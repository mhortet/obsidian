"""Interrumpe solo la conexion propia mientras escribe un registro sintetico."""
from pathlib import Path
import sys
import threading
import time
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).with_name('qontrolmed-piloto') / 'src'))
import mysql.connector
from compartido.configuracion import configuracion_db
from compartido.db import GestorConexiones


def main():
    manager = None
    interrupter = None
    errors = []
    with patch('compartido.configuracion.env_path', return_value=Path(sys.argv[1]) / '.env'):
        try:
            manager = GestorConexiones()
            if manager._fetchone_modulo('gestion', 'SELECT COUNT(*) FROM prueba_conexion WHERE id=3') != (0,):
                raise RuntimeError('Existe la fila de destino; no sobrescribir')
            interrupter = mysql.connector.connect(**configuracion_db('DB_GESTION', autocommit=True))
            connection_id = int(manager.conexion.connection_id)
            def interrupt():
                try:
                    time.sleep(1)
                    cursor = interrupter.cursor()
                    cursor.execute('KILL CONNECTION ' + str(connection_id))
                    cursor.close()
                except Exception:
                    errors.append('No se pudo interrumpir la conexion propia')
            worker = threading.Thread(target=interrupt)
            worker.start()
            try:
                manager._execute_commit_modulo('gestion', "INSERT INTO prueba_conexion (id,descripcion) SELECT 3,'escritura ficticia interrumpida' WHERE SLEEP(8)=0")
            except mysql.connector.Error:
                print('ESCRITURA_INTERRUMPIDA_ERROR_EXPLICITO', flush=True)
            else:
                raise RuntimeError('La escritura no se interrumpio')
            finally:
                worker.join(timeout=12)
            if errors or worker.is_alive():
                raise RuntimeError('No se confirmo la interrupcion propia')
            if manager._fetchone_modulo('gestion', 'SELECT COUNT(*) FROM prueba_conexion WHERE id=3') != (0,):
                raise RuntimeError('Escritura ambigua: revisar fila ficticia sin repetir')
            print('ESCRITURA_INTERRUMPIDA_SIN_REPETICION_NI_FILA_DUPLICADA', flush=True)
            print('RECUPERACION_POSTERIOR_PARA_NUEVA_OPERACION_OK', flush=True)
        finally:
            if manager is not None:
                manager.cerrar()
            if interrupter is not None:
                interrupter.close()


if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        print('ERROR_PRUEBA_INTERRUPCION ' + (str(error) if isinstance(error, RuntimeError) else type(error).__name__), flush=True)
        sys.exit(1)
