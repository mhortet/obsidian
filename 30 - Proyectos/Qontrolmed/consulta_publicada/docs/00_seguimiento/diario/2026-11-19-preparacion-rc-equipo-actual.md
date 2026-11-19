---
title: "Preparación y validación parcial de RC desde el equipo actual"
type: state
status: active
created: 2026-11-19
updated: 2026-11-19
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

### Ensayo administrativo pendiente

Se preparó un arnés local ignorado por Git para instalar en
`dist_rc\validacion_local`, configurar una CA exclusivamente sintética, validar
ACL, ejecutar el verificador y ensayar `-WhatIf` más desinstalación real. El
aviso UAC fue cancelado y el arnés no llegó a ejecutarse. No se tocaron
`Program Files`, `ProgramData` ni instalaciones existentes.

## Observado, inferido y decidido

### Observado

- Los controles de código, dependencias y secretos pasan.
- El paquete es coherente internamente y está ligado al commit fuente.
- La validación administrativa no se ejecutó.
- La publicación curada copió 12 documentos pendientes de los 85 seleccionados
  a Obsidian, incluida esta trazabilidad; el repositorio sigue siendo la fuente
  de verdad.

### Inferido

- La presencia de los binarios Tcl/Tk no sustituye el arranque real del EXE.
- Sin probar ACL y retirada no se satisface el criterio de validación del plan.

### Decidido

- No declarar todavía la RC candidata.
- No crear tag ni publicar artefactos.
- Mantener abierta la fase `equipo actual` y no iniciar portátil o sede.

## Siguiente paso recomendado

Ejecutar y aceptar el UAC del arnés
`dist_rc\VALIDAR-INSTALACION-LOCAL-0.1.0-rc.1.ps1`, revisar su resultado y
completar el smoke test del ejecutable. Solo si ambos pasan se cerrará la fase.
