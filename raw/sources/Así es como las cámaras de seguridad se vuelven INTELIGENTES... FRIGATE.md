---
title: "Así es como las cámaras de seguridad se vuelven INTELIGENTES... FRIGATE"
source: "https://www.youtube.com/watch?v=w0EEM9H8hBk"
author:
  - "[[Un loco y su tecnología]]"
published: 2022-04-02
created: 2026-11-11
description: "En este vídeo vamos a ver una introducción a FRIGATE, qué es, qué nos permite hacer, cómo instalarlo y cómo hacer una configuración básica. Con FRIGATE podrás, no sólo guardar todos los vídeos de tus"
tags:
  - "clippings"
---
![](https://www.youtube.com/watch?v=w0EEM9H8hBk)

En este vídeo vamos a ver una introducción a FRIGATE, qué es, qué nos permite hacer, cómo instalarlo y cómo hacer una configuración básica. Con FRIGATE podrás, no sólo guardar todos los vídeos de tus cámaras de vigilancia, si no que también podrás detectar objetos, animales, personas... todo eso integrado completamente con Home Assistant.  
  
Web de Frigate: https://frigate.video/  
  
👉 Únete a nuestro canal de Telegram: https://t.me/unlocoysutecnologia  
  
🛑 ¿Te gusta lo que hago? Puedes invitarme a un café: https://www.buymeacoffee.com/ccorderor  
  
\==== OTROS VÍDEOS DEL CANAL ====  
  
📌 Lista de reproducción sobre Home Assistant y Node Red: https://youtube.com/playlist?list=PLMuAf-x9dLNj-WOJS5WG2bN3vAiGhWX34  
  
📌 Duplicati: https://youtu.be/hoauNQsyer8  
📌 WireGuard: https://youtu.be/BoJ3wUZ4PJw  
📌 TailScale: https://youtu.be/BU47rgJGsns  
📌 PiHole: https://youtu.be/zeklVkwz6c0  
📌 Home Assistant y Node Red con Docker: https://youtu.be/wi2b5ZcySuc  
📌 ¿Cómo actualizar Home Assistant?: https://youtu.be/lk3IrUyh7nk  
📌 Instalación de HACS en Home Assistant: https://youtu.be/4-uJjhKU8CE  
📌 Home Assistant Cloud: https://youtu.be/bb-obCABcvc  
📌 Conectar Node-Red y Home Assistant: https://youtu.be/sIvzWJ4ytok  
  
\==== MATERIAL ====  
  
En general, las cámaras Foscam tienen un precio bastante correcto y funcionan muy bien en cuanto a feed RTSP y calidad de señal.  
Además, tienen cámaras fijas con buenos ángulos de visión.  
  
Reolink tiene cámaras a buenos precios también y los modelos que os dejo aquí tienen RTSP  
  
ieGeek es una marca más barata, de calidad media, pero yo tengo un par de ellas en exterior y me han sorprendido siempre por lo bien que funcionan.  
  
Dahua y Amcrest son marcas habitualmente más caras y profesionales, por si os interesa mirarlas también.  
  
🧰 Os pongo modelos Wifi, existen para casi todas ellas modelos similares con conexión cableada y alimentación PoE:  
  
✅ Foscam C2M 1080p: https://amzn.to/37rfKsb  
✅ Foscam C1 720p: https://amzn.to/3Idrc7y  
✅ Foscam Oscam G4P Exterior: https://amzn.to/3id90k3  
  
✅ Reolink E1 Pro: https://amzn.to/37xkMn3 / https://ali.ski/GvgNfJ  
✅ Reolink RLC-410W: https://amzn.to/361aFXs / https://ali.ski/qwP9A  
  
✅ ieGeek Camara de Vigilancia Exterior: https://amzn.to/3IkPRXY  
  
✅ Dahua Imou Cue 2C: https://ali.ski/xQjnF  
  
✅ Amcrest IP2M-841W: https://amzn.to/3tgpGxi  
  
Existen decenas de marcas “rebrandeadas” chinas, muchas de ellas soportan RTSP de alguna forma… pero como no las he probado, prefiero recomendaros aquello que yo tengo.  
  
🧰 ¿Necesitas comprar material para tu domótica?  
  
✅ Raspberry PI 4 4GB Kit: https://amzn.to/3sf6JLn  
✅ NUC Celeron: https://amzn.to/3J1BtoS  
✅ NUC i5: https://amzn.to/3p70cjU  
✅ Adaptador SATA a USB: https://amzn.to/3FViTgk  
  
  
\==== CAPÍTULOS ====  
  
00:00 ¿Qué es frigate? / Requisitos  
08:55 Documentación  
10:40 Instalación Docker  
15:20 Ejemplo de configuración  
17:59 Ejemplo de detección con cámara  
26:07 Conclusiones  
  
¿De qué hablamos en este vídeo?  
#frigate #homeassistant #rtsp #domotica

## Transcript

### ¿Qué es frigate? / Requisitos

**0:00** · Hola locos vamos a hablar de freegate y Qué es freegate es \[Música\] esto este posiblemente es uno de los vídeos que más me habéis pedido me pedís

**0:17** · y me pediréis hasta que lo suba Hoy es el primer día porque Este vídeo lo he intentado hacer ya en varias ocasiones pero el problema es que al final quedaban vídeos muy densos porque no nos no no no nos equivoquemos freegate no es sencillo freegate no es sencillo de configurar pero es muy potente es una newr es decir es un

**0:40** · grabador de vídeo en Red Pero además es un sistema que nos permite detectar objetos con un sistema de Inteligencia artificial local posiblemente si ya tenéis cámaras en casa sabréis que la mayoría lo normal es que detecten movimiento y eso hace que las cámaras de vigilancia estándar tienen demasiados falsos positivos y eso es un problema si la queremos para algo relacionado con la seguridad o automatizaciones Ahí viene la potencia de freegate freegate utiliza un sistema

**1:11** · framework de reconocimiento de modelos llamado tensor Flow que básicamente nos permite configurarlo para reconocer lo que queramos personas coches animales la taza del café hay decenas de eh modelos

**1:29** · ya entrenados y ojo es importante decir aquí que lo que detecta son personas No una persona en particular no caras no detecta matrículas esos son modelos aprendizaje de modelos que veremos en otros vídeos que hablaremos de di stack de otro tipo de soluciones aquí nos interesa freegate Por ejemplo para un

**1:50** · sistema de vigilancia en el que lo que queramos sea detectar Si aparece alguien hay alguien que entra en nuestro jardín hay alguien en casa cuánta gente hay en casa eh hay alguien que ha salido de una habitación o que ha entrado en una habitación todo eso es lo que vamos a poder hacer con freegate y es una solución muy potente Y eso tiene un Pero y el pero es que es una solución como casi todos los nvrs y freegate no es menos y además este reconocimiento o a

**2:18** · través de ia hace que todavía sea peor nos va a suponer un uso muy elevado de recursos y es así tenemos que tenerlo en cuenta esto es una pregunta que me hacéis mucho puedo utilizar freegate en mi raspberry eh Cuántas cámaras van a utilizar van a van a poder soportar Eh mi mi instalación mi ordenador mi mini PC mi nuk mi raspberry cuántas cámaras voy a poder poner eh qué configuración eh recomiendas Bueno pues La respuesta

**2:48** · es muy sencilla no hay una configuración recomendada o no hay una configuración perfecta todo va depender de el número de cámaras del tipo de cámaras Y de lo que queréis hacer con ellas Vamos a entrar en lo que permite hacer freegate Y luego lo veremos en el ordenador freegate nos va a permitir hacer tres cosas la primera es grabar como un nvr

**3:08** · nos va a permitir grabar con una serie de parámetros todo lo que ven nuestras cámaras lo segundo que nos va a permitir hacer es poder hacer un restream de ese vídeo para que por ejemplo lo podamos ver en Home assistant y lo tercero nos va a permitir detectar lo que hablábamos antes esas tres configuraciones vamos a

**3:25** · ir viendo que pueden ser distintas y es muy importante esto porque cuando os digo que depende de las cámaras que tengáis primero depende del número Pero también depende de la calidad con la que esa cámara del formato de vídeo porque a mayor calidad más recursos se necesitan para procesar esa imagen a mayor calidad más consumo de cpu por lo tanto eh Y

**3:48** · aquí yo Siempre os recomiendo bueno primero tienen que ser cámaras que soporten rtsp como siempre como hemos visto en todos los vídeos Aquí no hay novedad pero recomiendo también cámaras que tengan dos fit de vídeo uno en alta calidad y uno en baja o más pero como mínimo que tengan esos dos porque posiblemente vamos a querer el de alta para la función de grabación queremos tener un vídeo con buena calidad pu si tenemos que recuperar algo pero queramos un fit en Baja para lo que es reconocimiento de forma que sufra menos la máquina dicho esto qué os recomiendo

**4:20** · así para empezar para free gay bueno No utilicéis una raspberry porque salvo que utilicéis una única cámara eh lo vigo tal cual HM Vais a sufrir mucho por supuesto si vais a utilizar una raspberry tiene que ser una 4 y tiene que tener memoria la recomendación es que tenga 8 GB pero tampoco va a aguantar mucho más me vais a decir que entonces eh Para qué queremos freegate

**4:44** · si consume tantos recursos Bueno lo primero es que esa es la realidad los consume no vamos a engañarlo la segunda es que habréis oído hablar si habéis estado en comentarios un el canal de Telegram de algo llamado coral coral es un Hardware fabricado un proyecto apado

**5:00** · por Google que básicamente nos ofrece una tpu y Qué es una tpu pues es un procesador específicamente creado para eh trabajar con modelos de reconocimiento básicamente para todos estos temas de ia Qué es lo bueno que tiene coral es barato porque un Stick USB de coral Bueno pues nos va a costar unos 40 más o menos 30 40 50 y lo

**5:24** · segundo porque nos va a permitir que virtualmente en cualquier mini PC podamos tener un número bastante elevado de cámaras podamos tener 10 15 cámaras sin que el reconocimiento de objeto sea un problema vale Y aquí viene la pega no

**5:43** · hay coral es lo que hay coral lleva fuera de stock lleva con ruptura de stock muchos meses muchos lo seguimos esperando yo tengo pedidos en tres sitios por lo tanto no podemos contar con ello vale eh si hubiese dispositivos coral esto sería mucho más fácil se

**6:01** · acabaría el problema de tener que ver el Hardware dónde ponemos las cámaras Cuántas cámaras cómo las configuramos cuando activamos la detección todo sería más fácil pero como no hay coral no hay stock y hasta que os llegue si queréis tener la paciencia de comprarlo y esperar vamos a tener que jugar con la CP por lo tanto mi recomendación yo os digo lo que tengo yo ahora mismo tengo free Gate en uno de los mini PC que tiene un una cpu i3 antigua tengo Siete

**6:29** · cámaras eh Y esas siete cámaras funcionan siempre y cuando Y esto es un pero muy importante siempre y cuando no estén reconociendo todas a la vez ahora os iré enseñando la configuración que tengo pero es importante que entendáis esto yo el reconocimiento a día de hoy lo utilizo para motivos de seguridad porque aunque quería utilizar freegate también para y es mi objetivo final utilizarlo para eh reconocimiento dentro

**7:01** · de casa automatizaciones y demás básicamente lo hace inviable Puedo trabajar con un par de cámaras dos tres cámaras a la vez 247 en modo reconocimiento y aquello aguanta pero cinco o seis cámaras siete no se las

**7:16** · traga para nada por lo tanto es algo que tenéis que tener en cuenta también Es verdad que ese mini PC en mi caso es Antiguo es un mini PC tiene unos cuantos años posiblemente en un mini PC más reciente con un i5 de una generación más nueva funcione mucho mejor de hecho funcionará mucho mejor pero tenedlo en cuenta eh

**7:35** · Por eso os digo que intentar correr esto en una raspberry no es una buena solución y antes de irnos al ordenador vamos a ver cómo instalamos esto como os he dicho esto está muy acoplado muy ligado tiene mucha compatibilidad con home assistant por lo tanto tenemos dos opciones de instalarlo la primera es como un docker normal y corriente ahora lo veremos y la segunda es como un adon de hom asist Bueno pues si me permitís

**7:57** · un consejo yo es un software que no instalaría como un addon de Home assistant De hecho no lo montaría en la misma máquina donde tenga home assistant salvo que sea una máquina super potente que tengáis un nuk con mi 7 que tengáis 16 Gb de ram y lo podéis controlar bien porque si os pasáis la Vais a tumbar y Vais a tumbar toda vuestra domótica si lo

**8:29** · Endo que freegate lo instalé como un contenedor docker y luego lo unamos a través de la integración de hacks con home assistant tal y como lo tengo yo ahora nos vamos al ordenador os enseño cómo lo tengo os enseño un poco vamos a ir viendo la configuración y vamos a hacer una primera instalación de freegate una pequeña configuración sencilla que yo creo que para este vídeo introducción va a ser más que suficiente

### Documentación

**8:55** · Bueno pues lo primero de todo es que hagamos una introducción a la documentación de freegate porque es muy extensa Y si os decidís por utilizar freegate la vais utilizar mucho freegate se configura a través de un fichero jamel muy parecido en formato a lo que ya conocéis de Home assistant y solo a través de ese fichero por lo tanto no es sencillo de configurar Esa es la realidad lo primero que tenemos que que ver vamos a empezar por la

**9:28** · instalación como ya os he comentado en la parte de los requisitos de Hardware eh En cuanto a las cámaras eh es fácil tenéis que contar con cámaras que sean rtsp aquí os dan algunas recomendaciones las que yo os he recomendado en los vídeos funcionan bastante bien yo son las que tengo y no son cámaras excesivamente caras en cuanto a la plataforma y al servidor pues lo que os decía antes eh esto yo lo recomiendo

**9:55** · utilizar en un nuk o en un mini PC eh que tenga idealmente un i5 yo lo utilizo en un i3 y con un mínimo de 8 GB de ram es mi recomendación si solo veis utilizar A lo mejor una o dos cámaras Pues a lo mejor un celeron os puede llegar a funcionar Pero va a ir muy justito en cuanto a la instalación ya os he dicho las dos formas docker y ad dejo asistan si si lo instala como adon Pues

**10:24** · básicamente es la instalación de un adom más y luego la configuración es el mismo mmo fichero yamel Así que yo os voy a enseñar y yo lo que voy a hacer como recomendación es que lo hagáis eh Como un docker realmente tenéis que leeros la documentación no vamos a engañarnos si no la leéis os vais a perder hay varios aspectos importantes y para ello nos

### Instalación Docker

**10:46** · vamos a ir directamente a ver el Locker compos nombre de contenedor imagen tal lo lo de siempre pero llegamos a este parámetro este parámetro es muy importante básicamente esto es un espacio Temporal y Digamos que cada contenedor de boker tiene em eh un

**11:04** · espacio disponible lo que puede pasar si eh No lo configuré adecuadamente y ponéis más de dos cámaras es que empecéis a tener mensajes en el lock de este tipo bus error si esto ocurre es porque tenéis que subir el valor aquí os dan la fórmula para eh poder calcularlo Pero la realidad es que podéis ir jugando con él según vayáis aumentando cámaras pasáis de 64 128 256 depende

**11:32** · también un poco de la memoria que tengáis para que os hagáis una idea yo tengo Siete cámaras lo tengo en 128 y a mí no me ha dado problemas Aunque supuestamente debería tenerlo más alto Pero a mí no me ha dado problemas también Es verdad que yo las cámaras las tengo puestas la mayoría en low resolution para que eh Me cargue menos la máquina Pero bueno Ahí Vais a tener que ir jugando Vosotros los devices aquí de nuevo tenéis eh que leer

**11:57** · lo que tenéis que pasar si tenéis un coral si tenéis la suerte de tener un coral tenéis que pasar uno de estos dos parámetros y si no tenéis coral pero tenéis un Hardware de Intel que es lo normal si tenéis un mini PC tendréis que pasar este device que básicamente es lo que permite que el Locker acceda directamente a la tarjeta gráfica si utilizáis un mini PC que tenga una e una

**12:21** · md o una nvidia las configuraciones son distintas y las honraré en la documentación lo mismo con los volúmenes tenéis que exponer los volúmenes como haríais en cualquier sitio esto También es importante que en la parte de storage leáis las configuraciones que podéis poner por qué Porque posiblemente si tenéis varias cámaras os interese cambiar estos dos y ponerlos en un

**12:45** · almacenamiento en Red si tenéis un nas a través de nfs por ejemplo o en un disco externo de forma que cargué menos la máquina o si es un ssb o si no tenéis una SD que no deberíais pues lo mismo no esté todo el rato escribiendo en vuestro almacenamiento principal eso son cosas que tendréis que ir investigando con el tiempo Y por último un almacenamiento temporal que ayuda a hacer menos escritura en disco o en la tarjeta SD

**13:12** · esto también va a depender un poquito de la memoria que tengáis disponible Y por último los puertos que hay queis poner dependiendo de lo que tengáis pues yo por ejemplo tengo en el 5001 porque el 5000 ya lo utilizo y los feed de rtmp por último una contraseña para todo lo

**13:28** · que sea streaming de rtsp por ejemplo para tenerlo en Home assistant y si no tenéis docker compost pues lo podéis arrancar como un docker ya podemos arrancar el contenedor como hemos hecho en muchos otros vídeos Así que lo siguiente que tenemos que hacer es irnos a Añadir nuestra primera cámara esto os lo he contado al principio del vídeo las los tres formatos que soporta aquí de nuevo os vuelvo a decir eh En cuanto a qué formato de cámara utilizar las cámaras por rtsp normalmente utilizan h64 y utilizan aac para el audio nuevas

**13:59** · cámaras Hay nuevas cámaras cámaras como las de reolink que ya soportan h265 que tiene mejor compresión pero el problema es que los navegadores todavía no son muy no son muy compatibles y por lo tanto el problema es que si ponéis el fit h265 posiblemente No vais a poder ver bien la imagen en el navegador Y bueno pues os va a molestar así que yo

**14:22** · mi recomendación a día de hoy todavía es que utilicemos h64 luego con respecto a las resoluciones es lo que os contaba utilizar distintos tipos de resoluciones lo veremos en la configuración eh si las cámaras si la cámara soporta dos fit 2s fit si soporta tres pues tres y la idea

**14:37** · aquí es que juguéis vosotros también dependiendo donde tengáis puesta la cámara de lo que queráis localizar del tipo de cámara de la calidad podáis jugar con las resoluciones no hay una respuesta correcta y en cuanto al fichero de configuración lo primero es que necesitamos un servidor mqtt para poder conectarnos con homa System si no tenéis mosquito instalado hay vídeos en el canal donde os enseño a instalarlo Este es el el primer apartado de la configuración mqtt vuestro Host y si lo

**15:02** · tenéis protegido por usuario y contraseña usuario y contraseña lo segundo que vamos a hacer es configurar los detectores si tenéis un coral tenéis que configurarlo si utilizáis por cpu por ahora ignorar esta parte y lo siguiente como configuración más básica que vamos a empezar es a configurar las cámaras Esta es la parte compleja Yo quiero enseñaros mi fichero de configuración actualmente quiero que veáis que es extenso y aún así es

### Ejemplo de configuración

**15:26** · bastante sencillo porque no he tenido que hacer cosas raras con las cámaras cosas que vamos a ver vamos a cogernos una cámara tal cual la primera tenemos un input ahora lo veremos vale Esto está en la configuración Este input es el p de la cámara yo por ejemplo en esta cámara Solo tengo un fit porque solo tiene un fit Lo bueno es que está es una cámara HD no Full HD los roles nos permiten lo que os he comentado antes las tres opciones Pues esta cámara quiero que detecte quiero que me haga el

**15:54** · restream y quiero que guarde quiero que grabe como nvr en cuanto estos parámetros ahora los veremos en la configuración Aquí he puesto el ancho y el alto de la imagen de vídeo y básicamente pues lo que os decía quiero que grabe quiero que guarde snapshots

**16:13** · por defecto cuando arranca el sistema esto es importante si os dais cuenta yo aquí le he dicho que quiero que detecte pero aquí en la detección Yo no le he puesto un enable a TR porque por defecto cuando arranca freegate no quiero que detecte os enseñaré posiblemente ya en el siguiente vídeo todo este inter relación con home assistant yo cuando pongo la alarma de casa eh entre otras automatizaciones se activa la detección de movimiento y cuando la desactivo se Desactiva veis que la configuración no es excesivamente compleja pero bueno

**16:42** · Pues al principio te puedes perder un poco todo está en la documentación vale quiero que lo entendáis que leyendo esto tranquilamente se entiende eh también nos dan consejos sobre qué ocurre Oye eh veo el feed en verde no veo el vídeo Bueno pues es porque tenéis un error de configuración en a a la aceleración de Hardware aquí os dan opciones vale dependiendo de la cpu que utilicéis aquí nos dan dependiendo si utilizáis una raspberry si utilizáis un nuk con un e

**17:12** · procesador anterior a décima generación o igual y superior una gpu de de amd o de nvidia yo por ejemplo que utilizo un chip de menos de décima generación tengo que ponerle estos parámetros que son los

**17:29** · que encontráis aquí recordad que esto es el device que hemos pasado cuando hemos creado el docker una vez que tenemos la configuración hecha tenemos que reiniciar free Gate Esto va a ser siempre así es una de las cosas malas que tiene freegate y es que cada vez que tocamos la configuración nos toca parar el contenedor y volver a arrancarlo por lo que la configuración inicial e es bastante tediosa es lo que hay Pero

**17:54** · bueno una vez configurado pensad que es algo que no Vais a estar tocando todo todos los días Una vez que lo tenemos y arrancamos pues ya tenemos acceso a la cámara si nos vamos a la parte de bg quiero que veáis cosas muy interesantes vamos a Desactivar esta máscara veis que directamente me está detectando si yo me

### Ejemplo de detección con cámara

**18:22** · muevo me sigue detectando veis que ahora mismo me está detectando como persona es decir la cámara de saber que hay una persona de hecho detecta mis manos detecta y va detectando que estoy delante de la cámara y que me estoy moviendo esto es porque yo tengo en esta cámara en la cámara builla un activado la detección si yo la desactivo y me vuelvo a la parte de deb desaparece ya no hay una detección

**18:54** · de persona esto básicamente es importante que lo tengáis cuenta porque si solo lo Vais a utilizar en ciertos momentos Esto va a hacer que deje de haber esa carga enorme en la cpu pero quiero que enseñaros lo que básicamente ocurre fijaros en la cpu ahora mismo Está Pues en torno a un 20 un 30% de carga porque aún así tengo el

**19:17** · ffp que está haciendo cosas con las cámaras Pero bueno tiene una carga bastante bajita relativa está bien si yo ahora mismo activo la detección ya me está detectando de nuevo quiero que veáis automáticamente Cómo se pone la cpu la cpu va va a estar al 100

**19:40** · y no va a bajar no va a bajar mientras haya movimiento es decir si deja de haber movimiento Por ejemplo si no estoy en casa e está la arma puesta no hay nadie eh mientras no detecte a nadie no va a penas cargar la cpu la va a cargar un poco pero mucho menos vale va a ser

**19:57** · admisible en cuanto alguien va a meter carga por eso os digo que imaginaros que en las siete cámaras tuviese movimiento a la vez esto no aguantaría en un par de cámaras bueno puede aguantar el movimiento pero en más de dos cámaras a la vez esta cpu que es una i3 no aguantaría por lo menos una i3 de una

**20:16** · generación bastante más antigua qué más cosas os puedo enseñar Por ejemplo si activo las máscaras veis que automáticamente ya en esta zona no detecta nada en el siguiente vídeo hablaremos sobre sobre máscaras y zonas Qué son conceptos el de máscara más conocido básicamente el de máscara digamos que es la zona en la que no quiero que haga detección pero el de zonas es un poco más complejo porque básicamente lo que nos va a decir es que

**20:43** · permite ver si un un un objeto por ejemplo ha pasado por una zona antes de llegar a otra y que lo detecte un ejemplo Oye queremos detectar si llega un coche a nuestra Plaza de parking pero no queremos que detecte el coche siempre porque está ahí eh si no lo va a detectar al trabajar con zonas podemos hacer una zona que sea la entrada de la puerta del garaje y podemos hacer otra

**21:07** · otra zona que sea donde está aparcado el coche y podremos configurarlo para decirle Oye tiene que haber pasado por la zona de entrada para detectarlo como que ha llegado un coche todos estos todas estas cosas las veremos en el siguiente en el siguiente vídeo vamos a ir poquito a poco porque es eh un sistema complejo vale Pero bueno yo creo que yo creo que vais viendo la potencia que queene tiene un sistema de este tipo con respecto a la grabación como buen nvr nos permite configurar eh distintas

**21:35** · distintos tipos de grabaciones y distintos modos de retain de cuánto tiempo va a guardar la grabación y esto También es importante dependiendo de lo que queráis hacer dependiendo de si solo queréis grabar cuando eh Hay movimiento cuando detecta objetos cuando lo que sea

**21:52** · y esto es importante también porque nos permite ahorrar almacenamiento e y esto lo Vais a tener que configurar yo por por ejemplo tengo un almacenamiento externo y me puedo permitir grabar varios días TR cu días de todas las cámaras si quiero aunque creo que incluso ahora lo tengo puesto os lo voy

**22:09** · a decir porque está en la configuración lo tengo puesto en dos días dos días para mí es suficiente para grabar 247 de todas las cámaras y toda esta información la vamos a poder ver en la parte de recordings si os dais cuenta

**22:26** · todo lo que oc urre se graba en la cámara todo absolutamente todo porque es lo que yo quiero y puedo ir durante dos días para atrás y ver la información da igual cuál sea de las cámaras porque yo permito grabar todo por ejemplo me va va grabando en en lapsos de una hora por lo tanto

**22:52** · podemos ir y elegir donde queremos estamos en el día 1 de abril la 1 las 4 de la mañana las 9 veis ya se ha hecho de vía y así hasta ahora pero también nos permite eh grabar o mostrarnos los eventos y los eventos son los eventos de

**23:16** · personas o de coches o de lo que sea para que os hagáis una idea Bueno pues aquí por ejemplo me ha detectado moviendo el micrófono y colocando el micrófono para el vídeo si yo por ejemplo me voy a esta cámara de aquí tengo seleccionado coche y persona y por lo

**23:34** · tanto me detecta cualquiera de las dos cosas hablaremos de las máscaras porque aquí las he quitado para hacer pruebas y por ejemplo detecta gente en la calle lo cual no es legal eh yo he movido esta cámara para hacer unas pruebas y que bueno pues no no saliese toda la información pero tenéis que tener claro

**23:50** · que no podéis grabar a la calle e mis cámaras apuntan dentro de casa siempre para evitar cualquier problema legal Y por último vamos a hablar de la integración de Home assistant Aunque la veremos en el siguiente vídeo en profundidad pero por si queréis ir bicheando con iá tenéis que saber que hay una integración que se instala a través de hacks y si no sabéis lo que es hacks hay vídeos en el canal al respecto en la descripción encontraréis eh vídeos para verlo y montarlo y es una interacción que funciona muy bien y os va a permitir Ver todas las cámaras en Home assistant tener acceso a todas las configuraciones y poder hacer cosas muy

**24:22** · interesantes a nivel de automatización si yo por ejemplo me busco mi integración de freegate tengo otro sub dispositivos el propio freegate y siete cámaras y yo desde estas cámaras puedo hacer lo mismo que haría desde la página web puedo ver una cámara en directo que como veis aquí graba el vídeo directamente y me lo va streame podemos ver la última persona detectada y todo

**24:50** · esto nos lo podemos enviar luego como notificaciones a nuestros dispositivos móviles que es una de las cosas más interesantes que tiene podemos ver más datos podemos ver si hay eh personas detectadas o no como yo ahora lo tengo desactivado no tengo la detección Pues no hay personas si yo activo la detección automáticamente cambia y me dice que hay una persona detectada porque es que realmente hay una persona detectada que soy yo y de hecho me va

**25:15** · cambiando esto y me va a y me va poniendo la captura de lo que ha detectado como persona es realmente Una pasada y si lo quitamos podemos parar también el que nos haga los record o sea es decir las grabaciones o nos grabe los snapshots y todo esto además de verlo como lo hemos visto en la página de freegate directamente lo podéis ver directamente desde la sección media aquí tenemos Lo mismo para toar las cámaras

**25:44** · si os dais cuenta yo aquí me voy tengo jardín trasero tengo lo que llevamos de estos 7 minutos pero me puedo ver Cualquier cosa me puedo ir y decir Bueno pues yo quiero a las 3 de la mañana el jardín trasero y lo veo directamente sin necesidad de tener que acceder a la página web de freegate lo cual también es super completo para verlo y y muy potente para verlo cuando no estamos en casa Bueno pues vamos a dejar aquí Este primer vídeo en el siguiente vídeo trataremos en detalle la configuración eh de los

### Conclusiones

**26:16** · diferentes streams máscaras zonas y todas aquellas dudas que me vayáis poniendo en los comentarios porque seguro que eso es lo que va a hacer que el vídeo sea más fácil Y así pueda responder a todas vuestras preguntas si no le habéis dado un like todavía al vídeo y os ha gustado porfa dle un like y si no estáis suscritos al canal es un buen momento para hacerlo cuidaros ser buenos chao