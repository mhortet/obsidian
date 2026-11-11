"""Copia y restaura los tres esquemas funcionales ficticios del piloto.

Ejecucion prevista exclusivamente con sudo en srv-mm-01. No abre la LAN,
no desbloquea cuentas, no borra esquemas y deja MySQL detenido/deshabilitado.
"""

import datetime
import hashlib
import os
from pathlib import Path
import pwd
import re
import signal
import stat
import subprocess
import sys


CONFIG = Path("/etc/mysql/mysql.conf.d/90-qontrolmed-piloto.cnf")
CONFIG_SHA256 = "4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927"
SOCKET = "/run/mysqld/mysqld.sock"
ROOT = [
    "mysql",
    "--no-defaults",
    "--user=root",
    "--protocol=SOCKET",
    "--socket=" + SOCKET,
    "--batch",
    "--skip-column-names",
]
MODULES = ("gestion", "quirofanos", "preventivos")
SOURCES = {module: "piloto_mm_" + module for module in MODULES}
DESTINATIONS = {module: "piloto_mm_restore_func3_" + module for module in MODULES}
EXPECTED_FUNCTIONAL_TABLES = {"gestion": 13, "quirofanos": 7, "preventivos": 13}
RUN = Path("/root/srv-mm-piloto-20261105/restauracion-funcional-r3")
PUBLIC_RESULT = Path("/home/vicente/RESTAURACION-FUNCIONAL-R3-2026-11-05.txt")
started = False
result_file = None


def emit(message):
    """Emite solo hitos no secretos a consola y evidencia publica."""
    text = str(message)
    print(text, flush=True)
    if result_file is not None:
        result_file.write(text + "\n")
        result_file.flush()


def run(args, sql=None, timeout=120):
    completed = subprocess.run(
        args,
        input=sql,
        text=True,
        capture_output=True,
        timeout=timeout,
    )
    if completed.returncode != 0:
        codes = re.findall(r"ERROR (\d+)", completed.stderr)
        detail = "; codigos=" + ",".join(codes) if codes else ""
        raise RuntimeError("Fallo en " + Path(args[0]).name + detail)
    return completed.stdout.strip()


def root(sql):
    return run(ROOT, sql=sql)


def sql_literal(value):
    if not re.fullmatch(r"[A-Za-z0-9_]+", value):
        raise RuntimeError("Identificador SQL inesperado")
    return "'" + value + "'"


def quote_identifier(value):
    if not re.fullmatch(r"[A-Za-z0-9_]+", value):
        raise RuntimeError("Identificador SQL inesperado")
    return "`" + value + "`"


def stopped():
    active = subprocess.run(
        ["systemctl", "is-active", "mysql"], capture_output=True, text=True
    ).stdout.strip()
    enabled = subprocess.run(
        ["systemctl", "is-enabled", "mysql"], capture_output=True, text=True
    ).stdout.strip()
    listeners = run(["ss", "-H", "-ltn"])
    process = subprocess.run(["pgrep", "-x", "mysqld"], capture_output=True)
    return (
        active == "inactive"
        and enabled == "disabled"
        and process.returncode == 1
        and not re.search(r":(?:3306|33060)\s", listeners)
    )


def query_lines(sql):
    output = root(sql)
    return tuple(output.splitlines()) if output else ()


def tables(schema):
    return query_lines(
        "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES "
        "WHERE TABLE_SCHEMA=" + sql_literal(schema) + " AND TABLE_TYPE='BASE TABLE' "
        "ORDER BY TABLE_NAME;"
    )


