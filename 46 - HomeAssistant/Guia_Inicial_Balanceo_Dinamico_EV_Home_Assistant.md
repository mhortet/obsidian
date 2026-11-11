---
tags:
  - homeAssistant
  - movilidad-electrica
  - configuracion
  - domotica
  - documentacion
Creado:
Relacionado:
---

# Guía inicial --- Control de consumos y balanceo dinámico del cargador EV

## Objetivo del nuevo chat

Diseñar en Home Assistant el **control automático de la carga del coche
eléctrico** utilizando:

-   consumo/importación-exportación de la vivienda
-   producción fotovoltaica Huawei
-   tarifa eléctrica (valle / llano / punta)
-   corriente regulable del cargador mediante LocalTuya
-   estado real del cargador
-   un Shelly EM dedicado a la línea del cargador como medida
    independiente

La programación horaria interna del cargador (DP151) queda **aparcada de
momento**. La prioridad es el balanceo energético.

------------------------------------------------------------------------

## 1. Hardware y datos disponibles

### Cargador

-   dé Portable EV Charger 7 kW
-   monofásico 230 V
-   máximo 32 A
-   LocalTuya protocolo 3.5
-   HA controla correctamente la corriente mediante **DP150**
-   HA controla Start/Pause mediante **DP140**
-   HA conoce el estado real mediante **DP109**

Estados DP109 comprobados:

``` text
IDLE     → sin coche conectado
IDLEINS  → coche conectado/listo
WAIT     → esperando programación
PAUSE    → pausado
WORKING  → cargando
```

### Medida interna del cargador

DP102 proporciona:

-   tensión
-   corriente
-   potencia
-   temperatura
-   energía de sesión
-   tiempo de carga

Las lecturas se han contrastado con la app del cargador.

### Huawei / FusionSolar

Home Assistant ya dispone de integración Huawei Solar.

Existe un medidor Huawei conectado al inversor que permite conocer el
intercambio con la red.

**Signo comprobado en esta instalación:**

``` text
Potencia activa NEGATIVA → importación desde la red
Potencia activa POSITIVA → exportación / excedente
```

Se verificó encendiendo cargas de la vivienda: al aumentar consumo, el
valor se hizo más negativo.

Por tanto, para el balanceo interesa principalmente el **Huawei Meter**,
no solamente la producción instantánea de las placas.

### Shelly EM 50 A

Se instalará un Shelly EM con pinza de 50 A en la línea dedicada del
cargador.

Objetivos:

-   medir independientemente potencia/corriente/energía real del EV
-   contrastar DP102
-   detectar lecturas congeladas o inconsistentes
-   mejorar seguridad y diagnóstico del algoritmo

------------------------------------------------------------------------

## 2. Idea principal de funcionamiento

El sistema debe decidir automáticamente:

``` text
¿Hay coche conectado?
        ↓
¿Qué periodo tarifario tenemos?
        ↓
¿Cuánta potencia consume la vivienda?
        ↓
¿Cuánto excedente solar existe realmente?
        ↓
¿Cuánta corriente puede consumir el coche?
        ↓
Modificar DP150
        ↓
Comprobar resultado mediante Huawei + Shelly + DP109
```

------------------------------------------------------------------------

## 3. Disparador principal

Usar DP109.

El evento relevante será:

``` text
IDLE → IDLEINS
```

Es decir:

> se conecta el coche y queda listo para cargar.

No es necesario depender del DP190 mientras DP109 sea fiable.

También se utilizarán los cambios a:

``` text
WORKING
PAUSE
WAIT
IDLE
```

para seguimiento y control.

------------------------------------------------------------------------

## 4. Comportamiento según tarifa

### Periodo valle

Permitir carga desde la red.

La corriente no será necesariamente máxima: debe respetar el límite de
potencia total de la vivienda.

### Periodo punta o llano

Por defecto, **no consumir energía de red para cargar el coche**.

