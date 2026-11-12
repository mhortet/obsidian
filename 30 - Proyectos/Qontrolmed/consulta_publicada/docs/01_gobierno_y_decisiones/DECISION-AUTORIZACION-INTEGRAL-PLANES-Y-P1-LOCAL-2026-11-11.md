---
title: "Autorización integral de planes de trabajo y P1 local"
type: decision
status: accepted
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md"
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P0-PRODUCCION-READINESS-2026-11-11.md"
  - "docs/03_operacion_y_runbooks/RUNBOOK-RECONCILIACION-TLS-CA-P0-2026-11-11.md"
tags: [qontrolmed, autorizacion, planes, p1, gobernanza]
review_after: 2026-12-11
---

# Autorización integral de planes de trabajo y P1 local

## 1. Decisión del propietario

El 11 de noviembre de 2026 el propietario autorizó íntegramente el bloque P1
local propuesto y estableció como regla general que los planes de trabajo del
proyecto se autorizan completos, no paso a paso.

Esto significa que, una vez definido y registrado un plan con alcance, límites,
validaciones y reversión, su ejecución ordinaria incluye todos sus pasos,
pruebas, documentación y commits. No se debe interrumpir el bloque para pedir
de nuevo autorización sobre cada acción ya comprendida en él.

## 2. P1 local autorizado

La autorización cubre el bloque completo siguiente:

1. integrar TLS verificado y recuperación de conexión en commits separados;
2. excluir el cambio histórico de identificadores de marcas;
3. diseñar la cuenta MySQL de runtime sin DDL ni administración;
4. separar las migraciones en una cuenta y procedimiento administrativos;
5. retirar el `ALTER TABLE` ejecutado durante el uso normal;
6. convertir `pip-audit`, Bandit y Gitleaks en controles bloqueantes;
7. mantener fuera de este bloque el servidor, los datos reales y la
   construcción o instalación de una RC.

También están autorizadas las acciones normales necesarias para terminarlo:
inspección del código, edición local, creación de pruebas, ejecución de
validaciones, actualización documental y commits trazables en la rama P1.

## 3. Regla permanente de ejecución por planes

Para nuevos bloques se aplicará este criterio:

- el plan debe identificar objetivo, alcance, límites, riesgos, pruebas y
  reversión;
- una vez registrado, se considera autorizado en su totalidad dentro del
  alcance vigente del proyecto;
- no se solicitan aprobaciones repetidas para sus pasos internos;
- solo se vuelve al propietario si aparece una ampliación material no cubierta,
  falta una decisión funcional que no puede inferirse o surge un riesgo nuevo
  que haga inseguro continuar con el plan original.

Para cambios de alto impacto —servidor, red, firewall, base real, CA, copias
externas, puestos, poda o reescritura de Git— seguirá siendo obligatorio crear
antes un plan independiente con destinos exactos, precondiciones, verificación
y reversión. La presente delegación permite ejecutar el plan completo una vez
registrado, pero no permite actuar sin plan ni ampliar silenciosamente su
alcance.

## 4. Límites que permanecen vigentes

La decisión no elimina controles técnicos o de seguridad:

- no usar datos de pacientes, datos clínicos, secretos, credenciales ni `.env`
  reales en código, pruebas o evidencias;
- no sustituir información externa desconocida por valores inventados;
- no publicar, desplegar ni declarar producción sin superar sus puertas;
- respetar las confirmaciones impuestas por la plataforma o el entorno de
  ejecución cuando sean técnicamente obligatorias;
- documentar cualquier desviación material y detener el bloque si su reversión
  deja de ser segura.

## 5. Reversión de la decisión

El propietario puede revocar o restringir esta delegación para un bloque
posterior. Hasta que eso ocurra, esta decisión es la fuente vigente sobre cómo
interpretar la autorización de los planes de trabajo.
