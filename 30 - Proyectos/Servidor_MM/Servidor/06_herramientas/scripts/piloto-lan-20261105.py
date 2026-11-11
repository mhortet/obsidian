"""Ventana LAN autorizada: 15 minutos, cierre y restauracion al terminar."""
import datetime
import hashlib
import importlib.util
import os
from pathlib import Path
import pwd
import re
import secrets
import shutil
import signal
import sys
import time

spec = importlib.util.spec_from_file_location('pilot_core', Path(__file__).with_name('piloto-local-20261105.py'))
core = importlib.util.module_from_spec(spec)
spec.loader.exec_module(core)
run, root = core.run, core.root
IP = '192.168.1.107'
USER = 'mm_piloto_pc'
BASE = Path('/root/srv-mm-piloto-20261105/prueba-lan')
EXPORT = Path('/home/vicente/piloto-runtime-20261105')
TARGET = core.TARGET
changed = False
started = False
account = False
rule = False
ok = False
RESUME = sys.argv[1:] == ['--resume']


def interrupted(signum, frame):
    raise RuntimeError('Interrupcion de la ventana LAN')


def main():
    global changed, started, account, rule
    if os.geteuid() != 0 or run(['hostname']) != 'srv-mm-01' or not core.stopped():
        raise RuntimeError('Precondicion de host/estado incorrecta')
    if hashlib.sha256(TARGET.read_bytes()).hexdigest() != '4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927':
        raise RuntimeError('Configuracion no coincide')
    # sudo puede conservar SSH_CONNECTION; no se permite abrir a otro origen.
    connection = os.getenv('SSH_CONNECTION', '').split()
    if not connection or connection[0] != IP:
        raise RuntimeError('Ejecutar desde la sesion SSH del puesto 192.168.1.107')
    if sys.argv[1:] not in ([], ['--resume']):
        raise RuntimeError('Argumentos inesperados')
    for path in (BASE, EXPORT):
        if path.is_symlink() or (not RESUME and path.exists()) or (RESUME and not path.is_dir()):
            raise RuntimeError('Destino existente; revisar sin sobrescribir')
    firewall = run(['ufw', 'status', 'numbered'])
    if 'Status: active' not in firewall or re.search(r'\b3306\b', firewall):
        raise RuntimeError('Revisar firewall antes de agregar la regla propia')
    if not RESUME:
        BASE.mkdir(mode=0o700)
        shutil.copy2(TARGET, BASE / 'original.cnf')
    elif TARGET.read_bytes() != (BASE / 'original.cnf').read_bytes():
        raise RuntimeError('Configuracion de reanudacion inesperada')
    if RESUME and (EXPORT / 'FINALIZAR').exists():
        (EXPORT / 'FINALIZAR').rename(EXPORT / ('FINALIZAR-anterior-' + secrets.token_hex(4)))
    print('REGISTRO_ROOT=' + str(BASE), flush=True)
    print(datetime.datetime.now().astimezone().isoformat(), flush=True)
    # Arranque local inicial para preparar solo la cuenta nueva.
    started = True
    run(['systemctl', 'start', 'mysql'], timeout=90)
    if not RESUME and root(f"SELECT COUNT(*) FROM mysql.user WHERE User='{USER}';") != '0':
        raise RuntimeError('Cuenta de destino existente')
    for schema in core.SCHEMAS:
        if root(f"SELECT COUNT(*) FROM `{schema}`.prueba_conexion;") != '1':
            raise RuntimeError('Datos ficticios inesperados')
    if RESUME:
        if root(f"SELECT COUNT(*) FROM mysql.user WHERE User='{USER}';") != '1' or root(
            f"SELECT CONCAT(ssl_type, ':', account_locked) FROM mysql.user WHERE User='{USER}' AND Host='{IP}';"
        ) != 'ANY:Y':
            raise RuntimeError('Cuenta LAN no coincide con el piloto bloqueado')
        if (EXPORT / '.env').is_symlink() or not (EXPORT / '.env').is_file():
            raise RuntimeError('Falta configuracion protegida del puesto')
        root(f"ALTER USER '{USER}'@'{IP}' ACCOUNT UNLOCK;")
        account = True
    else:
        password = secrets.token_hex(32)
        root(f"CREATE USER '{USER}'@'{IP}' IDENTIFIED BY '{password}' REQUIRE SSL;")
        account = True
        for schema in core.SCHEMAS:
            root(f"GRANT SELECT,INSERT,UPDATE,DELETE ON `{schema}`.* TO '{USER}'@'{IP}';")
    run(['systemctl', 'stop', 'mysql'], timeout=120)
    if not core.stopped():
        raise RuntimeError('Parada intermedia no confirmada')
    identity = pwd.getpwnam('vicente')
    if not RESUME:
        EXPORT.mkdir(mode=0o700)
        os.chown(EXPORT, identity.pw_uid, identity.pw_gid)
        env = ('DB_HOST=192.168.1.31\nDB_PORT=3306\nDB_USER=' + USER + '\nDB_PASSWORD=' + password + '\n'
           'DB_GESTION=piloto_mm_gestion\nDB_QUIROFANOS=piloto_mm_quirofanos\nDB_PREVENTIVOS=piloto_mm_preventivos\n'
           'DB_TLS_REQUIRED=1\nDB_SSL_CA=ca-piloto.pem\nDB_CONNECT_TIMEOUT=5\nDB_READ_TIMEOUT=10\nDB_WRITE_TIMEOUT=10\n')
        (EXPORT / '.env').write_text(env, encoding='utf-8')
        os.chmod(EXPORT / '.env', 0o600)
        os.chown(EXPORT / '.env', identity.pw_uid, identity.pw_gid)
        shutil.copyfile('/var/lib/mysql/piloto-tls/ca.pem', EXPORT / 'ca-piloto.pem')
        os.chmod(EXPORT / 'ca-piloto.pem', 0o644)
        os.chown(EXPORT / 'ca-piloto.pem', identity.pw_uid, identity.pw_gid)
    original = (BASE / 'original.cnf').read_text()
    expected = original.replace('bind-address=127.0.0.1\n', 'bind-address=127.0.0.1,192.168.1.31\n')
    if expected == original:
        raise RuntimeError('No se encontro bind-address esperado')
    (BASE / 'expected.cnf').write_text(expected)
    # Archivo completo instalado con propietario y permisos conocidos.
    changed = True
    run(['install', '-o', 'root', '-g', 'root', '-m', '0644', str(BASE / 'expected.cnf'), str(TARGET)])
    run(['mysqld', '--user=mysql', '--validate-config'])
    rule = True  # Marcar antes: retirar tambien si ufw falla parcialmente.
    run(['ufw', 'allow', 'in', 'on', 'eno1', 'proto', 'tcp', 'from', IP, 'to', '192.168.1.31', 'port', '3306', 'comment', 'piloto-mm-20261105'])
    run(['systemctl', 'start', 'mysql'], timeout=90)
    listeners = sorted(line.split()[3] for line in run(['ss', '-H', '-ltn']).splitlines() if re.search(r':(?:3306|33060)$', line.split()[3]))
    if listeners != ['127.0.0.1:3306', '192.168.1.31:3306']:
        raise RuntimeError('Escucha LAN inesperada')
    print('PILOTO_LAN_LISTO_15_MINUTOS', flush=True)
    print('AVISAR_LISTO_EN_EL_CHAT_Y_MANTENER_ESTA_SESION_ABIERTA', flush=True)
    deadline = time.monotonic() + 900
    while time.monotonic() < deadline:
        if (EXPORT / 'FINALIZAR').exists():
            print('CIERRE_SOLICITADO_POR_LAS_PRUEBAS', flush=True)
            return
        time.sleep(2)
    print('TIEMPO_LIMITE_ALCANZADO_CERRANDO', flush=True)


