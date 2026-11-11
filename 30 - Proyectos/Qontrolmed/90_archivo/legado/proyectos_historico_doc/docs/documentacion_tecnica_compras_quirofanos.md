# Documentacion tecnica: Modulos Compras y Quirofanos
[[masgesth]]
Fecha de revision: 26/04/2026  
Proyecto: Gestion Hospital  
Alcance: modulos `Compras`, `Quirofanos` y soporte compartido necesario para ambos.

## 1. Resumen ejecutivo

La aplicacion es una herramienta de escritorio Python/Tkinter para gestion documental hospitalaria. El arranque principal esta en `main.py`, que crea una raiz Tkinter, inicializa `compartido.conexion.Comunicacion` y abre la interfaz principal desde `Compras.ui.app.crear_app`.

El modulo `Compras` actua como pantalla principal del sistema y agrupa:

- Registro de compras con cabecera y lineas de detalle.
- Mantenimiento de maestros: proveedores, repuestos, equipos, usuarios, marcas y tipos de trabajo.
- Dashboard economico con filtros, graficas, HTML y exportacion PDF.
- Importacion de historicos Excel.
- Servicio preparado para interpretacion de presupuestos PDF.

El modulo `Quirofanos` se abre desde el menu principal de Compras y gestiona:

- Catalogo de quirofanos.
- Catalogo de puntos de control.
- Asignacion de puntos por quirofano.
- Equipos de medida y estado de calibracion.
- Informes mensuales de revision.
- Generacion de PDF individual y libro anual/acumulado de quirofano.

Ambos modulos dependen de MySQL. `Comunicacion` abre tres conexiones separadas: gestion, quirofanos y preventivos. Para este documento importan `DB_GESTION` y `DB_QUIROFANOS`.

## 2. Estructura de carpetas

```text
Gestion_Hospital_modificado/
  main.py
  requirements.txt
  compartido/
    conexion.py
    utils/
      resources.py
      ui_helpers.py
  Compras/
    services/
      compras_service.py
      dashboard_service.py
      equipos_service.py
      excel_historicos_service.py
      export_excel_service.py
      marcas_service.py
      pdf_import_service.py
      proveedores_service.py
      repuestos_service.py
      tipos_trabajo_service.py
      usuarios_service.py
    ui/
      app.py
      compras_ui.py
      dashboard_ui.py
      equipos_ui.py
      import_excel_ui.py
      marcas_ui.py
      proveedores_ui.py
      repuestos_ui.py
      tipos_trabajo_ui.py
      usuarios_ui.py
    utils/
      app_layout.py
      formatters.py
      ui_helpers.py
    bin/
      wkhtmltopdf.exe
  Quirofanos/
    db/
      connection.py
    plantillas/
      plantillaQ1.xlsx
      puntos_control.xlsx
    services/
      equipos_medida_service.py
      informe_service.py
      pdf_service.py
      puntos_control_service.py
      quirofano_puntos_control_service.py
      quirofanos_service.py
    ui/
      equipos_medida_ui.py
      informes_quirofanos_ui.py
      libro_quirofano_ui.py
      main_window.py
      puntos_control_ui.py
      quirofano_puntos_control_ui.py
      quirofanos_ui.py
    output/
      PDFs historicos generados
  output/
    salida general de PDFs
```

## 3. Dependencias

Dependencias declaradas en `requirements.txt`:

- `mysql-connector-python`: conexion MySQL.
- `python-dotenv`: carga de credenciales desde `.env`.
- `pandas`: procesamiento tabular, dashboard e importacion Excel.
- `openpyxl`: lectura/escritura de Excel.
- `pillow`: carga de imagenes en Tkinter.
- `matplotlib`: graficas del dashboard.
- `pdfkit`: conversion HTML a PDF en Compras, mediante `wkhtmltopdf`.
- `reportlab`: generacion programatica de PDFs de quirofano.
- `pypdf`: combinacion y numeracion de PDFs para libro de quirofano.
- `pdfplumber`: extraccion de texto/tablas desde presupuestos PDF.

