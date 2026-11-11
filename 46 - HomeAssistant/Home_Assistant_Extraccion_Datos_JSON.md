---
tags:
  - homeAssistant
  - domotica
  - configuracion
  - documentacion
Creado: 2026-09-08
Relacionado:
---

# Extracción de datos JSON en Home Assistant

## Idea general

Cuando una entidad de Home Assistant devuelve varios datos agrupados en
formato JSON, podemos usar una **plantilla Jinja** para extraer cada
valor por separado.

La estructura básica es:

``` jinja
{{ (states('sensor.ev_charger_medidas') | from_json)['L1'][1] / 10 }}
```

Mentalmente se puede leer así:

> **Entidad → convertir JSON → elegir campo → elegir posición → aplicar
> escala**

------------------------------------------------------------------------

## 1. Leer la entidad

``` jinja
states('sensor.ev_charger_medidas')
```

-   `sensor.ev_charger_medidas` es la **entidad**.
-   `states()` obtiene su estado actual.
-   El nombre de la entidad va entre paréntesis y comillas.

------------------------------------------------------------------------

## 2. Convertir el JSON

``` jinja
states('sensor.ev_charger_medidas') | from_json
```

`from_json` convierte el texto recibido en una estructura de datos que
Home Assistant puede interpretar.

Por ejemplo, el cargador puede entregar algo parecido a:

``` json
{
  "L1": [2160, 74, 16],
  "L2": [2160, 0, 0],
  "L3": [2160, 0, 0],
  "t": 280,
  "p": 16,
  "d": 3000,
  "e": 1
}
```

------------------------------------------------------------------------

## 3. Seleccionar un campo

Después de convertir el JSON podemos elegir un dato mediante su nombre:

``` jinja
['L1']
```

Esto seleccionaría:

``` text
[2160, 74, 16]
```

Otros ejemplos:

``` jinja
['t']   # Temperatura
['p']   # Potencia
['d']   # Duración
['e']   # Energía
```

------------------------------------------------------------------------

## 4. Seleccionar una posición dentro de una lista

Cuando un campo contiene varios valores, utilizamos otro corchete para
indicar su posición.

Las posiciones empiezan siempre por **0**:

``` text
L1 = [2160, 74, 16]
       [0]  [1] [2]
```

Por tanto:

``` jinja
['L1'][0]   # Primer valor
['L1'][1]   # Segundo valor
['L1'][2]   # Tercer valor
```

En el cargador hemos identificado:

``` text
L1[0] → Tensión
L1[1] → Corriente
L1[2] → Potencia de la fase
```

------------------------------------------------------------------------

## 5. Ajustar la escala

Muchos dispositivos Tuya transmiten números enteros y hay que aplicar
una escala.

Ejemplos:

``` jinja
['L1'][0] / 10
```

Si el valor recibido es `2160`:

``` text
2160 / 10 = 216.0 V
```

Para corriente:

``` jinja
['L1'][1] / 10
```

Si recibimos `74`:

``` text
74 / 10 = 7.4 A
```

Para temperatura:

``` jinja
['t'] / 10
```

Si recibimos `280`:

``` text
280 / 10 = 28.0 °C
```

------------------------------------------------------------------------

## Ejemplo completo

### Corriente real del cargador

``` jinja
{{ ((states('sensor.ev_charger_medidas') | from_json)['L1'][1]) / 10 }}
```

Descomposición:

``` text
states('sensor.ev_charger_medidas')
        ↓
Obtiene el estado de la entidad

| from_json
        ↓
Interpreta el JSON

['L1']
        ↓
Selecciona los datos de la fase L1

[1]
        ↓
Selecciona el segundo valor (corriente)

 / 10
        ↓
Aplica la escala

Resultado → amperios
```

------------------------------------------------------------------------

## Sensores utilizados en el cargador

  Dato             Expresión                        Resultado
  ---------------- -------------------------------- -----------------
  Tensión L1       `['L1'][0] / 10`                 V
  Corriente L1     `['L1'][1] / 10`                 A
  Potencia L1      `['L1'][2] / 10`                 kW
  Temperatura      `['t'] / 10`                     °C
  Potencia total   `['p'] / 10`                     kW
  Energía sesión   `['e'] / 10`                     kWh
  Duración         `['d']` + conversión de escala   Tiempo de carga

> **Importante:** las escalas se han determinado comprobando los valores
> del DP102 frente a los valores mostrados por la aplicación del
> cargador. Para otros dispositivos o DP hay que verificar la escala
> antes de asumir que es `/10`.

------------------------------------------------------------------------

## Regla rápida

Para interpretar una plantilla como:

``` jinja
{{ (states('sensor.ev_charger_medidas') | from_json)['L1'][1] / 10 }}
```

leerla como:

``` text
ENTIDAD
   ↓
states('sensor.ev_charger_medidas')

CONVERTIR JSON
   ↓
| from_json

CAMPO
   ↓
['L1']

POSICIÓN
   ↓
[1]

ESCALA
   ↓
/ 10

RESULTADO
   ↓
7.4 A
```

### Resumen

**Entidad → JSON → campo → posición (si existe) → escala → valor útil**
