---
tags:
  - app
  - manuales
  - hospital
Relacionado:
  - "[[Manual Seguridad eléctrica]]"
Creado:
---

# SEG-001

# Manual General de Seguridad Eléctrica en Equipos Electromédicos

Versión: 0.1  
Estado: Borrador  
Autor: Máximo Hortet  
Proyecto: QontrolMed

---

# Prólogo

La seguridad eléctrica de los equipos electromédicos no depende exclusivamente de su diseño de fabricación. A lo largo de su vida útil, el desgaste de materiales, las reparaciones, el uso intensivo y las condiciones ambientales pueden modificar significativamente las características originales del equipo.

Por este motivo, el mantenimiento técnico de equipos médicos dispone de un marco normativo específico que permite verificar periódicamente que los niveles de seguridad continúan siendo aceptables para pacientes y operadores.

## Objetivo del documento

El objetivo de este manual es proporcionar una guía técnica que permita comprender, ejecutar e interpretar correctamente las verificaciones de seguridad eléctrica y de integridad funcional de equipos electromédicos conforme a los criterios establecidos por la norma IEC 62353.

Este documento no pretende sustituir la documentación de fabricantes ni el contenido de las normas aplicables. Su finalidad es servir como herramienta práctica de trabajo para técnicos de electromedicina, facilitando la aplicación de los principios teóricos en situaciones reales de campo.

Los valores fisiológicos mostrados en este documento deben interpretarse como referencias orientativas obtenidas a partir de estudios experimentales y experiencia clínica. La respuesta individual puede variar significativamente en función de factores como edad, estado fisiológico, humedad de la piel, patologías previas, medicación, superficie de contacto y trayectoria de la corriente.
## Alcance

Este manual está orientado a la revisión periódica, verificación post-reparación y evaluación de seguridad eléctrica de equipos electromédicos utilizados en entornos sanitarios.

Quedan fuera del alcance de este documento:
- Reparaciones electrónicas internas.
- Calibraciones     
- Verificaciones metrológicas especializadas.    
- Procedimientos específicos definidos exclusivamente por determinados fabricantes.
    

## Público objetivo

Este manual ha sido redactado para técnicos de electromedicina, personal de ingeniería clínica y profesionales responsables del mantenimiento de tecnología sanitaria.

Se asume que el lector posee conocimientos básicos sobre:

- Electricidad y electrónica.    
- Seguridad eléctrica en equipos médicos.    
- Instrumentación de medida.    
- Interpretación de documentación técnica.    
- Normativa aplicable a tecnología sanitaria.    

No obstante, se ha procurado que cada procedimiento incluya la explicación técnica necesaria para comprender no solo cómo realizar una prueba, sino también por qué debe realizarse y qué riesgos pretende controlar.

La experiencia demuestra que conocer el procedimiento no siempre garantiza una correcta evaluación técnica. La interpretación de los resultados y la comprensión de los mecanismos de fallo son elementos esenciales para realizar una valoración adecuada del estado del equipo.

## Filosofía de trabajo

La seguridad eléctrica en electromedicina no debe entenderse como una simple sucesión de mediciones destinadas a obtener un resultado de "apto" o "no apto".

Cada valor registrado constituye una información técnica que permite evaluar la evolución del equipo a lo largo de su vida útil.

Un equipo que hoy cumple los límites establecidos por la norma puede estar mostrando señales tempranas de degradación que únicamente serán detectables mediante el análisis histórico de sus resultados.

Por este motivo, toda intervención debe perseguir tres objetivos fundamentales:

1. Garantizar la seguridad del paciente.    
2. Garantizar la seguridad del operador.    
3. Detectar tendencias de deterioro antes de que se produzca una avería o un incidente clínico.    

La combinación de una inspección visual rigurosa, una correcta ejecución de las pruebas eléctricas y una adecuada interpretación de los resultados constituye la base de un programa eficaz de mantenimiento preventivo.


---

# PARTE I - FUNDAMENTOS

## 1. Introducción a la Seguridad Eléctrica

Este capítulo debe responder a una pregunta:

> ¿Por qué existe toda esta normativa y por qué dedicamos tiempo a medir corrientes que en otros entornos se considerarían insignificantes?

### 1.1 ¿Por qué es necesaria la seguridad eléctrica?

La seguridad eléctrica en ingeniería biomédica es una disciplina de gestión de riesgos orientada a prevenir el choque eléctrico, el cual se produce cuando el cuerpo humano pasa a formar parte de un circuito eléctrico cerrado. La gravedad de este choque depende de tres variables críticas: la intensidad de la corriente, la trayectoria que sigue a través del cuerpo y el tiempo de exposición.

El paso de la corriente eléctrica por el organismo genera tres efectos fisiológicos principales:
1. **Estimulación de tejidos excitables:** Altera los impulsos nerviosos y provoca contracciones musculares involuntarias violentas (tetanización), impidiendo que la víctima se suelte de la fuente de tensión.
2. **Efecto térmico (Quemaduras):** Disipación de calor por efecto Joule que destruye tejidos superficiales e internos, vasos sanguíneos y nervios.
3. **Disrupción electroquímica (Fibrilación ventricular):** Altera el sistema de conducción eléctrica del corazón. Si una corriente alterna externa interfiere durante la fase vulnerable del ciclo cardíaco (la onda T del electrocardiograma), desincroniza las fibras miocárdicas, deteniendo el bombeo de sangre.


### 1.2 El entorno hospitalario

El hospital es uno de los entornos electromecánicos más complejos y hostiles que existen. Rompe las reglas de seguridad de cualquier otra infraestructura debido a la convergencia de tres factores:

* **Densidad de equipamiento:** Un solo paciente en una Unidad de Cuidados Intensivos (UCI) o en un quirófano puede estar conectado simultáneamente a más de diez equipos electromédicos (monitores, bombas de infusión, ventiladores, ecógrafos, mantas térmicas). Si estos equipos no comparten una referencia de tierra idéntica, se generan diferencias de potencial entre sus chasis, provocando el flujo de corrientes de fuga a través del paciente.
* **Presencia de fluidos conductores:** El uso constante de soluciones salinas, sangre, geles de ultrasonido, antisépticos y fluidos corporales reduce drásticamente la resistencia de las superficies y crea caminos conductivos accidentales hacia la electrónica de los equipos.
* **Continuidad del servicio clínico:** Los equipos médicos no pueden desconectarse abruptamente ante cualquier fallo menor. Los sistemas de distribución eléctrica hospitalaria (como los sistemas IT o de aislamiento) están diseñados para seguir operando incluso ante un primer fallo a tierra, lo que exige un monitoreo y mantenimiento preventivo extremadamente riguroso por parte del servicio técnico.
*  **Pérdida de las defensas naturales (Microchoque):** En el hospital, la barrera de la piel se rompe deliberadamente mediante agujas, electrodos con gel conductivo, catéteres e incisiones quirúrgicas. 
	*Cuando un catéter lleno de solución salina o un electrodo interno se introduce directamente en el sistema vascular o cerca del miocardio, la resistencia cae prácticamente a cero. Bajo esta condición, una corriente insignificante de apenas **$10\ \mu\text{A}$ (microamperios)** aplicada directamente al corazón es suficiente para inducir fibrilación ventricular y un paro cardíaco. 
	 **Incapacidad de reacción:** Un paciente bajo anestesia, sedado o conectado a soporte vital no puede sentir el cosquilleo de una fuga eléctrica ni tiene la capacidad física de retirarse o alertar al personal médico.  
-  **Compromiso sistémico:** El organismo de un paciente enfermo o monitorizado ya se encuentra debilitado. Sus umbrales de tolerancia fisiológica son mucho menores que los de una persona sana en un entorno doméstico. 

### 1.3 El paciente como elemento vulnerable

En condiciones normales, la piel humana actúa como una barrera de alta resistencia óhmica (entre $10,000\ \Omega$ y $100,000\ \Omega$ dependiendo de la humedad). Esta resistencia limita la corriente que penetra al cuerpo si tocamos accidentalmente un chasis energizado, un fenómeno conocido como **Macrochoque**.

Sin embargo, el paciente clínico es un sujeto indefenso por tres razones fundamentales:

* **Pérdida de las defensas naturales (Microchoque):** En el hospital, la barrera de la piel se rompe deliberadamente mediante agujas, electrodos con gel conductivo, catéteres e incisiones quirúrgicas. Cuando un catéter lleno de solución salina o un electrodo interno se introduce directamente en el sistema vascular o cerca del miocardio, la resistencia cae prácticamente a cero. Bajo esta condición, una corriente insignificante de apenas **$10\ \mu\text{A}$ (microamperios)** aplicada directamente al corazón es suficiente para inducir fibrilación ventricular y un paro cardíaco.
* **Incapacidad de reacción:** Un paciente bajo anestesia, sedado o conectado a soporte vital no puede sentir el cosquilleo de una fuga eléctrica ni tiene la capacidad física de retirarse o alertar al personal médico.
* **Compromiso sistémico:** El organismo de un paciente enfermo o monitorizado ya se encuentra debilitado. Sus umbrales de tolerancia fisiológica son mucho menores que los de una persona sana en un entorno doméstico.


### 1.4 Evolución histórica de la seguridad eléctrica

La necesidad de regular estrictamente la electricidad en la medicina no nació de la teoría, sino de la acumulación de accidentes trágicos durante el siglo XX a medida que la tecnología médica se expandía:

* **Décadas de 1950 y 1960 (El despertar del riesgo):** Con la llegada de los primeros electrocardiógrafos de red, desfibriladores y bombas de circulación extracorpórea, comenzaron a registrarse muertes inexplicables en quirófanos. En 1969, el cirujano Dr. Carl Walter publicó un alarmante informe estimando que cerca de 1,200 pacientes morían electrocutados anualmente en hospitales de EE.UU. por microchoques silenciosos causados por líneas de tierra defectuosas. Esto obligó a la comunidad de ingeniería a actuar.
* **1977 (La unificación global):** La Comisión Electrotécnica Internacional publicó la primera edición de la norma **IEC 60601-1**. Por primera vez en la historia, se definieron las reglas de diseño para la fabricación de equipos electromédicos, introduciendo conceptos críticos como el doble aislamiento (Clase II), las partes aplicables aisladas de tierra (Tipo CF) y los límites estrictos para corrientes de fuga en fábrica.
* **Siglo XXI (El enfoque de mantenimiento):** Fabricar equipos seguros ya no era suficiente; los hospitales necesitaban asegurar que esos equipos mantuvieran sus propiedades tras años de uso clínico y reparaciones en campo. Para cubrir este vacío técnico, en **2007** se publicó la primera edición de la norma **IEC 62353** ("Equipos electromédicos - Ensayos recurrentes y ensayos después de la reparación"). 

---

## 2. Normativa Aplicable

## 2.1 IEC 60601: Norma de Fabricación

La serie de normas IEC 60601 constituye la referencia internacional para el diseño y fabricación de equipos electromédicos.

Su objetivo principal es garantizar que un equipo nuevo cumple los requisitos esenciales de:

- Seguridad eléctrica.    
- Seguridad mecánica.    
- Compatibilidad electromagnética.    
- Funcionamiento esencial.    
- Protección frente a riesgos previsibles.    