if __name__ == '__main__':
    os.umask(0o077)
    for sig in (signal.SIGTERM, signal.SIGHUP):
        signal.signal(sig, interrupted)
    try:
        main()
        ok = True
    except Exception as error:
        print('ERROR_LAN ' + str(error) if isinstance(error, RuntimeError) else 'ERROR_LAN ' + type(error).__name__, flush=True)
    finally:
        # Mantener la limpieza activa ante fallos independientes.
        if account:
            try:
                # Si no estaba arrancado, parar ya impide todas sus conexiones;
                # el bloqueo se intenta solo con servicio activo.
                if run(['systemctl', 'is-active', 'mysql']) == 'active':
                    root(f"ALTER USER '{USER}'@'{IP}' ACCOUNT LOCK;")
                    print('CUENTA_LAN_BLOQUEADA', flush=True)
                else:
                    print('CUENTA_LAN_PENDIENTE_BLOQUEO_SERVICIO_PARADO', flush=True)
                    ok = False
            except Exception:
                print('ERROR_BLOQUEO_CUENTA_LAN', flush=True)
                ok = False
        if started:
            try:
                run(['systemctl', 'stop', 'mysql'], timeout=120)
            except Exception:
                print('ERROR_PARADA_REQUIERE_INTERVENCION', flush=True)
                ok = False
        if rule:
            try:
                run(['ufw', '--force', 'delete', 'allow', 'in', 'on', 'eno1', 'proto', 'tcp', 'from', IP, 'to', '192.168.1.31', 'port', '3306'])
                print('REGLA_LAN_PROPIA_RETIRADA', flush=True)
            except Exception:
                print('ERROR_RETIRADA_REGLA_REQUIERE_REVISION', flush=True)
                ok = False
        if changed:
            try:
                if TARGET.read_bytes() != (BASE / 'expected.cnf').read_bytes():
                    raise RuntimeError('Archivo cambiado durante la prueba')
                run(['install', '-o', 'root', '-g', 'root', '-m', '0644', str(BASE / 'original.cnf'), str(TARGET)])
                run(['mysqld', '--user=mysql', '--validate-config'])
                print('ESCUCHA_LOCAL_RESTAURADA', flush=True)
            except Exception:
                print('ERROR_RESTAURACION_CONFIGURACION', flush=True)
                ok = False
        if started and not core.stopped():
            print('ERROR_ESTADO_FINAL_REQUIERE_INTERVENCION', flush=True)
            ok = False
        if started and core.stopped():
            print('MYSQL_FINAL_INACTIVE_DISABLED_SIN_ESCUCHAS', flush=True)
        print('VENTANA_LAN_CERRADA' if ok else 'VENTANA_LAN_REQUIERE_REVISION', flush=True)
    sys.exit(0 if ok else 1)
