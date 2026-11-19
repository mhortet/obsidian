---
title: "Operación, salud e incidencias de SFTPGo documental"
type: process
status: active
created: 2026-11-19
updated: 2026-11-19
sources:
  - "../00_seguimiento/estados/ESTADO-REVALIDACION-SFTPGO-FASE-EQUIPO-ACTUAL-2026-11-19.md"
  - "../00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
tags: [administracion, seguridad, documentacion]
review_after: 2026-11-26
---

# Runbook SFTPGo documental

Este runbook describe el estado de preparación y las comprobaciones seguras.
No autoriza producción, exposición externa ni cambios de configuración.

## Salud esperada durante la preparación

```bash
systemctl is-active sftpgo
systemctl is-enabled sftpgo
systemctl is-active cloudflared
systemctl is-enabled cloudflared
systemctl --failed --no-legend --plain
ss -lnt
findmnt /srv/compartido
df -hT /srv/compartido
```

Se espera SFTPGo `inactive/disabled`, Cloudflared `inactive/masked`, ningún
listener `18080/18081` y ninguna unidad fallida. MySQL puede estar activo, pero
solo en `127.0.0.1:3306`; es un estado coordinado separado.

## Contrato documental aceptado en el ensayo

- WebClient y WebAdmin separados y limitados a loopback.
- SFTP, FTP y WebDAV deshabilitados.
- Cuenta documental con TOTP, cuota, límite de fichero y permisos sin
  renombrado, copia, borrado, enlaces o comparticiones.
- Alta, revocación, baja, rotación y recuperación requieren administrador
  nominal y registro de la actuación; nunca se documentan credenciales,
  secretos TOTP o códigos de recuperación.
- Las cuentas y datos actuales son ficticios y no deben reutilizarse como
  identidades de producción.

## Copia y restauración

El ensayo del 06/11 copió documentos, configuración y SQLite con SFTPGo
detenido; `restic check`, restauración aislada, hashes e integridad SQLite
fueron correctos. El repositorio está en el mismo servidor y disco físico:
no cumple independencia ni 3-2-1. No sobrescribir el proveedor activo durante
una prueba de restauración.

## Incidencias

1. Registrar fecha, síntoma, alcance y último cambio conocido.
2. Preservar registros depurados; no copiar la base SQLite ni configuraciones
   privadas a la bóveda.
3. Si aparece un listener inesperado, una unidad fallida o exposición fuera de
   loopback, detener trabajo dependiente y preparar un plan de contención.
4. Ante fallo de autenticación, comprobar hora, estado, TOTP y política sin
   restablecer ni revelar secretos por canales no controlados.
5. Ante cuota o disco lleno, impedir nuevas cargas y evaluar capacidad; no
   borrar documentos para liberar espacio sin decisión responsable.

## Reversión

No aplicar una reversión histórica a ciegas. Verificar primero versión,
alcance, hashes, rutas y estado actual. Cualquier inicio, cambio de binding,
cuenta real, túnel, destino de copia o restauración sobre rutas activas exige
un plan aprobado con prueba de aceptación y reversión exacta.
