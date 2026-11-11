---
title: "Log"
type: register
status: active
created: 2026-06-27
updated: 2026-07-01
sources: []
tags: [sistema]
review_after:
---

# Log

Entradas append-only. Formato recomendado:

```markdown
### [YYYY-MM-DD] tipo | Titulo
```

Tipos recomendados: `bootstrap`, `ingest`, `query`, `lint`, `decision`, `maintenance`.

## [2026-06-27] bootstrap | Capa de buenas practicas sobre la boveda principal

- Se incorpora una capa operativa sin mover ni renombrar notas existentes.
- Se crea `AGENTS.md` como contrato de trabajo para sesiones asistidas.
- Se crea `00 - Sistema/` con indice, log, metadatos, taxonomia, checklist y herramientas.
- Se preparan subcarpetas curadas dentro de `20 - Notas enlazadas/`.
- Se anaden plantillas para fuentes, conceptos, entidades, sintesis y analisis.
- Se deja `raw/` como destino recomendado para fuentes crudas y Web Clipper.

## [2026-06-27] ingest | El microscopio de fluorescencia

- Se procesa la fuente `raw/sources/El microscopio de fluorescencia.md`.
- Se crea la ficha `20 - Notas enlazadas/Fuentes/2026-06-27-microscopio-fluorescencia.md`.
- Se crea el concepto `20 - Notas enlazadas/Conceptos/microscopia-de-fluorescencia.md`.
- Se registra la fuente en `00 - Sistema/meta/registro-fuentes.csv`.
- No se modifica la fuente cruda, aunque presenta problemas de codificacion en la transcripcion original.

## [2026-06-27] ingest | MySQL Reference Architectures for Security

- Se procesa el PDF `50 - Recursos/03 documentos/mysql_wp_reference_architecture_security.pdf`.
- Se conserva copia cruda normalizada en `raw/sources/mysql_wp_reference_architecture_security.pdf`.
- Se crea la ficha `20 - Notas enlazadas/Fuentes/2026-06-27-mysql-reference-architectures-security.md`.
- Se crea el concepto `20 - Notas enlazadas/Conceptos/arquitectura-de-seguridad-mysql.md`.
- Se crea el proceso preliminar `20 - Notas enlazadas/Procesos/checklist-seguridad-mysql.md`.
- Se registra la fuente en `00 - Sistema/meta/registro-fuentes.csv`.
- Se marca la necesidad de revisar vigencia por tratarse de seguridad, normativa y producto de proveedor.

## [2026-06-27] ingest | Engram Cloud y contexto compartido entre agentes

- Se procesa la fuente `raw/sources/La EVOLUCIÓN del contexto compartido entre AGENTES Engram Cloud.md`.
- Se crea la ficha `20 - Notas enlazadas/Fuentes/2026-06-27-engram-cloud-contexto-compartido-agentes.md`.
- Se crea el concepto `20 - Notas enlazadas/Conceptos/contexto-persistente-para-agentes.md`.
- Se crea el analisis `20 - Notas enlazadas/Analisis/2026-06-27-opciones-integracion-contexto-persistente-agentes.md`.
- Se registra la fuente en `00 - Sistema/meta/registro-fuentes.csv`.
- Se marca como pendiente validar madurez tecnica y seguridad antes de cualquier despliegue.

## [2026-06-28] ingest | MCP y herramientas agenticas

- Se procesan las fuentes nuevas en `raw/sources/` sobre MCP:
  - `raw/sources/Que es MCP Explicado fácil en 5 minutos, con ej.  productividad.md`.
  - `raw/sources/MCP desde cero Conecta tu IA a cualquier dato.md`.
  - `raw/sources/7 MCP que mejoran tu IA para programar.md`.
  - `raw/sources/🔥 ASÍ se crea  un MCP - CON @Achetronic.md`.
- Se crean cuatro fichas en `20 - Notas enlazadas/Fuentes/`.
- Se crea la carpeta `20 - Notas enlazadas/Conceptos/Herramientas agenticas/` para agrupar conceptos sobre agentes de IA, MCP, memoria, integraciones y gobierno.
- Se mueve `contexto-persistente-para-agentes.md` a la nueva carpeta tematica.
- Se crean conceptos sobre MCP, servidores locales/remotos, herramientas MCP para desarrollo, seguridad/gobierno y posible MCP propio para la boveda.
- Se actualizan indice, README de fuentes, README de conceptos y registro de fuentes.
- Se crea `15 - Notas diarias/README.md` para resolver el enlace estructural del indice.
- Se mantienen intactas las fuentes crudas; varias transcripciones se marcan como orientativas por errores de codificacion y reconocimiento.

