#!/usr/bin/env bash
set -Eeuo pipefail
export LC_ALL=C

umask 077
readonly PHASE="${1:-}"
readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly WORK_ROOT="/root/srv-mm-preparacion-20261106"
readonly BACKUP_ROOT="${WORK_ROOT}/backups"
readonly LOG="/home/vicente/APLICACION-BLOQUE-DOMESTICO-2026-11-06.txt"
readonly ENV_SOURCE="${SCRIPT_DIR}/sftpgo-loopback-piloto.env.example"
readonly CF_SOURCE="${SCRIPT_DIR}/cloudflared-documentos.invalid.yml"
readonly HARDENING_SOURCE="${SCRIPT_DIR}/srv-mm-sftpgo-hardening.conf.example"

if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: ejecutar con sudo" >&2
  exit 1
fi
if [[ "${PHASE}" != "packages" && "${PHASE}" != "configure" ]]; then
  echo "Uso: sudo bash $0 packages|configure" >&2
  exit 2
fi

mkdir -p "${WORK_ROOT}" "${BACKUP_ROOT}"
chmod 0700 "${WORK_ROOT}" "${BACKUP_ROOT}"
exec > >(tee -a "${LOG}") 2>&1
trap 'chown vicente:vicente "${LOG}" 2>/dev/null || true' EXIT

cleanup_on_error() {
  local rc=$?
  set +e
  echo "APPLY_ABORT phase=${PHASE} rc=${rc}"
  if [[ "${PHASE}" == "configure" ]]; then
    systemctl stop sftpgo.service 2>/dev/null || true
  fi
  exit "${rc}"
}
trap cleanup_on_error ERR

fail() {
  echo "APPLY_ERROR=$*"
  exit 1
}

state() {
  systemctl "$1" "$2" 2>/dev/null || true
}

assert_safe_base() {
  [[ "$(hostname)" == "srv-mm-01" ]] || fail "hostname inesperado"
  [[ "$(state is-active mysql)" == "inactive" ]] || fail "MySQL no está inactive"
  [[ "$(state is-enabled mysql)" == "disabled" ]] || fail "MySQL no está disabled"
  pgrep -x mysqld >/dev/null && fail "existe proceso mysqld"
  ss -H -lnt | awk '$4 ~ /:(3306|33060)$/ {found=1} END {exit !found}' && fail "MySQL tiene escucha"
  [[ -z "$(systemctl --failed --no-legend --plain)" ]] || fail "hay unidades fallidas"
}

