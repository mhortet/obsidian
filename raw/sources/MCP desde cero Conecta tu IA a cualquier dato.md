---
title: "MCP desde cero: Conecta tu IA a cualquier dato"
source: "https://www.youtube.com/watch?v=nqzVrkhmNTg&t=3465s"
author:
  - "[[MoureDev by Brais Moure]]"
published: 2026-04-29
created: 2026-06-28
description: "Aprende a trabajar con MCP (Model Context Protocol), el estándar abierto que permite conectar modelos de IA con herramientas, datos y aplicaciones externas mediante una interfaz común.Taller patroci"
tags:
  - "clippings"
---
![](https://www.youtube.com/watch?v=nqzVrkhmNTg)

Aprende a trabajar con MCP (Model Context Protocol), el estándar abierto que permite conectar modelos de IA con herramientas, datos y aplicaciones externas mediante una interfaz común.  
  
Taller patrocinado por Beehiiv:  
📩 Crea tu propia newsletter gratis: https://mouredev.link/beehiiv  
▶ Código MOUREDEV30 para un 30% de descuento los 3 primeros meses en los planes de pago.  
  
🤘 Estudia programación de manera diferente en https://mouredev.pro  
▶ Cursos desde cero, ejercicios, test, certificados, soporte, comunidad y mucho más.  
(Usa el cupón "PRO" para ahorrar un 10% en todas las suscripciones y cursos)  
  
👾 Comunidad Discord: https://www.discord.gg/mouredev  
📱 Todos mis enlaces de interés: https://moure.dev  
✉️ Newsletter de la comunidad: https://newsletter.moure.dev  
🖥 Practica programación: https://retosdeprogramacion.com  
📖 Mi libro: "Git & GitHub desde cero"  
• Amazon: https://mouredev.com/libro-git  
• Leanpub: https://mouredev.com/ebook-git  
  
Redes:  
https://www.instagram.com/mouredev  
https://www.tiktok.com/@mouredev  
https://www.twitter.com/mouredev  
https://www.facebook.com/mouredev  
  
Índice del curso:  
00:00:00 | Introducción  
00:02:45 | El problema antes de los MCP  
00:09:10 | Fundamentos de los MCP  
00:13:01 | Arquitectura  
00:17:23 | Primitivos  
00:20:43 | Conexión a un MCP existente  
00:44:23 | Proyecto práctico  
00:54:18 | Creación de un MCP  
01:09:15 | Conclusiones y recomendaciones

## Transcript

### Introducción

**0:00** · Bueno, gente, bienvenidos, bienvenidas.

**0:02** · Taller de MCPs, el acrónimo de Model Contest Protocol.

**0:08** · Ya lo comentaba aquí al inicio antes de dar comienzo a este taller, pero si no tenéis ni idea que por favor decirme en comentarios, ¿sabéis lo que es MCP? sio ir poniéndolo para que yo después lo lea. A ver, porque ya os prometo que cuando acabe el taller todo el mundo va a saber lo que es un MCP y va a entenderlo perfectamente y sobre todo va a tener clarísimo la potencia que tiene este protocolo, esta tecnología en el nuevo paradigma de desarrollo de software.

**0:39** · Pero bueno, de momento ir poniéndolo en comentarios para que después yo lo lea y a ver a cuánta gente \[risas\] le ha venido bien este tutorial y este taller desde cero. Okay, si no tenéis ni idea, lo primero que quiero dejar claro, Model Contest Protocol, tenéis una web que se llama modelprotocol.io.

**1:05** · Okay.Okay. Aquí se explica todo porque quiero que lo tengáis como referencia a la hora de entender la documentación, que aún no sabéis lo que es. No os preocupéis absolutamente nada porque al acabar este taller, en estas horas que estaremos aquí, vais a entender perfectamente qué es MCP. Vais a entender por qué, si lo podemos definir de alguna forma, se está convirtiendo en la especie de USBC de la inteligencia artificial. vais a con a conocer la arquitectura de un sistema de MCPs.

**1:35** · Vais a ver cómo conectar un MCP, cómo trabajar con él. Vamos a desarrollar algún proyecto pequeño utilizando MCPs.

**1:46** · Eh, vamos a incluso utilizar un MCP que os quiero presentar hoy y después también vamos a ver incluso cómo crear nosotros nuestro propio servidor MCP.

**1:56** · Todo esto lo vamos a ver hoy muy poquito a poco, pero yo creo que sin prisa, pero sin pausa. No quiero tampoco enrollarme mucho con el taller, con este tutorial, pero es importante que en algunas cosas me detenga, sobre todo para entenderlo bien, porque ya sabéis que mi filosofía siempre que os hablo de hay que aprender nuevas cosas, hay que adaptar estas nuevas herramientas a nuestros procesos de desarrollo.

**2:24** · Al final no se trata tanto en decir, "Venga, venga, esto es un MCP, lo conectamos, empezamos a trabajar y ya todo es magia." Sino que para mí es superimportante que entendáis las bases, que entendáis todo sobre lo que se sustenta esta tecnología y por qué realmente es tan importante. ¿Okay?

**2:42** · Así que eso es lo primero que quiero que tengáis en cuenta, ¿vale? Vamos a ir haciendo diferentes cosas porque creo que primero para entender lo que es un MCP tenemos que entender cuál es realmente el problema, ¿okay? ¿Cuál es el problema al que nos estamos encontrando ahora que empezamos a desarrollar todo con inteligencia artificial? Pues mira, me abrí por aquí un escalidrop simplemente para que tengáis en cuenta diferentes dibujos que os voy a ir poniendo yo por aquí para que entendamos mejor a nivel de esquema todo lo que significa un MCP. ¿Vale?

### El problema antes de los MCP

**3:17** · Pensar que ahora mismo teníamos algo muy claro. Empezamos ya a desarrollar con inteligencia artificial. Entonces, igual yo tengo pues a Clou, por ejemplo, o a Clock Code, pero ¿qué más puedo tener?

**3:29** · Imagínate que yo lo que tengo ahora mismo es VS Code, por ejemplo, o tengo Codex, me da igual la herramienta que os dé la gana para acabar desarrollando.

**3:41** · ¿Qué pasa? Que todos estos sistemas que ahora mismo tienen inteligencia artificial, todo esto que es IA sin más, es decir, marcamos aquí, pero pensar que todo esto IA. Okay. ¿Qué pasaba? que en realidad cada vez empezamos a desarrollar con más herramientas que necesitan más contexto, pero claro, más contexto de sistemas que nosotros estamos programando, pero también de sistemas externos. ¿Qué significa esto?

**4:12** · Que sí, muy bien, la IA va a acabar conociendo cuál es el código que yo estoy programando, pero y si tengo algo en una base de datos. La IA sabe lo que hay en mi base de datos. Vamos a ponerlo por aquí. Una base de datos.

**4:32** · Vamos a cambiarlo de color.

**4:34** · Imagínate que tenemos una base de datos o que tenemos nuestro GitHub o que tenemos un Figma o que tenemos, como va a ser el ejemplo que os quiero contar hoy, una newsletter. Hoy vamos a hacer un proyecto real relacionado con mi propia newsletter a través del MCP que nos expone, ¿vale? Minusletter está alojada en B, ¿okay?

**5:05** · Que ya os digo, ya os lo adelanto que ha venido muy bien este taller porque la gente de Behive, que es donde yo tengo la newsletter, si no estáis en la newsletter m.log, entráis por ahí y acabáis encontrando pues esto, newsletter.moure.d, esa es la URL de la newsletter. sabéis que os suscribís, yo todas las semanas os mando correos con consejos, con historias mías, pero todo esto básicamente lo que hago es utilizar Behive, ¿vale?

**5:34** · BHVE es una plataforma gratuita con la que podéis acabar creando vuestra propia newsletter y os lo he dejado fijado por ahí en el primer comentario, también en la parte de chat, incluso tenéis una URL que es mourede.link/behype.

**5:49** · Pues si queréis crear vuestra propia newsletter gratuita, lo podéis hacer sin ningún problema. Incluso tenéis el código Mouredev con un 30% si queréis meter los planes de pago, pero esta es mi newsletter, ¿vale? Yo con esto gestiono pues todas las newsletter que os voy enviando a vosotros. ¿Okay? Esto sin más. Pues mira, esta es la newsletter que envié ayer cuando estamos haciendo el tutorial.

**6:09** · Pues yo sin más la escribo por aquí, se envía y después pues tengo un montón de información, pues gestiono toda la gente que está suscrita, gestiono las diferentes métricas, pero claro, tú imagínate que ahora yo digo, voy a desarrollar una aplicación para mi newsletter porque quiero crear una web para sacar un dashboard, unas métricas o algo que me hace falta. Y es lo que estábamos viendo aquí.

**6:33** · Imagínate que yo ahora mismo tengo diferentes aplicaciones, diferentes sistemas, diferentes herramientas de terceros que no tienen nada que ver con el código que yo estoy generando, pero que no tienen nada que ver con el código que estoy generando, no porque no tenga que conocer estos sistemas, sino porque en realidad no hay relación entre, por ejemplo, el código que yo estoy programando en Visual Studio Code para hacer el dashboard web, imagínate. Pero esta web, ¿dónde está?

**7:05** · Todo esto son sistemas de terceros.

**7:09** · Todo esto podríamos decir que está en la nube, que está fuera de nuestros sistemas.

**7:15** · Voy a poner aquí cloud. ¿Por qué? Porque todo esto son sistemas que en este caso son externos a nosotros. La base de datos está en un servidor remoto, GitHob está en un servidor remoto, Figma está en un servidor remoto, BIH está en un servidor remoto. ¿Y cuál es la problemática que nos surge antes de los MCPs? Es que en el momento que nosotros queríamos conectar una IA, en realidad un LLM, ¿vale?

**7:39** · Lo veis aquí, Cloud, VS Code, Codex, Cursor, eh Clock Code, eh antigravity, me da igual la IA, Llm que querráis. el agente que querráis, pues lo que pasaba es que teníamos aquí unos clientes y después por aquí abajo teníamos pues diferentes herramientas.

**8:04** · Y esta conexión, ¿cómo se establecía? Si yo quiero que mi código tenga contexto sobre cada una de estas herramientas externas, imagínate, pues ahora quiero conectar mi cloud con mi base de datos y quiero conectar mi VS Code, que este es otro caso que yo tengo. Imagínate que lo quiero conectar en este caso con eh, no lo sé, Figma, me da igual. Es decir, el caso que fuera o Codex con BHP.

**8:37** · ¿Qué teníamos que hacer en cada uno de estos casos? Pues esta conexión era custom. Esto significa que cada vez que yo tengo que hacer algo, tendría que programar algo sí o sí adaptado a que cloud en este caso se pudiera conectar a mi base de datos.

**8:58** · Que ahora eh VS code porque tengo la necesidad de conectarlo a BHV. Pues, ¿cómo sería esta conexión? esta conexión pues también sería custom. Claro, esto es un rollo. Claro, si tenemos un montón de diferentes clientes, un montón de diferentes herramientas y tenemos que acabar conectando cada uno de estas IAS LMS a estas herramientas, es un rollo.

### Fundamentos de los MCP

**9:25** · Entonces, ¿qué empezó a pasar? Pues bueno, empezaron a crear diferentes APIs para conectarlos ahí a término medio hasta que por eso yo decía que para mí el MCP acabó siendo un USB tipo C.

**9:39** · Claro, antes del USB tipo C, no sé si recordáis que teníamos el micro USB, el mini USB, el Lightning, que es un conector propietario, no sé qué tal. Y lo que pasó es que dijeron, "Ey, esto es una locura. Hay que empezar a crear un estándar para que ese estándar facilite la vida, en este caso, a los desarrolladores. Entonces, de Idge concepto real de MCP.

**10:06** · MCP significa model context protocol. Ya lo estabais viendo también por aquí. Lo vuelvo a repetir. Tenemos la web modelprotocol.io.

**10:16** · IO. Esta es la web oficial que creó Antropic, pero que es un proyecto open source, es abierto, es decir, cualquiera puede implementarlo. ¿Qué es un MCP? Es un estándar abierto, eso sí, creado por Antropic. ¿Cuándo se creó? A finales de 2024. Ya veis que es muy reciente y de hecho la cesión de este proyecto a la Linux Foundation, a la Argentine AI Foundation, ¿vale?

**10:44** · Es decir, un proyecto código abierto que te lo das, se lo das a la comunidad para que lo pueda evolucionar. Eso se hizo en diciembre de 2025, es decir, eh hace nada. Pues claro, lo que hicieron fue crear este estándar abierto, este protocolo para conectar aplicaciones de inteligencia artificial.

**11:03** · estas aplicaciones que nosotros teníamos aquí, que si los LLM es de turno, una aplicación creada con Cloud, con VS Code, con Codex, con la IA que sea, con el ID que sea, con la herramienta que sea para poderlo conectar a diferentes herramientas de terceros, que en este caso pues no son nuestras ni están en nuestra base de código mediante un protocolo.

**11:27** · Entonces, ¿qué pasó directamente? que de empezar a tener conexiones custom, esto es un MCP, pero claro, esto también es un MCP. Y si ahora yo quiero acabar conectando eh, pues por ejemplo un VS Code también a mi base de datos, pues lo voy a poder hacer también mediante un MCP.

**11:55** · lo empezáis a ver de repente de tener una implementación por cada una de las necesidades que nosotros teníamos. Hemos pasado a tener un único protocolo para que nosotros en el momento que lo configuremos desde nuestro editor de código, desde nuestra IA, desde nuestro LLM, en realidad la implementación sea la misma para conectarnos a cualquier tipo de aplicación.

**12:18** · Entonces, claro, esto lo que pasa es que de repente empezamos a tener un protocolo en el que imaginemos que nuestra IA quiere leer archivos, quiere consultar bases de datos, quiere enviar un mensaje desde Slack, quiere crear una ISU en GitHub, quiere eh leer los datos de mi newsletter, que es el caso que vamos a acabar montando. Sin un MCP necesitamos escribir x integraciones diferentes.

**12:45** · En cambio, con un MCP, cualquier cliente de inteligencia artificial es compatible y se puede usar indistintamente sin modificar absolutamente nada. Entonces, de repente ahora tenemos todos estos MCPs que lo que tienen nada, es un protocolo Jason por aquí por el medio.

### Arquitectura

**13:11** · Es un Jason RPC. Es decir, tampoco os preocupéis demasiado, pero sin más es que tenemos un estándar creando otro estándar. Y claro, ahora aquí ya empezamos a renombrar cada uno de estos actores. Lo primero que tenemos que entender es que estos clientes que nosotros tenemos es lo que se le llamaría el host, ¿okay?

**13:35** · Y después las herramientas en realidad es lo que nosotros le llamamos el servidor, ¿vale?

**13:46** · Entonces, primero, muy importante tener esto claro. El host el host es la aplicación que nosotros usamos, Cloud, Cursor, VS Code, eh, con copilot, AGPD, lo que sea, ¿vale? Después tenemos el cliente, que es un componente dentro del host, por eso lo dejo por aquí.

**14:05** · es uno para cada server. El cliente pues sería en este caso cloud, VS Code, son los clientes diferentes y después el server, que el server es el proceso que se expone, es el proceso que expone las capacidades. ¿Qué pasa? Que en el momento que nosotros nos conectemos, y esto cuando veamos los ejemplos reales, no os preocupéis porque lo vais a ver clarísimo, pero dejarme que explique toda esta parte de teoría porque es importante, ¿vale? Porque si no después empezamos a utilizar los conectores y no entendemos bien qué está pasando detrás de todo esto.

**14:35** · Claro, ¿qué tenemos en el servidor? El servidor es el que va a exponer cada una de las capacidades, cada uno de esos procesos. Imagínate pues la base de datos, el MCP, si los desarrolladores de el MCP de la base de datos quieren exponer acciones para leer las diferentes tablas o acabar escribiéndolas o lo que sea.

**14:58** · Entonces, ahora aquí tenemos, claro, esas capacidades de terceros o incluso nosotros también podemos crear nuestros propios MCPs, que también os quiero acabar enseñando ahí un poquito el ejemplo.

**15:09** · formas de conectarnos a este transporte de datos. Vale, tenemos dos formas muy simples. Por un lado, en el caso de que nos querramos conectar a servidores locales, si yo me quiero acabar conectando a un servidor local, vamos a ponerlo aquí en amarillo, un servidor local.

**15:35** · Okay. La forma en la que nos vamos a conectar es por ese tedío, ¿vale?

**15:42** · Al final lo que estamos buscando es una forma de conectarnos de manera muy local a nuestra máquina, un server que tenemos corriendo en nuestra máquina. Lo podríamos hacer pues sin más utilizando esto y veremos cómo lo vamos a hacer.

**15:57** · Pero si nosotros lo queremos hacer pues a través de la red, a través de o hacia un servidor remoto, lo que tendremos que hacerlo es a través de HTTP, ¿vale? Nos vendremos por aquí y todo esto tendremos que conectarnos a él a través de HTTP.

**16:16** · Okay, bastante fácil. tenemos servidores locales porque montamos nosotros nuestro MCP local y nos conectamos por aquí, como estáis viendo, utilizando STD o HTTP si nos vamos a un servidor remoto. Ya está. Entender para qué es un servidor local. Los servidores locales los ponemos nosotros, los servidores remotos, MCP remotos, HTTP, pues nos dan las empresas. Claro, los locales suelen trabajar sobre nuestras propias herramientas.

**16:55** · Es decir, yo me creo un servidor MCP local para que mi propio agente de IA, mi propia IA, mi propio LM sea capaz de interactuar de una manera muy clara y transparente con cosas que yo tengo en mi máquina. Pero esta segunda parte que vemos aquí en verde es cuando otras herramientas, otras empresas que aquí lo veíamos, un proveedor de base de datos, GitHop, Figma, BH, nos acaban dando también esa información. ¿Vale?

### Primitivos

**17:24** · Teniendo claro todo esto, lo siguiente que tenemos que acabar entendiendo es cuáles son, digamos, los fundamentos primitivos de los MCPs. Lo vamos a poner por aquí muy rápido. Voy que aquí a poner primitivos.

**17:43** · ¿Qué pasa? ¿En qué se fundamenta en el momento que nosotros estamos hablando de un MCP? ¿Qué tendremos que tener en cuenta? Pues mira, es muy fácil.

**17:52** · Los MCPs en realidad son capaces de exponer tres tipos de capacidades.

**17:59** · Estos primitivos que yo le estoy llamando. ¿Qué capacidades?

**18:05** · Tools, es decir, herramientas.

**18:09** · Por otro lado, recursos.

**18:16** · O lo lo voy a poner en res de sources recursos.

**18:23** · Vale, estáis viendo aquí. Vale, y ya lo último que tenemos y ahora os voy a explicar cada uno de estos.

**18:33** · Dejarme que lo ponga aquí un poquito mejor. Y lo último son los prompts, ¿vale? Que son plantillas.

**18:43** · Vale, vamos a explicar cada uno de ellos. ¿Por qué? Porque claro, si tenemos un MCP que tiene que acabar exponiendo capacidades, en este caso, por el ejemplo que vamos hoy a ver hoy, capacidades de la plataforma donde yo tengo la newsletter y que vamos a desarrollar una aplicación por encima de mi newsletter leyendo los datos del MCP, claro, necesitamos que estas capacidades pues respondan a alguna información que tenemos del otro lado. Entonces, por un lado, ¿qué son las tools?

**19:14** · Okay, las tools al final son funciones que el LLM, nuestra IA puede ejecutar para hacer cosas. Es decir, una tools puede servir para crear, para modificar, para enviar.

**19:28** · Eh, al final el LM decide cuándo llamarlas.

**19:32** · Después, por otro lado, tenemos los recursos que vemos aquí, que los recursos son datos de modo lectura, ¿no?

**19:38** · No sirven para acabar modificando cosas.

**19:41** · Al final son archivos, registros de base de datos, documentos, métricas, algo así, ¿vale? Y los prompts, la las plantillas que os digo aquí en último caso, al final son tareas definidas que expone el server para estandarizar operaciones, para reducir eh la carga de

**19:57** · tokens, de los errores, bueno, h diferentes capacidades, las más habituales tools y recursos, pero aún así lo ideal es que en el momento que os metáis en serio con los MCPs, pues aprendáis a utilizar un poquito cada una de ellas, porque es posible que igual las tenéis que utilizar o igual también las tenéis que acabar creando. Por daros una analogía, las tools son como los verbos del MCP, hacen cosas, ¿no?

**20:24** · Los recursos son como los sustantivos, la información que ya existe y los prompts pues no dejan de ser como una especie de recetas, ¿no? Pasos que ya son como repetibles. Okay. Bueno, más o menos espero que se entienda eh todo esto.

### Conexión a un MCP existente

**20:43** · Vamos ya a lo que nos importa. Vamos a conectarnos a un MCP. Vamos a empezar a entender qué es esto de los MCPs y cómo nos podemos empezar a conectar. Yo os decía que os quería poner un ejemplo relacionado con mi newsletter, ¿okay?

**21:00** · Que os dejé por ahí el enlace para crearos la vuestra. Em, o incluso si os queréis suscribir a la mía, que ya os decía por aquí que era newsletter.moure.d, ¿vale?

**21:12** · cada plataforma y yo os voy a poner un ejemplo, pero entender que igual que vamos a encontrar documentación de Behive, que es nada la plataforma donde yo tengo alojada la newsletter, si tú quisieras encontrar el MCP de Supabase de las bases de datos, tiene MCP.

**21:34** · Si tú quieres acabar encontrando el MCP de GitHub, tiene el MCP. el de eh Stripe, el de Notion, el de Figma, lo que están haciendo ahora todas las grandes compañías de producto es acabar creando sus propios MCPs. ¿Por qué?

**21:52** · Porque como ahora casi todo lo que estamos desarrollando ya lo hacemos a través de LM con inteligencia artificial, pues ellos nos están dando diferentes mecanismos para ayudarnos a que nuestra base de código, nuestro sistema de desarrollo, nuestro ID, nuestro editor de código, nuestro agente sea capaz de conectarse a las herramientas de terceros que nosotros utilizamos.

**22:18** · No quiero explicarlo como una API, pero entender un concepto más o menos semejante. Es decir, tú ahora mismo si querías acceder de manera controlada a una herramienta de terceros, lo hacías a través de una API. Pues ahora si queremos que nuestra IA acceda a una herramienta de terceros de manera controlada, lo hacemos a través de un MCP. No se construye igual que una API, ni de broma.

**22:44** · El protocolo no es el mismo, la concepción no es la misma, pero entender que es una especie de normas para acabar conectándonos de manera segura y sobre todo de manera estandarizada. ¿Okay? ¿Qué pasa? Que yo ahora mismo quiero, por ejemplo, conectarme al MCP de mi newsletter.

**23:06** · Dejarme que venga por aquí y diga, "Ostras, pues vamos a buscar la documentación. ¿Dónde tenemos la documentación?" Yo lo que os recomiendo es que sin más, si en este caso para mí lo que yo quiero acabar buscando es el MCP de BHV, pues yo pongo Behive MCP y ya vemos que tenemos aquí un par de entradas. Hacer esto porque lo vais a encontrar en la documentación.

**23:28** · Mira, una entrada en su blog donde nos van a acabar explicando pues qué nos hace este MCP, tenemos aquí el lanzamiento, cómo lo conectamos, para qué nos sirve. ya nos está contando aquí un poquito la película. ¿Qué más tenemos? Un getting started, es decir, todos los MCPs cumplen un estándar. Es decir, todos los MCPs la manera de conectarlos es muy muy parecida, pero aún así vamos a encontrar documentación de cada una de las empresas, de cada una de las herramientas, de cada una de las aplicaciones para decirnos cómo conectar esto.

**24:00** · Veremos diferentes ejemplos ahora, pero fíjate que aquí, por ejemplo, el MCP de BH me dice, "Esto es lo que tienes que hacer para conectarlo a Cloud." Y si quieres a Clock Code, es esto. Y si quieres, uy, perdón, si quieres a Cursor tienes que hacer esto.

**24:14** · Si quieres a Codex, tienes que hacer esto. Vamos a ver diferentes ejemplos para que entendáis cómo conectaros a un MCP, a cualquier MCP, de manera sers simple, aunque sean realmente aplicaciones o confecciones diferentes.

**24:28** · Fijaos que también en este caso yo aquí me tenía guardada la documentación. que queréis profundizar más, por supuesto.

**24:35** · ¿Cómo acceder al MCP de BHI para conectarte con tus herramientas de inteligencia artificial? Aquí nos cuenta todo, nos dice diferentes ideas, diferentes maneras de utilizarlo. Bueno, documentación, documentación y más documentación. Vamos a lo importante que es, ¿y cómo puedo hacer yo para conectarme a un MCP?

**24:57** · Vamos a pensar que hay como dos grandes bloques de tipos de herramientas desde los que yo me puedo conectar a un MCP.

**25:04** · Lo primero son herramientas más estilo chatbot, como podemos tener la herramienta de Cloud Desktop, es decir, una herramienta que yo me descargo.

**25:17** · Bueno, supongo que todo el mundo más o menos conoce Cloud. Eh, tú te puedes descargar esta aplicación. Es un chatbot donde yo le puedo empezar a hacer preguntas, pero sin más. Es decir, me conecto al modelo que sea. Igual que tenemos esta aplicación, tenemos la de Gemini, tenemos la de Chat GPT, etcétera, como todas. Esto no es una clase para aprender a utilizar este tipo de aplicaciones sin más, pero bueno, seleccionas el modelo que quieres y al final tú le vas escribiendo y ya está.

**25:45** · Es decir, esto no tiene mucho más misterio. Yo ahora, imagínate que digo, e, sácame, pues no lo sé, las el top cinco newsletter que he enviado.

**26:02** · Esto podría tener sentido, ¿verdad?

**26:05** · Claro, es una información que yo es posible que le quiera acabar consultando a mi propio chatbot, a mi propia IA.

**26:14** · porque me ayuda a desarrollar o porque yo quiero esa información. Y ahora llévatelo a otra aplicación, a Figma, a Notion, a Stripe, lo que sea.

**26:24** · Yo, imagínate que estoy desarrollando, estoy interactuando, estoy buscando información y quiero obtener esa información. ¿Cómo lo hemos hecho toda la vida? Pues yo me iría a mi aplicación sin más y diría, bueno, pues voy a ver a ver qué métricas hay aquí. Vamos a ver cómo trabajar con ellas o lo que sea.

**26:42** · Pero claro, ahora en el momento que ya empezamos a interactuar todo a través de chats esta información, estaría guay que el propio cloud, en este caso, aún así recordar el esquema. Esto es compatible con todos los modelos de IA y todas las herramientas del mundo. Yo voy haceros un par de ejemplos para que entendáis cómo conectarlos a un MCP desde un editor de código y desde una herramienta externa. Aún así, lo volvemos a ver.

**27:16** · Aquí nos da, y esto nos lo van a dar todas las aplicaciones, las diferentes instrucciones para hacerlo desde las diferentes herramientas que solemos utilizar en este caso para desarrollar.

**27:30** · Fijaos lo que me dice aquí. Cloud. Me quiero conectar desde cloud. Me dice, "Ey, desde cloud de esto." Te vas a settings connector y le metes un connector custom y le metes esta URL.

**27:43** · \[ \_\_ \] pues vamos a ver un poco cuál es la filosofía de todo esto. Me voy a cloud, me voy a settings, me voy a connectors.

**27:52** · Lo vuelvo a repetir porque sé que esto se pregunta mucho. que utilizáis otra aplicación, buscar cómo meterle un MCP, que después cuando yo os hago un ejemplo con el editor de código, que utilizáis otro editor de código, a ver, hay decenas y decenas ahora mismo, no lo podemos hacer con todas, pero entender que si la herramienta soporta MCPs, va a tener unas opciones para conectar el MCP y el editor de código va a tener también unas opciones para acabar conectándote al MCP. Fíjate lo que va a pasar aquí.

**28:28** · Me dice, "Bueno, ya veis que hasta hay diferentes conectores que ya me está como sugiriendo.

**28:34** · GitHob, Gmail, Google Calendar, Google Drive, entendemos de sobra ya lo que es un MCP. ¿Cómo yo le podría conectar GitHo o mi Gmail o el Google Calendar o lo que sea para que así en este caso la herramienta de cloud yo le pudiera preguntar cosas sobre mi GitHob, sobre mi Gmail, sobre mi Google Calendar? Pero claro, aquí no tenemos el de BHV, pues me dice, mete un conector custom. ¿Qué nombre le pongo? Pues BH.

**29:01** · ¿Cuál es la URL? La que hemos visto la documentación. Y le voy a dar aquí a añadir. Fíjate, ya tengo un conector custom, un MCP custom creado. En el momento que yo he realizado la conexión, lo que yo puedo hacer es eliminarlo o conectarme. Le voy a dar a conectar.

**29:21** · Fijaos lo que va a pasar ahora. Se me va a abrir la página de autenticación, en este caso, de BHI, para darle permiso a la herramienta en concreto desde la que yo estoy intentando hacer la conexión. ¿Cuál es el LM? La herramienta, la aplicación. Pues en este caso cloud. Y me dice, "Ey, ¿quieres darle acceso? si no estuvieras logueado, te pediría hacer el login o lo que sea.

**29:46** · Y yo le digo, "Mira, quiero dejar leer acces e leer datos, pero también escribirlos." Aún así, en esta versión aún no permite escribir, pero yo le doy los permisos que deseo y le digo, "Okay, ya está, perfecto, conéctate."

**30:01** · Dejamos esto y ahora me dice, "Ey, ábrete la aplicación que la conexión ya se ha hecho." Volvemos por aquí, volvemos a la aplicación de Cloud y vemos que ahora ya está conectado porque ya lo que nos dice es configurar.

**30:17** · Okay, pues vamos a ver qué es esto de configurar. Rapidísimo lo vamos a entender. Os dije que el MCP lo que está haciendo es darnos un acceso controlado a esa herramienta. Fíjate qué tenemos aquí. Todas las operaciones que al final tú puedes decidir si permites hacer todas o algunas permites que sí, otras que no. No importa.

**30:43** · Fijaos. operaciones, obtener el autor, obtener la automatización, obtener el contenido del email de la automatización. Vamos a seguir bajando.

**30:53** · Listar autores, eh listar las respuestas de las encuestas, eh listar a los suscriptores. ¿Quién me da estas operaciones? Estas operaciones me las da la gente de BHVE a través de su MCP.

**31:10** · Ellos han expuesto un servidor MCP en remoto. Yo me conecto a él, me autentico y aquí tenemos 51 rezonely tools. Me dice que yo tengo. Ya está. Me han dado mecanismos para poder atacar a toda esta información. ¿Cómo funciona todo esto?

**31:31** · Vais a ver que es facilísimo. ¿Habéis visto que yo ya estaba conectado a este MCP desde los conectores?

**31:40** · Vemos que podría desconectarme, pero si ya me aparece aquí el configurar es que yo estoy conectado. Fíjate ahora lo que voy a hacer yo desde mi chatbot.

**31:53** · Dime las top CCO newsletter.

**32:01** · Lo voy a lanzar así sin nada más.

**32:05** · dice, "Te ayuda a buscar las tal y me dice, uy, ¿en qué te interesa centrar?"

**32:10** · No, claro. ¿Y ahora qué me va a hacer?

**32:13** · Me va a empezar a buscar newsletter eh genéricas. Pero vamos a intentar ayudarle un poquito más. Ahora voy a decirle, dime las cinco newsletter que mejor han funcionado en mi BHIVE.

**32:40** · A ver qué pasa.

**32:42** · Voy a consultar tu cuenta de behive para ver el rendimiento. Vamos a listar qué está haciendo. Ey, loading tools.

**32:51** · A ver qué nos cuenta. List publications.

**32:54** · List post.

**32:56** · ¿Qué está haciendo sin que yo le haya dicho algo como supercreto?

**33:04** · Él tiene un MCP de BH.

**33:07** · Él sabe que SMCP se conecta básicamente a mi cuenta de BHV. ¿Qué empieza a hacer automáticamente?

**33:15** · Empieza por debajo a llamar a las operaciones que tienes expuestas el MCP para conectarse directamente al la información, a los datos de mi propia newsletter. Fíjate, max clicks totales. Pues le voy a decir, no sé, eh, mayor tasa de apertura. de los últimos 3 meses. Esto me lo va haciendo eh el propio agente y me dice, "Voy a analizar." Lo tiene clarísimo. Y ya vemos que aquí get post stats, que está lanzando una request.

**33:50** · Estas request en realidad ya son request que está haciendo al propio MCP y gracias a eso se va sacando la información. Claro, imagínate lo costoso que sería tener que hacer esto a mano. Y ahora podemos mezclar toda la potencia de la inteligencia artificial, toda la potencia de los LMS con herramientas de terceros. Y esto, por ejemplo, para un chat, porque yo estoy aquí haciendo consultas sin más.

**34:19** · Y todo esto, pues bueno, le dejamos el tiempo que consulte los datos, que al final los trabaje y todas estas request más todo lo que haga el propio LM nos acabará dando diferente información, diferentes resultados. Esta es como la primera forma de conectar un MCP, pero claro, nosotros ahora podemos pensar, Brce, pero yo con esto es que tampoco desarrollo, tampoco es mi entorno habitual, pero bueno, entendamos que MCPs afecta a cualquier conexión de IA. Pasemos a otro ejemplo.

**34:49** · Imagínate que ahora lo que yo quiero hacer es conectar un MCP desde un editor de código. Por supuesto, en este caso que estamos con eh Clou, pues también tenemos CLC y tenemos estas aplicaciones de escritorio donde ya podemos ir haciendo cosas. Pero bueno, vamos a intentar poner un ejemplo un poquito más real a lo que nosotros solemos entender como entornos de desarrollo, que igual ya es tener, pues en este caso Visual Studio Code. Os voy a poner Visual Studio Code, pero por un único motivo.

**35:24** · El motivo es que en realidad sabéis que la gran mayoría de editores de código que tenemos ahora con inteligencia artificial, Google Antigravity, Cursor son forks de Visual Studio Code, es decir, que todos de base funcionan muy muy muy parecidos. ¿Okay?

**35:40** · Entonces, ¿qué os quiero decir? que si tenéis o si entendéis el mecanismo de conectar un MCP desde un editor de código, vais a entenderlo desde el resto de editores de código, porque al final por debajo no dejamos de tener un fichero de configuración también s s simple. Vale, vamos a venir por aquí. Esto es Ghajopilot sin más, pero según la herramienta habrá pequeñas variaciones para hacer la conexión del MCP.

**36:09** · Eh, si lo queréis hacer fácil, bueno, suele haber ciertos atajos, ya sabéis, el control alt p command shift p según el sistema operativo para abrir pues esta paleta de comandos. Y por ejemplo, hay una de las opciones que se llama adserver, es decir, yo quiero acabar añadiendo un servidor MCP.

**36:32** · Y fijaos aquí lo veis clarísimo, cómo tenéis un comando este dío. ¿Veis aquí? eh ejecuta un comando en local que implementa el protocolo MCP o se conecta a un servidor HTTP remoto que implementa el protocolo MCP.

**36:52** · ¿Cómo nos queremos conectar? Nos queremos conectar a un servidor remoto, a una aplicación de terceros. Entonces, ¿qué voy a acabar haciendo yo? Pues seleccionando este, ¿vale?, el protocolo http. ¿Cómo nos teníamos que conectar?

**37:06** · Fíjate que aquí sería casi lo mismo que cloud, pero imagínate en cursor hasta me da aquí una información, en Codex también una información. Si lo queremos ejecutar, pues bueno, con este comando dependería. Me voy a ir a otros porque esto es como el estándar. Nosotros siempre que nos queremos conectar a un servidor MCPR remoto, tenemos la URL del servidor. Entonces yo, sin más vengo por aquí y me dice URL del servidor es esta la que me proporciona la aplicación. Y ahora me dice que le dé un identificador. Le voy a poner un nombre.

**37:35** · Behive.

**37:36** · Pulso enter y digo, "¿Y cómo quieres acabar instalando este MCP? ¿Lo quieres acabar instalando de manera global?", es decir, para todos los proyectos que utilices, desde Visual Studio Code o para el workspace. Mira, yo me he creado un proyecto que se llama Hello MCP. Aquí sin más. Lo que yo os recomiendo es no creéis o no instaléis MCPs a nivel global. ¿Por qué? Porque si no después cuando utilicéis un LM vais a tener un montón de MCPs que igual ese proyecto en concreto no necesita conectarse a ellos.

**38:09** · Entonces no tiene tampoco ningún sentido. En este caso le voy a decir, "Hala, ya está. Aquí tenemos un servidor conectado desde nuestra máquina, en este caso, desde este proyecto. Fíjate lo que vamos a ver aquí. ¿Qué tenemos aquí?

**38:27** · una carpeta que se ha creado punto VScode. Ya sabéis que esto igual si estáis en cursor es una carpeta cursor.

**38:35** · Ya sabéis que cada eh ID tiene como sus ficheros de configuración propios. Pero, ¿sabéis lo que va a ser estándar?

**38:42** · Prácticamente esto, el fichero de configuración que no deja de ser un JSON. Aquí tenemos sin más pues nada un mcp.jonjong que tiene la configuración. Ya está, se acabó. Hemos configurado el MCP.

**38:57** · ¿Qué tuvimos que hacer desde cloud antes? pues conectarnos al MCP, ¿no?

**39:04** · Una de las formas más simples, si os vais a las extensiones, las extensiones de vuestro ID, si tenéis diferentes MCPs. Aquí yo tenía unos MCPs globales creados porque utilizo mucho el de Supabase, el de GitHop, pero bueno, en este caso veis que en este proyecto tengo un MCP solo a nivel del workspace, solo a nivel de este proyecto. ¿Qué me va a decir aquí? Pues por supuesto también la posibilidad de arrancar el server, pararlo. Imagínate que yo lo paro. Tengo la opción de arrancarlo. En el momento que me arranco.

**39:37** · Aquí lo tenemos. Se está autorizando.

**39:43** · Ey, descubiertas 51 tools.

**39:47** · ¿Os suena esto algo? Bueno, os suena a que eran todas las operaciones que estaban expuestas a través del MCP.

**39:56** · ¿Por qué a mí no me ha saltado lo out?

**39:59** · Porque yo ya estaba autenticado previamente. Si no, ¿qué os va a hacer?

**40:03** · ¿Recordáis cuando me llevó al explorador y me dijo, "Ey, tienes que autorizar aquí la conexión?" No sé qué. Sería exactamente lo mismo. Fíjate que en el momento que ya estoy aquí, lo voy a cerrar, ¿vale? Y vamos a hacer algo parecido a lo que hicimos antes. Fíjate, aquí lo dejé corriendo. Esto es Cloud, ¿no? Me empezó a lanzar las operaciones del MCP y aquí me dijo, "Ey, pues mira, la que más open rate tuvo fue esta. Te vas a perder eh tu beca. La segunda fue esta, ya estoy harto.

**40:33** · La segunda, la del máster de desarrollo con IA, esto curso gratis más certificado. Bueno, ¿de dónde ha sacado esta información? Es que me la ha sacado de mi plataforma, pero la está trabajando en el IDE. y la está utilizando y está accediendo a ella de manera segura a través de mi MCP. Claro, si yo ahora vengo por aquí y le pregunto, pues no lo sé, ¿qué le podíamos acabar preguntando para ver si de verdad tiene acceso a este conector?

**41:06** · Pues le podemos poner algo muy simple.

**41:09** · Dime el título de mi última newsletter.

**41:19** · A ver si esto funciona o no. Vamos a ver si de verdad se está conectando o no al MCP. Fíjate que ya empezamos a ver algo aquí cuando e yo no le he dicho en ningún momento que mi newsletter las de Big, pero obviamente tiene un MCP y entonces como esto ya está cargado dentro del contexto del LLM, en este caso aquí copilot o el que tú estés utilizando desde tu editor, ya dice, "Ey, yo sé que tengo una conexión a un MCP para una newsletter."

**41:54** · Igual si me están hablando de ella es porque yo quiero acabar accediendo a él.

**41:57** · Y fíjate, aquí lo tenemos. Me empieza a hacer búsqueda y empieza a correr.

**42:04** · Fíjate, list publications. ¿Qué es esto?

**42:07** · Una operación que expone el MCP.

**42:10** · Entonces, lista las publicaciones, lista los posts y dice, "Tu última newsletter es tutorial completado, no funciona.

**42:16** · Publicada el 28 de abril."

**42:19** · Ya está, ya tenemos nuestro editor de código, nuestro ID en este caso también conectado al MCP. Esto es igual en todos. Habrá pequeña diferencia que si el fichero cambia algo, que si la opción cambia algo, pero la manera de conectaros desde cualquier editor de código o desde cualquier aplicación, en este caso de escritorio como era la de Cloud, es prácticamente la misma. es una opción donde nosotros vamos a poder meter la URL, nos vamos a tener que autenticar y a correr.

**42:47** · Fíjate que en este caso, como estamos en un chat que tiene pues el acceso a en este caso estas tools, vamos a ver también entre las opciones algo también muy claro.

**43:00** · ¿Veis esta opción que me dice por aquí?

**43:02** · Estos son las tools que yo tengo configuradas. Fíjate que dentro de todo lo que yo tengo configurado, mira, aquí están las tools. Bueno, pues fíjate que yo tenía aquí el MCP de Kidop, también el de Supabase, pero también tengo el de Bit que he conectado aquí. ¿Y qué tenemos aquí? Pues todas esas tools, todas esas herramientas que están basadas en operaciones que yo puedo acabar invocando todas.

**43:27** · Pues bueno, más de lo mismo, lo que ya vimos antes de cloud, eh, list post templates, pues bueno, lista las templates que existen para una publicación y todo esto sí yo puedo llamarlas a mano. Yo podría venir aquí y decir list. Fíjate que lo hago en este caso con almohadilla. Dependiendo de la gente, dependiendo de la aplicación, pues igual es almohadilla, igual es barra.

**43:51** · Bueno, se tiende a ser un estándar, pero como ya está dentro del contexto de este agente, fíjate, si yo llamo a listar autores, ¿qué creéis que va a hacer? Va a llamar a la operación del MCP de de BHI para listar autores. Se va a conectar por aquí y me va a decir, "Pum, mi newsletter tiene un autor que es Brce Mour y me saca por aquí la información."

**44:20** · ¿Lo veis? Ya tenemos absolutamente todo.

### Proyecto práctico

**44:24** · Esto ya está conectado, ya vemos para lo que sirve un MCP. Pero ahora, claro, si lo utilizamos para esta información, un poco de lectura de información, ya vemos que es muchísimo más rápido porque podemos empezar a trabajar con nuestros datos muy muy rápido. Pero, ¿qué sería lo siguiente? Para mí intentar montar un caso práctico. Es decir, ya tenemos el MCP configurado de BHVE. ¿Por qué no utilizamos la información del MCP de BHIVE para acabar creando, por ejemplo, una aplicación?

**44:57** · Ya que estamos aquí, pues sería algo que podríamos intentar aprovechar. Así que ya que tenemos esta plataforma de newsletter, vamos a intentar crear una aplicación sobre esta plataforma de newsletter utilizando el MCP. Entendamos cuál sería el concepto sin MCP. Yo quiero crear una aplicación. Vamos a plantear, por ejemplo, una aplicación que sea un dashboard que visualice, que nos sirva para ver el top 10 newsletter que he enviado.

**45:30** · Claro, eso es una información que, por ejemplo, Behive no me da.

**45:36** · Yo me puedo ir a la plataforma, puedo empezar a buscar ahí todas las newletter que yo he enviado, pero en este caso para mí es muy importante pues también tener una aplicación que quiero desarrollar desarrollar yo con funcionalidades que en este caso no tiene mi newsletter. Claro, ahora volvamos a lo mismo. Yo ahora quiero acabar mostrando esos datos, pero pensemos que no existieran los MCPs.

**46:05** · Pues igual lo podría hacer desde una API, ¿okay? Pero desde una API tendría información igual muy concreta, pero no tendría ese contexto general donde yo le puedo decir, "Ey, hm, el LM de turno, lee toda la información con todas las operaciones que tú tienes disponibles del MCP. Utiliza las que te apetezcan y las que necesites y obtén la información de las top 10 newsletter eh, con las métricas más importantes.

**46:38** · Imagínate. Vamos a esto. Voy a venir por aquí y voy a decir, em, crea un Jason con con el top 10 newsletter que he enviado y sus métricas más importantes.

**47:00** · Voy a poner esto, lo voy a lanzar y aquí lo voy a dejar. ¿Por qué? porque ya se va a encargar él de invocar, pues mira, list post, no sé qué e irá haciendo lo que le dé la gana. Pero ahora con esta información, ¿qué voy a hacer? Con esta información voy a acabar creando una aplicación porque ahora que ya tengo esta información que me la va a dar el propio MCP y que yo he conseguido esta

**47:25** · información de manera segura y sobre todo transparente, sin pasar también mucho trabajo, porque esta conexión ya existe y yo podría trabajar con ella. de la manera que me dé la gana. Vamos a dejar que trabaje, vamos dejar que obtenga todo esto. Vamos a ver cómo también crea por aquí ese fichero que parece que ya lo ha hecho. Fijaos.

**47:49** · Fíjate, he creado este Jason con las 10 métricas más importantes, ba de las newsletter publicadas. Fíjate un poco lo que tenemos para ver qué nos ha creado, ¿no?

**48:01** · Ranking 1, dos y vemos aquí, pues, mira, las veces que sea diferentes métricas, las que ha decidido. Obviamente como yo tengo el MCP, me podría conectar y actualizar estas métricas cuando me diera la gana obtener nuevas métricas o lo que fuera. No importa. Pero bueno, que ya nos ha creado un Jason, que esto es información real, sin que yo realmente tuviera que acceder a ella a mano, todo a través de el propio LLM.

**48:28** · Ahora que ya tengo esto, voy a cambiar el modo agente a modo plan porque le voy a pedir hacer una aplicación. Obviamente esto no va a ser un desarrollo profesional ni nada. Os quiero enseñar algo rápido, pero para que entendáis también cómo empezamos a aprovechar toda esta información, en este caso del MCP de BHD. Okay.Ok. Crea un dashboard webre

**48:56** · el top newsletter que tienes en el Jason.

**49:09** · Vale, se lo voy a poner así un poco que tire millas, obviamente, ya sabéis, habría que que crear ficheros de reglas agents.md, specdrive development, intentar redefinir cada uno de los pasos que tenemos que dar. Bueno, yo en mi caso, como os quiero montar un dashboard muy muy rápido, se lo pido así a muerte.

**49:32** · Os hago aquí un by coding supercutre, pero para que entendamos también en el momento que somos capaces de tener los MCPs, como solo con un MCP yo voy a crear una web con información real, pero imagínate que ahora le conecto también el MCP de Supase, que lo veíamos antes de la base de datos, el MCP de GitHub.

**49:52** · Pues yo podría utilizar el MCP en general de todos esos para decirle, "Ey, lee el MCP de BHve, quédate con la información y ahora, según el modelo de tablas de bases de datos del esquema que he montado en Supase, modela todo eso para acabar persistiéndolo en mi base de datos y después teniendo en cuenta cuál es la estructura que yo he montado en GitHub, no sé qué, pues crea la versión, lo que sea realmente.

**50:18** · Entonces, claro, le empezamos a meter diferentes piezas a nuestra suit de desarrollo, que en este caso pues sería el editor sin más, pero de repente empieza a tener contexto de todo lo que va mucho más allá de únicamente, en este caso, yo diría, lo que nosotros sí o sí tenemos control. En este caso nos vamos a estos sistemas de terceros, ¿okay?

**50:47** · Así que bueno, entendamos que ahora tengo el agente que ha levantado otro subagente para crear el dashboard en HTML. Espero que me haga algo muy simple y lo y que lo podamos saber ver más o menos fácil. Pero también mientras se crea vamos a pensar eh datos prácticos que podríamos lanzar contra esta eh contra este MCP de Nan Letter.

**51:12** · Le podríamos decir que me analizara los usuarios más activos, que revisara los últimos días de la newsletter y que me dijera si hay casos extraños de gente que, yo que sé, se está desuscribiendo, eh, que auditaria, que auditara mi propia newsletter, la información de mi newsletter, a ver si es mejor o peor, yo que sé, lo que nos diera un poquito la gana. En realidad, todo esto lo podemos acabar llevando donde nos dé la gana, ¿vale?

**51:40** · Así que vamos a dejar que todo esto se crea después de esto, en el momento que veamos el ejemplo, a ver si nos crea aquí, que ya estoy viendo.

**51:48** · Bueno, creando un dashboard HTML.

**51:50** · Esperemos que cuando finalice nos lo meta por aquí y vemos un poquito el resultado. A ver si no nos la ha liado mucho por lo que vemos. Ta ta ta.

**52:00** · A ver, dale ta. Aquí tienes el código HTML completo. Guarda un dashboard junto como vamos a meterle por aquí el autopilot.

**52:18** · Vale, le voy a decir que cree todo y que se nos deje de tonterías porque nos está creando aquí toda la información. Así que vamos a darle solo unos minutos para que empiece a montar todo y ahora ya la propia implementación.

**52:35** · Al margen de todo lo que nos está contando por aquí, esperemos que ahora ya sea capaz de implementarlo y de meterlo, porque yo al final no le di ningún permiso y por eso me estaba actuando más como, "Ey, aquí tienes la información, pero después tú lo puedes acabar creando como tú quieras, ¿vale?"

**52:50** · Entonces, bueno, vamos a darle aquí unos minutos y veamos a ver si nos lo va a meter. Ta ta ta.

**52:59** · Vale.

**53:02** · Okay.

**53:04** · Vale, ya vemos que por aquí nos lo está creando. Ya lo veis. Guay, porque tampoco quería que me creara como una super aplicación ni me hiciera algo muy muy raro. Lo único que necesitaba es que sin más pudiéramos ver estos datos reflejados. Mira, ya tenemos esto por aquí.

**53:25** · Vale.

**53:28** · Okay. Servidor local activo. Vamos a irnos por aquí.

**53:34** · Y bueno, pues oye, nada mal. Aquí vemos un dashboard que nos ha creado. Claro, esto es información que en este caso yo no he trabajado nada, pero toda esta información es real y este top de newsletter es la real que la hemos sacado del MCP.

**53:50** · Bueno, es un dashboard sers simple de top 10 envíos, pero ya veis que en el momento que tenemos esta información después yo ya me puedo poner a desarrollar de una manera donde esa información que yo tengo en un sistema de terceros encaje perfectamente con el código que yo voy a acabar haciendo y ahí eso ya abrirlo al tipo de MCP al que vosotros querráis acabar conectando, ¿vale? Entonces, para eso, ya veis que los MCPs tienen todo el sentido del mundo.

### Creación de un MCP

**54:19** · Ahora que ya hemos visto cómo crear un código basado en un MCP al que nos estbamos estábamos conectando en remoto, vamos a ver otro caso también muy práctico, que es y cómo podemos crear nosotros mismos un MCP.

**54:36** · Esto también es muy importante. Claro, tú puedes necesitar acceder a herramientas de terceros, pero y si yo quiero crear mi propio MCP para acceder desde mi LLM, desde mi IA a también diferente información, pues mira, ya que pues bueno, teníamos todo esto, incluso vimos cómo creó el servidor con Python y todo, e, pues vamos a crearlo con Python. Sin más, me voy a crear un nuevo fichero.

**55:06** · También entender que aquí hay algo muy importante, que es que existen SDC oficiales para poder implementar MCPs locales.

**55:18** · Okay, lo tenéis en Python, en TypeScript, en JavaScript, en CSARP, en Java, en Rust.

**55:27** · Es decir, empezáis a buscar sin más el SDK del lenguaje que vosotros utilicéis para crear un MCP. Y ya está. Yo voy a crear aquí my MCP, lo voy a crear un fichero en Python sin más. Aquí todo simple. y vamos a ver cómo podemos acabar implementando este MCP. Okay.

**55:57** · Mira, fijaos lo primero que tenemos que acabar entendiendo, si vosotros no fueris capaz de encontrarlo o lo que sea, mira, MCP Python, fíjate, MCP Python SDK Model Contest Protocol. Aquí lo tenéis.

**56:20** · Tenemos a la fundación de código abierto que ha generado el estándar del model protocol. Y por supuesto, dentro de esto, dentro de los repositorios o incluso ya en su documentación principal nos dice, "Ey, ¿quieres empezar a crear un MCP?" Aquí tienes los SDK oficiales, el de Python, el de Java, el de Colin, el de Sharp, el lenguaje que te dé a ti la gana.

**56:42** · En este caso, el de Python, ¿qué vamos a encontrar? pues también toda la información, también cómo crearlo, cómo arrancarlo, cómo inicializarlo, cómo instalarlo, lo que tú quieras. Sin más, vamos a hacerlo también muy rápido para no rayarnos y para que más o menos esto nos quede fino. Para que no quede muy loco, voy a crear nada, un entorno virtual.

**57:07** · Esto, eh, ya sabéis, esto no es tanto la clase de programación como tal. sino que estamos entendiendo el concepto de MCP. Yo me voy a crear un entorno virtual con Python, ya está. Es decir, un entorno virtual al final no deja de ser una burbuja que nosotros tenemos para empezar a trabajar de una manera pues más segura para instalar las dependencias, igual que seguramente conocéis npm o algo parecido, que al final tenéis el contexto de todo lo que vosotros queréis acabar instalando.

**57:38** · Y yo ahora mismo, pues nada, si me voy aquí y esto ahora lo permite también hacer e Visual Studio Code, pero yo puedo venir venir por aquí y decir, "Ey, quiero crear un entorno virtual." Y entonces ese entorno virtual pues lo voy a crear con la última versión de Python que tengo yo. En este caso vemos que ya se me ha creado por aquí seguramente la carpeta del entorno virtual. Y si yo ahora me vengo por aquí también a la gestión de los entornos virtuales, pues le puedo decir, "Ey, utiliza este por defecto." Y ya está. ¿Vale?

**58:08** · Y si aún queremos eh hacerlo desde el desde la gente, le dices, "Créame un entorno virtual o lo que sea, no importa realmente. Sin más, vosotros venís por aquí y ya en el momento que lo tenéis lo empezáis a arrancar.

**58:31** · ¿Vale?

**58:33** · Bien, activate y arrancamos el entorno virtual para que ya todo esté aquí porque yo ahora lo que quiero hacer es instalar la dependencia para poder crear un MCP. Vale, un MCP local. Pipp install MCP. Y con esto me acabo instalando la dependencia. La vais a ver por aquí.

**58:51** · Dentro del VM, pues vais a tener Python y dentro de esto va a estar la dependencia del mcp. Con todo esto, en el momento que nosotros ya lo estamos utilizando, ya podemos empezar a implementar el MCP. Claro, ¿de qué manera lo implementamos? Esto es como todo. Acabamos accediendo primero a esta librería, a este módulo. En este caso ya vemos que tenemos aquí MCP.

**59:11** · Yo lo que quiero acabar montando es un servidor y este servidor lo que quiero acabar server y aquí lo que quiero acabar montando es fase MCP, ¿vale? Es un servidor muy muy simple. Y aquí simplemente lo que yo voy a hacer es acabar importando fast mcp.

**59:35** · Ya una vez tenemos esto, bueno, podemos empezar a utilizar el autocompletado. Ya vemos que nos manda inicializar todo esto. Mi server, me voy a acabar llamando o my server.

**59:46** · My server, ¿vale? Y después, en el momento que ya tenemos todo esto, pues ya empezamos a crear cada uno de los recursos. Digo, MCP, en este caso el no, que esto sería para cuando arranque. Yo quiero acabar creando una tool. Esto forma parte de los primitivos y quiero hacer eh pues una operación. Estos son las operaciones que yo voy a acabar exponiendo. Igual que cuando nos conectamos al MCP de BH vimos que teníamos diferentes operaciones.

**1:00:12** · Iba a decir hba \[risas\] decir hello world. Bueno, no lo sé. le podría acabar pasando también algo, un name y le voy a decir que es esto. Y aquí tenemos eh, hola, tal, bienvenido, bienvenido a tu primer MCP.

**1:00:37** · Por supuesto, igual que tenemos las tools, también tenemos los recursos, también tenemos un montón de cosas. Y ahora aquí, bueno, me voy a crear sin más un main para poder ejecutarlo más rápido y ya está. Okay. Vale, esto es lo que cuesta montar un MCP. Todo esto lo tenéis en la documentación oficial de todos los SDC, pero simplemente para que lo entendáis muy muy rápido. Yo ahora me creo este MCP y yo ahora lo que quiero es este MCP.

**1:01:10** · Me gustaría poder correrlo dentro de la máquina. ¿Cómo puedo hacer todo esto? Fijaos, vamos a la parte de documentación. En el momento que me decía, "Mira, así es como tú podías acabar creando, lo añadías, lo acababas instalando, incluso puedes acabar corriendo para correr el MCP.

**1:01:32** · Vemos aquí incluso un ejemplo, bla, bla, bla.

**1:01:36** · Aquí vais a tener absolutamente toda la información, pero vamos a verlo también de manera muy muy simple para entender que V es Ubicorn, que al final es un servidor que nosotros vamos a acabar levantando el local y que nosotros le podríamos acabar diciendo, "Ey, corre el MCP y te voy a decir también el nombre del fichero MCP que nosotros tenemos que acabar corriendo." Pero para eso necesitamos primero instalar, aquí lo veis, este CLI, es decir, hemos instalado el servidor, pero nosotros también necesitamos el cliente.

**1:02:05** · Sin más, yo lo voy a instalar aquí muy rápido y empezamos a tirar millas. Ya está. En el momento que tenemos todo esto, me dice, "Ey, puedes empezar a correr las development tools", es decir, las herramientas de desarrollo de cada uno de estos MCPs. Nosotros vamos a hacerlo un poquito mejor, que es que nosotros vamos a arrancar el servidor.

**1:02:24** · No sé si incluso hasta lo pone aquí, pero fíjate, me dice, "Ey, la manera que tú tienes de arrancar el servidor, pues puede ser con esto, ti ti, con para cloud, para npx, con lo que tú quieras, pero sin más. Si tú lo que quieres acabar corriendo, le puedes acabar marcando el RAM del MCP que tú quieres." Pues vamos a ver cómo sería ese RAM, en este caso del MCP.

**1:02:51** · Vamos a verlo muy rápido para que veáis cómo lo inicializamos de una forma también pues bastante simple. Voy a correr V r mp y en este caso, ¿cuál es el MCP que yo quiero acabar? Incluso le podríamos meter el flag de desarrollo, pero bueno, se lo puedo poner si quiero. Pero, ¿cómo se llama mi MCP? My MCP. Voy a lanzar esto a ver qué pasa. Vemos que esto pues ey, acaba de arrancarse. Fíjate.

**1:03:18** · Lo voy a meter aquí en el otro explorador para que lo veamos muy claros, pero veis que ya se ha arrancado una interfaz que es el inspector de MCPs que nosotros hemos arrancado en concreto con este comando que vemos el comando V.

**1:03:42** · Y aquí lo tenemos.

**1:03:43** · Wi mcp mcp r no sé qué tal todo esto.

**1:03:48** · ¿Qué va a pasar? Que en el momento que yo he accedido a mi MCP me voy a conectar a ver qué tenemos. Tenemos recursos. Tenemos algo. Vamos a ver la lista. Claro. Es decir, yo tengo la lista, tengo los templates, tengo la diferente información, tengo los mensajes que me van saltando.

**1:04:09** · Vamos por aquí al editor.

**1:04:11** · Ey, se ha creado el cliente. Tenemos la conexión al servidor y vemos como ya podemos empezar a acceder a cada uno de ellos. Esto lo Uy, desde aquí no era, lo tenía desde Brave. Vemos como tenemos la conexión a My Server, que es el que yo había creado, y como ahora ya tenemos levantado nuestro servidor.

**1:04:33** · Vamos a ver ahora porque sí, este servidor lo tenemos aquí en este inspector, pero esto quiere decir que yo ya tengo este servidor conectado desde mi propio editor, en este caso desde Visual Studio Code, ¿no? ¿Verdad?

**1:04:57** · Yo simplemente lo he levantado, está corriendo el servidor y ya está. Vamos a ver cómo podríamos ahora mismo añadir el servidor. Fíjate que cuando yo quería añadir un nuevo servidor, teníamos servidor remoto, pero también este servidor local. Y me dice, "Ey, ¿cuál es el comando que tienes que correr pero con argumentos?" El comando que tienes que correr con argumentos, fíjate que era este V más todos estos argumentos.

**1:05:25** · Fíjate. Bueno, pues vamos a ver si somos capaces de metiéndole estos argumentos, aunque después tengamos que cambiar cosas. V, el servidor Ubicorn. Voy a lanzar todo esto. ¿Cómo le voy a llamar yo a este? Pues no sé. H, MCP test.

**1:05:46** · ¿Cómo lo voy a instalar? También a nivel de workspace.

**1:05:50** · o sorpresa en el mismo fichero de configuración del MCP donde yo tengo el de Behive. Fíjate, ahora tengo uno que yo he creado esta vez llamado MCPTs, esta vez que nos conectamos en local y que los comandos son todo esto.

**1:06:10** · Okay, no está mal, ¿verdad? Vamos a hacer algo. Vamos a desconectar el MCP que nosotros corrimos desde esta interfaz de inspección. Y ahora vamos a ir al listado de MCPs.

**1:06:23** · Ah, mira, si yo tengo uno llamado MCP test por aquí lo voy a volver a parar para que veamos en el output que nos está parando.

**1:06:34** · MCP por aquí y dejarme que ponga esto y que veamos esto. Fíjate, se ha descubierto una tool.

**1:06:48** · ¿Qué tool? Pues la que nosotros estábamos exponiendo, una tool llamada high. Volvemos ahora en este caso a nuestro agente, a nuestro LLM, a nuestra IA, a lo que a nosotros nos dé la gana.

**1:07:06** · Primero vamos a hacer una cosa, vamos a ir al estado de tools y vamos a ver que igual que yo tenía pues el de Behive, ahora tengo un MCP que se llama MCP test, que se llama high, que no le he puesto descripción.

**1:07:23** · Obviamente lo mejor sería ponerlo para indicar de qué trata. Pero ya veis que nosotros tenemos una operación que yo os puesto en mi servidor local que se llama high y podríamos intentar acceder a ella. Si yo ahora pongo aquí high. Ey, tengo una tool que se llama high y ahora voy a decir saluda a Bris.

**1:07:52** · ¿Qué va a hacer esto? Tengo levantado el MCP. Sí, está conectado al MCP que hemos creado custom. Sí, hay una operación que se llama high. Sí, si yo le digo saluda a Brce, no le estoy diciendo tal cual que tiene que llamar a esta operación y pasarle un parámetro de tipo stram que sea un nombre, no sé qué, ¿no?

**1:08:15** · Pero vemos lo que está haciendo y lo que ya está infiriendo el propio LM rang de el MCPTs, que es un servidor tal, y me dice, "Brice, bienvenido a tu MCP."

**1:08:30** · Ha corrido una operación que nosotros hemos creado custom. Ahora imagínate, tú en local tienes diferentes aplicaciones, herramientas, bases de datos, lo que quieras y quieres que tu LLM, que tu agente, que tu IA se conecte también de manera segura siguiendo unos protocolos concretos a algo que tú tienes en local, te creas tu servidor MCP y vemos como ya únicamente con tenerlo levantado el propio IDE es capaz de empezar a conectarse a él a través del agente, a través de la IA, a través del LM.

**1:09:01** · Estos conceptos de tener un MCP tanto local como un MCP remoto y todo lo que nos ayuda a que nuestro día a día desarrollando sea muchísimo, muchísimo, muchísimo más simple. Ya como último, tener muy presente todo lo que hemos visto a nivel de documentación y de recursos. Por un lado, la web oficial de MCP.

### Conclusiones y recomendaciones

**1:09:26** · Por otro lado, que vosotros en el momento que queréis instalar un MCP, os tenéis que buscar la información, en este caso, de cómo funciona el MCP de la herramienta concreta que quieres acabar utilizando. Incluso también el repo oficial de Model Contest Protocol, donde nos habla del inspector, donde nos habla de los SDK para instalarlo el que a ti te venga mejor. Okay.

**1:09:50** · Y ya con esto acabáis de meter una pata más como herramienta de desarrollo dentro del flujo de creación de aplicaciones con IA, que es esencial y que nos permite ampliar nuestro contexto y sobre todo controlarlo de una manera mucho más clara.

**1:10:10** · Así que obligatorio utilizar MCPs, entender cómo funcionan, meterlos poquito a poco en vuestro proyecto, beber de ellos y ver como vuestro desarrollo es muchísimo más ágil y crearlos en el momento que os hagan falta.

**1:10:25** · Con esto lo que os diría es que porfa, empezar ya a hacer vuestras primeras pruebas, replicar este taller con los ejemplos que queráis o con el MCP que os dé la gana. también utilizar el MCPDH, lo podéis incluso acabar probando y si no crearos vuestra newsletter que os viene muy bien, que también os dejo por ahí el enlace y empezar a enriquecer vuestro sistema de desarrollo. sin más.