---
title: "Sesión P2I: base MySQL greenfield de Preventivos"
type: state
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P2I-BASE-MYSQL-PREVENTIVOS-2026-11-13.md"
  - "docs/05_evidencias/auditorias/INVENTARIO-CONTRATO-GREENFIELD-PREVENTIVOS-P2H-2026-11-13.md"
tags: [qontrolmed, sesion, p2, preventivos, mysql, greenfield]
review_after: 2026-11-20
---

# Sesión 2026-11-13: P2I, base MySQL greenfield de Preventivos
[[masgesth]]

## Objetivo y motivo

Convertir el contrato inventariado en P2H en una estructura MySQL 8.4 vacía,
reproducible y comprobable, sin arrastrar los datos locales de prueba.

## Punto seguro y límites

- Rama: `codex/produccion-readiness`.
- Solo código, SQL declarativo, pruebas y documentación del repositorio.
- Sin conexión al servidor, ejecución DDL, datos reales ni cambios móviles.

## Pasos, comandos y aprendizaje

### 1. Estructura canónica

Se creó `bd/base/preventivos_schema_greenfield.sql` con las diez tablas P2H.
Las tablas están ordenadas para que cada clave foránea interna apunte a una
tabla ya declarada. Las dependencias con Gestión y Quirófanos se conservan
como referencias lógicas para permitir copias y restauraciones por esquema.

### 2. Contraste con el código consumidor

Se revisaron las consultas e inserciones de servicios de informes, importación
tablet, campañas y equipos de medida. Esto confirmó los campos de cabecera,
resultados, observaciones, cierre, tracking y relaciones instrumentales.

### 3. Validación local

```powershell
python -m unittest discover -s tests -v
python scripts/db/validar_manifest_migraciones.py
python -m bandit -q -r src scripts -x tests -lll
git diff --check
```

- **Resultado observado**: 88 pruebas correctas; manifiesto válido con dos
  migraciones; Bandit sin hallazgos medios/altos; diff sin errores.
- **Validación remota**: commit `689ae06`; CI `43473769165` y Security Checks
  `43473769241` finalizados correctamente.
- **Límite**: una prueba estática no sustituye ejecutar el DDL en MySQL 8.4.
- **Reversión**: revertir el commit; no existe estado de base que restaurar.

## Observado, inferido y decidido

### Observado

- El escritorio y el móvil intercambian identificadores y resultados, pero el
  móvil no define el esquema MySQL.
- El código admite campañas, control de exportación/descarga y revisión final
  en escritorio.

### Inferido

- Evitar claves foráneas cruzadas reduce el acoplamiento operativo sin perder
  la validación funcional, que corresponde a los servicios.

### Decidido

- La base inicial de Preventivos será vacía y no incorporará pruebas locales.
- La ejecución real queda separada en P2J con entorno sintético y reversión.

## Siguiente paso recomendado

P2J: validar el script contra MySQL 8.4 sintético, incluida reejecución,
restricciones, relaciones y limpieza completa, antes de crear el runbook de
aprovisionamiento del piloto.
