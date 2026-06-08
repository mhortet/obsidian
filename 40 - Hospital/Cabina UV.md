---
tags:
  - equipos
  - hospital
Creado:
Autor:
Relacionado:
  - "[[Manual Seguridad eléctrica]]"
  - 10 - índice Hospital
---
## Alcance
Análisis del accesorio Z750 para medidas trifásicas con SECUTEST PRO
## Descripción


**Sí, con la referencia Z750A sí puedes realizar la medición completa y activa**, a diferencia del adaptador CEE básico convencional. El componente con referencia **Z750A** corresponde exactamente al adaptador trifásico activo **AT16-DI** de Gossen Metrawatt. [[1](https://www.rapidonline.com/gossen-metrawatt-z750a-test-lead-adapter-three-phase-current-16di-11-9352), [2](https://www.ebay.es/itm/386855253210)]

Este accesorio está diseñado específicamente para trabajar en conjunto con la gama [SECUTEST PRO](https://www.gossenmetrawatt.de/en/products/measuring-and-test-technology/product-archive/test-technology/testing-of-electric-devices/secutest-pro-iq/) y es totalmente apto para la verificación de equipos médicos según la norma **IEC 62353 / VDE 0751**. [[1](https://www.rapidonline.com/gossen-metrawatt-z750a-test-lead-adapter-three-phase-current-16di-11-9352), [2](https://www.gossenmetrawatt.de/en/products/measuring-and-test-technology/product-archive/test-technology/testing-of-electric-devices/secutest-pro-iq/)]

Capacidades del adaptador AT16-DI (Z750A) con tu SECUTEST PRO

Al utilizar este módulo técnico, superas todas las limitaciones del adaptador básico gracias a sus funciones avanzadas:

- **Prueba Diferencial Activa (L1-L2-L3-N):** Te permite alimentar el equipo electromédico trifásico a su tensión nominal para medir la corriente de fuga real mientras se encuentra en funcionamiento operativo.
- **Medición de Corriente de Fuga Equivalente:** Ejecuta evaluaciones precisas de las corrientes de fuga del chasis y hacia tierra requeridas por la legislación médica.
- **Automatización del Proceso:** El flujo de conmutación interna (cambio entre fases L1, L2, L3 y Neutro) está integrado con el sistema operativo de tu [SECUTEST PRO](https://camillebauer.com/en/product/secutest-st-pro/). [[1](https://www.gossenmetrawatt.de/en/products/software-and-accessories/accessories/test-technology/device-testers/adapters/at16-di/), [2](https://camillebauer.com/en/product/secutest-st-pro/)]

Limitaciones importantes a considerar

Aunque el equipo es totalmente compatible, debes vigilar dos restricciones físicas de hardware del modelo **Z750A**:

1. **Límite de Amperaje:** Está limitado exclusivamente a **16 Amperios**. Si el equipo electromédico que vas a inspeccionar consume más energía o posee una clavija industrial CEE de 32 A, este modelo no encajará físicamente y requerirías la variante superior de la marca (el adaptador de la gama AT3 para 32 A).
2. **Método Directo:** Para pruebas de corriente de fuga por método directo en partes aplicadas de pacientes (electrodos), comprueba en la pantalla de configuración del equipo si requiere de derivaciones externas conectadas directamente a los bornes secundarios del SECUTEST. [[1](https://meetwinkel.nl/p/gossen-metrawatt-at3-iiie-meetadapter/), [2](https://www.gossenmetrawatt.de/produkte/software-und-zubehoer/zubehoer/)]

    


# cabina de rayos UVA MEDISUN 2800

Para evaluar la ==cabina de fototerapia dermatológica **MEDISUN 2800 Innovation** con tu **SECUTEST PRO** utilizando el adaptador activo **AT16-DI (Z750A)**==, debes tener en cuenta que estás ante un equipo médico de alta potencia. [[1](https://www.cabinasfototerapia.es/producto/cabina-de-fototerapia-medisun-2800-innovation/)]

Revisando las especificaciones técnicas oficiales de la [MEDISUN 2800](https://www.medisun.de/wp-content/uploads/2021/06/medisun_2800_Innovation_05.2021_EN_MAILVERSAND-3.pdf), sus versiones más equipadas (de 40 a 44 lámparas de 100 W) tienen un consumo de entre **5.0 kW y 5.5 kW**. Esto significa que su alimentación trifásica nativa requiere exactamente **400 V / 3 x 16 A** (\(3\text{PH}+\text{N}+\text{PE}\)). [[1](https://www.medisun.de/wp-content/uploads/2021/06/medisun_2800_Innovation_05.2021_EN_MAILVERSAND-3.pdf), [2](https://www.dermat.be/Repository/MEDISUN_PDF/2800_INNOVATION_2M/Medisun_2800_innovatioN_2M_byDermat.Eng.pdf)]

El adaptador **Z750A es perfecto para este modelo exacto**, ya que encaja justo en el límite máximo de 16 Amperios de la cabina.

Protocolo de ensayo en la MEDISUN 2800 con SECUTEST PRO

Al configurar la prueba en el SECUTEST PRO bajo la norma **IEC 62353**, debes seguir estos pasos específicos para este equipo de fototerapia: [[1](http://www.cabinasfototerapia.es/wp-content/uploads/descargas/MED-1802.pdf)]

1. Prueba de Resistencia de Tierra (PE)

- **Punto crítico:** Las cabinas UV tienen una gran estructura metálica exterior e interior, además de reflectores internos.
- **Acción:** Coloca la sonda de prueba del SECUTEST PRO en diferentes partes del chasis metálico desnudo (tornillos de la estructura trasera, bisagras o zonas sin pintura) mientras el enchufe CEE de la cabina está conectado al adaptador Z750A.
- **Límite:** Debe dar menos de **\(0.2 \, \Omega\)**. [[1](https://www.ecomed.com.au/shop/our-brands/medisun-2800-innovation-pro/), [2](https://www.greenstuffworld.com/es/386-cabinas-de-curado-uv?srsltid=AfmBOoodSaudV62p8d6Vze8rNVXdRKDdH9JrlbrvIfHiYZrcH-F31qIv)]

2. Prueba de Resistencia de Aislamiento

- **Configuración:** El adaptador agrupará L1, L2, L3 y N para inyectar la tensión de prueba frente a PE.
- **Precaución Médica:** La MEDISUN 2800 incorpora un ordenador táctil integrado de 10.4" y sensores redundantes UV de tiempo real. Para proteger la electrónica sensible de la cabina, configura el SECUTEST PRO para aplicar una tensión de aislamiento reducida a **250 V DC** (en lugar de los 500 V DC habituales).
- **Límite:** Debe ser superior a **\(2 \, \text{M}\Omega\)**. [[1](https://www.calameo.com/books/0047163524f057c7a4caa), [2](https://www.dermat.be/Repository/MEDISUN_PDF/2800_INNOVATION_2M/Medisun_2800_innovatioN_2M_byDermat.Eng.pdf)]

3. Prueba de Fuga Activa (Corriente Diferencial)

- **Procedimiento:** Conecta el adaptador Z750A a una toma de pared trifásica de 16 A real. El SECUTEST PRO encenderá internamente la cabina.
- **Durante el test:** Enciende la cabina MEDISUN desde su pantalla táctil. Es indispensable que las lámparas UV se enciendan por un momento durante la medición, ya que los balastros de las 40-44 lámparas y los ventiladores de refrigeración son los componentes que podrían generar fugas bajo tensión.
- **Límite:** La corriente de fuga diferencial no debe superar **\(0.5 \, \text{mA}\)** en condiciones normales. [[1](http://www.cabinasfototerapia.es/wp-content/uploads/descargas/MED-1802.pdf), [2](https://www.dermat.be/Repository/MEDISUN_PDF/2800_INNOVATION_2M/Medisun_2800_innovatioN_2M_byDermat.Eng.pdf), [3](https://www.ecomed.com.au/shop/our-brands/medisun-2800-innovation-pro/)]

Exención de Partes Aplicadas

La MEDISUN 2800 es un equipo de radiación electromagnética donde el paciente se sitúa de pie en el centro. Cuenta con barandillas de sujeción, pero **no dispone de partes aplicadas eléctricas** (como electrodos de ECG o sensores en contacto directo con el paciente que inyecten o midan señales eléctricas). Por lo tanto, en el menú del SECUTEST PRO, debes configurar el equipo como **Clase I sin partes aplicadas (Tipo B/BF/CF)**. No requerirás conectar cables secundarios a bornes de paciente. [[1](http://www.cabinasfototerapia.es/wp-content/uploads/descargas/MED-1802.pdf), [2](https://www.ecomed.com.au/shop/our-brands/medisun-2800-innovation-pro/)]

