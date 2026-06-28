---
title: "Model Context Protocol (MCP)"
type: concept
status: active
created: 2026-06-28
updated: 2026-06-28
sources:
  - "20 - Notas enlazadas/Fuentes/2026-06-28-mcp-explicado-productividad.md"
  - "20 - Notas enlazadas/Fuentes/2026-06-28-mcp-desde-cero.md"
  - "20 - Notas enlazadas/Fuentes/2026-06-28-creacion-mcp-go.md"
tags: [ia, agentes, mcp, integraciones]
review_after: 2026-09-28
---

# Model Context Protocol (MCP)

## Definicion

Model Context Protocol (MCP) es un protocolo para conectar aplicaciones con IA a herramientas, datos y servicios externos mediante una interfaz comun. Su valor practico esta en evitar integraciones ad hoc entre cada agente y cada sistema: el agente habla con un servidor MCP y ese servidor expone capacidades de forma estructurada.

En terminos operativos, MCP actua como una capa de traduccion entre lenguaje natural y sistemas programaticos. El usuario pide una tarea al agente; el agente decide si necesita una herramienta; el servidor MCP expone que herramientas o recursos existen; y la herramienta ejecuta o devuelve informacion bajo reglas definidas.

## Arquitectura basica

- Host: aplicacion donde vive la experiencia de IA, por ejemplo un editor, cliente de escritorio o herramienta de agente.
- Cliente MCP: componente del host que mantiene la conexion con un servidor MCP concreto.
- Servidor MCP: proceso que expone capacidades hacia el agente.
- Herramienta externa: base de datos, API, repositorio, calendario, sistema documental, navegador, servicio cloud o aplicacion local.

Las fuentes consultadas describen MCP como una forma de pasar de conexiones personalizadas a un contrato comun. La analogia recurrente es "USB-C para IA", util para explicar la idea, aunque no debe ocultar que cada servidor sigue necesitando configuracion, permisos, seguridad y mantenimiento.

## Primitivos principales

- Tools: funciones que el agente puede invocar para hacer algo. Ejemplos: crear una issue, ejecutar una consulta, lanzar un test, enviar una notificacion o leer una tabla.
- Resources: informacion disponible en modo lectura. Ejemplos: documentos, registros, metricas, esquemas, archivos o resultados ya existentes.
- Prompts: plantillas o recetas reutilizables que el servidor puede ofrecer para estandarizar tareas.

La descripcion de cada tool importa mucho: el agente aproxima la intencion del usuario contra el nombre, la descripcion y el esquema de entrada de la herramienta. Una tool mal descrita puede no usarse, usarse tarde o usarse para una tarea que no corresponde.

## Criterios practicos

- Usar MCP cuando el agente necesite contexto vivo o acciones sobre sistemas externos.
- Evitar MCP si basta con pasar un documento puntual o leer un archivo local.
- Separar herramientas de lectura y de escritura.
- Empezar con permisos minimos y acciones reversibles.
- Registrar que sistemas quedan expuestos al agente.
- Documentar riesgos, datos accesibles, propietario y modo de revocacion.

## En esta boveda

MCP encaja como categoria de herramienta agentica: permite que un agente consulte conocimiento curado, documentacion tecnica, repositorios, bases de datos o servicios de proyecto. En ambito sanitario, la prioridad no es "dar mas acceso", sino dar acceso trazable, limitado y revisable.

## Fuentes y relaciones

- Fuentes:
  - [[2026-06-28-mcp-explicado-productividad]]
  - [[2026-06-28-mcp-desde-cero]]
  - [[2026-06-28-creacion-mcp-go]]
- Conceptos relacionados:
  - [[servidores-mcp-locales-y-remotos]]
  - [[herramientas-mcp-para-desarrollo]]
  - [[seguridad-y-gobierno-de-mcp]]
  - [[contexto-persistente-para-agentes]]