Las pruebas definidas por la IEC 60601 se realizan normalmente en laboratorio y bajo condiciones controladas.

Durante el proceso de certificación se evalúan aspectos como:

- Corrientes de fuga.    
- Rigidez dieléctrica.    
- Temperaturas máximas.    
- Resistencia mecánica.    
- Compatibilidad electromagnética.    
- Condiciones de fallo único.    

Estas verificaciones permiten demostrar que el equipo cumple los requisitos de seguridad establecidos por el fabricante antes de su comercialización.

Sin embargo, la aplicación directa de estas pruebas en un entorno hospitalario resulta, en muchos casos, impracticable o incluso potencialmente dañina para equipos en servicio.

---

## 2.2 IEC 62353: Norma de Mantenimiento

La IEC 62353 fue desarrollada específicamente para cubrir las necesidades de verificación periódica y post-reparación de equipos electromédicos en uso clínico.

Su filosofía difiere significativamente de la IEC 60601.

Mientras que la IEC 60601 busca validar el diseño del equipo, la IEC 62353 pretende verificar que dicho diseño continúa siendo seguro después de años de utilización.

La norma establece procedimientos simplificados que permiten realizar ensayos directamente en el hospital sin comprometer la integridad del equipo.

Entre las pruebas más habituales se encuentran:

- Inspección visual.    
- Resistencia de tierra de protección.    
- Resistencia de aislamiento.    
- Corriente de fuga del equipo.    
- Corriente de fuga de partes aplicadas.    
- Verificaciones posteriores a reparaciones.    

La IEC 62353 constituye actualmente la referencia principal para los programas de mantenimiento preventivo desarrollados por los servicios de electromedicina.

---

## 2.3 Relación entre IEC 60601 e IEC 62353

Una de las dudas más frecuentes entre técnicos que comienzan a trabajar con seguridad eléctrica es la diferencia existente entre ambas normas.

Aunque están estrechamente relacionadas, sus objetivos son distintos.

|        Aspecto         |       IEC 60601        |      IEC 62353       |
| :--------------------: | :--------------------: | :------------------: |
|       Aplicación       |      Fabricación       |    Mantenimiento     |
|     Momento de uso     | Diseño y certificación | Vida útil del equipo |
|        Entorno         |      Laboratorio       |       Hospital       |
| Complejidad de ensayos |          Alta          |       Moderada       |
| Riesgo para el equipo  |         Mayor          |       Reducido       |
|   Usuario principal    |       Fabricante       |   Servicio técnico   |

Desde un punto de vista práctico, el técnico de electromedicina utilizará habitualmente la IEC 62353 durante las revisiones periódicas, mientras que la IEC 60601 servirá principalmente como referencia para comprender la arquitectura de seguridad definida por el fabricante.

---

## 2.4 Otras Normas y Documentos de Referencia


Aunque la IEC 62353 constituye el eje principal de este manual, existen otros documentos que pueden resultar relevantes durante determinadas intervenciones.

### IEC 60601-1

Norma general de seguridad básica y funcionamiento esencial de equipos electromédicos.

Permite comprender la clasificación eléctrica de los equipos y los criterios utilizados durante su diseño.

### IEC 60601-1-2

Norma específica de compatibilidad electromagnética.

Especialmente relevante en equipos de ultrasonidos debido a la gran cantidad de dispositivos electrónicos presentes en entornos hospitalarios.

### Manuales de Servicio del Fabricante

Siempre que estén disponibles, los procedimientos del fabricante deben considerarse prioritarios para aspectos específicos del equipo.

Los límites y procedimientos definidos por el fabricante podrán complementar o restringir determinados ensayos contemplados por la IEC 62353.

### Procedimientos Internos del Centro

Algunos hospitales disponen de protocolos propios de mantenimiento, frecuencias de revisión o criterios documentales que deben integrarse dentro del programa general de seguridad eléctrica.

---

## 2.5 Principio Fundamental de Aplicación

Ninguna norma puede sustituir el criterio técnico.

Las normas proporcionan límites, procedimientos y criterios de aceptación, pero la interpretación de los resultados continúa siendo responsabilidad del profesional que realiza la evaluación.

Un equipo que cumple todos los límites establecidos puede presentar signos evidentes de deterioro que aconsejen una intervención preventiva.

Del mismo modo, determinados resultados anómalos pueden estar relacionados con características constructivas específicas del fabricante y no representar necesariamente una situación de riesgo.

Por este motivo, el cumplimiento normativo debe considerarse una herramienta de evaluación y no un sustituto del juicio técnico.

---
### 2.6 Responsabilidades

Porque muchas veces el técnico conoce la parte técnica pero no la documental.

Algo tipo:

- El fabricante diseña.
- El servicio técnico verifica.
- El centro sanitario debe conservar registros.
- Toda intervención debe ser trazable.
## 2.7 Conclusiones

La IEC 62353 constituye el marco de referencia para la evaluación periódica de seguridad eléctrica de los equipos en servicio.

Su correcta aplicación permite detectar degradaciones del aislamiento, defectos en los sistemas de protección y posibles riesgos para pacientes y operadores sin necesidad de recurrir a los complejos ensayos de certificación definidos por la IEC 60601.

Comprender la relación entre ambas normas resulta fundamental para interpretar correctamente los resultados obtenidos durante las revisiones técnicas.
---

# 3. Conceptos Eléctricos Aplicados a la Seguridad Eléctrica

## 3.1 Introducción

La seguridad eléctrica en equipos electromédicos se basa en la comprensión de una serie de fenómenos eléctricos que, aunque conocidos por cualquier técnico, adquieren una importancia especial cuando existe contacto directo o indirecto con pacientes.

En un entorno industrial, pequeñas corrientes de fuga pueden considerarse irrelevantes. Sin embargo, en un entorno clínico, esas mismas corrientes pueden representar un riesgo significativo debido a las condiciones fisiológicas particulares del paciente y a la existencia de dispositivos invasivos que reducen las barreras naturales de protección del organismo.

Los conceptos descritos en este capítulo constituyen la base para comprender los ensayos y criterios de aceptación desarrollados posteriormente.

---

## 3.2 Tensión de Contacto

Se denomina tensión de contacto a la diferencia de potencial que puede aparecer entre dos puntos accesibles simultáneamente por una persona.

En condiciones normales de funcionamiento, las partes metálicas accesibles de un equipo electromédico no deben presentar tensiones peligrosas respecto a tierra ni respecto a otros elementos conductores del entorno.

Sin embargo, determinados defectos de aislamiento o fallos internos pueden provocar la aparición de tensiones residuales sobre la carcasa del equipo.

La función de los sistemas de protección, especialmente la toma de tierra y los aislamientos de seguridad, consiste en evitar que dichas tensiones alcancen valores peligrosos para pacientes y operadores.

---

## 3.3 Corriente de Fuga

La corriente de fuga es una pequeña corriente eléctrica que circula fuera del recorrido previsto de funcionamiento.

Su existencia no implica necesariamente un defecto.

Incluso equipos en perfecto estado generan corrientes de fuga debido a:

- Capacidades parásitas.    
- Filtros de compatibilidad electromagnética (EMI).    
- Condensadores conectados entre líneas activas y tierra.    
- Características propias de las fuentes de alimentación conmutadas.    

Por este motivo, la normativa no exige una corriente de fuga nula, sino que establece límites máximos admisibles en función del tipo de equipo y de su aplicación clínica.

La medición de corrientes de fuga constituye uno de los principales indicadores del estado de seguridad eléctrica de un equipo electromédico.

---

## 3.4 Impedancia del Cuerpo Humano

La respuesta del organismo frente a una corriente eléctrica depende en gran medida de la impedancia que presenta el cuerpo humano al paso de dicha corriente.

Aunque frecuentemente se habla de "resistencia corporal", en realidad el comportamiento eléctrico del organismo es más complejo y se describe mediante el concepto de impedancia.

La impedancia corporal no es constante y puede variar significativamente dependiendo de múltiples factores:

#### Estado de la piel

La piel constituye la principal barrera eléctrica del organismo.

Una piel sana, seca e intacta puede presentar una impedancia relativamente elevada, limitando el paso de corriente.

Sin embargo, dicha impedancia disminuye considerablemente cuando existen:

- Heridas.    
- Erosiones.    
- Quemaduras.    
- Procesos inflamatorios.    
- Sudoración intensa.    

#### Humedad

La presencia de humedad sobre la piel reduce de forma importante la impedancia superficial.

Por este motivo, el riesgo eléctrico aumenta en situaciones como:

- Pacientes sudorosos.    
- Procedimientos realizados en ambientes húmedos.    
- Contacto con fluidos corporales.    

#### Geles y medios conductores

En el entorno sanitario es habitual el uso de sustancias diseñadas específicamente para mejorar la conductividad eléctrica o acústica.

Entre ellas destacan:

- Gel de ecografía.    
- Gel conductor para ECG.    
- Cremas conductoras.    
- Soluciones salinas.    

Estos productos reducen la impedancia de contacto entre el equipo y el paciente, mejorando la calidad de la señal clínica pero aumentando simultáneamente la capacidad de circulación de corriente eléctrica.

Este fenómeno explica la importancia de controlar rigurosamente las corrientes de fuga en equipos que utilizan electrodos o transductores en contacto directo con el paciente.

#### Superficie de contacto

A igualdad de tensión, una superficie de contacto amplia suele generar una menor densidad de corriente que una superficie reducida.

Por ello, los riesgos asociados a agujas, catéteres o electrodos invasivos son significativamente mayores que los asociados al simple contacto sobre piel intacta.

#### Dispositivos invasivos

La situación de mayor riesgo se produce cuando la corriente eléctrica puede acceder directamente a tejidos internos o al sistema circulatorio.

Catéteres intracardíacos, marcapasos temporales, guías vasculares y otros dispositivos invasivos eliminan gran parte de las barreras naturales del organismo, permitiendo que corrientes extremadamente pequeñas puedan alcanzar estructuras especialmente sensibles.

Esta circunstancia constituye el fundamento del concepto de microchoque, desarrollado en capítulos posteriores.

---

## 3.5 Influencia de la Frecuencia

Los efectos fisiológicos de la corriente eléctrica dependen no solo de su intensidad, sino también de su frecuencia.

La corriente alterna de 50 Hz utilizada en las redes eléctricas resulta especialmente peligrosa debido a su capacidad para interferir con la actividad eléctrica natural del corazón.

Por el contrario, corrientes de frecuencias muy elevadas pueden producir efectos diferentes, predominando fenómenos térmicos frente a fenómenos de estimulación muscular o cardíaca.

Este comportamiento explica la existencia de diferentes límites normativos según el tipo de señal eléctrica analizada.

---

## 3.6 Relación entre Corriente y Daño Fisiológico

La gravedad de una descarga eléctrica depende de múltiples factores:

- Intensidad de corriente.    
- Tiempo de exposición.    
- Trayectoria de la corriente.    
- Frecuencia.    
- Estado fisiológico del paciente.    

No obstante, de forma orientativa pueden establecerse los siguientes efectos:

