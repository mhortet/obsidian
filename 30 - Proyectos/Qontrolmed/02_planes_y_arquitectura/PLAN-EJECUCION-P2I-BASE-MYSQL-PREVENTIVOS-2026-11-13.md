---
title: "Plan P2I: base MySQL greenfield de Preventivos"
type: plan
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "PLAN-EJECUCION-P2H-CONTRATO-GREENFIELD-PREVENTIVOS-2026-11-13.md"
  - "../01_gobierno_y_decisiones/DECISION-IMPLANTACION-DESDE-CERO-Y-DATOS-PRUEBA-2026-11-13.md"
tags: [qontrolmed, p2, preventivos, mysql, greenfield]
review_after: 2026-11-20
---

# Plan P2I: base MySQL greenfield de Preventivos

## Objetivo

Crear una estructura MySQL 8.4 inicial, no destructiva y sin datos para las
diez tablas de Preventivos definidas en P2H.

## Alcance

- DDL ordenado con InnoDB y `utf8mb4_0900_ai_ci`;
- claves primarias, unicidad, índices y claves foráneas internas;
- campañas y tracking tablet incorporados directamente;
- campos necesarios para JSON de ida/vuelta y revisión en escritorio;
- dependencias entre esquemas documentadas como referencias lógicas;
- pruebas estáticas positivas y negativas.

## Límites

- sin ejecutar DDL ni conectar a MySQL;
- sin datos, semillas, usuarios o contraseñas;
- sin ledger de Preventivos todavía;
- sin modificar aplicaciones móviles ni construir RC;
- los tipos se validarán realmente en un bloque MySQL sintético posterior.

## Reversión

Los cambios son locales y versionados. Revertir el commit retira el SQL y sus
pruebas; no hay reversión de datos porque P2I no ejecuta el DDL.

## Resultado

- Creado `bd/base/preventivos_schema_greenfield.sql` con las diez tablas en
  orden de dependencias, claves e índices internos.
- Las referencias a `gestion.usuarios`, `gestion.cecos` y
  `quirofanos.equipos_medida` son lógicas: no se introducen claves foráneas
  entre esquemas que compliquen una restauración independiente.
- El script no contiene datos, borrados ni migración de la base local de
  pruebas.
- Añadidas cinco pruebas específicas; la validación completa cerró con 88
  pruebas correctas, manifiesto válido, Bandit sin hallazgos medios/altos y
  `git diff --check` correcto.
- No se conectó a MySQL ni se modificaron los repositorios móviles.

## Validación pendiente deliberadamente

La sintaxis y el comportamiento reales de MySQL 8.4, incluida la reejecución
del DDL y sus restricciones, deben probarse con datos sintéticos en P2J antes
de preparar el runbook de primera puesta en marcha.
