---
tags:
  - hospital
  - manuales
Creado: 2026-05-14
Autor:
Relacionado:
  - "[[Manual Seguridad Eléctrica]]"
---
## Alcance

## Descripción



# Guía Técnica: Seguridad Eléctrica en Ecógrafos según Normas IEC 60601 e IEC 62353

Este documento recopila de forma unificada los requisitos, clasificaciones, métodos de ensayo y riesgos asociados a la seguridad eléctrica de los ecógrafos en el entorno clínico.

---

## 1. Clasificación del Ecógrafo (Norma IEC 60601-1)

La norma **IEC 60601-1** regula el diseño y fabricación de equipos electromédicos. Desde el punto de vista de la protección y el contacto con el paciente, un ecógrafo estándar de consola se clasifica como:

### Protección contra Choques (Clase I)
* **Definición:** El equipo dispone de un aislamiento básico y una conexión obligatoria a la **tierra de protección (tierra física)** de la instalación eléctrica.
* **Mecanismo:** Si ocurre un fallo en el aislamiento interno, la corriente de defecto se desvía a tierra a través del cable de alimentación, impidiendo que la carcasa metálica se energice y protegiendo al operador y al paciente.
* *Nota:* Los ecógrafos portátiles compactos alimentados exclusivamente por baterías pueden clasificarse como Clase II (doble aislamiento) en modo batería, pero adoptan las exigencias de Clase I al conectarse a la red eléctrica para cargarse.

### Grado de Contacto con el Paciente (Parte Aplicada Tipo BF)
* **Definición:** Las **sondas o transductores** son las piezas aplicadas que entran en contacto físico directo con el paciente.
* **Mecanismo:** Clasificadas como **Tipo BF (Body Floating)**, cuentan con un circuito interno aislado galvánicamente (flotante) respecto a la tierra. Esto limita estrictamente el paso de corrientes de fuga hacia el cuerpo del paciente, incluso si este se encuentra conectado de forma simultánea a otros equipos.

---

## 2. Ensayos Periódicos y de Mantenimiento (Norma IEC 62353)

La norma **IEC 62353** (adoptada en España como UNE-EN 62353) define los ensayos que deben realizar los técnicos de electromedicina de forma **periódica (habitualmente anual)** o tras una **reparación**, asegurando que el ecógrafo sigue siendo seguro durante su vida útil.

### Secuencia Obligatoria de Ensayos
1. **Inspección Visual:** Verificación del estado de los cables de red, integridad de la carcasa del ecógrafo y, fundamentalmente, ausencia de grietas en las membranas y mangueras de las sondas.
2. **Resistencia del Conductor de Tierra de Protección:** Medición de la continuidad entre la clavija del enchufe y los puntos metálicos accesibles del chasis. El límite establecido es **$\leq$ 0.3 $\Omega$** (para equipos con cable de alimentación desmontable).
3. **Resistencia de Aislamiento (Opcional):** Aplicación de una tensión de 500 V CC entre los conductores activos y el chasis para verificar la calidad de los materiales aislantes (debe ser **$\geq$ 2 M$\Omega$**).

### Límites de Corriente de Fuga Admisibles
Durante las pruebas con el analizador de seguridad eléctrica, no se pueden superar los siguientes umbrales:


| Tipo de Ensayo | Límite Máximo Permitido | Aplicación en el Ecógrafo |
| :--- | :--- | :--- |
| **Resistencia de Tierra** | **$\leq$ 0.3 $\Omega$** | Continuidad del cable de red al chasis. |
| **Corriente de Fuga del Equipo** | **$\leq$ 500 $\mu$A** (0.5 mA) | Corriente total que escapa del chasis a tierra. |
| **Corriente de Fuga de la Parte Aplicada** | **$\leq$ 5000 $\mu$A** (5 mA) | Corriente que se fuga a través del transductor (Tipo BF). |

---

## 3. Ensayo Práctico de la Sonda por Inmersión

Debido a que la carcasa externa de un transductor es plástica (aislante), medir su corriente de fuga requiere simular la conductividad de la piel humana mediante el método de inmersión en solución salina:


### Pasos del Procedimiento: 1. 

**Preparación:** 
1. Se vierte una solución de **cloruro de sodio al 0.9% (suero fisiológico)** en un recipiente plástico aislado. 
2. **Inmersión controlada:** Se sumerge la cabeza del transductor en el líquido, cuidando estrictamente de no sobrepasar el límite de estanqueidad marcado por el fabricante para evitar filtraciones hacia el conector. 
3. **Conexión:** Se introduce un electrodo de acero inoxidable en la solución (sin tocar la sonda) y este se conecta a la toma de "Partes Aplicadas" del analizador de seguridad eléctrica. 4. **Medición:** El analizador evalúa cuánta corriente se transfiere desde la electrónica interna de la sonda, a través de sus materiales protectores, hacia la solución salina. 
4. Riesgos Clínicos y Técnicos del Aislamiento Deteriorado Las sondas sufren degradación por golpes, caídas o por el uso de desinfectantes químicos incompatibles (como alcoholes de alta concentración que resecan las gomas). Las consecuencias de una pérdida de aislamiento incluyen:
	* **Macrochoques Eléctricos:** El gel ecográfico es conductor. Si penetra en una fisura, crea un puente eléctrico directo entre los cristales piezoeléctricos (que operan con pulsos superiores a 100 V) y la piel del paciente o las manos del médico, pudiendo causar desde quemaduras hasta arritmias severas. 
	* **Microchoques Eléctricos:** En procedimientos ecoguiados (biopsias, accesos venosos profundos o ecografía transesofágica), corrientes de fuga imperceptibles en la piel exterior (del orden de microamperios) pueden resultar críticas si entran en contacto directo con el tejido cardíaco o el sistema circulatorio. 
	* **Artefactos en Imagen:** La degradación interna altera la impedancia del transductor, generando líneas negras o ruido estático en la pantalla, lo que incrementa el riesgo de un **diagnóstico médico erróneo**. 
	* ---
	* ## Fuentes y Referencias Normativas 
	*
	1. **IEC 60601-1 (Equipos electromédicos - 	
	2. Parte 1):** Requisitos generales para la seguridad básica y funcionamiento esencial. Establece los criterios de diseño para equipos de Clase I/II y partes aplicadas Tipo B/BF/CF. 2. **IEC 62353 (Equipos electromédicos):** Ensayos periódicos y ensayos tras reparación de equipos electromédicos. Define los métodos prácticos de medición (directo, diferencial y alternativo) y límites de fuga en entornos de mantenimiento clínico.
	3. **UNE-EN 62353:** Adopción oficial de la norma internacional en el marco regulatorio español (Asociación Española de Normalización - UNE). 
	4. **Manuales de Servicio Técnico del Fabricante:** Documentación específica de marcas de ecografía (ej. GE Healthcare, Philips, Siemens) que detallan los umbrales de estanqueidad de las sondas y procedimientos de desinfección química compatibles.