|Corriente aproximada|Efecto fisiológico|
|---|---|
|< 1 mA|Generalmente imperceptible|
|1 – 5 mA|Sensación de hormigueo|
|5 – 10 mA|Dolor moderado|
|10 – 30 mA|Contracción muscular involuntaria|
|> 30 mA|Riesgo significativo|
|> 75 mA|Posible fibrilación ventricular|

Estos valores deben interpretarse únicamente como referencias generales, ya que las condiciones clínicas pueden modificar sustancialmente el riesgo real.

---

## 3.7 Particularidades del Paciente Hospitalario

La diferencia fundamental entre la seguridad eléctrica industrial y la seguridad eléctrica hospitalaria radica en el estado del paciente.

Una persona sana constituye normalmente una barrera eléctrica relativamente eficaz gracias a la integridad de su piel.

Sin embargo, los pacientes hospitalizados presentan con frecuencia circunstancias que aumentan significativamente su vulnerabilidad:

- Alteraciones fisiológicas.    
- Dispositivos invasivos.    
- Electrodos adheridos a la piel.    
- Exposición a fluidos.    
- Procedimientos diagnósticos o terapéuticos simultáneos.    

Por este motivo, corrientes consideradas insignificantes en otros entornos pueden convertirse en un riesgo clínico relevante dentro del ámbito sanitario.

La comprensión de esta realidad constituye el fundamento sobre el que se desarrollan todas las normas de seguridad eléctrica aplicadas a equipos electromédicos.

---

# PARTE II - RIESGO ELÉCTRICO

# 4. Efectos de la Corriente Eléctrica sobre el Organismo

## 4.1 Introducción

La electricidad forma parte del funcionamiento normal del cuerpo humano.

La actividad del sistema nervioso, la contracción muscular y el ritmo cardíaco dependen de impulsos eléctricos generados de forma natural por el organismo.

Cuando una corriente eléctrica externa atraviesa el cuerpo, puede interferir con estos procesos fisiológicos produciendo efectos que van desde una simple sensación de hormigueo hasta lesiones graves o la muerte.

La gravedad del daño no depende exclusivamente de la tensión aplicada, sino de una combinación de factores entre los que destacan:

- Intensidad de corriente.    
- Tiempo de exposición.    
- Trayectoria de la corriente.    
- Frecuencia.    
- Estado fisiológico de la persona.    
- Existencia de dispositivos invasivos.    

Comprender estos mecanismos resulta fundamental para interpretar correctamente los límites establecidos por las normas de seguridad eléctrica.

---

## 4.2 Factores que Determinan el Riesgo Eléctrico

No todas las descargas eléctricas producen las mismas consecuencias.

Dos personas expuestas a la misma tensión pueden experimentar efectos completamente distintos dependiendo de las condiciones existentes en el momento del contacto.

Los factores más importantes son:

### Intensidad de corriente

Es el factor que más influye en el daño fisiológico.

A medida que aumenta la corriente que atraviesa el organismo, aumentan también los efectos sobre músculos, nervios y tejido cardíaco.

### Tiempo de exposición

Una corriente relativamente baja mantenida durante varios segundos puede resultar más peligrosa que una corriente superior aplicada durante un tiempo muy breve.

### Trayectoria

La corriente siempre busca un camino entre dos puntos con diferente potencial eléctrico.

Las trayectorias que atraviesan el tórax presentan un riesgo especialmente elevado debido a la proximidad del corazón.

Ejemplos de trayectorias peligrosas:

- Mano izquierda – mano derecha.    
- Mano – pie.    
- Tórax – extremidades.    

### Frecuencia

La corriente alterna de 50 Hz utilizada en las instalaciones eléctricas es especialmente peligrosa debido a su capacidad para interferir con la actividad eléctrica cardíaca.

### Estado del paciente

Las condiciones clínicas pueden modificar de forma importante la susceptibilidad frente a una descarga eléctrica.

Pacientes críticos, anestesiados o portadores de dispositivos invasivos presentan riesgos significativamente superiores a los de una persona sana.

---

## 4.3 Umbrales Fisiológicos Aproximados

Aunque cada individuo responde de forma diferente, existen rangos de corriente que permiten comprender los posibles efectos fisiológicos.

|Corriente|Efecto probable|
|---|---|
|< 1 mA|Generalmente imperceptible|
|1 - 5 mA|Hormigueo o sensación de corriente|
|5 - 10 mA|Dolor moderado|
|10 - 20 mA|Contracción muscular involuntaria|
|20 - 30 mA|Dificultad para soltarse del conductor|
|30 - 75 mA|Alteraciones respiratorias|
|> 75 mA|Riesgo elevado de fibrilación ventricular|
|> 1 A|Quemaduras graves y parada cardíaca|

**Estos valores deben considerarse únicamente orientativos y no representan límites absolutos de seguridad.**

---

## 4.4 Contracción Muscular

La corriente eléctrica estimula directamente las fibras nerviosas y musculares.

Cuando la intensidad supera determinados niveles, los músculos comienzan a contraerse involuntariamente.

Uno de los efectos más característicos es el denominado fenómeno de "no poder soltarse".

En esta situación, los músculos flexores de la mano se contraen con mayor intensidad que los extensores, impidiendo que la persona libere voluntariamente el conductor que está sujetando.

Este efecto aumenta considerablemente el tiempo de exposición y, por tanto, la gravedad potencial del accidente.

---

## 4.5 Alteraciones Respiratorias

Las corrientes eléctricas también pueden afectar a los músculos responsables de la respiración.

La contracción sostenida del diafragma y de la musculatura torácica puede impedir temporalmente la ventilación pulmonar.

En exposiciones prolongadas, esta situación puede provocar hipoxia y pérdida de conciencia.

Aunque generalmente estos efectos son reversibles tras la interrupción de la corriente, representan una situación de emergencia médica.

---

## 4.6 Fibrilación Ventricular

La fibrilación ventricular constituye el riesgo más grave asociado a las descargas eléctricas de baja intensidad.

En condiciones normales, el corazón se contrae de forma coordinada gracias a impulsos eléctricos generados y distribuidos por su sistema de conducción.

Cuando una corriente externa interfiere con este mecanismo, puede producirse una activación caótica de las fibras cardíacas.

Durante la fibrilación ventricular:

- El corazón continúa mostrando actividad eléctrica.    
- Desaparece la contracción mecánica eficaz.    
- Se interrumpe el bombeo de sangre.    
- La supervivencia depende de una desfibrilación rápida.    

Este fenómeno es la principal razón por la que la normativa de electromedicina establece límites extremadamente restrictivos para las corrientes de fuga.

---

## 4.7 Quemaduras Eléctricas

Además de los efectos fisiológicos, la corriente eléctrica puede producir daños térmicos.
La energía disipada durante el paso de corriente genera calor en los tejidos.
Las lesiones suelen concentrarse en:

- Puntos de entrada.    
- Puntos de salida.    
- Zonas de elevada densidad de corriente.    

Las quemaduras pueden afectar tanto a tejidos superficiales como a estructuras profundas.

En equipos electromédicos modernos este riesgo es poco frecuente, pero debe considerarse en situaciones de fallo grave.

---

## 4.8 Particularidades del Entorno Hospitalario

El riesgo eléctrico en un hospital difiere sustancialmente del existente en otros entornos.

Muchos pacientes presentan condiciones que reducen las barreras naturales de protección:

- Heridas abiertas.    
- Electrodos adheridos a la piel.    
- Catéteres vasculares.    
- Marcapasos temporales.    
- Procedimientos invasivos.    
- Presencia de fluidos conductores.    

Estas circunstancias permiten que corrientes extremadamente pequeñas alcancen tejidos internos con una eficacia mucho mayor que en una persona sana.

Por este motivo, los límites de seguridad establecidos para equipos médicos son considerablemente más exigentes que los utilizados en aplicaciones industriales o domésticas.

---

## 4.9 Aplicación Práctica para el Técnico de Electromedicina

Durante una revisión de seguridad eléctrica, el objetivo no consiste únicamente en comprobar si un equipo cumple o no una tabla de límites.

El técnico debe comprender que detrás de cada medición existe un riesgo fisiológico concreto.

Una corriente de fuga aparentemente insignificante puede representar un peligro real cuando el equipo se utiliza sobre pacientes críticos o durante procedimientos invasivos.

La interpretación de los resultados debe realizarse siempre considerando:

- El tipo de equipo.    
- La clasificación eléctrica.    
- El uso clínico previsto.    
- El perfil del paciente.    

Esta visión global constituye la base de una evaluación técnica rigurosa y es el motivo por el que la seguridad eléctrica ocupa un papel central dentro de la ingeniería clínica moderna.

---

## 4.10 Conclusiones

Los efectos de la corriente eléctrica sobre el organismo dependen de múltiples factores y pueden variar desde simples sensaciones perceptibles hasta alteraciones cardíacas potencialmente mortales.

La comprensión de estos mecanismos permite interpretar adecuadamente los requisitos de las normas de seguridad eléctrica y entender la necesidad de controlar de forma rigurosa las corrientes de fuga presentes en los equipos electromédicos.

En el siguiente capítulo se desarrollarán los conceptos de macrochoque y microchoque, fundamentales para comprender los criterios de clasificación y protección utilizados en tecnología sanitaria.
---

# 5. Macrochoque y Microchoque

## 5.1 Introducción

La mayor parte de los accidentes eléctricos que ocurren fuera del entorno sanitario corresponden a situaciones de macrochoque.

Sin embargo, en electromedicina existe una circunstancia particular que obliga a considerar un riesgo adicional: la posibilidad de que corrientes extremadamente pequeñas alcancen directamente tejidos internos o el propio corazón.

Este fenómeno recibe el nombre de microchoque.

La comprensión de la diferencia entre ambos conceptos constituye uno de los pilares fundamentales de la seguridad eléctrica hospitalaria y explica gran parte de las limitaciones establecidas por las normas IEC 60601 e IEC 62353.

---

## 5.2 Macrochoque

Se denomina macrochoque al paso de corriente eléctrica a través del cuerpo humano utilizando las vías normales de contacto externo.

La corriente penetra generalmente a través de la piel y atraviesa distintos tejidos antes de abandonar el organismo.

Ejemplos habituales:

- Contacto con una carcasa metálica energizada.    
- Manipulación de conductores activos.    
- Defectos de aislamiento en instalaciones eléctricas.    
- Contacto accidental con equipos defectuosos.    

En estos casos la piel constituye una barrera importante que limita parcialmente la corriente circulante.

Los efectos fisiológicos dependerán de:

- Intensidad.    
- Tiempo de exposición.    
- Trayectoria.    
- Estado de la piel.    

La mayoría de estudios sobre electrocución se basan en situaciones de macrochoque.

---

## 5.3 Microchoque

El microchoque se produce cuando una corriente eléctrica alcanza directamente tejidos internos sin atravesar previamente la barrera protectora de la piel.

Esta situación puede ocurrir cuando existen dispositivos invasivos capaces de establecer una conexión eléctrica con el interior del organismo.

Ejemplos:

- Catéteres intracardíacos.    
- Marcapasos temporales.    
- Electrodos intracavitarios.    
- Guías vasculares.    
- Catéteres centrales.    

