---
tags:
  - app
  - desarrollo
Creado: 2026-06-03
Autor:
  - Codex
Relacionado:
  - "[[masgesth]]"
---
## Alcance

## Descripción


# Migraciones operativas de hardening

Fecha de revision: 2026-06-03

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

## Orden recomendado ahora mismo

### 1. Sin tocar BD, operativa valida

Se puede seguir trabajando sin ejecutar ninguna migracion nueva si:

- el login funciona bien;
- `es_tecnico = 1` y `es_tecnico = 0` ya cubren la operativa actual;
- no necesitas todavia guardar auditoria real en BD.

### 2. Primera migracion recomendada cuando tengas una ventana tranquila

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

### 3. Migracion de roles explicitos, mas adelante

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
- hoy puedes seguir sin tocar BD;
- primer paso recomendado cuando quieras avanzar: `migracion_gestion_auditoria.sql`;
- dejar `migracion_gestion_roles.sql` para una ventana posterior.
