# Documentacion integral del proyecto (base para Word)
[[masgesth]]
Fecha: 12/05/2026
Proyecto: Gestion Hospital Modificado
Tipo de aplicacion: Escritorio (Python + Tkinter + MySQL)

## 1. Objetivo del documento

Este documento consolida la informacion tecnica y funcional del proyecto para que pueda maquetarse en Word como documentacion oficial. Incluye tecnologia, arquitectura, logica de negocio, modulos, flujo de trabajo y recomendaciones de mantenimiento.

## 2. Vision general del sistema

La aplicacion centraliza la gestion documental y operativa de tres areas:

- Compras
- Quirofanos
- Preventivos

El arranque se realiza desde `main.py`, con autenticacion inicial y un menu principal por modulos. El acceso a datos se hace contra MySQL mediante una capa compartida de conexion (`compartido`).

## 3. Stack tecnologico

### 3.1 Lenguaje y framework de interfaz

- Python
- Tkinter (UI de escritorio)

### 3.2 Base de datos

- MySQL
- Conexion con `mysql-connector-python`

### 3.3 Librerias del proyecto (`requirements.txt`)

- `mysql-connector-python`: acceso a MySQL.
- `python-dotenv`: carga de variables de entorno para BD.
- `pandas`: analitica tabular y soporte a dashboard/importaciones.
- `openpyxl`: lectura y escritura de Excel.
- `pillow`: soporte de imagenes en UI.
- `matplotlib`: graficos en dashboard.
- `pdfkit`: generacion PDF desde HTML (flujo Compras).
- `reportlab`: generacion PDF programatica (Quirofanos/Preventivos).
- `pypdf`: combinacion/manipulacion de PDFs.
- `pdfplumber`: lectura de contenido en PDFs de entrada.

## 4. Arquitectura y organizacion del codigo

## 4.1 Estructura principal

```text
Gestion_Hospital_modificado/
  main.py
  requirements.txt
  compartido/
    auth.py
    configuracion.py
    conexion.py
    db.py
    utils/
  Compras/
    db.py
    ui/
    services/
    utils/
  Quirofanos/
    db/
    ui/
    services/
  preventivos/
    db.py
    ui/
    services/
  bd/
    scripts SQL por dominio
  docs/
    documentacion y migraciones
```

### 4.2 Patron de capas usado

El codigo sigue una separacion por responsabilidad:

- `ui/`: ventanas, formularios, eventos y validacion visual.
- `services/`: reglas de negocio, normalizacion y coordinacion de persistencia.
- `db.py` por modulo: helpers de acceso SQL sobre la conexion compartida.
- `compartido/`: infraestructura comun (conexion, auth, configuracion, recursos).

Es un patron similar a una arquitectura por capas ligera (sin framework ORM).

## 5. Configuracion y conectividad

### 5.1 Variables de entorno

Desde `compartido/configuracion.py`, el sistema exige un `.env` con:

- `DB_HOST`
- `DB_PORT` (opcional, por defecto 3306)
- `DB_USER`
- `DB_PASSWORD`
- `DB_GESTION`
- `DB_QUIROFANOS`
- `DB_PREVENTIVOS`

Si faltan variables, el arranque falla con mensaje explicito.

### 5.2 Conexiones activas

`compartido/db.py` (`GestorConexiones`) mantiene 3 conexiones:

- `conexion` -> base de Gestion (Compras y usuarios)
- `conexion_quirofanos`
- `conexion_preventivos`

`compartido/conexion.py` expone `Comunicacion` como fachada de compatibilidad.

## 6. Seguridad y autenticacion

### 6.1 Login

`Compras/ui/login_ui.py` fuerza autenticacion antes de abrir modulos.

- Si no hay usuarios con `password_hash`, habilita acceso inicial controlado.
- Si hay passwords configuradas, aplica validacion de usuario/password.
- Cierra acceso tras 3 intentos fallidos.

### 6.2 Hash de contrasenas

`compartido/auth.py` usa:

- PBKDF2-HMAC-SHA256
- 210000 iteraciones
- Sal aleatoria por usuario
- Comparacion segura con `hmac.compare_digest`

Tambien existe compatibilidad con un valor legacy para columna historica.

## 7. Flujo funcional de la aplicacion

1. `main.py` crea ventana raiz.
2. Inicializa `Comunicacion` (3 conexiones).
3. Ejecuta login.
4. Muestra portada de modulos (Compras, Quirofanos, Preventivos).
5. Cada modulo abre en ventana `Toplevel` propia.
6. Al cerrar, se liberan conexiones.

## 8. Modulo Compras

### 8.1 Alcance

- Gestion de compras (cabecera + detalle).
- Maestros: proveedores, repuestos, equipos, marcas, tipos de trabajo, usuarios, CECOS.
- Dashboard de gasto.
- Importacion de historicos Excel.
- Servicios de exportacion.

### 8.2 Logica de negocio clave

