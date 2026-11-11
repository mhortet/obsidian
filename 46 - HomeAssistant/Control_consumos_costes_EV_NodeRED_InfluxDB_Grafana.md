---
tags:
  - homeAssistant
  - configuracion
  - domotica
  - documentacion
Creado: 2026-09-27
Relacionado:
---

# Control de consumos y costes del cargador EV
## Home Assistant · Node-RED · InfluxDB · Grafana

> **Estado:** diseño funcional corregido tras pruebas con carga real  
> **Objetivo:** registrar las cargas del vehículo eléctrico, separar el consumo por periodos 2.0TD y visualizar energía y coste en Grafana.  
> **Criterio:** sencillez, trazabilidad y facilidad de mantenimiento.

---

## 1. Arquitectura final

1. **Home Assistant** proporciona la potencia del cargador.
2. **Node-RED** registra la potencia general y calcula la energía de cada intervalo para clasificarla por periodo tarifario.
3. **InfluxDB** almacena cuatro mediciones:
   - `Cargador_Coche` — potencia instantánea general en **kW**.
   - `Cargador_Coche_valle` — energía de cada intervalo en **kWh**.
   - `Cargador_Coche_llano` — energía de cada intervalo en **kWh**.
   - `Cargador_Coche_punta` — energía de cada intervalo en **kWh**.
4. **Grafana** integra la potencia general, suma la energía de los tramos, calcula costes y presenta los datos.

Base de datos InfluxDB: `Home_Assistant`.

> `Cargador_Coche` se conserva: sirve para la gráfica de potencia, para obtener la energía total independientemente y para contrastar el reparto Valle + Llano + Punta.

---

## 2. Registro general de potencia en Node-RED

El intervalo de lectura puede modificarse sin alterar la unidad almacenada: esta rama conserva siempre la potencia instantánea en **kW**.

La potencia se almacena mientras el cargador trabaja. Al terminar se escribe **un único 0** y después no se generan registros hasta la siguiente carga.

```javascript
let potencia = Number(msg.payload);
let cargando = context.get("cargando") || false;

if (potencia > 0) {
    context.set("cargando", true);
    msg.payload = potencia;
    return msg;
}

if (potencia === 0 && cargando) {
    context.set("cargando", false);
    msg.payload = 0;
    return msg;
}

return null;
```

Resultado típico:

```text
1.90 kW
1.91 kW
1.89 kW
...
0 kW     ← un único registro al terminar
```

---

## 3. Clasificación tarifaria 2.0TD

### Días laborables

| Horario | Periodo |
|---|---|
| 00:00–08:00 | Valle |
| 08:00–10:00 | Llano |
| 10:00–14:00 | Punta |
| 14:00–18:00 | Llano |
| 18:00–22:00 | Punta |
| 22:00–00:00 | Llano |

### Sábados y domingos

Todo el día: **VALLE**.

### Festivos

Pendiente incorporar los festivos aplicables desde Home Assistant, evitando mantener manualmente una lista de fechas.

Zona horaria: `Europe/Madrid`.

---

## 4. Function Node-RED — energía por Valle / Llano / Punta

Tres salidas físicas:

1. Valle
2. Llano
3. Punta

Cada salida se conecta a su nodo InfluxDB correspondiente.

```javascript
// ============================================================
// CARGADOR EV - ENERGÍA POR PERIODOS TARIFARIOS 2.0TD
//
// SALIDAS:
//   1 → VALLE
//   2 → LLANO
//   3 → PUNTA
//
// Entrada:
//   msg.payload = potencia instantánea del cargador en kW
//
// Salida:
//   msg.payload = energía del intervalo en kWh
//
// El tiempo real entre muestras se calcula automáticamente.
// ============================================================

const MAX_INTERVALO_SEGUNDOS = 120;

const potencia = Number(msg.payload);
const ahoraMs = Date.now();

if (!Number.isFinite(potencia) || potencia < 0) {
    return [null, null, null];
}

const anterior = context.get("muestra_anterior_v2");

if (potencia === 0) {
    context.set("muestra_anterior_v2", null);
    return [null, null, null];
}

context.set("muestra_anterior_v2", {
    tiempo: ahoraMs,
    potencia: potencia
});

// La primera muestra solo establece el punto de partida.
if (
    !anterior ||
    !Number.isFinite(anterior.tiempo) ||
    !Number.isFinite(anterior.potencia)
) {
    return [null, null, null];
}

const segundos = (ahoraMs - anterior.tiempo) / 1000;

// Evita contabilizar intervalos anómalos por cortes o reinicios.
if (
    !Number.isFinite(segundos) ||
    segundos <= 0 ||
    segundos > MAX_INTERVALO_SEGUNDOS
) {
    return [null, null, null];
}

// Integración trapezoidal: potencia media × horas transcurridas.
const potenciaMedia = (anterior.potencia + potencia) / 2;
const energia = potenciaMedia * (segundos / 3600);

const ahora = new Date(ahoraMs);

const partes = new Intl.DateTimeFormat("en-GB", {
    timeZone: "Europe/Madrid",
    weekday: "short",
    hour: "2-digit",
    minute: "2-digit",
    hourCycle: "h23"
}).formatToParts(ahora);

const datos = {};

for (const p of partes) {
    datos[p.type] = p.value;
}

let diaSemana = datos.weekday;
let hora = Number(datos.hour);
let minuto = Number(datos.minute);

// SOLO PARA PRUEBAS:
// diaSemana = "Mon";
// hora = 11;
// minuto = 30;

msg.payload = energia;
msg.potencia_kw = potencia;
msg.potencia_media_kw = potenciaMedia;
msg.energia_kwh = energia;
msg.intervalo_segundos = segundos;
msg.dia_semana = diaSemana;
msg.hora_local =
    `${String(hora).padStart(2, "0")}:${String(minuto).padStart(2, "0")}`;

if (diaSemana === "Sat" || diaSemana === "Sun") {
    msg.periodo = "VALLE";
    return [msg, null, null];
}

if (hora >= 0 && hora < 8) {
    msg.periodo = "VALLE";
    return [msg, null, null];
}

if (
    (hora >= 10 && hora < 14) ||
    (hora >= 18 && hora < 22)
) {
    msg.periodo = "PUNTA";
    return [null, null, msg];
}

msg.periodo = "LLANO";
return [null, msg, null];
```

