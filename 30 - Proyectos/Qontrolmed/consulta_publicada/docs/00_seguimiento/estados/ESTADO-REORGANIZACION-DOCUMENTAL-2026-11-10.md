---
title: "Estado de la reorganización documental"
type: state
status: active
created: 2026-11-10
updated: 2026-11-11
sources:
  - "docs/02_planes_y_arquitectura/PLAN-ADAPTACION-DOCUMENTAL-MAXGESTH-AL-MODELO-SERVIDOR-2026-11-10.md"
tags: [qontrolmed, documentacion, estructura]
review_after: 2026-11-17
---

# Estado de la reorganización documental

## Resultado

La documentación se ha reclasificado por función y los dos históricos
anteriores se han reunido bajo `docs/90_archivo/`. La raíz incorpora reglas,
mapa y relevo. Los cambios documentales locales previos quedaron conservados e
integrados en el backlog y en el archivo.

## Alcance aplicado

- seguimiento, estados, diario y backlog;
- gobierno y decisiones;
- planes, arquitectura y especificaciones;
- operación y runbooks;
- guías didácticas;
- evidencias depuradas;
- archivo histórico con procedencia.

## Limpieza física

Con confirmación expresa del propietario se eliminaron aproximadamente
3,26 GiB de material no fuente: builds y distribuciones, `_internal/`, exports,
certificados locales, binarios legados de `wkhtmltopdf` y caches. Los últimos
256,13 MiB requerían una consola elevada por las ACL aplicadas durante pruebas
históricas de instalación. La limpieza física quedó completada y
`compartido/.env` se preservó sin inspeccionarlo.

## Revalidación no destructiva de 11 de noviembre de 2026

- Base confirmada: `014bf7c7b3c80c514786c36d1135efe00202b7a0` en
  `codex/estructura-documental-20261110`.
- El índice contenía 1.966 cambios: 11 altas, 3 modificaciones, 1.860
  eliminaciones y 92 renombres; no había cambios adicionales sin preparar.
- `git diff --check` y `git diff --cached --check` terminaron sin errores.
- Antes de añadir la documentación didáctica, el índice contenía 288 rutas y no
  conservaba rutas bajo `_internal/`, `build/`, `dist/`, `build_rc/`, `dist_rc/`
  u `output/`.
- Tras integrarla, el estado final contiene 1.970 ficheros cambiados frente a
  `HEAD`: 15 altas, 3 modificaciones, 1.862 eliminaciones y 90 renombres; el
  índice resultante tiene 290 rutas y sigue sin rutas bajo esos patrones. La
  variación en renombres se debe a la detección heurística de Git al ampliar dos
  documentos movidos.
- La comprobación final de enlaces Markdown relativos sobre 52 documentos
  activos revisó 7 enlaces y no encontró destinos ausentes.
- `python -m unittest discover -s tests -v` ejecutó 24 pruebas con resultado
  `OK`.

Esta validación permite cerrar la revisión estructural, pero no cambia el estado
`NO-GO` ni acredita producción, servidor, MySQL, TLS, CA o datos reales. El
detalle formativo está en
`docs/00_seguimiento/diario/2026-11-11-revision-estructural-y-trazabilidad-didactica.md`.
