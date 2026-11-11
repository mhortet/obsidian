#!/usr/bin/env bash

# Auditoria inicial de solo lectura para srv-mm-01.
# No modifica paquetes, servicios, red, firewall, usuarios ni almacenamiento.

set -u

section() {
    printf '\n===== %s =====\n' "$1"
}

run_if_available() {
    local command_name="$1"
    shift
    if command -v "$command_name" >/dev/null 2>&1; then
        "$@"
    else
        printf '%s no esta instalado\n' "$command_name"
    fi
}

section "CAPTURA"
date --iso-8601=seconds
printf 'usuario_solicitante=%s\n' "${SUDO_USER:-$(id -un)}"

section "SISTEMA"
hostnamectl
printf '\n'
timedatectl
printf '\n'
uname -a
printf '\n'
cat /etc/os-release

section "RECURSOS"
lscpu
printf '\n'
free -h
printf '\n'
df -hT

section "ALMACENAMIENTO"
lsblk -o NAME,MODEL,SERIAL,SIZE,TYPE,FSTYPE,FSVER,MOUNTPOINTS
printf '\n'
findmnt -rno TARGET,SOURCE,FSTYPE,OPTIONS
printf '\n'
run_if_available pvs pvs
run_if_available vgs vgs
run_if_available lvs lvs -a -o lv_name,vg_name,lv_size,lv_attr,devices
printf '\n'
run_if_available cryptsetup cryptsetup status dm_crypt-0

section "RED"
ip -br link
printf '\n'
ip -br address
printf '\n'
ip route
printf '\n'
ss -lntup

section "SSH"
systemctl is-enabled ssh 2>&1 || true
systemctl is-active ssh 2>&1 || true
sshd -T | grep -E '^(passwordauthentication|kbdinteractiveauthentication|permitrootlogin|pubkeyauthentication|maxauthtries|x11forwarding) '
printf '\n'
ls -la /etc/ssh/sshd_config.d

section "FIREWALL Y PROTECCION"
run_if_available ufw ufw status verbose
printf '\n'
run_if_available aa-status aa-status

section "SERVICIOS"
systemctl --failed --no-pager
printf '\n'
systemctl is-enabled unattended-upgrades.service 2>&1 || true
systemctl is-active unattended-upgrades.service 2>&1 || true

section "ACTUALIZACIONES PENDIENTES"
apt list --upgradable 2>/dev/null

section "ERRORES DEL ARRANQUE ACTUAL"
journalctl -b -p err --no-pager

section "FIN"
date --iso-8601=seconds
