---
title: "Herramientas agenticas"
type: register
status: active
created: 2026-06-28
updated: 2026-06-28
sources: []
tags: [ia, agentes, mcp, herramientas]
review_after:
---

# Herramientas agenticas

Esta carpeta agrupa conceptos reutilizables sobre trabajo con agentes de IA: herramientas, protocolos, memoria, integraciones, MCP, automatizacion de desarrollo y criterios de gobierno.

La regla local es sencilla: si una nota explica como un agente obtiene contexto, ejecuta acciones, usa herramientas externas, conserva memoria o se integra con sistemas de trabajo, vive aqui.

## Notas iniciales

- [[model-context-protocol-mcp|Model Context Protocol (MCP)]]
- [[servidores-mcp-locales-y-remotos]]
- [[herramientas-mcp-para-desarrollo]]
- [[context7-mcp]]
- [[semgrep-mcp]]
- [[seguridad-y-gobierno-de-mcp]]
- [[mcp-propio-para-la-boveda-obsidian]]
- [[contexto-persistente-para-agentes]]

## Criterio de seguridad

En proyectos sanitarios o tecnico-sanitarios, cualquier herramienta agentica debe tratarse como una superficie de acceso a datos. Por defecto, empezar con lectura, permisos minimos, datos no sensibles y revision humana antes de permitir escritura o acciones irreversibles.