## [2026-06-28] ingest | Context7 MCP y Semgrep MCP

- Se amplian los conceptos de `20 - Notas enlazadas/Conceptos/Herramientas agenticas/`.
- Se crea `context7-mcp.md` con uso, instalacion orientativa en Codex, pautas de consulta y cautelas de privacidad.
- Se crea `semgrep-mcp.md` normalizando la transcripcion "Sengrab" como Semgrep MCP, con estado de vigencia, proceso de uso y criterios de seguridad.
- Se usan fuentes oficiales actuales: repositorios y documentacion de Context7 y Semgrep.
- Se actualiza el README de la carpeta tematica.

## [2026-06-28] ingest | MCP vs API

- Se crea `20 - Notas enlazadas/Conceptos/mcp-vs-api.md`.
- Se resume la conversacion conceptual sobre diferencias entre MCP y API.
- Se deja como concepto transversal fuera de `Herramientas agenticas`, enlazando a las notas tecnicas de MCP.

## [2026-06-28] maintenance | Segmentacion de conceptos

- Se reorganiza `20 - Notas enlazadas/Conceptos/` en carpetas tematicas: `conocimiento/`, `gobierno/`, `ia/`, `ingenieria/`, `movilidad-electrica/` y `programación/`.
- Se mueve el contenido de `Herramientas agenticas/` a `ia/`, `programación/` o `gobierno/` segun su centro de gravedad.
- Se mueve `microscopia-de-fluorescencia.md` a `ingenieria/`.
- Se mueve `arquitectura-de-seguridad-mysql.md` a `gobierno/`.
- Se mueve `mcp-vs-api.md` a `ia/`.
- Se actualizan `AGENTS.md`, `00 - Sistema/Indice.md` y `20 - Notas enlazadas/Conceptos/README.md`.
- Se define que `30 - Proyectos/`, `32 - programación/` y las areas `40 - Hospital/`, `45 - coches electricos/` y `55 - Ayuntamiento/` quedan como espacios de trabajo vivo que pueden promocionar conocimiento maduro a conceptos.

## [2026-06-28] maintenance | Limpieza documental Qontrolmed raiz

- Se revisan los documentos situados directamente en `30 - Proyectos/Qontrolmed/`, sin reorganizar subcarpetas existentes.
- Se crea `README.md` como entrada limpia del proyecto.
- Se crea `evolucion_proyecto.md` como diario sintetico deducido de los documentos raiz.
- Se crea `mapa_documental_qontrolmed.md` para separar documentos vivos, historicos y entregables.
- Se crean carpetas de organizacion:
  - `01_gobierno_y_decisiones/`;
  - `02_historico/`;
  - `03_entregables/`.
- Se conservan los documentos absorbidos por trazabilidad y se sacan de la raiz para reducir ruido.
- Se mantienen como documentos vivos de raiz `security_delivery_playbook.md`, `estado_continuidad.md`, `plan_seguridad_consistencia.md` y `cola_triaje_campo.md`.
- Se restaura la ruta estructural `55 - Ayuntamiento/` con un README minimo para resolver el enlace del indice.

## [2026-06-29] query | Aprendizaje de programacion con Fortnite

- Se crea `30 - Proyectos/Aprendizaje programacion con Fortnite/README.md` como apunte de proyecto para retomar a partir de septiembre de 2026.
- Se resume el ecosistema Fortnite Creative, UEFN y Verse desde un enfoque educativo y no comercial.
- Se incorpora una explicacion basica de NPCs como personajes no jugadores controlados por reglas del sistema.
- Se actualiza `00 - Sistema/Indice.md` con el enlace al proyecto vivo.

## [2026-06-29] maintenance | Concepto NPC

- Se promociona la explicacion de NPC a `20 - Notas enlazadas/Conceptos/conocimiento/npc-personaje-no-jugador.md`.
- Se actualiza `30 - Proyectos/Aprendizaje programacion con Fortnite/README.md` para enlazar al concepto en vez de contener la definicion completa.
- Se actualiza `20 - Notas enlazadas/Conceptos/conocimiento/README.md` con el nuevo concepto.

## [2026-07-01] ingest | Entrevista con Geoffrey Hinton y apertura de Humanidades

