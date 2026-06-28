---
title: "Qontrolmed"
type: project
status: active
created: 2026-06-28
updated: 2026-06-28
sources: []
tags: [qontrolmed, proyecto, continuidad]
review_after: 2026-09-28
---

# Qontrolmed

Entrada limpia del proyecto. Esta raiz queda reservada para continuidad, direccion de trabajo y documentos de arranque.

## Lectura recomendada

1. [[security_delivery_playbook]]: ritual de entrada, criterios de ramas, tests y cierre.
2. [[estado_continuidad]]: foto viva del estado actual y proxima tarea recomendada.
3. [[plan_seguridad_consistencia]]: roadmap maestro y prioridades vigentes.
4. [[cola_triaje_campo]]: incidencias y mejoras reales detectadas en campo.
5. [[evolucion_proyecto]]: diario sintetico de evolucion del proyecto.
6. [[mapa_documental_qontrolmed]]: que documentos estan vivos, cuales son historicos y donde quedaron archivados.

## Criterio de organizacion

- La raiz contiene solo documentos de continuidad y gobierno inmediato.
- `01_gobierno_y_decisiones/` conserva diseno funcional, seguridad, migraciones y decisiones tecnicas aun utiles.
- `02_historico/` conserva documentos absorbidos, validaciones puntuales y planes ya superados.
- `03_entregables/` conserva informes o documentos pensados para entrega, manual o comunicacion.
- Las subcarpetas existentes de capturas, diario, prompts y documentos vivos no se han reordenado en esta limpieza.

## Estado operativo resumido

- Preventivos y Quirofanos estan en mantenimiento correctivo guiado por campo.
- El frente principal vigente es hardening transversal y readiness de produccion.
- Las lineas maduras actuales son acceso/login, roles/permisos, auditoria, ventanas unicas, migraciones controladas y consistencia documental.
- Cualquier incidencia real de campo con severidad alta o bloqueante puede romper la prioridad general.

## Regla de promocion

Los documentos operativos pueden madurar hacia:

- conceptos curados en `20 - Notas enlazadas/Conceptos/`;
- procesos en `20 - Notas enlazadas/Procesos/`;
- entregables formales en `03_entregables/`;
- historico si ya fueron absorbidos por documentos vivos.
