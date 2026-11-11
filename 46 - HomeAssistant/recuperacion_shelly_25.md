---
tags:
  - domotica
  - shelly
  - configuracion
  - documentacion
  - homeAssistant
Creado: 2026-10-11
Relacionado:
---
# 🛠️ Guía de Recuperación y Configuración Avanzada: Shelly 2.5



Documento estructurado para almacenamiento en notas locales (**Obsidian**). Recopila el proceso completo de diagnóstico, desbloqueo de red y comandos útiles para la API local.

---

## 1. Reseteo de Fábrica (Factory Reset)
Si el dispositivo no responde o ha cambiado de red inalámbrica, el primer paso es forzar el modo de configuración física.

1. **Corte de energía:** Desconecta el Shelly de la corriente (baja el automático/magnetotérmico) durante unos 10-15 segundos.
2. **Reconexión y pulsaciones:** Vuelve a dar corriente. Durante el **primer minuto** posterior al encendido, realiza **5 pulsaciones seguidas** en cualquiera de los interruptores de pared conectados a las entradas `SW1` o `SW2`.
3. **Confirmación visual/auditiva:**
   * Los relés internos realizarán un **repiqueo continuo (clics secuenciales)**.
   * El LED posterior del dispositivo comenzará a **parpadear rápidamente**. Esto indica que está en modo AP emitiendo su propia Wi-Fi.

---

## 2. Configuración Inicial y Bypass de Red (Modo AP)
El error más común es intentar emparejar el Shelly directamente desde la aplicación móvil mientras se está conectado a la red temporal del aparato, lo que suele provocar fallos de reconocimiento.

### Paso 1: Conexión limpia al Shelly
1. Desactiva por completo los **datos móviles (4G/5G)** de tu teléfono. Esto evita que el móvil salte a internet al detectar que el Shelly no ofrece navegación.
2. Abre los ajustes Wi-Fi del móvil y conéctate a la red abierta llamada `shellyswitch25-XXXXXX`.
3. Si el sistema operativo te avisa de que "Esta red no tiene acceso a internet", confirma obligatoriamente la opción **"Mantener conexión"**.

### Paso 2: Interfaz Web Nativa
1. Abre tu navegador web habitual e introduce la IP por defecto de rescate:
   `http://192.168.33.1`
2. Dirígete a **Internet & Security** > **WIFI Mode - Client**.
3. Activa la casilla, introduce el **SSID (nombre)** y la **contraseña** de tu red doméstica de 2.4 GHz.
4. Presiona **Save / Connect**. El LED posterior pasará a parpadear de forma mucho más lenta hasta quedarse apagado o fijo, indicando que ya ha negociado una IP en tu router.

---

## 3. Resolución del Conflicto de Propietario (Cloud Bypass)
Si la app muestra el mensaje: *"The device is already owned by another user/account"*, se debe a un bloqueo de caché en la nube de Shelly.

### Evolución del Device ID (6 vs 12 caracteres)
* **Firmware Antiguo:** Los Shelly 2.5 antiguos utilizaban un identificador único corto de 6 caracteres que colisionaba con facilidad en los servidores globales de la nube.
* **Firmware Moderno:** Al actualizar el dispositivo mediante su interfaz local (`Settings > Firmware Update`), el propio sistema migra el ID nativamente al formato **Long ID (12 caracteres)**.

### Pasos para saltarse el bloqueo en la App:
1. Accede a la interfaz web del Shelly introduciendo su nueva dirección IP local provista por tu router (ej. `http://192.168.1.X`).
2. Ve a **Internet & Security** > **Cloud**.
3. **Desactiva** por completo la casilla **Enable Cloud** y guarda los cambios.
4. Abre la aplicación móvil de Shelly y añade el dispositivo de forma puramente local mediante la opción **Añadir por IP** o escaneo de red. Al no estar vinculado a la nube temporalmente, la app permitirá integrarlo en tu sala sin saltar el error de propietario.
5. *(Opcional)* Una vez añadido a tu estructura de salas de la App, puedes volver a la interfaz web y reactivar la casilla de la nube si requieres control domótico fuera del hogar.

---

## 4. Esquema Lógico de Cableado
Estructura de terminales estándar del Shelly 2.5 para modos de persiana (Roller Shutter) o doble interruptor independiente.

| Terminal | Descripción | Conexión típica |
| :--- | :--- | :--- |
| **N** | Neutro | Cable azul de la red eléctrica general |
| **L** | Línea / Fase (Entrada 1) | Cable marrón/negro de fase general |
| **L** | Línea / Fase (Entrada 2) | Puenteado interno a la fase general |
| **O1** | Output 1 (Salida) | Carga 1 / Motor Persiana (Dirección Subida) |
| **O2** | Output 2 (Salida) | Carga 2 / Motor Persiana (Dirección Bajada) |
| **SW1** | Switch 1 (Entrada) | Interruptor / Pulsador mecánico 1 |
| **SW2** | Switch 2 (Entrada) | Interruptor / Pulsador mecánico 2 |

---

## 5. Comandos Útiles de la API HTTP Local
Puedes controlar y consultar tu Shelly directamente en tu red local lanzando estas peticiones HTTP desde cualquier navegador, script de Home Assistant u Obsidian (con plugins compatibles):

* **Estado Completo del Sistema:**
  ```text
  http://<IP-DEL-SHELLY>/status
  ```
  *(Devuelve un JSON con lecturas de consumo de energía, temperatura interna, estado de los relés y potencia).*

* **Acción sobre el Relé 1 (O1):**
  * **Encender:** `http://<IP-DEL-SHELLY>/relay/0?turn=on`
  * **Apagar:** `http://<IP-DEL-SHELLY>/relay/0?turn=off`
  * **Conmutar (Toggle):** `http://<IP-DEL-SHELLY>/relay/0?turn=toggle`

* **Acción sobre el Relé 2 (O2):**
  * **Encender:** `http://<IP-DEL-SHELLY>/relay/1?turn=on`
  * **Apagar:** `http://<IP-DEL-SHELLY>/relay/1?turn=off`

* **Reinicio de Hardware Remoto:**
  ```text
  http://<IP-DEL-SHELLY>/reboot
  ```
