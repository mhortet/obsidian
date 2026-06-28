---
title: "MCP vs API"
type: concept
status: active
created: 2026-06-28
updated: 2026-06-28
sources:
  - "20 - Notas enlazadas/Conceptos/ia/model-context-protocol-mcp.md"
  - "20 - Notas enlazadas/Conceptos/ia/mcp-propio-para-la-boveda-obsidian.md"
  - "20 - Notas enlazadas/Conceptos/gobierno/seguridad-y-gobierno-de-mcp.md"
tags: [concepto, ia, agentes, mcp, api, arquitectura]
review_after: 2026-09-28
---

# MCP vs API

## Definicion corta

Una API es una interfaz para que un programa hable con otro programa o sistema.

Un MCP es una interfaz para que un agente de IA descubra y use herramientas, datos o acciones de forma estructurada.

El objetivo se parece: conectar sistemas. La diferencia principal es el destinatario del contrato.

## Resumen para dummies

- API: pensada para programas en produccion.
- MCP: pensado para agentes de IA durante desarrollo, asistencia, automatizacion o trabajo con contexto.
- Un MCP puede llamar a una API por dentro.
- Si un MCP se usa en produccion, hay que tratarlo con el mismo rigor que una API: autenticacion, permisos, logs, limites, auditoria y versionado.

Formula mental:

```text
MCP para agentes y desarrollo asistido.
API para funcionalidades entre programas en produccion.
```

Y muchas veces:

```text
Agente -> MCP -> API -> Sistema real
```

## Diferencia practica

| Aspecto | API | MCP |
| --- | --- | --- |
| Destinatario | Software tradicional | Agentes de IA |
| Pregunta que responde | Como accede una app a una funcion o dato | Que herramientas puede usar un agente y como debe entenderlas |
| Contrato | Endpoints, parametros, metodos, respuestas | Tools, resources, prompts, descripciones y esquemas |
| Decision de uso | La decide el programador o la aplicacion | El agente puede decidir cuando invocar una tool |
| Contexto | Tecnico y estable | Tecnico + semantico para el modelo |
| Ejemplo | `GET /notes?query=mcp` | `buscar_conocimiento_curado(query, tipo, limite)` |
| Riesgo | Integracion mal protegida | Integracion mal protegida + agente con instrucciones ambiguas |

## Ejemplo de la boveda Obsidian

Una API clasica para la boveda podria exponer:

```text
GET /notes?query=mcp
GET /notes/{id}
```

Eso sirve para que un programa consulte notas, pero no explica demasiado al agente que debe hacer, que no debe tocar, que rutas son seguras o que tipo de nota tiene prioridad.

Un MCP propio para la boveda podria exponer una herramienta como:

```text
Tool: buscar_conocimiento_curado
Descripcion: Busca solo en notas curadas de la boveda y devuelve rutas, resumen, tipo de nota y fecha.
Parametros: query, tipo, limite
Restricciones: no accede a raw, adjuntos, credenciales ni notas sensibles.
```

La diferencia es que el MCP no solo abre acceso: tambien empaqueta intencion, limites y contexto operativo para que el agente lo use con mas criterio.

## Regla de decision

Usar API cuando:

- Una aplicacion necesita una funcionalidad estable.
- Hay integracion entre servicios.
- El contrato debe ser consumido por software convencional.
- Se busca produccion, escalabilidad, versionado y compatibilidad.

Usar MCP cuando:

- Un agente necesita consultar contexto o ejecutar herramientas.
- Se quiere que el agente descubra capacidades disponibles.
- La herramienta debe estar descrita en lenguaje util para un LLM.
- Se trabaja en desarrollo asistido, automatizacion, revision, analisis o soporte operativo.

## Criterio sanitario

En ambito sanitario o tecnico-sanitario, MCP no debe entenderse como "permiso para que la IA toque sistemas". Es una superficie de acceso que debe limitarse.

Por defecto:

- MCP local y de solo lectura.
- Rutas permitidas explicitas.
- Sin datos de pacientes, credenciales ni informacion clinica identificable.
- Escritura solo con aprobacion humana y despues de definir controles.
- Si se despliega como servicio remoto, tratarlo como API productiva.

## Relaciones

- [[ia/model-context-protocol-mcp|Model Context Protocol (MCP)]]
- [[ia/mcp-propio-para-la-boveda-obsidian|MCP propio para la boveda Obsidian]]
- [[gobierno/seguridad-y-gobierno-de-mcp|Seguridad y gobierno de MCP]]
- [[programación/herramientas-mcp-para-desarrollo|Herramientas MCP para desarrollo]]
