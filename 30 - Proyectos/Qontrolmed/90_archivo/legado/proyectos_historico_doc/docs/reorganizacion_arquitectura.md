# Reorganizacion de arquitectura
[[masgesth]]
## Objetivo

Preparar el proyecto para crecer sin mezclar responsabilidades, manteniendo cambios pequenos y verificables. La regla de partida es no mover todo a la vez: primero estabilizar dependencias compartidas, luego separar acceso a datos por dominio y por ultimo valorar una estructura `src/`.

## Restricciones

- No eliminar `compartido/.env`: es configuracion local sensible y debe sobrevivir a cualquier limpieza.
- No versionar `compartido/.env.example`: la configuracion correcta vive solo en `compartido/.env`.
- No eliminar aun `_internal/` ni `Compras/bin/`: contienen artefactos versionados y requieren una decision especifica.
- No cambiar nombres de carpetas de dominio (`Compras`, `Quirofanos`, `preventivos`) hasta tener imports y empaquetado controlados.

## Diagnostico actual

- `main.py` inicia la aplicacion principal de Compras y crea una unica instancia de `Comunicacion`.
- `Compras`, `Quirofanos` y `preventivos` ya tienen separacion basica entre `ui` y `services`.
- `compartido/conexion.py` concentra configuracion, conexiones y demasiada logica de datos de varios dominios.
- `compartido/utils/resources.py` resuelve recursos desde la raiz o desde el ejecutable, por lo que el renombre de la carpeta raiz no deberia romper rutas.
- Hay binarios y recursos pesados versionados (`_internal/`, `Compras/bin/`) que conviene revisar en una fase separada.

## Plan incremental

1. Configuracion y recursos compartidos:
   - Extraer lectura de entorno y validacion de variables desde `compartido/conexion.py` a un modulo pequeno de configuracion.
   - Mantener `env_path()` como unica fuente de la ruta a `compartido/.env`.
   - Documentar que `.env` se mantiene localmente y no se elimina en limpiezas.

2. Acceso a base de datos:
   - Reducir `Comunicacion` a gestor de conexiones y helpers comunes.
   - Usar wrappers de acceso a datos por dominio, empezando por `preventivos/db.py`.
   - Mover metodos de Compras a servicios/repositorios de `Compras`.
   - Mover metodos de Quirofanos a servicios/repositorios de `Quirofanos`.
   - Mover metodos de Preventivos a servicios/repositorios de `preventivos`.

3. UI y servicios:
   - Mantener las pantallas Tkinter en `ui`.
   - Dejar transformaciones, consultas y generacion de documentos en `services`.
   - Evitar que la UI construya SQL o conozca detalles de tablas.

4. Empaquetado y raiz:
   - Revisar `_internal/` y `Compras/bin/` antes de decidir si salen de Git.
   - Solo valorar `src/` cuando los imports por dominio esten limpios.
   - Mantener `main.py` como entrada durante la transicion.

## Validacion por fase

- Ejecutar compilacion de sintaxis de todos los `.py`.
- Abrir importaciones principales sin conectar a base de datos cuando sea posible.
- Verificar que `main.py` sigue encontrando `icono.ico` y `compartido/.env`.
- Revisar `git status` para asegurar que no se borran archivos locales protegidos ni plantillas.

## Avance realizado

- Configuracion de base de datos extraida a `compartido/configuracion.py`.
- Gestion de conexiones centralizada en `compartido/db.py`.
- Acceso a datos de Preventivos separado en `preventivos/db.py`.
- Acceso a datos de Quirofanos separado en `Quirofanos/db/__init__.py`.
- Acceso a datos basico de Compras separado en `Compras/db.py`.
- CRUD principal de Compras migrado a servicios: marcas, usuarios, tipos de trabajo, proveedores, equipos y repuestos.
- Pantallas de mantenimiento de Compras actualizadas para consumir servicios de listado en vez de llamar directamente a metodos heredados de `Comunicacion`.
- La pantalla principal de compras usa servicios para seleccionar usuarios, equipos, repuestos y tipos de trabajo.
- Guardado y consulta de compras migrados a `Compras/services/compras_service.py`, con transaccion unica para cabecera y detalle.
- Dashboard migrado a `Compras/services/dashboard_service.py`.
- Importacion historica de Excel migrada para usar servicios de Compras en la resolucion de maestros y guardado de compras.
- `compartido/conexion.py` reducido a fachada minima de compatibilidad.
- Helpers comunes de acceso a BD movidos a `compartido/db.py`.
- `Quirofanos/services/quirofanos_service.py` ya consulta quirófanos sin depender de metodos heredados de `Comunicacion`.

## Pendiente en Compras

- Revisar `Compras/services/pdf_import_service.py`: modulo experimental, actualmente en panales y sin funcionamiento estable.
- Eliminar o reescribir `Compras/services/pdf_import_service.py` cuando se decida si ese flujo se retoma.