En estas circunstancias desaparece gran parte de la protección proporcionada por la piel y pequeñas corrientes pueden llegar directamente al miocardio.

Corrientes que resultarían imperceptibles para una persona sana pueden producir alteraciones cardíacas graves cuando alcanzan directamente el tejido cardíaco.

---

## 5.4 ¿Por qué el Corazón es Especialmente Vulnerable?

El corazón funciona gracias a un sistema eléctrico propio encargado de coordinar la contracción de sus fibras musculares.

Cada latido es el resultado de una secuencia cuidadosamente sincronizada de impulsos eléctricos.

Una corriente externa aplicada durante determinados momentos del ciclo cardíaco puede alterar esta sincronización y provocar:

- Extrasístoles.    
- Taquicardias.    
- Fibrilación ventricular.    
- Parada cardíaca.    

La vulnerabilidad aumenta cuando la corriente alcanza directamente el miocardio mediante dispositivos invasivos.

---

## 5.5 Comparación entre Macrochoque y Microchoque

|Característica|Macrochoque|Microchoque|
|---|---|---|
|Entrada de corriente|A través de la piel|Directamente a tejidos internos|
|Protección natural|Piel|Muy reducida o inexistente|
|Corriente necesaria para producir daño grave|Relativamente elevada|Extremadamente baja|
|Situación habitual|Accidentes eléctricos convencionales|Entorno hospitalario|
|Principal riesgo|Electrocución general|Fibrilación ventricular|

---

## 5.6 Dispositivos Invasivos y Riesgo Asociado

La presencia de dispositivos invasivos modifica radicalmente el escenario de riesgo eléctrico.

Un paciente conectado simultáneamente a varios equipos médicos puede disponer de múltiples caminos potenciales para la circulación de corrientes de fuga.

Algunos ejemplos clínicos incluyen:

- Catéteres venosos centrales.    
- Catéteres de Swan-Ganz.    
- Marcapasos temporales.    
- Sistemas de monitorización intracardíaca.    
- Procedimientos electrofisiológicos.    

Estas situaciones justifican la existencia de clasificaciones especiales como BF y CF, que serán desarrolladas en capítulos posteriores.

---

## 5.7 Relación con las Corrientes de Fuga

La principal razón por la que las normas electromédicas limitan estrictamente las corrientes de fuga radica precisamente en la prevención del microchoque.

En otros sectores industriales una corriente de algunos cientos de microamperios podría considerarse despreciable.

En electromedicina, esa misma corriente puede ser relevante dependiendo de:

- La aplicación clínica.    
- La clasificación del equipo.    
- El tipo de paciente.    
- La existencia de accesos invasivos.    

Por este motivo, las mediciones de corrientes de fuga constituyen uno de los ensayos más importantes durante las revisiones de seguridad eléctrica.

---

## 5.8 Ejemplo Práctico

Imaginemos dos situaciones diferentes:

### Situación A

Un técnico toca accidentalmente una carcasa metálica con una pequeña tensión residual.

La corriente atraviesa la piel de la mano, parte del brazo y abandona el cuerpo por otro punto de contacto.

Dependiendo de la intensidad, podrá experimentar desde una sensación de hormigueo hasta una descarga dolorosa.

### Situación B

Un paciente portador de un catéter intracardíaco está conectado a varios equipos médicos.

Una pequeña corriente de fuga alcanza el sistema de monitorización y encuentra un camino hacia el miocardio a través del catéter.

Aunque dicha corriente sea extremadamente pequeña y resulte imperceptible desde el exterior, el riesgo fisiológico puede ser considerablemente superior.

Este ejemplo ilustra la diferencia fundamental entre macrochoque y microchoque.

---

## 5.9 Consecuencias para el Técnico de Electromedicina

Desde el punto de vista práctico, el técnico debe asumir que la seguridad eléctrica hospitalaria no se basa únicamente en evitar descargas perceptibles.

El objetivo real consiste en impedir que cualquier corriente potencialmente peligrosa alcance al paciente, especialmente cuando existen procedimientos invasivos.

Por ello, la evaluación de:

- Corrientes de fuga.    
- Aislamiento.    
- Tierra de protección.    
- Clasificación de partes aplicadas.    

debe realizarse siempre considerando el contexto clínico real del equipo.

---

## 5.10 Conclusiones

La diferencia entre macrochoque y microchoque constituye uno de los conceptos fundamentales de la seguridad eléctrica aplicada a la tecnología sanitaria.

Mientras que el macrochoque representa el riesgo eléctrico convencional asociado al paso de corriente a través de la piel, el microchoque aparece cuando corrientes extremadamente pequeñas alcanzan directamente tejidos internos o el propio corazón.

La prevención de este riesgo es uno de los principales motivos por los que los equipos electromédicos están sometidos a requisitos de diseño y mantenimiento significativamente más exigentes que los equipos eléctricos de uso general.
---

# 6. Sistemas de Protección

## 6.1 Introducción

La seguridad eléctrica de un equipo electromédico no depende de un único elemento de protección.

La filosofía de diseño utilizada en tecnología sanitaria se basa en la aplicación simultánea de múltiples barreras destinadas a evitar que una situación de fallo pueda poner en riesgo al paciente o al operador.

Estas barreras pueden ser de naturaleza física, eléctrica o funcional, actuando de forma complementaria para reducir la probabilidad de accidente.

Los sistemas de protección descritos en este capítulo constituyen la base sobre la que se construyen los requisitos establecidos por las normas IEC 60601 e IEC 62353.

---

## 6.2 Aislamiento Básico

El aislamiento básico es la primera barrera de protección frente al contacto con partes activas.

Está constituido por materiales aislantes que separan los conductores energizados de las partes accesibles del equipo.

Ejemplos habituales:

- Recubrimiento de conductores.    
- Barnices aislantes.    
- Carcasas plásticas.    
- Aislantes internos de transformadores.    
- Placas y soportes aislantes.
- Cámaras de aire

Durante el funcionamiento normal del equipo, el aislamiento básico debe impedir completamente el contacto accidental con tensiones peligrosas.

Sin embargo, debido al envejecimiento de materiales, humedad, contaminación o daños mecánicos, esta protección puede deteriorarse con el tiempo.

Por este motivo resulta imprescindible verificar periódicamente su integridad mediante inspecciones visuales y ensayos eléctricos.

---

## 6.3 Aislamiento Suplementario

El aislamiento suplementario constituye una segunda barrera independiente diseñada para mantener la seguridad incluso en caso de fallo del aislamiento básico.

Su objetivo es evitar que un único defecto provoque una situación peligrosa.

La filosofía es sencilla:

> Ningún fallo único debe exponer al paciente o al operador a un riesgo inaceptable.

Esta redundancia constituye uno de los principios fundamentales de la seguridad electromédica moderna.

---

## 6.4 Doble Aislamiento

Se considera que un equipo dispone de doble aislamiento cuando incorpora simultáneamente:

- Aislamiento básico.    
- Aislamiento suplementario.    

Los equipos con doble aislamiento no dependen de una conexión a tierra de protección para garantizar la seguridad del usuario.

Habitualmente se identifican mediante el símbolo de doble cuadrado.

Ejemplos frecuentes:

- Equipos portátiles alimentados mediante adaptadores específicos.    
- Algunos ecógrafos portátiles.    
- Equipos alimentados por batería.    

Aunque estos equipos no utilicen tierra de protección, continúan estando sujetos a los requisitos de seguridad eléctrica establecidos por las normas aplicables.

---

## 6.5 Tierra de Protección

La tierra de protección constituye uno de los sistemas de seguridad más utilizados en equipos de Clase I.

Su función consiste en proporcionar un camino de muy baja impedancia para las corrientes de defecto.

En caso de fallo del aislamiento, la corriente circula preferentemente hacia tierra en lugar de atravesar al usuario o al paciente.

Las principales funciones de la tierra de protección son:

- Evitar tensiones peligrosas sobre la carcasa.    
- Facilitar la actuación de protecciones eléctricas.    
- Limitar las tensiones de contacto.    
- Mejorar la seguridad frente a fallos internos.    

La continuidad de este conductor constituye uno de los ensayos fundamentales contemplados por la IEC 62353.

---

## 6.6 Equipotencialidad

La equipotencialidad consiste en mantener todos los elementos conductores accesibles de una zona a un potencial eléctrico lo más uniforme posible.

El objetivo no es eliminar completamente las tensiones, sino evitar diferencias de potencial peligrosas entre elementos que puedan ser tocados simultáneamente.

En entornos hospitalarios es habitual conectar a la red equipotencial:

- Tomas de tierra.    
- Estructuras metálicas.    
- Mesas quirúrgicas.    
- Equipos electromédicos.    
- Canalizaciones metálicas.    

La equipotencialidad adquiere especial importancia en:

- Quirófanos.    
- UCI.    
- Unidades coronarias.    
- Salas de hemodinámica.    

La reducción de diferencias de potencial contribuye significativamente a disminuir el riesgo de circulación de corrientes no deseadas a través del paciente.

---

## 6.7 Transformadores de Aislamiento

Los transformadores de aislamiento constituyen un elemento fundamental de los sistemas IT médicos.

Su misión es aislar galvánicamente determinadas áreas hospitalarias de la red general de distribución.

Mediante este aislamiento se consigue:

- Reducir corrientes de fuga.    
- Disminuir el riesgo de microchoque.    
- Mantener el servicio ante un primer defecto de aislamiento.    
- Mejorar la seguridad en áreas críticas.    

A diferencia de las instalaciones convencionales, un primer fallo de aislamiento en un sistema IT médico no provoca necesariamente la desconexión inmediata de la alimentación.

Esto permite mantener operativos equipos esenciales durante procedimientos clínicos críticos.

---

## 6.8 Sistemas IT Médicos

Los sistemas IT médicos se utilizan principalmente en áreas donde una interrupción repentina del suministro eléctrico podría poner en peligro la vida del paciente.

Entre ellas destacan:

- Quirófanos.    
- Salas de intervencionismo.    
- Unidades de cuidados intensivos.    
- Salas de reanimación.    

Sus características principales son:

- Alimentación mediante transformador de aislamiento.    
- Supervisión permanente del aislamiento.    
- Continuidad de servicio ante un primer fallo.    
- Reducción de corrientes de fuga a tierra.    

La vigilancia continua se realiza mediante dispositivos específicos denominados vigilantes de aislamiento.

Cuando se detecta una disminución del nivel de aislamiento, estos equipos generan alarmas que permiten actuar antes de que aparezca una situación peligrosa.

---

## 6.9 Filosofía de Protección por Capas

La seguridad eléctrica hospitalaria no se basa en una única medida de protección.

Un equipo moderno puede incorporar simultáneamente:

- Aislamiento básico.    
- Aislamiento suplementario.    
- Tierra de protección.    
- Sistemas de limitación de corriente.    
- Transformadores de aislamiento.    
- Equipotencialidad.    

Cada uno de estos elementos contribuye a reducir el riesgo global.

La pérdida de una barrera no debería provocar por sí sola una situación de peligro inmediato.

Esta estrategia de protección multicapa constituye uno de los principios fundamentales de diseño utilizados en tecnología sanitaria.