Permitir carga únicamente cuando exista excedente solar suficiente.

Importante:

> No calcular esto solo con "producción FV".

Ejemplo:

``` text
Producción FV = 3.0 kW
Consumo casa = 2.5 kW
Excedente real = 0.5 kW
```

El coche solo dispone realmente de esos 0.5 kW.

La referencia principal será el **Huawei Meter**, porque ya refleja el
balance final casa + solar + red.

### Sin excedente suficiente

Opciones previstas:

1.  Pausar automáticamente la carga.
2.  Enviar aviso al móvil:
    -   "No hay excedente solar suficiente."
    -   permitir autorización manual para seguir cargando desde red.

La segunda opción es especialmente interesante si excepcionalmente se
necesita el coche cargado.

------------------------------------------------------------------------

## 5. Límite de potencia de vivienda

Objetivo planteado:

``` text
Límite de referencia: 4.0 kW
Margen de seguridad: 0.5–0.6 kW
Objetivo operativo aproximado: 3.4–3.5 kW
```

**Nota:** hablamos de kW, no de 4000 kW.

El algoritmo debe evitar acercarse continuamente al límite
contractual/definido.

Ejemplo conceptual:

``` text
Objetivo vivienda = 3.4 kW

Consumo actual sin coche = 1.4 kW
Margen disponible = 2.0 kW

A 230 V:
2000 / 230 ≈ 8.7 A

→ cargador aproximadamente 8 A
```

Después se comprobará el resultado real y se corregirá.

------------------------------------------------------------------------

## 6. Regulación de corriente

Actuador:

``` text
DP150 x_charge_current
```

Comprobado:

``` text
mínimo 6 A
máximo 32 A
paso 1 A
```

La automatización deberá:

1.  calcular potencia disponible
2.  convertirla aproximadamente a amperios usando tensión real
3.  redondear a un valor entero seguro
4.  limitarlo entre mínimo y máximo permitido
5.  escribir DP150
6.  esperar estabilización
7.  volver a comprobar el Huawei Meter

No conviene reaccionar a cada pequeño cambio instantáneo.

Será necesario introducir:

-   histéresis
-   tiempo mínimo entre ajustes
-   posiblemente medias de varios segundos
-   margen de seguridad

para evitar que el cargador esté continuamente:

``` text
8 A → 9 A → 8 A → 9 A...
```

------------------------------------------------------------------------

## 7. Start / Pause

Actuador comprobado:

``` text
DP140 x_do_charge
```

El mando y el estado deben mantenerse separados:

``` text
DP140 → enviar orden
DP109 → verificar resultado real
```

Ejemplo:

``` text
Orden Start mediante DP140
        ↓
esperar
        ↓
DP109 == WORKING ?
        ↓
sí → carga confirmada
no → generar incidencia/reintento
```

Esto es más fiable que asumir que el switch visual de DP140 representa
el estado real.

------------------------------------------------------------------------

## 8. Mínimo de carga y excedente solar

El cargador necesita al menos **6 A**.

A \~230 V:

``` text
6 A × 230 V ≈ 1.38 kW
```

Por tanto, en modo "solo solar", si el excedente disponible no alcanza
aproximadamente esa potencia más el margen que definamos, no tiene
sentido ordenar 6 A y empezar a importar red.

En ese caso:

``` text
excedente insuficiente → PAUSE
```

Cuando vuelva a existir excedente suficiente durante un tiempo estable:

``` text
Start → 6 A → regulación progresiva
```

------------------------------------------------------------------------

## 9. Modos de funcionamiento previstos

Crear posteriormente un selector virtual de Home Assistant,
independiente del firmware del cargador:

``` text
Automático
Solo solar
Carga forzada
```

### Automático

-   valle → admite red y balancea contra límite vivienda
-   punta/llano → solo excedente solar
-   puede pedir autorización si no hay solar suficiente

### Solo solar

