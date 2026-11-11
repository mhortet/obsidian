# Propuesta: plantillas PDF en blanco para Preventivos y Quirófanos

Fecha: 2026-05-27

## 1. Resumen ejecutivo

Sí veo viable incorporar la generación de plantillas PDF en blanco para trabajo en campo, pero en el estado actual no se resuelve solo desde UI: para hacerlo de forma limpia hay que tocar ambos servicios de PDF:

- `src/preventivos/services/pdf_service.py`
- `src/Quirofanos/services/pdf_service.py`

La razón es que ambos generadores están acoplados a un `id_informe` real y a datos persistidos en base de datos.

## 2. Verificación pedida antes de tocar nada

### 2.1. ¿Hay que tocar los `pdf_service`?

Sí.

#### Preventivos

El generador actual entra por `generar_pdf_preventivo_a_output(db, id_informe, ...)` y deriva en `generar_pdf_informe_preventivo(db, id_informe, ruta_salida, ...)`.

Ese flujo carga:

- cabecera del informe desde `informes_preventivo`
- equipo desde `equipos_gmao`
- resultados desde `resultados_preventivo`
- puntos de control desde `puntos_control`

Conclusión: hoy no existe una ruta de generación “por plantilla” ni “sin informe”. Para sacar una plantilla en blanco hay que añadir un segundo flujo que construya el PDF desde `plantillas_preventivo` + `plantilla_puntos` + `puntos_control`, dejando vacíos los campos de ejecución.

#### Quirófanos

El generador actual entra por `generar_pdf_informe(db, id_informe, ...)`.

Ese flujo:

- carga cabecera con `obtener_informe_por_id(db, id_informe)`
- carga puntos con `obtener_puntos_informe(db, id_informe)`
- y `obtener_puntos_informe` completa registros faltantes en base de datos para ese informe

Conclusión: tampoco existe una ruta “sin informe”. Para imprimir plantillas en blanco con los datos del quirófano, hay que añadir un flujo alternativo que cargue:

- datos del quirófano
- asignación de puntos del quirófano
- estructura visual del PDF

sin depender de un informe mensual creado.

### 2.2. Implicación de ramas activas

Como has pedido que, si hay que tocar esos servicios, primero se integren las ramas activas en `main`, la secuencia correcta sería:

1. Asegurar un árbol de trabajo limpio.
2. Integrar `pdf_quirofano` en `main`.
3. Integrar `pdf_preventivos` en `main`.
4. Crear una nueva rama para esta mejora.

Estado actual observado:

- rama activa: `pdf_quirofano`
- existe rama local: `pdf_preventivos`
- `pdf_quirofano` está por delante de `origin/pdf_quirofano`
- hay cambios locales en el árbol:
  - `icono.ico` modificado
  - varios SVG bajo `pdf_assets/qontrolmed/icons/` eliminados

Importante: antes de mezclar ramas conviene decidir qué hacer con esos cambios locales, porque ahora mismo no es buen momento para fusionar con seguridad.

### 2.3. ¿Es fácil cambiar colores/imagen corporativa en los informes actuales?

A día de hoy, no de forma cómoda para negocio.

Sí es viable técnicamente, pero no está parametrizado.

Ambos servicios PDF tienen colores corporativos hardcodeados al principio del módulo, con constantes tipo:

- `AZUL`
- `CIAN`
- `GRIS_LINEA`
- `GRIS_TEXTO`
- variantes de fondos y estados

Además:

- preventivos usa logo e iconografía corporativa fija (`pdf_assets/qontrolmed/...`)
- quirófanos mezcla colores corporativos, colores de estado y resolución de logo por hospital o fallback

Conclusión:

- cambio puntual de color: fácil para un desarrollador
- personalización mantenible por cliente: ahora mismo no cómoda

Valoración:

- viable ahora mismo si se limita a una sola identidad visual global
- no recomendable meter “multi-branding” completo en esta misma tarea, porque ampliaría bastante el alcance

Recomendación:

- en esta tarea mantener el aspecto actual
- dejar preparada la arquitectura para una fase posterior con tema compartido, por ejemplo en un módulo tipo `shared_pdf_theme.py` o `pdf_theme.py`

## 3. Propuesta funcional

