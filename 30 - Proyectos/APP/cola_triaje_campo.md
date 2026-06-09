# Cola de triage de campo
[[masgesth]]
Fecha de arranque: 2026-06-09

Este documento no sustituye al roadmap ni a `docs/estado_continuidad.md`.
Su funcion es servir como cola operativa para volcar incidencias reales de
campo antes de decidir si alguna merece romper la prioridad general.

Fuentes de verdad que mandan sobre prioridad y continuidad:

1. `docs/plan_seguridad_consistencia.md`
2. `docs/estado_continuidad.md`
3. `docs/security_delivery_playbook.md`

## Regla de uso

- anotar aqui solo incidencias o mejoras detectadas en uso real;
- cada entrada debe describirse de forma corta, reproducible y accionable;
- la severidad debe seguir la cola definida en
  `docs/plan_seguridad_consistencia.md`:
  - `bloqueante`
  - `alta`
  - `media`
  - `mejora`
- solo `bloqueante` o `alta` puede romper la prioridad general del roadmap;
- si una observacion aun no esta bien descrita, dejarla en la seccion
  `pendientes_por_redactar` y no convertirla todavia en tarea tecnica.

## Estado actual

- el flujo `Qontrolmed -> APK tablet -> importacion local -> tecnico asignado ->
  clase o tipo de equipo por defecto` ha quedado validado en terminal real el
  2026-06-09;
- no hay a esta fecha ningun bloqueo confirmado abierto en Preventivos tablet;
- las primeras observaciones reales de campo ya quedan documentadas en esta
  cola con severidad provisional y decision explicita de no abrir todavia
  correctivos de codigo salvo que aparezca recurrencia, volumen significativo o
  bloqueo real de operativa.

## Pendientes por redactar

- sin entradas abiertas a esta fecha.

## Cola operativa

| ID | Fecha | Modulo | Severidad | Resumen | Reproduccion | Impacto real | Estado | Decision siguiente sesion |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| PTC-2026-06-09-01 | 2026-06-09 | Preventivos tablet | mejora | Renombrar la ventana de entrada como `Qontrolmed movil`, segunda linea `preventivos` y valorar icono visible. | Al abrir la app movil, la pantalla de entrada no refleja aun el naming funcional final esperado en campo. | Mejora de coherencia visual e identificacion del producto; no bloquea trabajo real. | documentado | mantener en cola y aplicar solo cuando haya tanda de ergonomia o si surge confusion real de usuarios. |
| PTC-2026-06-09-02 | 2026-06-09 | Preventivos tablet | media | En el campo `equipo`, mostrar numero de serie e inventario y no depender operativamente de OT como referencia principal de campo. | En trabajo por OT no aporta identificacion suficiente y puede faltar o borrarse la pegatina de inventario; el dato persistente y unico es el numero de serie. | Riesgo medio de identificar mal el equipo o de perder tiempo en comprobaciones manuales durante la campana. | documentado | observar recurrencia real en la siguiente tanda de pruebas antes de abrir correctivo. |
| PTC-2026-06-09-03 | 2026-06-09 | Preventivos tablet + escritorio | alta | Anadir `observaciones` al final del formulario movil y asegurar exportacion/importacion hacia sobremesa. | En campo, cuando aparece informacion no estructurada y no existe este hueco, hay que recurrir a papel para no perderla. | Riesgo alto de perdida de contexto tecnico y retrabajo administrativo al volver a escritorio. | documentado | priorizar solo si se confirma repeticion o si se detecta perdida real de informacion en la siguiente descarga. |
| PTC-2026-06-09-04 | 2026-06-09 | Preventivos tablet + escritorio | media | Incluir el valor de referencia seleccionado en los 8 puntos de `energia proporcionada`, alineado tambien con la app principal. | En desfibriladores, el usuario necesita introducir manualmente el valor de referencia para que la validacion por margenes use el dato correcto de cada prueba. | Riesgo medio de validacion cuantitativa incompleta o poco fiable en una familia concreta de equipos. | documentado | contrastar en la siguiente tanda cuantos informes reales quedan afectados antes de convertirlo en correctivo. |
| PTC-2026-06-09-05 | 2026-06-09 | Preventivos tablet | alta | Permitir marcado `NA` en puntos cuantitativos cuando el control no aplique al equipo. | Hay desfibriladores que no incorporan algunos puntos de control y la app no permite cerrar el informe si todos los puntos no quedan rellenados. | Riesgo alto porque puede impedir finalizar informes validos en campo y forzar trabajo manual alternativo. | documentado | si reaparece en mas de un equipo o bloquea cierres reales, abrir correctivo inmediato. |

## Criterio de decision rapida

- `bloqueante`: impide terminar informes o rompe un flujo critico de campo;
- `alta`: se puede seguir trabajando, pero con riesgo real de error, retrabajo
  serio o perdida de tiempo repetida;
- `media`: molesta o degrada uso, pero el trabajo sigue siendo operativo;
- `mejora`: ajuste de ergonomia, presentacion o conveniencia sin riesgo
  operativo inmediato.
