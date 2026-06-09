# Roles operativos de acceso
[[masgesth]]
Fecha de revision: 2026-06-03

## Objetivo

Dejar por escrito la regla operativa vigente de acceso y roles para no
depender del chat ni mezclar decisiones futuras con la necesidad actual de
trabajo de campo real.

## Decision vigente

Por ahora el modelo activo se limita a dos roles:

- `Administrador`
- `Tecnico`

No se activan todavia permisos finos por usuario ni una matriz detallada de
autorizaciones por rol. Esa evolucion queda aplazada a una fase posterior.

## Regla operativa actual sin migracion de BD

Mientras la tabla `gestion.usuarios` no tenga columna `rol`, la aplicacion
sigue funcionando con la columna existente `es_tecnico`:

- `es_tecnico = 1` equivale a `Tecnico`
- `es_tecnico = 0` equivale a `Administrador`

Esto permite trabajar sin tocar la base de datos durante una ventana operativa
de hospital o campo.

## Efecto funcional esperado

- Los usuarios tecnicos deben seguir apareciendo en selectores de tecnico de
  Preventivos y Quirofanos.
- Si un usuario pasa a `es_tecnico = 0`, debe dejar de aparecer en esos
  selectores.
- Un `Administrador` no se considera tecnico de campo por defecto.
- Si una misma persona necesita ambos perfiles, debe usar identidades
  separadas segun el contexto operativo.

## Login sin contrasena

El acceso implicito sin contrasena queda bloqueado por defecto.

Solo se permite bootstrap temporal si se activa expresamente:

- `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=1`

Fuera de un bootstrap controlado, lo correcto es exigir al menos un usuario
activo con contrasena.

## Cuando tocar la BD

No es obligatorio migrar la BD para usar la regla actual.

La migracion solo hace falta cuando se quiera dejar el rol explicito en base de
datos con la columna `rol` y abandonar la interpretacion operativa basada en
`es_tecnico`.

Referencia preparada:

- `bd/migracion_gestion_roles.sql`

## Regla de prudencia

Si hay trabajo de campo real en curso, priorizar estabilidad:

- no tocar esquema si no es necesario;
- usar `es_tecnico` como criterio operativo actual;
- dejar la migracion de roles para una ventana tranquila de mantenimiento.
