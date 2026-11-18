---
title: "Validación P2C del ledger contra MySQL sintético"
type: evidence
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "../02_planes_y_arquitectura/PLAN-EJECUCION-P2C-INTEGRACION-LEDGER-MYSQL-SINTETICO-2026-11-13.md"
tags: [qontrolmed, p2, mysql, ledger, evidencia]
---

# Validación P2C del ledger contra MySQL sintético

## Resultado

`P2C_COMPATIBILITY=OK`. La prueba se ejecutó en MySQL Community Server 8.4.11
de `srv-mm-01`, limitado a `127.0.0.1:3306`, con esquema, cuenta y datos
exclusivamente sintéticos.

## Casos confirmados

| Caso leído desde MySQL | Estado del comprobador P2B |
| --- | --- |
| ledger vacío | `migration-required` |
| migración exacta, versión 1, hash versionado y `applied` | `compatible` |
| hash distinto | `inconsistent` |
| resultado `recovered` | `inconsistent` |
| versión 2 desconocida | `unsupported-newer` |

MySQL rechazó una versión duplicada y un hash no canónico. La cuenta temporal
concedida únicamente para `SELECT` pudo leer el ledger y no pudo insertar,
crear tablas ni consultar `mysql.user`.

## Incidente seguro y corrección

El primer intento falló porque MySQL presentaba el certificado automático sin
SAN. La cadena era válida, pero `VERIFY_IDENTITY` rechazó correctamente
`127.0.0.1`. La limpieza automática retiró los objetos sintéticos, detuvo
MySQL y cerró los puertos.

Se inventarió el certificado piloto existente, con SAN `srv-mm-01`,
`127.0.0.1` y `192.168.1.31`. Tras aprobación expresa se aplicó un drop-in TLS
temporal protegido por hash, se validaron cadena, vigencia, clave y
configuración, y el segundo intento superó `VERIFY_IDENTITY`. No se degradó a
`VERIFY_CA`.

## Cierre y límites

- cuenta y esquema temporales retirados por el arnés con resultado cero;
- copia lógica vacía usada solo dentro de la ventana temporal;
- MySQL `inactive/disabled`, sin 3306/33060 ni proceso;
- drop-in TLS y estado de hash retirados;
- SFTPGo `inactive/disabled`; cloudflared `inactive/masked`;
- sin cambios UFW/LAN, paquetes, datos reales, `.env` o claves documentadas;
- el certificado piloto preexistente permanece sin cambios.

La prueba valida el contrato y el comprobador del ledger. No autoriza una RC,
una migración funcional real ni la instalación productiva de Qontrolmed.