### 3.1. Preventivos

Añadir en el módulo de preventivos un acceso nuevo:

- `Plantillas en blanco`

Y dentro:

- selección de plantilla
- acción `Generar PDF`

Comportamiento:

- genera el mismo formato actual del PDF
- sin datos de ejecución
- con espacios vacíos para anotación manual
- sin necesidad de crear un informe real en base de datos

### 3.2. Quirófanos

Añadir en el módulo de quirófanos un acceso nuevo:

- `Plantillas en blanco`

Con tres modos:

- un quirófano
- una ubicación
- todos los quirófanos

Comportamiento:

- conserva el formato actual del PDF
- rellena solo los datos de identificación del quirófano
- deja vacíos los campos de revisión, medidas, estados y observaciones
- genera un PDF por quirófano

Para “ubicación” y “todos”, mi recomendación inicial es:

- generar un ZIP o una carpeta de salida con un PDF por quirófano

No recomiendo un único PDF continuo para esta primera iteración, porque complica menos la navegación, el nombrado y la reutilización en campo.

## 4. Opinión sobre el botón y la UX

Tu idea de un botón específico `Plantillas en blanco` me parece buena y clara.

Mi sugerencia sería no mezclarlo con `Generar PDF` del informe normal. Mejor:

- mantener `Generar PDF` para informes reales
- añadir una entrada específica de menú o ventana modal para plantillas en blanco

Ventajas:

- evita errores de usuario
- separa bien “documento oficial del informe” de “soporte de trabajo de campo”
- nos deja evolucionar después la plantilla de campo sin tocar el flujo del informe final

## 5. Alternativas de diseño

### Opción A. Reutilizar exactamente el formato actual

Pros:

- menor coste
- menos riesgo
- salida homogénea con los informes actuales

Contras:

- no necesariamente es el formato más cómodo para escribir a mano
- algunas cajas, colores y jerarquías visuales están pensadas para informe final, no para toma de datos

### Opción B. Crear una “plantilla de campo” específica

Pros:

- más útil para el técnico
- se pueden reforzar líneas, espacios y ayudas visuales
- permite incluir instrucciones de uso

Contras:

- más trabajo de maquetación
- mayor superficie de pruebas
- obliga a decidir si convive con el PDF final o si deriva luego a otro flujo

Recomendación:

- Fase 1: reutilizar el formato actual
- Fase 2 opcional: sacar plantilla de campo mejorada si el uso real la justifica

## 6. Opinión sobre el versionado/nombre de plantillas

Me parece buena idea introducir identificadores como:

- `Q01QF`
- `P01QF`

pero no los expondría todavía como elemento principal de UI.

Recomendación:

- usarlos primero como código interno de plantilla o versión de salida
- reflejarlos en el nombre de archivo, en metadata interna o en una pequeña leyenda discreta del PDF

Ejemplo razonable:

- quirófanos: `Q01QF`
- preventivos: `P01QF`

Mi opinión:

- sí aporta valor para trazabilidad futura
- no es imprescindible bloquear esta tarea por no tener el modelo definitivo
- conviene dejarlo preparado desde el principio para no renombrar artefactos después

Lo que haría yo:

- guardar una constante o configuración de versión por tipo de plantilla
- usarla en el nombre del fichero y opcionalmente en pie de página
- no meter todavía gestión avanzada de versiones en base de datos salvo que ya estéis previendo muchas variantes

## 7. Propuesta técnica de implementación

### 7.1. Preventivos

Crear una ruta nueva en servicio, separada del informe real. Algo en esta línea:

- `generar_pdf_plantilla_preventivo_en_blanco(...)`

Necesidades:

- consulta de plantillas activas
- consulta de puntos por plantilla
- construcción de un contexto “vacío”
- reutilización máxima posible de bloques visuales ya existentes

Riesgo principal:

- el servicio actual parece más orientado a render a partir de resultados reales que a un “modo blank”, así que habrá que separar mejor carga de datos y render.

### 7.2. Quirófanos

Crear una ruta nueva en servicio, separada del informe real. Algo en esta línea:

- `generar_pdf_plantilla_quirofano_en_blanco(...)`

Y posiblemente helpers para:

- un quirófano
- varios quirófanos por ubicación
- todos los quirófanos

