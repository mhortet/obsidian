# Checklist de configuracion y preproduccion
[[masgesth]]
Fecha de revisión: 2026-07-16

## Objetivo

Fijar una receta unica para configurar `Qontrolmed` antes de piloto o
produccion controlada, evitando la doble ruta historica de `.env` y separando
uso normal, soporte, backup, restauracion y validacion funcional minima.

## Estado validado

Validacion local de 2026-06-24:

- `src/compartido/.env`: no existe.
- `compartido/.env`: existe.
- `env_path()` resuelve `D:\trabajo\Proyectos\maxgesth\compartido\.env`.
- `cargar_entorno_db()` carga el entorno sin imprimir secretos.
- `python -m py_compile src\compartido\configuracion.py src\compartido\utils\resources.py`: correcto.
- `python -m compileall main.py src`: correcto.
- Separacion validada el 2026-07-14 para ejecutable congelado:
  - aplicacion y recursos bajo `C:\Program Files\Qontrolmed`;
  - configuracion bajo `C:\ProgramData\Qontrolmed\config\.env`;
  - salidas bajo `C:\ProgramData\Qontrolmed\output`;
  - certificados bajo `C:\ProgramData\Qontrolmed\docs\certificados`.
- RC técnica `2026.07.15-rc4` generada sin `.env` real, con manifiesto
  SHA-256, recursos PDF y bootstrap limpio del administrador inicial.
- Instalación completa desde cero validada el 2026-07-16:
  - scripts SQL ejecutados correctamente;
  - esquemas y aplicación instalados sin incidencias funcionales;
  - bootstrap de `administrador` correcto, con solicitud de primera contraseña;
  - acceso a la aplicación y creación de nuevos usuarios correctos;
  - informes de Quirófanos y Preventivos generados en las rutas previstas;
  - exportación CSV correcta, con advertencia sobre posible contenido sensible
    y selección de ruta de destino.
- Incidencia operativa observada en RC4: para crear o actualizar el `.env` fue
  necesario modificar permisos y propiedad. RC5 sustituye ese procedimiento
  por un configurador administrativo y la creacion real ya se ha validado sin
  incidencias.

## Decision vigente

- Ruta canonica en desarrollo:
  - `compartido/.env`
- Ruta canonica en ejecutable congelado:
  - `C:\ProgramData\Qontrolmed\config\.env`
- Ruta antigua de desarrollo:
  - `src/compartido/.env`
- La aplicacion conserva `compartido/.env` en desarrollo y separa configuracion,
  datos y binarios en el ejecutable congelado.
- Si no existe `compartido/.env` pero si existe `src/compartido/.env`, el
  arranque debe informar de la ruta antigua y pedir migracion manual.
- `main.spec` no contiene ni empaqueta el `.env` real.
- `.env.example` se entrega solo como plantilla sin credenciales.
- La instalacion inicial no sobrescribe instalaciones existentes.

## Variables obligatorias

El fichero canonico correspondiente al modo de ejecucion debe contener:

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
- Mantener al menos un usuario activo con contrasena.
- Tratar la creación o modificación del `.env` instalado como tarea
  administrativa; los usuarios normales solo deben poder leerlo.
- No editar ni recrear `src/compartido/.env`.
- No versionar `.env` reales.
- No guardar copias de `.env` dentro de `docs/`, `output/`, `dist/`, backups
  documentales ni carpetas de intercambio con tablet.

## Uso de soporte o bootstrap

- Activar `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=1` solo durante una ventana
  controlada.
- Usarlo solo para soporte, restauracion o validacion de bootstrap.
- Volver a `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0` al terminar.
- Registrar la actuacion en el diario de sesion si afecta a acceso,
  restauracion o credenciales.

## Precheck de instalacion

Ejecutar desde la raiz del repo o desde la carpeta de despliegue equivalente.
No imprimir el contenido del `.env`.

```powershell
git status --short --branch
Test-Path src\compartido\.env
Test-Path compartido\.env
python -c "import sys; sys.path.insert(0, 'src'); from compartido.utils.resources import env_path; print(env_path())"
python -c "import sys; sys.path.insert(0, 'src'); from compartido.configuracion import cargar_entorno_db; cargar_entorno_db(); print('entorno ok')"
```

Criterio esperado:

- `Test-Path src\compartido\.env` debe devolver `False`.
- `Test-Path compartido\.env` debe devolver `True`.
- La ruta impresa debe terminar en `compartido\.env`.
- La carga debe terminar con `entorno ok`.

Si `src\compartido\.env` existe, parar la instalacion y migrar su contenido
manualmente a `compartido\.env` antes de continuar. No copiarlo a documentacion
ni al control de versiones.

