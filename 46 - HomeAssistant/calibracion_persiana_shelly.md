---
tags:
  - domotica
  - shelly
  - homeAssistant
  - configuracion
  - documentacion
Creado: 2026-10-11
Relacionado:
---

# Configuración y Calibración de Persiana Eléctrica en Shelly 2.5

Este documento técnico detalla el procedimiento para configurar, cablear y calibrar un dispositivo **Shelly 2.5** en modo **Roller Shutter (Persiana Eléctrica)**, asegurando el control por porcentajes y la protección de los motores.

---

## 1. Esquema de Conexiones Eléctricas (Modo Motorized Shutter)

Para controlar una persiana, el Shelly 2.5 utiliza sus dos canales de forma combinada (un canal para subir y otro para bajar). Es fundamental asegurarse de que el motor tiene topes finales mecánicos o electrónicos propios.

| Terminal Shelly 2.5 | Conexión Cableado Eléctrico | Descripción |
| :--- | :--- | :--- |
| **N** | Cable Neutro (Azul) | Alimentación del Shelly |
| **L** | Cable Fase (Marrón/Negro) | Alimentación del Shelly (Línea) |
| **O1** | Cable de Subida del Motor | Salida de relé 1 (Dirección Subir) |
| **O2** | Cable de Bajada del Motor | Salida de relé 2 (Dirección Bajar) |
| **SW1** | Pulsador / Interruptor de Subida | Entrada de control manual para subir |
| **SW2** | Pulsador / Interruptor de Bajada | Entrada de control manual para bajar |

> ⚠️ **ATENCIÓN SEGURIDAD:** Nunca conectes la fase directamente a los cables de subida/bajada del motor de forma simultánea. El Shelly gestiona el enclavamiento electrónico para evitar que ambos relés se activen a la vez y quemen el motor.

---

## 2. Configuración Inicial (Cambio de Modo)

Antes de realizar la calibración, es imperativo cambiar el modo de funcionamiento de "Relé Doble" a "Persiana":

1. Entra en la interfaz web introduciendo la IP del Shelly en tu navegador (ej. `192.168.1.8`).
2. Ve a **Settings** > **Device Type**.
3. Selecciona la opción **Roller Shutter** y guarda los cambios. El Shelly se reiniciará.
4. Tras el reinicio, ve a **Settings** > **Open/Close Working Time** y establece un tiempo máximo de cortesía (por ejemplo, `30` o `45` segundos). Esto apagará el relé si la persiana se atasca.

---

## 3. Proceso de Calibración de Consumo

La calibración permite al Shelly memorizar los picos de consumo eléctrico que ocurren cuando la persiana llega a sus topes físicos (arriba y abajo). Sin este proceso, solo podrás usar los comandos de "Subir del todo" o "Bajar del todo", perdiendo el control por porcentajes (ej. abrir al 50%).

### Requisitos previos:
* La persiana debe estar completamente montada y los topes del motor bien regulados.
* No debe haber interrupciones mecánicas durante el proceso.

### Paso a paso:
1. Desde la interfaz web o la App, ve a **Settings** > **Positioning Controls**.
2. Asegúrate de activar la casilla **Enable Positioning Controls**.
3. Haz clic en el botón **Calibrate** (Calibrar).
4. **Comportamiento automático:** La persiana empezará a moverse sola de la siguiente forma:
   * Subirá por completo hasta detectar la bajada de consumo del tope superior.
   * Bajará por completo hasta detectar el tope inferior.
   * Volverá a subir por completo para confirmar los tiempos y potencias.
5. Al finalizar, la interfaz mostrará un mensaje de **Calibración Exitosa**.

---

## 4. Control Local mediante API HTTP (Comandos Locales)

Una vez calibrado, puedes controlar tu persiana enviando peticiones HTTP directamente a la IP del Shelly desde scripts, automatizaciones de Home Assistant u Obsidian (utilizando plugins de peticiones web).

### Comandos de Control Directo:
* **Subir por completo:**
  `http://<IP_SHELLY>/roller/0?go=open`
* **Bajar por completo:**
  `http://<IP_SHELLY>/roller/0?go=close`
* **Detener movimiento inmediatamente:**
  `http://<IP_SHELLY>/roller/0?go=stop`

### Control por Porcentajes (Posicionamiento):
* **Ir a una posición específica (ej. 50% abierta):**
  `http://<IP_SHELLY>/roller/0?go=to_pos&pos=50`
  *(Nota: `pos=0` suele equivaler a totalmente cerrada y `pos=100` a totalmente abierta).*

### Consulta de Estado (JSON):
* **Obtener posición actual y estado de consumo:**
  `http://<IP_SHELLY>/roller/0`
  *Devuelve un JSON con parámetros como `"current_pos"`, `"state"` ("open", "close", "stop") y `"power"` (vatios consumidos en tiempo real).*

---
*Nota para Obsidian: Esta nota técnica complementa al archivo principal de recuperación del dispositivo.*