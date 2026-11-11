"""Fase local del plan autorizado: secretos solo bajo /root, parada final."""
import datetime
import hashlib
import os
from pathlib import Path
import re
import secrets
import signal
import subprocess
import sys
import stat

BASE = Path('/root/srv-mm-piloto-20261105')
RUN = BASE / 'prueba-local'
TARGET = Path('/etc/mysql/mysql.conf.d/90-qontrolmed-piloto.cnf')
SCHEMAS = ['piloto_mm_' + name for name in ('gestion', 'quirofanos', 'preventivos')]
USER = 'mm_piloto_local'
SOCKET = '/run/mysqld/mysqld.sock'
ROOT = ['mysql', '--no-defaults', '--user=root', '--protocol=SOCKET', '--socket=' + SOCKET, '--batch', '--skip-column-names']
started = False
created_user = False
RESUME = sys.argv[1:] == ['--resume']


def run(args, sql=None, expected=0, timeout=30):
    result = subprocess.run(args, input=sql, text=True, capture_output=True, timeout=timeout)
    if result.returncode != expected:
        codes = re.findall(r'ERROR (\d+)', result.stderr)
        raise RuntimeError('Fallo en ' + Path(args[0]).name + '; codigos=' + ','.join(codes))
    return result.stdout.strip()


def root(sql):
    return run(ROOT, sql)


def stopped():
    inactive = subprocess.run(['systemctl', 'is-active', 'mysql'], capture_output=True, text=True).stdout.strip()
    disabled = subprocess.run(['systemctl', 'is-enabled', 'mysql'], capture_output=True, text=True).stdout.strip()
    listeners = run(['ss', '-H', '-ltn'])
    process = subprocess.run(['pgrep', '-x', 'mysqld'], capture_output=True)
    return inactive == 'inactive' and disabled == 'disabled' and process.returncode == 1 and not re.search(r':(?:3306|33060)\s', listeners)


