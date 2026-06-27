---
title: "La EVOLUCIÓN del contexto compartido entre AGENTES: Engram Cloud"
source: "https://www.youtube.com/watch?v=JPZkbGgJNUQ"
author:
  - "[[Gentleman Programming]]"
published: 2026-05-02
created: 2026-06-27
description: "🚀 Un cerebro en la nube que conecta TODAS tus IAs. No importa si estás en la oficina, en tu casa o en la laptop del café: todos tus agentes comparten la misma memoria. Engram ya existía como cerebro"
tags:
  - "clippings"
---
![](https://www.youtube.com/watch?v=JPZkbGgJNUQ)

🚀 Un cerebro en la nube que conecta TODAS tus IAs. No importa si estás en la oficina, en tu casa o en la laptop del café: todos tus agentes comparten la misma memoria. Engram ya existía como cerebro local. Ahora con Engram Cloud podés sincronizar ese cerebro entre múltiples máquinas, múltiples proyectos y múltiples equipos de trabajo. Self hosted, open source, deployado en tu propio servidor. En este video te muestro el deploy completo paso a paso en una VPS de HostGator  
  
📌 TIMESTAMPS  
0:00 Intro - Cerrás la laptop y tu IA olvida todo  
0:37 Soy Alan, GDE, MVP, creador de Engram  
1:00 Tres temas: problema, solución, lanzamiento  
1:29 Sponsor: HostGator (donde deployamos hoy)  
1:48 Los modelos no tienen memoria real  
2:11 Recap de Engram: Go, SQLite, FTS5/BM25  
3:29 Demo: Open Code pregunta a Engram y ya sabe todo  
4:35 El problema entre máquinas: cada una tiene su SQLite  
5:53 Engram Sync manual es tedioso y puede ser público  
6:05 Nace Engram Cloud: local first, self hosted, open source  
6:40 Tres funciones: replica, dashboard web, self hosted  
7:06 Arquitectura: tres superficies, un binario, una fuente de la verdad  
8:27 Seguridad: 5 etapas de defensa en profundidad  
10:33 ¿Por qué una VPS? Siempre arriba, IP pública, HTTPS  
12:04 Deploy paso a paso: SSH a HostGator  
13:06 Git clone + Docker compose build  
14:26 Stack levantado y health check OK  
15:32 Probando desde afuera: engram.condetuti.com  
16:01 Autenticación: Bearer token (máquina) vs cookie HMAC-256 (humano)  
17:40 Cliente: config, token, enroll, sync  
19:24 Auto-sync: ciclo cada 30 segundos con backoff inteligente  
21:29 Demo: guardamos observación y aparece en el dashboard sola  
22:39 Dashboard: proyectos, categorías, sesiones, panel admin  
25:47 Recap: 5 puntos clave  
27:02 Tu data es tuya. Open source, self hosted, local first  
27:38 Cierre  
  
🧠 QUÉ VAS A APRENDER  
\- Por qué los agentes no tienen memoria real y cómo solucionarlo  
\- Engram Cloud: sincronización automática cada 30 segundos entre máquinas  
\- Local First: SQLite manda, Postgres replica, si el cloud cae seguís laburando  
\- Seguridad: 5 etapas de defensa en profundidad  
\- Deploy completo en VPS paso a paso (SSH, Docker, HTTPS, DNS)  
\- Dashboard web para ver qué tiene tu agente en la cabeza  
\- Autenticación: Bearer token para máquinas, cookie HMAC-256 para humanos  
  
━━━━━━━━━━━━━━━━━━━━━  
  
🧩 ENGRAM CLOUD  
  
\- Local First: SQLite local es la fuente de la verdad, siempre  
\- Self Hosted: deployalo en TU servidor, no en el mío  
\- Auto-sync cada 30 segundos con backoff inteligente  
\- Dashboard web para explorar memorias por categoría  
\- 5 capas de seguridad: red, SQLite, opt-in, HTTPS+token, allowlist  
\- Open source y gratuito  
  
━━━━━━━━━━━━━━━━━━━━━  
  
📦 REPOSITORIOS  
  
\- Engram: https://github.com/Gentleman-Programming/engram  
\- AI Gentle Stack: https://github.com/Gentleman-Programming/gentle-ai  
\- Gentleman.Dots: https://github.com/Gentleman-Programming/Gentleman.Dots  
  
━━━━━━━━━━━━━━━━━━━━━  
  
🖥️ HOSTGATOR VPS - SPONSOR  
La VPS donde deployé Engram Cloud en este video  
→ SSH + Docker + HTTPS con Let's Encrypt  
→ Siempre arriba, IP pública, backups  
→ Menos que un café por mes  
  
🎯 Descuento exclusivo con mi link: https://www.hostgator.la/7607-10-3-9.html  
Sin el link perdés el descuento.  
  
━━━━━━━━━━━━━━━━━━━━━  
  
🤑 DESCUENTOS EXCLUSIVOS  
  
💻 CodeCrafters - Challenges reales  
→ https://app.codecrafters.io/join?via=GentlemanProgramming  
  
🎧 Linsoul Audio  
→ https://www.linsoul.com/GentlemanProgramming  
  
━━━━━━━━━━━━━━━━━━━━━  
  
📺 DONDE ENCONTRARME  
\- Twitch: https://twitch.tv/gentleman\_programming  
\- Canal VODS: https://m.youtube.com/@GentlemanProgrammingVods  
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
Suscribite y activá la campanita 🔔  
  
#EngramCloud #Engram #IA #LocalFirst #SelfHosted #VPS #HostGator #MCP #SQLite #Postgres #OpenSource #GentlemanProgramming #DevTools #Deploy #Memoria #Agentes

## Transcript

### Intro - Cerrás la laptop y tu IA olvida todo

**0:00** · Abuela, salió vídeo de Gentleman.

**0:03** · Imagínate esto, estás logrando con tu agente de IA, le explicas todo el contexto del proyecto, le pasas 200 mensajes y por fin entiende. Cerras la laptop, te vas a otro lado, abrís otra máquina y arrancas de cero otra vez.

**0:17** · Toda esa memoria que construiste, la gente que ya entendía cómo pensas, qué arquitectura usas, qué te gusta, qué no, se fue a \[ \_\_ \] Hoy le ponemos punto final a eso y de paso te muestro cómo voy a desplegar en gran cloud, en una VPS de HostGator, paso a paso, real, vamos allá.

**0:36** · Primero de todo, si es la primera vez que entras al canal, soy Alan Google Developer Expert en Angular, Microsoft \[música\] MVP y creador de este hermosísimo canal y también el creador de Gently AI y de Engram, \[música\] que ahora mismo tiene su versión cloud.

### Soy Alan, GDE, MVP, creador de Engram

**0:50** · Entonces, vengo justamente haciendo herramientas para desarrolladores hace bastante tiempo. Hoy vamos a tocar tres cosas.

**0:59** · El problema real de la memoria de los agentes, la solución que vengo construyendo, que se llama Engram, y el lanzamiento de Engram cloud, que es la pieza que faltaba para que esto funcione entre múltiples máquinas. Y te muestro el deploy completo en producción. Así que, si te interesa que tu agente recuerde lo que vos sabes, sin que tu data viva en un SAS de moda y a toda locura, porque esto es open source y sobre todo gratuito. Antes que nada, para un poquito, este vídeo te lo trae por parte de HostGator, que además resulta ser literalmente donde voy a desplegar todo esto. No es un sponsor que está pegado con cinta, mamá.

### Tres temas: problema, solución, lanzamiento

### Sponsor: HostGator (donde deployamos hoy)

**1:31** · Esta VPS que estoy usando ahora mismo en producción para Engram cloud es con HostGator. Si quieres probar lo mismo que vamos a hacer en este vídeo, te dejo el link con el descuentiño en la descripción. Vamos \[música\] a lo que importa. Bien, este es el tema, cuando vos laboras con un agente de IA, sea cloud, sea open code, sea cursor, sea lo que sea, hay algo que es la mayoría de la gente no entiende y es que el modelo no tiene memoria. O por ahí las soluciones que tienen son bastante como la de Claudio.

### Los modelos no tienen memoria real

**1:58** · Cada vez que abrís una conversación nueva, vos arrancás de cero, lo único que hace es que parezca que se acuerda es que vos le pegás el contexto o que algún sistema le pega el contexto por vos. Y acá entra En Gram.

### Recap de Engram: Go, SQLite, FTS5/BM25

**2:11** · Vamos a hacer un recap rápido para los que no lo conocen. En Gram es un servidor MSP de memoria, escrito en Go con SQLite local en tu máquina, bien, tiene búsqueda semántica FTS5 BM 25, todo el combo espectacular. ¿Qué quiere decir esto?

**2:27** · Que cuando vos hacés ti a ver, tiene todo un sistema de búsqueda, bien, basado en texto y una de las cosas que nos permite justamente es poder buscar dentro de toda esta base de datos no solamente palabras, sino también frases, ver un poquitito el sorting de prioridad que me puede traer sobre lo que yo ya tengo. Después voy a hacer un video de todo esto porque está interesantísimo. Pero prácticamente si yo tengo una base de datos la cual, por ejemplo, ¿no?

**2:53** · Tiene un contexto y dentro de ese contexto es el libro gordo de Petete y en ese libro gordo aparece 400 veces la palabra que no tiene la misma prioridad que en un fragmento de un parrafito de cinco líneas que diga también que. Es mucho más prioritario ese segundo, ¿bien? Además también que no es muy prioritario, ¿se entiende?

**3:15** · Entonces es buscar la rareza de la palabra junto también con su ocurrencia y dentro del contexto en el que está.

**3:22** · ¿Qué importa? Que esto es rapidísimo.

**3:24** · Esa es la parte más importante y no pesa nada, ¿bien? Entonces tu agente le pregunta a En Gram, En Gram le devuelve el contexto relevante y de repente tu agente tiene memoria persistente entre \[música\] conversaciones. Les voy a mostrar un poquitito, vamos para allá.

### Demo: Open Code pregunta a Engram y ya sabe todo

**3:37** · Por ejemplo, acá estoy con Open Code, ¿bien? Mi dioso de la vida. Y si ven acá abajo dice que estoy dentro de mi repositorio de En Gram. Entonces le voy a preguntar, por ejemplo, ¿qué estábamos haciendo sobre En Gram? Le voy a tirar así no más, ¿eh? Ahora lo haciendo con chipití y miren, lo primero que hace es buscar dentro de engram el contexto del proyecto y ahí está. ¿Cuánto tardó esto?

**4:00** · ¿Cuántas veces tuvo que ir hacia atrás, revisar el código? Nada, ya sabe todo.

**4:08** · Esa es la idea justamente, ¿bien? Por ejemplo, me he apoyado junto con engram y demás para poder mejorar lo que estoy hablando con ustedes ahora mismo. ¿Por qué? Porque a mí no me gusta hacer scripts, no les voy a mentir, no me gusta hacer scripts, no me gusta seguir los scripts, me gusta hablar todo naturalmente, pero me gusta tener al menos una guía. Entonces, esto me ayuda un poquitito, ¿sí? Entonces, ahí lo tienen. Esto está espectacular. \[música\] Vamos a ver un poquitito más. Yo tengo más de una máquina, ¿bien? Yo tengo una máquina de trabajo y tengo una máquina mía personal con la que hago los streams y demás.

### El problema entre máquinas: cada una tiene su SQLite

**4:39** · Entonces, yo me muevo entre \[música\] máquinas. Tengo, de vuelta, la de laburo, la personal y cada una tiene su propia base SQLite local de engram.

**4:49** · Cada una es su propia memoria. Entonces, ¿qué pasa? Hay una forma con engram ya de por sí de poder sincronizar la memoria, que es que tiene un comandito que se llama engram sync. Les voy a mostrar qué es lo que hace. Por ejemplo, vamos a hacer bien grande. Yo voy a decir engram sync y van a ver que esto lo que hace es ver todas las observaciones que hizo en mi máquina, que por cierto, si hacen engram tweet lo van a poder ver, ¿bien? Ahí están todas las observaciones con cada una de sus cosas y demás. Espectacular.

**5:16** · Y claro, yo lo que quiero hacer es guardar estas observaciones, si yo ahora, por ejemplo, lo abro esto con en vim y voy a la carpetita engram, van a ver que acá están las observaciones guardaditas, haseadas, chiquititas y después un manifiesto que justamente controla versiones. Esa es la idea principal de todo. Claro, esto después vos lo podés subir a un repositorio y del otro lado la persona hace engram sync import y ya está, tiene todo lo mismo, lo puedes compartir tanto con vos mismo con un integrante del equipo.

**5:48** · Pero mira, tedioso y aparte estás guardando algo en un repositorio que puede ser público, ¿eh? Ojitos con esto, ¿no? Entonces, perdemos la continuidad de las cosas.

### Engram Sync manual es tedioso y puede ser público

**5:58** · ¿Se entiende ese dolor? Porque ese era el dolor mío usando mi propia herramienta. Cuando te das cuenta que el dolor lo sufrís vos primero, ahí es cuando tenés que construir una solución.

### Nace Engram Cloud: local first, self hosted, open source

**6:09** · Para resolver esto, hoy lanzo Engram Cloud. Y antes de que alguien me salte por los comentarios, no, no es una SaaS, no te estoy obligando a meter tu memoria a mis servidores, no es Cloud Only.

**6:21** · Engram Cloud es Local First. Repito, porque sé que alguien se le va a escapar, Local First, la fuente de la verdad sigue siendo tu SQLite local. Si mi servidor se cae, vos seguís laburando como si nada, es así. Y aparte, te doy todo para que lo montes en tu servidor, privadito, todo tuyo. ¿Se entiende?

### Tres funciones: replica, dashboard web, self hosted

**6:40** · Espectacular. ¿Qué hace entonces el Cloud? Tres cosas. Uno, replica tu memoria entre tus \[música\] propias máquinas, es copiada por proyecto. Dos, te da un dashboard en el browser para que vos, humano, puedas ver qué tiene tu agente en la cabeza. Tres, y la más importante, lo desplegás vos en tu infra self-hosted, no es mi server, es el tuyo. ¿Empezamos a entender la diferencia? Bien, vamos al cómo. Vamos a hablar primero cómo se comunica. Hay tres superficies, un binario en el medio, es super-super sencillo.

### Arquitectura: tres superficies, un binario, una fuente de la verdad

**7:11** · Vos tenés tu cliente, el agente con el que trabajás, que sea Claude, que sea Open Code, Cursor, Codex, lo que vos quieras, eso se comunica con un MSP a tu base de datos local, que es un binario de Go, super simple, ya está, pim pum pam, y esto tiene tu fuente de la verdad, ¿bien? Que es tu propio Engram, como vimos hace un ratito, tiene tu propia base de datos. Lo que vamos a estar haciendo es que esto se va a comunicar por un HTTPS con token y demás, ¿bien?

**7:41** · ¿A dónde? A un remoto, al servidor, ¿sí?

**7:45** · Esta parte es opcional, vos si querés la tenés y si querés no, pero si la tenés, vas a poder sincronizar en cualquier momento sin ningún tipo de problema. Eso es lo que queremos, pero siempre esa base de datos va a ser una réplica de lo que vos tenés en tu máquina o en tus máquinas o en la de tus compañeros.

**8:05** · Entonces, si vos mañana vas, borrás el Cloud entero, tu memoria sigue intacta en SQLite. Si yo mañana cierro en Gran Cloud, tu memoria sigue intacta en SQLite. Esto no es negociable, es local first, siempre. SQLite manda, Postgres replica. Son tres superficies, un binario, una fuente de la verdad. Pero vamos a hablar un poquitito del tema de la defensa ante todo esto. Ahora la parte que más me importa, porque sé que a algunos les preocupa, incluyéndome a mí, el tema de la seguridad. Acá tenemos cinco etapas, defensa en profundidad.

### Seguridad: 5 etapas de defensa en profundidad

**8:33** · La etapa número uno, acá tenemos, que es la de la gente en sí, sin red, habla por este tío nomás, no tiene cómo hacer request externos por su cuenta. La etapa número dos es justamente lo que sería la base de datos local, que es la fuente de la verdad. Tu máquina, tu disco, no sale de ahí, salvo que vos lo decidas. La etapa número tres es el enrolamiento opt in por proyecto. Yo puedo ir a cualquier proyecto y decir, quiero subir este, ¿bien?

**9:04** · Y ese es el que yo quiero justamente sincronizar con en Gran Cloud, si no, no lo hace, tenés que decidir y decirlo explícitamente, este proyecto sincroniza al Cloud. Por defecto, nada se sincroniza, nada. Después tenemos la parte número cuatro, la de HTTPS más better, ¿qué es esto? Tenemos un token.

**9:26** · Sin ese token, no entrás. Sin HTTPS, no hay request. Y después la etapa número cinco es el allow list más Postgres.

**9:35** · ¿Qué quiere decir esto? Hay un allow list de proyectos en el server, bien, más el tema de Postgres, que es que aunque tengas el token correcto si tu proyecto no está en la lista de permitidos, el server te rechaza, punto, ¿bien? Y ahora la fase que define todo esto justamente es que cada puerta vaya cerrada, ¿bien? ¿Qué quiere decir esto?

**9:58** · Tranquilos, a un desconocido la rico es rechaza por defecto, no hay un no sé qué es esto, dejarlo pasar, es que no sé qué es esto, fuera, como decía Milei. Eso es defensa en depth bien hecho. Esto no es magia ni es nuevo, es ingeniería sólida.

**10:14** · Si querés profundizar en local first, miren a Martin Kleppmann, por ejemplo, lean el paper de local first software, hay literatura sobre esto. Yo estoy parado sobre los hombros de gente que pensó esto mucho antes que yo y acá no quiero reinventar nada, yo quiero reinventar la forma que sus agentes guardan información. Ahora, ¿por qué una VPS? Te voy a hacer una pregunta, ¿dónde vas a desplegar tu cloud? Porque no es magia, necesitas un server. Acá hay opciones, tenés Colab, Raspberry Pi, eh mini PCs.

### ¿Por qué una VPS? Siempre arriba, IP pública, HTTPS

**10:39** · Yo tengo por ejemplo un Beelink que estoy usando para hacer inferencia local, pero para esto lo que querés es algo que esté siempre arriba, con IP pública, con HTTPS, con backups, sin pelear con tu router todo el día y ahí entra una VPS y por eso elegí HostGator. ¿Qué necesito de una VPS para en Gan Cloud?

**10:58** · Acceso root por SSH, tengo justamente Linux moderno, este tiene AlmaLinux 9, tengo Docker, lo instalo, reverse proxy, en este caso Apache, porque ya viene en el stack de cPanel de HostGator, tengo entonces HTTPS con Let's Encrypt, tengo DNS apuntable a la IP, lo manejo desde cualquier gestor que tengan ustedes de dominio, vos podés desde donde quieras hacer esto, ¿bien?

**11:26** · Entonces, no necesito Kubernetes, no necesito una infra AWS de $1,000 por mes, una VPS configurada, listo. Es así de fácil. Y para el que está arrancando, una VPS es barata. Por menos que un café por mes, tenés algo que corre 24/7.

**11:42** · Para un dev que está aprendiendo, esto es oro. Yo te recomiendo HostGator, no porque me paga, te lo recomiendo porque la estoy usando ahora mismo en este video y porque justamente quiero que los devs que arranquen tengan una opción más balanceada que encontré en cuanto a lo que es precio, control, ¿bien? De vuelta, tenés el link en la descripción, descuento incluido. Vamos a desplegar.

**12:02** · Esto es muy sencillo. Si ustedes van, por ejemplo, a HostGator, van a ver que esto tiene eh lo que es una IP, obviamente, y también un lugar para cambiar una contraseña. Ahí se los muestro. Entonces, acá estoy en el panel justamente de de lo que es de configuración del usuario, en la parte de hospedajes y servidores. Tengo acá la VPS y yo directamente voy a poner, miren, ¿eh? Administrar, y acá lo tienen, ¿sí? Tengo acá la IP que tengo asignada, tengo en esta partecita de acá también la posibilidad de cambiar la contraseña, ¿sí? Son todas las cosas que yo necesito, ahí lo tienen.

### Deploy paso a paso: SSH a HostGator

**12:33** · Entonces, yo me voy a comunicar con este puerto a esta IP y con esa password. Y con eso vamos a tener justamente la posibilidad de poder configurar desde adentro todo para que esto funcione. Y es muy fácil, ya van a ver. Yo desde código voy a hacer SSH, voy a poner justamente la IP con eh lo que sería el puerto. Entramos, voy a poner una contraseña.

**12:57** · No, otra vez. Que está tan segura que me hasta me equivoco. Entonces, claro, en este punto ya tenemos acá la VPS lista, tenemos eh Docker instalado, ¿sí? Si quieren lo pueden instalar, no es muy difícil. Es más, te voy a decir otra cosa, le podría decir a tu agente que lo haga. Te aviso nomás, ¿eh? Te aviso. Y lo único que sí te voy a pedir es que hagas un git clone de Ingram, nada más ni nada menos. ¿Dónde? En opt/ingram.

### Git clone + Docker compose build

**13:23** · Ya está. Entonces, una vez que ya tenés eso, tenés todas las cosas, todo lo que vos necesitás, ¿qué pasa? Vamos a tener dos posibilidades para tener el stack de engran cloud, ¿sí? ¿Por qué? Porque tenemos dos contenedores. Uno es el backend en go y otro es el tema de postgres, ¿sí? Entonces, acordate el diagrama de comunicación. Tenemos en la parte local sqlite, en el cloud tenemos postgres, son roles distintos. Sqlite es tu fuente de la verdad, postgres es el log de réplica entre máquinas, por eso hay postgres acá y no en tu laptop.

**13:56** · Vamos a levantar el stack. Yo voy a hacer cd {barra} opt {barra} engran. Ya estoy adentro. Y ahora hay que hacer un docker compose {guión} f docker compose {punto} en mi caso hostgator.yml app {guión} d {guión} {guión} build y ya está. Esto está buildeando engran cloud.

**14:18** · Es así de sencillo, ¿bien? Así de sencillo. Ahora que ya lo tenemos, vamos a decir docker compose. Vamos a hacer un {guión} f docker compose.hostgator y ahora vamos a decir {punto} yamel ps.

### Stack levantado y health check OK

**14:33** · ¿Qué va a hacer esto? Ahí lo tenemos. Ha literalmente levantado el servicio, ¿bien? Cuando el postgres de healthy, cuando ya tengamos todo listo, van a ver que lo tenemos corriendo. Ahí tenemos el engran cloud y el engran cloud postgres.

**14:47** · Ya está. Vamos a ver los logs. Si algo sucede, algo no te funciona, puedes hacer lo que te voy a decir ahora. Vamos a hacer un doc docker logs {guión} {guión} tail igual a 200 para tener las 200 últimas engran cloud. Y esto me va a decir todo y yo lo tengo levantado y funcionando, ¿bien? Espectacular.

**15:09** · Ahora, vamos a probar que esto funciona.

**15:11** · Vamos a hacer un curl a http {dos puntos} {barra} {barra} 127.0.0.1, porque estamos dentro de la vps. Vamos a poner en este caso el puerto eh 18080 y vamos a tirar un health, todo okay.

**15:27** · Tenemos todo levantado, espectacular, ¿bien? Y ahora lo que vamos a hacer es que como yo esto lo tengo levantado ya en mi dominio, que no hay ningún tipo de problema, vamos a, por ejemplo, levanto otra terminal y desde afuera le voy a pegar a mi dominio engran.condetuti.com/health y ahí lo tenemos, está todo funcionando, espectacular. Entonces, tenemos el cloud arriba en la VPS de Hostgator. Ahora vamos al lado del cliente, pero antes hay algo que te tengo que explicar cómo se autentica. Esto es muy importante.

### Probando desde afuera: engram.condetuti.com

**15:58** · Hay dos caminos de autenticación.

### Autenticación: Bearer token (máquina) vs cookie HMAC-256 (humano)

**16:01** · Tenemos la parte de que es la máquina, ¿sí? De por sí, en tu máquina, en tu CLI, tu cliente automatizado, habla con el bearer token. ¿Qué significa todo esto? Va a mandar el header, lo que es authorization, en cada una de las peticiones HTTPS que se hace a engran.

**16:20** · Cloud, al servidor, ¿bien? El servidor va a matchear el token contra el que tiene configurado en punto em y después va a chequear que el proyecto esté en el allow list. Si todo da bien, el request pasa, ¿bien? 200 okay. En la parte derecha tenemos la parte humana. La parte humana ¿qué quiere decir? Vos, en el browser, ¿bien? Acá no usás el bearer row, hacés un login con el token una vez. El servidor te firma una cookie con HMACSHA256 válida durante 8 horas.

**16:53** · El browser manda la cookie en cada request. El server verifica la firma y renderiza la página, ¿bien? ¿Por qué dos caminos? Esto es muy sencillo, porque una máquina puede guardar un token con seguridad en una envar, ¿no? De toda la vida, una variable de environment. En una secret manager también. Un browser, no. Si vos exponés el bearer token al JavaScript del browser, el primer XSS, bien, Cross-Site Scripting, te lo roba. La cookie firmada con flag HTTP only y secure, JavaScript no la toca, es así.

**17:27** · Entonces, esto de vuelta, yo no lo invento, es OAuth one on one, ¿sí? Es session management one on one, pero la mayoría de las herramientas de que dando vuelta hoy hacen esto mal, acá no.

**17:39** · Entonces, ahora sí, vamos al cliente, la parte que a todo el mundo le gusta. Lo primero que vamos a hacer es, dentro de lo que es la terminal, vamos a decirle Enigmacloud config guion guion server, vamos a decir dónde está nuestro servidor, y este en este caso es enigmacontutti.com.

### Cliente: config, token, enroll, sync

**17:56** · Bien, ¿qué vamos a hacer ahora? Vamos a decirle Open SSL, se lo recomiendo instalarlo, justamente para poder generar este tipo de tokens, vamos a hacerlo con rand hex en 32, y esto te va a dar un token cualquiera, ¿sí? Este que tienen acá, por ejemplo, no lo voy a utilizar yo, pero para que sepan. Y ahora lo que tienen que hacer es un export, ¿ven? Y hacemos así, export Enigmacloud token test test test, por ejemplo, o el que les dije acá arriba, esa es la idea, ¿sí? Entonces, después de esto, tenemos que enrollar lo que es el proyecto.

**18:24** · Esta es la etapa tres del diagrama de seguridad que yo les decía, que es opt in, que es lo que ustedes quieran, ¿sí? Yo, por ejemplo, ya estoy en Enigma, y lo que voy a hacer directamente es Enigmacloud enroll Enigma, nada más ni nada menos. Le dan un buen enter y listo, ya está. ¿Qué podemos hacer después? Una sincronización inicial. ¿Cómo se hace?

**18:47** · De la siguiente manera. Vamos a hacer Enigma sync guion guion cloud guion guion project Enigma, y tirándole esto, directamente se sincroniza con la nube.

**18:58** · Yo no tengo ningún tipo de problema porque ya lo tengo sincronizado, ¿sí?

**19:02** · Pero para que vean cómo es. Si quieren ver el status, tranquilamente, ponemos de vuelta el Enigma sync cloud, pero vamos a poner ahora lo que sería guion guión estatus. Y esto también te va a decir qué onda, ¿sí? Que se sincronizó, qué es lo que ya tenemos, ¿se entiende?

**19:19** · Pero acá viene lo bueno, esto que les acabo de mostrar es sync manual.

**19:23** · ¿Quieres saber cómo funciona el sync de verdad? Porque no te vas a sentar a tipear esto cada 5 minutos, tranquila, chaval. Miren esto. Esta justamente es la gracia que tiene Enram, que bueno, no tienes que hacer nada, lo hace todo la gente, lo hace todo solito. Entonces, claro, ¿qué va a pasar? Esto tiene un ciclo de vida, ¿sí? La autosincronización.

### Auto-sync: ciclo cada 30 segundos con backoff inteligente

**19:41** · El estado uno es inactivo, está esperando, no está haciendo nada, tu máquina respira tranquila. Después, cada 30 segundos va a hacer lo que se llama un tick, ¿bien? Es esta partecita de acá. ¿Qué quiere decir esto, qué es este tick? Enram dispara un ciclo. En el estado dos, ejecutando, lo que va a pasar es que, en verdad, pasan tres cosas en orden. Uno, push de cosas pendientes. ¿Por qué? Porque puede ser que yo me conecto después, ¿bien? O estaba offline o lo que sea.

**20:10** · Entonces, esto va a mandar los chunks locales nuevos al cloud de manera idempotente y iterativa. Después, pull, tráeme las nuevas cosas, trae los chunks que otras máquinas pushearon y están en el cloud.

**20:27** · Y también tenemos registrar, ¿bien? Que es directamente anotar qué es lo que pasó. Entonces, entre todo este proceso, si todo sale bien, saludable, vuelve inactivo, ¿bien? Ese este de acá. Y esto vuelve inactivo y de vuelta cada 30 segundos trata de repetir todo este ciclo, ¿bien? Pero ¿qué pasa si algo falla? Que puede ser esta parte de aquí.

**20:51** · Bueno, puede ser que el internet esté caído, que el servidor esté caído, lo que sea, degradado. ¿Y qué hace? No te bombardea con retries, hace un backoff hasta 5 minutos, o sea, si tu cloud está caído, en lugar de gastarte CPU intentando cada segundo, espera. Y cuando vuelve, sincroniza, ¿bien? Y mira lo importante, si el cloud está caído, vos seguís laburando, tu agente sigue funcionando con SQLite local. Esto es graceful degradation real. La memoria local no depende del cloud.

**21:16** · Bien, ahora sí, te voy a mostrar el wow moment, así como Vamos a pedirle algo. Open code, quiero que guardes en engram un test, ¿bien?

**21:28** · Algo simple que sea una simulación de una decisión arquitectónica, solamente para probar. Listo. Pon también que la gente, si lo lee, se va, lo ignore en el mismo eh la misma observación. Yo le voy a dar un buen enter y esto automáticamente lo que va a hacer es justamente eso. Van a ver que va a aparecer engram en un ratito, ahí está.

### Demo: guardamos observación y aparece en el dashboard sola

**21:54** · Engram mem current project, eso va a analizar en qué proyecto yo estoy parado y ahí acaba de hacer un guardado. Ahí está, el usuario pidió guardar, o sea, que está guardando cuál es eh la prompt y dice engram save content what, observación de prueba que simula una decisión arquitectónica adoptar una arquitectura hexagonal para separar dominio, aplicación e infraestructura.

**22:12** · Guay, es solo un test solicitando que el usuario, etcétera. Ya está guardado en engram como observación de prueba.

**22:18** · Ahora, te pregunto, quiero que vean algo, ¿eh? Esto se fue a engram cloud, pregunta importante. Bien, miren lo que dice, no tiene evidencia, porque esto corre por detrás, no tenés ni idea.

**22:30** · Realmente no tiene ni idea, él no ha ejecutado ese sync y no debería. Vamos a ver la nube, a ver qué pasó. Acá estamos en engram cloud, miren qué bonito que está, para que vean que está en mi dominio, lo me voy a hacer un sign in, ya estamos adentro y ahí lo tienen.

### Dashboard: proyectos, categorías, sesiones, panel admin

**22:45** · Miren qué sexy que se ve esto, está divino, no me pueden decir que no.

**22:49** · Hermoso. Entonces, cosas que podemos hacer acá, tenemos el dashboard que te indica todos los proyectos que vos estés logueados, espectacular. Tenemos acá la parte de browser, donde podemos investigar cosas de mi proyecto directamente y por ejemplo, ver tipos de decisiones como arquitectura, bug fixing, configuraciones, decisiones, descubrimientos, features, patrones, etcétera. Vamos a ir a la parte de arquitectura, ¿bien? Ahí tenemos cositas que hice justamente en el apartado de arquitectura. Vamos a ver también que tenemos diversos proyectos en Engram, por ejemplo, o IntelliJ, que son dos justamente que yo tengo por aquí, ¿bien?

**23:23** · Podemos ver cada uno de ellos, yo puedo entrar, se puede ver qué pasó, por qué pasó, qué archivos se tocaron y qué se aprendió de esto. También las sesiones que estén asociadas justamente a este descubrimiento y más sobre esta sesión.

**23:38** · Además de eso, podemos ver quiénes están subiendo cosas a Engram Cloud y podemos ver sus observaciones también, ¿sí?

**23:45** · Directamente. A su vez, tenemos también un panel de administrador donde podemos ver el estado de la base de datos, si está conectado, si está todo funcionando, los proyectos que están dentro del mismo, podemos pararlos también, podemos pausar por tema de seguridad, de que, mira, ha pasado tal cosa, no quiero que se sincronice la base de datos, lo que sea. Lo puedo pausar. Puedo ver qué usuarios están conectados ahora mismo.

**24:08** · Puedo ver también la, eh, digamos, la salud que tiene mi sistema en totalidad y hasta un audit log, porque cualquier problema que haya, podemos también auditarlo desde acá mismo, ¿bien? Entonces, ahora les voy a mostrar una cosa impresionante.

**24:21** · Dentro de lo que es Engram Cloud, vamos a ver si funcionó lo del test que hicimos. Voy a buscar test, miren qué rápido ya apareció. Listo, ya lo tenemos. ¿Bien? Este es el guardado que hicimos de prueba. Observación de prueba que simula una decisión arquitectónica, adoptar una arquitectura hexagonal para separar dominio, aplicación e infraestructura. Ya lo tenemos, pero hay una parte importante de todo esto. Para poder loguearme, también me puedo loguear como un administrador, que es lo que me da todo este panel, si no no lo vas a ver. Y te voy a mostrar cómo configurarlo muy rápidamente.

**24:49** · Acá estoy dentro de la aplicación, lo que he hecho es un cat de docker-compose-hostgator.yaml.

**24:57** · Esto es dentro del opt engran que hicimos al principio. Y van a ver si mi hermosísimo y espectacular, justamente, editor ofuscatodo, ¿bien? Tenemos acá todos los tokens que vamos a estar utilizando desde la base de datos donde está, el cloud token, el cloud admin token y demás. ¿Se acuerdan al principio que les enseñé cómo generar el token?

**25:18** · Fantástico. Ese token, si ustedes lo ponen dentro de la variable de entorno engran cloud admin, ya lo van a poder utilizar para acceder como admin, directamente. Si utilizan el de arriba, entran como un desarrollador y ya está.

**25:31** · Y lo importante es que en esta partecita también de aquí tenemos lo que son los allow project, qué proyectos van a poder ser utilizados para poder sincronizar con la nube, ¿bien? Y eso sería toda la parte de configuraciones, vean que es muy muy simple. Es crear un token, lo asignas en dos lugares diferentes y ya está.

### Recap: 5 puntos clave

**25:50** · Entonces, vamos a recapitular todo lo que hicimos hoy, ¿bien? Uno, los modelos no tienen memoria nativa, menos el de Claudio, por ejemplo, que la tiene, pero anda medio terrible y te come unos tokens que te morís, vos tenés que construirla, ¿sí? Dos, engran resuelve memoria local con SQLite, search semántico, FTS5, BM25. Tres, engran cloud agrega replicación entre máquinas con autosync cada 30 segundos, manteniendo local first como principio core.

**26:19** · la arquitectura completa, tres superficies, defensa en profundidad en cinco etapas con dos caminos de autenticación. Cinco, desplegamos todo desde cero en la VPS de Hostgator, ¿bien? Tenemos lo que es el DNS, el Apache reverse proxy, tenemos la parte del Let's Encrypt con renovación automática, generación de secrets criptográficos, configuración de servidor, deploy del stack en modo admin y cliente conectado. Entonces, la diferencia entre engran cloud y otra solución de memoria de agentes que te encuentres por ahí es que vos sos el dueño, justamente. Tu data vive donde vos decidís.

**26:52** · Si mañana yo desaparezco, espero que no, tu cloud sigue funcionando porque está en tu VPS, ¿se entiende la importancia? Esto es lo que yo creo que tiene que ser la herramienta para desarrolladores en la era de la IA, no una SaaS ahí de moda que te bloquea y tenés que chiqui chiqui, no. Un open source, self-hosted, local first, Tony Stark con Jarvis, vos dirigís la IA, ejecuta. Pero la infra y la data son tuyas. Sí, gente hermosa de mi corazón, ya sabés, si te gustó dale un like y suscribite en mi GitHub con link en la descripción, HostGator con descuento, link abajo, comentarios, los leo todos.

### Tu data es tuya. Open source, self hosted, local first

**27:25** · Así que los espero ahí. Le vas a dar esto a un saludazo y le vas a compartir hasta con tu abuela y nos vemos en el siguiente próximo impresionante Gabi blog. Yeah.

### Cierre

**27:38** · Nos fuimos.