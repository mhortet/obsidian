---
tags:
  - app
  - codigo
  - desarrollo
  - diario
Relacionado:
Creado: 2026-05-15
---

# Sesion 2026-05-15: puntos_control con 16 columnas
[[masgesth_port]]
## Problema

Durante la importacion de JSON real, `puntos_control` llego con 16 columnas y el importador esperaba 17.

Al revisar el exportador origen en `maxgesth/src/preventivos/services/export_preventivos_service.py`, la consulta exporta:

- datos del punto de control (`pc.*` relevantes)
- `valor_objetivo`
- `margen`

Pero no exporta `pp.id_plantilla`, que es necesario para relacionar cada punto con su plantilla en SQLite.

## Decision

No se debe inventar `id_plantilla` cuando hay varias plantillas, porque se perderia integridad funcional: los puntos podrian quedar asociados a una plantilla incorrecta.

El importador ahora:

- acepta `puntos_control` con 16 o 17 columnas;
- si hay 16 columnas y una sola plantilla, deduce `id_plantilla` de forma segura;
- si hay 16 columnas y varias plantillas, bloquea la importacion con un error claro;
- mantiene el contrato recomendado de 17 columnas con `id_plantilla` al final.

## Correccion recomendada en origen

Actualizar el exportador de `maxgesth` para incluir `pp.id_plantilla` al final del `SELECT` de `puntos_control`:

```sql
SELECT pc.id, pc.tipo, pc.codigo, pc.descripcion, pc.unidad,
       pc.valor_min, pc.valor_max, pc.limite_i_b_bf, pc.limite_i_cf,
       pc.limite_ii_b_bf, pc.limite_ii_cf, pc.orden, pc.comparador,
       pc.tipo_validacion, pc.valor_objetivo, pc.margen, pp.id_plantilla
FROM puntos_control pc
INNER JOIN plantilla_puntos pp ON pp.id_punto = pc.id
INNER JOIN plantillas_preventivo p ON p.id = pp.id_plantilla
WHERE p.activo = 1 AND pc.activo = 1
ORDER BY pp.id_plantilla, pp.orden
```

Despues de cambiar el origen, se debe regenerar el JSON.

## Pruebas previstas

```powershell
python test_import.py
python test_report_service.py
python -m py_compile src\services\import_service.py test_import.py
```