## 4. Configuracion y conexiones

La configuracion de base de datos esta centralizada en `compartido/conexion.py`.

Variables requeridas:

- `DB_HOST`
- `DB_USER`
- `DB_PASSWORD`
- `DB_GESTION`
- `DB_QUIROFANOS`
- `DB_PREVENTIVOS`
- `DB_PORT` opcional, por defecto `3306`

`compartido.utils.resources.env_path()` localiza el `.env`. Si no existe o faltan variables, el arranque muestra error y destruye la ventana raiz.

`Comunicacion.__init__` crea:

- `self.conexion`: base `DB_GESTION`, usada por Compras.
- `self.conexion_quirofanos`: base `DB_QUIROFANOS`, usada por Quirofanos.
- `self.conexion_preventivos`: base `DB_PREVENTIVOS`, fuera del alcance principal de este documento.

La clase incorpora utilidades internas:

- `_require_connection(modulo)`: valida conexion activa.
- `_execute_commit_modulo`: ejecuta SQL con commit/rollback.
- `_fetchone_modulo` y `_fetchall_modulo`: lecturas.
- `_to_int`, `_to_date`, `_to_decimal_2`: normalizacion de entradas.
- `_resolve_column`: compatibilidad ante nombres de columnas alternativos.

## 5. Arranque y navegacion general

Flujo de arranque:

1. `main.py` crea `tk.Tk()`.
2. Instancia `Comunicacion()`.
3. Si falla la conexion, muestra `messagebox.showerror`.
4. Llama a `Compras.ui.app.crear_app(raiz, db)`.
5. Ejecuta `raiz.mainloop()`.

`Compras.ui.app` define el menu lateral:

- Gestion: Compras, Dashboard, Quirofanos, Preventivos.
- Maestros: Proveedores, Repuestos, Equipos, Usuarios, Marcas, Tipos trabajo.
- Importacion: Historicos Excel, Importar PDF en construccion.
- Informes y Utilidades: actualmente marcados como funcionalidades en construccion.

La ventana de Quirofanos se abre con `Quirofanos.ui.main_window.abrir_main_window(raiz, db)` y ofrece accesos a:

- Informes quirofanos.
- Libro de quirofano.
- Quirofanos.
- Puntos de control.
- Equipos de medida.
- Puntos control por quirofano.

## 6. Modulo Compras

### 6.1 Responsabilidades

Compras cubre la gestion economica y documental de compras asociadas a equipos hospitalarios. La informacion principal se organiza en una cabecera de compra y lineas de detalle.

Entidades principales detectadas:

- `compras`: cabecera con fecha, CECO, OT y equipo.
- `detalle_compra`: lineas con repuesto, cantidad, tipo de trabajo, precio/importe y refacturacion.
- `equipos`: inventario, descripcion, fabricante/marca, modelo y numero de serie.
- `marcas`: fabricantes.
- `proveedor`: proveedores.
- `repuestos`: repuestos, proveedor, coste, referencia y observaciones.
- `tipo_trabajo`: clasificacion del trabajo.
- `usuarios`: maestros de usuario/tecnico en el area de compras.
- `cecos`: usado por dashboard para obtener hospital/proyecto.

### 6.2 Capa UI

`Compras/ui/compras_ui.py` contiene la pantalla operacional de compra. Mantiene estado local de lineas de detalle y coordina:

- Seleccion de usuario/equipo/repuesto/tipo de trabajo.
- Alta de lineas con validacion.
- Calculo de totales y total refacturable.
- Guardado de compra.
- Busqueda/carga de compras existentes.
- Exportaciones Excel de compra o presupuesto.

Los CRUD de maestros tienen patron repetido:

- UI Tkinter con entradas, botones y `ttk.Treeview`.
- Validaciones en servicio especifico.
- Escritura/lectura delegada en metodos de `db` (`Comunicacion`).
- Recarga de tabla tras operaciones.

Archivos CRUD:

- `proveedores_ui.py` + `proveedores_service.py`
- `repuestos_ui.py` + `repuestos_service.py`
- `equipos_ui.py` + `equipos_service.py`
- `usuarios_ui.py` + `usuarios_service.py`
- `marcas_ui.py` + `marcas_service.py`
- `tipos_trabajo_ui.py` + `tipos_trabajo_service.py`

### 6.3 Servicio de compras

`Compras/services/compras_service.py` es una capa de negocio ligera:

- `validar_linea`: exige repuesto, precio positivo y cantidad positiva.
- `calcular_total_linea`: precio por cantidad.
- `calcular_totales`: suma total y suma refacturable.
- `construir_detalle`: normaliza datos procedentes de UI.
- `preparar_registros_detalle`: adapta lineas al formato que espera `Comunicacion.guardar_detallesCompra`.
- `guardar_compra_con_detalles`: crea cabecera y persiste detalles.
- `descomponer_compra`: transforma una compra cargada desde BD a estructuras usadas por UI.

Flujo de guardado:

1. La UI valida campos basicos de cabecera y lineas.
2. Cada linea se transforma con `construir_detalle`.
3. `guardar_compra_con_detalles` llama a `db.insertar_compra`.
4. `Comunicacion.insertar_compra` persiste cabecera y devuelve identificador.
5. Los detalles se preparan con `preparar_registros_detalle`.
6. `db.guardar_detallesCompra` borra detalles previos de la compra y reinserta los actuales en una transaccion.

### 6.4 Logica en Comunicacion para Compras

`Comunicacion` centraliza la mayor parte del acceso a datos del modulo:

- Marcas: insertar, buscar, modificar, borrar, obtener o crear.
- Proveedores: insertar, buscar, modificar, borrar, obtener o crear.
- Equipos: insertar, buscar, listar, modificar, borrar, resolver desde historico.
- Repuestos: insertar, listar, modificar, borrar, resolver desde historico.
- Tipos de trabajo: listar, buscar, modificar, borrar, obtener o crear.
- Compras: insertar, recuperar, cargar cabecera, cargar detalle, guardar detalles, buscar con filtros.
- Dashboard: resumen de gastos con filtros.
- Importacion historica: deteccion de duplicados y creacion de maestros auxiliares.

Hay compatibilidad defensiva con nombres de columnas alternativos:

- En `detalle_compra`, el precio puede estar como `precio`, `Precio`, `coste`, `Coste`, `importe` o `Importe`.
- La refacturacion puede estar como `refacturar`, `refacturable` o `Refacturable`.
- En `tipo_trabajo`, la descripcion puede tener varios nombres candidatos.

Esto permite mantener la aplicacion funcionando ante esquemas heredados no totalmente uniformes, pero aumenta la importancia de documentar migraciones de base de datos.

### 6.5 Dashboard de compras

`Compras/services/dashboard_service.py` consume `db.resumen_gastos_dashboard(filtros)` y construye un `DataFrame`.

Metricas principales:

- Total mensual del mes actual.
- Importe refacturable.
- Neto: total menos refacturable.
- Neto externo: no refacturable con tipo de trabajo que contiene "externa".
- Neto interno: neto menos neto externo.
- Evolucion mensual.
- Totales anuales.
- Serie interanual por año y mes.
- Top 10 repuestos por gasto.
- Numero de compras del mes.

`Compras/ui/dashboard_ui.py` genera graficas con Matplotlib, produce HTML y permite:

- Guardar informe HTML.
- Guardar PDF mediante `pdfkit` y `wkhtmltopdf`.

La busqueda de `wkhtmltopdf.exe` contempla rutas dentro de `Compras/bin` y rutas de instalacion de Windows.

### 6.6 Importacion de historicos Excel

`Compras/services/excel_historicos_service.py` cubre el flujo completo:

