---
title: "Preparación coordinada de la fase equipo actual"
type: register
status: active
created: 2026-11-19
updated: 2026-11-19
sources:
  - "../../02_planes_y_arquitectura/PLAN-REVISION-SFTPGO-FASE-EQUIPO-ACTUAL-2026-11-19.md"
tags: [servidor-mm, sesion, sftpgo, continuidad]
review_after: 2026-11-26
---

# Sesión 2026-11-19: preparación de la fase equipo actual

## Decisión

El propietario ordenó terminar primero todo lo ejecutable desde el equipo
actual, pasar después al portátil y finalmente trabajar en sede. Los planes
mostrarán solo el pendiente de la fase activa.

## Estado observado

- La aceptación doméstica SFTPGo del 06/11 terminó correctamente con datos
  ficticios.
- Se validaron WebClient, contraseña y TOTP, subida, descarga,
  sobrescritura, límites, cuota, revocación y restauración local.
- SFTPGo quedó `inactive/disabled` y `cloudflared` `inactive/masked`.
- El relevo estaba desactualizado respecto al avance P2U–P2X de Qontrolmed.

## Trabajo documental

Se registró la regla de fases, se creó el plan autorizado de revisión SFTPGo y
se actualizaron maestro y relevo. No se conectó al servidor ni se modificaron
servicios, red, cuentas o datos.

## Continuación exacta

Reanudar desde esta carpeta con la revalidación remota de solo lectura del
plan vigente. No iniciar trabajo de portátil o sede.