Carga exclusivamente con excedente, independientemente del periodo
tarifario.

### Carga forzada

Carga aunque sea necesario importar de red, pero **siempre respetando el
límite máximo de potencia de la vivienda**.

Este selector pertenece a la lógica de HA, no al DP151.

------------------------------------------------------------------------

## 10. Sensores recomendados para la automatización

Antes de programar la automatización definitiva, identificar los
`entity_id` exactos de:

### Cargador

-   estado DP109
-   corriente solicitada DP150
-   potencia cargador DP102
-   corriente cargador DP102
-   tensión cargador DP102
-   Shelly: potencia cargador
-   Shelly: corriente cargador

### Huawei

-   potencia activa del medidor/red
-   potencia activa del inversor
-   producción FV si interesa para información/diagnóstico

### Sistema

-   periodo tarifario actual
-   modo virtual de carga
-   límite de potencia configurado
-   margen de seguridad

------------------------------------------------------------------------

## 11. Arquitectura recomendada en Home Assistant

No meter toda la lógica dentro de una tarjeta del dashboard.

Separar:

### Sensores / helpers

Datos y parámetros.

### Scripts

Acciones reutilizables:

``` text
Iniciar carga
Pausar carga
Establecer corriente
```

### Automatizaciones

Decisión:

``` text
tarifa + Huawei + consumo + solar + estado coche
```

### Dashboard

Solo visualización y controles manuales.

Esto permite cambiar completamente el panel sin romper el sistema.

------------------------------------------------------------------------

## 12. Estrategia de desarrollo

No construir de golpe una automatización enorme.

### Fase 1 --- Monitorización

Instalar Shelly y verificar durante cargas reales:

-   Huawei Meter
-   Shelly
-   DP102
-   app cargador
-   FusionSolar

### Fase 2 --- Límite de potencia

Automatizar únicamente:

> mantener consumo de vivienda por debajo del objetivo regulando DP150.

Sin tarifas ni solar todavía.

### Fase 3 --- Solo solar

Añadir lógica de excedentes y pausa/reanudación.

### Fase 4 --- Tarifas

Añadir valle / llano / punta.

### Fase 5 --- Excepciones

Añadir:

-   carga forzada
-   notificaciones al móvil
-   autorización para consumir red
-   fallos de comunicación
-   lectura Shelly/Huawei no disponible
-   comprobación DP109 después de órdenes

Este desarrollo por etapas permitirá validar cada parte antes de que
controle automáticamente la carga.

------------------------------------------------------------------------

## 13. Principio de seguridad

Home Assistant será un **sistema de control**, no una protección
eléctrica.

La instalación física debe limitar/proteger independientemente:

-   intensidad máxima
-   cortocircuito
-   diferencial
-   sobretensiones
-   sección de conductores
-   puesta a tierra

Si HA falla, pierde red o envía una consigna incorrecta, las
protecciones físicas deben seguir siendo suficientes.

------------------------------------------------------------------------

## Punto exacto para comenzar el nuevo chat

> Quiero continuar el proyecto del cargador EV en Home Assistant
> centrándonos ahora en **control de consumos y balanceo dinámico de
> carga**. Ya tengo controlados y verificados los DP principales de
> LocalTuya: DP109 estado, DP140 Start/Pause, DP150 corriente y DP102
> métricas. Huawei Solar y el Huawei Meter están integrados en HA; en mi
> instalación potencia activa negativa significa importación de red y
> positiva exportación. Voy a instalar un Shelly EM 50 A en la línea del
> cargador. Quiero desarrollar el sistema por fases, empezando por
> monitorización y después un control que mantenga la vivienda
> aproximadamente por debajo de 3.4--3.5 kW, dejando 500--600 W de
> margen respecto a 4 kW. Más adelante añadiremos solo excedente solar
> en punta/llano, carga permitida de red en valle, modos Automático/Solo
> solar/Carga forzada y notificaciones.
