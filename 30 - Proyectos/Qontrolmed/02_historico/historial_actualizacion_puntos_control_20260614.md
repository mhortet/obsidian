---
tags:
  - app
  - estructura
Creado:
Autor:
Relacionado:
---
## Resumen

## Descripción


# Historial de actualización de `puntos_control`

Fecha: 2026-06-14

## Objetivo

Se ha realizado una normalización del catálogo de puntos de control a partir de las plantillas Excel con hoja `Castellano 62353`, con el fin de:

- evitar duplicados funcionales en la tabla `puntos_control`
- consolidar controles reutilizables entre distintos equipos
- adaptar la nomenclatura de `tipo_validacion` a la utilizada realmente por la aplicación y la base de datos
- unificar la codificación de referencias al esquema `ITP_Qxxx`, `ITP_Cxxx` e `ITP_Sxxx`

## Alcance del trabajo

Se revisaron las plantillas Excel de la carpeta de trabajo y se extrajeron exclusivamente los puntos de:

- `Revisión cuantitativa`
- `Revisión cualitativa`
- `Revisión manual` si existiese

No se incluyó la seguridad eléctrica en el catálogo nuevo extraído desde las hojas `Castellano 62353`, aunque sí se contempló posteriormente en la normalización de códigos ya existentes dentro de la tabla.

## Criterios aplicados

### 1. Deduplicación funcional

Los puntos se consolidaron por control real y no por equipo origen. Esto evita multiplicar entradas equivalentes como:

- limpieza
- revisión de estado estructural
- verificación de carcasa o estado físico
- comprobaciones repetidas entre diferentes equipos

### 2. Nueva codificación

Para el catálogo consolidado nuevo se generaron referencias secuenciales:

- `ITP_Q001...` para puntos cuantitativos
- `ITP_C001...` para puntos cualitativos

Posteriormente se preparó también la renumeración de los códigos antiguos ya existentes en tabla a la serie:

- `ITP_Qxxx`
- `ITP_Cxxx`
- `ITP_Sxxx`

### 3. Alineación de `tipo_validacion`

Tras contrastar el catálogo generado con la exportación real de base de datos (`revisar.csv`), se ajustó la nomenclatura para mantener coherencia con la lógica de la aplicación:

- `MARGEN` pasa a `RANGO`
- `UMBRAL` pasa a `RANGO`
- `OBJETIVO_RANGO` pasa a `RANGO_VARIABLE`
- `OBJETIVO_MARGEN` pasa a `RANGO_VARIABLE`

Se mantuvieron sin cambios:

- `CHECKLIST`
- `LECTURA`
- `TABLA`
- `ESPECIFICACION`

## Ficheros generados

### Catálogo nuevo consolidado

- `catalogo_62353_mysql.csv`
- `catalogo_62353_mysql.sql`

### Scripts de soporte y ajuste

- `extract_62353_catalog.py`
- `ajuste_tipo_validacion_itp.sql`
- `normalizar_puntos_control_desde_revisar.sql`
- `renombrado_codigos_preview.csv`

## Resultado del catálogo nuevo

El catálogo consolidado generado desde las hojas `Castellano 62353` quedó en:

- 42 puntos `CUANTITATIVO`
- 107 puntos `CUALITATIVO`
- 0 puntos detectados como `Revisión manual`

Distribución final de `tipo_validacion` en el catálogo nuevo:

- `CHECKLIST`: 107
- `RANGO`: 19
- `RANGO_VARIABLE`: 13
- `LECTURA`: 4
- `TABLA`: 4
- `ESPECIFICACION`: 2

## Normalización sobre la tabla existente

A partir del fichero `revisar.csv`, exportado desde la tabla `puntos_control`, se preparó un script de normalización completo para aplicar sobre la base de datos actual.

Ese script:

1. actualiza la nomenclatura de `tipo_validacion`
2. renombra códigos antiguos al esquema `ITP_...`
3. no modifica los registros que ya estaban correctamente codificados como `ITP_...`

## Alcance del renombrado de códigos existentes

Renombrados preparados a partir de `revisar.csv`:

- 79 registros `CUANTITATIVO`
- 154 registros `CUALITATIVO`
- 8 registros `SEGURIDAD`

Total de renombrados previstos:

- 241 registros

## Seguridad operativa

Antes de la normalización se confirmó que existe backup de la tabla, por lo que la operación es reversible si apareciese cualquier efecto no previsto en la aplicación.

El SQL de normalización fue generado tomando como referencia el estado exportado en `revisar.csv`, por lo que debe aplicarse sobre una situación equivalente de la tabla `puntos_control`.

## Resumen final

Se ha dejado preparado un proceso coherente para sanear el catálogo de puntos de control de la aplicación:

- se consolidó un catálogo maestro sin duplicados evidentes
- se unificó la codificación nueva bajo la serie `ITP_Q` e `ITP_C`
- se adaptó `tipo_validacion` a la nomenclatura real usada por la aplicación
- se preparó un SQL para migrar los códigos antiguos de la tabla existente a `ITP_Q`, `ITP_C` e `ITP_S`
- se dejó una previsualización del renombrado y backup previo para poder aplicar los cambios con seguridad

Estado final del trabajo:

- catálogo nuevo generado
- SQL de importación generado
- SQL de normalización de tabla existente generado
- documentación de soporte generada
