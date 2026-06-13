---
tags:
  - SQL
  - software
Creado: 2026-06-12
Autor:
Relacionado:
  - "[[masgesth]]"
---
## Resumen
migrar MySQL a versión actualizada

## Objetivo

Dejar claro que scripts SQL hay que ejecutar manualmente, en que orden
conviene hacerlo y cuales pueden esperar sin romper la operativa actual.

## Regla general

En este proyecto los scripts de `bd/` no se ejecutan solos al abrir la
aplicacion.

Hay dos tipos de fichero:

- `bd/<tabla>.sql`: definicion base o estructura completa de una tabla.
- `bd/migracion_<algo>.sql`: cambio incremental pensado para ejecutarse a mano
  sobre una base ya existente.

Por tanto, si aparece una migracion nueva, hay que lanzarla manualmente en la
base de datos correspondiente cuando decidas abrir esa ventana de mantenimiento.

## Comprobacion previa obligatoria

Antes de ejecutar una migracion nueva sobre `gestion`, `quirofanos` o
`preventivos`, revisar y anotar:

- version exacta del servidor MySQL o MariaDB;
- si esa version soporta la sintaxis usada por la migracion;
- si hace falta adaptar el script o planificar una actualizacion del servidor
  antes de ejecutarlo en entorno real.

Caso abierto actual:

- la migracion `docs/migracion_centros_gestion.sql` ha obligado a revisar la
  compatibilidad por error de sintaxis con `ADD COLUMN IF NOT EXISTS`;
- la version real del servidor queda confirmada el `2026-06-12` como
  `MySQL 8.0.44`;
- la decision operativa vigente pasa a ser preparar la evolucion a
  `MySQL 8.4 LTS` antes de abrir una nueva tanda principal de roles/permisos o
  de ampliaciones de esquema sobre `gestion`.

## Orden recomendado ahora mismo

### 1. Preparar la evolucion del servidor

Antes de nuevas migraciones relevantes sobre `gestion`, conviene:

- preparar backup completo;
- restaurar en entorno seguro;
- validar arranque de la app contra `MySQL 8.4 LTS`;
- ejecutar una prueba funcional minima sobre `Gestion`, `Preventivos` y
  `Quirofanos`.

Referencia operativa:

- `docs/plan_upgrade_mysql_8_0_44_a_8_4_lts.md`

### 2. Sin tocar mas BD de negocio, operativa valida de corto plazo

Mientras llega esa ventana de upgrade, se puede seguir trabajando si:

- el login funciona bien;
- `es_tecnico = 1` y `es_tecnico = 0` ya cubren la operativa actual;
- no necesitas todavia activar permisos finos por rol;
- no abres una nueva tanda grande de cambios de esquema.

### 3. Primera migracion recomendada despues del upgrade o en ventana muy controlada

Ejecutar en la base `gestion`:

- `bd/migracion_gestion_auditoria.sql`

Motivo:

- no afecta a `roles`;
- no cambia selectores de tecnicos;
- solo crea la tabla `auditoria_eventos`;
- a partir de ahi empezaran a guardarse logs de login y cambios de usuarios.

Validacion minima:

```sql
SHOW TABLES LIKE 'auditoria_eventos';
SELECT * FROM auditoria_eventos ORDER BY id DESC;
```

### 4. Migracion de roles explicitos, despues de estabilizar `8.4 LTS`

Ejecutar en la base `gestion`:

- `bd/migracion_gestion_roles.sql`

Motivo:

- esta migracion ya da el paso de dejar el rol explicito en BD;
- hoy no es necesaria para operar porque la app puede seguir interpretando:
  - `es_tecnico = 1` como `Tecnico`;
  - `es_tecnico = 0` como `Administrador`.

Validacion minima:

```sql
SHOW COLUMNS FROM usuarios LIKE 'rol';
SELECT idUsuario, Nombre, es_tecnico, rol FROM usuarios ORDER BY Nombre;
```

## Que fichero usar en cada caso

### Si la tabla no existe y solo quieres crearla

Usar normalmente la migracion:

- `bd/migracion_gestion_auditoria.sql`

### Si necesitas revisar la estructura completa de referencia

Consultar:

- `bd/gestion_auditoria_eventos.sql`

Ese fichero describe la tabla final, pero no implica ejecucion automatica.

## Resumen corto

- nada de `bd/` se lanza solo desde la app;
- las migraciones se ejecutan a mano en MySQL;
- antes de migrar, revisar version del servidor y compatibilidad del script;
- la prioridad operativa actual ya no es `roles`, sino subir de
  `MySQL 8.0.44` a `MySQL 8.4 LTS`;
- despues del upgrade, primer paso recomendado: `migracion_gestion_auditoria.sql`;
- dejar `migracion_gestion_roles.sql` para una ventana posterior.