---

## 6.10 Aplicación Práctica para el Técnico de Electromedicina

Durante una revisión de seguridad eléctrica, el técnico debe considerar que las mediciones realizadas son únicamente una parte de la evaluación.

La inspección visual permite verificar el estado de las barreras físicas de protección.

Los ensayos eléctricos permiten comprobar la eficacia de dichas barreras.

La interpretación conjunta de ambos resultados proporciona una visión mucho más completa del estado real del equipo.

Una continuidad de tierra correcta no compensa un aislamiento deteriorado.

Del mismo modo, un buen aislamiento no elimina la necesidad de verificar la integridad del conductor de protección.

La evaluación debe entenderse siempre como una comprobación integral del conjunto de sistemas de protección presentes en el equipo.

---

## 6.11 Conclusiones

La seguridad eléctrica en equipos electromédicos se basa en la aplicación simultánea de múltiples barreras de protección.

El aislamiento, la tierra de protección, la equipotencialidad y los sistemas IT médicos constituyen elementos complementarios destinados a minimizar el riesgo de accidente eléctrico.

La comprensión de estos mecanismos resulta esencial para interpretar correctamente los ensayos de seguridad eléctrica y valorar adecuadamente los resultados obtenidos durante las revisiones técnicas.

---

# PARTE III - CLASIFICACIÓN DE EQUIPOS

# 7. Clasificación por Protección Eléctrica

## 7.1 Introducción

Los equipos electromédicos se clasifican en función de los mecanismos utilizados para proteger a pacientes y operadores frente al riesgo eléctrico.

Esta clasificación permite comprender cómo ha sido diseñado el equipo y cuáles son los sistemas de seguridad sobre los que se basa su funcionamiento.

Desde el punto de vista del mantenimiento, identificar correctamente la clase de protección resulta imprescindible para interpretar adecuadamente los ensayos de seguridad eléctrica y los límites aplicables.

---


## 8.5 Significado Clínico de la Clasificación

La clasificación B, BF o CF no indica la calidad del equipo ni su complejidad tecnológica.
Simplemente refleja el nivel de protección requerido en función del uso clínico previsto.
Un equipo BF puede ser perfectamente adecuado para una aplicación concreta mientras que un equipo CF resultaría innecesario.
La selección depende siempre del riesgo asociado al procedimiento.

---

## 8.6 Relación con el Microchoque

La existencia de las clasificaciones BF y CF está directamente relacionada con el concepto de microchoque descrito en el capítulo anterior.
A medida que aumenta la probabilidad de que una corriente alcance tejidos internos o el corazón, más estrictos se vuelven los requisitos de diseño y los límites de fuga permitidos.
Por este motivo, los equipos destinados a procedimientos invasivos están sujetos a requisitos especialmente exigentes.

---

## 8.7 Identificación de las Partes Aplicadas

Los fabricantes identifican la clasificación mediante símbolos normalizados situados en:

- Etiquetas del equipo.    
- Manuales técnicos.    
- Documentación de servicio.    

La correcta identificación resulta esencial para:

- Seleccionar los ensayos adecuados.    
- Aplicar los límites correctos.    
- Interpretar adecuadamente los resultados.    

---

## 8.8 Errores Habituales

Entre los errores más frecuentes se encuentran:

- Confundir Clase I con Tipo BF.    
- Confundir la clasificación del equipo con la clasificación de la parte aplicada.    
- Asumir que todos los equipos conectados al paciente son CF.    
- Interpretar BF y CF como indicadores de calidad.    

Clase de protección y tipo de parte aplicada son conceptos distintos y complementarios.

Un equipo puede ser simultáneamente:

- Clase I.    
- Con partes aplicadas BF.        ![[Guía_de_Seguridad_Eléctrica_Clínica.png]]

o

- Clase II.    
- Con partes aplicadas CF.
    

---

## 8.9 Conclusiones

La clasificación de partes aplicadas determina el nivel de protección exigido frente a las corrientes de fuga que pueden alcanzar al paciente.

Comprender las diferencias entre B, BF y CF resulta fundamental para interpretar correctamente los ensayos de seguridad eléctrica y valorar el riesgo asociado a cada aplicación clínica.

---

# PARTE IV - ENSAYOS DE SEGURIDAD ELÉCTRICA

# 9. Inspección Visual

## 9.1 Introducción

La inspección visual constituye el primer ensayo de seguridad eléctrica y, probablemente, el más infravalorado.

Diversos estudios y la experiencia acumulada tanto personalmente como de muchos compañeros, muestran que una gran parte de las incidencias relacionadas con la seguridad pueden detectarse mediante una inspección visual rigurosa, muchos de los problemas vienen derivados por cables en mal estado o roturas en aislamientos, por lo tanto independiente de si se va a realizar o no un mantenimiento preventivo en el equipo, conviene realizar una buena inspección visual de mismo y de todos sus accesorios o periféricos.

La inspección visual no debe considerarse un trámite previo a las mediciones, sino una evaluación técnica con entidad propia.

En numerosos casos, un defecto visible puede justificar la retirada inmediata del equipo sin necesidad de continuar con el resto de ensayos.

---

## 9.2 Objetivos

La inspección visual persigue varios objetivos:

- Detectar daños evidentes que comprometan la seguridad.    
- Identificar signos de deterioro progresivo.    
- Verificar la integridad de los sistemas de protección.    
- Comprobar la identificación y trazabilidad del equipo.    
- Detectar condiciones que puedan invalidar las mediciones posteriores.    

La inspección debe realizarse siempre antes de cualquier ensayo eléctrico, si en esta inspección se detectan evidentes fallos de seguridad, se interrumpe el ensayo y se retira el equipo para su reparación según los protocolos establecidos para ello por el centro o servicio de electromedicina.

---

## 9.3 Identificación del Equipo

Antes de iniciar cualquier verificación debe registrarse al menos la siguiente información, pudiendo verse ampliada si así lo estima el manual de operaciones vigente en el centro:

- Fabricante.    
- Modelo.    
- Número de serie.    
- Inventario interno.    
- Servicio o ubicación.    
- Fecha de revisión.    

Cuando sea posible, resulta recomendable consultar:

- Historial de mantenimiento.    
- Incidencias previas.    
- Reparaciones recientes.    
- Resultados de revisiones anteriores.    

El análisis histórico permite detectar tendencias de deterioro que podrían pasar desapercibidas durante una revisión aislada, para ello es interesante contar con gráficas de evolución de los valores registrados, entroncando cada revisión con los mantenimientos predictivos, cada día más demandado por los centros.

---

## 9.4 Cable de Alimentación

El cable de alimentación es uno de los elementos sometidos a mayor desgaste mecánico.

Debe verificarse:

- Integridad del aislamiento.    
- Ausencia de cortes.    
- Ausencia de aplastamientos.    
- Ausencia de empalmes no autorizados.    
- Estado de clavijas y conectores.    
- Integridad del alivio de tensión.
    

Cualquier daño que permita el acceso a conductores internos constituye un criterio de rechazo inmediato.
Quizás el más frecuente, sea el deslizamiento de la cobertura externa en las zonas de conexión, dejando al descubierto los conductores internos; en esta situación el cable debe ser sustituido, desaconsejando el recurso de la 'cinta aislante' para tapar la falla.

---

## 9.5 Carcasa y Elementos Exteriores

Las carcasas forman parte del sistema de protección del equipo.

Debe verificarse:

- Ausencia de grietas.    
- Ausencia de deformaciones.    
- Ausencia de piezas sueltas.    
- Integridad de tapas y cubiertas.    
- Correcta fijación de tornillos.    

Una carcasa dañada puede comprometer tanto el aislamiento como la protección mecánica de los componentes internos, en estos casos se debe valorar el nivel de degradación o rotura presente, a la más mínima duda de si puede afectar a la seguridad, se debe retirar de uso y derivarlo para reparación.

---

## 9.6 Etiquetado y Marcados

Deben comprobarse:

- Etiqueta identificativa.    
- Clasificación eléctrica.    
- Marcado CE cuando proceda.    
- Advertencias de seguridad.    
- Etiquetas de mantenimiento.    

Las etiquetas deben ser legibles y permanecer firmemente fijadas al equipo, 

---

## 9.7 Signos de Humedad o Contaminación

La presencia de humedad constituye una de las principales causas de deterioro del aislamiento.

Debe prestarse especial atención a:

- Manchas.    
- Corrosión.    
- Restos de líquidos.    
- Oxidación.    
- Acumulación de suciedad conductiva.    

La detección de humedad reciente puede justificar la suspensión temporal de los ensayos eléctricos, la presencia de cualquier líquido en el equipo determinará la total suspensión de las pruebas eléctricas hasta la eliminación del mismo y verificación de no verse afectos los sistemas de seguridad.
Igualmente caso detectarse restos de manchas y sobre todo oxido conviene investigar el motivo del mismo, ya que puede darse el caso de que se estén utilizado productos de limpieza no adecuado para esos equipos.

---

## 9.8 Accesorios y Partes Aplicadas

Deben revisarse tanto físicamente como con las correspondientes pruebas de partes aplicables todos los elementos que entren en contacto con el paciente.

Ejemplos:

- Cables ECG.    
- Sensores SpO₂.    
- Transductores.    
- Manguitos.    
- Sondas.
    

Se verificará:

- Integridad física.    
- Estado de conectores.    
- Presencia de fisuras.    
- Signos de desgaste.    

---

## 9.9 Criterios de Rechazo

Entre las situaciones que justifican la retirada inmediata del equipo destacan:

- Conductores expuestos.    
- Carcasas abiertas.    
- Signos de sobrecalentamiento.    
- Evidencia de líquidos internos.    
- Daños mecánicos graves.    
- Pérdida de partes esenciales de protección.
    

La realización de ensayos eléctricos no debe utilizarse para justificar la continuidad de uso de un equipo visualmente inseguro, es decir podemos encontrarnos equipos que pasen sin problemas los test de seguridad, pero presenten síntomas de potenciales peligro, en cuyo caso siempre ha de priorizarse la seguridad, si se puede subsanar en el momento de la inspección (sustitución de elementos dañados), se hace, sino se ha de poner el equipo fuera de servicio y seguir los procedimientos indicados en los correspondientes protocolos vigentes en el servicio..

---

## 9.10 Conclusiones

La inspección visual constituye la primera barrera de seguridad dentro de cualquier procedimiento de mantenimiento.

Su correcta ejecución permite detectar numerosos defectos antes de que estos puedan evolucionar hacia situaciones de riesgo para pacientes u operadores.

Es vital ante la detección de potenciales síntomas de deterioro o pérdida de aislamientos, la revisión profunda y reparación si procede el equipo antes de continuar con las pruebas eléctricas.

---

# 10. Continuidad de Tierra

## 10.1 Introducción

La continuidad de tierra es uno de los ensayos fundamentales aplicables a equipos Clase I.

Su objetivo consiste en verificar que todas las partes metálicas accesibles conectadas al sistema de protección mantienen un camino eléctrico de baja impedancia hasta el conductor de tierra de la instalación, en esto es vital la inspección visual tratada en el punto anterior, ya que esta permite la detección de posibles fallos de 'contacto' entre las distintas partes metálicas, por ejemplo la tapa o carcasa superior con la inferior.

