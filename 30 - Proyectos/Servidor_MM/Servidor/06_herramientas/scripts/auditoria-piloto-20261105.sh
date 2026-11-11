#!/usr/bin/env bash
# Auditoria de solo lectura; no inicia servicios ni imprime credenciales.
set -u
export LC_ALL=C
if [ "$(id -u)" -ne 0 ]; then echo 'ERROR: ejecutar mediante sudo'; exit 1; fi
printf '\n=== FECHA E IDENTIDAD ===\n'
date -Is
hostname
printf '\n=== VERSION MYSQL ===\n'
mysqld --version
printf '\n=== SERVICIOS ===\n'
for unit in mysql ufw ssh.socket; do
  printf '%s: ' "$unit"
  systemctl is-active "$unit" || true
  systemctl is-enabled "$unit" || true
done
printf '\n=== FIREWALL ===\n'
ufw status numbered
printf '\n=== ESCUCHAS TCP ===\n'
ss -ltnp
printf '\n=== OPCIONES MYSQL NO SECRETAS ===\n'
# Solo opciones de red/TLS; no se muestra el resto de los archivos.
grep -RInE --include='*.cnf' '^[[:space:]]*(bind[-_]address|port|mysqlx|mysqlx[-_]bind[-_]address|mysqlx[-_]port|require[-_]secure[-_]transport|ssl[-_]ca|ssl[-_]cert|ssl[-_]key|tls[-_]version|skip[-_]networking|skip[-_]name[-_]resolve)[[:space:]]*=' /etc/mysql 2>/dev/null || true
printf '\n=== METADATOS CERTIFICADOS (SIN CONTENIDO) ===\n'
find /var/lib/mysql -maxdepth 1 -type f \( -name '*ca*.pem' -o -name '*cert*.pem' -o -name '*key*.pem' \) -printf '%f %u:%g %m\n'
printf '\n=== MONTAJES ===\n'
findmnt /var/lib/mysql
findmnt /srv/compartido
printf '\n=== SALUD ===\n'
systemctl --failed --no-legend --plain
if test -e /var/run/reboot-required; then echo REBOOT_REQUIRED; else echo NO_REBOOT_REQUIRED; fi
printf '\nAUDITORIA_FINALIZADA\n'
