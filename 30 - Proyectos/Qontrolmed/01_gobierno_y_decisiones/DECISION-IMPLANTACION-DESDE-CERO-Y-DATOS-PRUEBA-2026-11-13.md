---
title: "Decisión: implantación desde cero y exclusión de datos de prueba"
type: decision
status: approved
created: 2026-11-13
updated: 2026-11-13
sources:
  - "Decisión expresa del propietario de 2026-11-13"
tags: [qontrolmed, piloto, datos, greenfield, mysql]
review_after: 2026-12-13
---

# Decisión: implantación desde cero y exclusión de datos de prueba

## Decisión

La primera implantación privada de Qontrolmed partirá de bases de datos nuevas.
Las bases locales usadas durante el desarrollo contienen únicamente pruebas sin
valor para la implantación y no se migrarán, restaurarán ni reconciliarán como
datos operativos.

## Consecuencias

- se diseñará una instalación inicial canónica para `gestion`, `preventivos` y
  `quirofanos`;
- no se ejecutarán por defecto migraciones puente destinadas a instalaciones
  históricas;
- los esquemas base deben representar directamente el estado objetivo del
  piloto y aprovisionar su ledger de forma verificable;
- las pruebas usarán datos sintéticos nuevos;
- cualquier futura importación de maestros se tratará como carga funcional
  controlada, no como recuperación de la base de desarrollo;
- el runbook de reconciliación de columnas preexistentes queda diferido porque
  no responde al escenario actual.

## Límites

Partir desde cero no autoriza a borrar bases, copias o datos existentes. La
retirada de una base de pruebas o la creación de bases de implantación exige un
plan con destinos exactos, copia/reversión y confirmación de que no contiene
datos que deban conservarse.

Tampoco autoriza a omitir el contrato JSON móvil. Preventivos y Quirófanos
intercambian trabajo offline mediante ficheros JSON; sus identificadores,
relaciones, versiones, estados y reglas de conflicto forman parte del contrato
de la instalación inicial.