La eficacia de este sistema resulta esencial para limitar las tensiones de contacto en caso de fallo del aislamiento.

---

## 10.2 Principio de Funcionamiento

En un equipo Clase I, la carcasa y demás elementos metálicos accesibles están conectados al conductor de protección (PE).

Si se produce un defecto interno que energiza accidentalmente una parte metálica, la corriente de fallo debe circular preferentemente por dicho conductor.

Para que esto ocurra, la resistencia del circuito de tierra debe mantenerse dentro de límites adecuados.

---

## 10.3 Objetivo del Ensayo

La medición permite verificar:

- Integridad del conductor de protección.    
- Calidad de las conexiones internas.    
- Ausencia de corrosión.    
- Ausencia de uniones defectuosas.    
- Correcta continuidad entre chasis y tierra.    

No pretende evaluar el estado del aislamiento.

---

## 10.4 Procedimiento General

El procedimiento habitual consiste en:

1. Conectar el analizador al equipo.    
2. Seleccionar la prueba de continuidad de tierra.    
3. Aplicar la corriente de ensayo.    
4. Medir la resistencia entre el pin de tierra y las partes metálicas accesibles.    

La corriente de prueba utilizada dependerá del procedimiento y del equipo de medida empleado.

---

## 10.5 Fundamento Físico

El ensayo se basa en la aplicación de una corriente conocida y la medición de la caída de tensión resultante.

A partir de estos valores se calcula la resistencia eléctrica del circuito de protección.

Una resistencia elevada indica la existencia de una conexión deficiente o deteriorada.

---

## 10.6 Factores que Influyen en la Medición

Entre los factores que pueden afectar al resultado se encuentran:

- Longitud del cable.    
- Estado de conectores.    
- Corrosión.    
- Oxidación.    
- Tornillos flojos.    
- Pinturas o tratamientos superficiales.
    
Por este motivo es importante seleccionar adecuadamente el punto de medición.

---

## 10.7 Límites Habituales

Los límites exactos deben obtenerse de la normativa aplicable y del procedimiento interno utilizado.

De forma general:

|Configuración|Valor típico|
|---|---|
|Cable desmontable|≤ 0,3 Ω|
|Cable fijo|≤ 0,1 Ω|

Estos valores pueden variar en función de la normativa utilizada y de las características constructivas del equipo.

---

## 10.8 Interpretación de Resultados

Una resistencia baja indica que la corriente de defecto dispondrá de un camino adecuado hacia tierra.

Sin embargo, un resultado correcto no garantiza por sí solo la seguridad del equipo.

El ensayo debe interpretarse conjuntamente con:

- Inspección visual.    
- Resistencia de aislamiento.    
- Corrientes de fuga.    

---

## 10.9 Defectos Habituales

Entre los defectos encontrados con mayor frecuencia destacan:

- Rotura parcial del conductor PE.    
- Tornillos flojos.    
- Oxidación de terminales.    
- Sustitución incorrecta del cable de alimentación.    
- Modificaciones no autorizadas.
    
Estos defectos pueden incrementar significativamente la resistencia medida.

---

## 10.10 Particularidades en Equipos Médicos

Muchos equipos modernos incorporan:

- Chasis pintados.    
- Componentes modulares.    
- Conectores rápidos.    
- Elementos móviles.    

Estas características pueden dificultar la selección del punto de ensayo y deben tenerse en cuenta durante la medición.

---

## 10.11 Errores Frecuentes

Algunos errores habituales son:

- Medir sobre superficies pintadas.    
- Utilizar puntos sin continuidad real con el chasis.    
- Interpretar incorrectamente valores próximos al límite.    
- No verificar accesorios desmontables.
    

---

## 10.12 Conclusiones

La continuidad de tierra constituye una de las verificaciones esenciales en equipos Clase I.

Su objetivo es garantizar que cualquier corriente de defecto pueda circular de forma segura hacia tierra, reduciendo el riesgo de tensiones peligrosas sobre las partes accesibles del equipo.

No obstante, debe considerarse únicamente una parte del conjunto de ensayos necesarios para evaluar la seguridad eléctrica global.

---

# 11. Resistencia de Aislamiento

## 11.1 Introducción

La resistencia de aislamiento constituye uno de los principales indicadores del estado eléctrico de un equipo electromédico.

Su objetivo es verificar la capacidad de los materiales aislantes para impedir el paso de corriente entre partes activas y elementos accesibles.

La degradación del aislamiento puede provocar:

- Incremento de corrientes de fuga.
    
- Tensiones de contacto peligrosas.
    
- Disparos intempestivos de protecciones.
    
- Riesgo para pacientes y operadores.
    

Por este motivo, la evaluación periódica del aislamiento forma parte de los ensayos fundamentales contemplados por la IEC 62353.

---

## 11.2 Concepto de Aislamiento Eléctrico

Todo equipo electromédico incorpora materiales destinados a separar eléctricamente los conductores activos de las partes accesibles.

Estos materiales incluyen:

- Aislantes plásticos.
    
- Barnices dieléctricos.
    
- Recubrimientos de cables.
    
- Transformadores.
    
- Placas aislantes.
    

Aunque idealmente el aislamiento debería impedir completamente el paso de corriente, en la práctica siempre existe una pequeña corriente residual.

La finalidad del ensayo consiste en comprobar que dicha corriente permanece dentro de límites seguros.

---

## 11.3 Mecanismos de Degradación

La capacidad aislante de los materiales disminuye progresivamente con el tiempo.

Las causas más habituales son:

- Envejecimiento natural.
    
- Humedad.
    
- Contaminación.
    
- Entrada de líquidos.
    
- Temperatura.
    
- Vibraciones.
    
- Daños mecánicos.
    

En equipos sometidos a limpiezas frecuentes, la degradación puede acelerarse debido a la acción química de determinados productos.

---

## 11.4 Principio de Medición

La resistencia de aislamiento se determina aplicando una tensión continua conocida entre distintos puntos del equipo y midiendo la corriente resultante.

Una resistencia elevada indica que el aislamiento mantiene sus propiedades.

Por el contrario, una resistencia reducida puede indicar:

- Humedad.
    
- Contaminación.
    
- Deterioro del aislamiento.
    
- Defectos internos.
    

---

## 11.5 Uso de Tensión Continua

Habitualmente se emplea tensión continua para evitar la influencia de fenómenos capacitivos presentes en los filtros de red y circuitos electrónicos.

La utilización de corriente continua permite evaluar principalmente la resistencia real del aislamiento.

En la mayoría de procedimientos IEC 62353 se utilizan tensiones de ensayo de:

- 250 VCC.
    
- 500 VCC.
    

La selección dependerá del procedimiento aplicado y de las características del equipo.

---

## 11.6 Situaciones Especiales

Algunos equipos modernos incorporan:

- Filtros EMI complejos.
    
- Protectores contra sobretensiones.
    
- Electrónica sensible.
    
- Componentes semiconductores específicos.
    

En determinadas circunstancias, el fabricante puede recomendar procedimientos alternativos o tensiones de ensayo reducidas.

Siempre que exista conflicto entre el procedimiento general y las instrucciones del fabricante, deberá evaluarse la situación específica antes de continuar con el ensayo.

---

## 11.7 Interpretación de Resultados

Un valor elevado de resistencia de aislamiento suele indicar un buen estado de las barreras dieléctricas.

Sin embargo, el valor absoluto no siempre proporciona toda la información necesaria.

La comparación con resultados históricos puede revelar tendencias de degradación progresiva incluso cuando el equipo continúa cumpliendo los límites normativos.

Por este motivo resulta recomendable registrar siempre los valores numéricos obtenidos.

---

## 11.8 Defectos Habituales Detectados

Entre los problemas más frecuentes identificados mediante este ensayo se encuentran:

- Humedad interna.
    
- Entrada de líquidos.
    
- Cables deteriorados.
    
- Acumulación de suciedad conductiva.
    
- Componentes envejecidos.
    

En determinados casos, estos defectos pueden no ser visibles durante la inspección visual.

---

## 11.9 Limitaciones del Ensayo

La resistencia de aislamiento constituye una herramienta muy útil, pero no permite detectar todos los posibles defectos.

Un equipo puede presentar:

- Corrientes de fuga elevadas.
    
- Problemas funcionales.
    
- Defectos intermitentes.
    

sin que necesariamente aparezcan anomalías significativas en este ensayo.

Por ello debe interpretarse siempre junto al resto de verificaciones.

---

## 11.10 Conclusiones

La resistencia de aislamiento proporciona una evaluación directa del estado de las barreras dieléctricas presentes en un equipo electromédico.

Su correcta interpretación permite detectar procesos de degradación antes de que evolucionen hacia situaciones de riesgo para pacientes y operadores.
---

# 12. Corrientes de Fuga

## 12.1 Introducción

Las corrientes de fuga constituyen uno de los parámetros más importantes dentro de la seguridad eléctrica aplicada a equipos electromédicos.

Su control es fundamental para garantizar que las corrientes no deseadas permanezcan dentro de niveles compatibles con la seguridad del paciente y del operador.

La medición de corrientes de fuga representa uno de los pilares fundamentales de la IEC 62353.

---

## 12.2 ¿Qué es una Corriente de Fuga?

Se denomina corriente de fuga a toda corriente que circula fuera del recorrido previsto para el funcionamiento normal del equipo.

Su existencia no implica necesariamente un defecto.

Incluso equipos completamente conformes generan corrientes de fuga debido a:

- Capacitancias parásitas.
    
- Filtros de red.
    
- Condensadores de supresión EMI.
    
- Acoplamientos internos.
    

La finalidad de los ensayos consiste en verificar que dichas corrientes permanecen dentro de los límites establecidos.

---

## 12.3 Origen de las Corrientes de Fuga

Las causas más habituales son:

- Diseño del equipo.
    
- Filtros EMI.
    
- Envejecimiento de componentes.
    
- Humedad.
    
- Deterioro del aislamiento.
    
- Contaminación.
    

En equipos modernos, una parte significativa de las corrientes de fuga procede de los propios sistemas de compatibilidad electromagnética.

---

## 12.4 Corriente de Fuga del Equipo

La corriente de fuga del equipo representa la corriente que puede circular desde las partes accesibles hacia tierra.

Este parámetro permite evaluar el comportamiento global del sistema de alimentación y de sus barreras de aislamiento.

Valores anormalmente elevados pueden indicar:

- Deterioro del aislamiento.
    
- Problemas en filtros.
    
- Humedad.
    
- Defectos internos.
    

---

## 12.5 Corriente de Fuga de Partes Aplicadas

Corresponde a la corriente que podría alcanzar al paciente a través de elementos destinados al contacto clínico.

Ejemplos:

- Electrodos ECG.
    
- Sensores.
    
- Transductores.
    
- Sondas.
    

Debido a la proximidad al paciente, los límites permitidos son considerablemente más restrictivos.

---

## 12.6 Corriente de Contacto

La corriente de contacto evalúa la corriente que podría circular a través de una persona que toque una parte accesible del equipo.

