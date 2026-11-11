#!/usr/bin/env bash
set -Eeuo pipefail
export LC_ALL=C

umask 077
readonly OUT="${1:-/home/vicente/ACEPTACION-BLOQUE-DOMESTICO-2026-11-06.txt}"
readonly WORK_ROOT="/root/srv-mm-preparacion-20261106"
readonly RESTIC_REPO="${WORK_ROOT}/restic-ensayo"
readonly SECRET_DIR="${WORK_ROOT}/secrets"
readonly PASSWORD_FILE="${SECRET_DIR}/restic-password"
readonly SOURCE_REPO="/srv/compartido/repositorio/piloto-20261106"

if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: ejecutar con sudo" >&2
  exit 1
fi
exec > >(tee "${OUT}") 2>&1
trap 'chown vicente:vicente "${OUT}" 2>/dev/null || true' EXIT

fail() {
  echo "ACCEPTANCE_ERROR=$*"
  exit 1
}

state() {
  systemctl "$1" "$2" 2>/dev/null || true
}

assert_mysql_safe() {
  [[ "$(state is-active mysql)" == "inactive" ]] || fail "MySQL no está inactive"
  [[ "$(state is-enabled mysql)" == "disabled" ]] || fail "MySQL no está disabled"
  if pgrep -x mysqld >/dev/null; then
    fail "existe mysqld"
  fi
  if ss -H -lnt | awk '$4 ~ /:(3306|33060)$/ {found=1} END {exit !found}'; then
    fail "MySQL escucha"
  fi
  return 0
}

echo "ACCEPTANCE_START=$(date --iso-8601=seconds)"
assert_mysql_safe
[[ -z "$(systemctl --failed --no-legend --plain)" ]] || fail "hay unidades fallidas"
[[ "$(state is-active sftpgo)" == "active" ]] || fail "SFTPGo no está activo"
[[ "$(state is-active cloudflared)" != "active" ]] || fail "cloudflared está activo"
[[ "$(stat -c '%U:%G %a' /srv/compartido)" == "root:root 750" ]] || fail "permisos inesperados en /srv/compartido"
getfacl -cp /srv/compartido | grep -qx 'user:sftpgo:--x' || fail "falta ACL mínima de tránsito"
runuser -u sftpgo -- test -x /srv/compartido || fail "sftpgo no puede atravesar /srv/compartido"
if runuser -u sftpgo -- ls /srv/compartido >/dev/null 2>&1; then
  fail "sftpgo puede listar /srv/compartido"
fi

mapfile -t sftpgo_sockets < <(ss -H -lntp | awk '/sftpgo/ {print $4}' | sort -u)
[[ "${#sftpgo_sockets[@]}" -eq 2 ]] || fail "sockets SFTPGo inesperados"
printf '%s\n' "${sftpgo_sockets[@]}" | grep -qx '127.0.0.1:18080' || fail "falta 18080 loopback"
printf '%s\n' "${sftpgo_sockets[@]}" | grep -qx '127.0.0.1:18081' || fail "falta 18081 loopback"
ss -H -lnt | awk '$4 ~ /:(2022|21|990|8080|3306|33060)$/ {found=1} END {exit !found}' && fail "puerto prohibido activo"

echo "HTTP_BEGIN"
curl -sS -o /dev/null -w 'CLIENT_STATUS=%{http_code}\n' http://127.0.0.1:18080/web/client
curl -sS -o /dev/null -w 'ADMIN_STATUS=%{http_code}\n' http://127.0.0.1:18081/web/admin
curl -sS -o /dev/null -w 'ADMIN_ON_CLIENT_STATUS=%{http_code}\n' http://127.0.0.1:18080/web/admin
curl -sS -o /dev/null -w 'CLIENT_ON_ADMIN_STATUS=%{http_code}\n' http://127.0.0.1:18081/web/client
echo "HTTP_END"