1. Localiza excels de pedidos bajo una carpeta.
2. Lee hojas con `pandas` y `openpyxl`.
3. Mapea columnas reales a columnas esperadas.
4. Normaliza textos, numeros, fechas y refacturable.
5. Separa filas validas, incidencias y rechazadas.
6. Exporta un Excel de revision (`historico_revision.xlsx`).
7. Importa filas validas a BD agrupando por `compra_clave`.

Durante importacion:

- Comprueba duplicados con `db.existe_compra_historica(ot, fecha, proveedor)`.
- Resuelve o crea equipo con `obtener_o_crear_equipo_desde_texto`.
- Resuelve o crea repuesto y proveedor con `obtener_o_crear_repuesto_desde_texto`.
- Resuelve o crea tipo de trabajo.
- Inserta compra y detalles.

La UI asociada esta en `Compras/ui/import_excel_ui.py`.

### 6.7 Importacion de presupuestos PDF

`Compras/services/pdf_import_service.py` esta preparado para interpretar presupuestos PDF:

- Usa `pdfplumber` para extraer texto y tablas.
- Define dataclasses: `ProveedorDetectado`, `LineaPresupuesto`, `PresupuestoDetectado`, `ConfigProveedorPDF`.
- Detecta proveedor mediante configuraciones y patrones.
- Extrae lineas genericas o especificas, por ejemplo `Medical Cables`.
- Busca o crea proveedor y repuesto.
- Prepara datos para importacion.

En el menu actual, la opcion `Importar PDF` todavia llama a `ventana_en_construccion`, por lo que el servicio existe pero no esta integrado como flujo completo de usuario.

## 7. Modulo Quirofanos

### 7.1 Responsabilidades

Quirofanos gestiona revisiones periodicas de quirofanos. La unidad documental principal es un informe mensual por quirofano, año y mes. Cada informe tiene resultados de puntos de control, tecnico, equipo de medida, estado de calibracion, observaciones y cierre.

Entidades principales detectadas:

- `quirofanos`: codigo, nombre, ubicacion, hospital y activo.
- `hospitales`: nombre y logo.
- `puntos_control`: catalogo general de puntos.
- `quirofano_puntos_control`: puntos asignados a cada quirofano con orden y texto de informe.
- `resultado_puntos`: resultado de cada punto dentro de un informe.
- `informes`: cabecera mensual del informe.
- `equipos_medida`: equipos usados para medicion y fechas de calibracion.

### 7.2 Ventana principal

`Quirofanos/ui/main_window.py` abre una ventana secundaria con bloques:

- Informes: informes quirofanos y libro de quirofano.
- Configuracion: quirofanos, puntos de control, equipos de medida y asignacion de puntos por quirofano.

Al cerrar esta ventana se llama a `db.close()` y se destruye la ventana secundaria. Este comportamiento debe revisarse si se desea volver a Compras y seguir usando la misma instancia `db`, porque cerrar las conexiones desde la ventana secundaria puede afectar al resto de la aplicacion.

### 7.3 Catalogos

Servicios CRUD:

- `quirofanos_service.py`: crear, actualizar, activar/desactivar, eliminar y listar quirofanos.
- `puntos_control_service.py`: listar, crear, actualizar, activar/desactivar y eliminar puntos.
- `equipos_medida_service.py`: listar, crear, actualizar, activar/desactivar y eliminar equipos de medida.

Las UIs correspondientes usan `Treeview`, formularios y botones de accion.

### 7.4 Asignacion de puntos por quirofano

`Quirofanos/services/quirofano_puntos_control_service.py` gestiona la relacion entre quirofanos y puntos:

- Obtiene puntos ya asignados.
- Obtiene puntos no asignados.
- Evita duplicados por codigo.
- Calcula siguiente orden.
- Permite asignacion manual.
- Permite asignacion automatica por codigo.
- Permite asignar rangos de puntos.
- Actualiza orden y texto de informe.
- Elimina relaciones.

Esta capa es clave porque los informes mensuales se inicializan copiando los puntos asignados al quirofano.

### 7.5 Informes mensuales

`Quirofanos/services/informe_service.py` concentra la logica de informe:

