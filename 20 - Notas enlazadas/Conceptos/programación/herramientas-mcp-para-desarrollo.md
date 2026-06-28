---
title: "Herramientas MCP para desarrollo"
type: concept
status: active
created: 2026-06-28
updated: 2026-06-28
sources:
  - "20 - Notas enlazadas/Fuentes/2026-06-28-mcp-herramientas-desarrollo.md"
  - "20 - Notas enlazadas/Fuentes/2026-06-28-mcp-desde-cero.md"
tags: [ia, agentes, mcp, programacion, devtools]
review_after: 2026-09-28
---

# Herramientas MCP para desarrollo

## Definicion

Las herramientas MCP para desarrollo son servidores que dan al agente acceso estructurado al contexto real del proyecto: documentacion actualizada, repositorios, issues, bases de datos, pruebas, navegador, seguridad, tareas y servicios de terceros.

Su valor no esta en sumar herramientas por moda, sino en reducir el trabajo manual de copiar contexto y permitir que el agente opere con informacion actual, verificable y acotada.

## Familias utiles

| Familia | Ejemplos citados en las fuentes | Uso |
| --- | --- | --- |
| Documentacion actualizada | Context7 | Consultar APIs, librerias y frameworks recientes. |
| Repositorio y gestion de cambios | GitHub MCP, GitHub CLI como alternativa | Issues, ramas, PR, estado del proyecto y revision. |
| Bases de datos | Supabase, PostgreSQL | Inspeccion de esquemas, consultas, relaciones y datos de desarrollo. |
| Testing | TestSprite | Generacion, ejecucion y revision de pruebas. |
| Seguridad de codigo | Semgrep | Analisis de vulnerabilidades, malas practicas y reglas personalizadas. |
| Navegador/frontend | Playwright, Chrome DevTools | Verificar UI, rellenar formularios, probar flujos y depurar frontend. |
| Gestion de tareas | Notion, Jira, ClickUp, Asana, Trello | Crear y actualizar tareas derivadas del trabajo tecnico. |
| Investigacion externa | Perplexity u otros buscadores | Contrastar enfoques o mejores practicas antes de planificar. |
| Memoria operativa | herramientas tipo Pieces/Engram segun fuentes | Recordar patrones, errores recurrentes y decisiones recientes. |

## Criterios de seleccion

- Instalar solo lo que responda a un flujo repetido.
- Priorizar herramientas que reduzcan errores verificables, no solo clics.
- Preferir herramientas oficiales o mantenidas por el proveedor del sistema.
- Revisar permisos antes de conectar cuentas personales o productivas.
- Mantener alternativas simples cuando existan, por ejemplo CLI local para GitHub.
- Separar entornos de desarrollo, pruebas y produccion.

## Riesgos

- Dar escritura a una base de datos productiva puede romper informacion critica.
- Un agente con acceso a tareas puede cerrar o crear trabajo sin criterio humano.
- Un MCP de navegador puede ejecutar flujos no deseados si las instrucciones son ambiguas.
- Un MCP de busqueda web puede introducir informacion no validada.
- Un MCP de seguridad no sustituye revision tecnica ni pruebas.

## Uso recomendado en esta boveda

Para proyectos propios, el orden prudente seria:

1. Documentacion actualizada y busqueda local.
2. GitHub o CLI con permisos revisables.
3. Navegador para validar interfaces.
4. Testing automatizado.
5. Bases de datos solo en entornos de desarrollo.
6. Escritura o acciones externas solo despues de definir reglas de aprobacion.

## Fuentes y relaciones

- Fuentes:
  - [[2026-06-28-mcp-herramientas-desarrollo]]
  - [[2026-06-28-mcp-desde-cero]]
- Conceptos relacionados:
  - [[model-context-protocol-mcp]]
  - [[context7-mcp]]
  - [[semgrep-mcp]]
  - [[seguridad-y-gobierno-de-mcp]]
  - [[contexto-persistente-para-agentes]]
