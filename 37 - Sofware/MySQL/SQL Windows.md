---
tags:
  - SQL
  - software
Creado:
Relacionado:
---

Lecciones aprendidas:

- en Windows, no confiar solo en que `MySQL Configurator` detecte la instancia
  existente;
- validar siempre:
  - binario real del servicio;
  - `my.ini` realmente usado por el servicio;
  - plugin de autenticacion de los usuarios de aplicacion;
- si `MySQL Workbench 8.0.x` queda por detras del servidor `8.4.x`, puede
  mostrar warning de compatibilidad sin impedir la administracion basica.