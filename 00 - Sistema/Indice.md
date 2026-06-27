---
title: "Indice operativo"
type: register
status: active
created: 2026-06-27
updated: 2026-06-27
sources: []
tags: [sistema, indice, gobierno]
review_after: 2026-09-27
---

# Indice operativo

Este es el mapa de entrada de la boveda. No sustituye a las carpetas historicas; sirve para orientar consultas, ingestas y mantenimiento.

## Sistema

- [AGENTS.md](../AGENTS.md): reglas de trabajo para agentes y sesiones asistidas.
- [log.md](log.md): cronologia append-only de cambios de metodo, ingestas y mantenimiento.
- [meta/modelo-operativo.md](meta/modelo-operativo.md): cadencia y definicion de terminado.
- [meta/taxonomia.md](meta/taxonomia.md): tipos de nota, estados y dominios.
- [meta/checklist-calidad.md](meta/checklist-calidad.md): control de calidad documental.
- [meta/registro-fuentes.csv](meta/registro-fuentes.csv): registro tabular de fuentes procesadas.
- [tools/obsidian_lint.py](tools/obsidian_lint.py): validacion suave de la capa curada.

## Capa curada

- [20 - Notas enlazadas/Fuentes](../20 - Notas enlazadas/Fuentes/README.md): fichas de fuentes capturadas o importadas.
- [20 - Notas enlazadas/Conceptos](../20 - Notas enlazadas/Conceptos/README.md): ideas reutilizables.
- [20 - Notas enlazadas/Entidades](../20 - Notas enlazadas/Entidades/README.md): proveedores, herramientas, equipos, organizaciones, sistemas o personas.
- [20 - Notas enlazadas/Sintesis](../20 - Notas enlazadas/Sintesis/README.md): vistas transversales.
- [20 - Notas enlazadas/Analisis](../20 - Notas enlazadas/Analisis/README.md): respuestas o estudios archivados.
- [20 - Notas enlazadas/Procesos](../20 - Notas enlazadas/Procesos/ingesta-de-fuentes.md): procedimientos de trabajo de la boveda.

## Carpetas existentes

- [10 - In box](../10 - In box/): entrada rapida sin procesar.
- [15 - Notas diarias](../15 - Notas diarias/): registro cronologico.
- [20 - Notas enlazadas](../20 - Notas enlazadas/): notas atomicas, vivas y capa curada.
- [30 - Proyectos](../30 - Proyectos/): proyectos y entregables.
- [32 - programacion](../32 - programación/): aprendizaje y patrones de desarrollo.
- [35 - git-github](../35 - git-github/): operativa de Git y GitHub.
- [37 - Sofware](../37 - Sofware/): herramientas y software.
- [40 - Hospital](../40 - Hospital/): area hospitalaria y tecnico-sanitaria.
- [45 - coches electricos](../45 - coches eléctricos/): movilidad electrica.
- [50 - Recursos](../50 - Recursos/): plantillas, adjuntos y esquemas.
- [55 - Ayuntamiento](../55 - Ayuntamiento/): tramites y documentacion municipal.
- [raw](../raw/README.md): fuentes crudas y capturas originales.

## Prioridad de implantacion

1. Usar `raw/sources/` como destino del Web Clipper para fuentes documentales.
2. Crear fichas en `Fuentes` solo para material que merezca ser reutilizado.
3. Crear conceptos y sintesis cuando haya aprendizaje transversal.
4. Aplicar trazabilidad reforzada en `40 - Hospital/` y proyectos sanitarios.
5. Migrar notas antiguas solo cuando se consulten o se reutilicen.
