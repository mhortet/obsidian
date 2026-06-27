---
title: "Contexto persistente para agentes"
type: concept
status: active
created: 2026-06-27
updated: 2026-06-27
sources:
  - "20 - Notas enlazadas/Fuentes/2026-06-27-engram-cloud-contexto-compartido-agentes.md"
  - "raw/sources/llm-wiki.md"
tags: [ia, agentes, memoria, conocimiento, mcp]
review_after: 2026-09-27
---

# Contexto persistente para agentes

## Definicion

Contexto persistente para agentes es el conjunto de informacion reutilizable que un agente puede consultar entre sesiones para no empezar de cero: reglas de trabajo, decisiones, preferencias, arquitectura de proyectos, fuentes procesadas, lecciones aprendidas, restricciones locales y estado actual.

No es lo mismo que una ventana de contexto larga. Una ventana amplia permite cargar mas informacion en una conversacion concreta; el contexto persistente organiza que informacion merece sobrevivir, como se actualiza, quien la valida y como se recupera cuando hace falta.

## Contexto

En esta boveda ya existe una forma documental de contexto persistente:

- `AGENTS.md` define reglas de comportamiento para agentes.
- `00 - Sistema/Indice.md` orienta la navegacion.
- `raw/sources/` conserva fuentes crudas.
- `20 - Notas enlazadas/` compila conocimiento reutilizable.
- `00 - Sistema/log.md` conserva continuidad cronologica.

Engram representa una variante mas operativa: una memoria local consultable por agentes, con busqueda y posible sincronizacion entre maquinas. La diferencia importante es que Obsidian conserva conocimiento humano, revisable y versionable; Engram conserva observaciones operativas que el agente puede recuperar de forma rapida.

## Criterios practicos

- Separar memoria canonica y memoria operativa.
- Guardar en memoria operativa solo informacion util, breve y no sensible.
- Promocionar a Obsidian lo que se convierta en decision, patron, procedimiento o fuente estable.
- Mantener opt-in por proyecto: ningun proyecto deberia sincronizarse sin decision explicita.
- Evitar almacenar datos personales, pacientes, credenciales, secretos, capturas clinicas o informacion interna no necesaria.
- Registrar fecha, fuente y responsable cuando una memoria afecte a seguridad, calidad, mantenimiento, compra, legalidad o asistencia.

## Modelo recomendado para la boveda

| Capa | Papel | Ejemplos | Riesgo |
| --- | --- | --- | --- |
| `AGENTS.md` | Contrato de comportamiento | Reglas de privacidad, flujos de ingesta, criterios sanitarios | Bajo si se revisa |
| Obsidian curado | Memoria canonica | Conceptos, fuentes, analisis, procesos, decisiones | Bajo-medio |
| Contexto de proyecto | Estado vivo | `estado_continuidad.md`, specs, colas de triaje | Medio |
| Memoria tipo Engram | Memoria operativa del agente | Preferencias, decisiones recientes, descubrimientos tecnicos | Medio-alto si no se filtra |
| MCP propio | Acceso estructurado a datos | Inventario, manuales, preventivos, incidencias | Alto en ambito sanitario |

## Fuentes y relaciones

- Fuentes:
  - [[2026-06-27-engram-cloud-contexto-compartido-agentes]]
  - `raw/sources/llm-wiki.md`
- Conceptos relacionados:
  - `32 - programacion/MCP propio.md`
  - `32 - programacion/Context7.md`
  - `32 - programacion/Multiagentes.md`
- Proyectos relacionados:
  - `30 - Proyectos/Qontrolmed/`