- Se procesa la fuente `raw/sources/“He creado un MONSTRUO”. Entrevista con Geoff Hinton, el PADRE de la IA.md`.
- Se crea la ficha `20 - Notas enlazadas/Fuentes/2026-07-01-entrevista-geoffrey-hinton-monstruo-ia.md`.
- Se crea el analisis `20 - Notas enlazadas/Analisis/2026-07-01-humanidades-entrevista-hinton.md`.
- Se abre `20 - Notas enlazadas/Conceptos/humanidades/` como seccion semilla para filosofia, etica, cultura, educacion, politica, sentido del trabajo y condicion humana.
- Se crean los conceptos `humanismo-ante-superinteligencia.md`, `experiencia-subjetiva-en-ia.md` e `ia-maternal-y-etica-del-cuidado.md`.
- Se actualizan indice, taxonomia, README de fuentes, README de conceptos, README de analisis y registro de fuentes.
- La transcripcion cruda se conserva intacta y se marca como fuente con problemas de codificacion; las predicciones y cifras se tratan como opinion experta hasta verificacion externa.

## [2026-07-18] ingest | Entrevista a Ramón López de Mántaras y contraste de entrenamiento de IA

- Se procesa `raw/sources/dr. ramón lópez de mántaras - Buscar con Google.md` sin modificar la captura original.
- Se identifica el vídeo `pmsTzFLM8rI`, *La Gran Mentira de la Inteligencia Artificial Que Nadie te Cuenta*, del canal Vidas Ajenas.
- Se documenta que el raw es una página de resultados de Google y no una transcripción; la revisión usa el índice temporal, el resumen del vídeo y fuentes externas, y exige comprobar el vídeo antes de citar literalmente.
- Se crea la ficha `20 - Notas enlazadas/Fuentes/2026-07-18-video-ramon-lopez-de-mantaras-gran-mentira-ia.md`.
- Se crea el análisis `20 - Notas enlazadas/Analisis/2026-07-18-afirmaciones-entrenamiento-y-vision-ia-lopez-de-mantaras.md`.
- Se crea el concepto `20 - Notas enlazadas/Conceptos/ia/entrenamiento-de-llm-datos-humanos-y-sinteticos.md`.
- Se distingue preentrenamiento, postentrenamiento, feedback, inferencia y operación humana.
- Se interpreta «ChatGPT» como metonimia habitual de los asistentes basados en LLM, salvo menciones específicas a OpenAI o versiones GPT.
- Se contrastan trabajo digital, datos sintéticos, colapso de modelo, leyes de escala, alucinaciones, grounding, corporeidad y delegación cognitiva.
- Se enlaza la posición de López de Mántaras con la fuente previa sobre Geoffrey Hinton para mostrar desacuerdos sobre conciencia y riesgo.
- Se actualizan índice, README de fuentes, análisis e IA, y registro de fuentes.

## [2026-07-18] maintenance | Gobierno y normalizacion de tags

- Se inventarian 119 formas distintas de tags en el ambito controlado de la boveda.
- Se define un vocabulario canonico de 43 tags en `00 - Sistema/meta/tags-controlados.json`, con alias, eliminaciones y limites de uso.
- Se normaliza el frontmatter de 219 notas; se unifican mayusculas, tildes, abreviaturas, guiones, singular/plural y etiquetas equivalentes.
- Se establece `qontrolmed` como tag canonico del proyecto y `app` como alias historico, de acuerdo con el uso en diarios, prompts y documentos de la aplicacion.
- Se eliminan tags que duplicaban metadatos (`source`, `concept`, estados y tipos) o eran demasiado circunstanciales.
- Se limita cada nota a cinco tags y a dos dominios generales, conservando los tags especificos que aportan recuperacion real.
- Se incorpora `00 - Sistema/tools/obsidian_tags.py` para informar, comprobar y normalizar; `obsidian_lint.py` ejecuta tambien esta validacion.
- Se actualizan `AGENTS.md`, la taxonomia y la checklist para impedir que futuras ingestas creen tags arbitrarios.
- Se excluye `raw/` de la normalizacion para preservar las capturas originales.
- Se guarda la trazabilidad completa en `00 - Sistema/meta/auditorias/tags-normalizacion-2026-07-18.csv`.

## [2026-07-18] analysis | Evaluacion de Gentle-AI, Engram y memoria local de Codex

- Se revisan los repositorios actuales de Gentle-AI y Engram y su integracion documentada con Codex en Windows.
- Se contrasta la propuesta con la memoria local nativa descrita en la documentacion oficial de Codex.
- Se crea `20 - Notas enlazadas/Analisis/2026-07-18-evaluacion-gentle-ai-engram-memoria-codex.md`.
- Se concluye aplicar una adopcion incremental: probar primero la memoria nativa de Codex, valorar Engram local solo ante una carencia demostrada y no implantar por ahora Gentle-AI completo.
- Se mantienen Obsidian como memoria canonica y la exclusion de datos sensibles como criterios de gobierno.
- Se actualiza `00 - Sistema/Indice.md` con el nuevo analisis.

## [2026-10-31] maintenance | Acceso SSH y cambio de red de srv-mm-01