def main():
    global started, created_user
    if os.geteuid() != 0 or run(['hostname']) != 'srv-mm-01':
        raise RuntimeError('Requiere sudo en srv-mm-01')
    if not stopped() or hashlib.sha256(TARGET.read_bytes()).hexdigest() != '4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927':
        raise RuntimeError('Estado o configuracion inicial inesperados')
    if sys.argv[1:] not in ([], ['--resume']):
        raise RuntimeError('Argumentos no reconocidos')
    if BASE.is_symlink() or RUN.is_symlink() or (RUN.exists() and not RESUME):
        raise RuntimeError('Destino existente: revisar, no sobrescribir')
    if not RESUME:
        RUN.mkdir(mode=0o700)
    else:
        options = RUN / 'client.cnf'
        if not RUN.is_dir() or options.is_symlink() or not options.is_file():
            raise RuntimeError('No existe una fase local reanudable')
        metadata = options.stat()
        if metadata.st_uid != 0 or stat.S_IMODE(metadata.st_mode) != 0o600:
            raise RuntimeError('Permisos inesperados en credencial local')
    print('REGISTRO_ROOT=' + str(RUN), flush=True)
    print(datetime.datetime.now().astimezone().isoformat(), flush=True)
    run(['mysqld', '--user=mysql', '--validate-config'])
    started = True
    run(['systemctl', 'start', 'mysql'], timeout=90)
    listeners = [line.split()[3] for line in run(['ss', '-H', '-ltn']).splitlines() if re.search(r':(?:3306|33060)$', line.split()[3])]
    if listeners != ['127.0.0.1:3306']:
        raise RuntimeError('Escucha inesperada')
    if root("SELECT @@bind_address='127.0.0.1' AND @@require_secure_transport=1;") != '1':
        raise RuntimeError('Parametros runtime incorrectos')
    if root("SHOW GLOBAL VARIABLES LIKE 'ssl_cert';").split('\t')[-1] != '/var/lib/mysql/piloto-tls/server-cert.pem':
        raise RuntimeError('Certificado runtime incorrecto')
    for name in [s.replace('piloto_mm_', 'piloto_mm_restore_') for s in SCHEMAS]:
        if root(f"SELECT COUNT(*) FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='{name}';") != '0':
            raise RuntimeError('Un esquema de destino ya existe')
    options = RUN / 'client.cnf'
    if RESUME:
        if root(f"SELECT COUNT(*) FROM mysql.user WHERE User='{USER}';") != '1' or root(
            f"SELECT CONCAT(ssl_type, ':', account_locked) FROM mysql.user WHERE User='{USER}' AND Host='127.0.0.1';"
        ) != 'ANY:Y':
            raise RuntimeError('La cuenta no coincide con el piloto bloqueado')
        for schema in SCHEMAS:
            if root(f"SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='{schema}';") != 'prueba_conexion':
                raise RuntimeError('Tablas inesperadas en el piloto')
            if root(f"SELECT COUNT(*) FROM `{schema}`.prueba_conexion;") != '1':
                raise RuntimeError('Datos del piloto inesperados')
        root(f"ALTER USER '{USER}'@'127.0.0.1' ACCOUNT UNLOCK;")
        created_user = True
        print('PILOTO_EXISTENTE_REANUDADO_SIN_RECREAR_DATOS', flush=True)
    else:
        for schema in SCHEMAS:
            if root(f"SELECT COUNT(*) FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='{schema}';") != '0':
                raise RuntimeError('Un esquema de destino ya existe')
        if root(f"SELECT COUNT(*) FROM mysql.user WHERE User='{USER}';") != '0':
            raise RuntimeError('La cuenta ya existe')
        password = secrets.token_hex(32)
        root(f"CREATE USER '{USER}'@'127.0.0.1' IDENTIFIED BY '{password}' REQUIRE SSL;")
        created_user = True
        options.write_text('[client]\nuser=' + USER + '\npassword=' + password + '\nhost=127.0.0.1\nport=3306\nprotocol=TCP\nssl-mode=VERIFY_IDENTITY\nssl-ca=/var/lib/mysql/piloto-tls/ca.pem\n', encoding='utf-8')
        os.chmod(options, 0o600)
    client = ['mysql', '--defaults-file=' + str(options), '--connect-timeout=5', '--batch', '--skip-column-names']
    for schema in SCHEMAS:
        if not RESUME:
            root(f"CREATE DATABASE `{schema}` CHARACTER SET utf8mb4; CREATE TABLE `{schema}`.prueba_conexion (id INT PRIMARY KEY, descripcion VARCHAR(100) NOT NULL); GRANT SELECT, INSERT, UPDATE, DELETE ON `{schema}`.* TO '{USER}'@'127.0.0.1';")
            run(client, f"INSERT INTO `{schema}`.prueba_conexion VALUES (1,'equipo ficticio piloto'); UPDATE `{schema}`.prueba_conexion SET descripcion='verificacion ficticia correcta' WHERE id=1;")
            run(client, f"INSERT INTO `{schema}`.prueba_conexion VALUES (2,'fila ficticia eliminable'); DELETE FROM `{schema}`.prueba_conexion WHERE id=2;")
        if run(client, f"SELECT COUNT(*) FROM `{schema}`.prueba_conexion WHERE descripcion='verificacion ficticia correcta';") != '1':
            raise RuntimeError('Verificacion DML incorrecta')
    cipher = run(client, "SHOW SESSION STATUS LIKE 'Ssl_cipher';")
    if not cipher.startswith('Ssl_cipher\t') or not cipher.split('\t')[-1]:
        raise RuntimeError('Sesion sin cifrado comprobado')
    print('SESION_TLS_IDENTIDAD_VERIFICADA ' + cipher, flush=True)
    for extra, codes, label in [(['--ssl-mode=DISABLED', '--get-server-public-key'], ('3159', '1045'), 'SIN_TLS_RECHAZADO'),
                               (['--ssl-ca=/var/lib/mysql/ca.pem'], ('2026',), 'CA_INCORRECTA_RECHAZADA')]:
        result = subprocess.run(client + extra, input='SELECT 1;', text=True, capture_output=True, timeout=15)
        found_codes = re.findall(r'ERROR (\d+)', result.stderr)
        print(label + '_CODIGOS=' + ','.join(found_codes), flush=True)
        if not result.returncode or not any(code in codes for code in found_codes):
            raise RuntimeError('Prueba negativa inconclusa: ' + label)
        # 1045 solo es valido tras conectar con la misma cuenta/credencial y TLS;
        # prueba REQUIRE SSL de esa cuenta, no aisla la politica global.
        if label == 'SIN_TLS_RECHAZADO' and '1045' in found_codes:
            print('RECHAZO_POR_CUENTA_REQUIRE_SSL; POLITICA_GLOBAL_COMPROBADA_EN_RUNTIME', flush=True)
        print(label, flush=True)
    result = subprocess.run(client, input='SELECT * FROM mysql.user;', text=True, capture_output=True, timeout=15)
    if not result.returncode or not re.search(r'ERROR (1142|1044)\b', result.stderr):
        raise RuntimeError('Privilegios fuera del alcance no comprobados')
    print('ACCESO_FUERA_DE_ALCANCE_DENEGADO', flush=True)
    for schema in SCHEMAS:
        dump = run(['mysqldump', '--no-defaults', '--user=root', '--protocol=SOCKET', '--socket=' + SOCKET,
                    '--single-transaction', '--no-tablespaces', '--set-gtid-purged=OFF', '--skip-add-drop-table', schema])
        backup = RUN / (schema + '.sql')
        backup.write_text(dump + '\n', encoding='utf-8')
        os.chmod(backup, 0o600)
        restore = schema.replace('piloto_mm_', 'piloto_mm_restore_')
        root(f'CREATE DATABASE `{restore}` CHARACTER SET utf8mb4;')
        run(ROOT + ['--database=' + restore], dump)
        if root(f"SELECT COUNT(*) FROM `{restore}`.prueba_conexion WHERE id=1 AND descripcion='verificacion ficticia correcta';") != '1':
            raise RuntimeError('Restauracion no verificada')
        print('COPIA_RESTAURACION_OK ' + schema, flush=True)
    print('FASE_LOCAL_PRUEBAS_SUPERADAS', flush=True)