def snapshot(schema):
    schema_value = sql_literal(schema)
    table_names = tables(schema)
    row_counts = tuple(
        table
        + "\t"
        + root(
            "SELECT COUNT(*) FROM "
            + quote_identifier(schema)
            + "."
            + quote_identifier(table)
            + ";"
        )
        for table in table_names
    )
    columns = query_lines(
        "SELECT CONCAT_WS('\\t',TABLE_NAME,COLUMN_NAME,ORDINAL_POSITION,"
        "COALESCE(COLUMN_DEFAULT,'<NULL>'),IS_NULLABLE,DATA_TYPE,COLUMN_TYPE,EXTRA,"
        "COALESCE(CHARACTER_SET_NAME,'<NULL>'),COALESCE(COLLATION_NAME,'<NULL>')) "
        "FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA="
        + schema_value
        + " ORDER BY TABLE_NAME,ORDINAL_POSITION;"
    )
    indexes = query_lines(
        "SELECT CONCAT_WS('\\t',TABLE_NAME,INDEX_NAME,NON_UNIQUE,SEQ_IN_INDEX,"
        "COALESCE(COLUMN_NAME,'<NULL>'),COALESCE(COLLATION,'<NULL>'),"
        "COALESCE(SUB_PART,'<NULL>'),INDEX_TYPE) FROM INFORMATION_SCHEMA.STATISTICS "
        "WHERE TABLE_SCHEMA="
        + schema_value
        + " ORDER BY TABLE_NAME,INDEX_NAME,SEQ_IN_INDEX;"
    )
    foreign_keys = query_lines(
        "SELECT CONCAT_WS('\\t',k.TABLE_NAME,k.CONSTRAINT_NAME,k.COLUMN_NAME,"
        "k.ORDINAL_POSITION,k.REFERENCED_TABLE_NAME,k.REFERENCED_COLUMN_NAME,"
        "r.UPDATE_RULE,r.DELETE_RULE) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE k "
        "JOIN INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS r "
        "ON r.CONSTRAINT_SCHEMA=k.CONSTRAINT_SCHEMA AND r.CONSTRAINT_NAME=k.CONSTRAINT_NAME "
        "AND r.TABLE_NAME=k.TABLE_NAME WHERE k.TABLE_SCHEMA="
        + schema_value
        + " AND k.REFERENCED_TABLE_NAME IS NOT NULL "
        "ORDER BY k.TABLE_NAME,k.CONSTRAINT_NAME,k.ORDINAL_POSITION;"
    )
    return table_names, row_counts, columns, indexes, foreign_keys


def validate_source(module, schema):
    table_names = tables(schema)
    if "prueba_conexion" not in table_names:
        raise RuntimeError("Falta tabla de control en " + module)
    functional = tuple(name for name in table_names if name != "prueba_conexion")
    if len(functional) != EXPECTED_FUNCTIONAL_TABLES[module]:
        raise RuntimeError("Numero de tablas funcionales inesperado en " + module)
    non_tables = root(
        "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA="
        + sql_literal(schema)
        + " AND TABLE_TYPE<>'BASE TABLE';"
    )
    routines = root(
        "SELECT COUNT(*) FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA="
        + sql_literal(schema)
        + ";"
    )
    events = root(
        "SELECT COUNT(*) FROM INFORMATION_SCHEMA.EVENTS WHERE EVENT_SCHEMA="
        + sql_literal(schema)
        + ";"
    )
    if (non_tables, routines, events) != ("0", "0", "0"):
        raise RuntimeError("Objetos fuera del alcance de tablas en " + module)
    return snapshot(schema)


def create_database_like(source, destination):
    charset_and_collation = root(
        "SELECT DEFAULT_CHARACTER_SET_NAME,DEFAULT_COLLATION_NAME "
        "FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME=" + sql_literal(source) + ";"
    ).split("\t")
    if len(charset_and_collation) != 2 or not all(
        re.fullmatch(r"[A-Za-z0-9_]+", item) for item in charset_and_collation
    ):
        raise RuntimeError("Charset o collation inesperados")
    root(
        "CREATE DATABASE "
        + quote_identifier(destination)
        + " CHARACTER SET "
        + charset_and_collation[0]
        + " COLLATE "
        + charset_and_collation[1]
        + ";"
    )


