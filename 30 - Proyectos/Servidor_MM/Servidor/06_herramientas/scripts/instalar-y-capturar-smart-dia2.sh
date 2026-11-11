#!/usr/bin/env bash

# Instala smartmontools y captura SMART sin lanzar autotests ni escribir en discos.

set -Eeuo pipefail

if [[ ${EUID} -ne 0 ]]; then
    printf 'ERROR: ejecutar con sudo: sudo bash %s\n' "$0" >&2
    exit 1
fi

log_file=/home/vicente/smart-srv-mm-01-2026-10-02.txt
install -o vicente -g vicente -m 0600 /dev/null "${log_file}"
exec > >(tee "${log_file}") 2>&1
trap 'chown vicente:vicente "${log_file}"; chmod 0600 "${log_file}"' EXIT

printf '===== CAPTURA =====\n'
date --iso-8601=seconds
printf 'hostname=%s\n' "$(hostname)"

printf '\n===== SIMULACION =====\n'
simulation=$(LC_ALL=C apt-get --simulate install --no-install-recommends smartmontools)
printf '%s\n' "${simulation}"
if ! grep -Fq '0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.' <<< "${simulation}"; then
    printf 'ERROR: la simulacion ya no coincide con 0/1/0/0. No se instala nada.\n' >&2
    exit 1
fi

printf '\n===== INSTALACION =====\n'
LC_ALL=C apt-get -y install --no-install-recommends smartmontools

printf '\n===== VERSION Y SERVICIO =====\n'
smartctl --version
systemctl is-enabled smartmontools.service 2>&1 || true
systemctl is-active smartmontools.service 2>&1 || true
systemctl status smartmontools.service --no-pager -l 2>&1 | sed -n '1,22p' || true

printf '\n===== DISPOSITIVOS DETECTADOS =====\n'
smartctl --scan-open

for device in /dev/sda /dev/sdb; do
    printf '\n===== SMART %s =====\n' "${device}"
    set +e
    smartctl --xall "${device}"
    smart_rc=$?
    set -e
    printf 'smartctl_exit_code=%s\n' "${smart_rc}"
done

printf '\n===== FIN =====\n'
date --iso-8601=seconds
printf 'No se han lanzado autotests SMART ni comandos de escritura sobre los discos.\n'
