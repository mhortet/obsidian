"""Prueba de las conexiones reales de Qontrolmed; secretos fuera del repositorio."""
import os
from pathlib import Path
import socket
import sys
import time
from unittest.mock import patch

ROOT = Path(__file__).with_name('qontrolmed-piloto')
sys.path.insert(0, str(ROOT / 'src'))
import mysql.connector
from compartido.configuracion import configuracion_db
from compartido.db import GestorConexiones


def main():
    directory = Path(sys.argv[1]).resolve()
    if not (directory / '.env').is_file() or not (directory / 'ca-piloto.pem').is_file():
        raise RuntimeError('Faltan archivos protegidos de configuracion del piloto')
    manager = None
    with patch('compartido.configuracion.env_path', return_value=directory / '.env'):
        try:
            manager = GestorConexiones()
            for module in ('gestion', 'quirofanos', 'preventivos'):
                rows = manager._fetchall_modulo(module, 'SELECT id, descripcion FROM prueba_conexion ORDER BY id')
                if rows != [(1, 'verificacion ficticia correcta')]:
                    raise RuntimeError('Datos ficticios inesperados')
                manager._execute_commit_modulo(module, "INSERT INTO prueba_conexion VALUES (2, %s)", ('prueba desde Windows',))
                manager._execute_commit_modulo(module, 'UPDATE prueba_conexion SET descripcion=%s WHERE id=2', ('actualizacion desde Windows',))
                if manager._fetchone_modulo(module, 'SELECT descripcion FROM prueba_conexion WHERE id=2') != ('actualizacion desde Windows',):
                    raise RuntimeError('Actualizacion no verificada')
                manager._execute_commit_modulo(module, 'DELETE FROM prueba_conexion WHERE id=2')
                cipher = manager._fetchone_modulo(module, "SHOW SESSION STATUS LIKE 'Ssl_cipher'")
                if not cipher or not cipher[1]:
                    raise RuntimeError('Cifrado no comprobado')
                print('QONTROLMED_DML_TLS_OK ' + module + ' ' + cipher[1], flush=True)
            manager.conexion.close()
            if manager._fetchone_modulo('gestion', 'SELECT 1') != (1,):
                raise RuntimeError('No se recupero la sesion cerrada')
            print('RECUPERACION_SESION_CERRADA_OK', flush=True)
            config = configuracion_db('DB_GESTION')
            no_tls = dict(config, ssl_disabled=True)
            for key in ('ssl_ca', 'ssl_verify_cert', 'ssl_verify_identity', 'tls_versions'):
                no_tls.pop(key, None)
            try:
                unexpected = mysql.connector.connect(**no_tls)
            except mysql.connector.Error as error:
                if error.errno not in (1045, 3159, 2061):
                    raise RuntimeError('Rechazo sin TLS inconcluso')
                print('SIN_TLS_RECHAZADO_PC_CODIGO=' + str(error.errno), flush=True)
            else:
                unexpected.close()
                raise RuntimeError('Se acepto una conexion sin TLS')
            original_lookup = socket.getaddrinfo
            wrong_name = 'identidad-incorrecta.invalid'
            def lookup(host, *args, **kwargs):
                return original_lookup(config['host'] if host == wrong_name else host, *args, **kwargs)
            try:
                with patch('socket.getaddrinfo', side_effect=lookup):
                    unexpected = mysql.connector.connect(**dict(config, host=wrong_name))
            except (mysql.connector.Error, ValueError) as error:
                message = str(error).lower()
                if not any(term in message for term in ('certificate verify failed', 'hostname mismatch', 'not valid for', 'does not match')):
                    raise RuntimeError('Rechazo de identidad inconcluso')
                print('IDENTIDAD_INCORRECTA_RECHAZADA_PC', flush=True)
            else:
                unexpected.close()
                raise RuntimeError('Se acepto identidad incorrecta')
            timed = mysql.connector.connect(**dict(config, read_timeout=1))
            before = time.monotonic()
            try:
                cursor = timed.cursor()
                cursor.execute('SELECT SLEEP(3)')
                cursor.fetchall()
            except mysql.connector.errors.ReadTimeoutError:
                if time.monotonic() - before > 5:
                    raise RuntimeError('Timeout fuera del limite')
                print('TIMEOUT_LECTURA_REAL_OK', flush=True)
            else:
                raise RuntimeError('No se aplico timeout de lectura')
            finally:
                timed.close()
            print('PRUEBA_CONEXIONES_QONTROLMED_PC_COMPLETADA', flush=True)
        finally:
            if manager is not None:
                manager.cerrar()


if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        # No imprimir mensajes del conector que incluyan usuario/SQL/configuracion.
        print('ERROR_PRUEBA_PC ' + (str(error) if isinstance(error, RuntimeError) else type(error).__name__), flush=True)
        sys.exit(1)
