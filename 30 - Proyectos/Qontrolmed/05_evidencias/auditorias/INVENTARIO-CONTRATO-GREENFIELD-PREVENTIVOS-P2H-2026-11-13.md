---
title: "Inventario del contrato greenfield de Preventivos P2H"
type: evidence
status: active
created: 2026-11-13
updated: 2026-11-13
sources:
  - "src/preventivos/"
  - "bd/migraciones/migracion_campanas_preventivo.sql"
  - "bd/migraciones/migracion_tablet_tracking_preventivos.sql"
  - "D:/trabajo/Proyectos/maxgesth_port/src/"
tags: [qontrolmed, p2, preventivos, mysql, json, tablet]
review_after: 2026-11-20
---

# Inventario del contrato greenfield de Preventivos P2H

## Conclusión

Preventivos forma parte del piloto, pero carece de una estructura MySQL base
completa en `bd/base/`. El código de escritorio, las dos migraciones y el
contrato móvil permiten definir el objetivo, pero el SQL debe construirse y
validarse explícitamente; no debe copiarse sin más el esquema SQLite.

## Tablas propias esperadas

| Tabla | Función | Relaciones principales |
| --- | --- | --- |
| `tipos_equipo` | tipologías de equipos | padre de plantillas y equipos |
| `plantillas_preventivo` | plantillas por tipología | `id_tipo_equipo` |
| `puntos_control` | catálogo de controles | usado mediante `plantilla_puntos` |
| `plantilla_puntos` | relación y orden plantilla-punto | plantilla y punto |
| `equipos_gmao` | maestro importado desde GMAO | tipología y centro (`id_ceco`) |
| `campanas_preventivo` | ciclo mensual/anual | padre de relación e informes |
| `campana_equipos_preventivo` | pertenencia y tracking tablet | campaña y equipo |
| `informes_preventivo` | cabecera operativa | equipo, plantilla, campaña y técnico |
| `resultados_preventivo` | resultados por punto | informe y punto |
| `informe_equipos_medida` | equipos de medida usados | informe y equipo de Quirófanos |

La estructura inicial debe incorporar directamente campañas y las columnas
`exportado_tablet`, `fecha_exportado_tablet`, `descargado_tablet` y
`fecha_descargado_tablet`; las dos migraciones históricas no deben ejecutarse
sobre una base nueva si el esquema final ya las contiene.

## Dependencias entre esquemas

- `gestion.usuarios`: técnicos exportables, autoría y cierre de informes;
- `gestion.cecos`: centro asociado al equipo mediante `id_ceco`;
- `quirofanos.equipos_medida`: catálogo compartido de instrumentos y
  certificados usado por `informe_equipos_medida`.

Las dependencias funcionales no implican necesariamente claves foráneas entre
esquemas. Esa decisión se tomará al diseñar el SQL base considerando orden de
restauración, mínimo privilegio y posibilidad de operar módulos por separado.

## Contrato JSON Preventivos: escritorio → tablet

El paquete maestro actual contiene:

- metadatos: `exported_at`, `version`, `campana`, `tecnico_asignado` y filtro;
- `equipos`;
- `tipos_equipo`;
- `plantillas_preventivo`;
- `puntos_control`, incluyendo `id_plantilla`;
- `usuarios`.

Son sensibles `id_campana`, los identificadores de equipo/plantilla/punto, el
orden de las filas posicionales, la tipología y la versión. La tablet protege
trabajo local y no mezcla silenciosamente un paquete nuevo con otro ciclo.

## Contrato JSON Preventivos: tablet → escritorio

La tablet devuelve informes y resultados. La versión observada es `1.1` y
declara `informe_observaciones` y `cuantitativo_na`. El importador de escritorio:

- valida JSON antes de escribir;
- resuelve campaña, equipo, plantilla, técnico y punto;
- escribe cabecera y detalle dentro de una transacción;
- permite `keep`, `replace` o cancelación ante conflicto;
- deja el informe importado abierto para revisión en sobremesa;
- marca tracking de descarga cuando las columnas existen.

`cerrado_tablet` no equivale a cierre definitivo en escritorio.

## Contrato móvil de Quirófanos

Quirófanos usa un contrato distinto, versionado como
`maxgestq_mov.quirofanos.v1`, con filas JSON nombradas para `hospitales`,
`quirofanos`, `puntos_control`, `quirofano_puntos_control`, `equipos_medida`,
`informes` y `resultado_puntos`. Esta confirmación refuerza que ambos módulos
deben incluirse en la validación greenfield, aunque sus formatos no se unifiquen
artificialmente.

## Decisiones ya resueltas

- implantación desde cero, sin migrar datos de desarrollo;
- JSON offline como canal operativo vigente, sin API en esta fase;
- conflictos de Preventivos decididos por el usuario en cada importación;
- cierre móvil sujeto a revisión/cierre posterior en escritorio;
- los repositorios móviles no se modifican en P2H.

## Pendientes técnicos, no funcionales

1. fijar tipos, longitudes, claves, índices y valores por defecto MySQL;
2. decidir dónde usar claves foráneas entre esquemas y dónde validación lógica;
3. crear `bd/base/preventivos_*.sql` sin `DROP TABLE` para instalación inicial;
4. añadir pruebas que comparen columnas exportadas/importadas con el contrato;
5. declarar una línea base de Preventivos en el ledger;
6. extender el guard de runtime a los tres esquemas.
