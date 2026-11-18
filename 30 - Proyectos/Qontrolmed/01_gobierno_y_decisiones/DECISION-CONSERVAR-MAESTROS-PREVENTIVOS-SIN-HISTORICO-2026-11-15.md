---
title: "Decisión: conservar maestros de Preventivos sin actividad histórica"
type: decision
status: approved
created: 2026-11-15
updated: 2026-11-15
sources:
  - "Aclaración expresa del propietario de 2026-11-15"
  - "DECISION-IMPLANTACION-DESDE-CERO-Y-DATOS-PRUEBA-2026-11-13.md"
tags: [qontrolmed, preventivos, maestros, greenfield, datos]
review_after: 2026-12-15
---

# Decisión: conservar maestros de Preventivos sin actividad histórica

## Corrección de alcance

«Implantación desde cero» significa que la base definitiva no hereda revisiones
realizadas ni actividad de prueba. No significa descartar los maestros de
Preventivos que el propietario preparó durante el desarrollo.

Se conservarán, tras revisión e importación controlada:

- `preventivos.tipos_equipo`;
- `preventivos.plantillas_preventivo`;
- `preventivos.puntos_control`;
- `preventivos.plantilla_puntos`.

Comenzarán vacías las tablas operativas:

- `equipos_gmao`;
- `campanas_preventivo`;
- `campana_equipos_preventivo`;
- `informes_preventivo`;
- `resultados_preventivo`;
- `informe_equipos_medida`.

## Modelo funcional

Los maestros importados son un punto de partida, no un catálogo inmutable. Los
usuarios autorizados podrán crear, modificar o desactivar tipologías,
plantillas, puntos y relaciones desde las pantallas previstas por Qontrolmed.

## Método de traslado

1. Inventario de solo lectura de la base local.
2. Validación de estructura, recuentos, duplicados y referencias.
3. Exportación revisable de las cuatro tablas, preferentemente en un libro con
   cuatro hojas y claves estables.
4. Revisión del propietario.
5. Importación transaccional en una base nueva, con precheck, postcheck y
   reversión.
6. Confirmación de que las seis tablas operativas permanecen vacías.

No se utilizará el exportador de campañas/tablet para este traslado porque
mezcla equipos y datos de trabajo y puede actualizar seguimiento operativo.

## Seguridad y límites

- No se exportan usuarios, pacientes, equipos, campañas, informes ni medidas.
- No se imprimen credenciales ni contenido de `.env`.
- La base de origen no se modifica.
- La importación no se ejecuta hasta aprobar el contenido y el destino exacto.

## Relación con decisiones anteriores

Esta decisión aclara y prevalece sobre cualquier interpretación de
`DECISION-IMPLANTACION-DESDE-CERO-Y-DATOS-PRUEBA-2026-11-13.md` que tratase
los maestros de Preventivos como datos de prueba descartables. Se mantiene la
exclusión de toda actividad e histórico de prueba.
