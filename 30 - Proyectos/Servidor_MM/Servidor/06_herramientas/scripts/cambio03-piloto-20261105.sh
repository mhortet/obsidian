#!/usr/bin/env bash
# Plan de certificado del piloto autorizado; no inicia MySQL.
set -Eeuo pipefail
export LC_ALL=C
umask 077
target=/etc/mysql/mysql.conf.d/90-qontrolmed-piloto.cnf
base=/root/srv-mm-piloto-20261105
ca=$base/ca-piloto
tls=/var/lib/mysql/piloto-tls
changed=0
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
  if [ "$result" -ne 0 ] && [ "$changed" -eq 1 ]; then
    if cmp -s "$target" "$run/expected.cnf"; then
      install -o root -g root -m 0644 "$run/original.cnf" "$target"
      echo CONFIGURACION_01_RESTAURADA
      if mysqld --user=mysql --validate-config >"$run/rollback.log" 2>&1; then
        echo REVERSION_VALIDADA
      else echo ERROR_REVERSION_REQUIERE_REVISION; fi
    else echo ERROR_ARCHIVO_MODIFICADO_REQUIERE_REVISION; fi
  fi
  if [ -n "$tempfile" ] && [ -f "$tempfile" ]; then rm -- "$tempfile"; fi
  if [ "$result" -ne 0 ]; then echo CAMBIO03_NO_COMPLETADO; fi
  exit "$result"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP
[ "$(id -u)" -eq 0 ] && [ "$(hostname)" = srv-mm-01 ]
check_stopped || { echo ERROR_ESTADO_INICIAL; exit 1; }
printf '94069a958ccf6f51fddcedc3e480028dc86e443709861fec996bd525f89b13c7  %s\n' "$target" | sha256sum -c -
for dest in "$ca" "$tls"; do
  [ ! -e "$dest" ] && [ ! -L "$dest" ] || { echo ERROR_DESTINO_EXISTENTE; exit 1; }
done
[ ! -L "$base" ]
install -d -o root -g root -m 0700 "$base"
run=$(mktemp -d "$base/cambio03.XXXXXXXX")
echo "REGISTRO_ROOT=$run"
date -Is
mysqld --user=mysql --validate-config >"$run/before-validation.log" 2>&1
cp -p -- "$target" "$run/original.cnf"
install -d -o root -g root -m 0700 "$ca"
install -d -o mysql -g mysql -m 0750 "$tls"
openssl req -x509 -newkey rsa:3072 -sha256 -nodes -days 365 \
  -subj '/CN=Servidor MM CA Piloto Domestico 20261105' \
  -addext 'basicConstraints=critical,CA:TRUE,pathlen:0' \
  -addext 'keyUsage=critical,keyCertSign,cRLSign' \
  -keyout "$ca/ca-key.pem" -out "$ca/ca.pem" >"$run/ca-generation.log" 2>&1
chmod 0600 "$ca/ca-key.pem"
openssl req -new -newkey rsa:3072 -nodes -sha256 \
  -subj '/CN=srv-mm-01' -keyout "$tls/server-key.pem" \
  -out "$run/server.csr" >"$run/server-generation.log" 2>&1
cat >"$run/server-ext.cnf" <<'EOF'
basicConstraints=critical,CA:FALSE
keyUsage=critical,digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
subjectAltName=DNS:srv-mm-01,IP:127.0.0.1,IP:192.168.1.31
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
EOF
openssl x509 -req -in "$run/server.csr" -CA "$ca/ca.pem" -CAkey "$ca/ca-key.pem" \
  -CAcreateserial -days 90 -sha256 -extfile "$run/server-ext.cnf" \
  -out "$tls/server-cert.pem" >"$run/signing.log" 2>&1
install -o mysql -g mysql -m 0644 "$ca/ca.pem" "$tls/ca.pem"
chown mysql:mysql "$tls/server-key.pem" "$tls/server-cert.pem"
chmod 0600 "$tls/server-key.pem"
chmod 0644 "$tls/server-cert.pem"
openssl verify -purpose sslserver -CAfile "$tls/ca.pem" -verify_hostname srv-mm-01 "$tls/server-cert.pem"
for ip in 127.0.0.1 192.168.1.31; do
  openssl verify -purpose sslserver -CAfile "$tls/ca.pem" -verify_ip "$ip" "$tls/server-cert.pem"
done
if openssl verify -CAfile "$tls/ca.pem" -verify_hostname nombre-incorrecto.invalid "$tls/server-cert.pem" >"$run/wrong-name.log" 2>&1; then
  echo ERROR_NOMBRE_INCORRECTO_ACEPTADO; exit 1
fi
grep -q 'hostname mismatch' "$run/wrong-name.log"
echo NOMBRE_INCORRECTO_RECHAZADO
openssl x509 -in "$tls/ca.pem" -noout -text >"$run/ca-public-details.txt"
grep -q 'CA:TRUE' "$run/ca-public-details.txt"
openssl x509 -in "$tls/server-cert.pem" -noout -text >"$run/server-public-details.txt"
grep -q 'CA:FALSE' "$run/server-public-details.txt"
grep -q 'TLS Web Server Authentication' "$run/server-public-details.txt"
for cert in "$tls/ca.pem" "$tls/server-cert.pem"; do
  openssl x509 -in "$cert" -checkend 0 -noout
  openssl x509 -in "$cert" -noout -subject -issuer -dates -fingerprint -sha256
  runuser -u mysql -- openssl x509 -in "$cert" -noout >/dev/null
done
openssl x509 -in "$tls/server-cert.pem" -noout -ext subjectAltName
runuser -u mysql -- test -r "$tls/server-key.pem"
cat "$run/original.cnf" >"$run/expected.cnf"
printf '\nssl-ca=%s/ca.pem\nssl-cert=%s/server-cert.pem\nssl-key=%s/server-key.pem\n' "$tls" "$tls" "$tls" >>"$run/expected.cnf"
tempfile=$(mktemp /etc/mysql/mysql.conf.d/.piloto-XXXXXXXX)
install -o root -g root -m 0644 "$run/expected.cnf" "$tempfile"
changed=1
mv -T -- "$tempfile" "$target"
tempfile=''
mysqld --user=mysql --validate-config >"$run/after-validation.log" 2>&1
mysqld --user=mysql --verbose --help >"$run/effective-help.log" 2>&1
awk '$1=="bind-address" || $1=="mysqlx" || $1=="require-secure-transport" || $1=="ssl-ca" || $1=="ssl-cert" || $1=="ssl-key" {print $1, $2}' "$run/effective-help.log" >"$run/effective-selected.txt"
grep -qx 'bind-address 127.0.0.1' "$run/effective-selected.txt"
grep -qx 'mysqlx OFF' "$run/effective-selected.txt"
grep -Eq '^require-secure-transport (TRUE|ON|1)$' "$run/effective-selected.txt"
grep -qx "ssl-ca $tls/ca.pem" "$run/effective-selected.txt"
grep -qx "ssl-cert $tls/server-cert.pem" "$run/effective-selected.txt"
grep -qx "ssl-key $tls/server-key.pem" "$run/effective-selected.txt"
cat "$run/effective-selected.txt"
check_stopped
stat -c '%U:%G %a %n' "$target" "$ca" "$ca/ca-key.pem" "$tls" "$tls/server-key.pem" "$tls/ca.pem" "$tls/server-cert.pem"
sha256sum "$target" "$tls/ca.pem" "$tls/server-cert.pem"
echo MYSQL_INACTIVE_DISABLED_SIN_ESCUCHAS
echo CAMBIO03_COMPLETADO
