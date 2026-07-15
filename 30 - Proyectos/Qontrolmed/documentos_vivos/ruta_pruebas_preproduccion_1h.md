---
tags:
  - app
  - documentacion
Creado: 2026-06-24
Relacionado:
---

# Ruta de pruebas de preproduccion - 1 hora
[[masgesth]]
Fecha de preparacion: 2026-06-24

## Objetivo

Ejecutar una validacion corta y dirigida antes de abrir cambios funcionales de
campo. La prueba busca confirmar que `Qontrolmed` arranca con configuracion
canonica, login normal, acceso basico a modulos y rutas runtime correctas.

No sustituye una validacion completa de piloto. Es una puerta tecnica para
saber si podemos pasar con criterio al Paquete A de Preventivos.

## Preparacion previa

Tener a mano:

- equipo donde se ejecutara `Qontrolmed`;
- `compartido/.env` real o de prueba;
- usuario normal activo con contrasena;
- acceso a MySQL o confirmacion del entorno disponible;
- ruta de backup si se va a validar manifest;
- este documento y `docs/checklist_configuracion_preproduccion.md`.

No imprimir ni copiar secretos del `.env`.

## Minuto 0-5 - Estado inicial

Ejecutar desde la raiz del repo o carpeta de despliegue:

```powershell
git status --short --branch
Test-Path src\compartido\.env
Test-Path compartido\.env
```

Criterio:

- `src\compartido\.env` debe devolver `False`. PASA
- `compartido\.env` debe devolver `True`. PASA
- Si aparece `src\compartido\.env`, parar y resolver antes de seguir.

## Minuto 5-12 - Configuracion y carga de entorno

```powershell
python -c "import sys; sys.path.insert(0, 'src'); from compartido.utils.resources import env_path; print(env_path())"
python -c "import sys; sys.path.insert(0, 'src'); from compartido.configuracion import cargar_entorno_db; cargar_entorno_db(); print('entorno ok')"
```

Criterio:

- la ruta debe terminar en `compartido\.env`; PASA
- debe aparecer `entorno ok`; PASA
- no deben mostrarse credenciales.

## Minuto 12-20 - Validacion tecnica rapida

```powershell
python -m py_compile src\compartido\configuracion.py src\compartido\utils\resources.py
python -m compileall main.py src
```

Criterio:

- ambos comandos terminan sin error;PASA
- si falla `compileall`, registrar modulo y no abrir cambios de campo hasta
  entender la causa.

## Minuto 20-32 - Arranque y login

Arrancar la aplicacion de escritorio.

Validar manualmente:

- abre sin error de configuracion;
- login con usuario normal y contrasena;
- no se usa acceso sin contrasena;
- confirmar que `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0` queda como modo normal.

Criterio:

- si no hay login normal, la salida queda bloqueada; PASA
- si se requiere passwordless para entrar, registrar como incidencia y volver a
  configuracion/usuarios antes de seguir. PASA

## Minuto 32-42 - Gestion

En `Gestion`, validar:

- apertura del modulo;
- acceso a usuarios;
- acceso a roles o permisos segun perfil;
- ausencia de errores al consultar listados;
- comportamiento esperado si el usuario no tiene permiso para una vista.

Criterio:

- debe poder verificarse administracion basica de usuarios/roles con un perfil
  autorizado; PASA
- cualquier error de permisos o consulta queda como incidencia de preproduccion.

## Minuto 42-50 - Preventivos y Quirofanos

Validar:

- apertura basica de `Preventivos`; PASA
- carga inicial sin excepciones visibles; PASA
- apertura basica de `Quirofanos`; PASA
- carga inicial sin excepciones visibles. PASA

No ejecutar todavia cambios de campo ni pruebas de Paquete A. Esta pasada solo
confirma que los modulos siguen abriendo sobre la configuracion actual.

## Minuto 50-56 - Rutas runtime e intercambio

Comprobar que existen o se pueden crear rutas bajo:

- `C:\ProgramData\Qontrolmed\output\`;
- `C:\ProgramData\Qontrolmed\output\export_tablet\`.

Verificar que el intercambio movil no depende de:

- `src/export_tablet/`.

Criterio:

- rutas runtime fuera del codigo fuente;
- no se generan `.env`, backups ni artefactos sensibles dentro de `docs/`,
  `src/`, `dist/` o `build/`. 

## Minuto 56-60 - Cierre y decision

Registrar resultado:

- fecha y equipo; 2026-06-24
- entorno usado; raiz del repositorio
- usuario/perfil usado, sin contrasena; M.Hortet y D.Hortet
- comandos ejecutados; Todos los disponibles
- modulos validados;Gestión, quirófanos y Preventivos
- incidencias;
- decision final. PASA

Decision:

- `PASA`: se puede abrir analisis tecnico del Paquete A de Preventivos.
- `PASA CON OBSERVACIONES`: se puede analizar Paquete A, pero no implementar
  hasta cerrar incidencias de configuracion/login/rutas.
- `NO PASA`: no abrir cambios de campo; resolver primero preproduccion.

## Plantilla de resultado

```text
Fecha: 2026-06-24
Equipo/entorno: PC SPBREMESA COMPILADO
Base de datos: gestion/preventivos/quirofanos
Usuario/perfil: M.Hortet / Superusuario

Precheck .env: PASA
Carga entorno: PASA
Compile: no arrastra compartido/.env ni icono1.ico
Login:  PASA
Gestion: PASA
Preventivos: PASA
Quirofanos: PASA
Rutas runtime: PASA
Backup/manifest, si aplica: PENDIENTE EXTERNO

Resultado: PASA / PASA CON OBSERVACIONES / NO PASA
Incidencias:
Decision siguiente:
```

## Prueba opcional si hay backup disponible

Si hay export MySQL disponible y tiempo dentro de la hora:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\db\registrar_backup_mysql.ps1 `
  -BackupPath "E:\backup_mysql_YYYY-MM-DD_HH-mm_completa" `
  -OutputDir "output\backup_mysql" `
  -ExpectedDatabases gestion,quirofanos,preventivos `
  -MaxAgeHours 6
```

Si no hay backup disponible, dejarlo registrado como pendiente externo. No debe
bloquear esta prueba corta si el objetivo inmediato es decidir si se abre el
analisis tecnico del Paquete A.
