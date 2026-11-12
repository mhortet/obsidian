---
title: "Piloto privado de evaluación y simplificación de requisitos"
type: decision
status: accepted
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/01_gobierno_y_decisiones/MATRIZ-P0-RIESGOS-PUERTAS-Y-RESPONSABLES-2026-11-11.md"
  - "docs/01_gobierno_y_decisiones/DECISION-CICLO-VIDA-SOPORTE-RELEASE-PILOTO-2026-11-10.md"
tags: [qontrolmed, piloto, evaluacion, alcance, simplificacion]
review_after: 2027-02-11
---

# Piloto privado de evaluación y simplificación de requisitos

## 1. Decisión

Qontrolmed se desarrollará y desplegará inicialmente como **piloto privado de
evaluación**, limitado a la empresa de un conocido del propietario. No es una
venta, un lanzamiento público ni una autorización para distribución comercial.

El objetivo es comprobar utilidad, estabilidad y encaje operativo. Solo después
de evaluar el resultado se decidirá si existe una fase comercial independiente.

## 2. Roles simplificados

- El propietario del proyecto es también mantenedor, publicador y aprobador de
  releases.
- Codex actúa como asistencia técnica, no como responsable contractual.
- La empresa piloto designará un contacto funcional cuando se prepare la sede.
- El administrador del servidor puede coincidir con el propietario durante el
  piloto.

## 3. Operación proporcional al piloto

- Soporte personal de mejor esfuerzo, sin SLA ni tiempo contractual de
  resolución.
- Franja de contacto: 08:00–22:00 cuando el mantenedor esté disponible.
- WhatsApp o teléfono para bloqueo grave, posible pérdida de datos o incidente
  de seguridad; correo para consultas, defectos no bloqueantes y mejoras.
- Releases privadas: repositorio privado, tag, hash, notas, versión vigente y
  versión anterior; el propietario publica y aprueba.
- Authenticode se aplaza hasta que exista una decisión comercial. Puede
  prepararse el punto de integración sin adquirir ni custodiar todavía una
  identidad de firma.
- No se exige dominio público ni acceso remoto para el primer piloto; se
  prioriza la LAN autorizada.
- La retención se mantiene mínima y proporcional. Los plazos que dependan de
  documentos reales se acordarán con la empresa antes de incorporarlos.

## 4. Controles que no se eliminan

La simplificación no afecta a los controles que evitan daños técnicos:

- no usar datos de pacientes ni información clínica;
- TLS verificado y puestos autorizados para MySQL;
- cuenta técnica de mínimo privilegio y sin DDL;
- migraciones manuales con copia, precheck, postcheck y restauración;
- copia independiente antes de depender de datos reales;
- restauración comprobada y posibilidad de volver a la versión anterior;
- pruebas de regresión, ausencia de secretos y trazabilidad de releases.

## 5. Requisitos diferidos a una futura fase comercial

Quedan fuera del piloto y solo se abrirán si se decide vender o distribuir:

- Authenticode productivo e identidad legal del editor;
- SLA, soporte contractual o cobertura garantizada;
- canal de distribución pública y reputación de editor;
- licencia comercial, contratos, precios y obligaciones jurídicas;
- escalado multiempresa, operación 24/7 o estructura empresarial de soporte.

## 6. Criterio de cambio de fase

El piloto no se convierte automáticamente en producto comercial. Hará falta una
nueva decisión expresa y un plan separado antes de vender, anunciar o distribuir
Qontrolmed fuera de la empresa evaluadora.
