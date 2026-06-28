---
title: "Servidores MCP locales y remotos"
type: concept
status: active
created: 2026-06-28
updated: 2026-06-28
sources:
  - "20 - Notas enlazadas/Fuentes/2026-06-28-mcp-desde-cero.md"
  - "20 - Notas enlazadas/Fuentes/2026-06-28-creacion-mcp-go.md"
tags: [ia, agentes, mcp, arquitectura]
review_after: 2026-09-28
---

# Servidores MCP locales y remotos

## Definicion

Un servidor MCP es el proceso que expone capacidades a un agente. Puede ejecutarse en local, cerca del proyecto y de los archivos del usuario, o en remoto, como servicio accesible por red y normalmente gestionado por un proveedor o por infraestructura propia.

La diferencia no es solo tecnica. Un servidor local suele ser una herramienta de desarrollo, prototipo o automatizacion personal. Un servidor remoto entra en territorio de producto, seguridad, autenticacion, disponibilidad, logs y gobierno.

## Modos de transporte

| Modo | Uso habitual | Ventaja | Riesgo principal |
| --- | --- | --- | --- |
| STDIO | Servidor local lanzado por el host o editor | Simple para prototipos y herramientas locales | Difuminacion de permisos si se le da acceso amplio al disco |
| HTTP | Servidor remoto o local expuesto como servicio | Encaja mejor con autenticacion, despliegue y observabilidad | Requiere proteger red, tokens, usuarios y scopes |
| SSE / WebSocket segun fuente | Comunicacion sostenida o variantes de transporte | Puede encajar con flujos remotos | Mas complejidad operativa |

Las fuentes coinciden en que STDIO es comun en ejemplos locales, mientras que HTTP cobra importancia cuando se quiere pasar a entornos mas productivos o servicios remotos.

## Local

Un MCP local puede leer archivos, consultar herramientas instaladas, interactuar con un repositorio o exponer utilidades del entorno de desarrollo. Es adecuado para pruebas controladas, scripts internos y trabajo personal.

Criterios:

- Preferir read-only al inicio.
- Delimitar rutas permitidas.
- No exponer secretos, `.env`, credenciales ni datos sensibles.
- Tener nombres y descripciones precisas para cada tool.
- Ejecutar en proyectos no sensibles hasta entender bien su comportamiento.

## Remoto

Un MCP remoto permite que un agente se conecte a sistemas de terceros o servicios propios mediante URL, autenticacion y permisos. Ejemplos: GitHub, calendarios, gestores documentales, bases de datos cloud o servicios internos.

Criterios:

- Usar autenticacion robusta y tokens revocables.
- Separar scopes de lectura, escritura y administracion.
- Registrar auditoria de llamadas.
- Documentar propietario, finalidad y datos expuestos.
- Tratar cada servidor como una API productiva, no como una extension informal del chat.

## Criterio para proyectos sanitarios

En contexto hospitalario o tecnico-sanitario, un servidor MCP remoto no deberia acceder a datos personales, pacientes, imagenes clinicas identificables, credenciales o informacion contractual sensible salvo que exista revision humana, base legal, trazabilidad y control de permisos. Para prototipos, usar datos anonimizados o sinteticos.

## Fuentes y relaciones

- Fuentes:
  - [[2026-06-28-mcp-desde-cero]]
  - [[2026-06-28-creacion-mcp-go]]
- Conceptos relacionados:
  - [[model-context-protocol-mcp]]
  - [[seguridad-y-gobierno-de-mcp]]
  - [[mcp-propio-para-la-boveda-obsidian]]
