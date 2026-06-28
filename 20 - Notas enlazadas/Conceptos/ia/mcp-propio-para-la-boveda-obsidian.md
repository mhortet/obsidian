---
title: "MCP propio para la boveda Obsidian"
type: concept
status: seed
created: 2026-06-28
updated: 2026-06-28
sources:
  - "20 - Notas enlazadas/Fuentes/2026-06-28-mcp-desde-cero.md"
  - "20 - Notas enlazadas/Fuentes/2026-06-27-engram-cloud-contexto-compartido-agentes.md"
  - "20 - Notas enlazadas/Conceptos/ia/contexto-persistente-para-agentes.md"
tags: [ia, agentes, mcp, obsidian, conocimiento]
review_after: 2026-09-28
---

# MCP propio para la boveda Obsidian

## Definicion

Un MCP propio para la boveda Obsidian seria un servidor local que exponga a los agentes herramientas controladas para buscar, leer y resumir conocimiento curado sin dar acceso indiscriminado a toda la carpeta.

No sustituye a Obsidian ni a Git. Seria una interfaz de consulta para que agentes de IA encuentren mejor el contexto que ya existe: indice, fuentes procesadas, conceptos, proyectos, decisiones y log.

## Capacidades candidatas

- Buscar notas curadas por texto, tags, tipo o estado.
- Leer `00 - Sistema/Indice.md` y `00 - Sistema/log.md`.
- Listar fuentes procesadas desde `registro-fuentes.csv`.
- Consultar notas `needs-review` o `review_after` vencido.
- Localizar conceptos relacionados con un proyecto.
- Devolver solo rutas y fragmentos breves, no documentos completos por defecto.

## Fase inicial recomendada

Empezar por un MCP local read-only, limitado a:

- `00 - Sistema/`
- `20 - Notas enlazadas/`
- rutas de proyecto explicitamente permitidas

No deberia acceder inicialmente a `raw/`, adjuntos, capturas, credenciales ni carpetas sanitarias sensibles salvo autorizacion concreta. Si se usa para QontrolMed u otros proyectos tecnico-sanitarios, el alcance debe quedar documentado.

## Criterios de diseno

- Cada tool debe tener una descripcion precisa.
- Las respuestas deben devolver trazabilidad: ruta, fecha y tipo de nota.
- Las busquedas deben favorecer notas curadas antes que fuentes crudas.
- Las acciones de escritura deben quedar fuera de la primera version.
- Cualquier promocion de memoria operativa a nota curada debe pasar por revision humana.

## Relacion con memoria de agentes

Este MCP cubriria recuperacion de conocimiento canonico. Para memoria tactica de sesion, herramientas tipo Engram pueden ser utiles, pero deberian convivir con la boveda, no reemplazarla. La regla seria: la memoria operativa ayuda a recordar; Obsidian conserva lo validado.

## Fuentes y relaciones

- Fuentes:
  - [[2026-06-28-mcp-desde-cero]]
  - [[2026-06-27-engram-cloud-contexto-compartido-agentes]]
- Conceptos relacionados:
  - [[model-context-protocol-mcp]]
  - [[contexto-persistente-para-agentes]]
  - [[seguridad-y-gobierno-de-mcp]]