- `crear_informe`: inserta cabecera en `informes` y crea resultados iniciales en `resultado_puntos` con estado `OK` para todos los puntos asignados.
- `completar_puntos_faltantes`: rellena puntos que falten si se modifico la configuracion despues de crear el informe.
- `obtener_puntos_informe`: carga resultados ordenados.
- `actualizar_punto_por_codigo`: cambia estado, incidencia, observacion y valor medido.
- `obtener_informe`: recupera informe por quirofano/año/mes.
- `obtener_equipos_medida`: lista equipos activos.
- `comprobar_calibracion`: devuelve `SIN EQUIPO`, `SIN FECHA`, `CADUCADO`, `PROXIMO` u `OK`.
- `actualizar_equipo_medida_informe`, `actualizar_tecnico_informe`, `actualizar_cabecera_informe`: mantienen cabecera.
- `cerrar_informe`: marca cerrado y registra fecha de cierre.
- `obtener_observaciones_informe` y `actualizar_observaciones_informe`.
- `obtener_informes_cerrados_hasta_mes`: base para construir libros.

`Quirofanos/ui/informes_quirofanos_ui.py` implementa la pantalla principal de informe:

- Seleccion de quirofano, año y mes.
- Creacion o carga de informe.
- Seleccion de tecnico y equipo de medida.
- Visualizacion de puntos en dos tablas.
- Marcado de puntos como OK/MAL.
- Edicion de observaciones y valores medidos.
- Actualizacion de cabecera.
- Generacion de PDF.
- Cierre de informe.
- Modo lectura para informes cerrados.

### 7.6 Generacion de PDF de informe

`Quirofanos/services/pdf_service.py` genera PDFs con ReportLab.

`generar_pdf_informe(db, id_informe, carpeta_salida="output")`:

1. Recupera informe con quirofano, hospital, logo y equipo de medida.
2. Recupera puntos del informe.
3. Indexa puntos por codigo.
4. Crea `output/<codigo>_<anio>_<mes>.pdf`.
5. Dibuja cabecera, datos generales y equipo de medida.
6. Dibuja bloques especificos: lampara, dispositivo de vigilancia, fugas de corriente, equipotenciales/protecciones, suelo, no aislado, estados finales.
7. Dibuja observaciones y firmas.
8. Si el informe esta cerrado, añade texto de firma digital, tecnico, fecha de cierre e ID.

El PDF depende de codigos y descripciones de puntos. Existen funciones de busqueda por codigo y por texto normalizado para tolerar variaciones.

### 7.7 Libro de quirofano

`generar_libro_quirofano(db, anio, mes_hasta, ids_quirofano=None, carpeta_salida="output")`:

1. Obtiene informes cerrados hasta el mes indicado.
2. Si no hay informes, lanza `ValueError`.
3. Crea portada con hospital, logo, año, periodo y quirofanos incluidos.
4. Genera separadores por quirofano.
5. Genera PDF mensual para cada informe cerrado.
6. Construye un indice con paginas por quirofano y mes.
7. Une portada, indice y contenido con `pypdf`.
8. Numera el PDF final omitiendo portada.

La UI esta en `Quirofanos/ui/libro_quirofano_ui.py` y permite seleccionar año, mes limite y quirofano.

## 8. Flujos funcionales clave

### 8.1 Alta de compra manual

```text
Usuario -> Compras UI -> selecciona equipo/repuesto/tipo -> agrega lineas
        -> compras_service valida y normaliza
        -> Comunicacion.insertar_compra crea cabecera
        -> Comunicacion.guardar_detallesCompra inserta lineas
        -> UI limpia/actualiza totales
```

Puntos de control:

- No se permite guardar sin equipo.
- No se permite guardar sin lineas.
- Lineas requieren repuesto, precio > 0 y cantidad > 0.
- El guardado de detalles borra e inserta por `id_compra`, por lo que funciona tambien como reemplazo total de lineas.

### 8.2 Busqueda y carga de compra

