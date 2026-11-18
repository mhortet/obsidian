---
title: "Cierre documental y preparación de P2C"
type: session-log
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "../../02_planes_y_arquitectura/PLAN-EJECUCION-P2C-INTEGRACION-LEDGER-MYSQL-SINTETICO-2026-11-13.md"
  - "2026-11-12-publicacion-documental-curada-obsidian.md"
tags: [qontrolmed, sesion, p2, mysql, documentacion]
---

# Cierre documental y preparación de P2C

## Objetivo

Cerrar el publicador curado iniciado el 12/11, confirmar la evidencia remota de
P2B y preparar la prueba integrada del ledger sin volver a encender el servidor.

## Resultado

- El publicador fue reproducible e idempotente en un destino temporal.
- Las 68 pruebas pasaron; manifiesto, compilación y Bandit fueron correctos.
- CI y Security Checks remotos de `aeb0c2e` terminaron correctamente.
- El equipo Windows no dispone de Docker, Podman ni cliente MySQL.
- La fuente acreditada para integración es MySQL Community Server 8.4.11 en
  `srv-mm-01`, que permanece apagado.
- Se redactó P2C con esquema y cuenta temporales, loopback, mínimo privilegio,
  copia previa, casos positivos/negativos y retirada completa.

## Límites

No se abrió MySQL, no se usó `.env`, credenciales, CA, datos reales ni SQL
remoto. P2C queda propuesto y no se ejecutará hasta contar con aprobación
transversal y un plan compatible en Servidor_MM.

## Continuación: ejecución P2C aprobada

El propietario aprobó el bloque transversal y su ampliación TLS temporal. El
primer intento falló de forma segura al descubrir que el certificado automático
de MySQL no tenía SAN. Se conservó la verificación de identidad, se seleccionó
temporalmente el certificado piloto preexistente con SAN y el segundo intento
pasó todos los casos.

El comprobador local evaluó exportaciones reales: vacío `migration-required`,
exacto `compatible`, hash distinto y `recovered` `inconsistent`, versión
posterior `unsupported-newer`. MySQL y los privilegios rechazaron las
operaciones negativas. El cierre retiró objetos y configuración temporales y
dejó MySQL detenido/deshabilitado y sin puertos.

El cierre se publicó en `674dbcd`. CI `43408673786` y Security Checks
`43408673712` terminaron correctamente.
