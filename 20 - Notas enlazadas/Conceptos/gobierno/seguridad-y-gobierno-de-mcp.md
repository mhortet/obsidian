---
title: "Seguridad y gobierno de MCP"
type: concept
status: active
created: 2026-06-28
updated: 2026-06-28
sources:
  - "20 - Notas enlazadas/Fuentes/2026-06-28-mcp-explicado-productividad.md"
  - "20 - Notas enlazadas/Fuentes/2026-06-28-mcp-herramientas-desarrollo.md"
  - "20 - Notas enlazadas/Fuentes/2026-06-28-creacion-mcp-go.md"
tags: [ia, agentes, mcp, seguridad, gobierno]
review_after: 2026-09-28
---

# Seguridad y gobierno de MCP

## Definicion

Seguridad y gobierno de MCP es el conjunto de reglas tecnicas y organizativas para decidir que herramientas puede usar un agente, con que permisos, sobre que datos, bajo que aprobaciones y con que trazabilidad.

El riesgo principal no es MCP como protocolo, sino el efecto practico de dar a un agente una interfaz para leer, escribir, consultar, modificar o publicar en sistemas reales.

## Principios

- Permisos minimos por defecto.
- Lectura antes que escritura.
- Desarrollo antes que produccion.
- Acciones reversibles antes que acciones destructivas.
- Autenticacion revocable.
- Auditoria de llamadas.
- Separacion clara entre recomendacion del agente y decision humana.

## Riesgos recurrentes

- Acceso directo a bases de datos con permisos de escritura.
- Lectura de secretos, `.env`, tokens o claves privadas.
- Acciones sobre repositorios sin revision de diff, tests y aprobacion.
- Automatizacion de tareas que cierra trabajo sin validacion.
- Exposicion de informacion sensible a servidores externos.
- Descripciones de tools ambiguas que llevan al agente a invocarlas mal.
- Memorias operativas que acumulan informacion obsoleta o no autorizada.

## Controles practicos

- Crear cuentas de servicio especificas para MCP.
- Definir scopes por herramienta.
- Separar entornos: local, desarrollo, staging y produccion.
- Usar allowlists de proyectos, rutas, tablas o endpoints.
- Mantener logs de invocaciones y resultados.
- Exigir confirmacion humana para escritura, borrado, envio, publicacion o cambios productivos.
- Revisar periodicamente que MCP siguen instalados y por que.
- Documentar responsable, finalidad, datos accesibles y mecanismo de revocacion.

## En ambito sanitario

Un MCP aplicado a sistemas hospitalarios debe considerarse una integracion tecnica con potencial impacto en confidencialidad, continuidad, seguridad y calidad. No deberia exponerse a datos de pacientes, credenciales, imagenes clinicas identificables, historiales, contratos o informacion operacional sensible sin evaluacion formal.

Para pilotos, usar:

- Datos sinteticos o anonimizados.
- Entornos locales o de desarrollo.
- Herramientas read-only.
- Logs revisables.
- Validacion humana de cualquier resultado que pueda afectar mantenimiento, compras, calidad, legalidad o asistencia.

## Fuentes y relaciones

- Fuentes:
  - [[2026-06-28-mcp-explicado-productividad]]
  - [[2026-06-28-mcp-herramientas-desarrollo]]
  - [[2026-06-28-creacion-mcp-go]]
- Conceptos relacionados:
  - [[model-context-protocol-mcp]]
  - [[servidores-mcp-locales-y-remotos]]
  - [[mcp-propio-para-la-boveda-obsidian]]