```text
Usuario -> popup de busqueda -> Comunicacion.buscar_compras_filtradas
        -> selecciona compra -> obtener_compra_completa
        -> descomponer_compra -> poblar formulario y tabla de lineas
```

Filtros disponibles: fecha desde/hasta, CECO, OT, equipo, proveedor y texto en repuesto/referencia/equipo.

### 8.3 Dashboard de compras

```text
Usuario -> filtros dashboard
        -> Comunicacion.resumen_gastos_dashboard
        -> pandas DataFrame
        -> resumen economico
        -> matplotlib genera imagenes base64
        -> HTML
        -> opcional PDF via wkhtmltopdf/pdfkit
```

### 8.4 Importacion de historicos Excel

```text
Usuario -> selecciona carpeta
        -> localizar_excels_pedidos
        -> leer y consolidar
        -> normalizar y validar
        -> exportar revision
        -> importar validas agrupadas por compra
        -> crear maestros faltantes
        -> insertar compras y detalles
```

### 8.5 Creacion de informe de quirofano

```text
Usuario -> selecciona quirofano/año/mes
        -> crear_informe
        -> INSERT informes
        -> INSERT resultado_puntos desde quirofano_puntos_control con estado OK
        -> UI carga puntos
```

### 8.6 Edicion y cierre de informe

```text
Usuario -> marca puntos OK/MAL y edita valores
        -> actualizar_punto_por_codigo
        -> actualiza cabecera/equipo/tecnico/observaciones
        -> generar_pdf_informe si se solicita
        -> cerrar_informe marca cerrado=1 y fecha_cierre=NOW()
        -> UI aplica modo lectura
```

### 8.7 Generacion de libro de quirofano

```text
Usuario -> año, mes hasta, quirofano opcional
        -> obtener informes cerrados
        -> generar PDFs individuales temporales
        -> portada + indice + separadores + informes
        -> combinar PDF
        -> numerar paginas
        -> guardar Libro_Quirofano_<anio>_<mes>_<sufijo>.pdf
```

## 9. Salidas generadas

Compras:

- Excel de compra/presupuesto mediante `export_excel_service`.
- Excel de revision historica `historico_revision.xlsx`.
- HTML de dashboard.
- PDF de dashboard mediante `pdfkit` y `wkhtmltopdf`.

Quirofanos:

- PDF mensual de informe: `<codigo_quirofano>_<anio>_<mes>.pdf`.
- Libro de quirofano: `Libro_Quirofano_<anio>_<mes_hasta>_<sufijo>.pdf`.

## 10. Observaciones tecnicas y riesgos de mantenimiento

1. `Comunicacion` mezcla acceso a datos, reglas de normalizacion y mensajes Tkinter. Para futuras ampliaciones conviene separar persistencia pura de UI.
2. Algunos textos aparecen con caracteres mojibake en archivos de Quirofanos (`GestiÃ³n`, `QuirÃ³fanos`). Conviene normalizar codificacion a UTF-8.
3. `Quirofanos.ui.main_window.cerrar_todo` llama a `db.close()`. Si el usuario vuelve a Compras tras cerrar la ventana de Quirofanos, puede quedar sin conexion.
4. `pdf_service.py` contiene una zona con codigo duplicado/antiguo comentado y una funcion `crear_portada_libro_quirofano` redefinida. Conviene depurar para evitar confusiones.
5. La generacion del libro de quirofano tiene bloques duplicados dentro de `generar_libro_quirofano`; requiere prueba regresiva antes de refactorizar.
6. La importacion PDF de Compras tiene servicio implementado, pero no UI final conectada.
7. El esquema de BD parece historico y flexible; el codigo resuelve columnas alternativas. Las migraciones futuras deberian fijar nombres canonicos.
8. Hay pyc y PDFs generados dentro de carpetas de codigo. Para archivo limpio, conviene mantener salidas en `output/` y excluir cache/salidas de versionado.
9. Las transacciones en Compras se concentran correctamente en `guardar_detallesCompra`, pero otras operaciones hacen commit individual. En operaciones compuestas futuras conviene transaccion unica.
10. Las validaciones de fechas y decimales estan repartidas entre UI, servicios y `Comunicacion`; conviene centralizarlas si crece el sistema.

