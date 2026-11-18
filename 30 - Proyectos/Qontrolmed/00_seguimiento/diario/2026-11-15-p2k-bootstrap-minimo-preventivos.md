---
title: "Sesión P2K: bootstrap mínimo de Preventivos"
type: state
status: completed
created: 2026-11-15
updated: 2026-11-15
sources:
  - "../../02_planes_y_arquitectura/PLAN-EJECUCION-P2K-BOOTSTRAP-MINIMO-PREVENTIVOS-2026-11-15.md"
  - "../../03_operacion_y_runbooks/PRIMERA-PUESTA-EN-MARCHA-PREVENTIVOS.md"
tags: [qontrolmed, sesion, p2k, preventivos]
review_after: 2026-11-22
---

# Sesión 2026-11-15: bootstrap mínimo de Preventivos
[[masgesth]]

## Objetivo y motivo

- Preparar la primera puesta en marcha de Preventivos después de validar en P2J
  su estructura greenfield.
- Evitar que datos históricos de desarrollo o límites técnicos no contrastados
  se conviertan en configuración del piloto.

## Punto seguro y límites

- Rama y commit base: `codex/produccion-readiness`, `33bbf84`.
- Árbol inicial limpio y alineado con el remoto.
- Sin conexión a MySQL, servidor, `.env`, datos reales ni aplicaciones móviles.
- Sin construcción de RC ni ejecución de DDL.

## Pasos, comandos y aprendizaje

### 1. Revalidación de continuidad

```powershell
git status --short --branch
git log -12 --oneline --decorate
rg -n -i "bootstrap|primera puesta|preventivos" docs bd tests
```

- **Motivo**: confirmar el punto real y localizar las fuentes activas.
- **Tipo de acción**: lectura.
- **Resultado observado**: P2J estaba cerrado y no existía todavía P2K ni un
  runbook específico.

### 2. Contraste de decisiones y código

Se revisaron la decisión greenfield, la política de datos iniciales, el DDL
P2I, las pruebas y `semillas_service.py`.

- **Resultado observado**: el servicio conserva una plantilla ECG histórica,
  pero no existe aprobación vigente para convertirla en semilla del piloto.
- **Interpretación**: el bootstrap mínimo seguro debe mantener los maestros
  vacíos; una carga posterior necesita procedencia y validación funcional.

### 3. Plan, runbook y protección automatizada

Se crearon el plan P2K y el runbook de primera puesta en marcha, y se amplió
`test_preventivos_greenfield_schema.py` para comprobar que el DDL continúa sin
`INSERT` y que el runbook declara el contrato vacío.

- **Tipo de acción**: cambio reversible y versionable.
- **Reversión**: revertir el futuro commit P2K; no existe estado externo que
  recuperar.

## Cambios cerrados

- Bootstrap mínimo definido como estructura P2I y diez tablas vacías.
- Carga de maestros separada de DDL, migraciones y recuperación.
- Precheck, postcheck, aborto, evidencia y reversión documentados.
- Ejecución automática de `semillas_service.py` excluida expresamente.

## Validaciones realizadas

- `python -m unittest discover -s tests -v`: 91 pruebas correctas.
- `python scripts/db/validar_manifest_migraciones.py`: formato 1 y dos
  migraciones válidas.
- `python -m py_compile tests/test_preventivos_greenfield_schema.py`: correcto.
- `python -m bandit -c bandit.yaml -r src -x "*/__pycache__/*" -ll`: cero
  hallazgos medios o altos.
- `git diff --check`: correcto; solo avisos informativos de conversión futura
  LF/CRLF en el entorno Windows.
- Publicación curada: cuatro documentos copiados de 59 seleccionados; la
  comprobación posterior quedó sin cambios pendientes.

## Observado, inferido y decidido

### Observado

- El DDL P2I no contiene semillas.
- Los cuatro maestros pueden permanecer vacíos después de crear la estructura.

### Inferido

- Cargar límites históricos sin contraste produciría una falsa aprobación
  técnica y funcional.

### Decidido

- P2K no entregó una semilla fija. Esta interpretación fue aclarada después:
  los maestros locales se conservan mediante una carga controlada y solo la
  actividad histórica se descarta. Véase la decisión del 15 de noviembre.

## Riesgos y pendientes

- Falta recibir o validar las plantillas de la empresa piloto.
- La ejecución del runbook necesita un plan transversal si utiliza el servidor.

## Siguiente paso recomendado

- Publicar y validar P2K en remoto.
- Después, definir el contrato greenfield restante de Gestión o la carga
  funcional de maestros cuando existan entradas validadas.