Para la RC instalada, ejecutar tambien:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\configurar_qontrolmed_env.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\verificar_qontrolmed_rc.ps1
```

El primer script crea o edita el `.env` desde un proceso elevado y restaura al
cerrar el propietario y las ACL previstas. La verificacion exige el `.env` en
`ProgramData`, comprueba las variables sin mostrar sus valores, valida
propietario y permisos, rechaza un `.env` junto al ejecutable y prueba escritura
en la carpeta compartida de salida.

Si el `.env` no puede crearse o modificarse desde una consola o editor elevado:

- registrar la incidencia y la identidad propietaria observada;
- no dejar Usuarios con permisos de modificación sobre `config` o `.env`;
- restaurar control total para Administradores y `SYSTEM`, y lectura para
  Usuarios;
- repetir la verificación como usuario normal;
- considerar la instalación no cerrada hasta validar lectura sin capacidad de
  modificación.

## Checklist de instalacion minima

- En desarrollo, crear `compartido/.env` a partir de `.env.example`.
- En la RC, crear o actualizar `C:\ProgramData\Qontrolmed\config\.env` mediante
  `scripts\configurar_qontrolmed_env.ps1` desde un proceso elevado.
- No migrar certificados ni salidas del entorno de desarrollo: son ejemplos y
  no son validos para el piloto. Todos los PDF existentes son pruebas
  funcionales sinteticas y no deben tratarse como documentacion real.
- Confirmar que `C:\ProgramData\Qontrolmed\output` y
  `C:\ProgramData\Qontrolmed\docs\certificados` comienzan vacios.
- Revisar que `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0`.
- Confirmar conexion a los tres esquemas:
  - `gestion`;
  - `quirofanos`;
  - `preventivos`.
- Confirmar que el servidor MySQL objetivo es compatible con las migraciones
  previstas. Referencia actual: `MySQL 8.4.9`.
- Confirmar que las salidas de la RC resuelven bajo
  `C:\ProgramData\Qontrolmed\output` y no dentro de `Program Files`.
- Confirmar que un usuario normal puede leer el `.env`, pero no modificarlo.
- Confirmar que `dist/`, `build/`, caches, logs y artefactos Android no entran
  en commits.

Validacion manual comunicada el 2026-07-17 sobre RC5:

- instalacion completada sin incidencias;
- `.env` creado correctamente mediante el procedimiento administrativo;
- PDF generados en las rutas previstas;
- ACL generales y accesos funcionales por permisos ya validados en RC3/RC4;
- no es necesario repetir la matriz completa porque RC5 no cambia login, roles
  ni autorizacion;
- regresion ACL de RC5 confirmada con usuario Windows normal: puede ejecutar la
  aplicacion y no puede modificar los binarios ni la configuracion;
- el permiso de lectura tecnica minima del `.env` se mantiene porque la
  aplicacion necesita cargar la configuracion con el mismo usuario.

## Backup previo obligatorio

Antes de piloto, migracion o produccion controlada debe existir un backup
logico de los esquemas `gestion`, `quirofanos` y `preventivos`.

1. Crear el backup con la herramienta definida para el entorno cliente
   (`mysqldump`, MySQL Workbench, tarea programada corporativa o herramienta
   del DBA). El resultado debe conservar ficheros identificables por esquema.
2. Guardar el export en una ubicacion externa al repo, por ejemplo
   `E:\backup_mysql_YYYY-MM-DD_HH-mm_completa`.
3. Registrar manifest y hashes con el script existente:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\db\registrar_backup_mysql.ps1 `
  -BackupPath "E:\backup_mysql_YYYY-MM-DD_HH-mm_completa" `
  -OutputDir "output\backup_mysql" `
  -ExpectedDatabases gestion,quirofanos,preventivos `
  -MaxAgeHours 6
```

4. Revisar el Markdown generado en `output\backup_mysql\backup_manifest_*.md`.
5. Duplicar el backup en una segunda ubicacion segura.
6. No borrar el export original hasta validar una restauracion de prueba y el
   arranque de la app.

Criterio de aceptacion:

- El manifest detecta los tres esquemas esperados.
- La evidencia mas reciente esta dentro de la ventana acordada.
- Existe CSV con hash SHA256 por fichero.
- El backup no queda dentro de `docs/`, `dist/`, `build/` ni carpetas de
  intercambio con tablet.

Evidencia de 2026-07-17:

- backup: `E:\backup_mysql_2026-07-17_completa`;
- tres ficheros SQL y 0,74 MiB registrados;
- cobertura de `gestion`, `quirofanos` y `preventivos`: `ok`;
- frescura: `ok`, 0,18 horas en el momento del registro;
- manifiesto y CSV SHA-256 generados en `output\backup_mysql`;
- segunda copia verificada en `K:\backup_mysql_2026-07-17_completa`: tres de
  tres ficheros, tamanos y SHA-256 coincidentes;
- restauracion individual con MySQL Workbench completada sin errores en
  `gestion_restore`, `quirofanos_restore` y `preventivos_restore`;
- dumps revisados sin `CREATE/DROP DATABASE`, `USE` ni referencias calificadas
  a los esquemas originales;

Resultado final comunicado el 2026-07-17:

- tablas y registros restaurados correctamente;
- Qontrolmed configurado temporalmente contra los tres esquemas `_restore`;
- login y apertura de `Gestion`, Preventivos y Quirofanos: correctos;
- muestra funcional de 4 o 5 accesos por cada UI: correcta;
- configuracion operativa restaurada al terminar;
- ensayo aceptado como smoke test representativo, no como comprobacion del
  100 % de enlaces.

