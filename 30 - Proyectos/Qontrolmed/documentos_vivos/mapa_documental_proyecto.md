---
tags:
  - app
  - documentacion
Creado: 2026-06-23
Relacionado:
---

# Mapa documental del proyecto
[[masgesth]]
Fecha de revision: 2026-06-23

## Objetivo

Clasificar la documentacion del proyecto para que la siguiente sesion arranque
con las fuentes vivas correctas y no con material historico o listas
competidoras.

## Lectura recomendada al iniciar sesion

Lectura minima obligatoria:

1. `docs/security_delivery_playbook.md`
2. `docs/estado_continuidad.md`
3. `docs/plan_seguridad_consistencia.md`

Lectura solo si aplica:

- `docs/mapa_documental_proyecto.md`: tareas documentales o dudas sobre fuente
  de verdad.
- `docs/cola_triaje_campo.md`: trabajo de campo Preventivos.
- `specifications/criterios_transversales_capas.md`: cambios de arquitectura,
  persistencia, integraciones o entrega.
- notas locales de `maxgesth_port` o `maxgestq_mov`: cuando se toque ese repo.

Soporte externo no versionado:

- `D:\trabajo\Proyectos\diario_qontrolmed\sesion_YYYY-MM-DD_HH-mm.md`

## Documentacion viva canonica

### Gobierno y continuidad

- `docs/security_delivery_playbook.md`: rutina de entrada, prioridad de etapa,
  reglas de trabajo, tests y cierre.
- `docs/estado_continuidad.md`: foto ejecutiva de reanudacion y riesgos
  actuales.
- `docs/plan_seguridad_consistencia.md`: roadmap unico hacia septiembre.
- `docs/mapa_documental_proyecto.md`: clasificacion de fuentes vivas,
  historicas y de apoyo.
- `docs/Tareas Pendientes.md`: redireccion heredada; no es backlog operativo.

### Campo y modulos moviles

- `docs/cola_triaje_campo.md`: observaciones reales de Preventivos ya aceptadas
  para planificacion.
- `D:/trabajo/Proyectos/maxgesth_port/docs/security_delivery_playbook.md`: nota
  local de continuidad de Preventivos tablet.
- `D:/trabajo/Proyectos/maxgestq_mov/docs/continuidad_local.md`: nota local de
  continuidad de Quirofanos tablet.

### Especificaciones

- `specifications/criterios_transversales_capas.md`: criterios tecnicos
  transversales.
- `specifications/remote_tablet_preventivos.md`: contrato funcional
  escritorio-tablet de Preventivos.
- `specifications/modulo_analitico_y_campanas_preventivo.md`: referencia de
  campanas y analitica futura, no frente inmediato.
- `D:/trabajo/Proyectos/maxgestq_mov/specifications/remote_tablet_quirofanos_it.md`:
  contrato funcional de Quirofanos tablet.

### Producto y operativa

- `docs/documentacion_integral_proyecto_entregable.md`: documento amplio de
  proyecto; debe revisarse antes de entrega formal porque puede contener
  alcance mas extenso que la version inicial de septiembre.
- `docs/Manual/manual_usuario_final_tecnicos_hospitalarios.md`: manual
  operativo; actualizar solo cuando cambie comportamiento real.
- `docs/roles_operativos_acceso.md`: regla vigente de acceso, bootstrap y roles.
- `docs/checklist_configuracion_preproduccion.md`: ruta canonica de `.env`,
  receta de uso normal/soporte y checklist inicial de instalacion.
- `docs/migraciones_operativas_hardening.md`: orden de migraciones y diferencia
  entre script base e incremental.
- `docs/puntos_automaticos_quirofanos.md`: nota funcional de puntos por
  quirofano.

### Informes ejecutivos

- `docs/informe_ejecutivo_estado_2026-06-22.md`: revision supervisora de estado
  actual, alcance de septiembre, standby y sugerencias.

## Material historico

El material de evolucion, propuestas superadas, cierres de iteracion o fotos de
sesion no debe competir con la documentacion viva.

Ubicaciones:

- `historico_doc/` en la raiz de cada modulo para backups y snapshots
  documentales del repo.
- `proyectos/historico_doc/` conserva material historico previo existente en
  `maxgesth`.
- `docs/diario_sesiones/` conserva evidencias versionadas de sesiones pasadas
  cuando sigan siendo utiles como trazabilidad.
- diario externo en `D:\trabajo\Proyectos\diario_qontrolmed\` para partes de
  sesion no destinados a ser fuente viva.

## Regla de mantenimiento

- No mantener dos documentos vivos con el mismo objetivo.
- Si un documento deja de condicionar la siguiente sesion, moverlo a historico
  o dejarlo como redireccion explicita.
- Si una decision afecta a produccion, seguridad, pruebas, continuidad, rutas o
  contratos, actualizar playbook, continuidad y roadmap.
- Si una validacion detallada solo sirve como evidencia, dejarla en diario o
  documento tematico, no en continuidad.
- Antes de editar documentos vivos, crear copia en `historico_doc`.

## Alcance diferido

Estos documentos pueden contener vision futura, pero no deben leerse como tarea
inmediata de septiembre:

- Compras operativas.
- Informes de compra.
- Informes directivos.
- Analitica ampliada.
- Nuevas prestaciones moviles no derivadas de campo.
