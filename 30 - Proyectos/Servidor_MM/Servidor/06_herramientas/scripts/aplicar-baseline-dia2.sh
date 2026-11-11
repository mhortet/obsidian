#!/usr/bin/env bash

# Primer bloque de endurecimiento de srv-mm-01.
# Ejecutar como root solo despues de revisar el contenido.

set -Eeuo pipefail

if [[ ${EUID} -ne 0 ]]; then
    printf 'ERROR: ejecutar con sudo: sudo bash %s\n' "$0" >&2
    exit 1
fi

backup_dir=/root/srv-mm-change-20261002-01
ssh_dropin=/etc/ssh/sshd_config.d/00-srv-mm-ssh-hardening.conf

if [[ -e ${backup_dir} ]]; then
    printf 'ERROR: ya existe %s; no se repetira el cambio.\n' "${backup_dir}" >&2
    exit 1
fi

install -d -m 0700 "${backup_dir}"
timedatectl show --property=Timezone --value > "${backup_dir}/timezone.before"
cp -a /etc/default/ufw "${backup_dir}/default-ufw.before"
cp -a /etc/ufw/ufw.conf "${backup_dir}/ufw.conf.before"
cp -a /etc/ufw/user.rules "${backup_dir}/user.rules.before"
cp -a /etc/ufw/user6.rules "${backup_dir}/user6.rules.before"
cp -a "${ssh_dropin}" "${backup_dir}/00-srv-mm-ssh-hardening.conf.before"
ufw status verbose > "${backup_dir}/ufw-status.before.txt"
sshd -T > "${backup_dir}/sshd-effective.before.txt"

cat > "${backup_dir}/rollback.sh" <<'ROLLBACK'
#!/usr/bin/env bash
set -Eeuo pipefail

backup_dir=/root/srv-mm-change-20261002-01
ssh_dropin=/etc/ssh/sshd_config.d/00-srv-mm-ssh-hardening.conf

if [[ ${EUID} -ne 0 ]]; then
    printf 'ERROR: ejecutar como root.\n' >&2
    exit 1
fi

timedatectl set-timezone "$(cat "${backup_dir}/timezone.before")"
cp -a "${backup_dir}/default-ufw.before" /etc/default/ufw
cp -a "${backup_dir}/ufw.conf.before" /etc/ufw/ufw.conf
cp -a "${backup_dir}/user.rules.before" /etc/ufw/user.rules
cp -a "${backup_dir}/user6.rules.before" /etc/ufw/user6.rules
cp -a "${backup_dir}/00-srv-mm-ssh-hardening.conf.before" "${ssh_dropin}"
sshd -t
systemctl reload ssh.service
ufw --force disable
printf 'Reversion aplicada. Verificar hora, SSH y UFW.\n'
ROLLBACK
chmod 0700 "${backup_dir}/rollback.sh"

timedatectl set-timezone Europe/Madrid

cat > "${ssh_dropin}" <<'SSH_CONFIG'
# SSH baseline for srv-mm-01.
# Keep a tested administrative session open while applying changes.
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin no
PermitEmptyPasswords no
MaxAuthTries 3
X11Forwarding no
SSH_CONFIG
chmod 0644 "${ssh_dropin}"

if ! sshd -t; then
    cp -a "${backup_dir}/00-srv-mm-ssh-hardening.conf.before" "${ssh_dropin}"
    printf 'ERROR: configuracion SSH no valida; se restauro el archivo anterior.\n' >&2
    exit 1
fi

systemctl reload ssh.service

ufw default deny incoming
ufw default allow outgoing
ufw allow from 192.168.2.0/24 to any port 22 proto tcp comment 'SSH LAN preparacion'
ufw --force enable

printf '\n=== HORA ===\n'
timedatectl
printf '\n=== UFW ===\n'
ufw status verbose
printf '\n=== SSH EFECTIVO ===\n'
sshd -T | grep -E '^(passwordauthentication|kbdinteractiveauthentication|permitrootlogin|pubkeyauthentication|maxauthtries|x11forwarding) '
printf '\nCambio aplicado. Mantener esta sesion abierta hasta validar una conexion SSH nueva.\n'
