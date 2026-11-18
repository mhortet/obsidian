---
title: "Validación P2J de Preventivos contra MySQL sintético"
type: evidence
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "../02_planes_y_arquitectura/PLAN-EJECUCION-P2J-INTEGRACION-PREVENTIVOS-MYSQL-2026-11-13.md"
tags: [qontrolmed, p2, preventivos, mysql, evidencia]
---

# Validación P2J de Preventivos contra MySQL sintético

## Resultado depurado

| Control | Resultado |
| --- | --- |
| MySQL | 8.4.11 |
| ejecuciones del DDL | 2 correctas |
| tablas | 10 |
| claves foráneas internas | 12 |
| InnoDB + `utf8mb4_0900_ai_ci` | 10 |
| informe, resultado y equipo de medida sintéticos | 1 / 1 / 1 |
| estado de resultado inválido | rechazado |
| inventario duplicado | rechazado |
| resultado de ventana | `P2J_WINDOW=OK` |

El original se verificó con SHA-256
`3c362217f4c2d39cd576cbf86b01dba47acdb4f65e7bcecf90bb27a73a382da0`.
Solo la copia temporal sustituyó el nombre `preventivos` por el esquema aislado
`qontrolmed_prev_base_it_20261113`.

## Cierre

- esquema y carpeta temporal retirados;
- TLS temporal retirado;
- MySQL `inactive/disabled`, sin 3306/33060;
- SFTPGo `inactive/disabled` y Cloudflared `inactive/masked`;
- `/srv/compartido` conservó `nosuid,nodev,noexec`;
- sin datos reales, cuentas, UFW/LAN, paquetes, CA persistente o RC;
- servidor encendido.
