---
title: "Plan P2H: contrato greenfield de Preventivos"
type: plan
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "../01_gobierno_y_decisiones/DECISION-IMPLANTACION-DESDE-CERO-Y-DATOS-PRUEBA-2026-11-13.md"
  - "especificaciones/remote_tablet_preventivos.md"
  - "D:/trabajo/Proyectos/maxgesth_port/specifications/remote_tablet_preventivos.md"
tags: [qontrolmed, p2, preventivos, greenfield, json]
review_after: 2026-11-20
---

# Plan P2H: contrato greenfield de Preventivos

## Objetivo

Definir el mapa de datos que debe cubrir una estructura MySQL inicial de
Preventivos, incluyendo el intercambio JSON con la tablet, antes de escribir
SQL base o ampliar el ledger.

## Alcance

- código de escritorio de Preventivos;
- migraciones de campañas y trazabilidad tablet;
- contrato JSON de ida y vuelta;
- SQLite móvil como consumidor, no como fuente autoritativa de MySQL;
- dependencias con `gestion.usuarios` y `quirofanos.equipos_medida`;
- clasificación de tablas, relaciones y decisiones aún abiertas.

## Límites

- sin modificar repositorios móviles;
- sin crear todavía SQL base ni entradas de manifiesto;
- sin MySQL, servidor, `.env`, datos reales o RC;
- sin asumir que nombres iguales implican tipos idénticos entre MySQL y SQLite.

## Aceptación y resultado

P2H queda aceptado con el inventario
`INVENTARIO-CONTRATO-GREENFIELD-PREVENTIVOS-P2H-2026-11-13.md`. Se identifican
diez tablas propias de Preventivos, dos dependencias entre esquemas y los
campos sensibles del contrato JSON. El siguiente bloque debe convertir este
contrato en SQL base MySQL explícito y pruebas estáticas, sin ejecutar aún DDL.

Publicado en `73beaa2`; CI `43472291142` y Security Checks `43472291363`
finalizaron correctamente.
