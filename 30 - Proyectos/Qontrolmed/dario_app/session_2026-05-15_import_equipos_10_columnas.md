---
tags:
  - app
  - codigo
  - desarrollo
  - diario
Relacionado:
Creado: 2026-05-15
---

# Sesion 2026-05-15: contrato de equipos con 10 columnas
[[masgesth_port]]
## Problema

Durante una prueba con JSON real, la importacion fallo porque `equipos` llegaba con 10 columnas y el importador esperaba 11.

La guia de import/export define `equipos` con estos campos:

- `id`
- `numero_gmao`
- `inventario`
- `modelo`
- `marca`
- `numero_serie`
- `ubicacion`
- `descripcion_gmao`
- `tecnico_gmao`
- `id_tipo_equipo`

El campo `fecha_importacion` existe en SQLite, pero no forma parte del contrato actual del exportador.

## Solucion

- `ImportService` acepta ahora `equipos` con 10 o 11 columnas.
- Si vienen 10 columnas, se rellena `fecha_importacion` con la fecha/hora local de la importacion.
- Se mantiene compatibilidad con JSON antiguos o de prueba que ya incluyan `fecha_importacion`.
- `test_import.py` se actualizo para usar equipos de 10 columnas, reproduciendo mejor el JSON real.

## Verificacion prevista

```powershell
python test_import.py
python test_report_service.py
python -m py_compile src\services\import_service.py test_import.py test_report_service.py
```
