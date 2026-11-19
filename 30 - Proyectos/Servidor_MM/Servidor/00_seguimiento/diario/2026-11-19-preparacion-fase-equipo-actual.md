---
title: "Preparación coordinada de la fase equipo actual"
type: register
status: active
created: 2026-11-19
updated: 2026-11-19
sources:
  - "../../02_planes_y_arquitectura/PLAN-REVISION-SFTPGO-FASE-EQUIPO-ACTUAL-2026-11-19.md"
tags: [documentacion, gobierno, seguridad]
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

La revalidación remota de solo lectura terminó correctamente. Se confirmaron
servicios, listeners, versiones, montaje, ACL, bindings efectivos, cuentas
ficticias, TOTP, permisos, cuota, límite de fichero y protección del ensayo
`restic`, sin mostrar secretos ni modificar el servidor.

La primera versión del arnés no interpretó campos binarios de SQLite y declaró
el marcador final pese al error. Se corrigió a `set -euo pipefail`, se añadió
decodificación segura y se incorporó la tabla de administradores. La ejecución
final terminó sin errores; SHA-256 de la evidencia:
`69616C8EAA8EA8405F25322A9573E084571CCFE08F44EBAD5F807E80EE080831`.

El bloque Servidor_MM de la fase equipo actual queda cerrado. La continuación
coordinada pasa a Qontrolmed para preparar y validar la RC y el paquete local.
No iniciar todavía trabajo de portátil o sede.
