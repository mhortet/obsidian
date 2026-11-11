# Cola de triage de campo
[[masgesth]]
Fecha de arranque: 2026-06-09
Fecha de revision: 2026-06-22

Este documento recoge observaciones reales de campo antes de convertirlas en
tareas tecnicas. Tras las pruebas de campo, las indicaciones aqui recogidas se
dan por buenas para planificacion.

No sustituye al roadmap:

1. `docs/plan_seguridad_consistencia.md`
2. `docs/estado_continuidad.md`
3. `docs/security_delivery_playbook.md`

## Estado actual

- Las observaciones de campo quedan aceptadas como entrada valida.
- No hay bloqueo confirmado que impida continuar la campana.
- Las entradas `alta` deben entrar en el bloque de preparacion de septiembre.
- Las entradas `media` se agrupan como mejoras de eficiencia y fiabilidad para
  ejecutar si no desplazan hardening, instalacion ni consistencia.
- Las entradas ya validadas localmente quedan en seguimiento pasivo.

## Regla de uso

- Anotar solo incidencias o mejoras observadas en uso real.
- No duplicar entradas: si reaparecen, actualizar estado e impacto.
- `bloqueante` y `alta` pueden romper prioridad general.
- `media` y `mejora` se programan por paquete, no como interrupciones sueltas.
- Si una entrada toca tablet y sobremesa, revisar contrato JSON y persistencia
  en ambos lados antes de programar.

## Cola operativa aceptada

| ID | Modulo | Severidad | Decision 2026-06-22 | Estado |
| --- | --- | --- | --- | --- |
| PTC-2026-06-09-03 | Preventivos tablet + escritorio | alta | Anadir `observaciones` al final del formulario movil y asegurar exportacion/importacion hacia sobremesa. Entra como prioridad alta para septiembre por riesgo de perdida de contexto tecnico. | aceptado para planificar |
| PTC-2026-06-09-05 | Preventivos tablet | alta | Permitir marcado `NA` en puntos cuantitativos cuando el control no aplique. Entra como prioridad alta porque puede impedir cerrar informes validos. | aceptado para planificar |
| PTC-2026-06-09-02 | Preventivos tablet | media | Mostrar numero de serie e inventario en `equipo`, reduciendo dependencia operativa de OT. Agrupar con mejoras de identificacion de equipo. | aceptado para paquete medio |
| PTC-2026-06-09-04 | Preventivos tablet + escritorio | media | Incluir valor de referencia seleccionado en los 8 puntos de `energia proporcionada`, alineado con app principal. Agrupar con ajustes DESF. | aceptado para paquete medio |
| PTC-2026-06-10-01 | Preventivos escritorio | media | Anadir busqueda de equipo por numero de serie en escritorio. Agrupar con identificacion de equipo y preparacion de futuras cargas. | aceptado para paquete medio |
| PTC-2026-06-10-02 | Preventivos escritorio + tablet | media | Ampliar manejo de objetivo en `DESF-Q01` a `DESF-Q08`, permitiendo editar y guardar referencia real. Agrupar con energia proporcionada. | aceptado para paquete medio |
| PTC-2026-06-10-03 | Preventivos escritorio | media | Mantener filtro y orden tras actualizar puntos de control. Paquete de ergonomia de mantenimiento, no critico para septiembre salvo tanda disponible. | aceptado para paquete medio |
| PTC-2026-06-10-04 | Preventivos tablet + escritorio | media | Permitir exportacion movil -> sobremesa por bloques evitando reenviar lo ya enviado. Decidir si entra en septiembre segun circuito inicial de descarga. | pendiente de decision de alcance |
| PTC-2026-06-11-01 | Preventivos escritorio | media | Reordenacion ergonomica de `informe_preventivo_ui`, tecla `N` para `NA`, estado visual, cabecera y busqueda complementaria. Ya validado localmente. | seguimiento pasivo |
| PTC-2026-06-11-02 | Preventivos escritorio | media | Mejora de `pc_preventivos_ui`: avance con `Enter`, busqueda viva y cabecera visual. Ya validado localmente. | seguimiento pasivo |
| PTC-2026-06-09-01 | Preventivos tablet | mejora | Renombrar entrada como `Qontrolmed movil`, segunda linea `preventivos` y valorar icono visible. Aplicar si hay tanda de identidad/ergonomia antes del corte. | mejora opcional |

## Detalle funcional de entradas prioritarias

### Observaciones en campo

- Deben permitir recoger informacion no estructurada sin recurrir a papel.
- Deben viajar en exportacion desde tablet y quedar disponibles en sobremesa.
- Antes de implementar, revisar impacto en persistencia, importacion, PDF y
  historico de informe.

### `NA` en puntos cuantitativos

- Debe permitir cerrar informes validos cuando un punto no aplique al equipo.
- Debe diferenciarse de campo vacio, error de captura o valor pendiente.
- Antes de implementar, revisar validacion de cierre, calculo de resultado y
  representacion en PDF/importacion.

## Paquetes recomendados

### Paquete A - septiembre, alta prioridad

- Observaciones tablet -> sobremesa.
- `NA` cuantitativo.
- Validacion conjunta de contrato, persistencia y PDF.

### Paquete B - eficiencia de campo

- Serie e inventario visibles en equipo.
- Busqueda por numero de serie en escritorio.
- Referencias `DESF-Q01` a `DESF-Q08`.

### Paquete C - ergonomia y flujo

- Exportacion por bloques si se confirma necesaria.
- Filtro/orden persistente en mantenimiento.
- Naming visual `Qontrolmed movil / preventivos`.

## Criterio de decision rapida

- `bloqueante`: impide terminar informes o rompe un flujo critico de campo.
- `alta`: permite seguir, pero con riesgo real de error, perdida de informacion
  o retrabajo serio.
- `media`: degrada eficiencia o fiabilidad, pero no bloquea operativa.
- `mejora`: coherencia visual o comodidad sin riesgo operativo inmediato.