## Restauracion de prueba

La restauracion debe ensayarse en esquemas de prueba, nunca directamente sobre
produccion como primera validacion.

1. Preparar carpetas por esquema si el backup viene dividido en ficheros
   `gestion_*.sql`, `quirofanos_*.sql` y `preventivos_*.sql`:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\db\preparar_restore_por_esquema.ps1 `
  -BackupPath "E:\backup_mysql_YYYY-MM-DD_HH-mm_completa" `
  -OutputDir "output\restore_mysql_preparado" `
  -GestionTarget "gestion_restore" `
  -QuirofanosTarget "quirofanos_restore" `
  -PreventivosTarget "preventivos_restore"
```

2. Generar scripts SQL de restauracion por esquema:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\db\generar_restore_sql_por_esquema.ps1 `
  -BackupPath "E:\backup_mysql_YYYY-MM-DD_HH-mm_completa" `
  -OutputDir "output\restore_mysql_scripts" `
  -GestionTarget "gestion_restore" `
  -QuirofanosTarget "quirofanos_restore" `
  -PreventivosTarget "preventivos_restore"
```

3. Ejecutar los SQL generados contra una instancia MySQL de prueba con un
   usuario autorizado.
4. Crear temporalmente el `.env` canonico del modo probado para que apunte a
   `gestion_restore`, `quirofanos_restore` y `preventivos_restore`.
5. Ejecutar el precheck de configuracion y la smoke test minima.
6. Restaurar el `compartido/.env` operativo al terminar y confirmar de nuevo
   `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0`.

Criterio de aceptacion:

- Los tres esquemas restaurados existen y contienen tablas esperadas.
- Login, Gestion, Preventivos y Quirofanos abren contra la restauracion.
- La prueba queda registrada en diario o acta tecnica con fecha, backup usado,
  destino restaurado y resultado.

## Validacion tecnica

Si solo cambia configuracion o packaging:

```powershell
python -m py_compile src\compartido\configuracion.py src\compartido\utils\resources.py
```

Si cambia cualquier flujo de aplicacion relacionado:

```powershell
python -m compileall main.py src
```

## Smoke test minima de salida controlada

Ejecutar con base real o restauracion de prueba validada:

- Arrancar la aplicacion de escritorio sin errores de configuracion.
- Iniciar sesion con usuario normal y contrasena.
- Confirmar que no se usa acceso passwordless en entorno normal.
- Abrir `Gestion`.
- Consultar usuarios y roles segun permisos del usuario.
- Abrir `Preventivos` y comprobar carga inicial sin excepciones.
- Abrir `Quirofanos` y comprobar carga inicial sin excepciones.
- Verificar que se pueden crear o usar las rutas runtime compartidas.
- Generar al menos un informe de Quirófanos y uno de Preventivos, y comprobar
  que ambos se publican en las rutas previstas.
- Exportar el CSV de auditoría y comprobar que advierte de la posible inclusión
  de datos sensibles y solicita la ruta de destino.
- Verificar que el intercambio movil usa
  `C:\ProgramData\Qontrolmed\output\export_tablet` en la RC y no rutas de
  codigo fuente.
- Cerrar la aplicacion y revisar que no se han generado `.env`, backups ni
  artefactos sensibles dentro de rutas versionables.

## Criterios de no salida

No iniciar piloto ni produccion controlada si se cumple cualquiera de estos
puntos:

- Existe `src/compartido/.env` en el entorno de entrega.
- Falta el `.env` canonico para el modo de ejecucion.
- La configuración requiere mantener un propietario anómalo o permisos de
  escritura para Usuarios después de completar la instalación.
- `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=1` queda activo fuera de una ventana de
  soporte documentada.
- No hay backup reciente de `gestion`, `quirofanos` y `preventivos`.
- No se ha ensayado restauracion en entorno de prueba.
- Falla login normal o apertura basica de `Gestion`, `Preventivos` o
  `Quirofanos`.
- Las rutas runtime apuntan a ubicaciones versionables, a `Program Files` o a
  carpetas documentales del repositorio.
- Aparecen certificados, informes o intercambios de ejemplo dentro de
  `ProgramData`.

## Riesgos residuales

- Puede existir todavia un `src/compartido/.env` local antiguo en otros equipos.
  No debe usarse como fuente de verdad.
- Si aparece un `.env` real dentro de un paquete de despliegue, rechazar el
  paquete y regenerarlo; no distribuirlo como material sensible.
- El ejecutable RC actual no esta firmado digitalmente. La firma debe resolverse
  antes de produccion si la politica de la organizacion o el control de
  aplicaciones la exige.
- Cualquier cambio de credenciales requiere repetir precheck, smoke test de
  login y conexion a los tres esquemas.
- RC5 permite crear el `.env` correctamente en la instalacion real validada.
  La regresion con usuario normal confirma ejecucion de la aplicacion y
  denegacion de modificacion sobre binarios y configuracion.
- La politica final de retencion de backup y auditoria depende todavia del
  entorno cliente.
