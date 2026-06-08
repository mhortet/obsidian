---
tags:
  - app
  - codigo
  - desarrollo
  - diario
Relacionado:
Creado: 2026-05-15
---

# Sesion 2026-05-15: referencias visibles en puntos de control
[[masgesth_port]]
## Objetivo

Mostrar al tecnico los valores de referencia en el momento de la medida, directamente encima del campo de entrada de cada punto.

## Decision

La tablet debe ayudar al tecnico a ser consciente del criterio de aceptacion durante la toma de datos. De momento se muestran referencias y se guardan los valores necesarios, sin cerrar todavia la logica definitiva de calculo automatico.

## Cambios realizados

- `src/services/report_service.py`
  - `PuntoControlOption` incluye ahora:
    - `valor_min`
    - `valor_max`
    - limites de seguridad por clase
    - `valor_objetivo`
    - `margen`
  - El guardado de resultados incluye `valor_referencia`.

- `src/data/schema.py`
  - `resultados_preventivo` incluye `valor_referencia`.
  - Migracion simple para anadir `valor_referencia` si la tabla ya existia.

- `src/ui/report_page.py`
  - Cada punto muestra una banda de referencia encima de la entrada.
  - `RANGO` muestra objetivo, margen y rango calculado.
  - rangos min/max muestran limite inferior/superior.
  - seguridad muestra limites por clase cuando existen.
  - `RANGO_VARIABLE` muestra dos entradas:
    - `Referencia`
    - `Valor leído`

- `test_report_service.py`
  - Verifica que `valor_referencia` se guarda para puntos de rango variable.

## Pendiente

- Decidir si la tablet debe calcular `B`, `M`, `P` y `NA` en tiempo real o si solo debe mostrar referencias y dejar el calculo final al ordenador principal.
- Si se calcula en tablet, conviene mantener recalculo en maxgesth al importar como verificacion adicional.

## Pruebas ejecutadas

```powershell
python test_import.py
python test_report_service.py
python -m py_compile src\data\schema.py src\data\db.py src\services\import_service.py src\services\report_service.py src\ui\import_page.py src\ui\report_page.py test_import.py test_report_service.py
git diff --check
```

Resultado: todas las verificaciones terminaron correctamente. `git diff --check` solo mostro avisos CRLF propios de Windows.
