---
tags:
  - Error
  - hospital
  - radiologia
Creado: 2026-07-07
Autor:
  - M.Hortet
Relacionado:
---
## Resumen
No permite su apagado, la pantalla principal mantiene la retroiluminación encendida, pero no presenta nada
## Descripción

El problema que describes en el equipo de rayos X portátil **Shimadzu** (pantalla con retroiluminación encendida pero sin imagen y bloqueo de apagado) sugiere un **fallo crítico del sistema operativo embebido** o un **bloqueo del procesador principal**. Esto ocurre comúnmente cuando el software de control se congela durante la inicialización o después de un error de comunicación con el detector.
## Procedimiento de Reinicio Forzado

Dado que el tactil y los botones de software no responden, es necesario realizar un reinicio físico ("Hard Reset"):

1. **Apagado de Emergencia**: Localiza el interruptor principal de encendido/apagado. En la mayoría de los modelos **MobileDaRt** y **MobileArt**, este es un interruptor de llave o un botón rojo grande situado en la columna lateral o en la parte trasera del panel de control. Mantén presionado el botón de encendido físico durante **10 a 15 segundos** hasta que la retroiluminación se apague por completo. Si hay un interruptor de llave, gíralo a la posición "OFF" y retírala.
    
2. **Descarga de Energía**: Una vez apagado, desconecta el cable de alimentación de la red eléctrica (si está conectado a la base de carga) y espera al menos **60 segundos**. Esto permite que los condensadores internos se descarguen y se limpie la memoria volátil (RAM) donde puede estar alojado el error.
    
3. **Reinicio**: Vuelve a conectar la energía y enciende el equipo. El sistema debería iniciar el proceso de arranque (boot) desde cero. Observa si aparece el logotipo de **Shimadzu** y la barra de carga.

No se puede realizar ningún de los procedimientos indicados al no localizar ningún tipo de botón para su apagado.

Se procede a desmontar el lateral del equipo para acceder a las baterías del mismo y desconectarlas para forzar su apagado.

Un vez desconectada, se apaga todo el equipo y al conectar de nuevo las baterías, queda el equipo funcionando correctamente, permite su encendido y apagado normal.

# Datos Equipo

Los equipos de **rayos X portátiles Shimadzu** son sistemas móviles de radiografía digital diseñados para ofrecer alta calidad de imagen, maniobrabilidad ergonómica y dosis reducidas para el paciente.  Destacan por su tecnología de **Radiología Digital Directa (DR)** con detectores de panel plano (FPD) inalámbricos, permitiendo la verificación de imágenes en tan solo dos segundos.

## Modelos Principales

El modelo más representativo y avanzado en la gama portátil actual es el **MobileDaRt Evolution MX8**.  Este sistema integra un generador de rayos X de inversor y un brazo telescópico diseñado para exámenes fuera del departamento principal de radiología. 

Sus características distintivas incluyen una columna plegable que ofrece un campo de visión amplio y sin obstáculos durante el traslado, ideal para rondas hospitalarias diarias. El sistema cuenta con una pantalla táctil de 19 pulgadas para visualización inmediata y herramientas de gestión de radiación que muestran el producto de área de dosis (DAP) antes y después de la exposición. La ergonomía es prioritaria, con un diseño de bajo perfil que permite al operador una posición de conducción natural y botones "All-Free" para liberar bloqueos electromagnéticos y posicionar el equipo desde cualquier ángulo. 

Otro modelo relevante es el **MobileArt Eco**, conocido por su diseño compacto y ligero, totalmente equilibrado para una fácil maniobrabilidad en espacios reducidos, manteniendo la capacidad de producir imágenes de alta calidad. También existe el modelo **MUX-10**, un sistema móvil compuesto por un generador de rayos X de inversor y brazo telescópico, enfocado en la facilidad de posicionamiento y funciones de autodiagnóstico.
## Características Técnicas y Operativas

Estos equipos utilizan detectores inalámbricos ultraligeros (generalmente de 35×43 cm), compatibles con chasis ISO 4090, lo que facilita su uso en cualquier Bucky sin modificaciones. La alta sensibilidad de los paneles FPD inalámbricos permite obtener imágenes diagnósticas excelentes con menores dosis de radiación, siendo una solución óptima incluso para atención pediátrica. 

El software de control está optimizado para un flujo de trabajo ágil, reduciendo los pasos necesarios para la adquisición de múltiples estudios. Incluyen indicadores de estado LED con códigos de color en el brazo telescópico para que el operador conozca las condiciones del equipo de un vistazo. La seguridad se ve reforzada mediante compartimentos de almacenamiento para el detector con funciones de bloqueo antirrobo y acceso al sistema mediante contraseña en lugar de llaves físicas. 

Algunas versiones, como la del MobileDaRt Evolution MX8 tipo k, ofrecen funcionalidades opcionales de **radiografía en serie**, capaces de adquirir hasta 15 imágenes estáticas por segundo durante 20 segundos consecutivos.  Esto permite observar movimientos reales, como cambios morfológicos en los pulmones debidos a la respiración o el flujo de medios de contraste, sin necesidad de trasladar al paciente.