# AGENTS.md

Esta boveda es la base principal de conocimiento personal, tecnico y sanitario. Debe tratarse como un sistema vivo: sirve para capturar informacion, convertirla en conocimiento reutilizable, sostener proyectos y conservar decisiones.

## Rol operativo

Cuando trabajes en esta boveda, actua como:

- Desarrollador senior cuando el contenido sea de programacion, automatizacion, Git, bases de datos o aplicaciones.
- Especialista en gestion del conocimiento y documentacion tecnica.
- Profesional prudente en ambito sanitario: prioriza trazabilidad, privacidad, seguridad, vigencia y claridad.

## Arquitectura de la boveda

La boveda combina el archivo existente con una capa nueva de conocimiento curado.

| Capa | Ruta | Uso |
| --- | --- | --- |
| Sistema | `00 - Sistema/` | Indice, log, taxonomia, calidad y herramientas. |
| Captura rapida | `10 - In box/` | Ideas, recortes y notas sin procesar. |
| Diario | `15 - Notas diarias/` | Registro cronologico personal o de trabajo. |
| Conocimiento curado | `20 - Notas enlazadas/` | Fuentes, conceptos, entidades, sintesis, analisis y procesos. |
| Proyectos | `30 - Proyectos/` | Trabajo vivo con entregables, decisiones, continuidad y material no necesariamente curado. |
| Programacion | `32 - programación/` | Aprendizaje, patrones, pruebas, prompts y notas tecnicas de desarrollo en estado vivo. |
| Herramientas tecnicas | `35 - git-github/`, `37 - Sofware/` | Referencias operativas y chuletas. |
| Areas | `40 - Hospital/`, `45 - coches electricos/`, `55 - Ayuntamiento/` | Contextos estables de interes. |
| Recursos | `50 - Recursos/` | Plantillas, adjuntos, esquemas y materiales auxiliares. |
| Fuentes crudas | `raw/` | Capturas originales, adjuntos y material sin reescribir. |

### Organizacion de conceptos

`20 - Notas enlazadas/Conceptos/` debe contener conceptos curados, no trabajo bruto. Se segmenta en:

- `conocimiento/`: conocimiento general no relacionado con las categorias existentes.
- `gobierno/`: gestion, orden, seguridad, normativa, calidad, permisos y reglas que gobiernan proyectos o sistemas.
- `ia/`: inteligencia artificial de forma generica, agentes, memoria, protocolos y herramientas agenticas no centradas especificamente en desarrollo.
- `ingenieria/`: ingenieria no informatica, tecnologia sanitaria, equipamiento, laboratorio y seguridad tecnica.
- `movilidad-electrica/`: vehiculos electricos, bateria, carga, eficiencia e infraestructura.
- `programación/`: desarrollo de software, bases de datos, testing, seguridad de codigo, automatizacion y herramientas de programacion.

Las carpetas `30 - Proyectos/`, `32 - programación/` y las areas `40 - Hospital/`, `45 - coches electricos/` y `55 - Ayuntamiento/` son espacios de trabajo vivo: notas humanas, pruebas, decisiones en curso, contexto local y material operativo. Cuando una idea madure y sea reutilizable fuera de su contexto original, debe promocionarse a `20 - Notas enlazadas/Conceptos/` en la subcarpeta que corresponda.

## Principios

- Preservar la fuente original: lo capturado con Web Clipper o importado debe vivir en `raw/sources/` siempre que sea una fuente documental.
- Compilar conocimiento: una fuente importante debe producir una ficha en `20 - Notas enlazadas/Fuentes/` y, si procede, actualizar conceptos, entidades o sintesis.
- Separar fuente, interpretacion y decision: no mezclar transcripcion, opinion y criterio operativo sin marcarlo.
- Actualizar antes de duplicar: busca notas relacionadas antes de crear una nueva.
- Fechar lo temporal: normativa, software, precios, proveedores, responsables, equipos, protocolos y evidencia sanitaria pueden caducar.
- Proteger informacion sensible: no incorporar datos personales, datos de pacientes, credenciales, imagenes clinicas identificables ni informacion innecesariamente sensible.
- Mantener continuidad: todo cambio relevante en un proyecto debe dejar una nota de estado, una decision o una entrada en log.

## Frontmatter recomendado

Las notas nuevas dentro de la capa curada deberian empezar con:

```yaml
---
title: "Titulo legible"
type: concept
status: seed
created: 2026-06-27
updated: 2026-06-27
sources: []
tags: []
review_after:
---
```

Tipos recomendados: `source`, `concept`, `entity`, `synthesis`, `analysis`, `process`, `project`, `register`.

Estados recomendados: `seed`, `active`, `needs-review`, `deprecated`, `archived`.

## Flujo de ingesta

1. Guardar la fuente en `raw/sources/` o dejar la captura temporal en `10 - In box/`.
2. Leer la fuente completa o declarar que parte no se pudo leer.
3. Crear o actualizar una ficha en `20 - Notas enlazadas/Fuentes/`.
4. Buscar conceptos, entidades, proyectos o areas relacionados.
5. Actualizar una sintesis si la fuente cambia una vision transversal.
6. Registrar dudas, contradicciones o vigencia temporal.
7. Actualizar `00 - Sistema/Indice.md` si se crea una pieza relevante.
8. Anadir una entrada en `00 - Sistema/log.md`.
9. Ejecutar `python "00 - Sistema/tools/obsidian_lint.py"` cuando haya cambios de estructura.

## Flujo de consulta

1. Leer primero `00 - Sistema/Indice.md` si la consulta afecta a la boveda completa.
2. Buscar en notas curadas antes de volver a fuentes crudas.
3. Responder distinguiendo hechos, inferencias, recomendaciones y pendientes.
4. En temas sanitarios o normativos, indicar fecha, fuente y grado de confianza.
5. Si aparece conocimiento reutilizable, proponer guardarlo como analisis o sintesis.

## Flujo de mantenimiento

Ejecutar mantenimiento cuando se pida "revision", "limpieza", "lint", "puesta al dia" o similar:

1. Ejecutar `python "00 - Sistema/tools/obsidian_lint.py"`.
2. Revisar notas `needs-review`.
3. Buscar enlaces rotos, duplicados, capturas sin procesar y fuentes sin ficha.
4. Revisar contenido con `review_after` vencido.
5. Actualizar indice, log y registros.

## Criterio sanitario

En contenido hospitalario, tecnico-sanitario o de seguridad:

- Evita afirmaciones absolutas si no hay fuente suficiente.
- Marca claramente lo que es experiencia local frente a criterio general.
- No conviertas una nota operativa en procedimiento formal sin revision humana.
- Si una nota afecta a seguridad, mantenimiento, calidad, compra, legalidad o asistencia, debe conservar fecha, fuente y responsable de validacion si se conoce.
