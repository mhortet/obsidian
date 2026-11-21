---
title: "Cierre de preparación desde el equipo actual"
type: plan
status: completed
created: 2026-11-19
updated: 2026-11-20
sources:
  - "docs/01_gobierno_y_decisiones/DECISION-SECUENCIA-EQUIPO-PORTATIL-SEDE-2026-11-19.md"
  - "docs/02_planes_y_arquitectura/PLAN-P2X-PROVISION-PUESTOS-Y-CONEXION-SEDE-2026-11-18.md"
  - "H:/02.Trabajo/obsidian/30 - Proyectos/Servidor_MM/Servidor/CONTINUAR-SIGUIENTE-SESION.md"
tags: [qontrolmed, servidor-mm, preparacion, rc, sftpgo]
review_after: 2026-11-26
---

# Cierre de preparación desde el equipo actual

## Objetivo

Terminar todo el trabajo necesario que puede ejecutarse con seguridad desde el
equipo actual antes de cambiar de ordenador. La fase se coordina con
Servidor_MM, pero cada proyecto mantiene sus autorizaciones y evidencias.

## Trabajo pendiente de esta fase

### Qontrolmed

1. Revalidar rama, commits locales, pruebas y controles de seguridad.
2. Revisar el circuito vigente de build, instalación, configuración, CA, ACL,
   verificación y desinstalación.
3. Preparar y validar una RC reproducible desde un commit exacto, sin secretos
   ni datos reales.
4. Generar manifiesto SHA-256, SBOM, notas de versión, evidencia de pruebas y
   procedimiento de reversión.
5. Preparar un paquete local autocontenido de instalador, documentación y
   verificadores, sin incorporarlo a Git.
6. Dejar la rama, documentación, publicación curada y relevo coherentes.

### Servidor_MM

El trabajo documental, SFTPGo, subida/bajada, copias y operación se ejecutará
desde su carpeta y plan compatible. En esta fase Qontrolmed solo debe mantener
el enlace y comprobar que no existan contradicciones funcionales.

## Límites

- Sin datos reales, credenciales, secretos ni certificados privados en Git.
- Sin instalar la RC en puestos del cliente.
- Sin abrir MySQL a la LAN ni modificar red, UFW o cuentas de sede.
- Sin modificar SFTPGo desde este repositorio.
- Los artefactos generados permanecen fuera del control de versiones.

## Validación

- suite automatizada completa;
- Bandit, `pip-audit` y Gitleaks bloqueantes;
- instalación, configuración, verificación y desinstalación reproducibles en
  entorno local controlado;
- CA pública validada por SHA-256 y ACL comprobadas sin secretos;
- manifiesto, SBOM, notas y reversión ligados al commit de la RC;
- enlace coherente con el cierre de Servidor_MM.

## Reversión

Los cambios de código o documentación se revierten por commit. Los builds y
paquetes locales se retiran de sus carpetas de salida exactas. Una instalación
de ensayo se revierte con el desinstalador y la retirada controlada de la
configuración de prueba, conservando evidencia depurada.

## Criterio de cierre

La fase termina cuando los dos proyectos acreditan que no queda trabajo
necesario ejecutable desde este equipo. El relevo indicará entonces pasar a la
fase **portátil**, sin anticipar su plan.

## Estado de ejecución y cierre — 20/11/2026

- El bloque SFTPGo de Servidor_MM está cerrado y enlazado desde su relevo.
- El circuito de empaquetado se completó en el commit
  `c79bcec8099724cadfc37fae6aa14f50a28c4d11`: commit fuente embebido, SBOM
  CycloneDX, notas, evidencia depurada, manifiesto SHA-256, verificador de
  paquete y desinstalador con rutas explícitas y `-WhatIf`.
- Pasaron 102 pruebas, Bandit sin hallazgos medios/altos, `pip-audit` sin
  vulnerabilidades conocidas y Gitleaks sin filtraciones en 147 commits.
- Se generó localmente `Qontrolmed-RC-0.1.0-rc.1.zip`, fuera de Git. Su
  SHA-256 es
  `4618C7258347106E0E62F920E9214E6940B11FA4057B10EDD3F9AB2B64D542DB`.
- El verificador confirmó 8.078 entradas ZIP, hashes internos, SBOM, evidencia,
  commit exacto y ausencia de `.env` real.
- La prueba elevada aislada terminó con
  `VALIDACION_INSTALACION_LOCAL=OK`: instalación, CA sintética, ACL,
  verificación con el usuario actual, simulación `-WhatIf` y desinstalación
  real correctas. No dejó la ruta `dist_rc\validacion_local` ni modificó
  `Program Files`, `ProgramData` o instalaciones existentes.
- El smoke test ejecutó el EXE con `PROGRAMDATA` aislado y configuración
  sintética: la ventana `Gestion Documental` apareció, respondió y se cerró de
  forma controlada. Quedó así resuelto el aviso de autodetección Tkinter de
  PyInstaller.
- El tag anotado local `v0.1.0-rc.1` apunta al commit fuente exacto. El tag y
  los commits locales pendientes no se han publicado en el remoto.

El paquete queda declarado **RC candidata local**, el plan se considera
completado y la fase `equipo actual` queda cerrada. El siguiente cambio de fase
será **portátil**; no se inicia ni se anticipa aquí su plan, y sede permanece
fuera de alcance.
