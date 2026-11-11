"""Extrae DDL sin registros ni contadores de la consulta local de metadatos."""
import json
from pathlib import Path
import re
import sys

source = Path(sys.argv[1]) / 'estructura-fuente.json'
destination = Path(__file__).with_name('estructura-piloto-20261105.json')
data = json.loads(source.read_text(encoding='utf-8'))
for module, tables in data.items():
    for table, ddl in tables.items():
        ddl = re.sub(r"\s+COMMENT\s+'(?:\\.|''|[^'])*'", '', ddl, flags=re.I)
        ddl = re.sub(r'\s+AUTO_INCREMENT=\d+', '', ddl)
        for line in ddl.splitlines():
            if re.match(r'\s*`(?:.*password.*|.*contrasena.*|.*token.*|.*secret.*)`', line, re.I):
                if re.search(r"DEFAULT\s+'[^']+'", line, re.I):
                    raise RuntimeError('Valor predeterminado sensible: no exportar')
        if not ddl.startswith('CREATE TABLE `' + table + '` (') or ';' in ddl:
            raise RuntimeError('DDL inesperado')
        cleaned = re.sub(r'ON\s+(?:DELETE|UPDATE)\s+(?:CASCADE|RESTRICT|SET NULL|NO ACTION)', '', ddl, flags=re.I)
        cleaned = re.sub(r'ON\s+UPDATE\s+CURRENT_TIMESTAMP(?:\(\))?', '', cleaned, flags=re.I)
        if re.search(r'\b(DROP|TRUNCATE|INSERT|UPDATE|DELETE|DEFINER)\b', cleaned, re.I):
            raise RuntimeError('Revisar DDL antes de exportar: ' + table)
        tables[table] = ddl
destination.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding='utf-8')
print('ESTRUCTURA_SIN_DATOS_EXPORTADA_TABLAS=' + str(sum(map(len, data.values()))))