cloudflared tunnel --config /etc/cloudflared/config.documentos.invalid.yml ingress validate
cloudflared tunnel --config /etc/cloudflared/config.documentos.invalid.yml ingress rule https://documentos.invalid
cloudflared tunnel --config /etc/cloudflared/config.documentos.invalid.yml ingress rule https://no-coincide.invalid

install -d -o root -g root -m 0700 "${SECRET_DIR}"
if [[ ! -f "${PASSWORD_FILE}" ]]; then
  openssl rand -base64 48 > "${PASSWORD_FILE}"
  chmod 0600 "${PASSWORD_FILE}"
fi
if [[ ! -d "${RESTIC_REPO}/data" ]]; then
  RESTIC_PASSWORD_FILE="${PASSWORD_FILE}" restic -r "${RESTIC_REPO}" init
fi

echo "Stopping SFTPGo for consistent backup"
systemctl stop sftpgo.service
[[ "$(state is-active sftpgo)" != "active" ]] || fail "SFTPGo no se detuvo"

manifest_source="${WORK_ROOT}/manifest-source.sha256"
(cd "${SOURCE_REPO}" && find . -type f -print0 | sort -z | xargs -0 -r sha256sum) > "${manifest_source}"

RESTIC_PASSWORD_FILE="${PASSWORD_FILE}" restic -r "${RESTIC_REPO}" backup \
  "${SOURCE_REPO}" /var/lib/sftpgo /etc/sftpgo
RESTIC_PASSWORD_FILE="${PASSWORD_FILE}" restic -r "${RESTIC_REPO}" check

restore_target="${WORK_ROOT}/restore-$(date +%Y%m%dT%H%M%S)"
[[ ! -e "${restore_target}" ]] || fail "destino de restauración existente"
RESTIC_PASSWORD_FILE="${PASSWORD_FILE}" restic -r "${RESTIC_REPO}" restore latest --target "${restore_target}"

restored_repo="${restore_target}${SOURCE_REPO}"
[[ -d "${restored_repo}" ]] || fail "falta repositorio restaurado"
manifest_restored="${WORK_ROOT}/manifest-restored.sha256"
(cd "${restored_repo}" && find . -type f -print0 | sort -z | xargs -0 -r sha256sum) > "${manifest_restored}"
diff -u "${manifest_source}" "${manifest_restored}"

restored_db="${restore_target}/var/lib/sftpgo/sftpgo.db"
[[ -f "${restored_db}" ]] || fail "falta SQLite restaurada"
python3 -c 'import sqlite3,sys; c=sqlite3.connect(sys.argv[1]); r=c.execute("PRAGMA integrity_check").fetchone()[0]; print("SQLITE_INTEGRITY="+r); raise SystemExit(0 if r=="ok" else 1)' "${restored_db}"

RESTIC_PASSWORD_FILE="${PASSWORD_FILE}" restic -r "${RESTIC_REPO}" forget --keep-last 1 --dry-run

systemctl disable sftpgo.service 2>/dev/null || true
systemctl stop sftpgo.service
systemctl mask cloudflared.service
assert_mysql_safe
[[ -z "$(systemctl --failed --no-legend --plain)" ]] || fail "hay unidades fallidas al cierre"
ss -H -lnt | awk '$4 ~ /:(18080|18081|2022|21|990|8080|3306|33060)$/ {found=1} END {exit !found}' && fail "quedó una escucha del bloque"

echo "PACKAGES_BEGIN"
dpkg-query -W -f='${Package} ${Version} ${Status}\n' sftpgo cloudflared restic acl
echo "PACKAGES_END"
echo "UFW_BEGIN"
ufw status verbose
ufw status numbered
echo "UFW_END"
echo "ACCEPTANCE_RESULT=OK"
echo "RESTIC_CLASSIFICATION=local-test-not-independent-not-3-2-1"
echo "ACCEPTANCE_END=$(date --iso-8601=seconds)"

