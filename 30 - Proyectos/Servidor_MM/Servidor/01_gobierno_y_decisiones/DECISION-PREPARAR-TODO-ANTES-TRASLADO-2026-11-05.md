---
title: "Preparar accesos y recuperación antes del traslado a sede"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../02_planes_y_arquitectura/PLAN-PREPARACION-PREVIA-Y-PUESTA-EN-SEDE-2026-11-05.md"
tags: [arquitectura, seguridad, administracion]
review_after: 2026-11-12
---

# Decisión del propietario

El propietario quiere trasladar `srv-mm-01` a la red del cliente en cuanto sea responsable hacerlo, dejando preparados y ensayados antes del desplazamiento:

- un repositorio para subir y descargar archivos mediante Cloudflare;
- un canal administrativo remoto desde su ordenador con capacidad completa de administración controlada;
- recuperación, reversión, copias y pruebas suficientes para reducir al mínimo la necesidad de volver físicamente a la sede.

Esta decisión fija la prioridad y el criterio de diseño. No autoriza por sí sola instalar SFTPGo o `cloudflared`, crear recursos en Cloudflare, modificar red/UFW/SSH, reutilizar discos, cambiar el desbloqueo LUKS ni introducir datos reales. Esos cambios se agruparán en un plan técnico final con aceptación y reversión, que requerirá una única aprobación explícita.

## Decisión operativa para el 2026-11-06

La preparación no esperará a disponer de toda la información del cliente. Se avanzará primero en auditoría, diseño, parametrización, scripts reversibles y pruebas domésticas con datos ficticios que no dependan del dominio, la red final, el destino de copia o el responsable local. La información que llegue después se incorporará mediante puntos de integración definidos, repitiendo solo las pruebas afectadas.

Esta prioridad no amplía la autorización técnica: sin un plan ejecutable aprobado no se instalarán servicios ni se modificarán firewall, SSH, red, DNS, Cloudflare, LUKS o discos. Sin datos confirmados tampoco se crearán sustitutos inseguros, cuentas de producción o configuraciones finales inventadas.

## Interpretación de “plenos poderes”

Se implementará como una cuenta administrativa nominal con autenticación fuerte y `sudo` interactivo. No significa habilitar login remoto de `root`, contraseña SSH, `NOPASSWD: ALL`, compartir secretos con Codex ni abrir TCP/22 en Internet.

## Límite operativo

No puede prometerse recuperación totalmente remota mientras no esté resuelto el arranque tras pérdida de alimentación. El sistema usa LUKS2 y la documentación no demuestra desbloqueo remoto o automático. El túnel y SSH solo funcionan después de arrancar Ubuntu. Antes del traslado se debe elegir y probar una solución: persona local instruida, consola remota/KVM o un mecanismo de desbloqueo expresamente auditado y aprobado. No se debilitará LUKS para evitar esta decisión.