> **Importante:** `Cargador_Coche` almacena potencia en kW, mientras que las tres mediciones tarifarias almacenan pequeñas fracciones de energía en kWh. Por tanto, la medición general se integra y los tramos se suman.

### Motivo de usar el tiempo real

La primera versión suponía que cada mensaje representaba siempre 60 segundos:

```javascript
energia = potencia * (60 / 3600);
```

Durante las pruebas se modificó la frecuencia de disparo. La función seguía asignando 60 segundos a cada mensaje y produjo un total muy superior al real. Con el cálculo basado en `Date.now()`, el resultado ya no depende de que las muestras lleguen cada 5, 10 o 60 segundos.

---

## 5. Pruebas de clasificación

Para probar fronteras horarias se pueden forzar temporalmente las variables:

```javascript
diaSemana = "Mon";
hora = 11;
minuto = 30;
```

Casos comprobables:

```text
Lunes 07:59 → VALLE
Lunes 08:00 → LLANO
Lunes 09:59 → LLANO
Lunes 10:00 → PUNTA
Lunes 13:59 → PUNTA
Lunes 14:00 → LLANO
Lunes 17:59 → LLANO
Lunes 18:00 → PUNTA
Lunes 21:59 → PUNTA
Lunes 22:00 → LLANO
Sábado       → VALLE
Domingo      → VALLE
```

Las fronteras se probaron correctamente.

> Forzar la hora solo cambia la clasificación. El timestamp de InfluxDB continúa siendo el momento real de escritura.

---

# 6. Grafana — criterio final

Siempre que InfluxQL pueda proporcionar directamente el dato:

> **InfluxQL calcula; Grafana presenta.**

Se evita añadir `Math`, `Reduce` y transformaciones salvo que aporten una ventaja real.

---

## 7. Consultas de energía

### Total

```sql
SELECT integral("value", 1h)
FROM "Cargador_Coche"
WHERE $timeFilter
```

### Valle

```sql
SELECT sum("value")
FROM "Cargador_Coche_valle"
WHERE $timeFilter
```

### Llano

```sql
SELECT sum("value")
FROM "Cargador_Coche_llano"
WHERE $timeFilter
```

### Punta

```sql
SELECT sum("value")
FROM "Cargador_Coche_punta"
WHERE $timeFilter
```

Unidad Grafana: **kWh**.

Grafana puede autoescalar valores inferiores a 1 kWh, por ejemplo:

```text
0.816 kWh → 816 Wh
```

No cambia el valor real; solo su presentación.

---

## 8. Tarifas utilizadas

| Periodo | Precio |
|---|---:|
| Valle | 0.073900 €/kWh |
| Llano | 0.109200 €/kWh |
| Punta | 0.182200 €/kWh |

---

## 9. Consultas de coste

### Valle

```sql
SELECT sum("value") * 0.0739
FROM "Cargador_Coche_valle"
WHERE $timeFilter
```

### Llano

```sql
SELECT sum("value") * 0.1092
FROM "Cargador_Coche_llano"
WHERE $timeFilter
```

### Punta

```sql
SELECT sum("value") * 0.1822
FROM "Cargador_Coche_punta"
WHERE $timeFilter
```

Unidad Grafana: **Euro (€)**.

Conceptualmente:

```text
Coste total = Coste Valle + Coste Llano + Coste Punta
```

---

# 10. Diseño final del dashboard

## Tarjeta 1 — Energía

