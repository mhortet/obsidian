---
title: "llm-wiki"
source: "https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f"
author:
  - "[[262588213843476]]"
published:
created: 2026-06-27
description: "llm-wiki. GitHub Gist: instantly share code, notes, and snippets."
tags:
  - "clippings"
---
## Wiki de LLM

Un modelo para construir bases de conocimiento personales utilizando modelos de aprendizaje de lenguaje (LLM).

Este es un archivo de ideas, diseñado para que lo copies y pegues en tu propio agente LLM (por ejemplo, OpenAI Codex, Claude Code, OpenCode/Pi, etc.). Su objetivo es comunicar la idea general, pero tu agente desarrollará los detalles en colaboración contigo.

## La idea central

La experiencia de la mayoría de las personas con los sistemas de gestión del conocimiento (LLM) y los documentos se asemeja a la de los sistemas RAG: se sube una colección de archivos, el LLM recupera los fragmentos relevantes al momento de la consulta y genera una respuesta. Esto funciona, pero el LLM redescubre el conocimiento desde cero para cada pregunta. No hay acumulación. Si se formula una pregunta sutil que requiere sintetizar cinco documentos, el LLM tiene que encontrar y unir los fragmentos relevantes cada vez. No se acumula nada. NotebookLM, la carga de archivos de ChatGPT y la mayoría de los sistemas RAG funcionan de esta manera.

La idea aquí es diferente. En lugar de simplemente recuperar información de documentos originales al momento de la consulta, LLM **construye y mantiene de forma incremental una wiki persistente**: una colección estructurada e interconectada de archivos Markdown que actúa como intermediario entre usted y las fuentes originales. Cuando agrega una nueva fuente, LLM no solo la indexa para su posterior recuperación, sino que la lee, extrae la información clave y la integra en la wiki existente, actualizando las páginas de entidades, revisando los resúmenes de temas, señalando dónde los nuevos datos contradicen afirmaciones anteriores y reforzando o cuestionando la síntesis en evolución. El conocimiento se compila una sola vez y *se mantiene actualizado*, en lugar de ser derivado nuevamente con cada consulta.

Esta es la diferencia clave: **la wiki es un artefacto persistente y en constante evolución.** Las referencias cruzadas ya existen. Las contradicciones ya han sido señaladas. La síntesis ya refleja todo lo que has leído. La wiki se enriquece continuamente con cada fuente que añades y cada pregunta que formulas.

Nunca (o casi nunca) escribes la wiki tú mismo: el LLM se encarga de escribirla y mantenerla. Tú eres responsable de buscar información, explorarla y formular las preguntas adecuadas. El LLM realiza todo el trabajo pesado: resumir, crear referencias cruzadas, archivar y mantener la base de conocimientos para que sea realmente útil a largo plazo. En la práctica, tengo el agente LLM abierto en un lado y Obsidian en el otro. El LLM realiza ediciones basándose en nuestra conversación, y yo consulto los resultados en tiempo real: sigo los enlaces, reviso la vista gráfica y leo las páginas actualizadas. Obsidian es el IDE; el LLM es el programador; la wiki es el código fuente.

Esto puede aplicarse a muchos contextos diferentes. Algunos ejemplos:

