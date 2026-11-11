# Especificacion: modulo Analitico y campanas de preventivos

Fecha de adopcion en este proyecto: 2026-05-28

## Objetivo

Definir la evolucion del modulo Analitico de `Qontrolmed` (`maxgesth`) y fijar la base de
campanas necesaria para que los informes preventivos puedan analizarse sin
perder historico ni depender de que los equipos importados desde GMAO sigan
presentes en la campana actual.

Esta especificacion complementa:

- `docs/02_planes_y_arquitectura/especificaciones/criterios_transversales_capas.md`
- `docs/02_planes_y_arquitectura/especificaciones/remote_tablet_preventivos.md`

## Decision de arquitectura

El modulo Analitico debe nacer como modulo tecnico independiente, con carpeta
propia:

```text
src/Analitico/
```

La primera estructura objetivo sera:

```text
src/Analitico/
  __init__.py
  services/
    __init__.py
    preventivos_analytics_service.py
    quirofanos_analytics_service.py
  ui/
    __init__.py
    preventivos_analytics_ui.py
    quirofanos_analytics_ui.py
  reports/
    __init__.py
```

Aunque la logica viva en `Analitico`, el acceso inicial debe estar integrado en
los menus de cada dominio:

- Preventivos: boton `Analitica preventivos` o `Informe estadistico`.
- Quirofanos: boton `Informe estadistico`.
- Libro de quirofano: opcion para incluir resumen final cuando proceda.

No se crea de inicio un menu principal `Analitico`, porque para trabajo tecnico
anade navegacion innecesaria. Ese menu queda como evolucion futura para perfiles
administrativos o direccion, cuando exista una vista transversal consolidada.

## Principios del modulo Analitico

- El modulo Analitico solo consulta y compone datos; no debe modificar informes
  ni estados operativos.
- Las consultas de negocio deben vivir en servicios, no en pantallas.
- Las pantallas solo deben recoger filtros, lanzar consultas y mostrar o exportar
  resultados.
- Los informes PDF/Excel deben generarse a partir de estructuras ya preparadas
  por servicios analiticos.
- Las metricas deben ser reproducibles: mismo filtro, mismo resultado.
- Cualquier KPI que dependa de una regla de estado debe reutilizar el criterio
  del dominio correspondiente.

## Preventivos: problema previo

La importacion desde GMAO trabaja actualmente contra `equipos_gmao` por
inventario, actualizando o insertando equipos activos. Si un equipo desaparece
de una importacion posterior y se elimina fisicamente, los informes historicos
quedan en riesgo porque referencian `informes_preventivo.id_equipo_gmao`.

Por tanto, no se debe usar el borrado fisico de equipos GMAO como forma normal
de limpiar la lista de trabajo de una campana.

La lista de equipos a revisar debe depender de campanas, no de borrar o perder
maestros historicos.

## Modelo real de campanas preventivas

Segun la estructura actual aportada el `2026-05-28`, la base ya contiene una
tabla de campanas preventivas con estos campos funcionales:

```sql
campanas_preventivo.id
campanas_preventivo.nombre
campanas_preventivo.anio
campanas_preventivo.mes
campanas_preventivo.fecha_creacion
campanas_preventivo.activo
```

La tabla `informes_preventivo` ya contiene `id_campana`, por lo que no debe
anadirse de nuevo.

El hueco a cubrir es la relacion explicita entre campana y equipos importados
desde GMAO:

```sql
CREATE TABLE campana_equipos_preventivo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_campana INT NOT NULL,
    id_equipo_gmao INT NOT NULL,
    presente_en_importacion TINYINT(1) NOT NULL DEFAULT 1,
    fecha_importacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_campana_equipo (id_campana, id_equipo_gmao),
    CONSTRAINT fk_cep_campana
        FOREIGN KEY (id_campana) REFERENCES campanas_preventivo(id),
    CONSTRAINT fk_cep_equipo
        FOREIGN KEY (id_equipo_gmao) REFERENCES equipos_gmao(id)
);
```

Cuando el esquema real lo permita, `informes_preventivo.id_campana` deberia
quedar indexado y referenciado a `campanas_preventivo(id)`, pero esto debe
comprobarse antes con `SHOW CREATE TABLE informes_preventivo`.

## Reglas de campana

1. Siempre debe existir una campana activa antes de importar GMAO o exportar
   datos a tablet.
2. La importacion GMAO de una campana no borra equipos historicos.
3. Si el equipo ya existe por inventario, se actualizan sus datos maestros y se
   vincula a la campana activa.
4. Si el equipo no existe, se crea y se vincula a la campana activa.
5. Si un equipo no aparece en una importacion posterior, puede quedar fuera de
   la campana activa o marcado como no presente, pero no debe eliminarse si tiene
   informes.
