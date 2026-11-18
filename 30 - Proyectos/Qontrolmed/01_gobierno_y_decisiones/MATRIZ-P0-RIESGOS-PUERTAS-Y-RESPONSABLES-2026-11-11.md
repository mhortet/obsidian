---
title: "Matriz P0 de riesgos, puertas y responsables"
type: decision
status: active
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P0-PRODUCCION-READINESS-2026-11-11.md"
tags: [qontrolmed, p0, riesgos, responsables, puertas]
review_after: 2026-11-18
---

# Matriz P0 de riesgos, puertas y responsables

El propietario autorizó íntegramente el P1 local el 11 de noviembre de 2026.
La autorización y su criterio general de ejecución por planes completos están
registrados en
`DECISION-AUTORIZACION-INTEGRAL-PLANES-Y-P1-LOCAL-2026-11-11.md`.

## 1. Roles

| Rol | Responsabilidad |
| --- | --- |
| Propietario/mantenedor | Prioridad, código, release y aceptación técnica |
| Administrador del servidor | Infraestructura, MySQL, firewall, copias y recuperación |
| Responsable funcional del cliente | Alcance, datos maestros y aceptación funcional |
| Autorizador de cambio | Aprueba migración, restauración, rollback y ventana |

Una persona puede asumir varios roles, pero cada autorización debe quedar
explícita. No se incorporan nombres personales al repositorio.

## 2. Riesgos activos

| ID | Riesgo | Severidad | Tratamiento | Responsable | Puerta |
| --- | --- | --- | --- | --- | --- |
| P0-R01 | Dependencias auditadas con fallo remoto | Crítica | Actualizar y ejecutar `pip-audit` bloqueante | Mantenedor | P1 |
| P0-R02 | `main` sin TLS verificado | Crítica | Integrar contrato TLS y CA | Mantenedor + administrador | P1 |
| P0-R03 | CA no provisionada por RC | Crítica | Instalador, ACL, hash y verificador | Mantenedor + administrador | P1 |
| P0-R04 | CI verde pese a fallo de dependencias | Alta | Eliminar `continue-on-error` obligatorio | Mantenedor | P1 |
| P0-R05 | `ALTER TABLE` automático en runtime | Alta | Migración controlada y fallo seguro | Mantenedor | P1/P2 |
| P0-R06 | Cuenta técnica sin grants cerrados | Alta | Matriz por tabla y pruebas de denegación | Administrador + mantenedor | P1 |
| P0-R07 | Inventario real de puestos ausente | Alta | Completar en almacén protegido | Administrador + cliente | P6 |
| P0-R08 | Copia independiente no concretada | Alta | Destino, cifrado, monitorización y restore | Administrador + propietario | P2 |
| P0-R09 | Checkout con objetos colgantes | Media | Clon limpio y comparación | Mantenedor | P4 |
| P0-R10 | Python local 3.13 y CI 3.11 | Media | Matriz compatible y build fijada | Mantenedor | P1/P5 |
| P0-R11 | Worktree TLS mezcla tres cambios | Alta | Portar por commits separados | Mantenedor | P1 |
| P0-R12 | Protección de `main` no verificada | Media | Revalidar permisos/API y convención PR | Propietario | P1/P4 |

## 3. Puertas mínimas

### Puerta de entrada a P1

- commit y rama P0 identificados;
- alcance funcional congelado;
- propuesta TLS/CA y cuenta técnica disponibles;
- cambios TLS separados de marcas;
- ninguna RC construida.

Estado: **superada para trabajo local**. No autoriza servidor, datos reales ni
construcción de RC.

### Puerta de seguridad P1

- tests TLS positivos y negativos;
- `pip-audit`, Bandit y Gitleaks bloqueantes;
- cuenta runtime sin DDL ni acceso a Compras diferidas;
- CA provisionada y no modificable por usuario estándar;
- CI sin falso verde.

### Puerta de datos P2

- ledger de esquema;
- migraciones con precheck, copia, postcheck y restauración;
- backup independiente y restauración probada;
- RPO/RTO medidos.

## 4. Decisiones del piloto

En este proyecto, **Propietario** es el usuario que dirige Qontrolmed. Durante
el piloto también asume mantenimiento, publicación y aprobación de releases.

| Decisión | Decisión o dato mínimo | Responsable | Estado |
| --- | --- | --- | --- |
| Puestos autorizados | Solo los equipos reales del piloto; registrar identificador, Windows, IP/reserva y responsable antes de conectarlos | Propietario + empresa piloto | Pendiente de sede |
| DNS y CA | Nombre estable y CA pública para MySQL; no se exige dominio público ni acceso remoto en el primer piloto | Propietario/administrador | Pendiente de encender y revalidar servidor |
| Copia independiente | Copia cifrada fuera del mismo servidor antes de depender de datos reales; destino concreto pendiente | Propietario | Pendiente de sede |
| Soporte | Mejor esfuerzo, sin SLA; contacto 08:00–22:00 según disponibilidad; teléfono/WhatsApp para bloqueos y correo para el resto | Propietario | Definido para piloto |
| Releases | Repositorio privado, tag, hashes, notas, versión vigente y anterior; propietario publica y aprueba | Propietario | Definido para piloto |
| Authenticode | Aplazado hasta una decisión comercial; se puede dejar preparado el punto de firma | Propietario | Diferido |
| Retención documental | Mínima y proporcional; logs técnicos 15 días; documentos reales se acordarán antes de incorporarlos | Propietario + empresa piloto | Parcial; no bloquea desarrollo local |
| Día de RTO | Objetivo de recuperación de 1 día laborable, sin garantía contractual en el piloto | Propietario + empresa piloto | Definido para piloto |

## 5. Matriz mínima de pruebas

| Área | Aceptación | Denegación/fallo |
| --- | --- | --- |
| TLS | CA y nombre correctos | CA ausente/incorrecta, nombre incorrecto, no TLS LAN |
| MySQL | DML autorizado | DDL, otros esquemas, Compras y origen no autorizado |
| Autorización | permisos funcionales válidos | esquema incompleto o permiso ausente falla cerrado |
| Auditoría | evento registrado | fallo de auditoría visible y bloqueante donde corresponda |
| Migración | pre/postcheck y versión | reejecución, versión inesperada y restore |
| Importación | paquete válido e idempotencia definida | corrupto, duplicado, reintento y pérdida de conexión |
| Backup | copia verificada y restore | copia incompleta, hash incorrecto y destino no disponible |
| Release | paquete desde tag y manifiesto | secreto, fichero no permitido o hash distinto |
