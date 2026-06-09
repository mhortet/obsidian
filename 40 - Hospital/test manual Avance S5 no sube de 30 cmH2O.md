---
tags:
  - Error
  - hospital
Creado:
Autor:
Relacionado:
---
## Alcance
Procedimiento a seguir  con el error indicado
## Descripción

==Que la presión no pase de 30 cmH2O durante el test manual, aun con la válvula APL ajustada a 70, 

### indica casi con total seguridad una **fuga importante en el circuito**.
El gas se está escapando antes de poder presurizar el sistema, por lo que la válvula APL no llega a entrar en acción. [[1](https://meditegic.com/wp-content/uploads/pdfs/Datex_Ohmeda_S5_Avance_Service_manual.pdf)]

Para solucionar este problema en tu **Datex-Ohmeda / GE Avance S5**, sigue estos pasos de verificación:

1. Comprobación rápida de fugas

- **Cúpula o Fuelle:** Asegúrate de que la concertina (fuelle) esté bien enroscada y asentada en su base. Una junta mal cerrada es la causa más común de fugas masivas.
- **Trampa de agua:** Verifica la trampa de agua (condensador) del circuito respiratorio. Presiónala suavemente o vuelve a enroscarla; a veces su peso o un mal sellado en la junta provoca fugas que impiden pasar los tests.
- **Puerto manual/bolsa:** Revisa el selector _Bolsa/Ventilador_. Asegúrate de que esté en la posición correcta según el test que estés realizando, y examina el estado de la bolsa manual. [[1](https://www.tiktok.com/@sociedadbiomedica/video/7352250740380798213), [2](https://es.scribd.com/document/420650790/Manual-de-Usuario-Avance-s-5), [3](https://www.medwrench.com/thread/162/self-test-error), [4](https://es.scribd.com/document/562195424/04-DATEX-S-5-Avance-MANUAL-TECNICO-DE-REFERENCIA)]

2. Inspección visual del Sistema de Respiración Avanzado (ABS)

- **Válvula APL:** Verifica que la perilla mecánica gire suavemente y cierre el paso.
- **Válvula de alivio/exhalación:** Comprueba que la membrana interna de la válvula de exhalación no esté rota, desgastada o atascada por residuos.
- **Mangueras corrugadas:** Revisa el tubo inspiratorio y espiratorio en busca de cortes, microperforaciones o abrazaderas flojas.
- **Cánister de cal sodada:** Si el sistema de absorción no está perfectamente sellado y bloqueado (comprobando que la palanca o rosca quede firme), el aire se fugará por ahí. [[1](https://es.scribd.com/document/562195424/04-DATEX-S-5-Avance-MANUAL-TECNICO-DE-REFERENCIA)]

3. Procedimiento recomendado de aislamiento

4. **Coloca un pulmón de prueba** en la pieza en Y del paciente.
5. Ocluye la conexión en Y manualmente o mediante el tapón.
6. Administra un flujo bajo de O₂ (o presuriza con la purga/flush de O₂).
7. Escucha atentamente de dónde proviene el escape de aire para identificar la pieza defectuosa. [[1](https://portal.insnsb.gob.pe/docs-web/calidad/guias-manejo/gmcie-16.pdf), [2](https://pmc.ncbi.nlm.nih.gov/articles/PMC3821271/), [3](https://es.scribd.com/document/562195424/04-DATEX-S-5-Avance-MANUAL-TECNICO-DE-REFERENCIA)]

_Nota:_ Si tras revisar minuciosamente estas conexiones y empaquetaduras el equipo sigue sin presurizar, el problema podría encontrarse en el interior del bloque neumático (válvulas internas o sensores). En este caso, será necesaria la intervención de **Ingeniería Biomédica** o el servicio técnico oficial para una calibración y revisión de componentes internos. [[1](https://www.cpsitem.com/wp-content/uploads/2018/09/Guia-del-Usuario-S5-ADU.pdf)]

Mostrar todo

## si inyecto O2 con el flush, si que presuriza por encima de 30

Que el sistema sí pase de 30 cmH2O al usar el botón de **flush (purga) de O₂** es una pista excelente. Esto significa que **el circuito sí es capaz de retener la presión** y que la válvula APL y la bolsa no tienen una fuga masiva.

El problema real es que el flujo normal de gas que usas para el test es **demasiado bajo** para compensar una **microfuga (fuga pequeña)**, mientras que el flush inyecta tanto volumen de golpe (entre 35 y 75 L/min) que logra inflar el circuito a pesar de la pérdida.

Para encontrar esa fuga pequeña en tu **GE Avance S5**, revisa estos puntos específicos:

1. Sustituir todas las tubuladuras, incluido el pulmón reservorio
2. Las válvulas unidireccionales (Dómos)
	- Gira y retira las tapas transparentes de las válvulas de inspiración y espiración.
	- Saca los discos de plástico (membranas) de su sitio.
	- Limpia cualquier rastro de humedad o cal sodada.
	- Si un disco está doblado, húmedo o mal asentado, el gas se escapará por ahí a flujos bajos.
3. El cánister de cal sodada y su junta
	- Desmonta el depósito de cal sodada.
	- Limpia con un paño la junta de goma superior donde sella el cánister. Un solo grano de cal sodada atrapado ahí causará este fallo exacta.
	- Asegúrate de que el depósito encaje firmemente al cerrarlo.
4. El sensor de flujo y su bloque
	- El módulo donde van conectados los sensores de flujo tiene juntas tóricas (O-rings) internas.
	- Si el bloque del sensor de flujo no está bien insertado o los cables/tubos están flojos, perderá presión.
5. La propia bolsa manual
	- Revisa la unión donde se conecta la bolsa manual.
	- Si estás usando una bolsa vieja, el cuello de goma puede estar estirado y fugar solo a presiones medias.

**¿Qué hacer ahora?**  
Para localizarla de forma visual, presuriza el circuito usando el _flush de O₂_ hasta llegar a 40 cmH2O, suelta el botón y **observa el manómetro**. Verás que la aguja empieza a caer. Mientras cae, pasa tu mano o acerca el oído a las zonas del **cánister** y de los **dómos transparentes** para escuchar por dónde sopla el aire.
