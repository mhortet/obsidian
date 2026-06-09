---
tags:
  - equipos
  - hospital
Creado: 2026-05-05
Autor:
Relacionado:
  - "[[Manual Seguridad Eléctrica]]"
---
## Alcance

## Descripción




# PROTOCOLO DE SEGURIDAD ELÉCTRICA PARA ECÓGRAFOS (NORMA IEC 62353)
**Equipo de Medición:** Analizador de Seguridad Eléctrica Rigel 288+  
**Clasificación del Equipo Bajo Prueba:** Clase I, Partes Aplicables Tipo BF (Transductores)  

---

## 1. INSPECCIÓN VISUAL Y PREPARACIÓN DEL ENTORNO
* Verificar la integridad del cable de alimentación del ecógrafo (sin cortes ni pines flojos).
* Inspeccionar la carcasa de la consola y la integridad física de los transductores (sin grietas en la lente acústica).
* Limpiar y secar completamente las sondas. **Cero restos de gel de ultrasonido**.
* Colocar el ecógrafo sobre una superficie no conductora, alejado de estructuras metálicas.

---

## 2. CONFIGURACIÓN FÍSICA DE CONEXIONES (RIGEL 288+)
1. **Alimentación:** Conectar el enchufe del ecógrafo directamente a la toma de corriente frontal del Rigel 288+.
2. **Chasis (Tierra):** Conectar el cable de prueba negro (sonda) en el puerto **Earth/Green** del Rigel. Sujetar el caimán a una parte metálica sin pintura del chasis del ecógrafo (ej. tornillo posterior).
3. **Partes Aplicables (Sondas):** 
   * Envolver firmemente la cabeza de los transductores activos con **papel de aluminio**, emulando la superficie de contacto con el paciente.
   * Asegurar que el aluminio no toque ninguna parte metálica del ecógrafo.
   * Conectar un cable verde desde el puerto **Patient Conn. (1-5)** del Rigel hasta el papel de aluminio mediante una pinza de cocodrilo.

---

## 3. PRUEBA DE RESISTENCIA DE AISLAMIENTO (R_ISO a 500 V CC)
* **Condición del Ecógrafo:** Interruptor térmico/principal trasero en posición **ON (I)**. Cable de red desconectado de la pared del hospital (energizado solo por el Rigel).

### Paso A: Red al Chasis (L+N contra Tierra)
1. En el Rigel 288+, ingresar a: `F4 (Manual)` > `Insulation Resistance`.
2. Configurar parámetros: `Test Voltage: 500V` | `Test Type: EUT to Earth`.
3. Mantener presionado el botón verde **START / TEST** por 3 segundos hasta estabilizar.
4. **Límite Aceptable:** $\ge 2.00 \text{ M}\Omega$ (Lo normal es ver `>100 MΩ` o `OL`).

### Paso B: Red a los Transductores (L+N contra Partes Aplicables)
1. Cambiar parámetro en pantalla: `Test Type: AP to Earth` (o `AP to EUT`).
2. Mantener presionado el botón verde **START / TEST** por 3 segundos.
3. **Límite Aceptable:** $\ge 70.0 \text{ M}\Omega$ (Exigencia estricta para Tipo BF).
4. Soltar el botón y esperar a que el Rigel indique voltaje en cero antes de mover los cables.

---

## 4. PRUEBA DE CORRIENTES DE FUGA ACTIVAS (EQUIPO EN ARRANQUE)
* **ADVERTENCIA DE SEGURIDAD:** El Rigel energizará el ecógrafo a tensión de red. **NO TOCAR** el chasis ni las sondas durante la medición.

### Paso A: Corriente de Fuga del Equipo (Equipment Leakage)
1. En el menú manual del Rigel, seleccionar `Equipment Leakage`.
2. Configurar parámetros: `Method: Direct` | `A.C. / D.C.: R.M.S.`
3. Presionar el botón verde **START / TEST**. El ecógrafo encenderá. **Esperar a que cargue por completo el sistema operativo (1-2 min)**.
4. Tomar lecturas alternando las siguientes condiciones con las teclas de función del Rigel:
   * Polaridad Normal / Polaridad Inversa (`F1 - Polarity`).
   * Condición de Falla: Tierra Abierta (`F2 - Earth`).
5. **Límites Aceptables:**
   * Condición Normal (Tierra Cerrada): $\le 500\ \mu\text{A}$ (0.5 mA).
   * Condición de Falla (Tierra Abierta): $\le 1000\ \mu\text{A}$ (1.0 mA).
6. Presionar el botón rojo **STOP** para apagar el equipo antes de avanzar.

### Paso B: Corriente de Fuga en las Partes Aplicables (Applied Part Leakage)
1. En el menú manual del Rigel, seleccionar `Applied Part Leakage`.
2. Configurar parámetros: `Method: Direct`.
3. Presionar el botón verde **START / TEST** y esperar el arranque del ecógrafo.
4. Alternar las condiciones de prueba (`Polarity` y `Earth`) mediante las teclas de función.
5. **Límite Aceptable (Tipo BF):** $\le 5000\ \mu\text{A}$ (5.0 mA) bajo inyección de falla. *(En equipos sanos, la lectura real suele ser $<100\ \mu\text{A}$)*.
6. Presionar el botón rojo **STOP** para cortar la energía de forma segura.

---

## 5. REGISTRO Y COMPROBACIÓN FUNCIONAL POST-PRUEBA
* Presionar **F4 (Store)** en el Rigel 288+ para guardar los resultados en la memoria interna. Registrar el Número de Serie y el ID de inventario del hospital.
* Desconectar el ecógrafo del analizador y conectarlo a la toma regulada de la pared del hospital.
* Encender el ecógrafo y realizar una prueba funcional rápida con gel en un transductor. **Verificar que la imagen en pantalla esté limpia y libre de ruido o artefactos eléctricos**.