- **Personal**: seguimiento de tus objetivos personales, salud, psicología, superación personal: registro de entradas en un diario, artículos, notas de podcasts y construcción de una imagen estructurada de ti mismo a lo largo del tiempo.
- **Investigación**: profundizar en un tema durante semanas o meses, leyendo artículos, informes y creando gradualmente una wiki completa con una tesis en constante evolución.
- **Leer un libro**: archivar cada capítulo a medida que avanzas, creando páginas para personajes, temas, tramas y sus conexiones. Al final, tendrás una completa wiki complementaria. Piensa en wikis de fans como [Tolkien Gateway](https://tolkiengateway.net/wiki/Main_Page): miles de páginas interconectadas que abarcan personajes, lugares, eventos e idiomas, creadas por una comunidad de voluntarios a lo largo de los años. Podrías crear algo similar a medida que lees, con el LLM encargándose de las referencias cruzadas y el mantenimiento.
- **Empresa/equipo**: una wiki interna mantenida por los gestores de proyectos, alimentada por hilos de Slack, transcripciones de reuniones, documentos de proyectos y llamadas con clientes. Posiblemente con la participación de personas revisando las actualizaciones. La wiki se mantiene actualizada porque los gestores de proyectos se encargan del mantenimiento que nadie más del equipo quiere realizar.
- **Análisis de la competencia, diligencia debida, planificación de viajes, apuntes de cursos, análisis en profundidad de aficiones**: cualquier cosa en la que acumules conocimientos con el tiempo y quieras que estén organizados en lugar de dispersos.

## Arquitectura

Hay tres capas:

**Fuentes originales**: su colección seleccionada de documentos fuente. Artículos, documentos, imágenes, archivos de datos. Estos son inmutables: el LLM los lee, pero nunca los modifica. Esta es su fuente de información fidedigna.

**La wiki** es un directorio de archivos Markdown generados por LLM. Contiene resúmenes, páginas de entidades, páginas de conceptos, comparaciones, una descripción general y una síntesis. LLM gestiona esta capa por completo. Crea las páginas, las actualiza cuando llegan nuevas fuentes, mantiene las referencias cruzadas y garantiza la coherencia. Tú la lees; LLM la escribe.

**El esquema** —un documento (por ejemplo, CLAUDE.md para Claude Code o AGENTS.md para Codex)— indica al LLM cómo está estructurada la wiki, cuáles son las convenciones y qué flujos de trabajo debe seguir al incorporar fuentes, responder preguntas o mantener la wiki. Este es el archivo de configuración clave: es lo que convierte al LLM en un gestor de wikis disciplinado, en lugar de un chatbot genérico. Usted y el LLM lo perfeccionan con el tiempo a medida que descubren qué funciona mejor para su dominio.

## Operaciones

**Ingesta.** Se añade una nueva fuente a la colección de datos sin procesar y se le indica al LLM que la procese. Un ejemplo de flujo: el LLM lee la fuente, analiza los puntos clave con usted, escribe una página de resumen en la wiki, actualiza el índice, actualiza las páginas de entidades y conceptos relevantes en toda la wiki y añade una entrada al registro. Una sola fuente puede afectar a entre 10 y 15 páginas de la wiki. Personalmente, prefiero ingerir las fuentes de una en una y mantenerme involucrado: leo los resúmenes, reviso las actualizaciones y oriento al LLM sobre qué destacar. Sin embargo, también se pueden ingerir varias fuentes a la vez con menos supervisión. Depende de usted desarrollar el flujo de trabajo que mejor se adapte a su estilo y documentarlo en el esquema para futuras sesiones.

**Consulta.** Formula preguntas en la wiki. El LLM busca páginas relevantes, las lee y sintetiza una respuesta con citas. Las respuestas pueden adoptar diferentes formatos según la pregunta: una página en formato Markdown, una tabla comparativa, una presentación (Marp), un gráfico (matplotlib) o un lienzo. Lo importante: las **buenas respuestas se pueden archivar en la wiki como nuevas páginas.** Una comparación que solicitaste, un análisis, una conexión que descubriste: todo esto es valioso y no debería desaparecer en el historial de chat. De esta forma, tus exploraciones se acumulan en la base de conocimiento, al igual que las fuentes incorporadas.

**Revisa** periódicamente el wiki. Busca contradicciones entre páginas, afirmaciones obsoletas que han sido reemplazadas por fuentes más recientes, páginas huérfanas sin enlaces entrantes, conceptos importantes mencionados pero sin su propia página, referencias cruzadas faltantes y lagunas de datos que podrían completarse con una búsqueda web. El administrador del wiki es experto en sugerir nuevas preguntas para investigar y nuevas fuentes para consultar. Esto mantiene el wiki en buen estado a medida que crece.

## Indexación y registro

Dos archivos especiales ayudan al LLM (y a usted) a navegar por la wiki a medida que crece. Cumplen diferentes funciones:

**index.md** está orientado al contenido. Es un catálogo de todo el contenido de la wiki: cada página se lista con un enlace, un resumen de una línea y, opcionalmente, metadatos como la fecha o el número de fuentes. Está organizado por categoría (entidades, conceptos, fuentes, etc.). El LLM lo actualiza con cada ingesta. Al responder a una consulta, el LLM lee primero el índice para encontrar las páginas relevantes y luego las explora en detalle. Esto funciona sorprendentemente bien a una escala moderada (aproximadamente 100 fuentes, cientos de páginas) y evita la necesidad de una infraestructura RAG basada en incrustaciones.

**El archivo log.md** es cronológico. Es un registro de solo escritura que indica qué sucedió y cuándo: ingestas, consultas, revisiones de código. Un consejo útil: si cada entrada comienza con un prefijo consistente (por ejemplo, `## [2026-04-02] ingest | Article Title`), el registro se puede analizar con herramientas Unix sencillas; `grep "^## \[" log.md | tail -5` te muestra las últimas 5 entradas. El registro te ofrece una línea de tiempo de la evolución de la wiki y ayuda al LLM a comprender qué se ha hecho recientemente.

## Opcional: Herramientas de línea de comandos

En algún momento, es posible que desee crear pequeñas herramientas que ayuden al LLM a operar en la wiki de manera más eficiente. Un motor de búsqueda sobre las páginas de la wiki es la opción más obvia: a pequeña escala, el archivo de índice es suficiente, pero a medida que la wiki crece, se necesita una búsqueda adecuada. [qmd](https://github.com/tobi/qmd) es una buena opción: es un motor de búsqueda local para archivos markdown con búsqueda híbrida BM25/vectorial y reordenamiento del LLM, todo en el dispositivo. Tiene una interfaz de línea de comandos (para que el LLM pueda acceder a él) y un servidor MCP (para que el LLM pueda usarlo como una herramienta nativa). También podría crear algo más simple usted mismo: el LLM puede ayudarle a programar un script de búsqueda básico cuando surja la necesidad.

## Consejos y trucos

- **Obsidian Web Clipper** es una extensión para navegador que convierte artículos web a formato Markdown. Muy útil para incorporar rápidamente fuentes a tu colección de archivos sin procesar.
- **Descarga imágenes localmente.** En Obsidian Settings → Files and links, establece "Attachment folder path" a un directorio fijo (por ejemplo, `raw/assets/`). Luego, en Settings → Hotkeys, busca "Download" para encontrar "Download attachments for current file" y asígnalo a un atajo de teclado (por ejemplo, Ctrl+Shift+D). Después de recortar un artículo, presiona el atajo de teclado y todas las imágenes se descargarán al disco local. Esto es opcional pero útil: permite que el LLM vea y haga referencia a las imágenes directamente en lugar de depender de URL que pueden romperse. Ten en cuenta que los LLM no pueden leer de forma nativa Markdown con imágenes en línea en una sola pasada; la solución alternativa es hacer que el LLM lea primero el texto y luego vea algunas o todas las imágenes referenciadas por separado para obtener contexto adicional. Es un poco engorroso, pero funciona bastante bien.
- **La vista gráfica de Obsidian** es la mejor manera de ver la estructura de tu wiki: qué está conectado con qué, qué páginas son nodos centrales y cuáles son páginas aisladas.
- **Marp** es un formato de diapositivas basado en Markdown. Obsidian cuenta con un complemento para ello. Resulta útil para generar presentaciones directamente a partir de contenido wiki.
- **Dataview** es un plugin de Obsidian que ejecuta consultas sobre el encabezado de página. Si tu LLM agrega encabezado YAML a las páginas wiki (etiquetas, fechas, recuentos de fuentes), Dataview puede generar tablas y listas dinámicas.
- La wiki es simplemente un repositorio Git de archivos Markdown. Obtienes historial de versiones, ramificación y colaboración de forma gratuita.

## Por qué esto funciona

La parte tediosa de mantener una base de conocimientos no es la lectura ni el pensamiento, sino la gestión administrativa. Actualizar las referencias cruzadas, mantener los resúmenes al día, registrar las contradicciones entre los datos nuevos y mantener la coherencia en decenas de páginas. Los humanos abandonan las wikis porque la carga de mantenimiento supera su valor. Los gestores de bases de datos (LLM) no se aburren, no olvidan actualizar las referencias cruzadas y pueden acceder a 15 archivos de una sola vez. La wiki se mantiene porque el coste de mantenimiento es prácticamente nulo.

La labor del ser humano consiste en seleccionar las fuentes, dirigir el análisis, formular buenas preguntas y reflexionar sobre su significado. La labor del máster en derecho abarca todo lo demás.

La idea guarda relación con el Memex de Vannevar Bush (1945): un repositorio de conocimiento personal y organizado, con rutas asociativas entre documentos. La visión de Bush se acercaba más a esto que a lo que se convirtió la web: un espacio privado, gestionado activamente, donde las conexiones entre documentos eran tan valiosas como los documentos mismos. El problema radicaba en quién se encargaba del mantenimiento. El programa LLM se ocupa de ello.

## Nota

Este documento es intencionadamente abstracto. Describe la idea, no una implementación específica. La estructura exacta de directorios, las convenciones del esquema, los formatos de página, las herramientas... todo eso dependerá de su dominio, sus preferencias y el LLM que elija. Todo lo mencionado anteriormente es opcional y modular: seleccione lo que le sea útil e ignore lo que no. Por ejemplo: sus fuentes podrían ser solo texto, por lo que no necesitaría gestionar imágenes. Su wiki podría ser lo suficientemente pequeña como para que el archivo de índice sea todo lo que necesite, sin necesidad de un motor de búsqueda. Quizás no le interesen las presentaciones de diapositivas y solo quiera páginas en formato Markdown. Quizás desee un conjunto de formatos de salida completamente diferente. La forma correcta de usarlo es compartirlo con su agente LLM y trabajar juntos para crear una versión que se ajuste a sus necesidades. La única función del documento es comunicar el patrón. Su LLM se encargará del resto.