---
tags:
  - homeAssistant
  - configuracion
  - domotica
  - movilidad-electrica
  - documentacion
Creado: 2026-09-08
Autor:
Relacionado:
---
## Resumen

## Descripción
# Integración cargador dé EV Charger con Home Assistant mediante Local Tuya

## 1. Datos identificados del cargador

**Cargador:** dé EV Charger  
**Modelo:** deM2D07B6A – Mobile Wallbox 7 kW  
**Potencia máxima:** 7 kW / 32 A  
**Firmware:** V2.5.4

### Datos Tuya

- Device ID: `bf0272b631feb6061aqhaw`
- Product ID: `gxrtu5vljdthtd3g`
- Protocolo Tuya: **3.5**
- IP local identificada: `192.168.2.106`
- Puerto Tuya: `6668`
- Local Key: obtenida mediante TinyTuya
- Región Tuya Cloud: `eu`

> IMPORTANTE: No guardar la Local Key, Access Secret u otras credenciales
> sensibles en documentación que pueda compartirse.


---

# 2. Identificación de la IP del cargador

El router de la operadora no permite acceso a su configuración, por lo que
la IP se identificó desde la propia LAN.

Se utilizaron herramientas de escaneo de red desde Windows y posteriormente
TinyTuya.

## Instalar TinyTuya

Comprobar Python:

    py --version

Versión utilizada:

    Python 3.13.12

Instalar TinyTuya:

    py -m pip install tinytuya

Escanear dispositivos Tuya:

    py -m tinytuya scan

TinyTuya identificó:

    Address = 192.168.2.105
    Device ID = bf0272b631feb6061aqhaw
    Version = 3.5
    MAC = d8:fc:92:05:91:35

Por tanto:

    IP cargador = 192.168.2.105


---

# 3. Tuya Developer / IoT Platform

Acceder a Tuya Developer Platform.

El proyecto utilizado finalmente fue el antiguo proyecto:

    Puerta

No fue necesario crear un proyecto nuevo porque ya tenía vinculada la
cuenta Smart Life y aparecía el cargador.

Ruta aproximada:

    Cloud
      └── Project Management
           └── Puerta


## 3.1 Comprobar dispositivos

Dentro del proyecto:

    Devices

El cargador debe aparecer como:

    dé EV Charger

con Device ID:

    bf0272b631feb6061aqhaw


---

# 4. Credenciales Tuya Cloud

Dentro del proyecto:

    Overview
      └── Authorization Key

Ahí aparecen:

- Access ID / Client ID
- Access Secret / Client Secret
- Project Code

Para TinyTuya y LocalTuya:

    API Key / Client ID = Access ID / Client ID

    API Secret = Access Secret / Client Secret

El **Project Code NO es el User ID**.


---

# 5. UID de la cuenta Tuya / Smart Life

LocalTuya solicita:

    User ID

Este valor corresponde al **UID de la cuenta Smart Life vinculada al
proyecto Tuya**.

NO utilizar:

- Project Code
- Device ID
- correo electrónico

Hay que utilizar el UID mostrado por Tuya en la información de la cuenta
Smart Life vinculada.


---

# 6. Renovación de IoT Core

TinyTuya inicialmente devolvió:

    Code 28841002:
    IoT Core service subscription has expired.

La suscripción IoT Core del proyecto había caducado.

En Tuya Developer:

    Cloud
      └── Cloud Services
           └── IoT Core

Se utilizó:

    Extend Service Trial Period

La extensión disponible era:

    6 Months

Se rellenó la solicitud para ampliar el periodo de prueba.

Una vez renovado IoT Core, TinyTuya pudo consultar correctamente los
dispositivos.


---

# 7. Obtener Local Key con TinyTuya

Ejecutar:

    py -m tinytuya wizard

TinyTuya solicita:

1. API Key
2. API Secret
3. Device ID
4. Región

