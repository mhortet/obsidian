---
title: "Asi se crea un MCP con Go"
type: source
status: active
created: 2026-06-28
updated: 2026-06-28
source_id: "2026-06-28-creacion-mcp-go"
raw_path: "raw/sources/🔥 ASÍ se crea  un MCP - CON @Achetronic.md"
sources:
  - "https://www.youtube.com/watch?v=tjGopRhYa4I"
tags: [ia, agentes, mcp, go, arquitectura, seguridad]
review_after: 2026-09-28
---

# Asi se crea un MCP con Go

## Resumen ejecutivo

Stream tecnico sobre implementacion de servidores MCP en Go y consideraciones de arquitectura, transporte, integracion con Claude y seguridad. La fuente aporta una vision mas cercana a produccion que las introducciones basicas: insiste en que un MCP no es magia, sino una capa programatica entre un LLM y APIs, procesos o sistemas externos.

Para esta boveda es especialmente relevante por la separacion entre prototipos locales y despliegues remotos, y por la insistencia en autenticacion, JWT, endpoints de autorizacion, middleware y restricciones por claims cuando el servidor se expone como conector.

## Datos de la fuente

- Tipo: stream tecnico con transcripcion capturada por Web Clipper.
- Autor / entidad: Gentleman Programming con Achetronic.
- Fecha de publicacion: 2025-09-17.
- Fecha de ingesta: 2026-06-28.
- Ruta original: `raw/sources/🔥 ASÍ se crea  un MCP - CON @Achetronic.md`.
- URL: `https://www.youtube.com/watch?v=tjGopRhYa4I`.

## Ideas clave

- MCP se describe como el protocolo entre un LLM y un programa que interactua con APIs, procesos o servicios externos.
- El LLM trabaja con lenguaje; los sistemas externos esperan peticiones estructuradas.
- Se mencionan transportes como STDIO, HTTP y variantes sostenidas tipo SSE/WebSocket segun la fuente.
- STDIO encaja con herramientas locales y pruebas rapidas; HTTP es mas relevante para servidores remotos o despliegues productivos.
- Una tool es una funcion con nombre, descripcion y ejecucion; la descripcion condiciona que el agente la use correctamente.
- Go se presenta como opcion adecuada por concurrencia y despliegue sencillo.
- Para conectores remotos, la fuente entra en autenticacion, JWT, recursos protegidos, authorization server, dynamic client registration y middleware.
- Se insiste en que produccion requiere controles adicionales que no aparecen en ejemplos "hello world".

## Implicaciones

- Cualquier MCP propio para esta boveda deberia empezar local y read-only.
- Si en el futuro se expone por HTTP, debe tratarse como una API con autenticacion, autorizacion, logs y restricciones por alcance.
- Las tools necesitan nombres y descripciones diseñadas como contrato operativo, no como etiquetas improvisadas.
- Para entorno sanitario, no se debe pasar de prototipo a produccion sin revision formal de seguridad y privacidad.

## Relaciones

- Conceptos:
  - [[model-context-protocol-mcp]]
  - [[servidores-mcp-locales-y-remotos]]
  - [[seguridad-y-gobierno-de-mcp]]
- Fuentes relacionadas:
  - [[2026-06-28-mcp-desde-cero]]
  - [[2026-06-28-mcp-herramientas-desarrollo]]
- Proyectos relacionados:
  - `32 - programacion/`

## Contradicciones, dudas o limites

- La transcripcion es larga, informal y contiene interrupciones, bromas y errores de reconocimiento.
- Algunas referencias a requisitos concretos de Claude, OpenAI u otros proveedores pueden cambiar y deben validarse en documentacion oficial antes de implementar.
- No se ha auditado el template o codigo mencionado en el stream.
