# Sesion 2026-05-29 - Preventivos end-to-end en Qontrolmed
[[masgesth]]

Nota de naming:

- `Qontrolmed` es la marca funcional del escritorio.
- Se conserva `maxgesth` cuando haga falta distinguir repo, ruta o nombres
  tecnicos ya existentes.

## Objetivo de la sesion

Cerrar el lado `Qontrolmed` del flujo `Preventivos end-to-end` sin abrir
frentes nuevos en Analitico, centrando el trabajo en:

- campanas preventivas;
- creacion manual de informes con regla coherente por campana;
- historico filtrable por campana;
- consistencia visible de tipologias;
- contrato escritorio-tablet con `id_campana`.

## Cambios funcionales aplicados

### 1. Creacion manual de informes por campana

En `src/preventivos/services/informes_preventivo_service.py` se ajusto la
creacion de informes preventivos para que la unicidad funcional siga la regla:

- un informe por `equipo + campana`;
- un informe abierto en otra campana no debe bloquear la creacion;
- si ya existe informe en la campana seleccionada, el mensaje distingue entre
  informe abierto e informe cerrado.

Tambien se mantuvo la insercion defensiva por columnas existentes y la
transaccion con `rollback()` previo y final.

### 2. Historico filtrable por campana

En `src/preventivos/services/historico_preventivos_service.py` y
`src/preventivos/ui/historico_preventivos_ui.py` quedo operativo:

- filtro por campana en historico;
- columna visible de campana;
- compatibilidad cuando el esquema no tenga `campanas_preventivo` o
  `informes_preventivo.id_campana`.

### 3. Consistencia de tipologias visibles

Se alineo la presentacion de tipologias para priorizar `descripcion` y dejar
`nombre` como fallback en:

- `src/preventivos/main_preventivos.py`;
- `src/preventivos/services/informes_preventivo_service.py`;
- `src/preventivos/services/historico_preventivos_service.py`;
- `src/preventivos/services/export_preventivos_service.py`;
- `src/preventivos/ui/plantillas_preventivo_ui.py`.

### 4. Contrato de importacion desde tablet

En `src/preventivos/services/import_tablet_service.py` y
`src/preventivos/main_preventivos.py` se dejo mas explicito que:

- los conflictos se resuelven por `equipo + campana`;
- el dialogo de conflictos muestra la campana afectada;
- si un fichero antiguo no trae `id_campana`, se usa la campana activa de
  escritorio como fallback controlado;
- ese fallback deja warning visible en previsualizacion e importacion.
- si por error se selecciona un export maestro de `Qontrolmed` para cargar en
  la tablet, el importador ahora lo detecta y muestra un mensaje especifico en
  vez del error generico de claves faltantes.

## Documentacion actualizada

Se ajustaron estos documentos para reflejar las reglas reales:

- `specifications/remote_tablet_preventivos.md`
- `specifications/modulo_analitico_y_campanas_preventivo.md`
- `docs/estado_continuidad.md`

## Validacion automatizada ejecutada

OK:

- `python -m compileall main.py src`
- `python -m py_compile src\preventivos\main_preventivos.py src\preventivos\services\informes_preventivo_service.py src\preventivos\services\historico_preventivos_service.py src\preventivos\services\import_tablet_service.py src\preventivos\services\export_preventivos_service.py src\preventivos\ui\historico_preventivos_ui.py src\preventivos\ui\plantillas_preventivo_ui.py`

Incidencia de entorno:

- `python test_export.py` no sirvio como prueba fiable porque intento escribir
  sobre `output/export_tablet/test_preventivos_export.json` y recibio
  `PermissionError`.
- El mismo script ademas imprime simbolos Unicode que rompen la salida CP1252
  del terminal actual.

Prueba de humo alternativa:

- exportacion directa del servicio a
  `output/export_tablet/smoke_export_2026-05-29.json` completada con exito.
- validacion de `_load_export()` con dos casos reales:
  - JSON de resultados de `maxgesth_port`: aceptado;
  - JSON maestro de `Qontrolmed`: rechazado con mensaje especifico.

## Validacion manual realizada

Verificaciones confirmadas:

1. Importacion de dos campanas sin conflictos: OK.
2. Realizacion de informes en PC: OK.
3. Historico, cierre y flujo general de seguimiento: OK.
4. Exportacion a tablet: OK.
5. Proteccion anti carga con datos antiguos en tablet: OK.
6. Doble seguridad para borrado de equipos antiguos en tablet: OK.
7. Trabajo operativo en tablet: OK.
8. Exportacion desde tablet e importacion en PC: OK.
9. Seguridad en caso de informes repetidos tablet/PC: OK.
10. La importacion permite elegir que informe permanece: OK.
11. Impresion de informe: OK.

## Incidencias detectadas para siguiente corte

1. Ventana emergente de campana:
   cambiar `Anio` por `Año`.
2. Ventana de asignar puntos a plantillas:
   anadir boton de salida.
3. Importacion GMAO:
   anadir la columna `clase_seguridad` desde Excel.
4. Ventana `Informe preventivo`:
   - recuperar boton de minimizar y ventana ajustable;
   - al crear informe desde esta pantalla no se habilita `Forzar No apto`;
   - al cerrar informe queda desbloqueado el combo de clase/tipo.
5. `informe_pdf`:
   - mantener juntas cabecera, titulo y primera fila de cada bloque, al menos
     en Seguridad Electrica;
   - sustituir imagen/texto fijo del recuadro superior derecho por logo en
     `pdf_assets/qontrolmed/logo.png`.

## Nota operativa sobre maxgesth_port

No hace falta recompilar `maxgesth_port` solo por estos cambios de
`Qontrolmed`.

Si conviene volver a validar `maxgesth_port` cuando:

- se cambie codigo en ese repo;
- se quiera ejecutar la validacion E2E completa del contrato;
- se vaya a generar una APK o binario nuevo para pruebas de campo.

## Reordenacion de carpetas de intercambio

Se separo `output/export_tablet` por dominio y sentido del flujo para evitar
mezclar exports maestros con resultados de campo:

```text
output/export_tablet/
  preventivos/
    desktop_a_tablet/
    tablet_a_desktop/
  quirofanos/
    desktop_a_android/
    android_a_desktop/
```

Uso actual en codigo:

- `Qontrolmed` Preventivos exporta maestros a
  `output/export_tablet/preventivos/desktop_a_tablet/`
- `Qontrolmed` Preventivos importa resultados desde
  `output/export_tablet/preventivos/tablet_a_desktop/`
- `Qontrolmed` Quirofanos exporta a
  `output/export_tablet/quirofanos/desktop_a_android/`
- `Qontrolmed` Quirofanos importa desde
  `output/export_tablet/quirofanos/android_a_desktop/`

Limpieza aplicada:

- se movieron los JSON antiguos de Preventivos a `preventivos/desktop_a_tablet/`;
- se movio el JSON antiguo de Quirofanos a `quirofanos/desktop_a_android/`;
- la raiz `output/export_tablet/` quedo solo con carpetas de primer nivel.