- Se documenta el cambio controlado de acceso SSH desde la LAN de preparacion `192.168.1.0/24` y la retirada de la regla obsoleta `192.168.2.0/24`.
- Se registra la preautorizacion TCP/22 de `192.168.0.0/24`, subred comunicada por el cliente pero pendiente de direccion, gateway, DHCP, DNS y validacion en sede.
- Se crea `30 - Proyectos/Servidor_MM/Servidor/ESTADO-ACCESO-SSH-Y-RED-2026-10-31.md` como evidencia y relevo operativo.
- Se crea `30 - Proyectos/Servidor_MM/Servidor/GUIA-DIDACTICA-CAMBIO-DE-RED-SSH-UFW.md` para aprendizaje y reutilizacion segura del procedimiento.
- Se actualizan `CONTINUAR-SIGUIENTE-SESION.md`, la revision documental vigente y el indice de la boveda.
- Se ejecutan `obsidian_lint.py` y `obsidian_tags.py check`: cero errores; los avisos restantes son anteriores o ajenos a este proyecto.

## [2026-11-01] maintenance | Cierre seguro y organizacion documental de srv-mm-01

- Se localiza `srv-mm-01` en `192.168.1.31` mediante MAC, clave SSH y hostname después de que `.30` fuese reasignada a otro equipo.
- El propietario reserva `.31` por DHCP para la MAC de `eno1`; la reserva se valida después de un reinicio.
- Se detecta MySQL activo por arranque automático, sin conexiones y filtrado por UFW; se auditan sus valores efectivos y se deja `disabled`, `inactive` y con 3306/33060 cerrados.
- `unattended-upgrade` instala actualizaciones de seguridad y el kernel 6.8.0-147; se realiza un reinicio controlado y se revalidan red, SSH, UFW, MySQL, montajes y salud del sistema.
- Se reorganiza `30 - Proyectos/Servidor_MM/Servidor/` en seguimiento, gobierno, planes, operación, guías, evidencias, herramientas, recursos y archivo.
- Se crean `README.md`, un estado operativo, un diario, un relevo autosuficiente, una guía didáctica y una plantilla reutilizable para futuros proyectos.
- Se conservan los nombres originales y el relevo anterior se archiva; los enlaces relativos nuevos se validan.
- `obsidian_lint.py` termina con cero errores. Los avisos globales de revisión y tags pertenecen a contenido preexistente ajeno a este proyecto.

## [2026-11-06] maintenance | Preparación doméstica de srv-mm-01 sin datos del cliente

- Se revalida `srv-mm-01` por SSH estricto y en solo lectura: MySQL continúa detenido/deshabilitado, sin 3306/33060 ni unidades fallidas; SSH opera por `ssh.socket` y UFW está activo.
- Se confirma que SFTPGo, `cloudflared` y `restic` no están instalados y que `/srv/compartido/repositorio` no existe.
- Se crea el plan propuesto `30 - Proyectos/Servidor_MM/Servidor/02_planes_y_arquitectura/PLAN-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md`, limitado a datos ficticios, bindings loopback, Cloudflare sin recursos y copia local no 3-2-1.
- Se actualizan documento maestro, diario, README y relevo. No se modificó el servidor ni se instalaron paquetes; la ejecución queda pendiente de una única aprobación explícita.
- `obsidian_lint.py` termina con cero errores; los avisos globales son anteriores o ajenos a este proyecto.

## [2026-11-06] maintenance | Ejecución parcial y pausa segura del bloque doméstico

- Se ejecutan preflight, instalación y configuración del bloque aprobado con SFTPGo Community, `cloudflared` inerte y `restic`, sin datos del cliente ni recursos externos.
- Se crean cuentas ficticias con TOTP y permisos mínimos; no se incorporan contraseñas, secretos o códigos de recuperación a la bóveda.
- Se detecta un bloqueo de tránsito en `/srv/compartido`; tras aprobación específica se instala `acl` y se aplica únicamente `u:sftpgo:--x`, con reversión documentada.
- Se validan autenticación, creación de carpeta y primera carga ficticia. Quedan pendientes descarga, sobrescritura, pruebas negativas, revocación y restauración local `restic`.
- Se cierra el túnel local y se confirma SFTPGo `inactive/disabled`, `cloudflared inactive/masked`, MySQL `inactive/disabled`, puertos del bloque cerrados, cero unidades fallidas y agente SSH vacío.
- Se actualizan el documento maestro a versión 1.2, diario, manifiesto, README, estado de pausa y relevo autosuficiente.
- `obsidian_lint.py` termina con cero errores; los 39 avisos globales y los avisos de tags son preexistentes o ajenos a este proyecto.
