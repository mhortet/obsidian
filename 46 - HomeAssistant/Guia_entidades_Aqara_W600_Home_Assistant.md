---
tags:
  - homeAssistant
  - domotica
  - documentacion
  - configuracion
Creado:
Relacionado:
---

# Guía de entidades del Aqara W600 en Home Assistant

Esta guía describe las entidades expuestas por **Zigbee2MQTT** para el cabezal termostático de radiador **Aqara W600 (WT-A03E)**.

## Entidades de configuración

| Entidad | Función |
|---|---|
| **Anti freeze temperature** | Temperatura mínima de protección anticongelación. Si la estancia baja hasta este valor, el cabezal puede abrir la válvula para evitar heladas. En la captura está configurada a **5 °C**. |
| **Away temperature** | Temperatura asociada al modo **Ausente**. En la captura: **18 °C**. |
| **Calibrate** | Inicia la calibración mecánica del cabezal respecto a la válvula. Conviene utilizarlo después de instalar, desmontar o recolocar el W600, o si no abre o cierra correctamente. |
| **Child lock** | Bloquea los controles físicos del termostato para evitar modificaciones accidentales. En la captura está activado. |
| **Clear schedule** | Borra toda la programación semanal almacenada internamente en el W600. |
| **Delta de temperatura** | Corrección aplicada a la lectura del sensor interno. Si el W600 marca 1 °C de más, se configuraría en **−1 °C**. No modifica la temperatura objetivo. |
| **Display flip** | Gira 180° la orientación de la pantalla, útil cuando el cabezal está instalado en una posición invertida. |
| **Home temperature** | Temperatura correspondiente al modo **En casa**. En la captura: **21 °C**. |
| **Identificar** | Hace que el dispositivo se identifique visualmente para localizarlo entre varios equipos. |
| **Manual Override Duration** | Tiempo durante el cual se mantiene un cambio manual antes de volver a la programación interna. En la captura: **120 minutos**. |
| **Open window detection** | Detecta una bajada rápida de temperatura, interpreta que hay una ventana abierta y cierra temporalmente la válvula para no desperdiciar calefacción. |
| **Save schedule** | Envía y guarda en el W600 la programación semanal introducida. |
| **Sleep temperature** | Temperatura asociada al modo **Dormir**. En la captura: **14,5 °C**. |
| **Temperatura** | Valor de temperatura que Home Assistant puede enviar al W600 cuando se configura un sensor externo. No es la temperatura objetivo. |
| **Temperature control abnormal notification** | Activa las notificaciones de regulación anormal: válvula atascada, montaje incorrecto o imposibilidad de controlar correctamente el radiador. |
| **Temperature source** | Selecciona el sensor empleado para regular: **internal**, sensor integrado en el W600; o **external**, temperatura enviada desde Home Assistant. |
| **Vacation temperature** | Temperatura correspondiente al modo **Vacaciones**. En la captura: **10 °C**. |
| **Wind down temperature** | Temperatura del modo **Antes de dormir** o relajación previa al sueño. En la captura: **24 °C**. No significa ventilación. |

## Programación semanal

Las siguientes entidades almacenan los horarios de cada día directamente en el termostato:

- **Monday schedule:** lunes.
- **Tuesday schedule:** martes.
- **Wednesday schedule:** miércoles.
- **Thursday schedule:** jueves.
- **Friday schedule:** viernes.
- **Saturday schedule:** sábado.
- **Sunday schedule:** domingo.

El valor **None** indica que ese día no tiene actualmente una programación interna definida.

## Recomendaciones para Home Assistant

- Si Home Assistant va a controlar completamente la calefacción, es aconsejable dejar los horarios internos en **None** y ejecutar **Clear schedule** una vez. Así se evita que el W600 cambie por su cuenta una consigna enviada por una automatización.
- Mantener **Temperature source = internal** mientras no se haya configurado el envío periódico de la temperatura de un sensor externo.
- La entidad **Temperatura** puede aparecer vacía mientras se utilice el sensor interno; es normal.
- Es recomendable activar **Temperature control abnormal notification** para detectar fallos de montaje o movimiento de la válvula.
- Utilizar **Calibrate** solamente cuando sea necesario; no es una orden habitual de funcionamiento.
- Si se emplea la programación interna, ajustar **Manual Override Duration** según el tiempo que se quiera conservar un cambio manual.

## Diferencias importantes

- **Temperatura objetivo:** la consigna normal de calefacción que se establece desde la entidad climática del W600.
- **Temperatura interna:** lectura realizada por el sensor incorporado al cabezal.
- **Temperatura externa:** lectura enviada por Home Assistant desde otro sensor situado en la habitación.
- **Delta de temperatura:** corrección matemática aplicada solamente al sensor interno.

## Referencias

- [Zigbee2MQTT — Aqara WT-A03E](https://www.zigbee2mqtt.io/devices/WT-A03E.html)
- [Aqara — Radiator Thermostat W600](https://www.aqara.com/eu/product/radiator-thermostat-w600/)