Necesidades:

- consulta de datos base del quirófano
- consulta de `quirofano_puntos_control`
- contexto vacío para estados, valores y observaciones
- reutilización de funciones de dibujo existentes

Riesgo principal:

- algunas funciones de dibujo actual infieren color/estado desde puntos reales; habrá que revisar que soporten valores vacíos sin romper alineación ni semántica visual.

### 7.3. UI

Cambios previsibles:

- `src/preventivos/main_preventivos.py`
- nueva UI/modal para seleccionar plantilla en preventivos
- `src/Quirofanos/ui/main_window.py`
- nueva UI/modal para selección por quirófano/ubicación/todos

Si la selección por ubicación no existe hoy como catálogo directo, habrá que construirla a partir de `quirofanos.ubicacion`.

## 8. Plan de ataque recomendado

### Fase 0. Preparación

1. Revisar y resolver los cambios locales actuales del árbol.
2. Integrar `pdf_quirofano` y `pdf_preventivos` en `main`.
3. Crear rama de trabajo para esta mejora.

Nombre sugerido de rama:

- `feature/plantillas-pdf-en-blanco`

### Fase 1. Extracción mínima de lógica

1. Separar en ambos `pdf_service` la parte de “carga de datos” de la parte de “render”.
2. Introducir contexto de datos compatible con “modo informe” y “modo plantilla en blanco”.

### Fase 2. Preventivos

1. Crear generador blank por plantilla.
2. Añadir ventana de selección de plantilla.
3. Generar archivo en carpeta de salida coherente.

### Fase 3. Quirófanos

1. Crear generador blank por quirófano.
2. Añadir selección por:
   - uno
   - ubicación
   - todos
3. Resolver salida múltiple.

### Fase 4. Nombres y trazabilidad

1. Introducir código de plantilla/versionado básico.
2. Aplicarlo a nombres de fichero.
3. Valorar si incluirlo también en pie de página.

### Fase 5. Validación

1. Comprobación manual visual de PDFs.
2. Pruebas de rutas sin datos.
3. Revisión de consistencia de nombres y carpetas de salida.
4. Paso de pruebas existentes y pruebas específicas nuevas si encajan en el repo.

## 9. Seguridad, consistencia y pruebas

### Seguridad y consistencia

Puntos a cuidar:

- no crear informes falsos en base de datos solo para imprimir plantillas
- no reutilizar el flujo de cierre o guardado de informes reales
- no modificar datos de operación por una acción de impresión
- validar bien nombres de archivo y rutas de salida

Esta parte es importante: para esta funcionalidad recomiendo explícitamente una generación “read-only”, sin inserts temporales.

### Pruebas

En el repo no he visto una batería de tests orientada a PDFs ni un armazón amplio de pruebas automáticas; sí existe `test_export.py`, pero no cubre esta funcionalidad.

Por tanto, el mínimo razonable para preparar producción sería:

- prueba manual de preventivos con varias plantillas
- prueba manual de quirófano individual
- prueba manual por ubicación
- prueba manual de todos los quirófanos
- verificación de apertura correcta de los PDFs generados
- comprobación de nombres de fichero y ausencia de escrituras en tablas de informes/resultados

Si durante la implementación vemos margen, propondría además pruebas unitarias ligeras para:

- selección de datos base
- construcción de nombres de fichero
- resolución de lotes por ubicación/todos

## 10. Recomendación final

Recomiendo seguir este orden:

1. Integrar primero las ramas PDF en `main`, como has pedido.
2. Implementar la versión simple reutilizando el formato actual.
3. Dejar el branding parametrizable como mejora posterior, no mezclarlo en esta sesión salvo preparación mínima.
4. Introducir desde ya los códigos tipo `Q01QF` y `P01QF` como trazabilidad ligera.

## 11. Decisión solicitada

Si te encaja la propuesta, mi siguiente paso sería:

1. dejar preparado el merge plan de `pdf_quirofano` + `pdf_preventivos` hacia `main`
2. crear la rama de trabajo de la mejora
3. implementar primero la base técnica en servicios
4. después la UI de selección
5. y cerrar con validación y pruebas

Pendiente de tu aceptación antes de iniciar cambios funcionales.
