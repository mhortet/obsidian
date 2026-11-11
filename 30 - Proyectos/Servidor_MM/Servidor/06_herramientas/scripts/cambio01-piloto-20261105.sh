#!/usr/bin/env bash
# Cambio autorizado: configurar y validar, sin arrancar MySQL.
set -Eeuo pipefail
export LC_ALL=C
umask 077
target=/etc/mysql/mysql.conf.d/90-qontrolmed-piloto.cnf
base=/root/srv-mm-piloto-20261105
installed=0
tempfile=''
check_stopped() {
  [ "$(systemctl is-active mysql || true)" = inactive ] &&
  [ "$(systemctl is-enabled mysql || true)" = disabled ] &&
  ! pgrep -x mysqld >/dev/null &&
  ! ss -H -ltn | awk '{print $4}' | grep -Eq ':(3306|33060)$'
}
cleanup() {
  result=$?
  trap - EXIT
  if [ "$result" -ne 0 ] && [ "$installed" -eq 1 ]; then
    if [ -f "$target" ] && cmp -s "$target" "$run/expected.cnf"; then
      mv -T -- "$target" "$run/reverted.cnf"
      echo CONFIGURACION_NUEVA_RETIRADA
      if mysqld --user=mysql --validate-config >"$run/rollback-validation.log" 2>&1; then
        echo CONFIGURACION_ANTERIOR_VALIDADA
      else
        echo ERROR_VALIDACION_ANTERIOR_REQUIERE_REVISION
      fi
    else
      echo ERROR_ARCHIVO_CAMBIADO_REQUIERE_REVISION_MANUAL
    fi
  fi
  if [ -n "$tempfile" ] && [ -f "$tempfile" ]; then rm -- "$tempfile"; fi
  if [ "$result" -ne 0 ]; then echo CAMBIO01_NO_COMPLETADO; fi
  exit "$result"
}
trap cleanup EXIT
[ "$(id -u)" -eq 0 ] || { echo ERROR_REQUIERE_SUDO; exit 1; }
[ "$(hostname)" = srv-mm-01 ] || { echo ERROR_HOST; exit 1; }
check_stopped || { echo ERROR_ESTADO_INICIAL; exit 1; }
[ ! -e "$target" ] && [ ! -L "$target" ] || { echo ERROR_ARCHIVO_YA_EXISTE; exit 1; }
[ ! -L "$base" ] || { echo ERROR_RUTA_BASE; exit 1; }
install -d -o root -g root -m 0700 "$base"
run=$(mktemp -d "$base/cambio01.XXXXXXXX")
echo "REGISTRO_ROOT=$run"
date -Is
find /etc/mysql -type f -name '*.cnf' -exec sha256sum {} + >"$run/baseline.sha256"
if ! mysqld --user=mysql --validate-config >"$run/before-validation.log" 2>&1; then
  echo ERROR_CONFIGURACION_PREVIA; exit 1
fi
echo VALIDACION_PREVIA_OK
printf '[mysqld]\nbind-address=127.0.0.1\nmysqlx=OFF\nrequire_secure_transport=ON\n' >"$run/expected.cnf"
tempfile=$(mktemp /etc/mysql/mysql.conf.d/.piloto-XXXXXXXX)
install -o root -g root -m 0644 "$run/expected.cnf" "$tempfile"
# Hard link publica el archivo completo sin sobrescribir un destino existente.
ln -- "$tempfile" "$target"
installed=1
rm -- "$tempfile"
tempfile=''
if ! mysqld --user=mysql --validate-config >"$run/after-validation.log" 2>&1; then
  echo ERROR_VALIDACION_NUEVA; exit 1
fi
mysqld --user=mysql --verbose --help >"$run/effective-help.log" 2>&1
awk '$1=="bind-address" || $1=="mysqlx" || $1=="require-secure-transport" {print $1, $2}' "$run/effective-help.log" >"$run/effective-selected.txt"
cat "$run/effective-selected.txt"
grep -qx 'bind-address 127.0.0.1' "$run/effective-selected.txt"
grep -qx 'mysqlx OFF' "$run/effective-selected.txt"
grep -Eq '^require-secure-transport (TRUE|ON|1)$' "$run/effective-selected.txt"
[ "$(stat -c '%U:%G %a' "$target")" = 'root:root 644' ]
sha256sum -c "$run/baseline.sha256" >"$run/baseline-check.log" 2>&1
check_stopped
sha256sum "$target"
stat -c '%U:%G %a %n' "$target"
echo MYSQL_INACTIVE_DISABLED_SIN_ESCUCHAS
echo CAMBIO01_COMPLETADO
