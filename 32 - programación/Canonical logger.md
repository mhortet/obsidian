---
tags:
  - codigo
  - estructura
Creado: 2026-06-15
Autor:
  - Brandur Leach
Relacionado:
---
## Resumen

## Descripción


# [Observabilidad rápida y flexible con líneas de registro canónicas](https://stripe.com/blog/canonical-log-lines)

[30 de julio de 2019](https://stripe.com/blog/canonical-log-lines)

[![](https://images.stripeassets.com/fzn2n1nzq965/7ouBgy4HhOabpYNnGYiiJL/bae9c7451dc6e68e98ffb82f67952433/brandur-fe68eb87f3a8d0260eaa9ffcdd74d4bab7f1595f.jpeg?w=96&h=96)](https://twitter.com/brandur)

[Brandur Leach](https://twitter.com/brandur)Experiencia de API

El registro de eventos es uno de los patrones más antiguos y omnipresentes en la informática. Fundamental para comprender problemas que van desde fallos básicos en entornos de prueba hasta los problemas más complejos en producción, es una práctica común en todas las pilas de software y en todo tipo de infraestructuras, y lo ha sido durante décadas.

Si bien los registros son potentes y flexibles, su gran volumen a menudo dificulta la extracción rápida de información útil. La información relevante se encuentra dispersa en numerosas líneas de registro individuales, e incluso con los sistemas de procesamiento de registros más potentes, la búsqueda de los detalles precisos puede ser lenta y requiere una sintaxis de consulta compleja.

En Stripe, hemos comprobado que una pequeña mejora en el registro tradicional resulta sumamente útil: una técnica que denominamos líneas de registro canónicas. Es bastante sencilla: además de sus registros habituales, las solicitudes generan una línea de registro larga al final que incluye muchas de sus características clave. Al agrupar estos datos en líneas únicas y densas, las consultas y agregaciones se escriben y ejecutan con mayor rapidez.

De todas las herramientas y técnicas que utilizamos para obtener información sobre la producción, las líneas de registro canónicas en particular han demostrado ser  _tan_  útiles para una mayor visibilidad operativa y una mejor respuesta a incidentes que las hemos incorporado a casi todos los servicios que gestionamos. No solo se utilizan en nuestra API principal, sino que se emite una cada vez que se envía un webhook, se tokeniza una tarjeta de crédito mediante nuestra bóveda PCI o se carga una página en el panel de control de Stripe.

## Registro estructurado

Al igual que en muchos otros ámbitos de la informática, el registro de eventos se utiliza ampliamente en las API y los servicios web. En una API de pagos, una sola solicitud podría generar un registro de seguimiento similar a este:

`   12345  [2019-03-18 22:48:32.990] Request started [2019-03-18 22:48:32.991] User authenticated [2019-03-18 22:48:32.992] Rate limiting ran [2019-03-18 22:48:32.998] Charge created [2019-03-18 22:48:32.999] Request finished   `

**El registro estructurado**  mejora la práctica al brindar a los desarrolladores una forma sencilla de anotar líneas con datos adicionales. El término  _«estructurado»_  es ambiguo: puede referirse a un formato de datos estructurado nativo como JSON, pero a menudo significa que las líneas de registro se enriquecen mediante la adición de  `key=value` pares (a veces llamados  [logfmt](https://brandur.org/logfmt) , aunque no universalmente). La estructura añadida facilita a los desarrolladores etiquetar líneas con información adicional sin tener que insertarla de forma engorrosa en el propio mensaje de registro.

Una versión enriquecida del rastro anterior podría verse así:

`   123456789  [2019-03-18 22:48:32.990] Request started http_method=POST http_path=/v1/charges request_id=req_123  [2019-03-18 22:48:32.991] User authenticated auth_type=api_key key_id=mk_123 user_id=usr_123  [2019-03-18 22:48:32.992] Rate limiting ran rate_allowed=true rate_quota=100 rate_remaining=99  [2019-03-18 22:48:32.998] Charge created charge_id=ch_123 permissions_used=account_write team=acquiring  [2019-03-18 22:48:32.999] Request finished alloc_count=9123 database_queries=34 duration=0.009 http_status=200   `

La estructura añadida también hace que los registros emitidos sean legibles por máquina (la  `key=value` convención está diseñada para ser un compromiso entre la legibilidad por máquina y la legibilidad humana), lo que permite que sean procesados ​​por varias herramientas diferentes de procesamiento de registros, muchas de las cuales ofrecen la capacidad de consultar los registros de producción prácticamente en tiempo real.

Por ejemplo, podríamos querer saber cuáles fueron los últimos puntos finales de API solicitados. Podríamos averiguarlo utilizando un sistema de procesamiento de registros como Splunk y su lenguaje de consulta integrado:

`   1  “Request started” | head   `

O si recientemente se ha limitado la frecuencia de alguna solicitud a la API:

`   1  “Rate limiting ran” allowed=false   `

O bien, recopile estadísticas sobre la duración de la ejecución de la API durante la última hora:

`   1  “Request finished” earliest=-1h | stats count p50(duration) p95(duration) p99(duration)   `

En la práctica, sería mucho más común recopilar este tipo de datos básicos a partir de paneles generados por sistemas de métricas como  [Graphite](https://github.com/graphite-project/graphite-web)  y  [statsd](https://github.com/statsd/statsd) , pero estos tienen limitaciones. Las métricas emitidas y los paneles que las interpretan están diseñados de antemano, y en caso de necesidad, suelen ser difíciles de consultar de forma creativa o inesperada. Donde el registro de eventos realmente destaca en comparación con estos sistemas es en la flexibilidad.

Los registros suelen  generar datos _en exceso,_ hasta el punto de que es posible obtener prácticamente cualquier cosa de ellos, incluso información que nadie pensaba que necesitaría. Por ejemplo, podríamos comprobar qué ruta de API es la más popular:

`   1  “Request started” | stats count by http_path   `

O supongamos que vemos que la API está generando errores 500 (errores internos del servidor). Podríamos verificar la duración de la solicitud en los errores para tener una idea clara de si es probable que se deban a tiempos de espera de la base de datos:

`   1  “Request finished” status=500 | stats count p50(duration) p95(duration) p99(duration)   `

Los sistemas sofisticados de procesamiento de registros también suelen permitir visualizar la información de forma similar a un panel de métricas. Así, en lugar de leer los registros en bruto, podemos hacer que nuestro sistema grafique los resultados de nuestras consultas ad hoc. Las visualizaciones son más intuitivas y facilitan la comprensión de lo que está sucediendo.

## Líneas de registro canónicas: una línea por solicitud por servicio

Si bien los registros ofrecen mayor flexibilidad en los ejemplos anteriores, seguimos encontrándonos en una situación difícil si queremos consultar información  en las _distintas_  líneas de un rastreo. Por ejemplo, si observamos que se está produciendo una limitación de velocidad excesiva en la API, podríamos preguntarnos: "¿Qué usuarios están siendo limitados con mayor frecuencia?". Conocer la respuesta ayuda a diferenciar entre la limitación de velocidad legítima, debida a que los usuarios realizan demasiadas solicitudes, y la limitación de velocidad accidental, que podría deberse a un error en nuestro sistema.

La información sobre si una solicitud fue limitada y qué usuario la realizó se encuentra dispersa en varias líneas de registro, lo que dificulta las consultas. La mayoría de los sistemas de procesamiento de registros aún pueden hacerlo agrupando los datos de un rastreo por identificador de solicitud y consultando el resultado, pero esto implica escanear una gran cantidad de datos y es más lento. Además, requiere una sintaxis más compleja, más difícil de recordar para un humano y que consume más tiempo escribir.

Utilizamos  **líneas de registro canónicas**  para abordar este problema. La idea es sencilla: además de sus registros habituales, las solicitudes (o cualquier otra unidad de trabajo que se esté ejecutando) también emiten una larga línea de registro al final que reúne toda su telemetría clave en un solo lugar. Tienen un aspecto similar a este:

`   1  [2019-03-18 22:48:32.999] canonical-log-line alloc_count=9123 auth_type=api_key database_queries=34 duration=0.009 http_method=POST http_path=/v1/charges http_status=200 key_id=mk_123 permissions_used=account_write rate_allowed=true rate_quota=100 rate_remaining=99 request_id=req_123 team=acquiring user_id=usr_123   `

Este ejemplo muestra el tipo de información que podría contener una línea canónica, que incluye:

- El verbo de la solicitud HTTP, la ruta y el estado de la respuesta.
- El usuario autenticado e información relacionada, como la forma en que se autenticó (clave API, contraseña) y el ID de la clave API que utilizó.
- Si los limitadores de velocidad permitieron la solicitud, y estadísticas como su cuota asignada y qué porción queda.
- Información sobre tiempos, como la duración total de la solicitud y el tiempo empleado en las consultas a la base de datos.
- El número de consultas a la base de datos realizadas y el número de objetos asignados por la máquina virtual.

Denominamos a la línea de registro  _canónica_  porque es la línea autorizada para una solicitud en particular, del mismo modo que la  [relación de enlace canónico](https://tools.ietf.org/html/rfc6596) del IETF  especifica una URL autorizada.

Las líneas canónicas son una característica ergonómica. Al agrupar todo lo importante, facilitamos el acceso mediante consultas sencillas, incluso durante incidentes de producción. Dado que el sistema de registro subyacente no necesita reconstruir varias líneas al realizar una consulta, su recuperación y agregación resultan económicas para los ordenadores, lo que agiliza su uso. La amplia variedad de información registrada ofrece una flexibilidad casi ilimitada en las consultas. Esto resulta especialmente valioso durante la fase de descubrimiento de un incidente, cuando se sabe que algo falla, pero aún se desconoce la causa.

Comprender el problema de limitación de velocidad descrito anteriormente es tan sencillo como:

`   1  canonical-log-line rate_allowed=false | stats count by user_id   `

Si solo uno o unos pocos usuarios están siendo limitados, probablemente se trate de una limitación legítima debido a que realizan demasiadas solicitudes. Si se trata de muchos usuarios distintos, es muy probable que tengamos un error.

Como ejemplo un poco más complejo, podríamos visualizar el rendimiento del  `charges` punto final para un usuario específico a lo largo del tiempo, asegurándonos de filtrar  `4xx` los errores causados ​​por el usuario.  `4xx` Los errores tienden a producirse rápidamente y, por lo tanto, no nos brindan información relevante sobre las características de rendimiento normales del punto final. La consulta para hacerlo podría ser similar a esta:

`   1  canonical-log-line user=usr_123 http_method=POST http_path=/v1/charges http_status!=4* | timechart p50(duration) p95(duration) p99(duration)   `

![Duración de las solicitudes de API](https://images.stripeassets.com/fzn2n1nzq965/Y0ofZ7xqW0QeptsnwNLKZ/b3aa1b4e19e41367068d5906f6b73bb5/dev-dashboard_2x-8d6b50fd630e96e4d83ad29d75a05f026dba5fec.png?w=1078&q=80)

Duración de las solicitudes a la API en los percentiles 50, 95 y 99: generada sobre la marcha a partir de los datos de registro.

## Implementación en middleware y más allá

El registro de eventos es una técnica tan extendida y las líneas de registro canónicas son una idea lo suficientemente simple como para que su implementación suela ser sencilla, independientemente del conjunto de tecnologías que se utilicen.

La implementación en la API principal de Stripe consiste en un middleware con un paso posterior a la solicitud que genera la línea de registro. Los módulos que se ejecutan durante el ciclo de vida de la solicitud modifican el entorno de la misma con información destinada a la línea de registro canónica, que el middleware extraerá al finalizar.

Aquí tienes una versión muy simplificada de cómo se ve:

`   12345678910111213  class CanonicalLineLogger   def call(env)     # Call into the core application and inner middleware     status, headers, body = @app.call(env)          # Emit the canonical line using response status and other     # information embedded in the request environment     log_canonical_line(status, env)          # Return results upstream     [status, headers, body]   end end   `

Con el paso de los años, nuestra implementación se ha perfeccionado para maximizar la probabilidad de que se generen líneas de registro canónicas para  _cada_  solicitud, incluso si se produce un fallo interno u otra condición inesperada. La línea se registra en un  `ensure` bloque Ruby por si acaso se deshace la pila de middleware debido a una excepción. La instrucción de registro se incluye en su propio  bloque `begin`/ `rescue` para que cualquier problema al construir una línea canónica nunca provoque un fallo en la solicitud, y también para que se notifique inmediatamente a alguien en caso de que ocurra. Son una herramienta tan importante para nosotros durante la respuesta a incidentes que es crucial que cualquier problema con ellas se solucione rápidamente; no tenerlas sería como volar a ciegas.

## Historia del almacenamiento

Un problema con los datos de registro es que suelen ser muy extensos. Esto significa que su conservación a largo plazo, salvo en almacenamiento en frío, resulta costosa, sobre todo si se tiene en cuenta que las probabilidades de que se vuelvan a utilizar son bajas. Además de su utilidad operativa, la brevedad de las líneas de registro canónicas las convierte en un medio conveniente para archivar solicitudes históricas.

En Stripe, los ingenieros utilizan con tanta frecuencia las líneas de registro canónicas para analizar la producción que hemos desarrollado una memoria muscular en torno a la nomenclatura de campos específicos. Por ello, durante mucho tiempo nos hemos esforzado por mantener esa nomenclatura estable; los cambios resultan inconvenientes para todo el equipo, ya que todos tienen que volver a aprenderla. Finalmente, dimos un paso más allá y formalizamos el contrato codificándolo con un  [búfer de protocolo](https://developers.google.com/protocol-buffers/) .

Además de emitir líneas canónicas al sistema de registro, la API también serializa los datos según ese contrato y los envía de forma asíncrona a un tema de Kafka. Un consumidor lee el tema y acumula las líneas en lotes que se almacenan en S3. Procesos periódicos ingieren esos lotes en archivos Presto y Redshift, lo que nos permite realizar fácilmente análisis a largo plazo que pueden examinar datos de varios meses.

En la práctica, esto nos permite medir casi todo lo que podríamos desear. Por ejemplo, aquí hay un gráfico que muestra la adopción de las principales versiones de Go a lo largo del tiempo a partir de las solicitudes de API que se realizan con nuestras bibliotecas de API oficiales:

![versiones del lenguaje go](https://images.stripeassets.com/fzn2n1nzq965/Ia0qU1XHQjADcxI01RQQu/a52fe3c39da0ce3228aa1b833202213b/go-language-versions_2x-adbfb20dd9ab3467339f6403e08d321912d1284e.png?w=1078&q=80)

Uso de la versión de Go medido a lo largo del tiempo. Los datos se agregan a partir de un archivo de líneas de registro canónicas ingresadas en un almacén de datos.

Mejor aún, dado que estas herramientas de almacenamiento de datos se basan en SQL, tanto ingenieros como personas sin conocimientos técnicos pueden agregar y analizar los datos. Aquí está el código fuente de la consulta anterior:

`   123456  SELECT     DATE_TRUNC('week', created) AS week,     REGEXP_SUBSTR(language_version, '\\d*\\.\\d*') AS major_minor,     COUNT(DISTINCT user) FROM events.canonical_log_lines WHERE created > CURRENT_DATE - interval '2 months'     AND language = 'go' GROUP BY 1, 2 ORDER BY 1, 3 DESC   `

## Apalancamiento del producto

Ya habíamos formalizado el esquema de nuestras líneas de registro canónicas con un búfer de protocolo para su uso en análisis, así que dimos un paso más y comenzamos a usar estos datos para impulsar partes del propio producto Stripe. Hace un año presentamos nuestro  [Panel de Desarrolladores](https://stripe.com/blog/developer-dashboard)  , que brinda a los usuarios acceso a métricas de alto nivel sobre sus integraciones de API.

El  [panel de control para desarrolladores](https://stripe.com/blog/developer-dashboard)  muestra el número de solicitudes API exitosas para esta cuenta de Stripe. Los datos se generan a partir de las líneas de registro canónicas archivadas en S3.

Los gráficos generados para este panel también se crean a partir de líneas de registro canónicas. Un backend MapReduce procesa los archivos almacenados en S3 para generar visualizaciones personalizadas para cada usuario que navega por sus paneles. Al igual que con nuestras herramientas de análisis, el esquema codificado en la definición del búfer de protocolo garantiza un contrato estable para evitar fallos.

Las líneas canónicas siguen siendo útiles aunque nunca se utilicen para alimentar productos, pero debido a que contienen una gran cantidad de datos históricos, constituyen una excelente fuente de datos primaria para este tipo de uso.

## Esquema de una canalización de registro canónica

Las líneas de registro canónicas son adecuadas para prácticamente cualquier entorno de producción, pero echemos un breve vistazo a algunas tecnologías específicas que podrían usarse para implementar una canalización completa para ellas.

En la mayoría de las configuraciones, los servidores registran la información en su disco local, y estos registros son enviados por agentes recolectores locales a un sistema de procesamiento central para su búsqueda y análisis. La  [documentación de Kubernetes sobre el registro](https://kubernetes.io/docs/concepts/cluster-administration/logging/)  sugiere el uso de Elasticsearch o, en GCP, Stackdriver Logging de Google. Para una pila basada en AWS, una solución convencional es CloudWatch. Las tres requieren un agente como  [fluentd](https://github.com/fluent/fluentd)  para gestionar la transmisión de registros desde los nodos del servidor. Estas soluciones son comunes, pero no exclusivas: el procesamiento de registros es un ecosistema en auge con docenas de opciones para elegir, y vale la pena dedicar tiempo a evaluar y seleccionar la que mejor se adapte a sus necesidades.

Emitir datos a un almacén de datos requiere una solución personalizada, pero no una inusual ni particularmente compleja. Los servidores deben emitir datos de registro canónicos en una estructura de flujo, de forma asíncrona para mantener la rapidez de las operaciones de los usuarios. Kafka es, con diferencia, la opción preferida para la transmisión de datos en la actualidad, pero no es especialmente económica ni fácil de gestionar, por lo que en una configuración a menor escala, los  [flujos de Redis](https://redis.io/topics/streams-intro)  son una buena alternativa. Un grupo de consumidores lee el flujo de forma cooperativa e inserta su contenido de forma masiva en un almacén de datos como Redshift o BigQuery. Al igual que con los procesadores de registros, existen numerosas soluciones de almacenamiento de datos entre las que elegir.

## Observabilidad flexible y ligera

Para recapitular los elementos clave de las líneas de registro canónicas y por qué las consideramos tan útiles:

- Una línea canónica es una línea por solicitud y por servicio que recopila la telemetría clave de cada solicitud.
- Las líneas canónicas no son tan fáciles de consultar como las métricas, pero son extremadamente flexibles y fáciles de usar.
- Las emitimos de forma asíncrona a temas de Kafka para su ingesta en nuestro almacén de datos, lo cual resulta muy útil para el análisis.
- El contrato estable que ofrecen las líneas canónicas las convierte incluso en una excelente opción para potenciar productos orientados al usuario. Nosotros las usamos para generar los gráficos del panel de control para desarrolladores de Stripe.

Han demostrado ser una técnica de observabilidad ligera, flexible e independiente de la tecnología, fácil de implementar y muy potente. Tanto las organizaciones pequeñas como las grandes las encontrarán útiles para obtener visibilidad de los servicios de producción, obtener información valiosa mediante análisis e incluso optimizar sus productos.