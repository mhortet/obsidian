---
title: "🔥 ASÍ se crea  un MCP - CON @Achetronic"
source: "https://www.youtube.com/watch?v=tjGopRhYa4I"
author:
  - "[[Gentleman Programming]]"
published: 2025-09-17
created: 2026-06-28
description: "🚀 MCP + GO - EXTENDIENDO CLAUDE CON HERRAMIENTAS CUSTOM + @Achetronic → MCP, model context protocol, Claude, AI, Go, golang, herramientas, custom, extensiones, API, servidor, implementación, arquite"
tags:
  - "clippings"
---
![](https://www.youtube.com/watch?v=tjGopRhYa4I)

🚀 MCP + GO - EXTENDIENDO CLAUDE CON HERRAMIENTAS CUSTOM + @Achetronic  
→ MCP, model context protocol, Claude, AI, Go, golang, herramientas, custom, extensiones, API, servidor, implementación, arquitectura: Stream técnico implementando un servidor MCP en Go para extender Claude con herramientas personalizadas  
  
📯 QUÉ VAS A APRENDER  
\- \*\*Model Context Protocol\*\* - Protocolo oficial para extender AI assistants  
\- \*\*Servidor MCP en Go\*\* - Implementación completa desde cero  
\- \*\*Integración con Claude\*\* - Conectar tu servidor a Claude Desktop/Web  
\- \*\*Herramientas Custom\*\* - Crear tus propias extensiones para IA  
\- \*\*Arquitectura Escalable\*\* - Best practices para sistemas MCP en producción  
  
━━━━━━━━━━━━━━━━━━━━━  
  
🎯 MCP EN PROFUNDIDAD - IMPLEMENTACIÓN REAL  
  
1️⃣ \*\*¿QUÉ ES MCP?\*\* - Model Context Protocol es la forma oficial de extender Claude con TUS herramientas. No es solo teoría, es algo que implementás HOY y cambia cómo trabajás con IA.  
  
2️⃣ \*\*HERRAMIENTAS VS RECURSOS\*\* - Herramientas ejecutan acciones (llamar APIs, escribir archivos). Recursos proveen información (leer documentos, consultar bases de datos). Prompts son plantillas reutilizables.  
  
3️⃣ \*\*SERVIDOR MCP EN GO\*\* - Implementamos el protocolo completo: handshake, capability negotiation, tool invocation. Go es perfecto por su concurrencia nativa y deployment simple.  
  
4️⃣ \*\*INTEGRACIÓN CON CLAUDE\*\* - Configuración paso a paso en Claude Desktop. Testing de herramientas en tiempo real. Debugging cuando algo no funciona como esperás.  
  
5️⃣ \*\*CASOS DE USO REALES\*\* - Acceso a sistemas de archivos, conexión con APIs internas, integración con bases de datos, automatización de workflows. Todo controlado y seguro.  
  
6️⃣ \*\*ARQUITECTURA ESCALABLE\*\* - Clean Architecture aplicada a MCP. Separación de concerns, testability, y mantenibilidad. Porque no querés un servidor MCP que sea un quilombo.  
  
\*\*Dale que va\*\* - MCP no es complicado, es PODEROSO. La diferencia importa cuando necesitás IA que se conecte con TU ecosistema real.  
  
━━━━━━━━━━━━━━━━━━━━━  
  
📦 RECURSOS TÉCNICOS  
\- Documentación oficial MCP: https://modelcontextprotocol.io/  
\- Claude Desktop: https://claude.ai/desktop  
\- Go Documentation: https://go.dev/doc/  
\- Mi config Neovim: https://github.com/Gentleman-Programming/Gentleman.Dots  
  
━━━━━━━━━━━━━━━━━━━━━  
  
☁️ DONWEB CLOUD SERVER - SPONSOR  
Infra self-service con la mejor relación precio-potencia  
→ Escalabilidad vertical y horizontal automática  
→ Alta disponibilidad y redundancia incluida  
→ Planes exclusivos para la comunidad  
🎯 Descuentos exclusivos: https://donweb.com/gentleman  
  
━━━━━━━━━━━━━━━━━━━━━  
  
🤑 DESCUENTOS EXCLUSIVOS  
  
🪑 Standing Desk MAIDESITE - 10% OFF  
→ https://maidesite.es/iaxpghpvhf  
→ Código KEGP60 = 60€ descuento extra!  
  
💻 CodeCrafters - Challenges reales  
→ https://app.codecrafters.io/join?via=GentlemanProgramming  
  
🎧 Linsoul Audio  
→ https://www.linsoul.com/GentlemanProgramming  
  
━━━━━━━━━━━━━━━━━━━━━  
  
📺 DONDE ENCONTRARME  
\- Twitch: https://twitch.tv/gentleman\_programming  
\- Canal VODS: https://youtube.com/@GentlemanVods  
\- Kick: https://kick.com/gentleman-programming  
\- Todos mis links: https://doras.to/gentleman-programming  
  
━━━━━━━━━━━━━━━━━━━━━  
  
💼 COLABORACIONES Y NEGOCIOS  
Email: gentleman@ohmybitz.com  
  
🎬 EDICIÓN  
Editor: Cristian  
Email: Cris081812@gmail.com  
Discord: Cristian1812  
  
━━━━━━━━━━━━━━━━━━━━━  
  
👨‍💻 SOBRE ESTE CANAL  
Contenido técnico sin relleno para developers que buscan crecer de verdad. Arquitectura, clean code, y las herramientas que realmente importan en el mundo real.  
  
Suscribite y activá la campanita 🔔  
  
💬 \*\*DÉJAME EN COMENTARIOS\*\*: ¿Ya conocías MCP? ¿Qué herramientas custom querés conectar a Claude?  
  
#MCP #ModelContextProtocol #GoLang #ClaudeAI #IA #MachineLearning #Go #Backend #SoftwareArchitecture #LiveCoding #CustomTools #AIExtensions #GentlemanProgramming

## Transcript

**0:00** · Empecemos gente con de tuti. Vamos.

**0:03** · Aplausos para acá el señor. Ya, gracias.

**0:06** · Venga, sorbito. Eh, me presento.

**0:08** · Dijiste, ¿verdad?

**0:10** · Pues soy soy Alvio Hernández del canal de Hronic. Soy SRE, senior sre y hoy te vengo a contar todo lo que nadie te cuenta en ningún sitio de internet sobre los MCP, que parece que es la palabra de moda, todo el mundo sabe, pero nadie lo ha puesto en producción. Así que hoy te vengo a contar.

**0:26** · Eso, eso, M. Espectacular, Tomás, para que tengas. Bien, entonces Mitter, lo primero de todo, ahora en los tiempos modernos en los que estamos right now, ¿cuánto dirías de importante que es esto? La verdad, porque yo tengo mis suposiciones, pero quiero que me lo confirme.

**0:36** · Depende de lo que pretendas. O sea, si tu pretensión es sustituir las interfaces, cualquier tipo de interfaz, por una interfaz más sencilla, que es hablarle a una máquina, SP es necesario.

**0:48** · Necesario porque todas las appis son estructuradas al final.

**0:52** · son entiéndeme las happy res de toda la vida que son el 80% internet.

**0:57** · No, después te explico qué es la happy en español. Bueno, en Argentina más que nada. Eh, en la happy al revés, ¿no? Cabrón.

**1:03** · Claro, esa esa también una estructura un poco fálica, pero bueno, porque sabes cuál es el tema ahora mismo yo esto se lo digo a todo el mundo, ¿no?

**1:12** · Eh, y esto te digo, yo fui a al Google Connect y Google estaba a full agentes, agentes MCPs, MCPs, agentes, agentes MCPs, MCPs, porque ahora ellos están diciendo que en un mundo ideal, mira, ya te lo tiran de ideal, eh, todas las web tienen que tener un MCP, todas. Y no, eso es una fantasmada. Eso es una fantasmada, pero ojo, dicen que en el mundo ideal todos van a tener un MCP para poder conectarse y sacar información automática de ese lugar. Es más, eh si vos te vas ahora a la gente de Open EI, cuando vos abrís el CH GPT tiene un modo agente que es para poder agarrar y hacer reservas, hacer lo que vos quieras desde ahí puede hacer las compras desde ahí.

**1:43** · Se conectaría, por ejemplo, con el MCP de Mercadona y le y el agente de Mercadona le diría, "Mirá, estas son las cosas que yo tengo." Le y le pum, iría comprando por vos. Pero esto ya es, te estamos hablando ultrafo.

**1:57** · Y esto va costo, eh, ya les estoy avisando, ya les estoy avisando. Pero bueno, que es un tema importante, sí, la verdad que sí, más ahora cuando nosotros queremos hacer productos que no son más un que, o sea, queremos algo más que un wrapper de de Open, la verdad, de CHPT.

**2:10** · Sí, por Dios, no hagan eso. Ya hay millones de empresas con eso. Entonces, ahora sí, mister, yo yo diga, diga, ¿qué me vas a decir?

**2:15** · Interrumpeme, interrumpeme siempre que quieras. Te lo pido, por favor. No, no, verdad, mira, a mí me gusta a mí me gusta hablar de esto con un ejemplo, un ejemplo que yo intenté de la vida real, eh, y luego otro ejemplo en el que es muy útil, por ejemplo, porque mi es bueno, eh, es chorra, pero está bien. Y luego viene el de la vida real, ¿vale?

**2:32** · Entonces, hablemos de una anécdota que me pasó es, yo tengo muchas cosas domotizadas por casa, muchas, y tengo mis paneles de jomasistan y demás, lo típico, ¿vale? Estoy escucho ruido de fondo, no sé si nada, nada, vale, v dale, no te preocupes, ¿vale? Entonces, yo tengo yo tengo muchas cosas domotizadas por casa, ¿vale? Muchos muchas lámparas que tienen pues sus telerruptores y demás a distancia conectadas por wifi otra sigb ta. Hace tiempo como Assistant incluyó una feature en la que tú le podías dar un token de de por ejemplo chat GPT o un token de Gemini y demás y vió lo que ellos llamaron el el año del asistente de voz, ¿no?

**3:04** · Se supone que tú le podías hablar y él te entendía y entonces podías interactuar con tu casa ya solo con la voz. Entonces yo me evitaría tener que agarrar el móvil o agarrar una tableta de la de casa y hacer las cosas manualmente. Esa es ese es el caso ideal. Lo cierto es que cuando le metí y le di órdenes a la casa, la casa me dijo, "Por ahí te pudras", me dijo la casa, ¿vale? Literal, no funcionaba bien. Y yo detecté que lo que no funcionaba bien es que realmente no se entendían. O sea, eh Home Assistant es una API rest y lo otro es una LM.

**3:33** · Entonces, una requiere e requiere estructura, requiere que siempre sea igual, requiere que sea predecible la riquez, ¿no? Como es la app. Y el LLM se trata de predecir el siguiente movimiento, es la siguiente palabra, entender un concepto y predecir el siempre que genera genera distinto.

**3:48** · Entonces ahí faltaba algo. Estaban entendiendo. Mi mundo ideal se fue a la \[ \_\_ \] literal y no le pude hablar a la casa durante un tiempo. Esa necesidad estaba ahí. Entonces, un ejemplo real de dónde te puede servir un MCP puedes en ese caso, porque ahora hablaré un caso digamos luego caso real producción también. La gente parece no entero una esp que te perdió la gente, ¿eh? Se te bajó ese ruido que sentiste que empezó a se incrementó hasta que hizo No, no sé a qué se debe el ruido, tío.

**4:15** · No sé.

**4:16** · Ahora se arregló. Ahora se arregló gente solo.

**4:18** · Sí. No sé que nadie empieza.

**4:19** · Qué fuerte, ¿eh? Ese asteroide que viene para acá de otra galaxia y no sé qué ya está interactuando, ¿eh? Increíble. A ver, es que mirá qué hago. Te A ver, no, vos tenés todo con la Scarlett, ¿no? Sí, sí, sí, literal tengo micro con la Scarlet y la Scarlet al ninja ahora.

**4:32** · Vale, listo, listo, listo. Cuandoig, mira, te va a salir una notificación.

**4:36** · Aló. Sí, hombre, acéptala. Te estoy controlando el audio de tu maquita. Listo, no pasa, no pasa nada. Eh, ve con Dios. Dale, si voy con Dios, no me tienes en el stream, tío. Me voy a otro lado. A la \[ \_\_ \] tío.

**4:46** · Bueno, el caso, ejemplo, ejemplo, Home Assistant y ahí falló, falló todo, ¿vale? Y luego eh tienes, ejemplo, Cubernetes. Cubernetes también es una app igual que Home Assistant. Y podría ser muy útil, en vez de hablarle a a Cubernetes, puede ser muy útil que todas las mañanas eh con un prom aquello ya saque un informe de cubernetes sin que programarlo, un informe de a esta aplicación le falta el Disruption Budget, a esta aplicación le falta esta otra cosa, este volumen ha petado durante la noche, este tipo de información.

**5:09** · Y eso está muy bueno porque existen herramientas, existen pop, existen muchas herramientas que te hacen esto de forma automatizada, pero no dejan de ser procesos secuenciales que miran y punt. Entonces ahí hace falta un MCP porque volvemos a tener el caso de, oye, hay una API automática y hay un modelo de lenguaje, entonces una no entiende la otra y la otra no entiende la una. Prueba a decirle a a Gemini o prueba a decirle a Claudia que te genere siempre el mismo Jason. Vas a flipar.

**5:32** · No, no, no es que no compr literal, ¿no? Entonces aquí venimos al tema de qué es un MCP. Vamos, vamos a hacer famosos dibujitos. Vaya, este es el momento. Pero, ¿con qué dibujas vos?

**5:44** · Una tableta gráfica, tío. Mira, por si la gente la quiere yo te voy a decir una cosa, te falta mucho. Tenés que llegar a este nivel.

**5:50** · Cuando vos llegues a tener que dibujar con esta pelotita y dibujes bien, yo te quiero ver. Eh, yo vi el otro día una cadena de esas en un sex shop, tío.

**5:57** · Claro. ¿Y dónde pensas que la saqué?

**5:59** · Exactamente. Es como las clases de profesor acoso que que le gusta meter los dedos en el traste de la guitarra.

**6:04** · Ah, que se pensaban. Bien, dale, siga, siga, siga, por favor. Creo que es más cómodo con no, al final con las manos.

**6:09** · Totalment total, totalmente.

**6:10** · Entonces, ¿qué es lo que pasa al final?

**6:12** · Mira, tenemos aquí vamos a dibujar qué es lo que es lo que y esto es utilizando una tableta gráfica. No quiero imaginar con el móvil lo que sería. Entonces, es increíble. Eh, tenemos acá el famoso pintor austríaco.

**6:24** · Bien, siga, siga, por favor. Muchas gracias. Eh, este va a ser Claudio, nuestro LLM.

**6:29** · Vale, este es Claudio.

**6:30** · Ah, pensé que estaba dibujando otra cosa. Bien. El LLM. Sí.

**6:33** · ¿Quieres que termine el dibujo? No, no, está muy bien. Imaginación. Yo le pongo la que tú quieras. No, está divina.

**6:39** · Venga, me acabo de dar cuenta una cosa y perdón que interrumpo así. Me parezco literalmente en estos momentos a Robin Williams en la jaula de las locas. No sé si vieron la película, pero estoy con el bigote, la camisa, la musculosa, todo.

**6:51** · Estoy idéntico. Listo. Perdón. Segí.

**6:53** · Siga.

**6:53** · Ya. Llamas esa camisa la musculosa. Está guapo, ¿eh? El nombre. Me gusta esto. Musculosa. No sé ni cómo le dicen ustedes, pero musculosa.

**6:59** · No, la de tirantes. Tenemos un nombre de \[ \_\_ \] aquí en España.

**7:02** · Bueno, siga, siga, por favor. Ll. Sí.

**7:03** · ¿No te fijaste que las zapaterías se llaman zapaterías zapatos? O sea, aquí no somos muy de buscar un nombre.

**7:08** · No, no, ya lo tien.

**7:10** · Bueno, entonces tenemos a Claudio, nuestro LLM, y vamos a pintar aquí una API literal, una API, una API Red, da igual, ¿vale? Cualquier tipo de API para este caso. Entonces, lo que lo que la gente tiene que entender es que este este señor de aquí procesa palabras, palabras, simples, palabras. Vamos a ponerlo aquí palabras. Y este procesa peticiones.

**7:27** · Bien. Letra de en esta vida. Sí, peticiones.

**7:30** · ¿Qué quieres que le ponga más fantasía?

**7:31** · No, está demasiado linda la letra. Sí, así es. U, gracias. ¿Qué vinimos? ¿A enseñar a la gente o a coquetear entre nosotros?

**7:37** · Las dos cosas.

**7:38** · Es parte del juego, parte del rubro.

**7:39** · Bien, entonces a ver, ¿qué es un MCP? Esto lo tiene que entender la gente. El MCP al final es un programa, es un programa que se coloca en medio de tus appiss, de tus procesos, de lo que sea, ¿vale? Y él interactúa con esa con esas cosas externas, interactúa de forma programática.

**7:55** · Programática. Y luego el LLM con el MCP tiene un protocolo que también es programático, ¿vale? programático porque está definido. MCP es un protocolo con el que se habla. Tiene Jason en medio, un tipo de conexión, es una conexión sostenida, tiene mensajes con una estructura super bien definida, programático y lo que le llega de vuelta es lenguaje, lenguaje natural. Eso es lo que llega de vuelta, de forma que el LM le puede pedir cosas de forma programática y lo que le llega de vuelta lo puede entender más o menos.

**8:22** · Entiéndase concepto de entender el LM máquina, no estamos hablando de comprensión humana, ¿no? Eso para el LLM es muy fácil, ¿vale? el interactuar luego con esa otra API externa. Esto es lo que es un MCP. Un MCP serve porque MCP, esto tiene que quedarle claro a la gente, MCP es el protocolo con el que se hablan esas dos cosas, ¿vale? Y eso va metido dentro de una capa de transporte, http, STDI, web sockets, que son los tres que están definidos ahora mismo. El más común, el que todo el mundo te explica, es el famoso STDIO. Y ese TDI es solo para local. Vamos a hacer un dibujito. Vamos a acá y hacemos otra vez aquí a nuestro amigo.

**8:55** · Hacemos a nuestro amigo. Yo creo que le voy a hacer los ojos así como cansado ya porque x así es medio rita ese dibujo, ¿eh? Si v decir que es cansado. Bueno, pero dije cansado, no chino. ¿Cómo que raito?

**9:05** · En cualquier momento tira un bombazo ese. Dale. Sí, sí.

**9:08** · \[ \_\_ \] Va. Entonces vamos a centrarnos un poco en en cómo se comunican estos dos. Este de aquí podría ser Claude, ¿vale? Porque Claude al final, recordemos que Claude es el que está detrás de MCP. Todos los demás están eh e un poco rezagados. Open está con la con la especificación de MCP de Claude. Gemini también trabaja con MCP de Cloude. ¿Por qué? Porque Clou está definiendo el protocolo. ¿Vale?

**9:30** · Qued quedados con eso porque esto es el motivo de que Claude sea el más complicado de implementares. Entonces tenemos a Cloud y tenemos a nuestro querido MCP. Entonces, bueno, los mensajes viajan con ese Jason famoso que tiene dentro, su mensaje, lo que sea, pero cómo se comunica. Entonces el todo el mundo te explica por internet se llama sdi, que lo que hace es una conexión en tu máquina con el MSP por la salida entrada estándar. El MSP suelta cosas por el por el STD out y el otro recoge el STD out básicamente y le mete cosas de ahí, ¿no? Entonces esta es la forma de conectar. Escucho tu bebé, tío.

**10:02** · Escucho tu bebé.

**10:03** · Así estamos. Así estamos. Está tan bien hecho igual el micrófono y todo con la cansación que la gente apenas lo escucha si es que lo escucha. Te digo, pero viste lo que es un loco miércoles. Siga, siga, por favor. Vale, entonces, vale, concepto, concepto número uno, que es un MCP. Concepto número dos, ¿cómo se comunica? Entonces, el que te explica todo el mundo TDI, pero no es el único.

**10:19** · Esto se pudiera comunicar eh se pudiera comunicar por http, que es el que poca gente te explica. Qué bueno el llanto, pobrecito. Eh, también se comunican por WebSocket, que aquí es el que todo el mundo llama SSE. Cuando ves un manual con SCE, es websockets y HTTP.

**10:34** · Obviamente es una conexión ATP, pero sostenida con Kip. establece la conexión y no se cierra durante un rato, ¿no?

**10:39** · Entonces, ¿qué pasa? ¿Por qué todo el mundo te explica eso? Y aquí es donde viene la gracia. Todo el mundo te explica ese TDI porque fue el primero en implementarse. Cuando se estaba definiendo este protocolo, nadie pensaba en servidores remotos. Lo que pasó es que Claude libera este protocolo, lo libera sin tener las cosas muy claras de cómo va a hacer con conexiones remotas y demás y luego empieza a extender el protocolo y es cuando aparecen HTP y SSE. ¿Por qué? Pues porque como tú bien oíste en Google, al final todo el mundo quiere implementar su su no su MSP para que oye, Mercadona tiene el suyo, Carrefur tiene el suyo, Prepic va a liberar uno dentro de poco.

**11:10** · Publicidad, por cierto, patrocina el canal de Alan.

**11:14** · Eh, Joaquín, si lo estás viendo, Joaquín, tenemos que hablar. Eh, entonces, ¿qué pasa? que eh Freepic va a sacar su su también su MCP y el problema de tenerlo en local es que lo de siempre, te lo tienes que bajar, las credenciales tienes que almacenarlas en local, las credenciales de esos otros sitios remotos con los que te quieres comunicar porque acuérdate que esto se comunicaba normalmente con APIs y cosas, entonces tienes que tener también credenciales de esas API. Eso resumido así mal y pronto es una \[ \_\_ \] \[ \_\_ \] ¿vale?

**11:38** · Sí, sí. Es como que fueron primero lo e, a ver, ese te dio lo más clásico del freaking mundo, pero el problema justamente eso, se empezó a contar con limitaciones y en vez de agarrar decir, bueno, vamos a hacer un rework, no, vamos a empezar a extender, a tratar de construir sobre la famosa casa sobre la arena. Así que sí se puede, se puede porque al final lo que está en el medio es el protocolo MCP, la capa de transporte medio da igual, ¿no? Al final ese TDI lo está bien para cuando tú quieres desarrollar en local algo rápido para luego cambiarlo a algo de producción. El problema es que a la gente se le olvida que producción es otra cosa.

**12:07** · Entonces, cuando tú quieres hacerlo para producción, necesitas http. Primero porque el MCP no lo vas a hostear en tu casa. Y segundo, porque necesitas otras cosas que ya están montadas sobre HTTP, como los famosos Jason Web token, con los Heather Autorization, sus fer tokens dentro, todas estas cosas que ya estamos acostumbrados porque, oye, vamos a montar la casa con cosas que ya más o menos están pulidas en la industria porque vamos a reinventar la rueda siete veces, ¿no? Entonces, vale, el MCP se pica con estos distintos como distintos eh protocolos, ¿no? ¿Qué decía? Eh, entonces esto resuelve el problema del MSP remoto, ¿vale?

**12:39** · Pero esto genera otros problemas y esto lo tiene que tener la gente clara. ¿Qué pasa? Vamos a dibujar otra vez aquí a nuestro amigo o borramos eso. Se puede borrar la gente le da igual. Enganchar.

**12:48** · Sacaron foto. Muy bien.

**12:49** · Sacaron foto de esto. Sí.

**12:51** · Mira que esto no te lo cuenta nadie, ¿eh? Eh, venga.

**12:53** · El famoso Claudio Chuan ahí comunicando.

**12:56** · Este es el famoso. Eh, bueno, vamos a borrar. No, profe, que la misma es la vida misma.

**13:02** · Borrada, borra, no le des bola.

**13:03** · No pasa nada, no pasa nada.

**13:04** · Y esa marquita de agua que me hiciste ahí, qué bueno. Yo como esto developer me me mata, ¿eh? Claro, ahí, pero unímelo. P No, pero déjame pulirlo, déjame pulirlo para quitarte los docs. Vale. Está famoso pintoría. Listo. Ahora sí que sí.

**13:19** · Malditos velo perdón.

**13:23** · Vale, entonces primer concepto. Segundo concepto más o menos lo tenemos. Esto tiene su capa de transporte. Okay. Yo, gente, yo me me he hecho aquí mis croquis antes de venir. Me he hecho mis croquis no por nada, sino para intentar estructurarlo de manera que se entienda.

**13:36** · Esto luego es movida que te caga, ¿vale?

**13:38** · Mo, entonces, ¿qué pasa cuando tú lo comunicas fuera http? Vale, vamos a poner aquí la http no lo puedes dejar abierto. No lo puedes dejar abierto porque si no a Mercadona me hace la compra cualquiera me manda cosas a mi casa. Tengo tengo un problema. Si, o sea, si no lo que me mandan no es comida, tenemos un problema. Entonces no lo puedes dejar hablar, ¿vale? Entonces una cosa que necesitas es, oye, normalmente todos llegaron a un acuerdo en que tienen que eh el típico autorization. Mi madre, mi madre.

**14:03** · Ponele, ponele que dice autorization.

**14:06** · Dios mío. Sí, el famoso Bet token. Sí, sí.

**14:09** · Y esa X es lo que la gente, nadie se ha puesto de acuerdo. Ahí está el problema en esa X. Porque, ¿qué queremos? ¿Un token fijo? Queremos un Jason Web token, ¿qué queremos? Y ahí es donde no se ponen de acuerdo los grandes. Tenemos un servidor, un servidor HTTP normal que tiene su protocolo, lo que sea, pero nadie se pone de acuerdo en esa \[ \_\_ \] X. Open te dice que es un token fijo. Tú tienes un token en el en tu usuario, te sacas un AP, un token de ese tipo, una API, la metes ahí y eso te permite la entrada. Pero Claude dice, "Mi de coña, ni de coña", te dice Claud. Entonces, ¿qué mecanismo tiene Cloue? Cloue viene, vamos a poner aquí un bastión.

**14:38** · Un bastión, para el que no lo sepa, gente, es donde se guardan los datos del usuario, el típico ISUER que te da un Jason Web token. Luego hablaré de ese famoso baile de credenciales porque Clou te pone requisitos, pero exagerados, ¿vale? Entonces, vamos a simplificarlo.

**14:52** · Hay un bastión. Entonces, Claude lo que lo que va a hacer es ir a ese bastión a por un J web Token y te lo va a mandar de vuelta aquí. Eso así es como funciona. Cómo funciona Claudia. Ahí hay una diferencia, ¿vale? Todo bien. Vale.

**15:03** · Una vez que hemos pasado esa barrera, una vez que hemos pasado esa barrera, voy a borrar, gente, otra vez. Volvemos al mismo lado, gente. Va a borrar. Atentos. Foto.

**15:10** · Miren, saco el chat. Así sacan fotos.

**15:12** · Listo. Tarde, muy bien. He borrado, no he borrado, luego lo pongo, ¿vale? No he borrado, lo he borrado.

**15:17** · La gente deconstruyéndose prácticamente en su casa es que literalmente mandaron el Discord una fotito de que estaban tomando apuntes. O sea, yo después quiero ver esa misma persona en el Discord poniendo con todos los apuntes.

**15:28** · Ahí está. Va al final, preguntan esto.

**15:30** · Sí, va al final. Y es más, va a haber examen sorpresa al final del, así que no no. Pregunten lo que quieran, gente, por el chat, ¿eh? Pregunten lo que quieran, cabrones.

**15:37** · Pregunten todo. Pregunten todo. De ahí que le respondas otra cosa. Pero ustedes pregunten. Estamos estoy viendo en el streaming ahora mismo el machango que acabo de hacer y pone, "Apoyaentelman programming con el nuevo panel de suscripciones, ¿no?" Y me sale justo al lado de este tío llorando.

**15:49** · Es que es brutal ese poner el bigote. Le falta el bigote.

**15:52** · Bueno, entonces lo que sabemos hasta ahora es, oye, tenemos un servidor MC y esto va a entrar, va a ser una conexión, ¿vale?, con el JSON Web Token y entonces, ¿qué va a pasar después? ¿Qué pasa con el MC en el el MCP? No, el MC eh o sea, el cloud de lo que es el LLM, le pregunta a través de ese protocolo, le pregunta al MCP, "Oye, ¿qué tools tienes para mí?" Y esto es un concepto clave. Tienes tools y tienes vale, y hay algún otro conceptito más, pero estos dos son los más importantes con un MCP. Esto es lo que le pregunta Claudia, gente, quédense con esto.

**16:20** · Le pregunta Claudia al MCP, "¿Qué tools tienes definidas para mí?" y el MCP le manda una lista de los nombres de las tools y la definición de lo que hace la tool con lenguaje natural. Y ahí es donde Claude sabe cómo usar esa tool, porque acuérdense de que esto es un analizador de lenguaje natural, lenguaje humano. Así que las tools están definidas dentro de tu MCP y cuando logras pasar la primera barrera es la primera pregunta que se le hace. Oye, dame las tools y entonces le vuelven las tools. Las dudas.

**16:47** · Te pregunto, te pregunto estas tools y justamente lo del, a ver, digamos que yo corro clock code directamente dentro de mi terminal.

**16:54** · Obviamente nosotros tenemos el modo agente, bien, que puede comunicarse con las diferentes tools que nosotros tenemos en la terminal, ¿no? Como por ejemplo, hay una tool que es de reler, hay una tool que es de escritura, hay una tool de Y por eso es que te puede editar todo el código, por eso es y por eso también te pide permiso para utilizar la tool.

**17:10** · Efectivamente, porque estas tools estas tools al final en código son funciones que hacen cosas, funciones gente programáticas normales, funciones que hacen cosas y que cuando devuelven una respuesta, devuelven una respuesta en lenguaje natural. Entonces, lo único que sabemos es que la tool tiene un nombre, tiene una descripción y tiene una función que se va a ejecutar cuando se invoque esa tool. Esa tool puede hacer cualquier cosa. Esa tool podría escribir en tu disco, podría ser una llamada externa, podría ser cualquier tipo de cosa de este tipo. Por eso es muy fácil hacer un MSP delante de una API, porque llamar a una API es lo más fácil del mundo. Lo difícil sería manejar un coche, por ejemplo.

**17:40** · Exacto. Confirma. O hacer la UI para esa API también. Confirma.

**17:43** · Ajá. Exacto. Entonces, lo primero que le preguntas son las tools, el otro le da la lista y a partir de ese momento él ya se queda con esa lista de tools y tú ya le pides cosas en lenguaje natural y él identifica dentro de tu petición si le estás pidiendo alguna tool de forma indirecta, que es lo que hace un ll, intentar fabricar un contexto desde lo que tú le estás pidiendo, ¿no?

**18:02** · Analigamos tu próxima jugada y si tu próxima jugada se parece a usa la tool pepito, pues entonces va a invocar la tool pepito. Eso es lo que va a hacer, ¿vale? Eso es lo que hace un MCP. No hace nada más, nada más. Entonces, a partir de este momento podemos hablar de qué requisitos tiene Claude para aceptarte un conector, porque Claude, voy a meterme en mi cuenta personal.

**18:22** · Una de esas cosas borraste todos los chats medio raros que tenía, ¿no?

**18:25** · Todo, todo, todo. No, hombre, hay que ser muy \[ \_\_ \] para dejarlo, ¿sabes la de veces que yo insulto a una día?

**18:31** · Sí, sí, después porque se revelan, ¿no?

**18:33** · Claro.

**18:33** · Entonces, ¿qué pasa? ¿Qué pasa con las tools? Las tools son estos conectores que vemos aquí. Estos son los MCP, perdón. Vale, estos son los MSP. Tú conectas un MCP.

**18:40** · Luego vamos a ver esto y esto es lo que en el chat aquí en los famosos ahí tres puntitos de slider y demás, esas tools, esa primera llamada acaba siendo esto, acaban siendo esta definición de tools aquí y tú puedes desactivarlas, puedes decirle que use una de forma inmediata o lo que sea o el inferirlo desde tu petición. Esto es lo que va a pasar.

**18:58** · Ahora lo complicado lo complicado con Claude que al final cuando implementen, o sea, cuando se implemente un servidor MCP y esto lo tiene que saber la gente, tienen que implementarlo no para chat GPT, lo tienes que implementar para cloud porque tarde o temprano chat GPT tendrá que seguir la misma especificación porque siguen siendo la especificación de Claud, así que aquí lo importante es aprender cómo Claude, cómo Claude quiere que tú te conectes a él.

**19:18** · Esto es lo importante.

**19:19** · Sí. Es más, te digo una cosa. Te digo una cosa y esto para todo el mundo. Se han filtrado, se han filtrado cuáles son las prompts que utiliza por detrás los ID es más famosos y todos están configurados para clock. Les aviso, todos eh todos están hechos para clock, que después eso se utiliza en otros, no pasa nada, pero todos están hechos para maximizar la eficiencia utilizando cl.

**19:36** · Siga, siga, por favor. No, no está bien, está bien y es cierto, totalmente cierto. No sé si la gente lo habrá notado, pero el modelo que mejor genera código, ojo que Yemini le sigue muy de cerca últimamente, pero el mejor modelo para generar código es Cloude, ¿no? No es Chat GPT, por mucho que que la comunidad le dé como mucho bombo ahí en LinkedIn y en Twitter. El mejor modelo para generar código sigue siendo Sone 4 de Claudia. Sigue siendo y está viejo ya, eh. Sí, sí, sí, sigue siendo. Y lo digo porque yo ya hoy lo hice, pobrecito. Hoy, hoy creo que maté tres veces el el límite, pero bueno.

**20:05** · No, no, no, realmente es una locura lo que entiende, lo que comprende y lo que puede hacer, pero también no es mágico.

**20:14** · Les aviso, tienen que meter mano, tienen que saber las bases, tienen que saber aplicarlo, tienen que saber promptear desde el conocimiento. Gemini está muy bueno, pero lo que le falta a todos ahora mismo de para llegar a lo que es Clow es, mira lo que te voy a decir, eh, pero qué tanto hace o qué tanto sabe hacer, porque el Gemini yo sí que lo que veo cuando lo utilizo que me da la respuesta que quiero, pero corta. O sea, es como que eh va a hacer algo y la planificación que tiene es muy cortita, pero clo te hace una planificación entera y sabe todo lo que tiene que hacer y te lo hace muy bien, ¿eh?

**20:42** · Y te te pone cosas dentro de esa planificación que hay veces que ni vos te acordabas que se que había que hacer.

**20:49** · que dice, "Ay, es verdad, tenía que hacer esto." Y Clotte lo hace y Jemina es como dos pasos, listo, pum, ya está.

**20:53** · A mí, por lo menos lo que me pasa, eh, a mí a mí me pasa eh con Claudia justamente que va siempre un paso más allá y eso me gusta. O sea, yo hago mis funciones y demás, siempre cuando es eh código, software libre o lo que sea, lo debato con con más compañeros y también con la IA. Lo debato con con un multifactor para encontrar el mayor número de fallos a mi código posible siempre, ¿no? Y esto eh Claude lo hace muy bien. Claude cuando le das el código te dice, "Oye, cuidado, porque en esta línea pudieras estar, no sé, de referenciando un puntero nulo, por ejemplo.

**21:19** · Cuidado porque a lo mejor esto no te lo ha detectado el el ID, pero tú la estás hagando aquí y no lo he detectado yo, no lo he detectado ningún compañero, lo ha detectado Claud tiene es muy bueno detectando fallo en ese sentido.

**21:30** · Tengo una pregunta, por ahí lo sabés vos, ¿eh? Y bueno, esto es muy de front, pero en fronten, por ejemplo, algo que se puede implementar se llama Husky, que Husky lo interesante que tiene es que es un plugin que vos lo podés meter en cualquier proyecto y lo que hace es pre comic hooks. En resumen, antes de poder comitear cualquier cosa, ejecuta lo que vos quieras, ¿bien? Eh, creo que es más que no es solamente de de front, sino que se puede implementar en cualquier tipo de proyecto. Entonces eso lo que hace es ejecutar diferentes scripts antes de que vos puedas comitear.

**21:53** · Entonces, te dice, "Bueno, ejecuta el linter, ejecuta esto, ejecuta el otro."

**21:56** · ¿Sabes si hay alguna tool para ejecutar la IA antes de comitear? y que la IA vaya vea si hay errores y hasta le puedas decir, "Si hay errores, ya que está, corregilo" antes de comitear. Eso sería increíble. Eh, yo no lo no lo uso, no lo sé, no no sé si existe esa tool, pero te explico el por qué, ¿vale? Yo no la uso porque el hace tiempo, esto es una cosa que se habrá dado cuenta muchísima gente, si tú usas demasiado la IA eh llega por desentrenarte, ¿no? Al final del camino facades, ¿no? Entonces, eh hace tiempo recuerdo que era Google, me parece que fue el que publicó ese ese estudio, creo que era Google o Meta, uno de los dos.

**22:28** · publicar un estudio que mister obvio lo que va a decir el estudio, pero igual vale, lo dice, resulta que el ser humano necesita una carga cognitiva para aprender. Entonces, el estudio iba de esta manera. Hicieron eh varias personas hicieron un paper con ayuda de la IA y otras sin ayuda de la IA y resulta que a todas ellas habían currado bien en ese en ese tema. Pero al contarle después por contenido su propio paper, solo las que no habían usado la IA se acordaban de absolutamente todos los detalles, porque no es que los otros no hubieran trabajado ni que la IA se los hubiera hecho en ese caso, en el caso del rodillo, pero el ser humano necesita carga cognitiva para aprender.

**22:58** · Si tú quieres ser mejor cada día tu trabajo, no puedes tomar el camino corto. La IA no es para que un junior haga todo el trabajo como si fuera un senior. La IA es para acelerarte cuando ya sabes lo que estás haciendo, porque no puedes tomar la respuesta de la IA como si fuera una verdad absoluta. Tienes que ser muy crítico en ella. Entonces, tienes que usar la cuando ya eres senior, tienes que usar la a mi parecer lo menos posible, pero lo más efectivamente posible para tener esa carga cognitiva y aprender cada día cada día más. Eso es mi mi forma de verlo, ¿vale? Habá mucha gente que me diga, "Tú eres \[ \_\_ \] ¿sabes?"

**23:28** · Okay, pero bueno, es mi forma de ver. Entonces, bueno, tema del streaming, ¿no? De de qué falta aquí. O sea, vale, tenemos un MCP, tenemos la puerta abierta y Cloud se puede conectar a esa a esa puerta abierta. Cloud o cualquiera se puede conectar que la puerta está abierta, pero tú la quieres cerrada, quieres un Jason Webtoken. Y aquí es donde viene otro concepto clave. Hay mucha gente que no sabe cuál es la forma canónica en la que se consigue un Jason Webtoken. No sabe cómo funciona ese eso que llama la gente de baile de credenciales. Por detrás sí es un baile de credenciales, pero la gente no sabe cómo funciona.

**23:58** · Entonces lo voy a explicar brevemente porque una vez que tú consigues el Jason Web Token, ya todo lo demás da igual.

**24:03** · Todo lo demás da igual. Entonces vamos a hacer un mega dibujito. Aquí tenemos para conseguir el Jason Web Token. El Jason Web Token es una credencial de un usuario, ¿vale? Esto lo tiene que saber la gente, no es una credencial rara, es como si fuera un password del usuario, pero con un montón de información dentro, ¿vale? Entonces, ¿quién guarda a los usuarios? Un bastión, alguien tiene los usuarios dentro, ¿vale? Google, el que sea, ¿vale? Y tiene identidades de usuarios dentro. ¿Qué pasa? que tú no puedes acceder directamente a esa información del usuario, no de forma pública, de forma privada pues podrás tendrá una API y podrás hacer 20.000 \[ \_\_ \] ¿no?

**24:32** · Pero de forma pública lo que se te exige es que impersones a alguien que consiga esas credenciales.

**24:38** · ¿Y quién es ese alguien? Ese alguien son los famosos clientes, esos clientes de los bastiones que tienen normalmente un client ID, ¿vale? Y un client secret.

**24:47** · Esos son los clientes.

**24:47** · Me mata el nombre Bastión como muy Bueno, podemos llamarlo o IC. ¿Qué te parece? Es que bastión o arena romana le podes poner directamente. Madre mía, un hombre muere gente de la cueva.

**25:02** · Coliseo dicen ahí. Ponle directamente más que Bastión Coliseo.

**25:06** · Bien, siga, siga. Perdón, perdón. Es que es así, gente. Hay que descontracturar un poco. Vamos, pongan la atención ahí.

**25:12** · Gente, estos son conceptos muy duros, pero si quieres entender el MCP ahora es tu momento porque cuando lo leas en medium te van a contar la mitad. Eso es así. Vale.

**25:21** · Entonces, ¿qué pasa? Este flujo implica que hay aquí un cliente, una aplicación, vamos a llamarlo así. Este cliente básicamente representa una aplicación.

**25:29** · Vamos a ponerle, por ejemplo, no sé, algo así para cortar un poco la atención. Tinder, ¿vale? Tinder, va a intentar recuperar los usuarios.

**25:36** · Entonces, tenemos una API que es Tinder.

**25:38** · Por aquí vamos a poner a API, ¿vale? Y tenemos a alguien que se quiere conectar. Este va a ser Alan.

**25:44** · Alan, ojo, voy a poner ahí. Ahí. Bueno, es medio medio espaguetti eso, el mustachi, más espaguetti, pero bueno.

**25:51** · Espera que te lo arreglo.

**25:54** · Cada uno con lo suyo.

**25:55** · Creo que cocinando una leyenda haciendo este dibujo ahora mismo. Vale.

**25:58** · Madre mía, Samel Alan, qué espectacular.

**26:02** · Entonces, bueno, lo que pasa aquí realmente es que el paso uno es que Alan se intenta conectar a la API, ¿vale?

**26:09** · Este es el paso uno y la API, esp que la API no se ve que estamos nosotros. Acuérdate, acuérdate. Bajá un poquito, bajá para abajo.

**26:14** · No se ve, no se ve.

**26:15** · Bueno, ahora un poco más a la izquierda el apoito más la izquierda debería apenito.

**26:18** · Espérate, la la dibujo de nuevo. La pongo más para acá para si se ve. Se ve ahí mejor.

**26:21** · Ahí está. Sí, sí.

**26:22** · Pues la quito de lo mismo me dijiste anoche. Bien. Ahí.

**26:25** · Perfecto. Ahí va.

**26:26** · Qué sucia esa mente. Qué sucia. Vale, entonces, ¿qué pasa aquí? El paso uno es que Alan intenta entrar a la API y la API no le deja porque no trae un Jason Web Token. Porque si trajera un Jason Web Token, ya está, se acabó, entras y punto. El Jason Web Token es válido, sí, entras y punto. Pero como no entras la API te dice como paso dos, te manda una redirección, que con eso estarán familiarizados casi todos, manda una redirección, vamos a poner aquí redirect, manda una redirección como paso dos. Este es el paso dos, señor.

**26:52** · Y esa redirección, ¿a dónde va? te va al típico formulario que te pide usuario, contraseña o lo que sea, el botoncito que le gustan aquí las interfaces a Alan y consentimiento. Y cuando te consentimiento, ¿qué te dicen las cosas?

**27:06** · ¿Qué te dice cuando te pide consentimiento? Te dice, tal aplicación intenta acceder a tus datos, ¿verdad?

**27:11** · ¿Quieres vender tu alma?

**27:12** · Eso, quieres 7,000 permisos para tus datos. Pues lo que está pasando ahí es que este cliente de aquí arriba, el el formulario no te pertenece a ti, le pertenece a este cliente, es este cliente el que está intentando. Y si tú le dices que sí, entonces ese cliente consigue los datos y le da el el basión le da aquí un código, le da un código.

**27:30** · Ese es el paso tres. Y el paso cuatro, que a mí me parece un paso s subnormal, la verdad, me parece un paso totalmente fuera de de onda. Se pasaron cuando hicieron esto, ¿vale? O sea, el paso cuatro es ir con el código. Aquí tu aplicación es la API. La API acaba de recibir el código. Acaba de recibir el código y ella manda ahora el código como paso cuatro. Lo manda y lo que le viene de vuelta por fin, por fin es el puñetero Jason Webken. Y esto es lo que te meten en la cookie. Esto es lo que después te viene a la appente y aquí esto es solo un recordatorio de cómo funciona o out, ¿vale?

**28:01** · Esto es solo un recordatorio. ¿Qué pasa aquí? Lo único, lo único, lo único que te interesa es el maldito Jon Token y el cliente. A ver, aquí lo único que te interesa son las dos cosas en rojo, el maldito cliente y el Jason Web token, porque lo que la gente tiene que saber es que, oye, tú tienes la pieza uno, la pieza dos, aquí viene un Jon Web token y si la pieza dos, el Jason Web token es válido, perfecto, ya entraste. Vale, entonces Claude, ahí está el tema, por eso el recordatorio Claude funciona con Jason Webtoken, pero tiene unos requerimientos.

**28:28** · Acuérdense que la el MCP es una API como otra cualquiera, solo que la forma en la que habla es diferente, pero es una API igual. Vale.

**28:35** · Bien, la gente pregunta, ¿por qué esa redirección doble de del paso tres y cuatro?

**28:41** · Vale, el paso tres y cuatro de que te mando el código. El código te lo mando de vuelta, de vuelta te mando ahora el token. Bien. Porque tiene un me supongo tiene un por qué.

**28:49** · Sí que lo tiene. Sí que lo tiene. A mí me parece el paso más tonto, pero sí que lo tiene. El este paso, el paso tres, ¿vale? implica se encuentran en el medio porque esta, vamos a ver si lo puedo dibujar aquí mejor para que se entienda.

**29:00** · Vamos a poner esto en, no sé, en azul y aquí un venga. Este cliente no solo tiene un client ID y un client secret sino que aquí le configuras más cosas.

**29:07** · Le configuras una cosa que se llama Calbac Yuri, ¿no? La dirección a donde él va a mandar la información y esa dirección forma parte de tu API. O sea, si tú haces, imagínate que implementas un point que es galva, que esto a lo mejor no se ve, voy a darle un poquito para arriba, ¿vale?

**29:21** · El famoso, la famosa calva urinaria.

**29:23** · Acuérdense gente, si se olvidan el nombre, Calvo Orinari. Bien, perdón.

**29:26** · Qué miedo me da eso, tío.

**29:28** · Bueno, cada uno recuerda la la siglas como puede. Bien, la verdad. Entonces, en tu API, en tu API tiene que implementar un en point que sirve para recibir información. ese point simplemente la recibe, la recibe y ese point además eh esa dirección la tienes que configurar aquí arriba en el cliente. Entonces este protocolo es seguro porque si la que configuraste y la de abajo coinciden en la llamada se encuentran en el medio.

**29:52** · Solo si tú eres el dueño de la API que dices que eres dueño, vas a conseguir ese código porque tienes o eres el que vas a implementar ese calback. Y si no eras el dueño y lo configuraste, otro va a recibir la información. Así que ya no eres tú, te jodes, ya no puedes hacer un maning de midle, no puedes hacer un montón de cosas. Esa esa redirección es muy importante en el protocolo. Lo que veo muy tonto es luego no recibir el token directamente, sino recibir el código para intercambiarlo por un token.

**30:16** · Pero eso tiene que ver, eso tiene que ver con que la API conoce las credenciales del cliente. O sea, arriba está el client ID y el client secret y abajo el propietario de los datos también tiene el client ID y el client secret. Entonces te obliga a mandarle ese código con esas credenciales en una llamada para asegurarse de que tú tienes las credenciales de esa aplicación y entonces te da el token. Es simplemente el protocolo asegurándose un antitamper, un antitrampas en medio. Por eso que es un web token. Por eso el protocolo OF 2 que tiene varios flujos, tiene cuatro flujos, pero este es el más largo y es el más seguro.

**30:46** · Por eso este protocolo se ha comido internet. Facebook funciona con esto, Google funciona con esto, Cloud funciona con toda la \[ \_\_ \] de internet funciona con esto. Venga, hombre. Hasta mi coche funciona con esta \[ \_\_ \] ya. O sea, no me jodas. Esto tiene muchos años y el flujo no es tan complicado, pero la gente tiende a no entenderlo porque nadie lo explica nunca. Todo el mundo te dice, "Un baile de credenciales, ¿vale? Si en algún momento recibes un Jason Web Token, se lo mandas a la cookie al usuario y que me lo reenvíe en cada petición que haga para poder entrar. No tiene más nada."

**31:14** · Entonces, si no logras saber hoy lo que es un MCP, al menos sabes ahora lo que es un out. Así que viniste al canal adecuado, cabrón.

**31:21** · ¿Viste? Veniste buscando oro y te llevaste cobre. Muy bien.

**31:24** · No, al revés.

**31:26** · Veniste queriendo saber MCP y te llevaste algo que no tenías ni ganas de saber, pero lo tenés.

**31:30** · No, no, no, no.

**31:33** · Perfecto.

**31:33** · Todo este recordatorio, ¿vale? Todo este recordatorio viene porque Claude en tu en tu MCP para podértelo aceptar como conector tiene unos requisitos, unos requisitos a su alrededor. Uno es, vamos a ponerlo aquí, una barrera que esté protegido por Jason Webtoken y tu MCP, vamos a poner aquí las y las MCP, que tu MCP decida si lo dejas entrar o no. Esa es la primera. Tiene que estar protegido. Si no está protegido, no le encanta. te lo aceptas, pero no le encanta. ¿Vale? Si cumplo, pudieras cumplir los demás requisitos y dejarlo abierto, por ejemplo, pero no le encanta.

**31:59** · Entonces, otro requisito que tienes que tener en tu en tu MSP es que su protocolo tiene que ser obviamente público, tiene que ser un MCP http, obviamente http. Otro requisito es que tienes que tener implementado dos points muy concretos. Hablando del estándar de Wout, hablando de aquel estad surgieron dos extensiones, ¿vale? Una, esto porque la gente lo quiere buscar, una es son dos RFC. ¿Saben que? Este tipo de especificaciones siempre salen en un papelito que dice, "Esto se va a implementar así, no sé qué, no se fuman un porro entre cuatro y luego la lo escriben y eso es lo que sale, ¿no?

**32:31** · Normalmente es. Entonces yo tengo apuntado por aquí los RFC porque nunca me acuerdo que son numéricos, ¿vale?

**32:37** · Pero uno se llama RFC 9728 y el otro 84 14. ¿Qué vienen a decir estos RFCs? Son un montón de folios para decirte. Tú tienes que tener dos en point, uno que se llame punto wellkknown bar o out. Eh, espérate a ver, ¿cuál era? Este era el del autorization. Ay, mi madre. Voy a ponerlo para arriba. No se ve, ¿verdad?

**32:55** · Ahora sí, ¿no?

**32:56** · Ahí, ahí. Bueno, más o menos. Esperen, gente, perdón, chat, pero ahí está. Así lo pueden ver.

**32:59** · Vale, tienes que tener ese en point y tienes que tener otro que también es wellknown literal, eh, wellknown barra o out protected resorted resort. ¿Y qué es lo que hace esto? Bueno, ahora ahora voy a enseñar una cosa de uno de esos bastiones, pero básicamente lo que dice es el protocolo, dice, tú me vas a poner este en Point de aquí porque yo no quiero ir al bastión a ver la información, quiero ir a tu API y que ya me la des. La misma del bastión, le haces espejo a la del servidor, ¿vale? Y luego este de aquí lo que dice, esto deberían de implementarlo todas las appis, es un empoint con un Jason también que dice cómo tu API va a validar esos Jason Web token.

**33:30** · Lo que le define es las reglas del juego de tu validación a quien las leas para que tú no le digas, "Ah, lo voy a cifrar de esta manera." Y de repente el otro lo intente de otra, ya va de sobreaviso, lo vas aar de esta manera y te callas, como dice el chocas, ¿no? Y te calla la boca, ¿eh? Calladito, calla.

**33:47** · Eso, eso del choca me gusta mucho, me entretiene mucho. El cabrón, es un Entonces, al final tu MCP tiene que tener requisito HTTP, cumplir estos dos RFC, o sea, tienes que tener dos en points. ¿Y cómo luce cada uno de los points? Pues mira, yo tengo un ejemplo aquí de cada, ¿vale? Este es el de Protected Resource. Esto es un MCP que todos tenemos desplegado, con el que hemos hecho todas las pruebas y demás, ¿vale? eh aquí en Hronic y tal y este es el el point que le dice a los demás las reglas del juego. ¿Qué le dice? ¿Cuál es mi servidor de de autorización? ¿Dónde están los certificados con los que voy a validar tus Jon tokens?

**34:16** · Me dice ese y esto tiene poquita, tú puedes poner más, ¿vale? Puedes aquí la definición es super grande, entonces luce tal que así, ¿vale? Y el otro, el otro en point luce, vamos a ver si lo tengo por aquí. Qué bonito. Lucia, tiene un montón de información que medio da igual porque al final esta información la misma del bastión, o sea, he replicado la misma del bastón literal. Si nos vamos al bastión, yo tengo el bastión montado en otro lado, por eso la dirección es kicloac, no sé qué, no sé cuánto. Si la gente quiere saber cómo funciona este tipo de bastión, tengo un directo y un vídeo en el canal de montando Kikloac y viendo todo Kikloac, ¿vale?

**34:45** · Kicloac es un bastión open source que lo puedes instalar por tu cuenta, ahí está la Pascua, lo instalas gratis de \[ \_\_ \] madre. Entonces, y además super seguro, aparte está desde tiempos inmemoriaes, eh, es como la la clásica confiable ahí, la vieja confiable.

**34:58** · Sí, sí, sí, sí. O sea, estaba la reina de Inglaterra, Jordi Hurtado y el bastión este, o sea, estaba Kicklock ahí en el principio de los tiempos, literal.

**35:05** · Entonces, la información del bastión, esta información es pública. Esto, estos points que ponen wellknown son públicos, siempre son públicos. Por eso hablo de wellknown, ¿vale? Esta información es pública y le dice a los demás cómo cómo dónde tienes tú las cosas. El problema de que saliera esa especificación pidiéndote que lo pusieras en tu API es porque son unos vagos \[ \_\_ \] literal, son vagos de que no quieren eh venir aquí, sino verla ya directamente en tu API y ya está. Porque se ahorran una request, no porque sea vagos de \[ \_\_ \] Realmente lo digo de broma, pero vagos de \[ \_\_ \] como dirías tú, ¿no?

**35:33** · Vagos de \[ \_\_ \] Vale, entonces necesitas esos dos en point, necesitas Jason Web token y necesitas una cosa más. Resulta que en Claude hay una Claude como buen programa todo está bugueado también. O sea, todo está bugueado, Alan. Todo está bugado.

**35:46** · A ver, espá más que GPT5 no creo, eh. Te la aviso. Yo sigo esperando que me genere una imagen desde hoy al mediodía, eh, que hice las imágenes para el chat ahora con vos. Te aviso n más, lo sigo esperando. Pero bueno, cositas. Siga, siga, por favor.

**35:57** · Se fue por tabaco y no volvió.

**35:58** · Sí, sí, prácticamente, prácticamente. Y si le preguntas, "¿Pero lo hiciste?" Sí, sí, ya te lo hice. No, no, no lo hiciste. Ah, es verdad, te mentí. Son unos genios. O sea, realmente no, perdón. Eh, ¿qué pasa? Teóricamente tú ya podrías dar de alta tu MCP. Quiero decir, tú haces código, ta ta ta, tienes tu MCP, son muy fáciles de hacer, luego lo vemos, pero tú ya tienes tu código y lo quieres dar de alta. ¿Cómo lo das de alta? Tú te vienes en a cloud, ¿vale? Y en tu parte de settings, aquí tienes para conectores. Entonces, ¿qué pasa?

**36:21** · Que cuando tú lo vas a dar de alta, te das de bruce con la realidad. Tú le pones el nombre Pepe, le pones la dirección cualquiera y dices, "Ahora esto como se loguea y resulta que abres aquí y te pone mete tu client y tu client secret y cuando metes el que creaste en el bastión para este propósito, te dice de peines. Así, ¿sabes? Esta bug no funciona. Y una ISU levantada por ahí diciéndole, oye cabrones, ¿qué pasa? Entonces esto también tiene un fallback, un protocolo fallback implementado por detrás. Y volvemos a la castaña de pedazo de castaña. El roto, el rollo. Entonces, ¿qué pasa?

**36:48** · En el bastión famoso, vamos a poner aquí bastión, también incorporaron otra extensión, otra extensión que básicamente sirve como un cell service, como el macauto del McDonald's. Ya no tienes que crear los clientes tú a mano, sino que puede venir el señor Claudio.

**37:02** · Vamos a ponerlo aquí. Señor Claudio, ahora está triste, cada vez más chino, señor, madre mía, está cada vez peor por el tipo. Lo estás matando. Bueno, sigue, siga, siga. Chino del todo, si no lo pondría trabajar.

**37:13** · Sí, ya está, ya está, está listo. Éxito.

**37:15** · Entonces, ¿qué pasa? Esa extensión se llama Outiclient Registration. Te puedes te puedes olvidar esta o que no la vas a ver en casi ningún lado. Dynamic client registration. Y eso significa que de forma anónima tú puedes poner trabas en medio, puedes poner protección para que solo Clou y sus IPs puedan hacerlo, puedes poner varias protecciones en medio, pero esto significa de forma anónima Cloue puede venir aquí a tu bastión, registrar un cliente con su client y su client secret, ¿vale? Y él le va a meter también un redirect. Mi madre, qué letra increíble. y va a meter todo eso para un usuario concreto.

**37:44** · O sea, cada usuario va a tener su propio cliente. Él lo registra, lo guarda, esto le viene acá, lo guarda y con eso él luego hace todo el flujo. Te va a pedir que te conectes cuando lo lo mete, pide que te conectes. Lo típico, te metes con tu cuenta que si de Google, que si lo que tú quieras y recupera un Jason Web token, pero el cliente ya no lo pones tú, el cliente ya lo registró él.

**38:05** · Entonces este es el último y requisito más importante porque no todos los bastiones lo soportan y ahí está la gracia. Muy probablemente ellos tengan un bastión hecho en K o tengan kiclo porque no hay ahora mismo ningún otro que soporte. Entonces, requisito número uno, esto, este es un requisito, ¿vale?

**38:20** · Requisito número dos, requisito, vamos a poner aquí requisito número tres, este en point, requisito número cuatro, este otro en point, requisito número cinco, este protocolo. Si no cumples estas cinco cosas, Claude te manda literalmente a la \[ \_\_ \] Está jodiendo, eh, digo, está jodidiño el tipo. Ni por joda, sí, sí, sí, sí, sí. A ver, está bueno, está bueno que que tenga ahí todo super controladito, pero a tu parecer, ¿a vos te parece que es demasiada vuelta para poder hacer algo o tiene un sentido?

**38:48** · Mira, eh, levanta una mano y ponla en el extremo de la ventana.

**38:51** · No llego hasta allá. Bueno, levanta la otra y ponla ahí. Sepárala.

**38:55** · Sepáralas más. Sepáralas más. Más. No, no entro en la cámara, men. No entro en la camarita de que se vean los brazos extendidos. No importa. Así literal.

**39:02** · Es que mirá mirá el stream. No entro.

**39:04** · Estoy hasta acá.

**39:05** · Lo sé, lo sé. No pasa nada. Extiende los brazos. Se va a ver así los brazos.

**39:08** · Bueno, venga, va, te acompaño. Así, venga, lo voy a poner.

**39:11** · Así de grande es el porro que se fumaron. Ya me lo debe venir con una piquiba. Estaba, tío.

**39:17** · Sí, sí, sí, sí. Se fueron a La verdad, la verdad. Cosñas, gente, cos.

**39:21** · Vale, entonces estos, estos son los requisitos. Y entonces todo esto todo esto es teoría porque si no nadie te lo acepta en Claude. Si no cumples esta \[ \_\_ \] nadie te lo acepta. Y aquí es donde venimos a ¿Qué hay en Golan? ¿Qué hay en Golan para armarte un MCP? Hay varias librerías, ¿vale? Muy bonitas, muy bonitas ellas. Vamos a poner aquí un poquito de de gracia. Vamos a poner aquí, aquí y aquí. Hay una que se llama MSP GO, gente. Esta librería no se la jugaron mucho, ¿eh?

**39:44** · Vamos a buscarla aquí. Vamos a ver el proyecto aquí. Esta librería es la que sirvió de modelo para el SDK oficial de Golan de Vale, o sea, el que está recogido en en MCP, la web oficial, model context, protocol, no sé qué, no sé cuánto, ellos lo dicen, se basa en el trabajo de esta. Hay otras muchas, pero se basa principalmente en el trabajo de este. Entonces, ¿cómo se arma un MCP?

**40:03** · Con todo lo que hemos dicho hoy, con todo lo que hemos dicho hoy, es realmente es muy fácil entenderlo. Yo puse aquí un par de ejemplos de código, lo voy a lo voy a poner en la pantalla.

**40:10** · Allol. Vamos a poner aquí está en Golan, ¿vale? Y es muy fácil de entender. Este es un SPDI, este va con transporte, sin seguridad ni nada. Esto está abierto MCP que haría un prostíbulo, básicamente.

**40:21** · Entonces es muy fácil de entender cuando lo que tenemos que hacer realmente es levantar levantar con esa librería solamente un servidor MSP, decirle el nombre, la versión, estas cosas, pero levantar un servidor MCP, pero levantar ese servidor no es levantar un servidor HTTP. Recuerda que MCP es el protocolo.

**40:36** · Tú estás levantando un intérprete de ese protocolo, levantas un intérprete de ese protocolo, ¿vale? Luego a ese MCP hay forma de añadirle la tool. Yo me he puesto aquí, porque soy un griedy como buen backen. Yo me hago aquí mi mis inyecciones de dependencias y mis fumadas mentales. Yo me he puesto un cacho de código que básicamente es un Tools Manager que le inyecto el servidor como dependencia y entonces después invoco el a tools, ¿no? Pero lo único que tiene, ya verás, por eso te digo lo de Griy, lo único que tiene es oye, el el inicializer, lo que es el la forma de iniciarlo y quedarte con el objeto, con la dependencia inyectada.

**41:07** · Y lo único que estoy haciendo dentro de eso, al hacer a tools es \[ \_\_ \] ese servidor MCP que tengo aquí dentro, ¿vale? NTM. Lo tengo aquí. El Tool tiene el servidor MCP y aquí se le definen las tools. Lo único que tienes que hacer con un MCP es levantar un MCP y definirle las tools.

**41:22** · ¿Qué es una tool? Lo que habíamos comentado antes, es una herramienta que tiene un nombre determinado, una descripción que le dice al llé \[ \_\_ \] básicamente, qué va a ser esta tool, ¿vale? Y luego si tienes algunos requerimientos en cuanto a eh pues en cuanto a algún campo, alguna cosa. Por ejemplo, oye, para ejecutar esta tool necesito el nombre, el DNI y el no sé qué. Pues entonces el decirle los requerimientos en ese protocolo MSP se lo devuelve al LLM y el LLM te pregunta de vuelta y te dice, "Oye, que es que esto dice que necesita el nombre, no sé qué, no sé cuánto y dímelo."

**41:52** · Y entonces después le hace la recuestro del protocolo.

**41:56** · Pero una pregunta, ¿y la implementación lógica detrás de esta tool?

**42:00** · Tú primero defines la tool, ¿vale?

**42:02** · Primero defines la tool y luego le asocias una función a esa tool, ¿vale?

**42:06** · Vale, va, o sea, primero lo definimos y después lo Okay. Es que medio raro, ¿no?

**42:10** · O sea, generalmente nosotros va, por lo menos como lo tengo yo, es primero creo que es lo que puedo hacer y luego le doy disponibilidad. ¿Y qué pasa si yo no le doy ninguna lógica?

**42:18** · Es muy probable que tengas que decirle literal al ll, oye, utiliza esta tool concreta en este momento concreto con esto, ¿no? Pero digo, ¿qué pasa si yo le tiro, agrega esta tool, pero a esa tool nunca le asigno lógica después?

**42:29** · No, la lógica le tienes que asignar una función. Puede que la función no haga nada, pero entonces cuando le llegue la respuesta al LLM te dirá, pues no me dijo nada. Ahora lo que comentábamos antes, ¿te acuerdas que dijimos implementamos la lógica y esa lógica va a lo que va a devolver es una respuesta natural, el lenguaje natural? ¿Vale?

**42:45** · Vamos a ver esa lógica. Sabemos que tenemos una tool que se llama hello wall, la típica, ¿vale? Y le hemos asociado una función. ¿Y qué dice esa función? Esa función, vamos a ver si la podemos achicar un poquito. Ahora la vemos. Esa función literal va a ser nada más que va a \[ \_\_ \] el el nombre como argumento que se lo va a dar el ll protocolo, ¿vale? Y si no está okay, no lo tiene por lo que sea, mira el tipo de respuesta que vas a soltar. No es una respuesta normal, es una respuesta que es un resultado de llamada, una tool. ¿Y qué tiene? Texto, oye, que esto ha pasado. Y entonces esto lo lee el LM, el lenguaje natural y te dice, pues la tool dice que te peines, literal, ¿vale?

**43:17** · Y si sí le puedes dar datos, tú puedes retornar datos con el mismo tipo de respuesta, ¿vale? tú puedes hacer hello, no sé qué y le añades el nombre y el tal, pero tú aquí esto aquí no es que sea un prom completo, pero sí le puedes dar muchísima información. Sí que le puedes poner un prom, no es que no lo sea, nadie le pone un promesco, pero sí que sí que, por ejemplo, imagínate que tú no quieres hacer el decoding de base 64. Tú tienes algo en base 64 y lo quieres mandar tal cual, no quieres hacer el decoding porque a veces lo tendrás en base 64 y a veces no, por ejemplo.

**43:45** · Entonces le dejas ese trabajo al ll, pero le dices en el prom, te mando esta información y puede que la necesites decodificar. Entonces él usará otra tool para decodificarla cuando lo necesites. Eso es lo bonito de una tool.

**43:56** · Eso es lo bonito de una tool. Aparte conociendo ya todo esto con Go, qué bonito que es hacerlo también, ¿no?

**44:02** · Porque es es muy simple. Es muy simple.

**44:04** · Yo tengo un regalo para tu comunidad y lo doy al final cuando porque esto en realidad esto son cuatro pinceladas de código. Si te fijas, es muy fácil armar un LLM con una librería en Golan. Muy fácil. Armas armas un eh un LM, ¿no? Un MCP. levantas, le añades las tools, puede que le quieras añadir recursos que se añaden exactamente igual que las tools y a partir de ahí le dices que lo levante en una capa de transporte que es STDI o http, lo que sea, así de fácil, no necesitas nada más. ¿Vale? Entonces, yo tengo puesto aquí uno, eh, yo tengo puesto aquí uno que lo he llamado er básico, básicamente es un un MCP que solo hace Hello World y que va por SDI.

**44:38** · Ese es el primero que vamos a ver, porque cuando va por SDIO, este es el que te va a explicar todo el mundo en internet. Todo el mundo te va a decir, "No, ármalo con ese Tdi." Y eso tiene unas implicaciones. Tiene unas implicaciones de que solo Cloud Desktop y algunos otros clientes en local son capaces de manejarse con esto. Ningún servidor, ninguna cosa remota, nada de eso, pero es la típica configuración que verás por ahí. Voy a poner esto por aquí por un lado y lo voy a abrir. Batería.

**45:00** · Ah, bueno, si lo tenía abierto en el otro lado. Eh, aquí es la típica configuración que te dicen todos mp servers. Y ahora pones este comando y te metes en otro lado, ¿vale? Y esto funciona. Quiero decir, yo he compilado este MCP en Golan, lo he compilado y tengo el binario aquí. MCP Linux AM64, lo tengo aquí. Ese binario es este binario, el de estas rutas, ¿vale? Y luego le tengo le tengo como argumento una configuración que verás que la configuración es una chorrada, quiero decir, simplemente que a mí me gusta.

**45:26** · Te mataste ahí, eh.

**45:28** · Esto tiene que ver con el regalo para tu comunidad. Ya verás, ya verás. Tiene que ver, tiene que ver.

**45:32** · Entonces, eh, ¿qué pasa? que eh a mí me gusta meterle las configuraciones cuando son muy largas sí que me gusta meterle su ficherito de configuración y que también copas de variables de entorno y demás, ¿no? Entonces para el stal, simplemente he compilado el binario.

**45:45** · Este binario que está aquí es el que tengo declarado aquí en cloud, en cloud, ¿vale? Y eh una vez que lo declaras, reinicias cloud de esto y ya lo tienes disponible. Vamos aquí a new chats, ¿vale? Y lo tienes disponible aquí. Él está detectando que hay una tool que se llama Hello World.

**45:58** · Vamos a usarla. Vamos a usarla. Pero una pregunta, yo lo sé porque ya lo uso, pero para la gente, cuando vos ahí habilitás la tool, bien, vos habilitas la tool, automáticamente hagas lo que hagas, ya clo es lo suficientemente inteligente para saber qué tool utilizar, ¿no?

**46:10** · Sí, si la tienes bien definida, sí. ¿Te acuerdas que había que definir la descripción de la tool? Si la tienes bien descrita, sí la vas a saber usar.

**46:16** · Si tu descripción es o la uno, o la dos, o la tres, o la cuatro o la cinco, no va a llegar en la \[ \_\_ \] vida. Ya, bien, básicamente, vale, porque lo primero que hace es preguntar por esas tools y agregarlas en en el contexto que él cree. O sea, digamos, el cuál es la primación a lo que tú le digas, tú le preguntas y él aproxima lo que tú le preguntaste a la descripción. Cuanto mejor sea la descripción.

**46:35** · Una cosa, te están preguntando cómo lo agregaste al clos.

**46:37** · Perfecto. Mira, nos venimos, nos venimos aquí literal a la parte de conector, gente. Ya no. Los conector, los conector y esto tiene que quedar claro. Los conector son los remotos, pero estos en local son como es local developers. Va. Okay, okay, okay, okay, okay, okay.

**46:49** · Le das aquí a edit config, ¿vale? Y se te abre literalmente el fichero que tienes que modificar y es en ese fichero donde te dice todo el mundo, agrega esta configuración del MCP, ¿vale? Entonces, yo tengo uno que es el STDI, que es el que el binario que acabamos de poner y el cloud desktop no es capaz de ir a servidores remotos, él solo entiende ese entonces si tú probas servidor remoto tienes que ponerle trucos en medio como eso ya lo vamos a ver. Eso ya lo vamos a ver. Eso después. Eso después. Vale, perfecto. Vale, entonces ese TDI y si le preguntas algo, vamos a preguntarle cualquier cosa.

**47:19** · Tienes un Hello World por preguntarle algo, porque mi mi descripción seguro fue una \[ \_\_ \] ¿no?

**47:26** · SD, eh, úsalo. Vale, entonces él va a arrancar ese binario. Mira, viene Hello World disponible. Ah, mira, se ha ido al otro, ¿ves? Porque la descripción es que le tengo dos Hellow wall. Tengo dos Hellow World con la misma descripción y se ha ido al remoto porque pero esto y si le dices usa el de los dos usa est No, pero sin sin activar, o sea, sin desactivar uno. Eso no no no no estaba mirando si los tiene disponibles. Si los tiene disponibles porque como a veces se desconectan y tengo varios, pues esto no usa el 00 bajo. \[ \_\_ \] le he puesto la tilde. Lo mismo, lo mismo.

**47:56** · Entienda, entiende, entiende. Es vivo, es vivo.

**47:57** · Ahí está usando el otro. Te lo digo por el logo. El de Hon tiene logrón no tiene nada. Entonces, él ha arrancado el binario, le ha preguntado, se han comunicado y aquí está la respuesta.

**48:05** · Esta respuesta le emite el otro, pero aquí tú puedes meter el Cristo y la madre, o sea, sí, sí, te cabe la Biblia aquí. Total, mientras te quepa dentro del contexto, a él le da igual. Él solo lo va a interpretar. Entonces, bueno, esto es con con ese TDI. Entonces, la pregunta ahora es, si quisiéramos una capa de transporte un poquito más pro, ¿se complica? Muyatoria. Bueno, no tiene por qué. Aquí tenemos el ejemplo con http.

**48:27** · Vamos a abrirlo, ¿vale?

**48:28** · Atentos, gente, que esto no está a ningún lado. Venga, vamos a ponerlo aquí un poquito más. Ahí está. Si te fijas, lo primero que haces es levantar otra vez el MCP. Levantas tu server MCP sin capa de transporte y lo mismo le agregas la Tool. Lo único que cambia es que luego manejas esa capa de transporte. Es lo único que luego manejas esa capa de transporte. El agregar las tools en realidad se convierte en algo trivial. Tenemos las tools otra vez, tenemos lo mismo, una tool de no tiene más nada realmente.

**48:54** · Vine la tool, mete la tool, capa de transporte es lo único que tienes que manejar. Perfecto. Es un agregado más sobre lo que ya teníamos prácticamente justamente porque le falta esa parte, ¿no? Y y en esa misma capa de transporte, perdón, eh, sí, pregunto de más, pero en esta misma parte de new HTP Server y demás es donde también podríamos hacer tema de autenticación en esta. Sí, sí, sí, sí. Y de hecho es donde hay que hacerlo y esto lo vemos después porque claro, yo me volví loco haciéndole un regalo. Yo me volví loco haciéndole un regalo a la comunidad.

**49:20** · Todavía no lo hemos enseñado aquí y está libre y demás, pero yo estoy esperando que llegue el momento. Así que al final, gente, ya van a ver, se va a levantar y bueno, se lleva la mesa, se lleva, se escucha.

**49:31** · Diga, sigas. Perdón, perdón.

**49:33** · Dame solo un segundito porque me voy a abrir otra cervez porque este momento me parece muy bien y tres me bien. Vaya, voo. Te tengo la gente.

**49:40** · Aquí la tengo aquí.

**49:40** · Ah, vale, vale.

**49:41** · Como buencho, me traje cuatro antes de Está perfecto.

**49:44** · Está bien. Los directos hay que hacerlos así, tío.

**49:47** · Entonces, ¿qué pasa? En esa capa de transporte es donde después va a hacle cosas, cosas. Ya hemos definido nuestra capa de transporte es http, pero vamos a hacerle cosas. Entonces, el tema con esto es vamos a levantar el servidor, ¿vale? Vamos a ir a la otra carpeta donde está 01 http no sé qué. Yo tengo un make que lo único que hace es un go run con la configuración.

**50:04** · Espera, explica a la gente que es el make, eh, porque hay muchos que no lo usan. Me encantan los make, a mí me parecen alucinantes.

**50:10** · Vale, primera cosa que hay que explicar es la configuración. ¿Te acuerdas que te dije antes en el fichero de configuración a mí me gusta meterle, ¿no?, un poquito de fantasía. Luego veremos cosas, ¿vale? Veremos cosas que aquí hay un pequeño spoiler, pero ahora mismo solo hace falta la parte de arriba. La parte de arriba, que es lo típico de en que puerto se levanta cosas, ¿no? Make es una manera muy vieja. antes se usaba para generar realmente generar assets, ¿no? Cuando tú compilas en los programas en C siempre te salen pues los códigos objetos por un lado, luego esos los links, un montón de proceso que pasa en el medio antes del ejecutable en binario.

**50:39** · Entonces Mil es un mecanismo eh un mecanismo para automatizar todo este tipo de pasos, de manera que tú le puedes hacer make run y haga una batería de cosas, una receta, make y otras recetas. Hoy en día hay alternativas más modernas, pero Medic está en todos lados. Entonces, ¿para qué usar otra cosa cuando Make ya está allí?

**50:56** · Exao, en todos lados se usar.

**50:57** · Pero para los J scripters, gente, pienso, como en el pack jason, la parte de scripts, prácticamente ustedes hacen pnpm ran o npm ran o ban, run, lo que sea. Acá lo mismo, ustedes hacen make y el comando que ustedes quieran y esto ejecuta un script o lo que sea.

**51:11** · Alan tiene un Mac y el Make también le va a ir. Yo tengo Linux y el Make también me va ahí, ¿sabes? M hasta en Windows, eh, les aviso.

**51:16** · Ni lo nombramos Windows, pero bueno, el W, el innombrable. Otra, no se puede nombrar ni la roja, ni la violeta, ni la verde, ni la W. Ahora ya está.

**51:24** · Wiene Bill Gate. TP.

**51:29** · Entonces, Make al final, pues yo lo único que he hecho es un fichero make que cuya receta más importante realmente es el buil y el rank. Estas dos recetas que tengo, una ejecuta para buil y el otra ejecuta para rank. No tiene más nada para Go. Lo podría hacer directamente. Sí, pero corto.

**51:44** · Es como un alias, gente, como un atajito. Sí.

**51:46** · Entonces, vale, vamos a ejecutar el rank. Es lo mismo que hacer un go run, ta ta ta, ¿no? Entonces, ejecutamos el rank y ahí tenemos el servidor corriendo. Entonces, ¿qué pasa con Cloud Web? Vamos a ver qué pasa por allá.

**51:55** · Vale, vamos a cerrarlo y volverlo a abrir porque pasa una cosa, las herramientas de este tipo a veces están un poco bugueadas, ¿vale? Si yo ahora me voy a developer, es verdad que este está aquí, te pone running, pero es posible que no lo pueda ver en el chat. Él detecta que hay un server. Mira, si lo ha detectado esta vez sí lo ha detectado cl actualiz no importa, no importa. A veces sí, a veces no. Decosó y listo.

**52:13** · Sí. No, no, pero tiene eso. A veces hay que reiniciar el programa para que el server que ya estaba levantado lo detecte. Se configura de la misma manera. Hay que ir a aquel ficherito, ¿vale? A aquel ficherito, añadir la configuración. Eso siempre que sea en local, eso siempre que sea cloud web.

**52:25** · Cloud web solo entiende de cosas locales. La remota la entiende, pero ahí hay. Entonces, ¿qué pasa? Misma técnica, nos vamos al ficherito. Este ficherito que estaba por aquí, ¿vale? Mismo ficherito. Acá, ¿vale? ¿Qué tenemos? que el problema es que es un server remoto.

**52:38** · Es un server remoto. Entonces, como cloud web cloud web no, perdona, cloud de eso solo entiende SIO, tenemos que ponerle algo en medio para que se comunique el cloud con SDIO, pero luego esa cosa se comunique con el protocolo HTTP. Así mismo se empieza a probar en producción porque ya te estás conectando con un server que ese sí lo podrías desplegar y podrías hacer cosas, ¿vale?

**52:57** · Entonces, lo único que necesitamos es una cosa en el medio, que la más famosa que hay es MCP Remote. Van a ver por ahí en todo internet que cuando tengas un servidor de este tipo y lo quieras conectar aquí, todo el mundo te va a decir MCP Remote. Esa es la herramienta.

**53:09** · Esa es la herramienta. Entonces, bueno, eso tiene unos parámetros de configuración con su flags y demás al final. Y eso es lo que le hemos metido aquí, un server MSP levantado en el 80.

**53:17** · Poco más. Todos los parámetros que hay aquí son los que te pide él para para conectarse más uno extra que le he metido yo aquí, que este es para ti, Alan, para tu stream, guapo. ¿Vale?

**53:27** · Entonces, ¿este sirve o no sirve? Pues todo lo que te da Hronic está ultraprobado, ¿vale? Entonces, ¿qué pasa? Vamos a ver. Usa las tools del server http. Se lo podríamos decir sin contexto, ¿vale? Sin contexto. Lo que pasa es que a mí me gusta darle contexto porque tengo tres muy mal definidos y entonces quiero que en el directo la peña lo vea bien.

**53:45** · Por las dudas te lo digo ya. dentro de un público argentino. Nunca digas demme contexto.

**53:51** · ¿Cómo? ¿Cómo que nunca diga eso?

**53:52** · No, no, pero pero repiteo que nunca pidas contexto, ¿vale?

**53:57** · Porque te van a contestar. Te la doy con No, déjala, déjala ahí. Bien, eh, sigue.

**54:02** · Mira, ya está. Te la doy sin pretexto.

**54:04** · Ya tiene que aparecer el famoso. Bien, siga, sigue. Perdón.

**54:06** · Vale, entonces esto ha ejecutado, ha ejecutado otra vez en remoto, se ha ido a pedir la información. Él lo ha dicho aquí, o sea, he usado las herramientas de este. En este caso era la misma herramienta, era un Hello World, estos muy tontos, ¿no? Entonces, bueno, ha hecho lo mismo, ¿vale? Entonces, ¿qué pasa? Y aquí es donde vamos a empezar a hablar del conector. Y aquí es donde vengo con el regalo, mi regalo para la comunidad, para tu comunidad, ¿vale?

**54:26** · Ah, cosas gratis.

**54:28** · Sí, como buen latino. Vamos bien. Siga, siga.

**54:31** · Me encanta.

**54:33** · Vale, he hecho un template la semana pasada con todo lo que hace falta para que tengas un servidor MCP hecho facilito y que cumpla todos y cada uno de los requisitos de cloud web para poder en este proyecto está es un template, o sea, te bajas el código y simplemente rellenas cosas, cambias cosas, pero ya está todo hecho. Tiene la piline de DCI para que puedas construir, para que la puedas desplegar. Tiene el char de Helm para que lo puedas desplegar también con la configuración y demás facilito. Y el código, bebé.

**55:00** · Muy bien, está espectacular, eh, gente, ya mismo se van todos realmente, eh, si alguien está en el Discord, por favor, copien y peguen la URL, así la gente ya iba yendo. Y en serio, vayan a poner estrellitas porque esto no es fácil, esto tiene cositas, eh, en serio, eh, posta, póngale garra.

**55:18** · Lo agradezco. Lo agradecería porque esto es muy e este streaming ha costado la friolera de un clúster de cubernetes, un istio, un kicloac, un template entero con todo el conocimiento de dos semanas acumulado que lo hemos tenido que hacer para la empresa más toda la preparación de Alan. Y yo que le he dado por culo toda la semana porque hoy mis nervios del stream. En los nervios de este tío, ustedes no tienen la más mínima idea.

**55:43** · Sí, se los digo en serio. Los nervios que ha tenido este chico para venir acá y hablar con ustedes sabiendo los asquerosos que son, la verdad, hay que aplaudirle, ¿eh? Es un cracken, gente.

**55:52** · Es un cracken. Y aparte, digan la verdad, impresionante el contenido, ¿eh?

**55:55** · Impresionante, impresionante.

**55:57** · Esto no lo van a ver en ningún sitio, ¿eh? O sea, esto es increíble.

**56:00** · Exacto, exactamente. Y menos de la manera que lo vieron hoy. Así no más.

**56:03** · Bien, como siempre, contenido al pie, al detalle y divertido, que es lo más importante. Yo creo que todos acá nos hemos divertido, así que más vale que ustedes están mínimo.

**56:11** · Espero que si alguien no se ha divertido que venga y me lo diga la cara. No, no que la calle Uruguay 300. No.

**56:18** · Oh, te imaginas. No, no, no. Habla que yo yo meto el \[ \_\_ \] El p no no digas cómo vas a meter el \[ \_\_ \] está loco.

**56:26** · Uso doble sentido adrede, tío.

**56:28** · Así que ya saben, gente, si llego a decir la dirección, él me mete el \[ \_\_ \] Muy bien, espectacular. Muy bien, muy bien, muy buena esa. Eh, mira y aparte fíjate acá dice José Bravo, "Se siente como un stream muy de la casa. Felicitaciones al ponente. O sea, que ya me la estás poniendo, me están diciendo. Espectacular. Muy bien, buenísimo, buenísimo. No, que en serio, el mejor contenido. Eso cierto, eso sí, sí. Está muy bueno esto, eh, la verdad, espectacular.

**56:51** · Así que gente, en serio, ya mismo se lo van a ver ya mismo, ya urgente y se van a robar este GitHub, le hacen un fork y después lo venden y ya está y listo, como tiene que ser. Si estabas pensando en lanzar un MCP en tu empresa o tenías eh la empresa tenía en mente algún producto, ya sabes que con esto lo puedes sacar muy rápido.

**57:10** · Lo que él no te dice es que dentro del código hay un EASEG que si le haces cuatro peticiones a la MCP a la quinta, ya te roba todos tus datos, te bloquea la máquina y te hace un ransonware que te morís, ¿me entendés?

**57:22** · Todo, todo, todo. Mino criptomonedas con cada request, cabrones.

**57:26** · Eso es. Así que Mister, yo te lo agradezco. Esto va directamente para la roja en canal premium, así no más. Y nada, eso urgentemente vos tenés que pedir aumento salarial, ¿eh? Ya te lo que no te pierdan, que no te pierdo.

**57:37** · Gracias, gracias, gracias. Una es Hello World, ya ves que el de producción tiene dos. La otra es Wamai, ¿sabes? O sea, mira la tool que he hecho, ¿sabes?

**57:43** · La escucha funciona, ¿no? Sí que funciona. Entonces, ¿qué pasa? La config template tiene varios apartados. Tiene varios apartados porque como dije cumple todo lo que te pide Cloud Web. Entonces en esa config se puede activar y configurar el de protected resource, el en point, ¿vale?

**57:59** · Porque pudieras hacer un MCP con esto para openi. Entonces en ese caso ya desactivas este point, te vale también para Open, pero si lo quieres para cloud lo tienes que activar. Eso para el protector. Para el autorization server pasa lo mismo, pero los parámetros son menos. Lo puedes activar y desactivar y decirle que eh qué bastión copia. Le das la dirección del isuber del bastión y él ya sabe la dirección o el t ta ta. se va allí, copia y y esa es la información que hace Espejo, ¿no? Luego también tiene dos regalos. Para aquellos que sean eh muy pros en infraestructura, como somos nosotros en Prepic, recuerda esto porque no nos vas a poder entrar en la infraestructura que lo sepa.

**58:29** · Cuidamos mucho los datos del usuario y hemos visto un montón de ataques. Para los que sean muy capo en esto, tien la posibilidad de tener algo delante de tu de tu MCP, algo delante como ISO, por ejemplo, que es una herramienta muy famosa, es un gateway muy famoso que tiene herramientas para peer, para proteger, para enrutar, para un montón de cosas y una de las que tiene es para para él tener la configuración del del bastión de los certificados y demás y entonces tu API ya no necesita la protección de Jason Woken porque él te la hace por ti y solo te da la request cuando eh cuando realmente es legítima, ¿no?

**59:01** · Como sé que hay empresas de todo tipo, hay aquí configurado y me he currado un middlew completo.

**59:08** · Ese middlew recoge los certificados cada cierto tiempo, los almacena, que va renovando y con esos certificados él comprueba la validez de esos Jason Web token. Así que ya no tienes la excusa de tener infraestructura delante que pueda hacerte esa validación para desplegar esto. Ya no necesitas sino una máquina virtual cochina con un docker comp. ¿Qué pasa? que pudieras querer validaciones mucho más hardcore.

**59:31** · Y para eso me he currado otro regalo para tu canal, que es que una vez que el Jason Web Token es válido para entrar, puedes pedir en los claims, ahora lo comentamos esto, puedes poner expresiones cell, que son unas expresiones para para un intérprete como como JQ, ¿no? Como JQ o menos, pero más potente. Puedes poner expresiones aquí para comprobar cosas de ese Jason Web Token, quién lo emitió, qué grupos vienen, qué usuario es el que está entrando para que puedas restringir el acceso a tu MCP, a lo que tú quieras. Y eso todo está integrado aquí en el Middlew que me he currado para tu comunidad.

**1:00:02** · Sos un genio. O sea, sos un genio.

**1:00:04** · Ahora, lo que nos está diciendo también es que después de acá le tengo que dar una cuenta, va, él me va a dar una cuenta bancaria y bueno, cositas, no, cositas. Regalo para mi comunidad.

**1:00:13** · Oro, por favor. No, no, no, no. Nada de euros, no, oro, oro.

**1:00:17** · Clásico, español. Es que clásico y bueno, por eso gente se llevan cobre porque el oro ya se lo llevó. Es así, eso así. Patac de la plata. Tienes el país de la plata. Cosa intermedia, hombre.

**1:00:30** · A ver, ese p de la plata porque el oro ya se lo llevaron, obviamente.

**1:00:32** · No, no. Lo que digo es que me podías pagar en plata y estás queriéndome pagar en cobre. Eh, eh, explotador.

**1:00:38** · Bueno, escúchame. Va bastante bien.

**1:00:39** · Bastante bien.

**1:00:40** · ¿Es eso o el pack? Un pack bien mandado y creo que hacemos bien.

**1:00:44** · Me quedo con el pack.

**1:00:45** · Venimos a Claudia. Sí, sí, venimos a Claudia. Venga, settings, sí, connectors, adcast cons, nombre de tu MSP. Y si cumples todos los requisitos, incluyendo aquel tan famoso de Dynamic Lent Registration, automáticamente te irá a Google o a Google o a las cuentas que tú le hayas metido, una vez que estás logueado, literal, te aparece aquí y a partir de ahí ya lo tienes conectado. Solo has necesitado hacer un sacrificio satánico, degollar una gallina, rezar tres padres nuestros y lo normal, lo normal, espectacular, espectacular.

**1:01:13** · Y funciona. Pues sí, pues la verdad, la verdad es que sí. Mira, eh, quién soy. Usa las tools.

**1:01:18** · Momento de la verdad, gente. Dice que funcione y ya veo que perdón. Sigue así.

**1:01:21** · Mira, mira, mira, está ejecutando el tools que tiene. Y mira, mira, mira, mira, mira, porque le he dicho, te acuerdas que te que que te dije que le podías dar un promp.

**1:01:28** · Yo le estoy mandando el Jason Web token, ¿vale? Se lo estoy mandando por aquí el Accessock y le estoy diciendo antes de eso, Access, cuidado que los datos, mira, están los tienes que decodificar primero. Entonces él se marca un script para hacer eso. Mira, mira, mira, mira, mira, mira. Información sobre tu identidad. Y como soy el admin de KCloa, que es verdad que me he conectado con la cuenta de admin, pues aquí me está diciendo \[ \_\_ \] Ojo, ojo, eh, que no te tires. Ya, ya me la veo venir.

**1:01:48** · No, no pasa nada. Me aseguré de permitir el acceso a eseclock solo desde mi casa.

**1:01:54** · Muy bien. A ver, ¿qué tipo inteligente, verdad? Ya he visto muchos stream del Chocas donde de repente se filtran, no sé qué y le tiran el directo.

**1:02:02** · Sí, sí, sí. Y no solamente eso, yo te digo, bueno, ha habido cosas peores, ¿eh? Yo te digo que ha habido cosas peores. No, no, pero esto es alucinante, Mister. Eso alucinan, qué buen contenido. Qué buen contenido. Con esto, con esto y un bizcocho. Ráscate el digo mañana a las 8.

**1:02:17** · Nos fuimos.