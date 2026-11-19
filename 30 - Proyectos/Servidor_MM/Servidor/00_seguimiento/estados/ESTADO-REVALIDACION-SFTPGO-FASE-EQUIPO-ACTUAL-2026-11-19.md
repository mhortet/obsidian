---
title: "Estado de revalidación SFTPGo desde el equipo actual"
type: register
status: active
created: 2026-11-19
updated: 2026-11-19
sources:
  - "../../02_planes_y_arquitectura/PLAN-REVISION-SFTPGO-FASE-EQUIPO-ACTUAL-2026-11-19.md"
  - "../../05_evidencias/REVALIDACION-SFTPGO-FASE-EQUIPO-ACTUAL-2026-11-19.txt"
  - "ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
tags: [administracion, seguridad, documentacion]
review_after: 2026-11-26
---

# Estado de revalidación SFTPGo — 19/11/2026

## Resultado

La auditoría de solo lectura terminó correctamente. No se iniciaron servicios,
no se transfirieron artefactos persistentes y no se modificaron cuentas,
configuración, red, UFW, SSH, LUKS, discos o datos.

## Hechos confirmados

- SFTPGo Community `2.7.6-1`: `inactive/disabled`.
- `cloudflared 2026.10.7`: `inactive/masked`.
- Sin unidades fallidas ni listeners `18080`, `18081`, SFTP, FTP o WebDAV.
- MySQL `active/enabled`, limitado a `127.0.0.1:3306`, coherente con el estado
  coordinado posterior a P2R/P2T.
- `/srv/compartido`: ext4 con `rw,nosuid,nodev,noexec`, 1 % usado,
  `root:root 0750` y ACL de tránsito `u:sftpgo:--x`.
- Overrides efectivos: WebClient solo en `127.0.0.1:18080`, WebAdmin solo en
  `127.0.0.1:18081`; SFTP, FTP y WebDAV con puerto `0`.
- `documental-piloto` activo, TOTP HTTP, cuota 250 MiB, máximo 50 MiB y solo
  permisos `list`, `download`, `upload`, `overwrite` y `create_dirs`.
- `admin-piloto` activo con TOTP; los códigos de recuperación existen pero no
  se leyeron ni mostraron.
- Repositorio y contraseña del ensayo `restic` restringidos a `root`.

## Interpretación y límites

No se observó una desviación que obligue a repetir las pruebas funcionales del
06/11. Aquellas pruebas siguen acreditando descarga, sobrescritura, límites,
rechazos, revocación y restauración solo dentro del alcance ficticio.

El modelo actual tiene una carpeta personal ficticia. El diseño definitivo de
carpetas compartidas y personales, las cuentas nominales reales, la
recuperación administrada por Vicente, Cloudflare y el destino independiente
de copias siguen pendientes de la fase correspondiente; no son producción.

La base SQLite figura `0644`, pero permanece dentro de `/var/lib/sftpgo` con
directorio `0750 sftpgo:sftpgo`; no se propone cambiarla sin evaluar el modelo
de acceso y un plan específico.

## Cierre

El bloque SFTPGo ejecutable desde el equipo actual queda cerrado. La fase
coordinada continúa en Qontrolmed con la RC y el paquete local autorizados.
Solo al cerrar ambos proyectos se pasará a **portátil**.
