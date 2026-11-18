---
title: "Decisión: migrar solo puntos de control de Quirófanos"
type: decision
status: accepted
created: 2026-11-15
updated: 2026-11-15
tags: [qontrolmed, quirofanos, maestros, migracion]
---

# Decisión: migrar solo puntos de control de Quirófanos

El propietario confirmó el 15/11/2026 que de la base local de Quirófanos solo
debe conservarse el maestro `quirofanos.puntos_control`.

Quedan excluidos `hospitales`, `quirofanos`, `quirofano_puntos_control`,
`equipos_medida`, informes, resultados y cualquier otra configuración o dato
histórico. Los puntos automáticos guardados dentro de
`quirofano_puntos_control` tampoco forman parte del maestro elegido.

La exportación revisable conservará el contrato funcional `id`, `codigo`,
`descripcion`, `orden` y `activo`. Las marcas de tiempo técnicas no se
consideran contenido maestro necesario y se revisarán antes de definir el
formato final de importación.
