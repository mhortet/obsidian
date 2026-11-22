---
title: "Reorganización documental y preparación de entrega al cliente"
type: register
status: active
created: 2026-11-21
updated: 2026-11-21
sources:
  - "../../DOCUMENTACION-SERVIDOR-UBUNTU.md"
  - "../../08_entrega_cliente/README.md"
tags: [documentacion, administracion, gobierno]
review_after:
---

# Sesión del 21 de noviembre de 2026

## Objetivo

Preparar una documentación comprensible para el cliente y una consulta interna consolidada, sin borrar fuentes ni anticipar datos de sede.

## Cambios

- Creada `08_entrega_cliente/` con manual del sistema, guías de Qontrolmed y SFTPGo, administración de usuarios, mantenimiento, copias, incidencias, inventario y acta.
- Creados registros maestros de decisiones y planes.
- Creados estado actual y cronología maestra.
- Reescrito `README.md` como mapa vigente, retirando la acumulación de estados superados.
- Actualizado `DOCUMENTACION-SERVIDOR-UBUNTU.md` a versión 2.1 como memoria técnica interna.
- Corregidas contradicciones de MySQL/Qontrolmed y la colisión histórica de versión 1.8.

## Límites

- No se movió ni eliminó ningún documento, evidencia, imagen, script o duplicado.
- No se conectó al servidor ni se modificó ningún servicio.
- Red, túnel, identidades, responsables, copias y aceptación quedan pendientes de observación en sede.

## Validación

- Enlaces relativos de los documentos nuevos: correctos.
- `obsidian_lint.py`: cero errores; conserva avisos históricos de la bóveda.
- `obsidian_tags.py check`: sin avisos nuevos atribuibles a esta reorganización; conserva avisos históricos.
- `git diff --check`: ejecutar de nuevo tras el ajuste final de espacios.

## Continuidad

En sede, completar los campos `PENDIENTE` únicamente con valores observados o confirmados y convertir las guías `seed` en procedimientos aceptados después de probar sus flujos.
