#!/usr/bin/env bash
# Arranque manual breve autorizado; no crea cuentas ni datos.
set -Eeuo pipefail
export LC_ALL=C
umask 077
started=0
run=''
check_stopped() {
  [ "$(systemctl is-active mysql || true)" = inactive ] &&
  [ "$(systemctl is-enabled mysql || true)" = disabled ] &&
  ! pgrep -x mysqld >/dev/null &&
  ! ss -H -ltn | awk '{print $4}' | grep -Eq ':(3306|33060)$'
}
cleanup() {
  result=$?
  trap - EXIT INT TERM HUP
  if [ "$started" -eq 1 ]; then
    echo PARANDO_MYSQL
    if ! timeout 120s systemctl stop mysql; then
      echo ERROR_PARADA_REQUIERE_INTERVENCION; exit 1
    fi
    if ! check_stopped; then
      echo ERROR_ESTADO_FINAL_REQUIERE_INTERVENCION; exit 1
    fi
    echo MYSQL_FINAL_INACTIVE_DISABLED_SIN_ESCUCHAS
  fi
  if [ "$result" -ne 0 ]; then echo CAMBIO02_NO_COMPLETADO; fi
  exit "$result"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP
[ "$(id -u)" -eq 0 ] || { echo ERROR_REQUIERE_SUDO; exit 1; }
[ "$(hostname)" = srv-mm-01 ] || { echo ERROR_HOST; exit 1; }
check_stopped || { echo ERROR_ESTADO_INICIAL; exit 1; }
target=/etc/mysql/mysql.conf.d/90-qontrolmed-piloto.cnf
printf '94069a958ccf6f51fddcedc3e480028dc86e443709861fec996bd525f89b13c7  %s\n' "$target" | sha256sum -c -
[ "$(stat -c '%U:%G %a' "$target")" = 'root:root 644' ]
base=/root/srv-mm-piloto-20261105
[ ! -L "$base" ] || exit 1
install -d -o root -g root -m 0700 "$base"
run=$(mktemp -d "$base/cambio02.XXXXXXXX")
echo "REGISTRO_ROOT=$run"
date -Is
if ! mysqld --user=mysql --validate-config >"$run/validation.log" 2>&1; then
  echo ERROR_VALIDACION; exit 1
fi
echo VALIDACION_OK
for cert in ca.pem server-cert.pem; do
  echo "CERTIFICADO_PUBLICO=$cert"
  openssl x509 -in "/var/lib/mysql/$cert" -noout -subject -issuer -dates
  openssl x509 -in "/var/lib/mysql/$cert" -noout -ext subjectAltName 2>&1
  openssl x509 -in "/var/lib/mysql/$cert" -checkend 0 -noout
done
openssl verify -CAfile /var/lib/mysql/ca.pem /var/lib/mysql/server-cert.pem
echo 'NOTA: la cadena y vigencia no demuestran identidad apta para el cliente.'
started=1
if ! timeout 90s systemctl start mysql >"$run/start.log" 2>&1; then
  echo ERROR_ARRANQUE_VER_REGISTRO_ROOT; exit 1
fi
[ "$(systemctl is-active mysql)" = active ]
[ "$(systemctl is-enabled mysql || true)" = disabled ]
ss -H -ltn | awk '$4 ~ /:(3306|33060)$/ {print $4}' >"$run/mysql-listeners.txt"
cat "$run/mysql-listeners.txt"
[ "$(cat "$run/mysql-listeners.txt")" = '127.0.0.1:3306' ] || { echo ERROR_ESCUCHA; exit 1; }
client=(mysql --no-defaults --protocol=SOCKET --socket=/run/mysqld/mysqld.sock --user=root --connect-timeout=5 --batch)
timeout 20s "${client[@]}" -e "SELECT VERSION(), @@bind_address, @@require_secure_transport, @@tls_version; SHOW GLOBAL STATUS LIKE 'Ssl_server_not_after'; SHOW GLOBAL VARIABLES LIKE 'ssl_ca'; SHOW GLOBAL VARIABLES LIKE 'ssl_cert'; SHOW GLOBAL VARIABLES LIKE 'mysqlx_port'; SELECT PLUGIN_NAME, PLUGIN_STATUS FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME='mysqlx';" >"$run/runtime-selected.txt" 2>"$run/runtime-error.log"
cat "$run/runtime-selected.txt"
runtime_ok=$(timeout 15s "${client[@]}" --skip-column-names -e "SELECT IF(@@bind_address='127.0.0.1' AND @@require_secure_transport=1 AND (SELECT COUNT(*) FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME='mysqlx' AND PLUGIN_STATUS='ACTIVE')=0, 'RUNTIME_OK', 'RUNTIME_ERROR');")
[ "$runtime_ok" = RUNTIME_OK ] || { echo ERROR_PARAMETROS_RUNTIME; exit 1; }
echo RUNTIME_OK
set +e
timeout 15s mysql --no-defaults --protocol=TCP --host=127.0.0.1 --port=3306 --user=root --connect-timeout=5 --ssl-mode=DISABLED --batch -e 'SELECT 1' >"$run/no-tls.log" 2>&1
tcp_result=$?
set -e
if [ "$tcp_result" -ne 0 ] && grep -qE 'ERROR 3159 .*insecure transport' "$run/no-tls.log"; then
  tls_result=RECHAZO_SIN_TLS_CONFIRMADO
else
  tls_result=PRUEBA_SIN_TLS_INCONCLUSA
  echo "CODIGO_CLIENTE_TCP=$tcp_result"
  # Solo el numero de error, no datos de autenticacion ni contenido arbitrario.
  grep -oE 'ERROR [0-9]+' "$run/no-tls.log" || true
fi
echo "$tls_result"
echo PARANDO_MYSQL
timeout 120s systemctl stop mysql
check_stopped
started=0
echo MYSQL_FINAL_INACTIVE_DISABLED_SIN_ESCUCHAS
if [ "$tls_result" = RECHAZO_SIN_TLS_CONFIRMADO ]; then
  echo CAMBIO02_COMPLETADO
else
  echo CAMBIO02_FINALIZADO_CON_PRUEBA_INCONCLUSA
fi
