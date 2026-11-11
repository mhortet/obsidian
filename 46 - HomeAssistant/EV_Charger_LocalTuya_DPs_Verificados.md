---
tags:
  - homeAssistant
  - movilidad-electrica
  - configuracion
  - documentacion
  - domotica
Creado: 2026-09-11
Relacionado:
---

# EV Charger dé + LocalTuya --- Mapa de DP verificado

> **Equipo:** dé EV Charger / Portable EV Charger 7 kW\
> **Firmware observado:** 2.5.4\
> **Tuya Product ID:** `gxrtu5vljdthtd3g`\
> **LocalTuya:** xZetsubou/hass-localtuya, protocolo Tuya 3.5
>
> Este documento recoge principalmente **datos comprobados en este
> cargador**, no equivalencias genéricas de otros modelos.

## 1. DP verificados

  --------------------------------------------------------------------------------------------------------------
DP Nombre Tuya        Tipo / contenido   Comportamiento comprobado    Uso recomendado en HA
  ----------------- --------------------- ------------------ ---------------------------- ----------------------
101 `x_work_state`        Entero             `200` listo para cargar;                     Sensor diagnóstico:
                                                           `202` programado/esperando;  Preferible usar DP109
                                                           `204` pausa
                                                           `300` cargando  para automatizaciones
                                                           por ser más legible

102 `x_metrics`               JSON               Métricas instantáneas de              Sensor origen + carga                                                                                                                            sensores Template

 106 `x_charger_info`      JSON               Información del cargador:    Diagnóstico
                                                             protección, firmware, CP,    
                                                             temperatura/energía          
                                                             acumulada según campos       
                                                             observados                   

  107 `x_adjust_current`    Lista              `[6,8,10,13,16,20,25,32]`;   Diagnóstico
                                                             son accesos/valores          
                                                             predefinidos, no limita el   
                                                             ajuste entero del DP150      

                109 `x_work_st_debug`     Texto              Estados reales del cargador; **Sensor principal de
                                                             ver tabla inferior           estado**

                140 `x_do_charge`         Booleano/comando   Confirmado para              Mando Start/Pause;
                                                             iniciar/parar carga cuando   verificar estado real
                                                             el cargador está en modo     con DP109
                                                             adecuado                     

                150 `x_charge_current`    Número             Consigna de corriente.       **Number**, 6--32 A,
                                                             Confirmado control desde HA, paso 1 A
                                                             pasos enteros; probado que   
                                                             el cambio se refleja en el   
                                                             cargador/app                 

                151 `x_charge_mode`       JSON               Configuración del modo y     Lectura + escritura
                                                             horario                      controlada con
                                                                                          `localtuya.set_dp`

                152 `x_max_current_cfg`   Número             Máximo configurado;          Sensor/configuración
                                                             observado 32 A               

                155 `x_nfc_cfg`           Booleano           Configuración NFC            No necesario para
                                                                                          balanceo

                156 `x_earch_free_cfg`    Booleano           No investigado               Sin uso actual
                                                             funcionalmente               

                157 `x_product_variant`   Número             Variante de producto;        Diagnóstico
                                                             observado `1`                

                188 `x_heartbeat`         Booleano           Heartbeat; observado `False` Diagnóstico

                190 `x_plug_charge`       Booleano/cloud     No fue necesario para        Aparcado
                                          pull               detectar coche conectado:    
                                                             DP109 ofrece mejor           
                                                             información                  
  --------------------------------------------------------------------------------------------------------------

## 2. DP109 --- Estados comprobados

  Valor       Interpretación comprobada
  ----------- ---------------------------------------------------
  `IDLE`      Sin coche conectado / cargador esperando conexión
  `IDLEINS`   Coche conectado y listo para cargar
  `WAIT`      Esperando por programación
  `PAUSE`     Carga pausada
  `WORKING`   Cargando activamente

**Conclusión:** DP109 es el mejor candidato para determinar
presencia/estado del coche y para confirmar que una orden enviada al
cargador realmente se ha ejecutado.

## 3. DP101 --- Correspondencia numérica comprobada

  Situación                  DP101 DP109
  ------------------------ ------- -----------
  Listo para cargar          `200` `IDLEINS`
  Programado / esperando     `202` `WAIT`
  Pausado                    `204` `PAUSE`
  Cargando                   `300` `WORKING`

DP101 aporta información equivalente codificada. Para automatizaciones
se prefiere DP109.

## 4. DP102 --- Métricas

Ejemplo real:

``` json
{"L1":[2150,91,19],"L2":[2150,0,0],"L3":[2150,0,0],"t":280,"p":19,"d":4100,"e":2}
```

Interpretación comprobada:

  -----------------------------------------------------------------------
  Campo                   Conversión              Resultado
  ----------------------- ----------------------- -----------------------
  `L1[0]`                 `/10`                   Tensión L1 en V

  `L1[1]`                 `/10`                   Corriente L1 en A

  `L1[2]`                 `/10`                   Potencia L1 en kW

  `L2`, `L3`              mismo esquema           En monofásica aparecen
                                                  sin corriente/potencia

  `t`                     `/10`                   Temperatura en °C

  `p`                     `/10`                   Potencia total en kW

  `d`                     escala observada        Duración de sesión;
                          compatible con décimas  convertir a unidad
                          de segundo              deseada

  `e`                     `/10`                   Energía de sesión en
                                                  kWh
  -----------------------------------------------------------------------

Las lecturas de tensión, corriente, potencia y energía se contrastaron
con la aplicación del cargador y resultaron coherentes.

### Patrón de extracción en Home Assistant

