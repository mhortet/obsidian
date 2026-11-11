#!/usr/bin/env bash
set -Eeuo pipefail
export LC_ALL=C

umask 077
readonly WORK_ROOT="/root/srv-mm-preparacion-20261106"
readonly QUARANTINE="${WORK_ROOT}/reversion-$(date +%Y%m%dT%H%M%S)"
readonly OUT="/home/vicente/REVERSION-BLOQUE-DOMESTICO-2026-11-06.txt"

if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: ejecutar con sudo" >&2
  exit 1
fi
install -d -o root -g root -m 0700 "${QUARANTINE}"
exec > >(tee "${OUT}") 2>&1
trap 'chown vicente:vicente "${OUT}" 2>/dev/null || true' EXIT

move_if_present() {
  local path="$1"
  if [[ -e "${path}" || -L "${path}" ]]; then
    local safe_name
    safe_name="$(printf '%s' "${path#/}" | tr '/' '_')"
    mv -- "${path}" "${QUARANTINE}/${safe_name}"
  fi
}

echo "REVERSAL_START=$(date --iso-8601=seconds)"
systemctl stop sftpgo.service cloudflared.service 2>/dev/null || true
systemctl disable sftpgo.service cloudflared.service 2>/dev/null || true

if command -v setfacl >/dev/null 2>&1; then
  setfacl -x u:sftpgo /srv/compartido 2>/dev/null || true
fi

move_if_present /etc/systemd/system/sftpgo.service.d/10-srv-mm-hardening.conf
move_if_present /etc/sftpgo/srv-mm-piloto.env
move_if_present /etc/cloudflared/config.documentos.invalid.yml
move_if_present /etc/apt/sources.list.d/sftpgo.list
move_if_present /etc/apt/sources.list.d/cloudflared.list

systemctl daemon-reload
systemctl mask sftpgo.service cloudflared.service 2>/dev/null || true

echo "DATA_PRESERVED=/srv/compartido/repositorio"
echo "SECRETS_PRESERVED=/etc/sftpgo/secrets"
echo "RESTIC_PRESERVED=${WORK_ROOT}/restic-ensayo"
echo "ACL_TRANSIT_REMOVED=/srv/compartido"
echo "QUARANTINE=${QUARANTINE}"

echo "MYSQL_ACTIVE=$(systemctl is-active mysql 2>/dev/null || true)"
echo "MYSQL_ENABLED=$(systemctl is-enabled mysql 2>/dev/null || true)"
pgrep -a mysqld || true
ss -lntup
systemctl --failed --no-legend --plain
ufw status verbose
echo "REVERSAL_END=$(date --iso-8601=seconds)"

