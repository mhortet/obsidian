---
title: "Inventario agregado de maestros de Preventivos P2L"
type: evidence
status: completed
created: 2026-11-15
updated: 2026-11-15
sources:
  - "../02_planes_y_arquitectura/PLAN-EJECUCION-P2L-INVENTARIO-MAESTROS-PREVENTIVOS-2026-11-15.md"
tags: [qontrolmed, p2l, preventivos, maestros, evidencia]
---

# Inventario agregado de maestros de Preventivos P2L

## Alcance y método

Consulta de solo lectura ejecutada en MySQL Workbench sobre la instancia local.
La evidencia contiene únicamente recuentos; no incluye filas, valores de
maestros, credenciales ni datos identificativos.

## Maestros que deben conservarse

| Tabla | Filas |
|---|---:|
| `tipos_equipo` | 8 |
| `plantillas_preventivo` | 7 |
| `puntos_control` | 390 |
| `plantilla_puntos` | 160 |

## Histórico que no debe migrarse

| Tabla operativa | Filas |
|---|---:|
| `equipos_gmao` | 144 |
| `campanas_preventivo` | 1 |
| `campana_equipos_preventivo` | 144 |
| `informes_preventivo` | 12 |
| `resultados_preventivo` | 396 |
| `informe_equipos_medida` | 7 |

## Comprobaciones de integridad

| Comprobación | Incidencias |
|---|---:|
| Plantillas sin tipo de equipo | 0 |
| Relaciones sin plantilla | 0 |
| Relaciones sin punto | 0 |
| Códigos de punto duplicados | 0 |
| Relaciones plantilla-punto duplicadas | 0 |

## Conclusión y límite

El inventario permite preparar la exportación revisable de los cuatro
maestros. No demuestra todavía que cada descripción, límite o asociación sea
funcionalmente correcta; esa revisión corresponde al siguiente bloque. Las
tablas operativas se excluirán por contener revisiones y actividad histórica.
