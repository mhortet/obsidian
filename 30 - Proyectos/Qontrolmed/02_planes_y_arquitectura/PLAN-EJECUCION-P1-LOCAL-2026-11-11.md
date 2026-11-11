---
title: "Plan de ejecución P1 local"
type: plan
status: active
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/01_gobierno_y_decisiones/DECISION-AUTORIZACION-INTEGRAL-PLANES-Y-P1-LOCAL-2026-11-11.md"
  - "docs/03_operacion_y_runbooks/RUNBOOK-RECONCILIACION-TLS-CA-P0-2026-11-11.md"
  - "docs/02_planes_y_arquitectura/PROPUESTA-CUENTA-TECNICA-MYSQL-P0-2026-11-11.md"
tags: [qontrolmed, p1, tls, mysql, seguridad, ci]
review_after: 2026-11-18
---

# Plan de ejecución P1 local

## 1. Objetivo

Cerrar localmente los bloqueos críticos de conexión, mínimo privilegio y
controles de seguridad necesarios antes de construir una nueva RC.

## 2. Autorización y alcance

El propietario autorizó el bloque completo el 11 de noviembre de 2026. No se
requieren confirmaciones intermedias para sus pasos internos.

Incluye código, pruebas, CI, documentación y commits locales. Excluye conexión
al servidor, MySQL real, datos reales, credenciales, CA real, cambios de red y
construcción o instalación de una RC.

## 3. Secuencia de trabajo

### P1.1. Contrato TLS

- portar solo la política TLS y sus pruebas desde la worktree aislada;
- exigir CA y verificación de certificado e identidad fuera de loopback;
- limitar protocolos, timeouts y `LOCAL INFILE`;
- alinear configuración, ejemplo, instalador y verificador local.

### P1.2. Recuperación de conexión

- integrar la recuperación acotada en un commit separado;
- impedir reintentos ambiguos de escrituras;
- probar aceptación, agotamiento y fallos no recuperables.

### P1.3. Runtime sin DDL

- retirar el `ALTER TABLE` automático de Quirófanos;
- fallar de forma segura si falta la columna exigida;
- preparar la migración con precheck, postcheck y reversión prevista;
- probar tanto esquema correcto como esquema incompleto.

### P1.4. Seguridad de dependencias y CI

- actualizar dependencias vulnerables de forma compatible;
- convertir `pip-audit`, Bandit y Gitleaks en controles bloqueantes;
- fijar herramientas y documentar cualquier excepción temporal;
- ejecutar la batería local disponible y revisar el resultado remoto cuando se
  publique la rama.

### P1.5. Cierre documental

- actualizar evidencia, diario y relevo;
- registrar resultados reales y límites;
- no declarar superada la puerta P1 si falta alguna validación obligatoria.

## 4. Puerta de aceptación

- pruebas TLS positivas y negativas correctas;
- conexión fuera de loopback rechazada sin CA o verificación de identidad;
- cuenta runtime diseñada sin DDL ni acceso al módulo Compras;
- aplicación sin migraciones automáticas al abrir o usar funciones;
- CI sin falso verde en los tres controles de seguridad;
- `pip-audit`, Bandit y Gitleaks correctos o bloqueo explícito sin declarar
  éxito;
- ninguna RC construida y ningún sistema externo modificado.

## 5. Reversión

Cada subbloque se conservará en un commit independiente. Si falla su puerta,
no se promoverá; podrá revertirse el commit concreto sin afectar al servidor ni
a datos, porque P1 es exclusivamente local.
