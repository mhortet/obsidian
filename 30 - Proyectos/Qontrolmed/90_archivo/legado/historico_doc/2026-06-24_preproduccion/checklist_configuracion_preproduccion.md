# Checklist de configuracion y preproduccion
[[masgesth]]
Fecha de revision: 2026-06-23

## Objetivo

Fijar una receta unica para configurar `Qontrolmed` antes de piloto o
produccion controlada, evitando la doble ruta historica de `.env` y separando
uso normal, soporte y validacion.

## Decision vigente

- Ruta canonica del entorno real:
  - `compartido/.env`
- Ruta antigua de desarrollo:
  - `src/compartido/.env`
- La aplicacion ya resuelve `compartido/.env` tanto en desarrollo como en
  ejecutable congelado.
- Si no existe `compartido/.env` pero si existe `src/compartido/.env`, el
  arranque debe informar de la ruta antigua y pedir migracion manual.
- `main.spec` empaqueta el `.env` real desde `compartido/.env` y deja
  `.env.example` como referencia en la misma carpeta de despliegue.

## Variables obligatorias

El fichero `compartido/.env` debe contener:

```env
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=maxgesth_user
DB_PASSWORD=change-me
DB_GESTION=gestion
DB_QUIROFANOS=quirofanos
DB_PREVENTIVOS=preventivos
QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0
```

`DB_PASSWORD` puede quedar vacio solo si el usuario MySQL real esta preparado
para ello. La variable debe existir igualmente para evitar configuraciones
ambiguas.

## Uso normal

- Mantener `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0`.
- Mantener un usuario activo con contrasena.
- No editar `src/compartido/.env`.
- No versionar `.env` reales.
- No guardar copias de `.env` dentro de `docs/`, `output/`, `dist/` ni
  carpetas de intercambio con tablet.

## Uso de soporte o bootstrap

- Activar `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=1` solo durante una ventana
  controlada.
- Usarlo solo para soporte, restauracion o validacion de bootstrap.
- Volver a `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0` al terminar.
- Registrar la actuacion en el diario de sesion si afecta a acceso o
  restauracion.

## Checklist de instalacion minima

- Crear carpeta `compartido/` junto al ejecutable o en la raiz del repo de
  desarrollo.
- Crear `compartido/.env` a partir de `.env.example`.
- Confirmar conexion a los tres esquemas:
  - `gestion`;
  - `quirofanos`;
  - `preventivos`.
- Confirmar que el servidor MySQL objetivo es compatible con las migraciones
  previstas. Referencia actual: `MySQL 8.4.9`.
- Confirmar que `output/` y `export_tablet/` son rutas runtime y no entran en
  control de versiones.
- Confirmar que `dist/`, `build/`, caches y artefactos Android no entran en
  commits.

## Validacion tecnica

Si solo cambia configuracion o packaging:

```powershell
python -m py_compile src\compartido\configuracion.py src\compartido\utils\resources.py
```

Si cambia cualquier flujo de aplicacion relacionado:

```powershell
python -m compileall main.py src
```

Validacion manual minima:

- abrir la aplicacion;
- comprobar login normal;
- comprobar que `Gestion` carga usuarios o roles segun permisos;
- comprobar que no aparece acceso passwordless en entorno normal;
- comprobar que los errores de configuracion muestran la ruta canonica.

## Backup y restauracion

Antes de piloto o produccion controlada:

- disponer de backup de `gestion`, `quirofanos` y `preventivos`;
- documentar comando o herramienta usada;
- ensayar restauracion en entorno de prueba;
- validar login y apertura basica tras restaurar;
- registrar migraciones aplicadas y pendientes.

## Riesgos residuales

- Puede existir todavia un `src/compartido/.env` local antiguo. No debe usarse
  como fuente de verdad.
- Si el `.env` real se copia dentro de un paquete de despliegue, tratar ese
  paquete como material sensible.
- Cualquier cambio de credenciales requiere repetir smoke test de login y
  conexion a los tres esquemas.
