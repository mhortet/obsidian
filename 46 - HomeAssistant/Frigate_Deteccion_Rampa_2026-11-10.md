---
title: Frigate — detección y estado de la rampa
created: 2026-11-10
tags:
  - Frigate
  - camaras
  - homeAssistant
---

# Frigate: detección y estado de la rampa

## Objetivo

Usar la Tapo C200 y Frigate para determinar si la rampa está ocupada por un coche y controlar después la iluminación desde Home Assistant. La cámara está bajo techo y no recibe directamente la lluvia.

## Resumen del diagnóstico actual

- Frigate **sí detectó el coche dentro de las zonas**. El polígono y la asociación de zonas funcionan.
- El seguimiento del coche terminó cuando el coche seguía aparcado en la rampa. Por tanto, «Coche ha salido» en ese seguimiento no describía una salida física: Frigate perdió o cerró el seguimiento del objeto.
- No se encontró un máximo de fotogramas configurado para los objetos estacionarios, ni global ni por objeto/cámara.
- La causa concreta de que Frigate deje de seguir el coche todavía no está identificada. No conviene seguir cambiando la zona o la inercia hasta revisar el seguimiento al quedarse estacionario.

## Contexto del problema

Tras una noche de lluvia intensa, la automatización basada en reconocimiento de la cámara empezó a dispararse repetidamente y se deshabilitó. La lluvia no alcanza físicamente la cámara. Es posible que el suelo mojado, los reflejos o los cambios de imagen influyeran en la detección, pero no se han revisado los clips de esos falsos disparos, así que esa causa no está confirmada.

Antes de la lluvia se había subido el ajuste de fotogramas mínimos de inicialización de 2 a 3 para reducir los cambios entre «rampa libre» y «rampa ocupada». Con 3 dejó de detectar el coche en la zona; con 1 lo detecta, pero la ocupación cae enseguida. La inicialización del objeto y la inercia de zona son ajustes distintos.

## Zonas y entidades

La cámara es una **Tapo C200** integrada con Frigate. Se definieron varias zonas, entre ellas:

- `zona_rampa_estado`
- `Zona_deteccion`
- `Estado_Rampa`

La zona `zona_rampa_estado` se amplió durante las pruebas hasta cubrir prácticamente todo el encuadre. En el editor de zonas se veían cinco puntos y el área sombreada en azul. Está habilitada; tiene seleccionados **Coche** y **Motocicleta**, con **Persona** y **Todos los objetos** desactivados. El tiempo de merodeo está a `0`.

Frigate asigna un objeto a una zona según el **centro del borde inferior de su caja delimitadora**, no según cuánto se solape la carrocería con el polígono. Por eso las zonas representan áreas en la imagen y no volúmenes físicos. En este caso, sin embargo, el historial de seguimiento confirma que el coche sí entró en la zona.

## Cómo interpretar los sensores de Home Assistant

- **`Car count`**: recuento de coches detectados en la cámara o en la zona correspondiente.
- **`Car Active Count`**: recuento de coches considerados activos/en movimiento. Puede ser `0` con un coche aparcado.
- **`Car occupancy`**: sensor binario de ocupación para automatizaciones rápidas. Puede activarse con menos filtros y no es una confirmación infalible.
- **`Motion`**: movimiento en la imagen; no significa por sí solo que se haya reconocido un coche o una persona.
- Los sensores de la cámara general cubren toda la imagen. Los de una zona solo reflejan los objetos que Frigate asigna a esa zona.

En una captura general aparecía `Tapo C200 Car Count: 1`, `Car occupancy: Detectado` y `Car Active Count: 0`. Eso es compatible con un coche aparcado. En la vista del dispositivo de zona, la ocupación llegó a encenderse brevemente y volvió a apagarse.

## Ajustes de detección global y por cámara

Frigate permite un valor global y sobrescrituras por cámara. Una cámara puede tener la detección de objetos habilitada aunque el valor global esté deshabilitado, si la cámara tiene la opción local habilitada. En este montaje, la detección global estaba deshabilitada y la detección de la Tapo habilitada localmente; el recuento general de coche confirma que la detección estaba funcionando.

Los parámetros de la zona y los de seguimiento global son independientes:

- **Inercia de zona**: número de fotogramas consecutivos que el objeto debe cumplir la condición de zona antes de considerarse dentro.
- **Fotogramas mínimos de inicialización** (`min_initialized`): detecciones consecutivas necesarias para crear el objeto seguido.
- **Fotogramas máximos desaparecido** (`max_disappeared`): tolerancia sin detecciones antes de considerar que el objeto seguido ha desaparecido.
- **Fotogramas máximos estacionario** (`stationary.max_frames`): límite explícito para conservar un objeto estacionario. No debe configurarse para coches si se quiere mantener su ocupación mientras permanecen aparcados.

