---
title: "Sesión P2M: puntos de control de Quirófanos"
type: state
status: completed
created: 2026-11-15
updated: 2026-11-15
sources:
  - "../../01_gobierno_y_decisiones/DECISION-MIGRAR-SOLO-PUNTOS-CONTROL-QUIROFANOS-2026-11-15.md"
  - "../../02_planes_y_arquitectura/PLAN-EJECUCION-P2M-INVENTARIO-PUNTOS-CONTROL-QUIROFANOS-2026-11-15.md"
tags: [qontrolmed, sesion, p2m, quirofanos]
---

# Sesión 2026-11-15: puntos de control de Quirófanos

## Decisión funcional

El propietario revisó Qontrolmed y la base local y decidió conservar únicamente
`quirofanos.puntos_control`. El resto del esquema queda fuera.

## Contraste con el código

La aplicación mantiene como contenido funcional `id`, `codigo`, `descripcion`,
`orden` y `activo`. `quirofano_puntos_control` representa asociaciones y puntos
automáticos de quirófanos concretos, no el catálogo general elegido.

## Estado

Se ejecutó una consulta agregada de solo lectura sobre la tabla elegida. El
resultado fue: 136 filas, 136 activas y ninguna inactiva. También resultaron a
cero los códigos vacíos o duplicados, descripciones vacías, órdenes nulos y
estados distintos de `0` o `1`.

No se consultaron filas individuales ni se modificó MySQL. El siguiente bloque
debe generar un libro Excel revisable que contenga exclusivamente las columnas
funcionales del catálogo.
