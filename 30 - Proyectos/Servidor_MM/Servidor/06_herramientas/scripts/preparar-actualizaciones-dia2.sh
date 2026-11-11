#!/usr/bin/env bash

# Actualiza indices APT y simula una actualizacion sin instalar paquetes.

set -Eeuo pipefail

if [[ ${EUID} -ne 0 ]]; then
    printf 'ERROR: ejecutar con sudo: sudo bash %s\n' "$0" >&2
    exit 1
fi

log_file=/home/vicente/apt-simulacion-2026-10-02.txt
install -o vicente -g vicente -m 0600 /dev/null "${log_file}"
exec > >(tee "${log_file}") 2>&1
trap 'chown vicente:vicente "${log_file}"; chmod 0600 "${log_file}"' EXIT

printf '===== CAPTURA =====\n'
date --iso-8601=seconds
printf 'hostname=%s\n' "$(hostname)"

printf '\n===== APT UPDATE =====\n'
apt-get update

printf '\n===== SIMULACION APT UPGRADE =====\n'
apt-get --simulate upgrade

printf '\n===== LISTA ACTUALIZABLE =====\n'
apt list --upgradable 2>/dev/null

printf '\n===== REINICIO PENDIENTE ANTES DE INSTALAR =====\n'
if [[ -e /var/run/reboot-required ]]; then
    cat /var/run/reboot-required
    [[ -r /var/run/reboot-required.pkgs ]] && cat /var/run/reboot-required.pkgs
else
    printf 'No hay reinicio pendiente.\n'
fi

printf '\n===== FIN =====\n'
date --iso-8601=seconds
printf 'No se ha instalado, eliminado ni actualizado ningun paquete.\n'
