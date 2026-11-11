"""Consulta solo metadatos de la instancia local; nunca imprime credenciales."""
import json
import os
from pathlib import Path
import re
import sys

import mysql.connector
from dotenv import dotenv_values


def main():
    config_file = Path(os.environ['PROGRAMDATA']) / 'Qontrolmed' / 'config' / '.env'
    values = dotenv_values(config_file)
    host = values.get('DB_HOST', '')
    if host not in ('127.0.0.1', 'localhost', '::1'):
        print('FUENTE_NO_LOOPBACK_NO_CONSULTADA')
        return
    names = [values.get(key, '') for key in ('DB_GESTION', 'DB_QUIROFANOS', 'DB_PREVENTIVOS')]
    if not all(re.fullmatch(r'[A-Za-z0-9_]{1,64}', name) for name in names):
        raise RuntimeError('Nombres de esquema no validos')
    connection = mysql.connector.connect(
        host=host, port=int(values.get('DB_PORT') or 3306), user=values.get('DB_USER'),
        password=values.get('DB_PASSWORD', ''), connection_timeout=5,
        read_timeout=10, write_timeout=10, use_pure=True, allow_local_infile=False,
    )
    result = {}
    try:
        connection.start_transaction(readonly=True)
        cursor = connection.cursor()
        for label, schema in zip(('gestion', 'quirofanos', 'preventivos'), names):
            cursor.execute('SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=%s AND TABLE_TYPE=%s ORDER BY TABLE_NAME', (schema, 'BASE TABLE'))
            tables = [row[0] for row in cursor.fetchall()]
            definitions = {}
            for table in tables:
                quoted_schema = schema.replace('`', '``')
                quoted_table = table.replace('`', '``')
                cursor.execute(f'SHOW CREATE TABLE `{quoted_schema}`.`{quoted_table}`')
                definitions[table] = cursor.fetchone()[1]
            result[label] = definitions
            print('ESTRUCTURA_' + label.upper() + '_TABLAS=' + str(len(definitions)))
        cursor.close()
        destination = Path(os.environ['LOCALAPPDATA']) / 'Qontrolmed-Piloto-20261105' / 'estructura-fuente.json'
        if destination.exists():
            raise RuntimeError('Destino de metadatos ya existe')
        destination.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf-8')
        print('SOLO_METADATOS_GUARDADOS_EN_DIRECTORIO_PROTEGIDO')
    finally:
        connection.rollback()
        connection.close()


if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        print('ESTRUCTURA_LOCAL_NO_RECUPERADA ' + type(error).__name__)
        sys.exit(1)