``` jinja
{{ (states('sensor.ev_charger_medidas') | from_json)['L1'][1] / 10 }}
```

Lectura mental:

**entidad → `from_json` → campo → posición → escala**

Ejemplos:

``` jinja
{{ (states('sensor.ev_charger_medidas') | from_json)['L1'][0] / 10 }}  {# V #}
{{ (states('sensor.ev_charger_medidas') | from_json)['L1'][1] / 10 }}  {# A #}
{{ (states('sensor.ev_charger_medidas') | from_json)['p'] / 10 }}      {# kW #}
{{ (states('sensor.ev_charger_medidas') | from_json)['t'] / 10 }}      {# °C #}
{{ (states('sensor.ev_charger_medidas') | from_json)['e'] / 10 }}      {# kWh #}
```

## 5. DP150 --- Control de corriente

Configuración utilizada en LocalTuya:

-   Plataforma: `Number`
-   Mínimo: **6 A**
-   Máximo: **32 A**
-   Paso: **1 A**
-   Categoría: configuración

**Verificado:** modificar DP150 desde Home Assistant cambia la corriente
configurada en el cargador y el cambio aparece también en la app
oficial.

DP107 no limita el control a sus valores `[6,8,10,13,16,20,25,32]`;
DP150 ha permitido trabajar con valores enteros intermedios.

Este DP será el **actuador principal del balanceo dinámico**.

## 6. DP140 --- Start / Pause

`x_do_charge`

Se confirmó que permite controlar inicio/parada de carga cuando el
cargador está en el modo adecuado.

Recomendación de arquitectura:

-   **DP140 = orden**
-   **DP109 = confirmación del estado real**

No depender del estado visual del propio switch como prueba de que el
coche está cargando. Tras mandar la orden, comprobar que DP109 cambia a
`WORKING`, `PAUSE`, etc.

## 7. DP151 --- Programación

Formato comprobado:

``` json
{"m":0,"dt":0,"ss":"13:15","se":"08:00"}
```

Campos identificados:

  Campo     Significado comprobado
  --------- --------------------------------------------------------
  `m`       modo
  `m = 0`   carga inmediata
  `m = 2`   carga programada
  `ss`      hora de inicio
  `se`      hora de fin
  `dt`      función no identificada; permaneció `0` en las pruebas

Ejemplo programado:

``` json
{"m":2,"dt":0,"ss":"13:15","se":"08:00"}
```

Ejemplo inmediato conservando horario:

``` json
{"m":0,"dt":0,"ss":"13:15","se":"08:00"}
```

### Escritura correcta del JSON

La acción disponible en esta versión de LocalTuya es:

``` yaml
action: localtuya.set_dp
data:
  device_id: bf0272b631feb6061aqhaw
  dp: 151
  value: '{"m":2,"dt":0,"ss":"13:15","se":"08:00"}'
```

**Conclusión importante:** para DP151 ha resultado estable enviar el
JSON como **cadena literal completa**.

Se probó repetidamente la alternancia `m=0 ↔ m=2` con payloads literales
y funcionó correctamente.

### Lo que NO funcionó bien

La construcción dinámica del `value` mediante plantillas que Home
Assistant terminaba interpretando como diccionario, y especialmente el
intento de doble codificación:

``` jinja
| to_json | to_json
```

provocó comportamiento incorrecto e incluso dejó temporalmente el
control del modo sin responder desde la app.

**No reutilizar ese método.**

Para futuras escrituras dinámicas, partir del método ya validado con
cadenas JSON literales y probar cualquier variación de forma controlada.

## 8. Sensores Template derivados del DP151

A partir del sensor que contiene el JSON completo:

### Hora de inicio

``` jinja
{{ (states('sensor.ev_charger_programado') | from_json)['ss'] }}
```

### Hora fin

``` jinja
{{ (states('sensor.ev_charger_programado') | from_json)['se'] }}
```

Al ser valores como `13:15`, deben tratarse como **texto**:

-   sin unidad de medida
-   sin clase de dispositivo
-   sin clase de estado

### Modo legible

``` jinja
{% set m = (states('sensor.ev_charger_programado') | from_json)['m'] | int %}
{% if m == 2 %}
  Programada
{% elif m == 0 %}
  Inmediata
{% else %}
  Desconocido
{% endif %}
```

## 9. Arquitectura recomendada

Separar funciones:

-   **Sensores:** información real del cargador.
-   **DP109:** estado operativo real.
-   **DP140:** orden Start/Pause.
-   **DP150:** regulación de corriente.
-   **DP151:** programación interna, actualmente secundaria.
-   **Scripts:** acciones concretas reutilizables.
-   **Automatizaciones:** lógica de balanceo/tarifas/solar.
-   **Dashboard:** solo presentación y mandos; no guardar lógica crítica
    únicamente en tarjetas.

Así se puede rehacer o borrar un dashboard sin perder el funcionamiento
del sistema.

## 10. Estado actual del proyecto

La parte esencial necesaria para el futuro balanceo está comprobada:

1.  HA puede leer el estado del cargador.
2.  HA puede conocer tensión, corriente, potencia y energía.
3.  HA puede modificar la corriente de carga mediante DP150.
4.  HA puede iniciar/parar mediante DP140.
5.  HA puede leer y modificar el modo programado mediante DP151.
6.  Las lecturas observadas en HA han coincidido con las aplicaciones
    del cargador y FusionSolar/Huawei durante las pruebas.

La siguiente fase se centra en **control de consumos, producción solar y
balanceo dinámico**, no en la programación interna del cargador.
