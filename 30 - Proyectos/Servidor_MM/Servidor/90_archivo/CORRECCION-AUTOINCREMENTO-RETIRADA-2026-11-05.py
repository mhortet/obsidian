"""Corrige solo el ID de marcas del piloto y abre su ventana LAN autorizada."""
import importlib.util
import os
from pathlib import Path
import signal
import subprocess
import sys

spec = importlib.util.spec_from_file_location('pilot_core', Path(__file__).with_name('piloto-local-20261105.py'))
core = importlib.util.module_from_spec(spec)
spec.loader.exec_module(core)
root, run = core.root, core.run
BASE = Path('/root/srv-mm-piloto-20261105/correccion-marcas')
started = False
altered = False
ok = False


def interrupted(signum, frame):
    raise RuntimeError('Correccion interrumpida')


def main():
    global started, altered
    if os.geteuid() != 0 or run(['hostname']) != 'srv-mm-01' or not core.stopped():
        raise RuntimeError('Host o estado inesperados')
    if BASE.exists() or BASE.is_symlink():
        raise RuntimeError('Registro existente: revisar antes de repetir')
    BASE.mkdir(mode=0o700)
    started = True
    run(['systemctl', 'start', 'mysql'], timeout=90)
    if root("SELECT @@bind_address='127.0.0.1' AND @@require_secure_transport=1;") != '1':
        raise RuntimeError('Configuracion local no coincide')
    if root("SELECT COUNT(*) FROM piloto_mm_gestion.marcas;") != '0':
        raise RuntimeError('Tabla marcas no vacia; revisar sin sobrescribir')
    actual = root("SELECT CONCAT(DATA_TYPE, ':', IS_NULLABLE, ':', EXTRA) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='piloto_mm_gestion' AND TABLE_NAME='marcas' AND COLUMN_NAME='idMarcas';")
    if actual != 'int:NO:':
        raise RuntimeError('Definicion de idMarcas distinta de la diagnosticada')
    dump = run(['mysqldump', '--no-defaults', '--user=root', '--protocol=SOCKET', '--socket=' + core.SOCKET,
                '--no-tablespaces', '--set-gtid-purged=OFF', '--skip-add-drop-table', 'piloto_mm_gestion', 'marcas'])
    (BASE / 'marcas-antes.sql').write_text(dump + '\n', encoding='utf-8')
    root('ALTER TABLE piloto_mm_gestion.marcas MODIFY COLUMN idMarcas INT NOT NULL AUTO_INCREMENT;')
    altered = True
    if root("SELECT EXTRA FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='piloto_mm_gestion' AND TABLE_NAME='marcas' AND COLUMN_NAME='idMarcas';") != 'auto_increment':
        raise RuntimeError('No se verifico AUTO_INCREMENT')
    print('ID_MARCAS_PILOTO_AUTOGENERADO_CONFIGURADO', flush=True)


if __name__ == '__main__':
    os.umask(0o077)
    for sig in (signal.SIGTERM, signal.SIGHUP):
        signal.signal(sig, interrupted)
    try:
        main()
        ok = True
    except Exception as error:
        print('ERROR_CORRECCION ' + (str(error) if isinstance(error, RuntimeError) else type(error).__name__), flush=True)
        if altered:
            try:
                root('ALTER TABLE piloto_mm_gestion.marcas MODIFY COLUMN idMarcas INT NOT NULL;')
                print('DEFINICION_ANTERIOR_RESTAURADA', flush=True)
            except Exception:
                print('ERROR_REVERSION_REQUIERE_REVISION', flush=True)
    finally:
        if started:
            try:
                run(['systemctl', 'stop', 'mysql'], timeout=120)
                if not core.stopped():
                    raise RuntimeError('Parada no confirmada')
                print('MYSQL_PARADO_TRAS_CORRECCION_LOCAL', flush=True)
            except Exception:
                ok = False
                print('ERROR_PARADA_REQUIERE_INTERVENCION', flush=True)
    if not ok:
        sys.exit(1)
    print('ABRIENDO_VENTANA_PARA_REPETIR_SERVICIOS', flush=True)
    sys.exit(subprocess.call([sys.executable, str(Path(__file__).with_name('piloto-lan-20261105.py')), '--resume']))
