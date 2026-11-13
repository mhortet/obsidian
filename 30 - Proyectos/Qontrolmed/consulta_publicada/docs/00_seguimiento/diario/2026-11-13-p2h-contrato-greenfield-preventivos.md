---
title: "Sesión P2H: contrato greenfield de Preventivos"
type: state
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "docs/01_gobierno_y_decisiones/DECISION-IMPLANTACION-DESDE-CERO-Y-DATOS-PRUEBA-2026-11-13.md"
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P2H-CONTRATO-GREENFIELD-PREVENTIVOS-2026-11-13.md"
tags: [qontrolmed, sesion, p2, preventivos, greenfield]
review_after: 2026-11-20
---

# Sesión 2026-11-13: P2H, contrato greenfield de Preventivos
[[masgesth]]

## Objetivo y límites

- Registrar que la implantación parte de cero e inventariar Preventivos y sus
  intercambios móviles.
- Solo lectura y documentación; sin SQL nuevo, MySQL ni cambios móviles.

## Resultado

- Diez tablas propias y dos dependencias funcionales entre esquemas.
- Contratos JSON de Preventivos y Quirófanos confirmados como canales offline
  distintos y vigentes.
- Conflictos de Preventivos ya resueltos por decisión interactiva del usuario.
- SQLite móvil queda como consumidor del contrato, no como modelo MySQL.
- Commit `73beaa2` publicado; CI `43472291142` y Security Checks
  `43472291363` correctos.

## Siguiente paso

- P2I: construir la estructura base MySQL de Preventivos con pruebas estáticas
  y sin ejecutar todavía DDL.
