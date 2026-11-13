---
title: "Sesión P2F: promoción de certificados"
type: state
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P2F-PROMOCION-CERTIFICADOS-2026-11-13.md"
  - "bd/migraciones/manifest.json"
tags: [qontrolmed, sesion, p2, migraciones, quirofanos]
review_after: 2026-11-20
---

# Sesión 2026-11-13: P2F, promoción de certificados
[[masgesth]]

## Objetivo y motivo

- Promover individualmente `equipos_medida.ruta_certificado` después de la
  clasificación P2E, sin mezclar otras migraciones.

## Punto seguro y límites

- Base: `3029769` en `codex/produccion-readiness`, árbol inicialmente limpio.
- Servidor apagado; sin MySQL, `.env`, credenciales, datos reales, DDL ni RC.

## Pasos, comandos y aprendizaje

### Endurecimiento y catálogo

```powershell
python scripts/db/validar_manifest_migraciones.py
```

- **Motivo**: retirar la dependencia de `ADD COLUMN IF NOT EXISTS` y gobernar
  la segunda versión mediante hash y dependencia explícita.
- **Resultado**: manifiesto válido con versiones 1 y 2; el SQL comprueba
  esquema, tabla y columna, y valida tipo, longitud, nulabilidad y defecto.
- **Reversión**: restauración desde copia; no se automatiza `DROP COLUMN`.

### Pruebas de aceptación y rechazo

```powershell
python -m unittest discover -s tests -v
python -m bandit -c bandit.yaml -r src -x '*/__pycache__/*' -ll
python -m py_compile src/compartido/schema_migrations.py src/compartido/schema_runtime_guard.py
git diff --check
```

- **Resultado**: 81 pruebas correctas; Bandit sin hallazgos medios/altos;
  compilación y diff correctos.
- **Aprendizaje**: al elevar el objetivo a v2, las fixtures que representaban
  un ledger completo debían incluir ambas filas. Se actualizaron y se añadió
  la denegación explícita para un ledger detenido en v1.

## Cambios cerrados

- SQL de certificados endurecido y hashado.
- `quirofanos-0002-certificados-equipos-medida` añadido al manifiesto.
- Segundo SQL incorporado al paquete PyInstaller.
- Pruebas estáticas y de compatibilidad actualizadas.
- Commit `fe99684` publicado; CI `43464360995` y Security Checks
  `43464360775` correctos.

## Observado, inferido y decidido

- **Observado**: v1 sola produce `migration-required`; v1+v2 exactas son
  `compatible`.
- **Inferido**: la lógica local está preparada para integración MySQL, pero no
  demuestra todavía que MySQL 8.4 ejecute y valide el DDL.
- **Decidido**: una columna preexistente sin ledger exige reconciliación
  administrativa; la aplicación no la adopta automáticamente.

## Riesgos y pendientes

- Falta una prueba de integración sintética real de la migración v2 y su fila
  de ledger. Ese bloque sí necesitará una instancia MySQL aislada.

## Siguiente paso recomendado

- Diseñar P2G de integración MySQL sintética para `quirofanos-0002`, con
  esquema temporal, copia lógica sintética, postcheck y limpieza completa.
