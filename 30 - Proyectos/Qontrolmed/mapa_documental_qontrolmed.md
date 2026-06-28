---
title: "Mapa documental Qontrolmed"
type: project
status: active
created: 2026-06-28
updated: 2026-06-28
sources: []
tags: [qontrolmed, documentacion, mapa]
review_after: 2026-09-28
---

# Mapa documental Qontrolmed

## Documentos vivos en raiz

| Documento | Papel |
| --- | --- |
| [[README]] | Entrada limpia del proyecto. |
| [[security_delivery_playbook]] | Rutina de entrada, trabajo, validacion y cierre. |
| [[estado_continuidad]] | Foto viva de reanudacion. |
| [[plan_seguridad_consistencia]] | Roadmap maestro vigente. |
| [[cola_triaje_campo]] | Incidencias y mejoras reales de campo. |
| [[evolucion_proyecto]] | Diario sintetico de evolucion. |
| [[mapa_documental_qontrolmed]] | Este mapa documental. |

## Gobierno y decisiones

Carpeta: `01_gobierno_y_decisiones/`

| Documento | Motivo |
| --- | --- |
| `propuesta_modelo_roles_permisos.md` | Diseno objetivo de autorizacion. |
| `roles_operativos_acceso.md` | Regla operativa vigente de acceso y compatibilidad. |
| `migraciones_operativas_hardening.md` | Orden y criterio de migraciones manuales. |
| `migracion_centros_gestion.sql` | Migracion funcional de `cecos` a maestro ampliado de Centros. |
| `Legalizar.md` | Propiedad intelectual, marca, RGPD y criterios legales preliminares. |

## Historico

Carpeta: `02_historico/`

Documentos conservados por trazabilidad, pero absorbidos por documentos vivos o por evolucion posterior:

- `Roadmap.md`
- `puntos_automaticos_quirofanos.md`
- `Pos revisión flujo de preventivos.md`
- `Referencias de documentos.md`
- `plan_upgrade_mysql_8_0_44_a_8_4_lts.md`
- `checklist_validacion_hardening_permisos_ventanas.md`
- `historial_actualizacion_puntos_control_20260614.md`
- `Módulo compras.md`
- `Módulo informe.md`

## Entregables

Carpeta: `03_entregables/`

- `documentacion_integral_proyecto_entregable.md`
- `Informe módulo Quirófano.md`
- `Informe sobre módulo preventivos.md`

Estos documentos son utiles para comunicacion, manuales, defensa funcional o redaccion formal, pero no deben competir con el roadmap vivo.

## Subcarpetas no revisadas en esta limpieza

No se han reorganizado:

- `capturas Manual/`
- `capturas temporales/`
- `dario_app/`
- `documentos_vivos/`
- `promps/`

## Regla de mantenimiento

- Si un documento cambia prioridad, continuidad o decision activa, debe reflejarse en la raiz o en `01_gobierno_y_decisiones/`.
- Si un documento solo conserva historia, moverlo a `02_historico/`.
- Si un documento esta pensado para entrega, comunicacion o manual, moverlo a `03_entregables/`.
- No crear backlogs paralelos si `plan_seguridad_consistencia.md` ya cubre la prioridad.
