"""Crea solo estructura y bootstrap revisado en los tres esquemas ficticios."""
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import signal
import sys

spec = importlib.util.spec_from_file_location('pilot_core', Path(__file__).with_name('piloto-local-20261105.py'))
core = importlib.util.module_from_spec(spec)
spec.loader.exec_module(core)
run, root = core.run, core.root
BASE = Path('/root/srv-mm-piloto-20261105/esquema-funcional')
started = False


def interrupted(signum, frame):
    raise RuntimeError('Preparacion interrumpida')


def main():
    global started
    if os.geteuid() != 0 or run(['hostname']) != 'srv-mm-01' or not core.stopped():
        raise RuntimeError('Host o estado inicial incorrectos')
    if BASE.exists() or BASE.is_symlink():
        raise RuntimeError('Destino existente: revisar sin sobrescribir')
    definitions = json.loads(Path(__file__).with_name('estructura-piloto-20261105.json').read_text(encoding='utf-8'))
    if set(definitions) != {'gestion', 'quirofanos', 'preventivos'} or [len(definitions[k]) for k in ('gestion', 'quirofanos', 'preventivos')] != [13, 7, 13]:
        raise RuntimeError('Inventario estructural no coincide')
    for module, tables in definitions.items():
        for table, ddl in tables.items():
            if not re.fullmatch(r'[A-Za-z0-9_]+', table) or not ddl.startswith('CREATE TABLE `' + table + '` (') or ';' in ddl:
                raise RuntimeError('DDL no esperado')
            if re.search(r'\b(DROP|TRUNCATE|INSERT|UPDATE|DELETE|DEFINER)\b', ddl, re.I):
                # ON DELETE / ON UPDATE forman parte de las claves foraneas.
                cleaned = re.sub(r'ON\s+(?:DELETE|UPDATE)\s+(?:CASCADE|RESTRICT|SET NULL|NO ACTION)', '', ddl, flags=re.I)
                cleaned = re.sub(r'ON\s+UPDATE\s+CURRENT_TIMESTAMP(?:\(\))?', '', cleaned, flags=re.I)
                if re.search(r'\b(DROP|TRUNCATE|INSERT|UPDATE|DELETE|DEFINER)\b', cleaned, re.I):
                    raise RuntimeError('DDL fuera de alcance')
    BASE.mkdir(mode=0o700)
    print('REGISTRO_ROOT=' + str(BASE), flush=True)
    started = True
    run(['systemctl', 'start', 'mysql'], timeout=90)
    if root("SELECT @@bind_address='127.0.0.1' AND @@require_secure_transport=1;") != '1':
        raise RuntimeError('Configuracion local no coincide')
    for schema in core.SCHEMAS:
        if root(f"SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='{schema}';") != 'prueba_conexion':
            raise RuntimeError('El esquema piloto ya tiene otras tablas')
    for module, tables in definitions.items():
        schema = 'piloto_mm_' + module
        dump = run(['mysqldump', '--no-defaults', '--user=root', '--protocol=SOCKET', '--socket=' + core.SOCKET,
                    '--single-transaction', '--no-tablespaces', '--set-gtid-purged=OFF', schema])
        (BASE / (schema + '-antes.sql')).write_text(dump + '\n', encoding='utf-8')
        ddl = 'USE `' + schema + '`; SET FOREIGN_KEY_CHECKS=0;\n' + ';\n'.join(tables.values()) + ';\nSET FOREIGN_KEY_CHECKS=1;'
        root(ddl)
        if root(f"SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='{schema}';") != str(len(tables) + 1):
            raise RuntimeError('Numero de tablas no coincide')
        print('ESTRUCTURA_CREADA ' + module + ' TABLAS=' + str(len(tables)), flush=True)
    # Solo datos estaticos de roles/permisos y administrador sintetico sin clave;
    # el asistente de la aplicacion debe asignar la primera clave posteriormente.
    for name in ('gestion_roles_permisos_iniciales.sql', 'gestion_administrador_inicial.sql'):
        text = Path(__file__).with_name(name).read_text(encoding='utf-8-sig')
        text = re.sub(r'(?im)^USE\s+`gestion`\s*;', 'USE `piloto_mm_gestion`;', text)
        if re.search(r'(?im)^USE\s+(?!`piloto_mm_gestion`)', text) or re.search(r'(?im)^\s*(?:DROP|TRUNCATE|CREATE USER|GRANT)\b', text):
            raise RuntimeError('Bootstrap fuera de alcance')
        root(text)
    if root("SELECT COUNT(*) FROM piloto_mm_gestion.usuarios;") != '1':
        raise RuntimeError('Bootstrap de usuario no coincide')
    print('BOOTSTRAP_FICTICIO_ROLES_Y_ADMINISTRADOR_OK', flush=True)
    print('ESQUEMA_FUNCIONAL_PREPARADO', flush=True)


if __name__ == '__main__':
    os.umask(0o077)
    for sig in (signal.SIGTERM, signal.SIGHUP):
        signal.signal(sig, interrupted)
    ok = False
    try:
        main()
        ok = True
    except Exception as error:
        print('ERROR_ESQUEMA ' + (str(error) if isinstance(error, RuntimeError) else type(error).__name__), flush=True)
    finally:
        if started:
            try:
                run(['systemctl', 'stop', 'mysql'], timeout=120)
                if not core.stopped():
                    raise RuntimeError('Parada no confirmada')
                print('MYSQL_FINAL_INACTIVE_DISABLED_SIN_ESCUCHAS', flush=True)
            except Exception:
                ok = False
                print('ERROR_PARADA_REQUIERE_INTERVENCION', flush=True)
        print('PREPARACION_FUNCIONAL_COMPLETADA' if ok else 'PREPARACION_FUNCIONAL_NO_COMPLETADA', flush=True)
    sys.exit(0 if ok else 1)
