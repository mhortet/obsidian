#!/usr/bin/env bash
set -Eeuo pipefail
export LC_ALL=C

umask 077
readonly WORK_ROOT="/root/srv-mm-preparacion-20261106"
readonly OUT="/home/vicente/CORRECCION-ACL-SFTPGO-2026-11-06.txt"
readonly SHARED_ROOT="/srv/compartido"
readonly USER_HOME="/srv/compartido/repositorio/piloto-20261106/usuarios/documental-piloto"
readonly SEED_FILE="/srv/compartido/repositorio/piloto-20261106/datos-ficticios/LEEME-PILOTO.txt"

if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: ejecutar con sudo" >&2
  exit 1
fi

install -d -o root -g root -m 0700 "${WORK_ROOT}/backups"
exec > >(tee "${OUT}") 2>&1
trap 'chown vicente:vicente "${OUT}" 2>/dev/null || true' EXIT

fail() {
  echo "ACL_FIX_ERROR=$*"
  exit 1
}

state() {
  systemctl "$1" "$2" 2>/dev/null || true
}

echo "ACL_FIX_START=$(date --iso-8601=seconds)"
[[ "$(hostname)" == "srv-mm-01" ]] || fail "hostname inesperado"
[[ "$(state is-active mysql)" == "inactive" ]] || fail "MySQL no está inactive"
[[ "$(state is-enabled mysql)" == "disabled" ]] || fail "MySQL no está disabled"
[[ "$(state is-active sftpgo)" == "active" ]] || fail "SFTPGo no está activo"
[[ "$(stat -c '%U:%G %a' "${SHARED_ROOT}")" == "root:root 750" ]] || fail "estado inesperado en ${SHARED_ROOT}"

apt-get --simulate install --no-install-recommends acl | tee "${WORK_ROOT}/apt-simulate-acl.txt"
grep -Eq '^Remv ' "${WORK_ROOT}/apt-simulate-acl.txt" && fail "APT propone retiradas"
grep -Eiq '^Inst (linux-(image|headers)|openssh|mysql|ufw|netplan|network-manager|sftpgo|cloudflared|restic)' "${WORK_ROOT}/apt-simulate-acl.txt" && fail "APT propone cambio fuera de acl"
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends acl
dpkg-query -W -f='${Package} ${Version} ${Status}\n' acl

getfacl -p "${SHARED_ROOT}" > "${WORK_ROOT}/backups/srv_compartido.acl.before-correction"
setfacl -m u:sftpgo:--x "${SHARED_ROOT}"

echo "ACL_RESULT_BEGIN"
getfacl -cp "${SHARED_ROOT}"
echo "ACL_RESULT_END"
[[ "$(stat -c '%U:%G %a' "${SHARED_ROOT}")" == "root:root 750" ]] || fail "propiedad o modo alterado"
getfacl -cp "${SHARED_ROOT}" | grep -qx 'user:sftpgo:--x' || fail "ACL mínima no aplicada"
runuser -u sftpgo -- test -x "${SHARED_ROOT}" || fail "sftpgo no puede atravesar el montaje"
if runuser -u sftpgo -- ls "${SHARED_ROOT}" >/dev/null 2>&1; then
  fail "sftpgo puede listar el montaje"
fi

install -d -o sftpgo -g sftpgo -m 0750 "${USER_HOME}"
if [[ -f "${SEED_FILE}" ]]; then
  install -o sftpgo -g sftpgo -m 0640 "${SEED_FILE}" "${USER_HOME}/LEEME-PILOTO.txt"
fi
runuser -u sftpgo -- test -r "${USER_HOME}" || fail "sftpgo no puede leer el hogar ficticio"
runuser -u sftpgo -- test -w "${USER_HOME}" || fail "sftpgo no puede escribir el hogar ficticio"

ss -H -lntup
[[ "$(state is-active cloudflared)" != "active" ]] || fail "cloudflared está activo"
[[ "$(state is-active mysql)" == "inactive" ]] || fail "MySQL cambió de estado"
[[ -z "$(systemctl --failed --no-legend --plain)" ]] || fail "hay unidades fallidas"
echo "ACL_FIX_REVERSAL=setfacl -x u:sftpgo /srv/compartido"
echo "ACL_FIX_RESULT=OK"
echo "ACL_FIX_END=$(date --iso-8601=seconds)"
