---
title: "Checklist de calidad documental"
type: process
status: active
created: 2026-06-27
updated: 2026-06-27
sources: []
tags: [sistema, calidad, mantenimiento]
review_after: 2026-09-27
---

# Checklist de calidad documental

## Para una fuente

- La fuente original esta en `raw/sources/` o se indica claramente su procedencia.
- La ficha resume sin inventar.
- Se distingue entre dato de la fuente e interpretacion propia.
- Se enlazan conceptos, entidades, proyectos o sintesis relacionados.
- Se marca `review_after` si el contenido puede caducar.

## Para una nota sanitaria

- No contiene datos personales innecesarios.
- No contiene identificadores de pacientes.
- No contiene credenciales ni secretos.
- Distingue experiencia local, criterio tecnico y procedimiento formal.
- Incluye fecha y fuente cuando afecta a seguridad, calidad, compras, mantenimiento o asistencia.

## Para un proyecto

- Existe una nota de continuidad o estado vivo.
- Las decisiones importantes estan fechadas.
- El historico no compite con la fuente de verdad actual.
- Los documentos obsoletos estan marcados como historicos, redirigidos o archivados.

## Para mantenimiento

- Ejecutar `python "00 - Sistema/tools/obsidian_lint.py"`.
- Revisar capturas acumuladas en `10 - In box/` y `raw/sources/`.
- Buscar notas `needs-review`.
- Revisar enlaces rotos o duplicados evidentes.
- Actualizar `00 - Sistema/Indice.md` y `00 - Sistema/log.md` si cambia la estructura.

