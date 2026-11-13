---
title: "Sesión P2J: integración de Preventivos en MySQL"
type: state
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P2J-INTEGRACION-PREVENTIVOS-MYSQL-2026-11-13.md"
  - "docs/05_evidencias/VALIDACION-P2J-PREVENTIVOS-MYSQL-SINTETICO-2026-11-13.md"
tags: [qontrolmed, sesion, p2, preventivos, mysql]
review_after: 2026-11-20
---

# Sesión 2026-11-13: P2J, integración de Preventivos en MySQL
[[masgesth]]

## Objetivo y límites

- Validar el DDL greenfield P2I en MySQL 8.4.11 sintético.
- Sin datos reales, LAN MySQL, cuentas, paquetes, CA persistente ni RC.

## Resultado

- Precheck remoto coincidente con la línea base segura.
- Dos ejecuciones correctas: 10 tablas, 12 claves foráneas y collation exacta.
- Ciclo sintético y dos rechazos negativos correctos.
- `P2J_DB_TESTS=OK` y `P2J_WINDOW=OK`.
- Esquema, TLS y carpeta temporal retirados; servicios y puertos seguros.
- Validación local: 90 pruebas y Bandit sin hallazgos medios/altos.
- Commit `a969c39` publicado; CI `43476382817` y Security Checks
  `43476383169` correctos.

## Aprendizaje y límite

`CREATE TABLE IF NOT EXISTS` permite repetir la creación sobre el mismo esquema
sin duplicar objetos. Esto demuestra compatibilidad técnica en limpio, no una
migración ni reconciliación de instalaciones previas.

## Siguiente paso

Definir el bootstrap mínimo de maestros de Preventivos y el runbook ordenado de
primera puesta en marcha, todavía sin datos reales ni RC.
