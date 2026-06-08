# Estado de continuidad
[[masgesth]]
Fecha: 2026-06-08

Este documento es la foto viva del estado actual del proyecto conjunto. Debe
permitir reabrir trabajo sin depender del chat anterior y sin competir con el
roadmap maestro.

Nota de naming:

- El nombre comercial del escritorio es `Qontrolmed`.
- Los nombres tecnicos de repositorio y ruta siguen siendo `maxgesth`,
  `maxgesth_port` y `maxgestq_mov` hasta una migracion separada.
- `Gestion` sera el nombre funcional del modulo hoy llamado tecnicamente
  `Compras`.
- `Centros` sera el nombre funcional del maestro hoy apoyado en la tabla
  tecnica `cecos`.

## Entrada canonica de sesion

Leer siempre antes de elegir tarea:

1. `docs/security_delivery_playbook.md`
2. `docs/estado_continuidad.md`
3. `docs/plan_seguridad_consistencia.md`
4. `docs/mapa_documental_proyecto.md`

Despues revisar `git status --short --branch` en:

- `D:/trabajo/Proyectos/maxgesth`
- `D:/trabajo/Proyectos/maxgesth_port`
- `D:/trabajo/Proyectos/maxgestq_mov`

Y crear o actualizar el parte externo de sesion en:

- `D:\trabajo\Proyectos\diario_qontrolmed\sesion_YYYY-MM-DD_HH-mm.md`

## Topologia actual del proyecto

- `maxgesth` / `Qontrolmed`: aplicacion matriz de escritorio y centro
  documental vivo del proyecto.
- `maxgesth_port`: tablet offline para Preventivos, con SQLite local y flujo de
  import/export contra `Qontrolmed`.
- `maxgestq_mov`: tablet offline para revisiones IT de Quirofanos, con contrato
  de datos propio frente a `Qontrolmed`.

## Ramas activas y suciedad local relevante

### maxgesth

- Rama actual: `fix-trabajo-campo`
- Base de trabajo: `main` alineado con `origin/main` al abrir esta rama en esta
  sesion
- Cambios locales visibles:
  - ajustes en exportacion de Preventivos para trabajo de campo;
  - trazabilidad de exportado/descargado tablet preparada en escritorio sobre
    `campana_equipos_preventivo`;
  - primer corte visual `Compras -> Gestion` en portada y entrada del modulo;
  - selector cerrado `MAX/MIN` en puntos preventivos;
  - documentacion viva de sesion y continuidad en revision.

Lectura operativa:

- la sesion actual ya sale de `main` y trabaja en rama correctiva aislada;
- el frente activo de hoy es `fix-trabajo-campo`, centrado en exportacion
  Preventivos y contrato con tablet;
- el hub real del proyecto sigue siendo `Qontrolmed`.

### maxgesth_port

- Rama actual: `fix-trabajo-campo`
- Cambios locales visibles:
  - soporte de importacion para `tecnico_asignado`;
  - soporte de importacion para `clase_seguridad` del equipo;
  - uso de ambos datos como valores por defecto en la UI de informe.

Lectura operativa:

- esta rama debe validarse con un export real desde `maxgesth` antes de cerrar;
- esta rama ya estaba preparada para tecnico y clase por defecto; la trazabilidad
  de exportado/descargado queda resuelta en `maxgesth` sobre
  `campana_equipos_preventivo`, pendiente de migracion en la BD real si aun no
  se ha ejecutado `docs/migracion_tablet_tracking_preventivos.sql`.

### maxgestq_mov

- No revisado en detalle en esta sesion.
- Mantenerlo en compatibilidad contractual y de campo salvo incidencia real.

## Estado funcional que importa ahora

- Preventivos esta operativamente bastante cerrado y debe quedar en
  mantenimiento correctivo guiado por pruebas reales.
- Quirofanos tambien entra en mantenimiento correctivo guiado por campo, tras la
  ultima tanda de ajustes de UI, PDF, libro e historico.
- El foco principal deja de ser ampliar funcionalidad en esos modulos y pasa a:
  - endurecimiento transversal;
  - acceso y permisos;
  - auditoria;
  - maestros y nomenclatura funcional;
  - persistencia madura;
  - readiness de produccion.
- Excepcion activa de esta sesion:
  - correccion de campo en Preventivos para preparar campana real con 144
    desfibriladores.

## Tarea recomendada de la proxima sesion

### Tarea principal recomendada

`Cerrar y validar fix-trabajo-campo en Preventivos + tablet`

Objetivo inmediato:

