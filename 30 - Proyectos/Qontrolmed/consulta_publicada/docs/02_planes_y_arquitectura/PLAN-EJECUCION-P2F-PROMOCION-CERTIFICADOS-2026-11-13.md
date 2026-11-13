---
title: "Plan P2F: promoción de certificados de equipos de medida"
type: plan
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "PLAN-EJECUCION-P2E-CLASIFICACION-MIGRACIONES-2026-11-13.md"
  - "bd/migraciones/manifest.json"
  - "bd/migraciones/migracion_certificados_equipos_medida.sql"
tags: [qontrolmed, p2, migraciones, quirofanos, certificados]
review_after: 2026-11-20
---

# Plan P2F: promoción de certificados de equipos de medida

## Objetivo

Promover individualmente la migración de `equipos_medida.ruta_certificado`
como `quirofanos-0002`, conservando el guard de runtime de solo lectura y sin
ejecutar SQL sobre una base real.

## Alcance

- endurecer precheck, postcheck y recuperación del SQL;
- declarar dependencia de `quirofanos-0001-tecnico-cierre` y versión 2;
- empaquetar el recurso en PyInstaller;
- probar el SQL estáticamente, el manifiesto, el ledger completo y los estados
  de rechazo;
- validar suite, compilación, Bandit, documentación, Obsidian y CI.

## Límites

- servidor apagado, sin SSH ni MySQL;
- sin `.env`, credenciales, CA, datos reales ni DDL ejecutado;
- sin herramienta que escriba el ledger ni migración automática;
- sin construir una RC ni promover otra migración.

## Aceptación

- el SQL exige esquema, tabla y ausencia de columna antes del `ALTER`;
- el postcheck comprueba tipo, longitud, nulabilidad y valor por defecto;
- la recuperación usa copia previa y prohíbe `DROP COLUMN` automático;
- el manifiesto válido contiene versiones 1 y 2 en orden y con hashes exactos;
- un ledger solo con versión 1 produce `migration-required` y bloquea runtime;
- el ledger exacto de versiones 1 y 2 es `compatible`;
- suite y controles de seguridad correctos.

## Reconciliación y reversión

Si `ruta_certificado` ya existe sin fila de ledger, se detiene la ejecución: la
presencia debe verificarse contra el contrato y reconciliarse en un runbook
administrativo posterior. Qontrolmed no adopta ni registra automáticamente el
estado.

Si la migración falla, se restaura la copia previa. No se automatiza `DROP
COLUMN`, porque podría eliminar rutas ya creadas. Los cambios locales se
revierten mediante Git y no modifican bases.

## Autorización

El propietario autorizó continuar con este bloque el 13/11/2026. La
autorización cubre implementación local, pruebas, documentación, commits y
publicación, sin ampliar los límites anteriores.

## Resultado

Completado localmente el 13/11/2026. El manifiesto declara dos versiones de
Quirófanos, el SQL contiene comprobaciones estructurales y recuperación no
destructiva, el paquete incorpora ambos SQL y el guard bloquea correctamente
un ledger detenido en versión 1.

Validación: 81 pruebas correctas, manifiesto válido con dos migraciones,
compilación correcta, Bandit sin hallazgos medios o altos y `git diff --check`
sin errores. No se conectó a MySQL; la ejecución sintética real queda para un
bloque de integración posterior.

Publicado en `fe99684`; CI `43464360995` y Security Checks `43464360775`
finalizaron correctamente.
