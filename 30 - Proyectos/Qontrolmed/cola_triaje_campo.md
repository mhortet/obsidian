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
- la campana real en curso sigue funcionando y no debe considerarse afectada
  por las mejoras pendientes de esta cola;
- a fecha 2026-06-10, los informes reales de la campana activa viven en movil;
  los informes cargados en sobremesa se estan usando solo como datos ficticios
  de prueba;
- a fecha 2026-06-11, la cola incorpora dos paquetes adicionales de ergonomia
  en Preventivos escritorio:
  - uno sobre `informe_preventivo_ui`, centrado en trabajo cuantitativo, flujo
    de `NA`, reordenacion de cabecera y busqueda complementaria por serie;
  - otro sobre `pc_preventivos_ui`, centrado en navegacion por `Enter`,
    cabecera visual y busqueda viva;
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
| PTC-2026-06-10-01 | 2026-06-10 | Preventivos escritorio | media | Anadir en `informe_ui` un campo de busqueda del equipo por numero de serie. | Al preparar o revisar informes desde escritorio, la identificacion por inventario u OT no siempre es suficiente y el numero de serie es la referencia mas estable del equipo. | Mejora la localizacion del equipo y reduce tiempo de busqueda en futuras cargas o revisiones, pero no afecta a la campana real activa porque los informes reales siguen en movil. | documentado | valorar como mejora de preparacion para futuras cargas en dispositivos, sin urgencia durante la campana viva. |
| PTC-2026-06-10-02 | 2026-06-10 | Preventivos escritorio + tablet | media | Ampliar el manejo de valor objetivo en `DESF-Q01` a `DESF-Q08`, tomando como base el objetivo de BD y permitiendo editarlo y guardarlo con avance al siguiente punto. | En los ocho puntos de energia proporcionada, el tecnico necesita partir del objetivo almacenado, ajustarlo si hace falta segun la prueba real y conservar ese valor tanto en informe como en persistencia. | Mejora la fiabilidad y velocidad de captura en desfibriladores para futuras campanas, pero no corrige un bloqueo de la campana actual porque los informes reales estan en movil. | documentado | tratar como paquete funcional de preparacion para proximas cargas moviles y validar con datos ficticios antes de llevarlo a terminal real. |
| PTC-2026-06-10-03 | 2026-06-10 | Preventivos escritorio | media | Mantener filtro y orden actuales en puntos de control preventivo tras cualquier actualizacion. | Al editar un punto desde la pantalla de configuracion, la tabla puede perder el contexto de filtrado u orden en el que estaba trabajando el usuario. | Evita retrabajo y mejora ergonomia de mantenimiento maestro, sin impacto sobre la campana operativa actual. | documentado | agrupar con otras mejoras de ergonomia de escritorio cuando se abra una tanda controlada de ajustes no criticos. |
| PTC-2026-06-10-04 | 2026-06-10 | Preventivos tablet + escritorio | media | En la exportacion de resultados desde movil a sobremesa, permitir envio por bloques evitando repetir los ya enviados salvo peticion expresa de reexportacion total. | La exportacion `sobremesa -> tablet` nace desde la campana completa cargada desde `equipos_gmao` y no debe cambiarse por ahora: o toda la campana se trabaja en movil o se trabaja en papel desde sobremesa. La necesidad observada aparece al devolver informes desde movil, donde interesa poder mandar bloques parciales a sobremesa sin reenviar una y otra vez los ya transferidos. | Reduce duplicidades y paquetes repetidos en la descarga desde movil hacia sobremesa para futuras campanas, sin afectar a la operativa real actual. | documentado | tratar como ajuste del flujo `movil -> sobremesa`, manteniendo sin cambios el criterio actual de carga completa de campana hacia movil. |
| PTC-2026-06-11-01 | 2026-06-11 | Preventivos escritorio | media | Reordenar `informe_preventivo_ui` para acelerar trabajo cuantitativo: tecla `N` para fijar `NA` y avanzar, quitar columna `Observacion`, centrar `Limite`, `Estado`, `Valor leido` y `Referencia`, recolocar logo y acciones de cabecera, mostrar estado visual `En proceso` o `Cerrado`, bajar `Forzar NO APTO` y anadir selector complementario de equipo por numero de serie sin retirar la busqueda actual. | En la captura y revision de informes desde sobremesa, la cabecera actual mezcla acciones y estado, y el flujo de puntos cuantitativos exige mas clics de los necesarios cuando un control debe marcarse como `NA` o cuando se busca un equipo por serie. | Reduce tiempo repetitivo, errores de navegacion y carga visual en preparacion de futuras cargas y revisiones de campo, sin afectar la campana viva actual que sigue operando en movil. | validado localmente | implementado y validado manualmente en sobremesa; mantener solo seguimiento pasivo salvo regresion o nueva necesidad real antes de extender el patron a otras ventanas. |
| PTC-2026-06-11-02 | 2026-06-11 | Preventivos escritorio | media | Mejorar `pc_preventivos_ui` con avance al siguiente campo al pulsar `Enter`, busqueda viva mientras se escribe y logo `logo1.png` centrado en la derecha de la cabecera, revisando despues la reutilizacion del patron en ventanas compatibles. | En mantenimiento maestro de puntos, el formulario y la busqueda actual obligan a interacciones manuales adicionales y la cabecera no sigue aun la linea visual pedida para otras pantallas de Preventivos. | Mejora velocidad de alta y edicion de puntos de control, refuerza consistencia visual y reduce friccion operativa sin tocar contrato ni persistencia. | validado localmente | implementado y validado manualmente en sobremesa; reutilizar el patron solo cuando reaparezca una ventana compatible o se abra una tanda visual especifica. |

## Criterio de decision rapida

- `bloqueante`: impide terminar informes o rompe un flujo critico de campo;
- `alta`: se puede seguir trabajando, pero con riesgo real de error, retrabajo
  serio o perdida de tiempo repetida;
- `media`: molesta o degrada uso, pero el trabajo sigue siendo operativo;
- `mejora`: ajuste de ergonomia, presentacion o conveniencia sin riesgo
  operativo inmediato.