backup_if_present() {
  local path="$1"
  if [[ -e "${path}" || -L "${path}" ]]; then
    local safe_name
    safe_name="$(printf '%s' "${path#/}" | tr '/' '_')"
    cp -a -- "${path}" "${BACKUP_ROOT}/${safe_name}.before"
  fi
}

phase_packages() {
  assert_safe_base
  for path in \
    /usr/share/keyrings/sftpgo-archive-keyring.gpg \
    /usr/share/keyrings/cloudflare-main.gpg \
    /etc/apt/sources.list.d/sftpgo.list \
    /etc/apt/sources.list.d/cloudflared.list; do
    [[ ! -e "${path}" ]] || fail "ruta APT ya existente: ${path}"
  done
  for pkg in sftpgo cloudflared restic acl; do
    dpkg-query -W "${pkg}" >/dev/null 2>&1 && fail "${pkg} ya estaba instalado"
  done

  local tmpdir
  tmpdir="$(mktemp -d)"

  curl -fsSL --proto '=https' --tlsv1.2 https://oss.sftpgo.com/apt/gpg.key -o "${tmpdir}/sftpgo.asc"
  gpg --batch --dearmor --output "${tmpdir}/sftpgo.gpg" "${tmpdir}/sftpgo.asc"
  curl -fsSL --proto '=https' --tlsv1.2 https://pkg.cloudflare.com/cloudflare-main.gpg -o "${tmpdir}/cloudflare.gpg"

  install -o root -g root -m 0644 "${tmpdir}/sftpgo.gpg" /usr/share/keyrings/sftpgo-archive-keyring.gpg
  install -o root -g root -m 0644 "${tmpdir}/cloudflare.gpg" /usr/share/keyrings/cloudflare-main.gpg
  [[ "${tmpdir}" == /tmp/tmp.* ]] || fail "ruta temporal inesperada"
  rm -rf -- "${tmpdir}"
  printf '%s\n' 'deb [signed-by=/usr/share/keyrings/sftpgo-archive-keyring.gpg] https://oss.sftpgo.com/apt noble main' > /etc/apt/sources.list.d/sftpgo.list
  printf '%s\n' 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' > /etc/apt/sources.list.d/cloudflared.list
  chmod 0644 /etc/apt/sources.list.d/sftpgo.list /etc/apt/sources.list.d/cloudflared.list

  echo "KEYS_BEGIN"
  gpg --show-keys --with-fingerprint /usr/share/keyrings/sftpgo-archive-keyring.gpg
  gpg --show-keys --with-fingerprint /usr/share/keyrings/cloudflare-main.gpg
  sha256sum /usr/share/keyrings/sftpgo-archive-keyring.gpg /usr/share/keyrings/cloudflare-main.gpg
  echo "KEYS_END"

  apt-get update
  apt-get --simulate install --no-install-recommends sftpgo cloudflared restic acl | tee "${WORK_ROOT}/apt-simulate.txt"
  grep -Eq '^Remv ' "${WORK_ROOT}/apt-simulate.txt" && fail "APT propone retiradas"
  grep -Eiq '^Inst (linux-(image|headers)|openssh|mysql|ufw|netplan|network-manager)' "${WORK_ROOT}/apt-simulate.txt" && fail "APT propone cambio crítico"

  systemctl mask sftpgo.service cloudflared.service
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends sftpgo cloudflared restic acl
  systemctl stop sftpgo.service cloudflared.service 2>/dev/null || true

  dpkg-query -W -f='${Package} ${Version} ${Status}\n' sftpgo cloudflared restic acl
  sftpgo_version="$(dpkg-query -W -f='${Version}' sftpgo)"
  dpkg --compare-versions "${sftpgo_version}" ge 2.7.6 || fail "SFTPGo anterior a 2.7.6"
  apt-cache policy sftpgo cloudflared restic
  assert_safe_base
  ss -lntup
  echo "PACKAGES_PHASE_RESULT=OK"
}

phase_configure() {
  assert_safe_base
  for pkg in sftpgo cloudflared restic acl; do
    dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | grep -qx 'install ok installed' || fail "falta ${pkg}"
  done
  for file in "${ENV_SOURCE}" "${CF_SOURCE}" "${HARDENING_SOURCE}"; do
    [[ -f "${file}" ]] || fail "falta artefacto ${file}"
  done
  [[ "$(state is-active sftpgo)" != "active" ]] || fail "SFTPGo ya estaba activo"

  echo "PACKAGE_UNIT_BEGIN"
  systemctl cat sftpgo.service || true
  systemctl cat cloudflared.service || true
  echo "PACKAGE_UNIT_END"
  backup_if_present /etc/sftpgo/sftpgo.json
  backup_if_present /etc/systemd/system/sftpgo.service.d
  backup_if_present /etc/cloudflared

  getent group sftpgo >/dev/null || fail "el paquete no creó grupo sftpgo"
  getent passwd sftpgo >/dev/null || fail "el paquete no creó cuenta sftpgo"

  [[ "$(stat -c '%U:%G %a' /srv/compartido)" == "root:root 750" ]] || fail "permisos inesperados en /srv/compartido"
  command -v setfacl >/dev/null || fail "setfacl no disponible"
  getfacl -p /srv/compartido > "${BACKUP_ROOT}/srv_compartido.acl.before"
  setfacl -m u:sftpgo:--x /srv/compartido
  getfacl -cp /srv/compartido | grep -qx 'user:sftpgo:--x' || fail "ACL de tránsito no aplicada"
  runuser -u sftpgo -- test -x /srv/compartido || fail "sftpgo no puede atravesar /srv/compartido"
  if runuser -u sftpgo -- ls /srv/compartido >/dev/null 2>&1; then
    fail "sftpgo puede listar /srv/compartido"
  fi

  install -d -o root -g sftpgo -m 0750 /srv/compartido/repositorio
  install -d -o sftpgo -g sftpgo -m 0750 /srv/compartido/repositorio/piloto-20261106
  install -d -o sftpgo -g sftpgo -m 0750 /srv/compartido/repositorio/piloto-20261106/usuarios
  install -d -o sftpgo -g sftpgo -m 0750 /srv/compartido/repositorio/piloto-20261106/datos-ficticios
  printf '%s\n' 'ARCHIVO FICTICIO DEL PILOTO. NO CONTIENE DATOS DEL CLIENTE.' > "${WORK_ROOT}/LEEME-PILOTO.txt"
  install -o sftpgo -g sftpgo -m 0640 "${WORK_ROOT}/LEEME-PILOTO.txt" /srv/compartido/repositorio/piloto-20261106/datos-ficticios/LEEME-PILOTO.txt

  install -d -o root -g sftpgo -m 0750 /etc/sftpgo/secrets
  if [[ ! -f /etc/sftpgo/secrets/master.key ]]; then
    openssl rand -base64 48 > "${WORK_ROOT}/master.key.new"
    install -o root -g sftpgo -m 0640 "${WORK_ROOT}/master.key.new" /etc/sftpgo/secrets/master.key
    rm -f -- "${WORK_ROOT}/master.key.new"
  fi
  install -o root -g sftpgo -m 0640 "${ENV_SOURCE}" /etc/sftpgo/srv-mm-piloto.env
  install -d -o root -g root -m 0755 /etc/cloudflared
  install -o root -g root -m 0644 "${CF_SOURCE}" /etc/cloudflared/config.documentos.invalid.yml
  install -d -o root -g root -m 0755 /etc/systemd/system/sftpgo.service.d
  install -o root -g root -m 0644 "${HARDENING_SOURCE}" /etc/systemd/system/sftpgo.service.d/10-srv-mm-hardening.conf

  systemctl unmask sftpgo.service
  systemctl daemon-reload
  systemd-analyze verify sftpgo.service
  systemctl disable sftpgo.service 2>/dev/null || true
  systemctl start sftpgo.service
  sleep 3
  [[ "$(state is-active sftpgo)" == "active" ]] || {
    journalctl -u sftpgo.service --no-pager -n 100
    fail "SFTPGo no arrancó"
  }

  echo "SFTPGO_LISTEN_BEGIN"
  ss -lntup
  echo "SFTPGO_LISTEN_END"
  mapfile -t sftpgo_sockets < <(ss -H -lntp | awk '/sftpgo/ {print $4}' | sort -u)
  [[ "${#sftpgo_sockets[@]}" -eq 2 ]] || fail "número inesperado de sockets SFTPGo"
  printf '%s\n' "${sftpgo_sockets[@]}" | grep -qx '127.0.0.1:18080' || fail "falta binding cliente loopback"
  printf '%s\n' "${sftpgo_sockets[@]}" | grep -qx '127.0.0.1:18081' || fail "falta binding admin loopback"
  ss -H -lnt | awk '$4 ~ /:(2022|21|990|8080|3306|33060)$/ {found=1} END {exit !found}' && fail "puerto prohibido activo"

  curl -fsS -o /dev/null http://127.0.0.1:18080/web/client
  curl -fsS -o /dev/null http://127.0.0.1:18081/web/admin

  cloudflared tunnel --config /etc/cloudflared/config.documentos.invalid.yml ingress validate
  cloudflared tunnel --config /etc/cloudflared/config.documentos.invalid.yml ingress rule https://documentos.invalid
  cloudflared tunnel --config /etc/cloudflared/config.documentos.invalid.yml ingress rule https://no-coincide.invalid
  systemctl mask cloudflared.service
  [[ "$(state is-active cloudflared)" != "active" ]] || fail "cloudflared está activo"

  assert_safe_base
  echo "CONFIGURE_PHASE_RESULT=OK"
  echo "SFTPGO_TEMPORARILY_ACTIVE_FOR_LOCAL_SETUP=true"
}

echo "APPLY_START phase=${PHASE} time=$(date --iso-8601=seconds)"
if [[ "${PHASE}" == "packages" ]]; then
  phase_packages
else
  phase_configure
fi
echo "APPLY_END phase=${PHASE} time=$(date --iso-8601=seconds)"

