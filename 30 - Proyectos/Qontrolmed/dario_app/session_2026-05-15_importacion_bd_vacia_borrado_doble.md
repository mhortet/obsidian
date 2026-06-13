---
tags:
  - app
  - codigo
  - desarrollo
  - diario
Relacionado:
Creado: 2026-05-15
---

# Sesion 2026-05-15: importacion solo con BD vacia y borrado doble
[[masgesth_port]]
## Objetivo

Evitar importaciones sobre una base local con datos y exigir doble verificacion para borrar datos locales.

## Decision

La tablet trabaja offline y puede contener trabajo pendiente. Por seguridad:

- No se permite importar un JSON si la base local contiene cualquier dato relevante.
- Antes de importar un nuevo paquete, la base debe estar vacia.
- El borrado local requiere:
  - escribir la frase exacta `BORRAR DATOS`;
  - confirmar una segunda vez la accion destructiva.

## Cambios realizados

- `src/services/import_service.py`
  - Nueva excepcion `DatabaseNotEmptyError`.
  - Nueva excepcion `DatabaseClearConfirmationError`.
  - Nuevo metodo `get_database_counts`.
  - Nuevo metodo `clear_database` con frase exacta y segunda confirmacion.
  - `import_json_data` bloquea por defecto si hay datos locales.

- `src/ui/import_page.py`
  - Muestra si la base local esta vacia o contiene datos.
  - Informa al usuario de que debe borrar antes de importar.
  - Anade flujo de borrado con doble confirmacion.

- `test_import.py`
  - Verifica bloqueo de importacion con base no vacia.
  - Verifica que el borrado exige segunda confirmacion.
  - Verifica que el borrado deja la base vacia.

## Pruebas previstas

```powershell
python test_import.py
python test_report_service.py
python -m py_compile src\services\import_service.py src\ui\import_page.py test_import.py
git diff --check
```
