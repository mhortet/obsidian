---
title: "Validación P2G de certificados contra MySQL sintético"
type: evidence
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "../02_planes_y_arquitectura/PLAN-EJECUCION-P2G-INTEGRACION-CERTIFICADOS-MYSQL-2026-11-13.md"
tags: [qontrolmed, p2, mysql, certificados, evidencia]
---

# Validación P2G de certificados contra MySQL sintético

## Resultado

`P2G_COMPATIBILITY=OK` y `P2G_WINDOW=OK`. La prueba se ejecutó en MySQL
Community Server 8.4.11 de `srv-mm-01`, limitado a `127.0.0.1:3306`, con
esquema, cuenta y datos exclusivamente sintéticos.

| Control | Resultado |
| --- | --- |
| tabla `equipos_medida` previa | 1 |
| columna `ruta_certificado` previa | 0 |
| tipo y longitud posterior | `varchar(500)` |
| nulabilidad y defecto | `YES`, `NULL` |
| fila sintética conservada | 1 |
| reejecución | rechazada |
| ledger solo v1 | `migration-required` |
| ledger v1+v2 | `compatible` |
| escritura con cuenta lectora | rechazada |

La copia lógica previa fue sintética y se hashó. El SQL original se verificó
por su SHA-256 canónico antes de generar una copia temporal que sustituía
únicamente el nombre de esquema por el destino aislado exacto.

## Incidente seguro del primer intento

El primer lanzamiento no creó esquema ni resultados porque el comando
interactivo anidaba variables de PowerShell, SSH y Bash. La retirada dejó
MySQL detenido/deshabilitado y el drop-in ausente. Un wrapper Bash versionado
con limpieza explícita permitió completar el segundo intento.

## Cierre y límites

- esquema y cuenta temporales retirados con código de salida cero;
- MySQL `inactive/disabled`, sin 3306/33060;
- drop-in y estado TLS temporales ausentes;
- SFTPGo `inactive/disabled`; Cloudflared `inactive/masked`;
- `/srv/compartido` conservó `nosuid,nodev,noexec`;
- sin datos reales, UFW/LAN, paquetes, CA, certificados o RC;
- el servidor permaneció encendido según lo acordado.