Este ensayo resulta especialmente relevante en equipos que incorporan superficies metálicas accesibles.

---

## 12.7 Relación con la Clasificación BF y CF

La clasificación de las partes aplicadas determina los límites máximos admisibles.

A medida que aumenta el riesgo clínico asociado al equipo, más restrictivos se vuelven los límites permitidos.

Por este motivo:

- Los equipos BF presentan requisitos más exigentes que los Tipo B.
    
- Los equipos CF presentan los límites más restrictivos de todos.
    

---

## 12.8 Influencia de los Filtros EMI

Uno de los errores más frecuentes consiste en interpretar toda corriente de fuga como un defecto.

Los filtros EMI incorporan condensadores diseñados específicamente para derivar perturbaciones eléctricas hacia tierra.

Como consecuencia, incluso equipos en perfecto estado pueden presentar corrientes de fuga perfectamente normales.

El técnico debe ser capaz de diferenciar entre:

- Corrientes de fuga inherentes al diseño.
    
- Corrientes de fuga asociadas a un deterioro real.
    

---

## 12.9 Importancia del Historial

Un resultado aislado ofrece información limitada.

La verdadera utilidad de las mediciones aparece cuando pueden compararse con registros anteriores.

Un equipo puede continuar dentro de los límites normativos y, sin embargo, mostrar una evolución progresiva que aconseje una intervención preventiva.

La tendencia suele ser tan importante como el valor absoluto.

---

## 12.10 Interpretación Técnica

La evaluación de corrientes de fuga debe considerar simultáneamente:

- Clasificación del equipo.
    
- Clasificación de partes aplicadas.
    
- Entorno clínico.
    
- Historial de resultados.
    
- Estado general del equipo.
    

La interpretación nunca debe limitarse a comprobar si un valor está por encima o por debajo de un límite determinado.

---

## 12.11 Errores Frecuentes

Entre los errores más habituales destacan:

- Desconocer la clasificación BF o CF.
    
- Ignorar la influencia de los filtros EMI.
    
- Comparar resultados obtenidos mediante métodos diferentes.
    
- Interpretar valores aislados sin considerar el histórico.
    
- Confundir corrientes de fuga normales con defectos reales.
    

---

## 12.12 Conclusiones

Las corrientes de fuga constituyen uno de los indicadores más sensibles del estado de seguridad eléctrica de un equipo electromédico.

Su correcta medición e interpretación permiten detectar anomalías potencialmente peligrosas y garantizar que los niveles de protección previstos por el fabricante continúan siendo efectivos durante toda la vida útil del equipo.

---

# 13. Métodos de Medición IEC 62353

## 13.1 Introducción

La norma IEC 62353 contempla distintos métodos para la medición de corrientes de fuga y otros parámetros de seguridad eléctrica.

La existencia de varios procedimientos responde a la necesidad de adaptarse a diferentes situaciones de trabajo, tipos de equipos y limitaciones operativas.

Aunque el objetivo final de todos ellos es evaluar la seguridad eléctrica del equipo, los principios de funcionamiento, las condiciones de ensayo y la precisión de los resultados pueden variar significativamente.

La correcta selección e interpretación del método empleado constituye una parte fundamental de la labor del técnico de electromedicina.

---

## 13.2 Método Directo

El método directo se considera el procedimiento de referencia dentro de la IEC 62353.

Durante el ensayo, el equipo bajo prueba se alimenta a través del propio analizador de seguridad eléctrica, que incorpora internamente los circuitos de medida necesarios para cuantificar las corrientes de fuga.

De esta forma, toda la energía suministrada al equipo circula a través del analizador.

### Características principales

- El equipo recibe alimentación desde el analizador.
    
- La corriente de fuga se mide directamente.
    
- No requiere cálculos indirectos.
    
- Proporciona la mayor precisión de medida.
    

### Ventajas

- Elevada precisión.
    
- Menor influencia de factores externos.
    
- Método de referencia de la norma.
    
- Resultados fácilmente comparables.
    

### Inconvenientes

- Algunos equipos no funcionan correctamente alimentados desde el analizador.
    
- Puede resultar incompatible con determinados sistemas electrónicos modernos.
    
- No siempre es viable en equipos de gran potencia.
    

### Aplicaciones recomendadas

- Verificaciones periódicas.
    
- Equipos de complejidad moderada.
    
- Ensayos donde se requiera máxima precisión.
    

---

## 13.3 Método Diferencial

El método diferencial mide la diferencia entre las corrientes que circulan por los conductores activos de alimentación.

En condiciones normales, la suma vectorial de las corrientes debería ser prácticamente nula.

Cualquier diferencia indica la existencia de corriente que abandona el circuito previsto, generalmente en forma de corriente de fuga.

A diferencia del método directo, el equipo permanece conectado a la red eléctrica habitual.

### Características principales

- El equipo se alimenta desde su instalación normal.
    
- No requiere modificar el entorno de trabajo.
    
- Permite ensayar equipos complejos en condiciones reales.
    

### Ventajas

- Muy versátil.
    
- Adecuado para equipos electrónicos modernos.
    
- Permite ensayos en condiciones de funcionamiento reales.
    
- Especialmente útil en equipos de gran potencia.
    

### Inconvenientes

- Mayor sensibilidad a perturbaciones externas.
    
- Puede verse afectado por otros equipos conectados.
    
- Requiere interpretar correctamente el contexto de medida.
    

### Aplicaciones recomendadas

- Equipos con filtros EMI complejos.
    
- Sistemas informáticos médicos.
    
- Equipos de imagen.
    
- Equipos cuyo funcionamiento se altera con el método directo.
    

---

## 13.4 Método Alternativo

El método alternativo fue desarrollado para situaciones en las que no resulta posible realizar una medida directa de corrientes de fuga.

En este procedimiento, el analizador aplica una tensión de ensayo y evalúa el estado del aislamiento mediante cálculos indirectos.

No se trata de una medida real de corriente de fuga durante funcionamiento normal, sino de una estimación obtenida a partir de las características eléctricas del equipo.

### Características principales

- El equipo puede permanecer apagado.
    
- No requiere funcionamiento completo.
    
- Evalúa el aislamiento de forma indirecta.
    

### Ventajas

- Rapidez.
    
- Aplicable a equipos que no pueden energizarse.
    
- Útil en determinadas verificaciones preliminares.
    

### Inconvenientes

- Menor representatividad respecto al funcionamiento real.
    
- No sustituye completamente a una medida funcional de fuga.
    
- Puede no detectar determinados defectos dependientes del funcionamiento.
    

### Aplicaciones recomendadas

- Equipos averiados.
    
- Comprobaciones preliminares.
    
- Situaciones donde otros métodos no sean posibles.
    

---

## 13.5 Selección del Método Adecuado

La elección del método debe realizarse considerando:

- Tipo de equipo.
    
- Tecnología utilizada.
    
- Condiciones de ensayo.
    
- Recomendaciones del fabricante.
    
- Disponibilidad del equipo para funcionar durante la prueba.
    

Como criterio general:

|Situación|Método recomendado|
|---|---|
|Verificación estándar|Directo|
|Equipos complejos o sensibles|Diferencial|
|Equipo no operativo|Alternativo|

No existe un método universalmente válido para todas las situaciones.

La capacidad del técnico para seleccionar correctamente el procedimiento constituye una parte esencial de la evaluación.

---

## 13.6 Comparación Práctica

Desde un punto de vista operativo, los tres métodos pueden considerarse complementarios.

El método directo proporciona la referencia más precisa.

El método diferencial ofrece una excelente aproximación en condiciones reales de funcionamiento.

El método alternativo permite obtener información útil cuando los anteriores no pueden aplicarse.

La elección no debe basarse únicamente en la comodidad del procedimiento, sino en su adecuación a las características del equipo evaluado.

---

## 13.7 Errores Frecuentes

Entre los errores más habituales destacan:

- Comparar resultados obtenidos mediante métodos diferentes.
    
- Aplicar siempre el mismo método independientemente del equipo.
    
- Interpretar el método alternativo como equivalente al directo.
    
- Ignorar las recomendaciones del fabricante.
    
- No documentar el método utilizado en el informe técnico.
    

La trazabilidad del procedimiento empleado resulta tan importante como el propio valor medido.

---

## 13.8 Aplicación Práctica para el Técnico de Electromedicina

En la práctica hospitalaria actual, el método diferencial ha ganado protagonismo debido a la creciente complejidad electrónica de los equipos médicos.

Muchos equipos modernos incorporan:

- Fuentes de alimentación conmutadas.
    
- Sistemas informáticos.
    
- Filtros EMI avanzados.
    
- Electrónica digital sensible.
    

Estas características hacen que, en determinadas situaciones, el método diferencial proporcione resultados más representativos del comportamiento real del equipo.

No obstante, el técnico debe conocer y comprender los tres procedimientos para seleccionar en cada caso el más adecuado.

---

## 13.9 Conclusiones

La IEC 62353 contempla distintos métodos de medición con el objetivo de adaptarse a las características de los equipos electromédicos modernos.

La correcta comprensión de sus principios, limitaciones y aplicaciones permite obtener resultados fiables y realizar una evaluación técnica más rigurosa de la seguridad eléctrica.

La selección adecuada del método de ensayo constituye una parte esencial del proceso de verificación y debe formar parte del criterio profesional del técnico responsable.

# Revisar a partir de aquí para completar lo anterior

## Inspección Visual y Resistencia de Tierra

Antes de realizar cualquier ensayo eléctrico, se lleva a cabo una inspección visual para detectar daños, desgastes en el equipo o en sus cables o cualquier deterioro que pueda afectar la integridad del dispositivo. Con una inspección detallada, se garantiza que el equipo cumple con los estándares de calidad y seguridad necesarios.

Posteriormente, se evalúa la Prueba de Resistencia de Tierra de Protección, la cual es fundamental para asegurar que el sistema de puesta a tierra funcione de manera óptima. Durante esta prueba se conecta un analizador de seguridad eléctrica al equipo médico para inyectar una corriente de prueba de 200 mA en la conexión a tierra. Se mide la caída de tensión generada en el trayecto y, aplicando la Ley de Ohm, se calcula la resistencia de tierra. Este proceso se efectúa en condiciones controladas para no afectar el funcionamiento del equipo.

En equipos con cable de alimentación desmontable (de hasta 3 metros), **IEC 62353** establece un límite máximo de 100 mΩ. Para dispositivos de Clase I que incluyen cable de alimentación de hasta 3 metros, el límite es de 300 mΩ.