```text
ENERGÍA

Valle       xxx kWh
Llano       xxx kWh
Punta       xxx kWh
Total       xxx kWh
```

El Total procede directamente de `Cargador_Coche`.

Esto permite comprobar independientemente:

```text
Valle + Llano + Punta ≈ Total
```

Una diferencia importante indicaría que conviene revisar el reparto o el muestreo.

## Tarjeta 2 — Costes

```text
COSTES

Valle       xxx €
Llano       xxx €
Punta       xxx €
Total       xxx €
```

## Gauge — Coste total

Gauge independiente para interpretar de un vistazo el gasto del periodo.

Objetivo visual:

```text
Gasto bajo / normal / elevado
```

Inicialmente los umbrales pueden ser estimativos. Cuando exista suficiente histórico, se ajustarán usando el **coste mensual real**, para convertirlo en un indicador útil y no meramente decorativo.

## Gráfica de potencia

Se conserva `Cargador_Coche` para visualizar el histórico de potencia durante las cargas: inicio, potencia mantenida, variaciones y final.

---

# 11. Pruebas realizadas con Grafana

Durante el diseño se probaron:

- expresiones `Math`;
- `Reduce`;
- transformaciones;
- ocultación de consultas/campos.

Una expresión como:

```text
$B + $C + $D
```

puede generar:

```text
items dropped from union(s)
```

cuando Grafana intenta combinar series con etiquetas diferentes.

También se observó que ocultar determinados campos que alimentan una transformación puede impedir que participen en el resultado esperado.

### Decisión final

No añadir esa complejidad cuando no sea necesaria.

```text
Node-RED → adquisición, integración temporal de tramos y clasificación
InfluxDB → almacenamiento
InfluxQL → integral de potencia general, suma de tramos y costes
Grafana  → visualización
```

---

# 12. Validación recomendada con una carga real

Con todo el sistema definitivo activo:

1. Seleccionar exactamente el intervalo de una carga.
2. Obtener la energía total desde `Cargador_Coche`.
3. Obtener Valle, Llano y Punta.
4. Comprobar que la suma de los tres periodos coincide razonablemente con Total.
5. Verificar los costes de cada periodo.
6. Prestar especial atención a una carga que atraviese un cambio de periodo tarifario.
7. Comparar el resultado con la energía de sesión indicada por el propio cargador.

Ejemplo:

```text
Valle       20.0 kWh
Llano        2.0 kWh
Punta        1.0 kWh
--------------------
Periodos    23.0 kWh

Total       23.0 kWh
```

---

# 13. Pendientes

- [ ] Incorporar festivos aplicables mediante Home Assistant.
- [ ] Validar una carga real completa con el sistema definitivo.
- [ ] Comparar Total con Valle + Llano + Punta.
- [ ] Comparar ambos cálculos con los kWh de sesión indicados por el cargador.
- [ ] Terminar tarjeta resumen de Energía.
- [ ] Terminar tarjeta resumen de Costes.
- [ ] Crear Gauge de Coste Total.
- [ ] Definir umbrales del Gauge con histórico mensual.
- [ ] Ajustar tamaños y alineación final de paneles.
- [ ] Mantener gráfica histórica de potencia.
- [ ] Actualizar esta nota si cambia la lógica tarifaria.

---

# 14. Resumen rápido de queries

```sql
-- ENERGÍA TOTAL
SELECT integral("value", 1h)
FROM "Cargador_Coche"
WHERE $timeFilter

-- ENERGÍA VALLE
SELECT sum("value")
FROM "Cargador_Coche_valle"
WHERE $timeFilter

-- ENERGÍA LLANO
SELECT sum("value")
FROM "Cargador_Coche_llano"
WHERE $timeFilter

-- ENERGÍA PUNTA
SELECT sum("value")
FROM "Cargador_Coche_punta"
WHERE $timeFilter

-- COSTE VALLE
SELECT sum("value") * 0.0739
FROM "Cargador_Coche_valle"
WHERE $timeFilter

-- COSTE LLANO
SELECT sum("value") * 0.1092
FROM "Cargador_Coche_llano"
WHERE $timeFilter

-- COSTE PUNTA
SELECT sum("value") * 0.1822
FROM "Cargador_Coche_punta"
WHERE $timeFilter
```

### Regla para no confundir unidades

```text
Dato almacenado en kW  → integral("value", 1h) → kWh
Dato almacenado en kWh → sum("value")          → kWh
```

No debe aplicarse una integral a los tramos porque Node-RED ya ha convertido cada intervalo en energía. Tampoco debe sumarse directamente la potencia general, porque una suma de valores en kW no representa energía.

---

## Filosofía del montaje

> **En domótica, lo que mejor funciona es la sencillez.**

El objetivo no es utilizar todas las posibilidades de Node-RED, InfluxDB o Grafana, sino disponer de un sistema comprensible, estable y fácil de recuperar o modificar meses después.
