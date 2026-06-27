---
title: "Log"
type: register
status: active
created: 2026-06-27
updated: 2026-06-27
sources: []
tags: [sistema, log]
review_after:
---

# Log

Entradas append-only. Formato recomendado:

```markdown
### [YYYY-MM-DD] tipo | Titulo
```

Tipos recomendados: `bootstrap`, `ingest`, `query`, `lint`, `decision`, `maintenance`.

## [2026-06-27] bootstrap | Capa de buenas practicas sobre la boveda principal

- Se incorpora una capa operativa sin mover ni renombrar notas existentes.
- Se crea `AGENTS.md` como contrato de trabajo para sesiones asistidas.
- Se crea `00 - Sistema/` con indice, log, metadatos, taxonomia, checklist y herramientas.
- Se preparan subcarpetas curadas dentro de `20 - Notas enlazadas/`.
- Se anaden plantillas para fuentes, conceptos, entidades, sintesis y analisis.
- Se deja `raw/` como destino recomendado para fuentes crudas y Web Clipper.