En `Compras/services/compras_service.py`:

- Validacion de lineas (`repuesto`, `precio`, `cantidad`).
- Calculo de totales y total refacturable.
- Construccion de detalle normalizado.
- Guardado transaccional de cabecera + detalle.
- Busqueda de compras por filtros funcionales.

### 8.3 Particularidades tecnicas

- Soporte a esquemas heredados con nombres de columna alternativos (`_resolve_column`).
- Alta acoplacion con SQL manual (mas control, mas necesidad de documentar cambios BD).

## 9. Modulo Quirofanos

### 9.1 Alcance

- Catalogo de quirofanos.
- Catalogo de puntos de control.
- Asignacion de puntos por quirofano.
- Equipos de medida y estado de calibracion.
- Informes mensuales.
- Libro de quirofano y salida PDF.

### 9.2 Logica de negocio clave

En `Quirofanos/services/informe_service.py`:

- Creacion de informe con alta de resultados base por punto.
- Completar automaticamente puntos faltantes en informes existentes.
- Actualizacion de estado por codigo de punto.
- Comprobacion de calibracion de equipo de medida (vigente/caducado/aviso).

## 10. Modulo Preventivos

### 10.1 Alcance

- Generacion de informes preventivos por equipo GMAO.
- Gestion de plantillas y puntos de control.
- Importacion de inventario GMAO desde Excel.
- Historico e impresion multiple.

### 10.2 Logica de negocio clave

En `preventivos/services/informes_preventivo_service.py`:

- Creacion de informe desde plantilla asociada a tipo de equipo.
- Inicializacion automatica de resultados por punto.
- Evaluacion de puntos:
  - `CUALITATIVO`
  - `CUANTITATIVO` (rango fijo, rango variable, sistema legacy)
  - `SEGURIDAD` (limites por clase de equipo)

## 11. Logica transversal de datos

La aplicacion usa SQL explicito con cursores. Los helpers compartidos gestionan:

- Commit/rollback.
- Fetch one/fetch all.
- Verificacion de conexion activa.
- Resolucion dinamica de columnas para compatibilidad.

Ventaja: control completo de SQL.
Coste: mayor disciplina de pruebas y migraciones.

## 12. Scripts SQL y datos

La carpeta `bd/` contiene scripts de tablas por dominio (`gestion_*`, `quirofanos_*`).
En `docs/` existen scripts de migracion para cambios funcionales.

Recomendacion operativa:

- versionar toda alteracion de esquema en `docs/` con prefijo de fecha.
- anotar impacto en servicios afectados.

## 13. Forma de trabajar recomendada

## 13.1 Convenciones de desarrollo

- Mantener separacion UI/servicio/db.
- Evitar SQL embebido en UI.
- Centralizar validaciones de negocio en `services/`.
- Mantener nombres de metodos consistentes por modulo (listar, buscar, guardar, modificar, borrar).

### 13.2 Flujo de cambio sugerido

1. Definir cambio funcional y tablas implicadas.
2. Preparar migracion SQL (si aplica).
3. Implementar en `services/`.
4. Adaptar UI.
5. Probar manualmente flujo completo.
6. Actualizar documentacion tecnica/funcional.

### 13.3 Pruebas minimas por release

- Login correcto e incorrecto.
- Alta/edicion/baja en al menos un maestro de cada modulo.
- Creacion de compra con detalle y recalculo de totales.
- Creacion de informe de quirofano y salida PDF.
- Creacion de informe preventivo y evaluacion automatica.

## 14. Riesgos tecnicos actuales

- No hay suite automatizada de tests.
- Hay dependencia de variaciones historicas de esquema en BD.
- La UI Tkinter crece por ventanas, puede aumentar duplicidad de patrones.
- El empaquetado y distribucion no esta estandarizado en esta revision.

## 15. Roadmap tecnico recomendado

1. Incorporar pruebas unitarias de servicios criticos (compras/informes).
2. Crear validaciones de esquema al arranque (health check de columnas).
3. Consolidar migraciones SQL con versionado unico.
4. Extraer componentes UI repetidos para reducir deuda tecnica.
5. Documentar procedimiento de build y despliegue en entorno cliente.

## 16. Guia de maquetacion en Word

Para convertir este contenido en documento formal:

1. Copiar el contenido a Word.
2. Aplicar estilos:
   - Titulo 1: secciones `##`
   - Titulo 2: subsecciones `###`
   - Texto normal: parrafos y listas
3. Insertar portada con:
   - Nombre del proyecto
   - Version
   - Fecha
   - Responsable
4. Insertar tabla de contenido automatica.
5. Agregar control de cambios al final.

## 17. Anexos recomendados para version final

- DER simplificado (Gestion, Quirofanos, Preventivos).
- Diccionario de datos por tabla.
- Matriz de permisos por rol de usuario.
- Capturas de pantallas clave.
- Checklist de pruebas por version.