def main():
    global started, result_file
    if os.geteuid() != 0 or run(["hostname"]) != "srv-mm-01":
        raise RuntimeError("Requiere sudo en srv-mm-01")
    if not stopped():
        raise RuntimeError("Estado inicial de MySQL inesperado")
    if hashlib.sha256(CONFIG.read_bytes()).hexdigest() != CONFIG_SHA256:
        raise RuntimeError("Configuracion piloto no coincide")
    if RUN.exists() or RUN.is_symlink() or PUBLIC_RESULT.exists() or PUBLIC_RESULT.is_symlink():
        raise RuntimeError("Destino de evidencia existente; no sobrescribir")

    RUN.mkdir(mode=0o700)
    result_file = PUBLIC_RESULT.open("x", encoding="utf-8")
    os.chmod(PUBLIC_RESULT, 0o640)
    owner = pwd.getpwnam("vicente")
    os.chown(PUBLIC_RESULT, owner.pw_uid, owner.pw_gid)
    emit("RESTAURACION_FUNCIONAL_R3_INICIO")
    emit(datetime.datetime.now().astimezone().isoformat())
    emit("REGISTRO_PRIVADO=" + str(RUN))

    run(["mysqld", "--user=mysql", "--validate-config"])
    for certificate in (
        "/var/lib/mysql/piloto-tls/ca.pem",
        "/var/lib/mysql/piloto-tls/server-cert.pem",
    ):
        run(["openssl", "x509", "-in", certificate, "-checkend", "0", "-noout"])
    private_key = os.stat("/var/lib/mysql/piloto-tls/server-key.pem")
    if (
        private_key.st_uid != pwd.getpwnam("mysql").pw_uid
        or stat.S_IMODE(private_key.st_mode) != 0o600
    ):
        raise RuntimeError("Permisos de clave TLS inesperados")

    started = True
    run(["systemctl", "start", "mysql"], timeout=90)
    listeners = tuple(
        line.split()[3]
        for line in run(["ss", "-H", "-ltn"]).splitlines()
        if re.search(r":(?:3306|33060)$", line.split()[3])
    )
    if listeners != ("127.0.0.1:3306",):
        raise RuntimeError("Escucha MySQL inesperada")
    if root("SELECT @@bind_address='127.0.0.1' AND @@require_secure_transport=1;") != "1":
        raise RuntimeError("Parametros runtime inesperados")
    if (
        root("SHOW GLOBAL VARIABLES LIKE 'ssl_cert';").split("\t")[-1]
        != "/var/lib/mysql/piloto-tls/server-cert.pem"
    ):
        raise RuntimeError("Certificado runtime inesperado")
    emit("MYSQL_LOCAL_TLS_VALIDADO")

    for destination in DESTINATIONS.values():
        if root(
            "SELECT COUNT(*) FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME="
            + sql_literal(destination)
            + ";"
        ) != "0":
            raise RuntimeError("Un destino ya existe; no sobrescribir")

    source_snapshots = {}
    for module, source in SOURCES.items():
        source_snapshots[module] = validate_source(module, source)
        emit(
            "ORIGEN_VALIDADO "
            + module
            + " TABLAS_FUNCIONALES="
            + str(EXPECTED_FUNCTIONAL_TABLES[module])
        )
    emit("ORIGEN_TOTAL_TABLAS_FUNCIONALES=33")

    for module in MODULES:
        source = SOURCES[module]
        destination = DESTINATIONS[module]
        dump_path = RUN / (source + "-funcional-r3.sql")
        dump = run(
            [
                "mysqldump",
                "--no-defaults",
                "--user=root",
                "--protocol=SOCKET",
                "--socket=" + SOCKET,
                "--single-transaction",
                "--quick",
                "--hex-blob",
                "--no-tablespaces",
                "--set-gtid-purged=OFF",
                "--skip-add-drop-table",
                "--skip-lock-tables",
                "--triggers",
                source,
            ],
            timeout=300,
        )
        if re.search(r"(?im)^\s*(?:CREATE DATABASE|USE)\b", dump):
            raise RuntimeError("La copia contiene seleccion explicita de base")
        dump_path.write_text(dump + "\n", encoding="utf-8")
        os.chmod(dump_path, 0o600)
        (RUN / (dump_path.name + ".sha256")).write_text(
            hashlib.sha256((dump + "\n").encode("utf-8")).hexdigest()
            + "  "
            + dump_path.name
            + "\n",
            encoding="utf-8",
        )

        create_database_like(source, destination)
        run(ROOT + ["--database=" + destination], sql=dump, timeout=300)
        restored_snapshot = snapshot(destination)
        if restored_snapshot != source_snapshots[module]:
            raise RuntimeError("La restauracion no coincide en " + module)
        emit(
            "COPIA_RESTAURACION_VERIFICADA "
            + module
            + " DESTINO="
            + destination
            + " TABLAS_TOTALES="
            + str(len(restored_snapshot[0]))
            + " RELACIONES="
            + str(len(restored_snapshot[4]))
        )

    emit("COPIA_RESTAURACION_FUNCIONAL_33_TABLAS_OK")


if __name__ == "__main__":
    os.umask(0o077)

    def interrupted(signum, frame):
        raise RuntimeError("Interrupcion recibida")

    for current_signal in (signal.SIGTERM, signal.SIGHUP):
        signal.signal(current_signal, interrupted)

    ok = False
    try:
        main()
        ok = True
    except Exception as error:
        safe_error = str(error) if isinstance(error, RuntimeError) else type(error).__name__
        emit("ERROR_RESTAURACION_FUNCIONAL " + safe_error)
    finally:
        if started:
            try:
                run(["systemctl", "stop", "mysql"], timeout=120)
                if not stopped():
                    raise RuntimeError("Parada no confirmada")
                emit("MYSQL_FINAL_INACTIVE_DISABLED_SIN_ESCUCHAS")
            except Exception:
                ok = False
                emit("ERROR_PARADA_REQUIERE_INTERVENCION")
        emit("RESTAURACION_FUNCIONAL_COMPLETADA" if ok else "RESTAURACION_FUNCIONAL_NO_COMPLETADA")
        if result_file is not None:
            result_file.close()
    sys.exit(0 if ok else 1)