Datos utilizados:

    API Key    = Access ID de Tuya
    API Secret = Access Secret de Tuya
    Device ID  = bf0272b631feb6061aqhaw
    Región     = eu

Después TinyTuya obtuvo los dispositivos vinculados y guardó:

    devices.json
    tuya-raw.json
    snapshot.json

En `devices.json` se encuentra la Local Key correspondiente al cargador.

Buscar:

    bf0272b631feb6061aqhaw

y localizar:

    "key": "XXXXXXXXXXXXXXXX"

Esa es la **Local Key**.

No compartirla públicamente.


---

# 8. Comprobación de comunicación local

TinyTuya consiguió consultar directamente:

    dé EV Charger
    192.168.2.106

y recibió los DPS del cargador.

Esto confirmó que:

- El cargador acepta comunicación local.
- La IP es correcta.
- El Device ID es correcto.
- La Local Key es correcta.
- El protocolo es Tuya 3.5.


---

# 9. LocalTuya en Home Assistant

La primera versión de LocalTuya instalada no permitía seleccionar
protocolo Tuya 3.5.

Se eliminó completamente:

    Ajustes
      └── Dispositivos y servicios
           └── LocalTuya
                └── Eliminar

Después se desinstaló también desde HACS.


---

# 10. LocalTuya compatible con Tuya 3.5

Se instaló desde HACS el repositorio de:

    xZetsubou / hass-localtuya

La integración aparece como:

    Local Tuya

Versión instalada durante la configuración:

    2026.07.0

Esta versión permite utilizar:

    Protocol Version = 3.5


---

# 11. Configuración Cloud API en LocalTuya

Al añadir LocalTuya:

### API server region

    eu

### Client ID

Utilizar:

    Access ID / Client ID

del proyecto Tuya.

### Secret

Utilizar:

    Access Secret / Client Secret

### User ID

Utilizar:

    UID de la cuenta Smart Life

### Username

Puede mantenerse:

    localtuya


---

# 12. Añadir manualmente el cargador

LocalTuya no descubrió automáticamente el cargador, por lo que se añadió
manualmente.

Datos:

    Name:
    EV Charger

    Host:
    192.168.2.106

    Device ID:
    bf0272b631feb6061aqhaw

    Local Key:
    [Local Key obtenida mediante TinyTuya]

    Protocol Version:
    3.5

No utilizar:

    http://192.168.2.106

El Host es simplemente:

    192.168.2.106


---

# 13. DPS detectados

LocalTuya consiguió leer los DPS del cargador.

Principales DPS observados:

| DP | Código | Función / información |
|---:|---|---|
| 101 | x_work_state | Estado de funcionamiento |
| 102 | x_metrics | Métricas eléctricas principales |
| 103 | x_selftest | Autotest |
| 104 | x_alarm | Alarmas |
| 105 | x_charge_history | Historial de carga |
| 106 | x_charger_info | Información del cargador |
| 107 | x_adjust_current | Información relacionada con corrientes |
| 108 | x_downcounter | Cuenta atrás |
| 109 | x_work_st_debug | Estado/debug |
| 110 | x_single_fase_mode | Configuración monofásica |
| 111 | x_debug | Debug |
| 140 | x_do_charge | Orden de carga |
| 141 | x_do_reset | Reset |
| 142 | x_do_reboot | Reinicio |
| 150 | x_charge_current | Corriente de carga configurada |
| 151 | x_charge_mode | Modo/programación de carga |
| 152 | x_max_current_cfg | Corriente máxima configurada |
| 153 | x_lang_cfg | Idioma |
| 154 | x_socket_cfg | Configuración socket |
| 155 | x_nfc_cfg | Configuración NFC |
| 156 | x_earch_free_cfg | Configuración adicional |
| 157 | x_product_variant | Variante del producto |
| 188 | x_heartbeat | Heartbeat |
| 189 | dp_num | Información interna |
| 190 | x_plug_charge | Estado relacionado con conexión/carga |


---

# 14. DP 152 - Corriente máxima