if __name__ == '__main__':
    os.umask(0o077)
    def interrupted(signum, frame):
        raise RuntimeError('Interrupcion recibida; cerrar prueba')
    for sig in (signal.SIGTERM, signal.SIGHUP):
        signal.signal(sig, interrupted)
    ok = False
    try:
        main()
        ok = True
    except Exception as error:
        # Nunca imprimir SQL, credenciales o salida arbitraria de procesos.
        print('ERROR_FASE_LOCAL ' + str(error) if isinstance(error, RuntimeError) else 'ERROR_FASE_LOCAL ' + type(error).__name__, flush=True)
    finally:
        if started:
            try:
                if created_user:
                    root(f"ALTER USER '{USER}'@'127.0.0.1' ACCOUNT LOCK;")
                    print('CUENTA_PILOTO_BLOQUEADA', flush=True)
            except Exception:
                ok = False
                print('ERROR_BLOQUEO_CUENTA', flush=True)
            try:
                run(['systemctl', 'stop', 'mysql'], timeout=120)
                if not stopped():
                    raise RuntimeError('Parada no verificada')
                print('MYSQL_FINAL_INACTIVE_DISABLED_SIN_ESCUCHAS', flush=True)
            except Exception:
                ok = False
                print('ERROR_PARADA_REQUIERE_INTERVENCION', flush=True)
        print('PILOTO_LOCAL_COMPLETADO' if ok else 'PILOTO_LOCAL_NO_COMPLETADO', flush=True)
    sys.exit(0 if ok else 1)
