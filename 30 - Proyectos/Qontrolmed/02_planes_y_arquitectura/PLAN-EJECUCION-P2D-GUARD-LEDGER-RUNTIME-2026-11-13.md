---
title: "Plan P2D: guard de ledger en runtime"
type: plan
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "PLAN-EJECUCION-P2C-INTEGRACION-LEDGER-MYSQL-SINTETICO-2026-11-13.md"
  - "CONTRATO-LEDGER-ESQUEMA-P2A-2026-11-11.md"
tags: [qontrolmed, p2, ledger, runtime, seguridad]
review_after: 2026-11-20
---

# Plan P2D: guard de ledger en runtime

## Objetivo

Integrar en el arranque de Qontrolmed una comprobación de solo lectura del
ledger de Quirófanos. Solo `compatible` permite llegar al login; cualquier otro
estado cierra las conexiones y falla de forma segura.

## Alcance

- adaptador de lectura sin DDL, DML ni reparación automática;
- validación del manifiesto y hash versionados;
- consulta de `qontrolmed_schema_migrations` en la conexión de Quirófanos;
- integración antes del login;
- cierre de las tres conexiones ante fallo;
- inclusión del manifiesto y SQL piloto en el paquete PyInstaller;
- pruebas de ledger compatible, ausente, ilegible, pendiente, incoherente y
  posterior;
- pruebas estáticas que impidan escrituras y aseguren recursos de build;
- documentación, commit y CI.

## Límites

- servidor apagado, sin SSH ni MySQL;
- sin `.env`, credenciales, CA o datos reales;
- sin crear o actualizar el ledger;
- sin promover las otras migraciones;
- sin construir una RC;
- el guard se limita a Quirófanos porque es el único esquema declarado todavía
  en el manifiesto.

## Puerta de aceptación

- solo `compatible` permite continuar;
- ausencia, error, hash distinto, `recovered`, migración pendiente o versión
  posterior bloquean el arranque;
- ningún módulo del guard contiene SQL de escritura;
- las conexiones se cierran si falla la comprobación;
- el build declara los recursos exactos del manifiesto;
- suite, manifiesto, compilación, Bandit, CI y Security Checks correctos.

## Reversión

Los cambios son locales y versionados. Revertir los commits P2D elimina el
guard y los recursos de build sin modificar ninguna base. No existe reversión
de datos porque P2D no escribe en MySQL.

## Autorización

El propietario autorizó continuar con el siguiente bloque el 13/11/2026. La
autorización cubre este alcance local, sus pruebas, documentación, commits y
publicación, pero no amplía los límites anteriores.

## Resultado

P2D se completó localmente. El guard lee el ledger de Quirófanos antes del
login, valida manifiesto y hash y solo permite `compatible`. El gestor cierra
las tres conexiones ante cualquier fallo. `main.spec` incorpora exactamente el
manifiesto y el SQL piloto necesarios.

Validación: 76 pruebas correctas, compilación y manifiesto correctos, Bandit sin
hallazgos medios o altos y cero SQL de escritura en el adaptador runtime. El
servidor permaneció apagado y no se construyó una RC.
