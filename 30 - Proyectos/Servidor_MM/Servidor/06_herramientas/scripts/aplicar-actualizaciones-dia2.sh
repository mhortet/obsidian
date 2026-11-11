#!/usr/bin/env bash

# Instala exclusivamente el conjunto de 15 paquetes aprobado el 2026-10-02.

set -Eeuo pipefail

if [[ ${EUID} -ne 0 ]]; then
    printf 'ERROR: ejecutar con sudo: sudo bash %s\n' "$0" >&2
    exit 1
fi

log_file=/home/vicente/apt-upgrade-2026-10-02.txt
expected_file=$(mktemp)
actual_file=$(mktemp)
simulation_file=$(mktemp)

cleanup() {
    rm -f "${expected_file}" "${actual_file}" "${simulation_file}"
    chown vicente:vicente "${log_file}" 2>/dev/null || true
    chmod 0600 "${log_file}" 2>/dev/null || true
}
trap cleanup EXIT

install -o vicente -g vicente -m 0600 /dev/null "${log_file}"
exec > >(tee "${log_file}") 2>&1

cat > "${expected_file}" <<'PACKAGES'
apparmor
dmidecode
krb5-locales
libapparmor1
libaudit-common
libaudit1
libgssapi-krb5-2
libk5crypto3
libkrb5-3
libkrb5support0
libnetplan1
netplan-generator
netplan.io
python3-netplan
sosreport
PACKAGES
LC_ALL=C sort -u -o "${expected_file}" "${expected_file}"

printf '===== CAPTURA PREVIA =====\n'
date --iso-8601=seconds
printf 'hostname=%s\n' "$(hostname)"

LC_ALL=C apt-get --simulate upgrade | tee "${simulation_file}"
awk '/^Inst / { print $2 }' "${simulation_file}" | LC_ALL=C sort -u > "${actual_file}"

if ! grep -Fq '15 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.' "${simulation_file}"; then
    printf 'ERROR: la simulacion ya no coincide con 15/0/0/0. No se instala nada.\n' >&2
    exit 1
fi

if ! diff -u "${expected_file}" "${actual_file}"; then
    printf 'ERROR: la lista de paquetes cambio respecto de la aprobada. No se instala nada.\n' >&2
    exit 1
fi

printf '\n===== INSTALACION APROBADA =====\n'
printf 'La lista coincide exactamente. APT solicitara confirmacion en esta consola.\n'
LC_ALL=C apt-get upgrade

printf '\n===== PAQUETES PENDIENTES =====\n'
apt list --upgradable 2>/dev/null

printf '\n===== REINICIO PENDIENTE =====\n'
if [[ -e /var/run/reboot-required ]]; then
    cat /var/run/reboot-required
    [[ -r /var/run/reboot-required.pkgs ]] && cat /var/run/reboot-required.pkgs
else
    printf 'No hay reinicio pendiente.\n'
fi

printf '\n===== SERVICIOS FALLIDOS =====\n'
systemctl --failed --no-pager

printf '\n===== HORA =====\n'
timedatectl

printf '\n===== RED =====\n'
ip -br address
ip route

printf '\n===== UFW =====\n'
ufw status verbose

printf '\n===== SSH EFECTIVO =====\n'
sshd -T | grep -E '^(passwordauthentication|kbdinteractiveauthentication|permitrootlogin|pubkeyauthentication|maxauthtries|x11forwarding) '

printf '\n===== ERRORES DEL ARRANQUE =====\n'
journalctl -b -p err --no-pager

printf '\n===== PAM LASTLOG =====\n'
grep -Rns 'pam_lastlog\.so' /etc/pam.d 2>/dev/null || true
find /usr/lib -type f -name 'pam_lastlog.so' -o -name 'pam_lastlog.so.*' 2>/dev/null

printf '\n===== FIN =====\n'
date --iso-8601=seconds
