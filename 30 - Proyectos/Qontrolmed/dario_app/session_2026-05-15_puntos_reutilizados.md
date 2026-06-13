---
tags:
  - app
  - codigo
  - desarrollo
  - diario
Relacionado:
Creado: 2026-05-15
---

# Sesion 2026-05-15: puntos reutilizados en varias plantillas
[[masgesth_port]]
## Problema

Tras corregir el exportador para incluir `id_plantilla`, la importacion detecto:

```text
ID duplicado en puntos_control[56]: 24
```

Esto indica que el punto de control origen `24` esta vinculado a mas de una plantilla. El modelo local anterior suponia que `puntos_control.id` era unico globalmente y que cada punto pertenecia a una unica plantilla.

## Decision

El modelo real de origen usa una relacion plantilla-punto. Para soportarlo en la tablet:

- `puntos_control.id` pasa a ser un ID local unico por combinacion punto-plantilla.
- `puntos_control.id_origen` conserva el ID real del punto en maxgesth.
- `puntos_control.id_plantilla` conserva la plantilla a la que pertenece esa fila local.
- Los resultados locales referencian el ID local, porque la misma definicion de punto puede aparecer en distintas plantillas.
- La futura exportacion debera usar `id_origen` cuando necesite comunicar el punto original a maxgesth.

## Implementacion

- `src/data/schema.py`
  - Nueva columna `id_origen` en `puntos_control`.
  - Migracion simple para anadir `id_origen` si la tabla ya existe.

- `src/services/import_service.py`
  - Los duplicados de `puntos_control` ya no se validan solo por `id`.
  - Se valida la combinacion `(id_origen, id_plantilla)`.
  - Se genera un ID local determinista a partir de `id_plantilla` e `id_origen`.

- `src/services/report_service.py`
  - Los puntos cargados para UI conservan `id_origen` ademas del ID local.

- `test_import.py`
  - Caso de prueba con un punto reutilizado en dos plantillas.
  - Verifica que se importan dos filas locales distintas y se conserva el mismo `id_origen`.

## Pruebas ejecutadas

```powershell
python test_import.py
python test_report_service.py
python -m py_compile src\data\schema.py src\services\import_service.py src\services\report_service.py src\ui\report_page.py test_import.py test_report_service.py
```

Resultado: todas las verificaciones terminaron correctamente.
