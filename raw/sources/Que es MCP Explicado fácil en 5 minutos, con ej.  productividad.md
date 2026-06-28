---
title: "Que es MCP? Explicado fácil en 5 minutos, con ej.  productividad"
source: "https://www.youtube.com/watch?v=QLsgTPzf32g"
author:
  - "[[Stark Skool AI]]"
published: 2025-03-24
created: 2026-06-28
description: "Te ayudo a dejar de crear con IA como un noob y hacerlo como un ingeniero (comunidad #n8n2pro) https://starkskool.com/(ya no es gratuita, debido al alta demanda y el poco tiempo que tenemos, hemos de"
tags:
  - "clippings"
---
![](https://www.youtube.com/watch?v=QLsgTPzf32g)

Te ayudo a dejar de crear con IA como un noob y hacerlo como un ingeniero (comunidad #n8n2pro) https://starkskool.com/  
(ya no es gratuita, debido al alta demanda y el poco tiempo que tenemos, hemos decidido ponerla de pago)  
  
Si eres nuevo al canal, mi nombre es Emelian Gurei y soy Ingeniero de IA en Capitole.  
En este canal compartiré con vosotros todos los consejos, mejores prácticas y errores que he ido acumulando durante mis años trabajando en proyectos de IA. Además, exploraremos día a día las últimas novedades del sector: desde la parte técnica de construcción de modelos (LLMs, visión por ordenador, etc.) hasta la metodología e infraestructura necesaria para desplegarlos en la nube. Y, por supuesto, os mostraré cómo llevar a cabo proyectos prácticos y útiles para que podáis aplicar todo lo que aprendáis.  
  
Este video explica como funciona MCP (Model Context Protocol) de manera muy sencilla y con un ejemplo práctico que muestra los beneficios y ahorro de tiempo de usarlo. Si queréis ejemplos concretos usando MCP, decírmelo en los comentarios.  
  
Estas son las fuentes que he utilizado para informarme (a parte de Grok):  
Video de Ras Mic (Ingeniero de Software que explica en inglés como funciona MCP):  
https://www.youtube.com/@rasmic/videos  
https://www.youtube.com/watch?v=7j\_NE6Pjv-E  
Posts de X:  
https://x.com/minchoi/status/1900931746448756879  
https://x.com/bilawalsidhu/status/1900240156826939560  
https://x.com/sidahuj/status/1902719460278198658  
https://x.com/svpino/status/1901624443488596328  
  
  
Esta información la he obtenido investigando sobre distintas fuentes y discutiendo reiteradamente con Grok para entender que es MCP. Si usáis MCP Server propio, usarlo con precaución y bajo vuestra responsabilidad, configurar bien la seguridad de vuestro servidor.

## Transcript

**0:00** · estos últimos días seguro que has estado viendo la palabra mcp por todo Twitter y aún no sabes qué es verdad para que no te quedes atrás y otra gente te pase por delante te lo explicaré de for muy simple y con un ejemplo que quizá te pueda aplicar así descubrirás por qu está age ahora mismo además al final del vídeo os he dejado un ejemplo loquísimo

**0:20** · de có usar mcp con Blender así que qué es mcp de manera muy resumida mcp es una capa que actúa como un traductor entre múltiples herramientas como Google Drive Google sheet que están conectadas a un modelo llm Como por ejemplo chat gpt y

**0:37** · permite utilizar estas herramientas únicamente conectándote al servidor de mcp y haciendo la petición en lenguaje natural español o de inglés aquí va un ejemplo para que lo entiendas mejor Y quizá te aplique Imagínate que eres Pepe un jefe de equipo un máquina y necesitas

**0:56** · coordinar una entrega de proyecto para mañana bien tú como Pepe tendrías que pasar por las siguientes tareas manualmente revisar las fechas límite y disponibilidad del equipo actualizar un registro de tareas completadas y notificar al equipo sobre una reunión urgente Pepe no conoce que es mcp

**1:19** · entonces decide hacerlo a mano para revisar las fechas y disponibilidad Abre Google calendar mira su calendario y el compartido con el equipo y anota manualmente quién está libre y cuándo esto le toma 15 minutos entre clics y notas siguiente tarea actualizar el registro Pepe Abre Google sheets donde tiene el control de las tareas por ejemplo tarea responsable y su

**1:45** · estado revisa correos y mensajes para ver qué se ha hecho actualiza fila por fila y calcula el progreso total esto lo ha llevado otros 20 minutos ahora pasa a la siguiente tarea tiene que notificar al equipo para ello entra slack y escribe un mensaje en el Canal del proyecto reunión urgente mañana a las 10 para revisar el progreso copia el enlace de la hoja de ships y lo envía en todo esto Pepe ha

**2:18** · gastado 10 minutos más si tiene que revisar las respuestas cuál es el problema de esto Pepe ha perdido 45 minutos saltando entre varias herramientas calendar para fech cheats para tareas slack para mensajes Todo es manual desconectado y propenso a errores como olvidar actualizar una tarea o invitar a alguien entonces Pepe decide recurrir a la ia y pedirle ayuda a gpt 4 le dice Oye ayúdame a coordinar

**2:48** · el proyecto a lo que gpt 4 le responde no puedo ver tu calendario ni tus hojas de cálculo ni enviar mensajes por slack dame los datos y te ayudo a adar algo entonces PP se frustra y Busca otra solución donde descubre Qué es mcp y cómo utilizarlo ahora Pepe le vuelve a preguntar a gpt 4 lo mismo que antes lo

**3:15** · que ahora como está conectado a los servidores de mcp le contesta Al toque mi rey una vez referida la orden gpt 4 hará la petición a los servidores utilizando el protocolo estándar especificado por

**3:35** · mcp de ahí su nombre model context protocol de esta manera podrá utilizar las herramientas como Google calendar y Google sheets simplemente conectándose al servidor correspondiente de Google y

**3:51** · lo mismo pasa con slack donde solo Tendremos que configurar la conexión a su servidor vale Y qué nos ha solucionado esto hemos tardado menos de un minuto en hacer todo lo que antes habíamos hecho en 45 minutos simplemente ha tenido que hacer una petición lenguaje natural Castellano Oye ayúdame

**4:12** · a coordinar esto y el modelo ha coordinado el uso de todas las herramientas para obtener el mismo resultado entonces una de las posibles preguntas que quizá te hagas en un futuro es vale pero yo tengo que mantener estas conexiones La respuesta es no de esto se

**4:30** · encarga el proveedor que ofrece los servicios por ejemplo para Google calendar y Google Drive sería Google tú únicamente tendrías que tener configurada la conexión a su servidor Y así te olvidas de configurar herramienta por herramienta y antes de enseñaros la guinda del pastel podéis pedirme ayuda

**4:54** · para vuestros proyectos de ia Por mensaje privado entrando en la comunidad starch com y sin más dilación aquí os pongo un ejemplo aún más flipante que el que acabáis de ver podéis Conectar mcp a Blender y hacer cosas como

**5:24** · esta increíble verdad pues suscríbete y mira mis pros vídeos para aprender Cómo utilizar mcp con cursor y python