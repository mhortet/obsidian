#!/usr/bin/env bash
set -Eeuo pipefail
export LC_ALL=C

umask 077
readonly OUT="${1:-/home/vicente/PREFLIGHT-BLOQUE-DOMESTICO-2026-11-06.txt}"
readonly EXPECTED_HOST="srv-mm-01"
readonly EXPECTED_CNF_HASH="4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927"
readonly CNF="/etc/mysql/mysql.conf.d/90-qontrolmed-piloto.cnf"

if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: ejecutar con sudo" >&2
  exit 1
fi

exec > >(tee "${OUT}") 2>&1
trap 'chown vicente:vicente "${OUT}" 2>/dev/null || true' EXIT

fail() {
  echo "PREFLIGHT_ERROR=$*"
  exit 1
}

state() {
  systemctl "$1" "$2" 2>/dev/null || true
}

echo "PREFLIGHT_BLOQUE_DOMESTICO_2026-11-06"
echo "TIME=$(date --iso-8601=seconds)"
echo "HOST=$(hostname)"
[[ "$(hostname)" == "${EXPECTED_HOST}" ]] || fail "hostname inesperado"

mysql_active="$(state is-active mysql)"
mysql_enabled="$(state is-enabled mysql)"
echo "MYSQL_ACTIVE=${mysql_active}"
echo "MYSQL_ENABLED=${mysql_enabled}"
[[ "${mysql_active}" == "inactive" ]] || fail "MySQL no está inactive"
[[ "${mysql_enabled}" == "disabled" ]] || fail "MySQL no está disabled"
pgrep -x mysqld >/dev/null && fail "existe proceso mysqld"
ss -H -lnt | awk '$4 ~ /:(3306|33060)$/ {found=1} END {exit !found}' && fail "MySQL tiene escucha"

failed_units="$(systemctl --failed --no-legend --plain)"
if [[ -n "${failed_units}" ]]; then
  echo "${failed_units}"
  fail "hay unidades fallidas"
fi
echo "FAILED_UNITS=0"

[[ -f "${CNF}" ]] || fail "falta configuración piloto MySQL"
cnf_hash="$(sha256sum "${CNF}" | awk '{print $1}')"
echo "CNF_SHA256=${cnf_hash}"
[[ "${cnf_hash}" == "${EXPECTED_CNF_HASH}" ]] || fail "hash MySQL inesperado"

echo "SSH_SERVICE_ACTIVE=$(state is-active ssh)"
echo "SSH_SOCKET_ACTIVE=$(state is-active ssh.socket)"
echo "SSH_SOCKET_ENABLED=$(state is-enabled ssh.socket)"
echo "UFW_SERVICE_ACTIVE=$(state is-active ufw)"
echo "UFW_SERVICE_ENABLED=$(state is-enabled ufw)"
[[ "$(state is-active ssh.socket)" == "active" ]] || fail "ssh.socket no está activo"
[[ "$(state is-active ufw)" == "active" ]] || fail "UFW no está activo"

echo "UFW_BEGIN"
ufw status verbose
ufw status numbered
echo "UFW_END"

echo "LISTEN_BEGIN"
ss -lntup
echo "LISTEN_END"
unexpected_tcp="$(ss -H -lnt | awk '$4 !~ /:(22|53)$/ {print}')"
[[ -z "${unexpected_tcp}" ]] || {
  echo "${unexpected_tcp}"
  fail "escucha TCP inesperada"
}

echo "FILESYSTEM_BEGIN"
df -hT -x tmpfs -x devtmpfs
findmnt -no TARGET,SOURCE,FSTYPE,OPTIONS --target /
findmnt -no TARGET,SOURCE,FSTYPE,OPTIONS --target /srv/compartido
stat -c '%A %a %U:%G %n' /srv /srv/compartido
echo "FILESYSTEM_END"

findmnt -no OPTIONS --target /srv/compartido | grep -qw nosuid || fail "falta nosuid"
findmnt -no OPTIONS --target /srv/compartido | grep -qw nodev || fail "falta nodev"
findmnt -no OPTIONS --target /srv/compartido | grep -qw noexec || fail "falta noexec"
[[ ! -e /srv/compartido/repositorio ]] || fail "la ruta documental ya existe antes del bloque"

echo "PACKAGES_BEGIN"
for pkg in sftpgo cloudflared restic; do
  if dpkg-query -W -f='${Status} ${Version}\n' "${pkg}" 2>/dev/null; then
    fail "${pkg} ya estaba instalado"
  else
    echo "${pkg}=not-installed"
  fi
done
apt-cache policy restic
echo "PACKAGES_END"

echo "NETWORK_PRECHECK_BEGIN"
getent ahosts oss.sftpgo.com | sed -n '1,4p'
getent ahosts pkg.cloudflare.com | sed -n '1,4p'
curl -fsSL --max-time 20 -o /dev/null -w 'SFTPGO_KEY_HTTP=%{http_code}\n' https://oss.sftpgo.com/apt/gpg.key
curl -fsSL --max-time 20 -o /dev/null -w 'CLOUDFLARE_KEY_HTTP=%{http_code}\n' https://pkg.cloudflare.com/cloudflare-main.gpg
echo "NETWORK_PRECHECK_END"

echo "PREFLIGHT_RESULT=OK"

