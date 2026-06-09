---
tags:
  - SegElec
  - manuales
Relacionado:
  - "[[Capítulo 2]]"
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
