"""Integracion de servicios de negocio reales con datos ficticios, sin UI."""
import json
from pathlib import Path
import sys
from unittest.mock import patch

PROJECT = Path(__file__).with_name('qontrolmed-piloto')
sys.path.insert(0, str(PROJECT / 'src'))
from compartido.conexion import Comunicacion
from compartido.autorizacion import es_superusuario, tiene_permiso
from Compras.services.usuarios_service import autenticar_usuario
from Compras.services import marcas_service
from Quirofanos.services import equipos_medida_service
from preventivos.services import semillas_service
from preventivos.services.informes_preventivo_service import obtener_campana_activa


def main():
    issues = []
    directory = Path(sys.argv[1])
    credentials = json.loads((directory / 'usuario-aplicacion-piloto.json').read_text(encoding='utf-8'))
    with patch('compartido.configuracion.env_path', return_value=directory / '.env'), patch('compartido.db.messagebox.showinfo'):
        db = Comunicacion()
        try:
            db.usuario_actual = autenticar_usuario(db, credentials['usuario'], credentials['password'])
            if not db.usuario_actual or not es_superusuario(db) or not tiene_permiso(db, 'preventivos.informes_editar'):
                raise RuntimeError('Sesion o permisos funcionales incorrectos')
            print('AUTENTICACION_Y_ROL_FUNCIONAL_OK', flush=True)
            brand = 'PILOTO MARCA FICTICIA 20261105'
            if any(row[1] == brand for row in marcas_service.listar_marcas(db)):
                raise RuntimeError('La marca ficticia ya existe; no sobrescribir')
            try:
                marcas_service.guardar_marca(db, brand, id_marca='1207')
            except Exception as error:
                if getattr(error, 'errno', None) != 1364:
                    raise
                issues.append('Gestion: campo ID sin valor predeterminado (1364)')
                print('GESTION_INCOMPATIBILIDAD_ESQUEMA_CODIGO_1364', flush=True)
            else:
                row = next(row for row in marcas_service.listar_marcas(db) if row[1] == brand)
                marcas_service.modificar_marca(db, str(row[0]), brand + ' VERIFICADA')
                if marcas_service.buscar_marca_por_id(db, str(row[0]))[1] != brand + ' VERIFICADA':
                    raise RuntimeError('Flujo de marca no verificado')
                print('GESTION_SERVICIO_CREAR_CONSULTAR_MODIFICAR_MARCA_OK', flush=True)
            name = 'PILOTO INSTRUMENTO FICTICIO 20261105'
            data = (name, 'PILOTO', 'MODELO FICTICIO', 'PILOTO-20261105', '2026-11-01', '2027-11-01', 6, None)
            existing = [row for row in equipos_medida_service.listar_equipos(db) if row[1] == name]
            if existing:
                if len(existing) != 1 or existing[0][4] != 'PILOTO-20261105' or existing[0][3] != 'MODELO VERIFICADO' or existing[0][8] != 0:
                    raise RuntimeError('Instrumento ficticio previo inesperado')
                equipment = existing[0]
            else:
                equipos_medida_service.crear_equipo(db, data)
                equipment = next(row for row in equipos_medida_service.listar_equipos(db) if row[1] == name)
                updated = (name, 'PILOTO', 'MODELO VERIFICADO', *data[3:])
                equipos_medida_service.actualizar_equipo(db, equipment[0], updated)
                equipos_medida_service.cambiar_activo(db, equipment[0])
            result = next(row for row in equipos_medida_service.listar_equipos(db) if row[0] == equipment[0])
            if result[3] != 'MODELO VERIFICADO' or result[8] != 0:
                raise RuntimeError('Flujo de instrumento no verificado')
            print('QUIROFANOS_SERVICIO_CREAR_MODIFICAR_DESACTIVAR_INSTRUMENTO_OK', flush=True)
            point = {'tipo': 'CUALITATIVO', 'codigo': 'PILOTO-001', 'descripcion': 'Punto sintetico de ensayo', 'orden': 10}
            first = semillas_service.obtener_o_crear_punto(db, point)
            second = semillas_service.obtener_o_crear_punto(db, point)
            if not first or first != second:
                raise RuntimeError('Idempotencia de punto no verificada')
            if db._fetchone_modulo('preventivos', 'SELECT COUNT(*) FROM puntos_control WHERE codigo=%s', ('PILOTO-001',)) != (1,):
                raise RuntimeError('Punto ficticio duplicado')
            if obtener_campana_activa(db) is not None:
                raise RuntimeError('Campana inesperada en el piloto vacio')
            print('PREVENTIVOS_SERVICIO_PUNTO_IDEMPOTENTE_Y_CAMPANA_VACIA_OK', flush=True)
            if issues:
                raise RuntimeError('Servicios parcialmente verificados; ' + '; '.join(issues))
            print('SERVICIOS_FUNCIONALES_PILOTO_COMPLETADOS', flush=True)
        finally:
            db.cerrar()


if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        print('ERROR_SERVICIOS_FUNCIONALES ' + (str(error) if isinstance(error, RuntimeError) else type(error).__name__), flush=True)
        if hasattr(error, 'errno'):
            print('CODIGO_MYSQL=' + str(error.errno), flush=True)
        sys.exit(1)