![Resistencia de Tierra de Protección de equipos con cable de alimentación desmontables.](https://biomedex.mx/wp-content/uploads/2025/02/image-300x196.png)

Imagen 1. Prueba de Resistencia de Tierra de Protección de equipos con cable de alimentación desmontables.

Si la resistencia medida es igual o inferior, el equipo cumple con el límite máximo permitido para equipos según **IEC 62353**. Por otra parte, si el valor supera los límites, se debe revisar la integridad de la conexión a tierra y realizar las acciones correctivas necesarias, ya que un valor mayor podría comprometer la seguridad eléctrica del equipo.

## Pruebas de Corriente de Fuga

La medición de la corriente de fuga es fundamental para comprobar que las corrientes no funcionales se mantengan dentro de límites seguros, minimizando el riesgo para pacientes y operadores. La norma distingue dos tipos de pruebas de corriente de fuga:

### Corriente de Fuga del Equipo

**La Prueba de la Corriente de Fuga del Equipo** verifica la fuga total que se origina desde la fuente de alimentación hacia la carcasa y otros componentes accesibles del equipo, evaluando la protección del dispositivo.

De los tres métodos que establece la norma, el método directo es el más empleado por su facilidad de aplicación y precisión. En este método, se conecta el analizador de seguridad eléctrica de forma que se mida de forma directa el valor RMS de la corriente que se devía del camino normal. Es necesaria la interrupción temporal de la conexión a tierra del equipo y se inyecta una corriente de prueba. Se utiliza la Ley de Ohm para calcular la corriente de fuga a partir de la caída de tensión y una resistencia de 1kΩ (ya integrada en el analizador).

![Corriente de fuga del equipo por Método Directo](https://biomedex.mx/wp-content/uploads/2025/02/image-2-1024x307.png)

Imagen 2. Prueba de la Corriente de fuga del equipo por Método Directo

La prueba se realiza en ambas polaridades de la alimentación, garantizando una medición precisa y reproducible. Los límites máximos son:

- Para equipos de **Clase I**, el límite máximo de corriente de fuga es de **500 µA**.
- Para equipos de **Clase II**, el límite máximo permitido es de **100 µA**.

Superar estos límites puede indicar un deterioro en el aislamiento o en la conexión a tierra, lo que requiere acciones correctivas inmediatas.

### Corriente de Fuga de Partes Aplicadas

**La Prueba de Fuga de Partes Aplicadas** se centra en evaluar la seguridad de las partes del equipo que tienen contacto directo con el paciente (aplicadas), asegurando que la corriente de fuga en estas zonas se mantenga en niveles seguros.

Al igual que en la prueba de corriente de fuga del equipo, se utiliza el método directo para las partes aplicadas. En este caso, el medidor se conecta directamente a las partes aplicadas que, durante la prueba, se dejan flotantes (sin conexión a tierra). Esto permite simular las peores condiciones de aislamiento, midiendo directamente la corriente de fuga que podría circular hacia el paciente. La medición se realiza en condiciones de prueba controladas, inyectando una corriente de prueba y midiendo la caída de tensión para calcular la corriente a través de la Ley de Ohm utilizando el mismo valor de resistencia de 1 kΩ.

![Corriente de fuga de parte aplicada por Método Directo](https://biomedex.mx/wp-content/uploads/2025/02/image-3-1024x288.png)

Imagen 3. Prueba de Corriente de fuga de parte aplicada por Método Directo

Los límites máximos de esta prueba son:

- Para equipos de **Clase I** y II con partes aplicadas de Tipo BF, el límite máximo permitido es de **5000 µA**
- Para equipos de **Clase I** y II con partes aplicadas de Tipo CF, el límite máximo permitido es de **50 µA**.

Estos límites aseguran que la exposición del paciente a corrientes de fuga sea mínima, garantizando un alto nivel de seguridad.



stoy de acuerdo. De todos los capítulos que llevamos, el **13 es probablemente el más importante para un técnico de campo**, porque es donde se pasa de "sé medir" a "sé qué estoy midiendo y por qué".

Y además ahora mismo está demasiado descriptivo. Explica los métodos, pero no los hace "visuales".

Yo ampliaría bastante:

### 13.2 Método Directo

Añadiría un esquema simple:

```
RED │ │ ▼ANALIZADOR │ │ ▼EQUIPO BAJO PRUEBALa fuga es medida directamente por el analizador.
```

Y una explicación práctica:

> El analizador se convierte temporalmente en la fuente de alimentación del equipo. Toda la corriente consumida por el equipo pasa a través de los circuitos internos de medida del analizador.

También incluiría:

- Qué ocurre con fuentes conmutadas modernas.
- Por qué algunos equipos se niegan a arrancar.
- Equipos que dan resultados inconsistentes.

---

### 13.3 Método Diferencial

Aquí sí metería un dibujo más elaborado:

```
        ┌─────────────┐L ─────▶│             │─────▶ Equipo        │ Sensor ΔI   │N ─────▶│             │─────▶        └─────────────┘Si la corriente que entraes distinta de la que sale,la diferencia es una fuga.
```

Y una analogía muy sencilla:

> Es exactamente el mismo principio utilizado por un interruptor diferencial de una instalación eléctrica.

Eso cualquier técnico lo entiende inmediatamente.

Además explicaría:

```
Corriente que entra = 1,000 ACorriente que sale = 0,998 AFuga = 0,002 A     = 2 mA
```

Visualmente queda muy claro.

---

### 13.4 Método Alternativo

Aquí suele haber bastante confusión.

Yo reforzaría algo así:

> El método alternativo NO mide una corriente de fuga real durante el funcionamiento del equipo.

Porque es un error muy frecuente.

Incluso pondría un cuadro:

|Método|Mide fuga real|
|---|---|
|Directo|Sí|
|Diferencial|Sí|
|Alternativo|No|

Eso ayuda muchísimo.

---

### 13.5 Selección del método adecuado

Aquí haría un árbol de decisión:

```
¿El equipo funciona?│├─ NO│   └─ Método alternativo│└─ SÍ    │    ├─ Funciona correctamente    │   alimentado por analizador?    │    ├─ SÍ    │   └─ Método directo    │    └─ NO        └─ Método diferencial
```

Muy sencillo.

---

### Imágenes que buscaría

No buscaría imágenes complejas.

Buscaría:

1. Esquema de método directo.
2. Esquema de método diferencial.
3. Esquema de método alternativo.
4. Imagen de un diferencial doméstico (para explicar el principio).
5. Capturas reales de Rigel y Fluke mostrando los tres métodos.

Estas últimas, sinceramente, valen más que cualquier dibujo.

---

Además, una cosa que me gustaría añadir en este capítulo cuando lo revisemos en profundidad:

### 13.X Limitaciones de cada método

Porque en la práctica la pregunta no es:

> ¿Cuál es mejor?

Sino:

> ¿Cuál me está diciendo la verdad en esta situación concreta?

Y ahí entran:

- Fuentes conmutadas.
- Filtros EMI.
- Equipos informáticos.
- Monitores.
- Ecógrafos.
- Torres de endoscopia.

Ese apartado puede acabar siendo uno de los más útiles de todo el manual para un técnico de electromedicina. 🔧⚡📟📚

Y sí, voy buscando esquemas simples y didácticos para estos tres métodos porque aquí una imagen bien hecha ahorra dos páginas de explicación.
He encontrado material bastante útil, pero te diría que **no uses imágenes complejas sacadas de la norma**. Para el manual van a funcionar mucho mejor esquemas propios, sencillos y limpios.

Lo más interesante que he encontrado es:

- La guía práctica de Rigel incluye esquemas de los métodos directo, diferencial y alternativo.
- Fluke tiene una explicación bastante clara de cuándo usar cada método.
- Un artículo de 24x7 explica muy bien ventajas e inconvenientes del método diferencial y alternativo.

---

### Mi recomendación

No copiar ninguna figura.

Crear 4 figuras propias para el manual.

---

## Figura 13-1 Método Directo

```
      RED       │       ▼┌─────────────┐│ ANALIZADOR  │└──────┬──────┘       │       ▼┌─────────────┐│  EQUIPO     │└─────────────┘La corriente de fuga es medidadirectamente por el analizador.
```

Pie:

> En el método directo el equipo es alimentado a través del analizador, permitiendo medir directamente la corriente de fuga mediante el circuito de medida interno.

---

## Figura 13-2 Método Diferencial

```
          Corriente entradaL ───────────────────────►          Corriente salidaN ◄───────────────────────      SENSOR DIFERENCIALEntrada - Salida = Fuga
```

Pie:

> El método diferencial mide el desequilibrio entre la corriente que entra y la que sale del equipo.

Aquí añadiría una nota:

> El principio de funcionamiento es análogo al utilizado por los interruptores diferenciales de las instalaciones eléctricas.

---

## Figura 13-3 Método Alternativo

```
      ANALIZADOR      250 V CA          │          ▼ ┌────────────────┐ │    EQUIPO      │ └────────────────┘Evaluación indirectadel aislamiento
```

Pie:

> El método alternativo no mide una corriente de fuga real durante el funcionamiento normal del equipo, sino que estima el estado del aislamiento aplicando una tensión de ensayo limitada.

---

## Figura 13-4 Selección del Método

```
¿El equipo funciona?        │   ┌────┴────┐   │         │  NO        SI   │         │Altern.   ¿Funciona           con el         analizador?           │      ┌────┴────┐      │         │     SI        NO      │         │ Directo   Diferencial
```

Esta figura sola probablemente evita media página de explicaciones.

---

### Y una ampliación que sí metería en el texto

Un apartado nuevo:

```
13.X Comparación práctica de resultados
```

Con una tabla:

|Aspecto|Directo|Diferencial|Alternativo|
|---|---|---|---|
|Mide fuga real|Sí|Sí|No|
|Precisión|Alta|Media-Alta|Media|
|Equipo alimentado normalmente|No|Sí|No|
|Influencia EMI|Baja|Media|Baja|
|Equipos informáticos|Puede dar problemas|Muy adecuado|Limitado|
|Tendencias históricas|Muy útil|Muy útil|Útil|

Y otro cuadro:

> **Importante:** Los resultados obtenidos mediante distintos métodos no deben compararse directamente entre sí sin tener en cuenta el procedimiento empleado. La trazabilidad del método utilizado forma parte esencial del resultado obtenido.

---

Mi impresión es que este capítulo puede acabar siendo de los más largos del manual porque es donde realmente se aprende a interpretar lo que hace un Fluke o un Rigel cuando pulsas "Start". Y eso tiene muchísimo más valor para un técnico que memorizar un límite de microamperios.



---

# PARTE V - APLICACIÓN PRÁCTICA

## 14. Procedimiento General de Verificación

### 14.1 Preparación

### 14.2 Identificación del equipo

### 14.3 Secuencia de ensayo

### 14.4 Registro de resultados

### 14.5 Cierre de la intervención

---

## 15. Interpretación Técnica de Resultados

### 15.1 Equipos conformes

### 15.2 Equipos no conformes

### 15.3 Resultados dudosos

### 15.4 Tendencias de degradación

### 15.5 Importancia del histórico

---

## 16. Casos Reales de Campo

### Caso 1 - Fuga elevada por humedad

### Caso 2 - Tierra defectuosa

### Caso 3 - Daño por líquidos

### Caso 4 - Error de medición

### Caso 5 - Falso positivo por periféricos

---

## 17. Documentación y Trazabilidad

### 17.1 Requisitos documentales

### 17.2 Informes técnicos

### 17.3 Registros históricos

### 17.4 Auditorías

---

# ANEXOS

## Anexo A - Tablas IEC 62353

## Anexo B - Valores límite habituales

## Anexo C - Glosario técnico

## Anexo D - Equipos de medida

### Rigel

### Fluke

### Gossen Metrawatt

## Anexo E - Bibliografía