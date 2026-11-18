---
title: "Plan P2L: inventario de maestros de Preventivos"
type: plan
status: completed
created: 2026-11-15
updated: 2026-11-15
sources:
  - "../01_gobierno_y_decisiones/DECISION-CONSERVAR-MAESTROS-PREVENTIVOS-SIN-HISTORICO-2026-11-15.md"
  - "PLAN-EJECUCION-P2K-BOOTSTRAP-MINIMO-PREVENTIVOS-2026-11-15.md"
tags: [qontrolmed, p2, preventivos, maestros, inventario]
review_after: 2026-11-22
---

# Plan P2L: inventario de maestros de Preventivos

## Objetivo

Comprobar si la base local configurada contiene los cuatro maestros que deben
conservarse y si sus relaciones permiten preparar una exportación revisable.

## Alcance

- consulta de metadatos y recuentos de las cuatro tablas maestras;
- recuento separado de las seis tablas operativas;
- detección agregada de huérfanos y duplicados, sin mostrar valores;
- utilidad específica de solo lectura y pruebas de su contrato;
- evidencia depurada con resultados agregados.

## Límites

- no mostrar filas, nombres, descripciones, límites ni credenciales;
- no escribir en MySQL ni ejecutar el exportador tablet existente;
- no generar todavía Excel, SQL de importación ni cambios en destino;
- no conectar al servidor ni utilizar datos de una empresa externa;
- detenerse si la configuración segura no permite conectar.

## Aceptación

- conexión cerrada siempre y transacción de solo lectura revertida;
- cuatro tablas maestras inventariadas;
- tablas operativas claramente separadas;
- recuentos de integridad suficientes para diseñar la exportación;
- suite, Bandit y `git diff --check` correctos.

## Reversión

Las consultas no modifican la base. Los cambios del repositorio se revierten
retirando el commit P2L; cualquier evidencia solo contendrá agregados.

## Resultado

El inventario agregado se ejecutó el 15/11/2026 desde MySQL Workbench sobre la
instancia local. Se confirmaron las cuatro tablas maestras con contenido y las
cinco comprobaciones de integridad previstas finalizaron con cero incidencias.
Las seis tablas operativas también contienen actividad histórica, que queda
expresamente fuera de la migración. Los recuentos depurados se conservan en
`../05_evidencias/INVENTARIO-AGREGADO-MAESTROS-PREVENTIVOS-P2L-2026-11-15.md`.
