---
title: "Sesión P2G: integración de certificados en MySQL"
type: state
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P2G-INTEGRACION-CERTIFICADOS-MYSQL-2026-11-13.md"
  - "docs/05_evidencias/VALIDACION-P2G-CERTIFICADOS-MYSQL-SINTETICO-2026-11-13.md"
tags: [qontrolmed, sesion, p2, mysql]
review_after: 2026-11-20
---

# Sesión 2026-11-13: P2G, integración de certificados en MySQL
[[masgesth]]

## Objetivo, punto seguro y límites

- Validar `quirofanos-0002` contra MySQL 8.4.11 sintético.
- Servidor en línea; MySQL inicialmente detenido.
- Sin datos reales, LAN MySQL, UFW, paquetes, CA, RC ni otros esquemas.

## Pasos y aprendizaje

1. Se revalidaron host, clave histórica, montajes, espacio, unidades,
   servicios, puertos y ausencia de destinos temporales.
2. Se normalizó a LF la copia temporal transferida desde Windows para igualar
   el hash canónico.
3. El primer comando interactivo falló antes de crear objetos por anidamiento
   de variables entre shells; la línea base se restauró correctamente.
4. Un wrapper Bash versionado ejecutó TLS, prueba y retirada con un único
   contexto `sudo` y log depurado.
5. El evaluador productivo confirmó v1 `migration-required` y v1+v2
   `compatible` a partir de filas leídas desde MySQL.

## Validaciones

- `P2G_DB_TESTS=OK`, `P2G_COMPATIBILITY=OK`, `P2G_WINDOW=OK`.
- estructura exacta, datos preservados, reejecución y escritura rechazadas;
- limpieza y línea base verificadas independientemente.
- Commit `8c6b0e7` publicado; CI `43469627567` y Security Checks
  `43469627563` correctos.

## Siguiente paso recomendado

- Elegir la siguiente migración de P2E o diseñar el runbook de reconciliación
  para instalaciones donde v2 ya exista sin ledger. No migrar una base real.
