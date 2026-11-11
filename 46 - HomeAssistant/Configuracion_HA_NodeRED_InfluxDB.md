---
tags:
  - homeAssistant
  - configuracion
  - domotica
  - documentacion
Creado: 2026-09-25
Relacionado:
---

# Home Assistant → Node-RED → InfluxDB

> Configuración verificada el 25/09/2026 para registrar datos de Home
> Assistant en InfluxDB mediante Node-RED.

## 1. Esquema

``` text
Home Assistant
    ↓
Node-RED (current state)
    ↓
InfluxDB out
    ↓
InfluxDB 1.x
```

## 2. Node-RED ↔ Home Assistant

En el nodo de configuración **Home Assistant**:

-   Activar **Using the Home Assistant Add-on**.
-   No es necesario configurar manualmente URL ni token cuando Node-RED
    funciona como Add-on de Home Assistant.

### Error encontrado: `Invalid server config`

Se solucionó utilizando la conexión mediante **Home Assistant Add-on**.

### Error encontrado: `Entity could not be found in cache`

Aunque el `entity_id` era correcto, Node-RED no encontraba la entidad en
su caché.

**Solución:**

1.  Ir a **Ajustes → Complementos → Node-RED**.
2.  Reiniciar el complemento.
3.  Esperar unos segundos.
4.  Volver a Node-RED y hacer **Deploy**.

Tras el reinicio, el nodo `current state` volvió a leer correctamente la
entidad.

## 3. InfluxDB

Se decidió comenzar una configuración nueva para Cáceres, independiente
de las antiguas bases de datos de Avilés.

### Base de datos

``` text
Home_Assistant
```

Retention Policy:

``` text
autogen
```

Duración:

``` text
∞
```

### Usuario específico para Node-RED

``` text
Usuario: nodered
Permisos: Read / Write
Base de datos: Home_Assistant
Admin: No
```

> La contraseña no se documenta aquí. Guardarla en un gestor de
> contraseñas.

## 4. Configuración de InfluxDB en Node-RED

En el nodo de configuración `influxdb`:

  Parámetro    Valor
  ------------ --------------------------
  Versión      `1.x`
  Host         `192.168.2.100`
  Puerto       `8086`
  Database     `Home_Assistant`
  Usuario      `nodered`
  Contraseña   La creada para `nodered`
  SSL/TLS      Desactivado

### Error encontrado: `401 Unauthorized`

Mensaje:

``` text
authorization failed
```

**Causa:** faltaban las credenciales de InfluxDB en Node-RED.

**Solución:** crear el usuario `nodered` con permisos Read/Write sobre
`Home_Assistant` y configurar esas credenciales en Node-RED.

## 5. Nodo de lectura del cargador

Entidad utilizada inicialmente:

``` text
sensor.potencia_cargador
```

El nodo `current state` entrega el valor en:

``` text
msg.payload
```

Ejemplo:

``` text
msg.payload = 0
```

Tipo:

``` text
number
```

## 6. Nodo `influxdb out`

Medición utilizada:

``` text
cargador_coche
```

**Importante:** evitar espacios en el nombre de la medición.

### Error encontrado: `400 Bad Request`

Mensaje:

``` text
unable to parse 'Cargador Coche value=0': invalid field format
```

La medición se había llamado:

``` text
Cargador Coche
```

Se corrigió a:

``` text
cargador_coche
```

Tras este cambio InfluxDB comenzó a registrar correctamente los datos.

## 7. Flujo de prueba verificado

``` text
[Inject / marca tiempo]
        ↓
[current_state: sensor.potencia_cargador]
        ├──→ [debug]
        └──→ [influxdb out: cargador_coche]
```

Durante las pruebas se utilizó un intervalo de **10 segundos** para
comprobar fácilmente que InfluxDB recibía nuevos registros.

**Estado final:** ✅ Home Assistant → Node-RED → InfluxDB funcionando
correctamente.

## 8. Próximo paso

El intervalo de 10 segundos es únicamente de prueba. Antes de dejar el
sistema definitivo conviene decidir la estrategia de almacenamiento:

-   frecuencia de muestreo;
-   almacenamiento por cambio de valor;
-   tratamiento de periodos con potencia `0`;
-   datos del cargador, vivienda y producción fotovoltaica;
-   estructura de mediciones/campos para facilitar posteriormente
    consultas y gráficas.

------------------------------------------------------------------------

## Chuleta rápida

``` text
INFLUXDB
Versión:     1.x
Host:        192.168.2.100
Puerto:      8086
Database:    Home_Assistant
Usuario:     nodered
SSL/TLS:     No

MEDICIÓN INICIAL
cargador_coche

ENTIDAD HA
sensor.potencia_cargador
```

### Si deja de funcionar

1.  Comprobar que Home Assistant e InfluxDB están arrancados.
2.  Reiniciar Node-RED si aparece `Entity could not be found in cache`.
3.  `401 Unauthorized` → revisar usuario/contraseña/permisos de
    InfluxDB.
4.  `400 ... invalid field format` → revisar nombres de
    mediciones/campos y evitar espacios.
