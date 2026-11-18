---
title: "Plan P2B: ledger y compatibilidad local"
type: plan
status: completed
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/02_planes_y_arquitectura/CONTRATO-LEDGER-ESQUEMA-P2A-2026-11-11.md"
  - "bd/migraciones/manifest.json"
tags: [qontrolmed, p2, ledger, compatibilidad, mysql]
review_after: 2026-11-18
---

# Plan P2B: ledger y compatibilidad local

## 1. Objetivo

Preparar localmente el aprovisionamiento administrativo del ledger y comprobar
la compatibilidad entre un manifiesto validado y filas de ledger simuladas. No
se abrirá MySQL ni se ejecutará SQL.

## 2. Alcance

- SQL administrativo de creación del ledger con precheck, postcheck y
  recuperación condicionada;
- contrato explícito de que ese SQL nunca se llama desde el arranque;
- comprobador puro de compatibilidad sin conector de base de datos;
- estados `compatible`, `migration-required`, `inconsistent` y
  `unsupported-newer`;
- pruebas positivas y negativas con filas sintéticas;
- prueba estática del SQL administrativo;
- documentación, diario, relevo, commits y CI remoto.

## 3. Límites

- servidor apagado y sin SSH;
- sin MySQL local o remoto, `.env`, credenciales, CA ni datos reales;
- sin ejecutar DDL o DML;
- sin integrar todavía el comprobador en el arranque de Qontrolmed;
- sin herramienta que escriba filas en el ledger;
- sin promover las otras diez migraciones al manifiesto;
- sin RC.

## 4. Secuencia

1. crear SQL administrativo con destino seleccionado explícitamente por el
   operador y sin nombres de esquema inventados;
2. implementar estructuras y función pura de compatibilidad;
3. cubrir ausencia, vacío, coincidencia, faltantes, duplicados, saltos, hash
   distinto, resultado recuperado y versión posterior;
4. ejecutar pruebas, compilación, Bandit y validaciones estáticas;
5. actualizar contrato, guía, diario y relevo;
6. crear commits separados, publicar y comprobar CI/seguridad.

## 5. Puerta de aceptación

- ningún módulo P2B importa un conector MySQL ni ejecuta SQL;
- el SQL contiene precheck y postcheck verificables y una recuperación que no
  borra un ledger con filas;
- solo un ledger exacto y aplicado devuelve `compatible`;
- estados ausentes, ilegibles o contradictorios fallan de forma segura;
- las pruebas existentes y nuevas pasan;
- CI y controles de seguridad remotos correctos;
- ningún sistema externo del cliente modificado.

## 6. Reversión

Los cambios son locales y versionados. Los commits pueden revertirse sin tocar
bases de datos porque el SQL solo se añade como artefacto revisable y no se
ejecuta durante P2B.

## 7. Resultado

- SQL administrativo añadido con prechecks, postchecks y recuperación
  condicionada a tabla nueva y vacía;
- comprobador puro implementado sin acceso a base de datos;
- 13 pruebas nuevas para estados de compatibilidad y seguridad estática del
  SQL;
- 68 pruebas totales correctas;
- compilación Python y validación del manifiesto correctas;
- Bandit sin hallazgos medios o altos;
- servidor apagado, sin SSH, MySQL, `.env`, DDL, DML ni datos reales.

La prueba integrada con una instancia MySQL sintética queda fuera de P2B y
necesita un plan posterior con versión, cuenta, destino y reversión definidos.