6. Al crear o editar informes preventivos desde la pantalla operativa se debe
   seleccionar primero una campana de trabajo. Solo deben ofrecerse campanas con
   informes abiertos o equipos importados sin informe creado.
7. Al crear un informe preventivo, se debe asignar la campana de trabajo
   seleccionada.
7.bis. La unicidad operativa del informe se controla por `id_equipo_gmao` +
   `id_campana`; un informe abierto en otra campana no debe bloquear la
   creacion en la campana seleccionada.
8. Al importar desde tablet, el informe debe conservar `id_campana` si viene en
   el fichero; si no viene, se usa la campana activa como fallback controlado.
9. Los conflictos de importacion se resuelven por equipo y campana.
10. El historico y las analiticas deben filtrar por campana cuando exista.
11. Los selectores de tipologia de equipo deben mostrar la descripcion de
    `tipos_equipo`, usando `nombre` solo como respaldo tecnico.

## KPIs preventivos prioritarios

El primer informe general debe permitir filtrar por:

- Campana.
- Tipologia seleccionada o todas.
- Rango de fechas si procede.

KPIs iniciales:

- Numero de preventivos por tipologia.
- Numero total de incidencias.
- Cerrados, con incidencias, no aptos y pendientes.
- Preventivos lanzados pendientes de cierre por tipologia.
- Distribucion de estados al cierre de la campana actual.
- Evolucion anual con limite recomendado de cinco campanas/anios.

KPIs individuales por equipo:

- Fechas de cierre.
- Evolucion de estados.
- Evolucion de numero de incidencias.
- Evolucion de campos cuantitativos con valores medidos.

La analitica individual solo aporta valor real cuando existan varias campanas
cerradas para el mismo equipo.

## KPIs quirofanos prioritarios

El informe estadistico de quirofanos debe permitir filtrar por:

- CECO o centro cuando el dato este disponible.
- Periodo.
- Quirofano.
- Ubicacion.

KPIs iniciales:

- Numero de quirofanos medidos en el periodo.
- Numero total de incidencias.
- Incidencias por quirofano.
- Incidencias agrupadas por ubicacion.
- Puntos de control con mas incidencias.
- Evolucion mensual de incidencias.
- Evolucion de campos con `valor_medido` numerico.
- Estado de calibracion de equipos de medida usados.

En el libro de quirofano se podra anadir una hoja o bloque resumen final con:

- Numero de incidencias.
- Evolucion de campos con valores.
- Relacion de puntos repetidos con incidencias.

## Plan de trabajo inmediato

1. Cerrar incidencias puntuales de Preventivos que afecten a estabilidad,
   importacion GMAO, PDF o trazabilidad.
2. Crear la estructura `src/Analitico/` sin conectar todavia demasiada UI.
3. Implementar servicios analiticos de solo lectura.
4. Crear o consolidar migracion SQL documentada para campanas preventivas y su
   relacion con equipos.
5. Ajustar importacion GMAO para vincular equipos a campana activa.
6. Ajustar exportacion a tablet para incluir campana en metadatos y datos.
7. Ajustar importacion desde tablet para exigir o resolver campana de forma
   explicita.
8. Crear primera pantalla de analitica preventivos dentro del menu Preventivos.
9. Hacer una revision funcional de Quirofanos antes de abrir su analitica de
   escritorio.
10. Crear primera pantalla de analitica quirofanos dentro del menu Quirofanos.

## Plan futuro

1. Crear menu principal `Analitico` si se habilitan perfiles administrativos o
   direccion.
2. Preparar instalacion modular por dominios: Compras, Preventivos, Quirofanos,
   Analitico.
3. Crear registro central de modulos disponibles y activos.
4. Generar informes PDF/Excel con graficas consolidadas.
5. Anadir comparativas de hasta cinco anios/campanas.
6. Anadir analitica individual de equipos con varias campanas cerradas.
7. Incorporar permisos por rol para separar operativa tecnica de vision
   administrativa.
8. Preparar paquetes de salida orientados a piloto o produccion con evidencias
   de validacion y criterios de soporte.

## Validaciones minimas

Antes de dar por cerrado cualquier cambio de esta linea:

- `python -m compileall main.py src`
- Crear o seleccionar campana activa.
- Importar GMAO y comprobar que no se borran equipos historicos.
- Crear informe y comprobar que queda asociado a campana.
- Exportar a tablet e importar resultados con campana.
- Generar resumen analitico con una tipologia y con todas.
- Verificar que los conteos de cerrados, pendientes, incidencias y no aptos
  coinciden con una consulta manual de contraste.
