"""Harness de UI exclusivo del piloto: autentica por servicio, no automatiza login."""
import json
import os
from pathlib import Path
import secrets
import sys
from unittest.mock import patch

PROJECT = Path(__file__).with_name('qontrolmed-piloto')
sys.path.insert(0, str(PROJECT / 'src'))
sys.path.insert(1, str(PROJECT))
RUNTIME = Path(os.environ['LOCALAPPDATA']) / 'Qontrolmed-Piloto-20261105'


def main():
    from compartido.conexion import Comunicacion
    from Compras.services.usuarios_service import (
        autenticar_usuario, bootstrap_password_usuario,
        hay_usuarios_con_password, resolver_bootstrap_login,
    )
    with patch('compartido.configuracion.env_path', return_value=RUNTIME / '.env'):
        db = Comunicacion()
        try:
            credential_file = RUNTIME / 'usuario-aplicacion-piloto.json'
            if not hay_usuarios_con_password(db):
                state = resolver_bootstrap_login(db)
                candidates = state.get('candidatos', [])
                if len(candidates) != 1 or candidates[0].get('usuario') != 'administrador':
                    raise RuntimeError('No hay un unico administrador ficticio para inicializar')
                if credential_file.exists():
                    saved = json.loads(credential_file.read_text(encoding='utf-8'))
                    if saved.get('usuario') != 'administrador' or not saved.get('password'):
                        raise RuntimeError('Credencial de prueba inesperada')
                    password = saved['password']
                else:
                    password = secrets.token_urlsafe(32)
                    # Guardar solo en directorio protegido, nunca repositorio.
                    credential_file.write_text(json.dumps({'usuario': 'administrador', 'password': password}), encoding='utf-8')
                bootstrap_password_usuario(db, candidates[0]['id'], password)
                print('BOOTSTRAP_APLICACION_FICTICIA_OK', flush=True)
            credential = json.loads(credential_file.read_text(encoding='utf-8'))
            if autenticar_usuario(db, credential['usuario'], credential['password'] + '-incorrecta') is not None:
                raise RuntimeError('Se acepto una clave incorrecta')
            user = autenticar_usuario(db, credential['usuario'], credential['password'])
            if not user:
                raise RuntimeError('Autenticacion del servicio no valida')
            db.usuario_actual = user
            print('SERVICIO_AUTENTICACION_CORRECTA_E_INCORRECTA_VERIFICADO', flush=True)
            import src.main as application
            application.APP_TITLE = 'Qontrolmed - PILOTO FICTICIO'
            # Solo para este proceso de test: la sesion ya ha sido autenticada
            # por el servicio real. El dialogo de login no se automatiza ni prueba.
            with patch.object(application, 'Comunicacion', return_value=db), patch.object(
                application, 'solicitar_login', return_value=True
            ):
                print('ABRIENDO_INTERFAZ_CON_SESION_DE_PRUEBA_AUTENTICADA', flush=True)
                application.main()
        finally:
            db.cerrar()


if __name__ == '__main__':
    try:
        main()
    except Exception as error:
        print('ERROR_PILOTO_GUI ' + (str(error) if isinstance(error, RuntimeError) else type(error).__name__), flush=True)
        sys.exit(1)
