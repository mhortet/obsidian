---
title: "Plan P2K: bootstrap mínimo y primera puesta en marcha de Preventivos"
type: plan
status: superseded
created: 2026-11-15
updated: 2026-11-15
sources:
  - "PLAN-EJECUCION-P2J-INTEGRACION-PREVENTIVOS-MYSQL-2026-11-13.md"
  - "../01_gobierno_y_decisiones/DECISION-IMPLANTACION-DESDE-CERO-Y-DATOS-PRUEBA-2026-11-13.md"
  - "../01_gobierno_y_decisiones/politica_datos_iniciales_piloto.md"
tags: [qontrolmed, p2, preventivos, bootstrap, runbook]
review_after: 2026-11-22
---

# Plan P2K: bootstrap mínimo y primera puesta en marcha de Preventivos

## Objetivo

Definir el estado inicial mínimo y seguro de Preventivos y documentar su primera
puesta en marcha sin reutilizar datos de desarrollo ni inventar contenido
técnico que deba validar la empresa piloto.

## Decisión técnica aplicada

El bootstrap mínimo de Preventivos es **estructura canónica y maestros
vacíos**. El DDL P2I crea las diez tablas, pero no se entregan semillas para
`tipos_equipo`, `puntos_control`, `plantillas_preventivo` ni
`plantilla_puntos`.

Esta ausencia es deliberada: los límites y relaciones de una plantilla forman
parte del procedimiento técnico del usuario. Sembrar los valores históricos de
desarrollo los convertiría de hecho en configuración aprobada sin haberlos
contrastado.

## Alcance

- fijar los prechecks y el orden de aplicación del DDL P2I;
- definir el punto de retorno y la reversión de una base nueva;
- verificar las diez tablas y la ausencia de datos operativos y maestros;
- separar la carga funcional posterior del DDL y de las migraciones;
- añadir pruebas estáticas para impedir semillas accidentales;
- registrar el procedimiento en un runbook reutilizable.

## Límites

- sin conexión a MySQL ni ejecución de SQL en P2K;
- sin servidor, cuentas, firewall, CA, copias reales ni datos de empresa;
- sin importar la base local de desarrollo ni invocar `semillas_service.py`;
- sin construir una RC ni modificar los repositorios móviles;
- sin definir todavía el contenido de las plantillas del piloto.

## Validación

- pruebas unitarias del contrato greenfield y del contrato P2K;
- suite completa de tests;
- validación del manifiesto de migraciones, Bandit y `git diff --check`;
- revisión documental de precheck, postcheck, aborto y reversión.

## Reversión

P2K solo modifica ficheros versionados. Revertir su commit elimina el plan, el
runbook y sus pruebas. No existe reversión de base de datos porque el bloque no
abre MySQL ni ejecuta DDL.

## Criterio de cierre

El bloque queda cerrado cuando el runbook permite ejecutar una futura ventana
con destinos exactos y cuando las pruebas demuestran que el DDL canónico sigue
sin contener semillas. La ejecución real o sintética del runbook será otro
bloque con autorización de infraestructura independiente.

## Resultado

- Bootstrap mínimo fijado como estructura canónica y diez tablas vacías.
- Runbook creado con precheck, postcheck, aborto, reversión y evidencia.
- Prueba de regresión añadida para impedir semillas accidentales.
- Validación local: 91 pruebas, manifiesto, compilación, Bandit y
  `git diff --check` correctos.
- Sin conexión a MySQL, servidor, datos reales ni construcción de RC.

## Corrección posterior

El 15 de noviembre el propietario aclaró que deben conservarse los cuatro
maestros existentes y comenzar vacías únicamente las seis tablas operativas.
La interpretación «maestros vacíos» queda sustituida por
`DECISION-CONSERVAR-MAESTROS-PREVENTIVOS-SIN-HISTORICO-2026-11-15.md` y P2L.
