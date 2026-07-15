---
tags:
  - app
  - documentacion
Creado: 2026-06-09
Relacionado:
---

# Cola de triage de campo
[[masgesth]]
Fecha de arranque: 2026-06-09
Fecha de revision: 2026-07-14

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
- Las entradas `alta` ya validadas quedan cerradas salvo regresion.
- Las entradas de eficiencia de campo ya cerradas en `maxgesth_port` quedan en
  seguimiento pasivo y no deben reabrirse salvo regresion.
- Las entradas ya validadas localmente quedan en seguimiento pasivo.
- No quedan entradas funcionales abiertas para el corte inicial de septiembre.
- La exportacion movil -> sobremesa por lotes queda aplazada para una revision
  posterior de estabilizacion.

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
| PTC-2026-06-09-03 | Preventivos tablet + escritorio | alta | Anadir `observaciones` al final del formulario movil y asegurar exportacion/importacion hacia sobremesa. Validado manualmente el 2026-07-12, incluida salida PDF. | validado manualmente |
| PTC-2026-06-09-05 | Preventivos tablet | alta | Permitir marcado `NA` en puntos cuantitativos cuando el control no aplique. Validado manualmente el 2026-07-12, incluida salida PDF. | validado manualmente |
| PTC-2026-06-09-02 | Preventivos tablet | media | Mostrar numero de serie e inventario en `equipo`, reduciendo dependencia operativa de OT. Cerrado en `maxgesth_port` y tagueado en `preventivos-pruebas-campo-2026-07-13`. | cerrado / seguimiento pasivo |
| PTC-2026-06-09-04 | Preventivos tablet + escritorio | media | Incluir valor de referencia seleccionado en los 8 puntos de `energia proporcionada`, alineado con app principal. Cerrado en `maxgesth_port` dentro del tag `preventivos-pruebas-campo-2026-07-13`. | cerrado / seguimiento pasivo |
| PTC-2026-06-10-01 | Preventivos escritorio | media | Anadir busqueda de equipo por numero de serie en escritorio. Queda absorbido por el cierre de identificacion de equipo y validaciones previas; reabrir solo por regresion real. | cerrado / seguimiento pasivo |
| PTC-2026-06-10-02 | Preventivos escritorio + tablet | media | Ampliar manejo de objetivo en `DESF-Q01` a `DESF-Q08`, permitiendo editar y guardar referencia real. Cerrado en `maxgesth_port` dentro del tag `preventivos-pruebas-campo-2026-07-13`. | cerrado / seguimiento pasivo |
| PTC-2026-06-10-03 | Preventivos escritorio | media | Mantener filtro y orden tras actualizar puntos de control. Mejora ergonomica aparcada; no compite con septiembre salvo regresion real. | seguimiento pasivo |
| PTC-2026-06-10-04 | Preventivos tablet + escritorio | media | Permitir exportacion movil -> sobremesa por lotes evitando reenviar lo ya enviado. Aplazada el 2026-07-14; revisar tras estabilizar el circuito inicial. | aplazada / fuera del corte inicial |
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

Estado: validado manualmente el 2026-07-12.

- Observaciones tablet -> sobremesa.
- `NA` cuantitativo.
- Validacion conjunta de contrato, persistencia y PDF.

### Paquete B - eficiencia de campo

Estado: cerrado en `maxgesth_port` y tagueado como
`preventivos-pruebas-campo-2026-07-13`.

- Serie e inventario visibles en equipo.
- Busqueda por numero de serie en escritorio.
- Referencias `DESF-Q01` a `DESF-Q08`.

### Decision cerrada - exportacion por lotes

- Queda aplazada para una revision posterior y fuera del corte inicial de
  septiembre.
- Se mantiene el contrato actual tablet-sobremesa.
- Solo se reabrira con necesidad operativa confirmada y definiendo antes el
  criterio anti-duplicados, la validacion de escritorio y la prueba Android.

### Mejoras aparcadas sin prioridad de septiembre

- Filtro/orden persistente en mantenimiento salvo regresion.
- Naming visual `Qontrolmed movil / preventivos`.

## Criterio de decision rapida

- `bloqueante`: impide terminar informes o rompe un flujo critico de campo.
- `alta`: permite seguir, pero con riesgo real de error, perdida de informacion
  o retrabajo serio.
- `media`: degrada eficiencia o fiabilidad, pero no bloquea operativa.
- `mejora`: coherencia visual o comodidad sin riesgo operativo inmediato.