- validar export real de Preventivos con tecnico asignado;
- comprobar que la tablet recibe `clase_seguridad` por equipo y la propone
  correctamente al abrir informe;
- comprobar que la tablet usa el tecnico asignado del paquete como valor por
  defecto de informe;
- continuar con:
  - validacion real de la nueva trazabilidad `exportado/descargado`;
  - revision de seguridad en exportaciones parciales de la misma campana;
  - `NA` manual solo para cuantitativos.

Ataque recomendado:

1. generar un JSON real desde `maxgesth` con tipologia y tecnico seleccionados;
2. importarlo en `maxgesth_port` y verificar equipo, clase y tecnico por
   defecto;
3. si el contrato queda estable, ejecutar y validar la migracion de
   trazabilidad tablet en la BD real;
4. dejar anotadas las reglas definitivas de `valor_referencia` para
   desfibriladores antes de tocar mas evaluacion automatica.

Tests a preparar para cerrar esa tarea:

- `python -m py_compile src\preventivos\services\export_preventivos_service.py src\preventivos\main_preventivos.py src\preventivos\ui\pc_preventivos_ui.py`
- `python -m py_compile src\data\schema.py src\services\import_service.py src\services\report_service.py src\ui\report_page.py`
- validacion manual de export/import real `maxgesth -> maxgesth_port`.

### Tarea alternativa valida

`Gestion: renombrado funcional y ampliacion de Centros`

Objetivo inmediato:

- completar el renombrado visual `Compras -> Gestion` en pantallas de entrada y
  decidir la arquitectura futura del menu del modulo;
- preparar migracion documentada para ampliar `cecos` y convertirlo
  funcionalmente en `Centros`;
- revisar el maestro de equipos de medida como base comun entre dominios.

## Tabla minima de arranque de sesion

Cada sesion debe arrancar dejando claro:

| Campo | Valor esperado |
| --- | --- |
| Tarea principal | frente elegido del roadmap |
| Tarea alternativa | trabajo preparado si aparece bloqueo |
| Tests exigibles | comandos concretos de cierre |
| Validacion manual esperada | prueba funcional o visual pendiente |
| Dependencias | repos, migraciones, documentos o contratos afectados |

## Comprobaciones previas antes de tocar codigo

- confirmar si la tarea toca un solo repo o un flujo compartido;
- identificar cambios ajenos ya presentes en el repo afectado;
- decidir si hace falta abrir rama en `maxgesth`;
- confirmar que no se van a mezclar limpieza, documentacion y funcionalidad en
  el mismo commit;
- dejar anotados los tests que cerraran la tarea antes de programar;
- revisar si hay autoajustes de schema en tiempo de ejecucion que deban pasar a
  migracion documentada.

## Pendientes de informacion abiertos

### Configuracion de cliente

- mecanismo final de instalacion y distribucion;
- ubicacion final de credenciales y parametros de conexion;
- si habra asistente inicial o fichero de configuracion gestionado.

### Roles

- decision operativa vigente:
  - solo `Administrador` y `Tecnico`;
  - sin permisos finos por usuario en esta fase;
  - si no existe columna `rol`, usar `es_tecnico = 1` como tecnico y
    `es_tecnico = 0` como administrador;
- matriz exacta de acciones por rol;
- si en una fase posterior hacen falta permisos por rol o excepciones por
  usuario.

### Auditoria

- politica de retencion;
- si habra consulta o exportacion de logs desde UI;
- alcance exacto de impresion y reimpresion en todos los modulos.

### Centros

- confirmacion final del conjunto de campos;
- validaciones obligatorias de contacto o formato.

### Informes y analitica

- destinatario real de cada informe;
- diseno y filtros finales;
- prioridad relativa frente a salida a produccion.

### Mobile

- que incidencias de campo escalan a bloqueante;
- cuales quedan como mejora acumulada.
- confirmar si la validacion de `maxgesth_port` en movil se hara por `APK` como
  flujo principal o si merece la pena seguir invirtiendo tiempo en preview
  Flet por QR/web dentro de este entorno.

## Riesgos abiertos

- `maxgesth` sigue acumulando trabajo relevante sobre `main`.
- La documentacion viva debe mantenerse alineada con este roadmap unico para no
  volver a duplicar backlog.
- El login actual puede seguir teniendo criterios aceptables para desarrollo
  pero no para piloto o produccion.
- Roles, auditoria y migraciones documentadas siguen siendo deuda central.
- `cecos` sigue siendo demasiado pobre para operar como maestro maduro de
  centros.
- Preventivos y Quirofanos pueden seguir revelando incidencias de campo, pero no
  deben arrastrar el roadmap salvo severidad alta o bloqueante.
