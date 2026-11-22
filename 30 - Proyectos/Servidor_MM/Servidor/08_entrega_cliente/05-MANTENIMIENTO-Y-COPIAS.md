---
title: "Mantenimiento y copias"
type: process
status: active
created: 2026-11-21
updated: 2026-11-21
sources:
  - "../DOCUMENTACION-SERVIDOR-UBUNTU.md"
tags: [administracion, seguridad, documentacion]
review_after:
---

# Mantenimiento y copias

## Responsabilidades pendientes

| Tarea | Responsable | Sustituto | Frecuencia aprobada |
| --- | --- | --- | --- |
| Revisión diaria | PENDIENTE | PENDIENTE | PENDIENTE |
| Actualizaciones | PENDIENTE | PENDIENTE | PENDIENTE |
| Revisión de usuarios | PENDIENTE | PENDIENTE | PENDIENTE |
| Copias | PENDIENTE | PENDIENTE | PENDIENTE |
| Restauración de prueba | PENDIENTE | PENDIENTE | PENDIENTE |
| Certificados y dominios | PENDIENTE | PENDIENTE | PENDIENTE |

## Rutina mínima propuesta

- Diaria en producción: disponibilidad, espacio, alertas y último resultado de copia.
- Semanal: errores, intentos de acceso, estado de discos y actualizaciones disponibles.
- Mensual: cuentas, permisos, firewall, vencimientos y restauración de muestra.
- Tras cualquier cambio o reinicio: red, montajes, servicios y acceso desde un cliente.

## Actualizaciones

Las actualizaciones se aplicarán en una ventana acordada, con copia recuperable, consola disponible, impacto revisado y validación posterior. No se cambiará de versión de Ubuntu o de rama MySQL como parte de una actualización ordinaria.

## Copias definitivas

| Parámetro | Valor aceptado |
| --- | --- |
| Datos incluidos | PENDIENTE DE SEDE |
| Destino independiente | PENDIENTE DE SEDE |
| Cifrado | PENDIENTE DE SEDE |
| Frecuencia | PENDIENTE DE SEDE |
| Retención | PENDIENTE DE SEDE |
| RPO: pérdida máxima admisible | PENDIENTE DE CLIENTE |
| RTO: tiempo máximo de recuperación | PENDIENTE DE CLIENTE |
| Avisos | PENDIENTE DE SEDE |

Una copia almacenada en el mismo servidor o disco no es suficiente. La aceptación exige restaurar en un destino separado, comprobar integridad y medir el tiempo.

## Registro de revisión

| Fecha | Revisión | Resultado | Evidencia | Responsable | Acción pendiente |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |
