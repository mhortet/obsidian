---
title: "Taxonomia"
type: register
status: active
created: 2026-06-27
updated: 2026-07-18
sources: []
tags: [sistema]
review_after: 2026-09-27
---

# Taxonomia

## Tipos de nota

- `source`: resumen fiel de una fuente concreta.
- `concept`: idea reutilizable y estable.
- `entity`: persona, organizacion, proveedor, herramienta, sistema, equipo o proyecto.
- `synthesis`: vision transversal que integra varias fuentes o notas.
- `analysis`: respuesta o investigacion archivada a partir de una pregunta.
- `process`: flujo de trabajo o procedimiento interno.
- `project`: nota de continuidad o gobierno de un proyecto.
- `register`: indice, inventario, decisionario o lista controlada.

## Estados

- `seed`: nota inicial, todavia incompleta.
- `active`: util y vigente.
- `needs-review`: requiere revision por caducidad, duda o cambio externo.
- `deprecated`: superada por otra nota.
- `archived`: conservada por historico.

## Dominios iniciales

- `sanidad`: hospital, equipos, procedimientos, calidad, seguridad, compras sanitarias.
- `programacion`: desarrollo, arquitectura, herramientas, Git, bases de datos.
- `proyectos`: Qontrolmed y otros trabajos vivos.
- `ia`: agentes, prompts, modelos, automatizacion, MCP, Codex.
- `humanidades`: filosofia, etica, cultura, educacion, politica, sentido del trabajo y condicion humana.
- `movilidad-electrica`: coche electrico, carga, autonomia, viajes.
- `administracion`: ayuntamiento, tramites y documentacion administrativa.
- `conocimiento`: Obsidian, LLM Wiki, metodo personal, pedagogia.

## Regla practica

La carpeta no es la verdad completa. La carpeta ayuda a encontrar, pero el valor real esta en:

- buenas fuentes,
- notas curadas,
- enlaces entre piezas,
- sintesis transversales,
- decisiones fechadas.

## Gobierno de tags

Los tags son un vocabulario controlado, no palabras clave libres. Su fuente de verdad es `00 - Sistema/meta/tags-controlados.json`.

Reglas:

- Usar como máximo cinco tags por nota.
- Usar como máximo dos tags de dominio.
- Escribir en minúsculas, sin acentos, con palabras separadas por guion.
- No usar singular y plural como tags distintos.
- No repetir `type`, `status`, la carpeta o el formato como tag (`concepto`, `fuente`, `proyecto`, `pendiente`, etc.).
- Priorizar tags reutilizables y transversales. Un término específico que solo identifica una herramienta, equipo, persona o marca debe resolverse mediante título, enlace o entidad.
- No inventar un tag nuevo durante una ingesta. Si el vocabulario no cubre una necesidad estable, justificar su incorporación en la política y registrar el cambio.
- `app` es un alias histórico de `qontrolmed`; no debe reutilizarse con sentido genérico.
- `raw/` queda fuera de la normalización para preservar las capturas originales.

Herramientas:

- `python "00 - Sistema/tools/obsidian_tags.py" report`: inventario y frecuencias.
- `python "00 - Sistema/tools/obsidian_tags.py" check`: valida vocabulario, aliases y límites.
- `python "00 - Sistema/tools/obsidian_tags.py" normalize`: vista previa conservadora.
- `python "00 - Sistema/tools/obsidian_tags.py" normalize --apply --audit "ruta.csv"`: normaliza frontmatter y registra cada cambio.
- `python "00 - Sistema/tools/obsidian_lint.py"`: incluye la validación de tags en el mantenimiento general.
