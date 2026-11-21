---
title: "Preparación y validación parcial de RC desde el equipo actual"
type: state
status: completed
created: 2026-11-19
updated: 2026-11-20
sources:
  - "docs/02_planes_y_arquitectura/PLAN-CIERRE-FASE-EQUIPO-ACTUAL-2026-11-19.md"
tags: [qontrolmed, sesion, rc, equipo-actual]
review_after: 2026-11-20
---

# Sesión 2026-11-19: preparación de RC
[[masgesth]]

## Objetivo y motivo

Continuar el plan autorizado de cierre de la fase `equipo actual`, una vez
cerrado SFTPGo en Servidor_MM, preparando y validando localmente una RC y su
paquete autocontenido sin iniciar portátil o sede.

## Punto seguro y límites

- Rama: `codex/produccion-readiness`.
- Commit fuente del paquete: `c79bcec8099724cadfc37fae6aa14f50a28c4d11`.
- Sin servidor, MySQL real, SFTPGo, red, datos reales, secretos ni certificados
  privados.
- Artefactos únicamente en `build_rc/` y `dist_rc/`, ignorados por Git.

## Pasos, comandos y aprendizaje

### Revisión y corrección del circuito

Se detectó que el build apuntaba a una ruta documental obsoleta y no generaba
SBOM, notas, evidencia, commit fuente ni un desinstalador. Se corrigió el
circuito, se añadió verificación integral del paquete y se ampliaron sus
pruebas. El desinstalador exige rutas absolutas exactas, valida marcadores de
Qontrolmed, admite `-WhatIf` y rechaza raíces o carpetas generales.

### Controles bloqueantes

```powershell
python -m unittest discover -s tests -v
bandit -c bandit.yaml -r src -x '*/__pycache__/*' -ll
python -m pip_audit -r requirements.txt
gitleaks git . --redact --no-banner
```

- 102 pruebas correctas.
- Bandit: cero hallazgos medios o altos.
- `pip-audit`: ninguna vulnerabilidad conocida.
- Gitleaks 8.30.0: 147 commits, aproximadamente 16,68 MB y cero filtraciones.

### Build y verificación del paquete

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File .\scripts\build_qontrolmed_rc.ps1 `
  -Version 0.1.0-rc.1 `
  -TestEvidencePath .\dist_rc\EVIDENCIA-CONTROLES-0.1.0-rc.1.txt

powershell -NoProfile -ExecutionPolicy Bypass `
  -File .\scripts\verificar_paquete_qontrolmed_rc.ps1 `
  -PackageRoot .\dist_rc\Qontrolmed-RC-0.1.0-rc.1 `
  -ExpectedCommit c79bcec8099724cadfc37fae6aa14f50a28c4d11
```

Resultado observado: paquete y ZIP creados; 8.078 entradas; manifiesto,
commit, SBOM y evidencia correctos; ausencia de `.env` real. SHA-256 externo:
`4618C7258347106E0E62F920E9214E6940B11FA4057B10EDD3F9AB2B64D542DB`.

PyInstaller avisó que su autodetección de Tkinter estaba dañada, aunque la
build incluyó `_tkinter.pyd`, `tcl86t.dll`, `tk86t.dll`, los directorios Tcl/Tk
y el runtime hook propio. Este aviso refuerza la necesidad de no omitir la
prueba de instalación y arranque.

### Ensayo administrativo completado el 20/11/2026

El primer UAC fue cancelado al quedar el equipo desatendido. Al reanudar, el
arnés local ignorado por Git instaló en `dist_rc\validacion_local`, configuró
una CA exclusivamente sintética, validó ACL, ejecutó el verificador y ensayó
`-WhatIf` más desinstalación real. Terminó con
`VALIDACION_INSTALACION_LOCAL=OK` y retiró por completo la ruta de ensayo. No
se tocaron `Program Files`, `ProgramData` ni instalaciones existentes.

Después se ejecutó el EXE con un `PROGRAMDATA` aislado y configuración
sintética. El proceso presentó la ventana `Gestion Documental`, permaneció
respondiendo y se cerró de forma controlada. Esto confirma que Tcl/Tk funciona
en la build pese al aviso de autodetección emitido por PyInstaller.

Se creó el tag anotado local `v0.1.0-rc.1`, que apunta al commit fuente exacto
`c79bcec8099724cadfc37fae6aa14f50a28c4d11`. No se publicó el tag ni el ZIP.

## Observado, inferido y decidido

### Observado

- Los controles de código, dependencias y secretos pasan.
- El paquete es coherente internamente y está ligado al commit fuente.
- La validación administrativa, la retirada y el smoke test del EXE pasan.
- La publicación curada copió 12 documentos pendientes de los 85 seleccionados
  a Obsidian, incluida esta trazabilidad; el repositorio sigue siendo la fuente
  de verdad.

### Inferido

- El arranque real confirma que los binarios y el runtime hook Tcl/Tk
  incorporados son funcionales en este equipo.
- El ensayo aislado acredita el circuito local, no una instalación en un puesto
  real ni conectividad con la sede.

### Decidido

- Declarar `0.1.0-rc.1` como RC candidata local.
- Cerrar la fase `equipo actual`.
- Dejar como siguiente fase `portátil`, sin iniciarla ni anticipar su plan;
  sede continúa fuera de alcance.

## Siguiente paso recomendado

Cuando el propietario decida cambiar físicamente de equipo, iniciar la fase
`portátil` y redactar entonces su plan con el estado realmente observado. No
publicar el tag, el ZIP o los commits locales como efecto implícito de este
cierre.
