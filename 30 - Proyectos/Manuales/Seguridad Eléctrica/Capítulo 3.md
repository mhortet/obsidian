---
tags:
  - manuales
  - SegElec
Referencias:
  - "[[Capítulo 4]]"
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
