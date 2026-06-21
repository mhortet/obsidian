---
tags:
  - SQL
  - software
Creado:
Relacionado:
---
## Riesgos o notas

- `MySQL Workbench 8.0.44` muestra warning de compatibilidad al conectar contra
  `MySQL 8.4.9`, pero permite continuar;
- queda recomendado actualizar Workbench en otra ventana tranquila de
  mantenimiento;
- leccion operativa importante:
  - al subir a `MySQL 8.4+`, revisar siempre el `plugin` de los usuarios de
    aplicacion antes de dar el cambio por cerrado;
  - si el configurador no detecta la instancia existente, no continuar como
    instalacion nueva sin revisar antes servicio, `my.ini` y `datadir`.
