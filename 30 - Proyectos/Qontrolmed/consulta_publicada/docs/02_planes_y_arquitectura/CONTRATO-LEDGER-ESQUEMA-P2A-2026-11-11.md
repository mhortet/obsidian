---
title: "Contrato de ledger de esquema P2A"
type: architecture
status: accepted-for-local-design
created: 2026-11-11
updated: 2026-11-11
sources:
  - "bd/migraciones/manifest.json"
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P2A-GOBIERNO-LOCAL-DE-ESQUEMA-2026-11-11.md"
tags: [qontrolmed, p2, mysql, ledger, migraciones]
review_after: 2026-11-18
---

# Contrato de ledger de esquema P2A

## 1. Finalidad

Definir cómo una base declarará las migraciones aplicadas y cómo Qontrolmed o
una futura herramienta administrativa comprobarán compatibilidad. Este contrato
no crea tablas, no contiene un ejecutor y no autoriza migraciones.

## 2. Separación de responsabilidades

- el manifiesto versionado declara el estado objetivo y los hashes esperados;
- el ledger de cada esquema registra únicamente hechos aplicados a esa base;
- una cuenta administrativa temporal crea y actualiza el ledger dentro de un
  runbook de migración;
- la cuenta runtime de Qontrolmed solo necesita `SELECT` sobre el ledger;
- el arranque compara estado observado y esperado, pero nunca ejecuta DDL;
- ausencia, ilegibilidad o contradicción del ledger produce fallo cerrado en
  producción.

## 3. Modelo lógico mínimo

Nombre propuesto de tabla en cada esquema: `qontrolmed_schema_migrations`.

| Campo | Tipo lógico | Regla |
| --- | --- | --- |
| `migration_id` | texto hasta 120 | clave primaria; coincide con el manifiesto |
| `schema_version` | entero positivo | único y creciente dentro del esquema |
| `sha256` | 64 caracteres hexadecimales | hash canónico del SQL aprobado |
| `applied_at_utc` | fecha/hora UTC | momento de aplicación confirmado |
| `applied_by` | texto hasta 120 | identificador técnico depurado, no contraseña |
| `application_version` | texto hasta 50 | versión/tag que promovió la migración |
| `result` | enumeración lógica | solo `applied` o `recovered` |
| `notes` | texto opcional | referencia operativa sin secretos ni datos reales |

No se registra SQL completo, credenciales, nombres de pacientes ni contenido
operativo. Un intento fallido se conserva en la evidencia operativa, no se
presenta como versión aplicada.

## 4. Consulta futura de solo lectura

La herramienta administrativa seguirá esta secuencia:

1. validar localmente el manifiesto y sus hashes;
2. abrir una conexión TLS verificada con permisos de lectura;
3. comprobar que el ledger existe y es legible;
4. leer identificador, versión, hash y resultado en orden ascendente;
5. rechazar duplicados, saltos, migraciones desconocidas, hashes distintos,
   resultados no aplicados o versiones superiores al manifiesto;
6. informar `compatible`, `migration-required` o `inconsistent` sin ejecutar
   SQL ni modificar el ledger.

`migration-required` no autoriza a continuar en producción. Debe remitir al
runbook administrativo con backup, precheck, ejecución, postcheck y decisión de
restauración.

## 5. Estados y compatibilidad

- `compatible`: todas las migraciones requeridas por la versión están aplicadas
  con identificador, orden y hash coincidentes;
- `migration-required`: el ledger es coherente pero falta una migración
  conocida;
- `inconsistent`: falta el ledger, no puede leerse o contradice el manifiesto;
- `unsupported-newer`: la base declara una versión posterior a la soportada.

En producción, solo `compatible` permite continuar. Los otros estados fallan de
forma segura y no intentan reparar la base.

## 6. Trabajo diferido a P2B

- convertir este modelo en SQL administrativo con precheck, postcheck y
  restauración;
- implementar un comprobador de compatibilidad mediante interfaces simulables;
- probar aceptación y rechazo sin una base real;
- reservar la integración MySQL aislada para un plan posterior con versión de
  servidor, cuenta temporal y datos sintéticos definidos.

## 7. Implementación local P2B

P2B añadió el SQL administrativo de aprovisionamiento del ledger vacío y una
función pura que compara filas ya leídas con el manifiesto validado. El módulo
no conoce credenciales, conectores ni cursores y no puede escribir en la base.

El SQL de aprovisionamiento queda fuera del manifiesto porque establece la
infraestructura vacía necesaria para que exista el propio ledger. No registra
una migración como aplicada, no selecciona un esquema real y no se ejecuta
desde la aplicación. Una futura prueba integrada deberá fijar el runbook exacto
antes de utilizarlo.