Primera entidad creada correctamente.

    DP:
    152 - x_max_current_cfg

Configuración:

    Friendly Name:
    Max Corriente Cargador

    Unit of Measurement:
    A

    Device Class:
    Current

    State Class:
    Measurement

    Scaling Factor:
    vacío / 1

Resultado comprobado:

    32 A

La lectura funciona correctamente desde Home Assistant.


---

# 15. DP 150 - Control de corriente de carga

Este es uno de los DPS más importantes.

    DP:
    150 - x_charge_current

Se comprobó que el valor representa directamente los amperios.

Ejemplo:

    value: 9

correspondía a que el cargador estaba configurado realmente a:

    9 A

Por tanto, se creó como entidad:

    Number

Configuración:

    Friendly Name:
    Corriente Carga del Cargador

    Minimum Value:
    6

    Maximum Value:
    32

    Increment:
    1

    Restore last value:
    Desactivado

Esto permite regular desde Home Assistant:

    6 A → 32 A

en pasos de:

    1 A


## PRUEBA REALIZADA

Se modificó la corriente desde Home Assistant.

Se comprobó posteriormente desde la aplicación oficial del cargador que
el valor había cambiado realmente.

### RESULTADO

    CONTROL LOCAL DE CORRIENTE DESDE HOME ASSISTANT: FUNCIONANDO


---

# 16. Cómo añadir nuevas entidades posteriormente

En Home Assistant:

    Ajustes
      └── Dispositivos y servicios
           └── Local Tuya
                └── Engranaje del HUB localtuya

Entrar en la configuración del cargador.

Aparecerán las entidades existentes, por ejemplo:

    152: Max Corriente Cargador

Marcar:

    Add new entity(s)

NO desmarcar las entidades existentes, ya que esa opción sirve para
eliminarlas.

Después elegir el tipo de entidad:

- Sensor
- Number
- Switch
- Select
- Binary Sensor
- Button
- etc.

y asignarle el DP correspondiente.


---

# 17. Próximos DPS interesantes

## DP 102 - x_metrics

Probablemente será el siguiente más importante.

Contiene un bloque de información con datos eléctricos como:

    L1
    L2
    L3
    temperatura
    potencia
    duración
    energía

Ejemplo observado:

    {"L1":[2240,0,0],
     "L2":[2240,0,0],
     "L3":[2240,0,0],
     "t":280,
     "p":0,
     "d":0,
     "e":0}

Será necesario estudiar cómo separar estos valores en diferentes sensores
de Home Assistant.


## DP 101 - Estado

    x_work_state

Permitirá conocer el estado del cargador.


## DP 140 - Control de carga

    x_do_charge

Puede ser interesante para iniciar/detener la carga desde Home Assistant.


## DP 105 - Historial

    x_charge_history

Puede aportar información sobre sesiones de carga.


## DP 106 - Información del cargador

Contiene información como:

- Protección diferencial
- Firmware
- Voltaje CP
- Temperatura
- Energía acumulada


---

# 18. Objetivo final

Integrar completamente el cargador en Home Assistant para disponer de:

- Corriente configurada.
- Regulación de corriente entre 6 y 32 A.
- Corriente real.
- Tensión.
- Potencia instantánea.
- Energía consumida.
- Energía de sesión.
- Estado del cargador.
- Estado de conexión del vehículo.
- Inicio/parada de carga.
- Temperatura.
- Alarmas.
- Historial de carga.
- Información del cargador.

Posteriormente se podrá utilizar esta información para automatizaciones,
especialmente:

## Balanceo dinámico de potencia

Regular automáticamente los amperios del cargador dependiendo del consumo
total de la vivienda.

Ejemplo:

    Potencia disponible vivienda
              ↓
        Home Assistant
              ↓
       Calcula amperios
              ↓
    DP150 x_charge_current
              ↓
         EV Charger

Esto permitiría aprovechar al máximo la potencia contratada sin superar
el límite de la vivienda.
