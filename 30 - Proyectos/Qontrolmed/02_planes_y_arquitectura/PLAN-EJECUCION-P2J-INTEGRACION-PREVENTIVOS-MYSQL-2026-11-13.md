---
title: "Plan P2J: integración greenfield de Preventivos en MySQL"
type: plan
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "PLAN-EJECUCION-P2I-BASE-MYSQL-PREVENTIVOS-2026-11-13.md"
  - "PLAN-EJECUCION-P2G-INTEGRACION-CERTIFICADOS-MYSQL-2026-11-13.md"
tags: [qontrolmed, p2, preventivos, mysql, integracion]
review_after: 2026-11-20
---

# Plan P2J: integración greenfield de Preventivos en MySQL

## Objetivo y destinos exactos

Validar el DDL P2I en MySQL 8.4.11 de `srv-mm-01` con esquema temporal
`qontrolmed_prev_base_it_20261113`, trabajo en
`/tmp/qontrolmed-p2j-20261113` y datos exclusivamente sintéticos. MySQL
escuchará solo en `127.0.0.1:3306`, con TLS obligatorio y sin habilitar el
servicio.

## Secuencia autorizada

1. Revalidar identidad, servicios, puertos y ausencia de destinos temporales.
2. Transferir DDL y arnés, verificar SHA-256 e iniciar TLS/MySQL temporal.
3. Crear el esquema vacío y una copia lógica previa.
4. Ejecutar dos veces el DDL y comprobar diez tablas, doce claves foráneas,
   InnoDB y collation.
5. Insertar el ciclo sintético completo y verificar rechazos de estado inválido
   y duplicado.
6. Borrar esquema y carpeta, retirar TLS y detener MySQL; verificar línea base.

## Límites, aceptación y reversión

Sin datos o esquemas reales, UFW/LAN, paquetes, CA persistente, cuentas, RC ni
cambios móviles. Cualquier precondición distinta detiene la ventana. La trampa
de salida elimina exclusivamente el esquema exacto, detiene MySQL y cierra
puertos; el wrapper retira el drop-in TLS por hash. Aceptación: dos ejecuciones,
estructura exacta, ciclo sintético y rechazos correctos, limpieza completa y
servicios seguros. El propietario autorizó P2J completo el 13/11/2026.

## Resultado

P2J terminó correctamente contra MySQL 8.4.11. Las dos ejecuciones del DDL
dejaron diez tablas, doce claves foráneas y diez tablas InnoDB con
`utf8mb4_0900_ai_ci`. El ciclo sintético completo generó un informe, un
resultado y una relación de equipo de medida; un estado inválido y un
inventario duplicado fueron rechazados. El esquema, TLS y carpeta temporal se
retiraron; MySQL quedó `inactive/disabled`, 3306/33060 cerrados y los demás
servicios conservaron su línea base segura.

Evidencia: `docs/05_evidencias/VALIDACION-P2J-PREVENTIVOS-MYSQL-SINTETICO-2026-11-13.md`.
