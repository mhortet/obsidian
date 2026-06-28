---
title: "Log"
type: register
status: active
created: 2026-06-27
updated: 2026-06-28
sources: []
tags: [sistema, log]
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