## 11. Recomendaciones para supervision futura

- Mantener este documento junto con scripts SQL de migracion.
- Añadir un documento de esquema de BD con tablas, columnas y claves foraneas reales exportadas desde MySQL.
- Crear pruebas de servicios puros: `compras_service`, `dashboard_service`, `excel_historicos_service`, `informe_service`.
- Probar manualmente antes de cada entrega:
  - Crear compra con varias lineas, refacturable y tipo de trabajo.
  - Buscar y recargar compra.
  - Exportar Excel.
  - Generar dashboard PDF.
  - Crear informe de quirofano.
  - Marcar puntos OK/MAL y generar PDF.
  - Cerrar informe y generar libro.
- Revisar codificacion de todos los `.py` en UTF-8.
- No modificar codigos de puntos de control sin validar `pdf_service.py`, porque varias secciones del PDF dependen de codigos o textos esperados.
- Documentar cualquier cambio de esquema en `docs/` con fecha y SQL aplicado.

## 12. Mapa rapido por archivo

### Compartido

- `main.py`: arranque Tkinter y creacion de `Comunicacion`.
- `compartido/conexion.py`: carga `.env`, conexiones MySQL, operaciones de Compras y una parte de Quirofanos.
- `compartido/utils/resources.py`: resolucion de rutas para ejecucion normal y empaquetada.
- `compartido/utils/ui_helpers.py`: mensajes y validacion de fecha.

### Compras

- `Compras/ui/app.py`: ventana principal y menu lateral.
- `Compras/ui/compras_ui.py`: formulario principal de compra.
- `Compras/ui/dashboard_ui.py`: filtros, graficas, HTML y PDF del dashboard.
- `Compras/ui/import_excel_ui.py`: importacion historica.
- `Compras/services/compras_service.py`: reglas de lineas, totales y guardado.
- `Compras/services/dashboard_service.py`: DataFrame y resumen economico.
- `Compras/services/excel_historicos_service.py`: importacion historica completa.
- `Compras/services/export_excel_service.py`: exportacion estilizada con OpenPyXL.
- `Compras/services/pdf_import_service.py`: interpretacion de presupuestos PDF.
- `Compras/services/*_service.py`: validaciones CRUD de maestros.
- `Compras/utils/app_layout.py`: menu lateral y panel principal.
- `Compras/utils/ui_helpers.py`: helpers de UI y Treeview.
- `Compras/utils/formatters.py`: formato monetario.

### Quirofanos

- `Quirofanos/ui/main_window.py`: ventana de entrada al modulo.
- `Quirofanos/ui/informes_quirofanos_ui.py`: gestion de informe mensual.
- `Quirofanos/ui/libro_quirofano_ui.py`: generacion de libro.
- `Quirofanos/ui/*_ui.py`: CRUDs y asignacion de puntos.
- `Quirofanos/services/informe_service.py`: cabecera, puntos, cierre y calibracion.
- `Quirofanos/services/pdf_service.py`: PDF individual y libro.
- `Quirofanos/services/quirofano_puntos_control_service.py`: asignacion de puntos.
- `Quirofanos/services/quirofanos_service.py`: CRUD quirofanos.
- `Quirofanos/services/puntos_control_service.py`: CRUD puntos.
- `Quirofanos/services/equipos_medida_service.py`: CRUD equipos de medida.
- `Quirofanos/db/connection.py`: conexion directa a `DB_QUIROFANOS`, actualmente alternativa a `Comunicacion`.

## 13. Criterios de archivo

Para conservar una fotografia tecnica del sistema se recomienda archivar juntos:

- Este PDF.
- El Markdown fuente.
- `requirements.txt`.
- Scripts SQL de migracion existentes en `docs/`.
- Copia del esquema MySQL sin datos sensibles.
- Version empaquetada o commit asociado.

