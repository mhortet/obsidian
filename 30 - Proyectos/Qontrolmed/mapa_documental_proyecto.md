# Mapa documental del proyecto
[[masgesth]]
Fecha de revision: 2026-06-14

## Objetivo

Separar la documentacion viva del material historico y dejar clara la fuente de
verdad de cada decision para que la siguiente sesion no arranque con referencias
duplicadas o backlog competidor.

## Lectura recomendada al iniciar sesion

Orden minimo obligatorio fijado por el playbook:

1. `docs/security_delivery_playbook.md`
2. `docs/estado_continuidad.md`
3. `docs/plan_seguridad_consistencia.md`
4. `docs/mapa_documental_proyecto.md`

Lectura transversal adicional recomendada justo despues:

- `specifications/criterios_transversales_capas.md`

Lectura de apoyo segun tarea:

- `specifications/remote_tablet_preventivos.md`
- `specifications/modulo_analitico_y_campanas_preventivo.md`
- `docs/documentacion_integral_proyecto_entregable.md`
- `docs/Manual/manual_usuario_final_tecnicos_hospitalarios.md`
- `docs/puntos_automaticos_quirofanos.md`

Soporte externo no versionado:

- `D:\trabajo\Proyectos\diario_qontrolmed\sesion_YYYY-MM-DD_HH-mm.md`

## Documentacion viva

### Continuidad y gobierno tecnico

- `docs/plan_seguridad_consistencia.md`: roadmap unico, prioridades activas,
  estados de linea y criterios de cierre.
- `docs/estado_continuidad.md`: foto operativa de reanudacion, riesgos,
  siguiente tarea recomendada y pendientes de informacion.
- `docs/security_delivery_playbook.md`: rutina de entrada, reglas de ramas,
  tests, diario externo y politica de cierre.
- `docs/Tareas Pendientes.md`: redireccion controlada al roadmap maestro; no se
  usa como backlog independiente.

### Especificaciones funcionales y tecnicas

- `specifications/criterios_transversales_capas.md`: criterios obligatorios de
  consistencia, seguridad y estabilidad.
- `specifications/remote_tablet_preventivos.md`: contrato funcional de
  Preventivos escritorio-tablet.
- `specifications/modulo_analitico_y_campanas_preventivo.md`: base de campanas
  y evolucion analitica objetivo de Preventivos y Quirofanos.

### Documentacion de producto y operativa

- `docs/documentacion_integral_proyecto_entregable.md`: documento tecnico y
  funcional consolidado para entrega.
- `docs/diario_sesiones/`: diario breve versionado para futura integracion con
  Obsidian como capa de conocimiento operativo.
- `docs/Manual/manual_usuario_final_tecnicos_hospitalarios.md`: manual de uso
  operativo.
- `docs/checklist_validacion_hardening_permisos_ventanas.md`: guia ejecutable
  para el smoke test manual de permisos, foco y ventana unica antes de abrir
  `auditoria`.
- `docs/migraciones_operativas_hardening.md`: orden recomendado de migraciones
  manuales y diferencia entre script base y migracion incremental.
- `docs/roles_operativos_acceso.md`: regla operativa vigente de acceso,
  bootstrap y correspondencia actual entre `es_tecnico` y roles.
- `docs/propuesta_modelo_roles_permisos.md`: modelo objetivo de roles,
  permisos, bootstrap de `superusuario` e implantacion progresiva.
- `docs/puntos_automaticos_quirofanos.md`: nota funcional vigente de la
  asignacion automatica de puntos por quirofano.

## Material historico

El material de evolucion, propuestas superadas, cierres de iteracion o
fotografias de sesion ya no debe competir con la documentacion viva. Debe
vivir en:

- `proyectos/historico_doc/`

Regla de uso:

- si un documento describe una decision ya implantada, una propuesta ya
  resuelta o una fotografia de una sesion concreta, debe ir a historico;
- si un documento condiciona la siguiente sesion o la forma actual de trabajar,
  debe quedarse en `docs/` o `specifications/`;
- si una nota sirve solo para dejar rastro de una sesion, debe ir al diario
  externo fuera del repo, no a `docs/`.

## Criterio de mantenimiento

- No mantener dos documentos vivos con el mismo objetivo.
- Si un documento deja de ser fuente de verdad, moverlo a historico o dejarlo
  como redireccion explicita.
- Si una decision afecta a produccion, seguridad, pruebas, continuidad o rutas,
  actualizar roadmap, playbook y continuidad.
- Si una sesion cambia el estado real del trabajo, resumirlo tambien en el
  diario externo.