Un campo vacío en Frigate suele significar que se usa el valor predeterminado o que se hereda el valor global, según el nivel de configuración; no equivale automáticamente a cero.

## Configuración observada

### Zona `zona_rampa_estado`

- Habilitada.
- Objetos: coche y motocicleta.
- Inercia: se probó `1`, `2` y `3`; en la última captura estaba en `1`.
- Tiempo de merodeo: `0`.
- Con inercia `1` hubo una entrada breve; con `3` no se consiguió una detección mantenida.

### Cámara Tapo C200 — objetos estacionarios

En la configuración de cámara se observaron:

- Intervalo estacionario: `30` fotogramas.
- Umbral estacionario: `30` fotogramas.
- Fotogramas máximos predeterminados: vacío.
- Sin límites por objeto añadidos.
- Clasificador visual: habilitado.

Los `30` son fotogramas, no segundos; el tiempo equivalente depende de los FPS de detección.

### Configuración global

En la pantalla global se observaron vacíos:

- Fotogramas mínimos de inicialización.
- Fotogramas máximos desaparecido.
- Intervalo y umbral estacionarios.
- Fotogramas máximos estacionario: se comprobó que no había valores globales ni límites por objeto.

Los campos vacíos usan los valores predeterminados. El máximo de fotogramas estacionario está sin configurar, por lo que no hay un plazo explícito para descartar un coche aparcado. El máximo desaparecido es un parámetro distinto: gestiona la pérdida del seguimiento cuando faltan detecciones.

## Seguimiento del coche revisado en Explore

Se localizó el detalle en **Explore** (icono de lupa en Frigate), pestaña **Detalles de seguimiento**. La captura del objeto mostraba:

| Hora | Suceso | Puntuación visible |
|---|---|---:|
| 13:44:42 | Coche detectado | 66 % |
| 13:44:44 | Entra en `zona_rampa_estado` | 86 % |
| 13:44:44 | Entra en `Zona_deteccion`, `zona_rampa_estado` y `Estado_Rampa` | 87 % |
| 13:45:01 | Se vuelve estacionario | 82 % |
| 13:45:08 | Frigate marca que el seguimiento termina/«ha salido» | 81 % |

El coche estaba en la rampa desde el comienzo y siguió allí. Por tanto, el final del seguimiento no fue una salida física. La puntuación de entrada y la del momento final no eran bajas; la detección inicial fue más moderada. Esto no basta por sí solo para establecer la causa.

## Conclusiones confirmadas

1. La cámara detecta el coche en la vista general.
2. El coche entra en `zona_rampa_estado` y en las otras zonas indicadas.
3. El polígono funciona; el problema no es que el coche nunca entre en la zona.
4. La ocupación cae cuando Frigate termina el seguimiento aunque el coche permanezca aparcado.
5. No se ha configurado un `max_frames` global ni un límite por objeto para el coche.
6. La lluvia pudo contribuir a los falsos positivos nocturnos, pero aún no está confirmado.

## Pendiente para retomar

1. En **Explore → Detalles de seguimiento**, revisar si Frigate vuelve a crear otro seguimiento para el mismo coche después de marcarlo estacionario.
2. Revisar el vídeo alrededor de las 13:45:01–13:45:08 con las cajas superpuestas y comprobar si la detección se pierde o si cambia la caja del coche.
3. Consultar las puntuaciones de las detecciones posteriores a «se volvió estacionario»; la puntuación final disponible en la captura fue 81 %.
4. Anotar los FPS de detección efectivos de la Tapo para traducir los valores de fotogramas a tiempo.
5. Revisar con esos datos `min_score`/`threshold` y `max_disappeared`, sin elevar umbrales a ciegas: hacerlo podría empeorar la detección del coche.
6. Mantener por ahora la geometría de zona y no variar varios parámetros a la vez. La inercia puede probarse de nuevo una vez entendido el final del seguimiento.
7. Para automatización de iluminación, valorar una combinación de Frigate con PIR o radar. El sensor de lluvia podría servir para ignorar eventos de cámara por sí solos durante lluvia, dejando operativo el disparo del sensor físico; esta lógica aún no está implementada.

## Referencias

- [Frigate — Zones](https://docs.frigate.video/configuration/zones/)
- [Frigate — Home Assistant Integration](https://docs.frigate.video/integrations/home-assistant/)
- [Frigate — Stationary Objects](https://docs.frigate.video/configuration/stationary_objects/)
- [Frigate — Object Filters](https://docs.frigate.video/configuration/object_filters/)
- [Frigate — Explore](https://docs.frigate.video/usage/explore/)
