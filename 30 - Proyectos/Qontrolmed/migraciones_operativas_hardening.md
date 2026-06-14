# Migraciones operativas de hardening
[[masgesth]]
Fecha de revision: 2026-06-14

## Objetivo

Dejar claro que scripts SQL hay que ejecutar manualmente, en que orden
conviene hacerlo y cuales pueden esperar sin romper la operativa actual.

## Regla general

En este proyecto los scripts de `bd/` no se ejecutan solos al abrir la
aplicacion.

Hay dos tipos de fichero:

- `bd/base/<tabla>.sql`: definicion base o estructura completa de una tabla.
- `bd/migraciones/migracion_<algo>.sql`: cambio incremental pensado para ejecutarse a mano
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

- la migracion `bd/migraciones/migracion_centros_gestion.sql` ha obligado a revisar la
  compatibilidad por error de sintaxis con `ADD COLUMN IF NOT EXISTS`;
- la version real del servidor queda ya confirmada el `2026-06-13` como
  `MySQL 8.4.9`;
- el upgrade operativo desde `8.0.44` ya se ha completado y validado con
  apertura correcta de la app;
- aprendizaje a no olvidar en futuras subidas a `8.4+`:
  revisar el `plugin` de autenticacion de los usuarios de aplicacion, porque el
  entorno requirio migrar `administrador@%` a `caching_sha2_password`.

## Orden recomendado ahora mismo

### 1. Servidor ya estabilizado en `MySQL 8.4.9`

La preparacion principal de infraestructura ya no esta pendiente. Antes de
nuevas migraciones relevantes sobre `gestion`, conviene:

- conservar backup verificado y referencia de restauracion;
- revisar compatibilidad concreta del SQL nuevo contra `8.4.9`;
- ejecutar una prueba funcional minima sobre `Gestion`, `Preventivos` y
  `Quirofanos`.

Referencia operativa:

- `docs/plan_upgrade_mysql_8_0_44_a_8_4_lts.md`

### 2. Sin tocar mas BD de negocio, operativa valida de corto plazo

Mientras no haga falta una migracion nueva, se puede seguir trabajando si:

- el login funciona bien;
- `es_tecnico = 1` y `es_tecnico = 0` ya cubren la operativa actual;
- la base actual ya sostiene el primer corte de permisos por rol implantado;
- no abres una nueva tanda grande de cambios de esquema.

### 3. Auditoria en entornos donde aun falte

Ejecutar en la base `gestion`:

- `bd/migraciones/migracion_gestion_auditoria.sql`

Motivo:

- no afecta a `roles`;
- no cambia selectores de tecnicos;
- solo crea la tabla `auditoria_eventos`;
- a partir de ahi empezaran a guardarse logs de login y cambios de usuarios.

Nota:

- en el entorno principal de trabajo esta linea ya queda operativa y validada;
- este paso sigue siendo relevante para replicas, restauraciones o entornos
  nuevos donde la tabla aun no exista.

Validacion minima:

```sql
SHOW TABLES LIKE 'auditoria_eventos';
SELECT * FROM auditoria_eventos ORDER BY id DESC;
```

### 4. Migracion de roles explicitos, solo si hace falta el puente textual

Ejecutar en la base `gestion`:

- `bd/migraciones/migracion_gestion_roles.sql`

Motivo:

- esta migracion ya da el paso de dejar el rol explicito en BD;
- hoy no es necesaria para operar porque la app puede seguir interpretando:
  - `es_tecnico = 1` como `Tecnico`;
  - `es_tecnico = 0` como base no tecnica legacy.

Validacion minima:

```sql
SHOW COLUMNS FROM usuarios LIKE 'rol';
SELECT idUsuario, Nombre, es_tecnico, rol FROM usuarios ORDER BY Nombre;
```

### 5. Base del modelo final de roles y permisos, en ventana controlada

Ejecutar en la base `gestion`:

- `bd/migraciones/migracion_gestion_roles_permisos_base.sql`

Alcance:

- crea `roles`;
- crea `permisos`;
- crea `roles_permisos`;
- anade `usuarios.id_rol`;
- siembra roles reservados y permisos base.

Criterio:

- este es el primer paso real hacia el modelo final `usuario -> rol -> permisos`;
- no sustituye todavia toda la logica actual basada en `es_tecnico`;
- no exige haber ejecutado antes `bd/migraciones/migracion_gestion_roles.sql`;
- no hace aun la migracion funcional completa de usuarios existentes a
  `id_rol`.

Validacion minima:

```sql
SHOW TABLES LIKE 'roles';
SHOW TABLES LIKE 'permisos';
SHOW TABLES LIKE 'roles_permisos';
SHOW COLUMNS FROM usuarios LIKE 'id_rol';
SELECT codigo, nombre, acceso_total, tecnico_campo FROM roles ORDER BY id;
SELECT codigo, modulo, accion FROM permisos ORDER BY codigo;
```

### 6. Backfill inicial de usuarios hacia `id_rol`

Ejecutar en la base `gestion`, despues de la migracion base:

- `bd/migraciones/migracion_gestion_roles_permisos_backfill_usuarios.sql`

Alcance:

- rellena `usuarios.id_rol` para usuarios ya existentes;
- conserva `es_tecnico` como puente operativo;
- no promociona automaticamente a `superusuario`.

Criterio:

- `es_tecnico = 1` se asigna a `tecnico`;
- cualquier otro caso se asigna a `administrativo`;
- la subida de un usuario concreto a `superusuario` debe hacerse manualmente
  tras revisar el censo real de usuarios.

Validacion minima:

```sql
SELECT u.idUsuario, u.Nombre, u.es_tecnico, u.id_rol, r.codigo, r.nombre
FROM usuarios u
LEFT JOIN roles r ON r.id = u.id_rol
ORDER BY u.Nombre;
```

## Que fichero usar en cada caso

### Si la tabla no existe y solo quieres crearla

Usar normalmente la migracion:

- `bd/migraciones/migracion_gestion_auditoria.sql`

### Si necesitas revisar la estructura completa de referencia

Consultar:

- `bd/base/gestion_auditoria_eventos.sql`

Ese fichero describe la tabla final, pero no implica ejecucion automatica.

## Resumen corto

- nada de `bd/` se lanza solo desde la app;
- las migraciones se ejecutan a mano en MySQL;
- antes de migrar, revisar version del servidor y compatibilidad del script;
- el servidor principal ya queda estabilizado en `MySQL 8.4.9`;
- si montas un entorno nuevo, el primer paso recomendado sigue siendo
  `migracion_gestion_auditoria.sql`;
- despues, para abrir el modelo final, basta con
  `migracion_gestion_roles_permisos_base.sql`;
- despues debe ejecutarse `migracion_gestion_roles_permisos_backfill_usuarios.sql`
  para enlazar usuarios existentes con `id_rol`;
- `migracion_gestion_roles.sql` queda como puente legado si en algun momento se
  quiere mantener solo el rol textual sin abrir aun la matriz completa.

