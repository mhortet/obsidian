#!/usr/bin/env bash
set -euo pipefail

section() {
  printf '\n=== %s ===\n' "$1"
}

section "IDENTIDAD"
hostnamectl --static
date --iso-8601=seconds

section "SERVICIOS"
for unit in sftpgo cloudflared mysql ssh ufw; do
  printf '%s active=' "$unit"
  systemctl is-active "$unit" 2>/dev/null || true
  printf '%s enabled=' "$unit"
  systemctl is-enabled "$unit" 2>/dev/null || true
done
systemctl --failed --no-legend --plain || true

section "VERSIONES"
dpkg-query -W -f='${Package}\t${Version}\n' \
  sftpgo cloudflared restic acl mysql-server 2>/dev/null || true

section "LISTENERS"
ss -lntup

section "ALMACENAMIENTO"
findmnt -no TARGET,SOURCE,FSTYPE,OPTIONS /srv/compartido
df -hT /srv/compartido
namei -l /srv/compartido
getfacl -cp /srv/compartido
find /srv/compartido -maxdepth 3 -mindepth 1 \
  -printf '%M %u:%g %p\n' | sort

section "CONFIGURACION SFTPGO DEPURADA"
python3 - <<'PY'
import json

with open('/etc/sftpgo/sftpgo.json', encoding='utf-8') as stream:
    data = json.load(stream)

for section in ('httpd', 'sftpd', 'ftpd', 'webdavd'):
    value = data.get(section, {})
    result = {}
    for key in ('bindings', 'bind_port', 'bind_address'):
        if key in value:
            result[key] = value[key]
    if section == 'httpd' and isinstance(value.get('bindings'), list):
        allowed = ('address', 'port', 'enable_web_admin',
                   'enable_web_client', 'enable_https')
        result['bindings'] = [
            {key: binding.get(key) for key in allowed if key in binding}
            for binding in value['bindings']
        ]
    print(section, json.dumps(result, sort_keys=True))

provider = data.get('data_provider', {})
print('data_provider.driver', provider.get('driver'))
print('data_provider.name', provider.get('name'))
PY

section "OVERRIDES EFECTIVOS DEPURADOS"
grep -E '^SFTPGO_(HTTPD|SFTPD|FTPD|WEBDAVD)__(BINDINGS__.*__(ADDRESS|PORT|ENABLE_WEB_ADMIN|ENABLE_WEB_CLIENT)|BIND_PORT|BIND_ADDRESS)=' \
  /etc/sftpgo/srv-mm-piloto.env | sort || true

section "ARCHIVOS Y PERMISOS"
stat -c '%A %a %U:%G %n' \
  /etc/sftpgo \
  /etc/sftpgo/sftpgo.json \
  /etc/sftpgo/srv-mm-piloto.env \
  /var/lib/sftpgo \
  /var/lib/sftpgo/sftpgo.db 2>/dev/null || true
sha256sum \
  /etc/sftpgo/sftpgo.json \
  /etc/sftpgo/srv-mm-piloto.env \
  /var/lib/sftpgo/sftpgo.db 2>/dev/null || true

section "CUENTAS SFTPGO DEPURADAS"
python3 - <<'PY'
import sqlite3

db = sqlite3.connect('file:/var/lib/sftpgo/sftpgo.db?mode=ro', uri=True)
db.row_factory = sqlite3.Row
columns = {row['name'] for row in db.execute('PRAGMA table_info(users)')}
wanted = [name for name in (
    'username', 'status', 'home_dir', 'quota_size', 'quota_files',
    'permissions', 'filters', 'virtual_folders', 'last_login'
) if name in columns]
print('columns=' + ','.join(wanted))
for row in db.execute('SELECT ' + ','.join(wanted) + ' FROM users ORDER BY username'):
    safe = dict(row)
    for key in ('permissions', 'filters', 'virtual_folders'):
        if key in safe and isinstance(safe[key], bytes):
            safe[key] = safe[key].decode('utf-8', errors='replace')
        if key in safe and isinstance(safe[key], str):
            try:
                value = __import__('json').loads(safe[key])
                if key == 'filters' and isinstance(value, dict):
                    safe[key] = {
                        name: value.get(name) for name in (
                            'max_upload_file_size', 'totp_config',
                            'hooks', 'disable_fs_checks'
                        ) if name in value
                    }
                    if isinstance(safe[key].get('totp_config'), dict):
                        config = safe[key]['totp_config']
                        safe[key]['totp_config'] = {
                            'enabled': bool(config.get('enabled')),
                            'protocols': config.get('protocols', [])
                        }
                else:
                    safe[key] = value
            except Exception:
                safe[key] = '<presente-no-interpretado>'
    print(__import__('json').dumps(safe, ensure_ascii=False, sort_keys=True))

admin_columns = {row['name'] for row in db.execute('PRAGMA table_info(admins)')}
admin_wanted = [name for name in (
    'username', 'status', 'permissions', 'filters', 'last_login'
) if name in admin_columns]
print('admin_columns=' + ','.join(admin_wanted))
for row in db.execute(
    'SELECT ' + ','.join(admin_wanted) + ' FROM admins ORDER BY username'
):
    safe = dict(row)
    for key in ('permissions', 'filters'):
        if key in safe and isinstance(safe[key], bytes):
            safe[key] = safe[key].decode('utf-8', errors='replace')
        if key in safe and isinstance(safe[key], str):
            try:
                value = __import__('json').loads(safe[key])
                if key == 'filters' and isinstance(value, dict):
                    safe[key] = {
                        name: value.get(name) for name in (
                            'allow_list', 'totp_config', 'recovery_codes'
                        ) if name in value
                    }
                    if 'recovery_codes' in safe[key]:
                        safe[key]['recovery_codes'] = '<presentes-no-mostrados>'
                    if isinstance(safe[key].get('totp_config'), dict):
                        config = safe[key]['totp_config']
                        safe[key]['totp_config'] = {
                            'enabled': bool(config.get('enabled'))
                        }
                else:
                    safe[key] = value
            except Exception:
                safe[key] = '<presente-no-interpretado>'
    print(__import__('json').dumps(safe, ensure_ascii=False, sort_keys=True))
db.close()
PY

section "RESTIC ENSAYO LOCAL"
stat -c '%A %a %U:%G %n' \
  /root/srv-mm-preparacion-20261106/restic-ensayo \
  /root/srv-mm-preparacion-20261106/secrets/restic-password 2>/dev/null || true
find /root/srv-mm-preparacion-20261106 -maxdepth 2 -mindepth 1 \
  -printf '%M %u:%g %p\n' 2>/dev/null | sort || true

section "RESULTADO"
printf '%s\n' 'AUDITORIA_SFTPGO_SOLO_LECTURA=COMPLETADA'
