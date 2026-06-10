# Estado de continuidad
[[masgesth]]
Fecha: 2026-06-09

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
  - `NA` manual habilitado tambien en cuantitativos, manteniendolo en
    cualitativos y seguridad;
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
- Cierre validado en esta misma linea:
  - el flujo `maxgesth -> maxgesth_port` ya ha quedado validado en terminal
    real para tecnico asignado y clase o tipo de equipo por defecto;
  - a falta de nueva evidencia de campo, este frente deja de ser tarea abierta
    de implementacion inmediata y pasa a observacion.
- Contexto operativo confirmado el 2026-06-10:
  - la campana real en curso esta funcionando;
  - todos los informes reales de esa campana viven actualmente en movil;
  - los informes cargados en sobremesa se estan usando como datos ficticios de
    prueba;
  - las nuevas observaciones abiertas deben tratarse como mejoras para futuras
    cargas en dispositivos moviles, no como correctivos urgentes de la campana
    activa.
  - el criterio operativo vigente de exportacion `sobremesa -> movil` no debe
    cambiarse por ahora: la campana se carga completa desde `equipos_gmao`
    para trabajarla en movil, o bien se trabaja fuera de movil con papel y
    sobremesa;
  - la observacion abierta sobre evitar reenvios repetidos afecta al flujo
    `movil -> sobremesa` por bloques de informes ya enviados, no al armado
    inicial de la campana en escritorio.
  - durante esta sesion se ha decidido dejar fuera cambios en app movil y
    centrar el correctivo solo en sobremesa.

## Cola operativa de campo

- documento de trabajo: `docs/cola_triaje_campo.md`;
- uso previsto:
  - volcar incidencias y mejoras detectadas en uso real;
  - clasificarlas antes de convertirlas en cambios de codigo;
  - evitar abrir correctivos prematuros por observaciones aisladas.
- estado actual:
  - no hay bloqueo confirmado abierto en Preventivos tablet tras la validacion
    real del 2026-06-09;
  - ya hay una primera tanda de cinco observaciones documentadas en
    `docs/cola_triaje_campo.md`;
  - a fecha 2026-06-10, la cola incorpora cuatro mejoras adicionales
    orientadas a futuras cargas moviles y no a resolver un fallo de la
    campana viva;
  - en `maxgesth` ya queda implementado sobre datos de prueba:
    - mantenimiento de filtro y orden en `Puntos de control preventivo`;
    - carga de referencia editable por informe para `DESF-Q01` a `DESF-Q08`
      usando persistencia en `resultados_preventivo` y sin sobrescribir el
      maestro de `puntos_control`;
    - busqueda de equipo por inventario o numero de serie en
      `informe_preventivo_ui`;
    - coherencia del limite visual y del PDF con la referencia guardada por
      informe cuando exista;
  - criterio operativo vigente: mientras no haya volumen significativo de
    evidencia, documentar primero y no abrir correctivo de codigo salvo
    recurrencia clara o bloqueo real de operativa.

## Tarea recomendada de la proxima sesion

### Tarea principal recomendada

`Triage de incidencias de campo y retorno al roadmap transversal`

Objetivo inmediato:

- seguir volcando en `docs/cola_triaje_campo.md` las incidencias o mejoras
  acumuladas en el siguiente bloque de pruebas reales;
- clasificar cada entrada como `bloqueante`, `alta`, `media` o `mejora`;
- decidir si alguna incidencia merece rama correctiva inmediata solo cuando ya
  exista recurrencia o volumen significativo y, si no, mantener el roadmap en
  endurecimiento transversal y maestros;
- si no aparece nada `bloqueante` o `alta`, retomar `Gestion`, `Centros`,
  `roles` y `auditoria` como linea principal.

Ataque recomendado:

1. revisar primero `docs/cola_triaje_campo.md` y completar el detalle de las
   nuevas observaciones de campo y confirmar si las ya documentadas se repiten
   o fueron aisladas;
2. confirmar si la trazabilidad `exportado/descargado` en la BD real ya quedo
   ejecutada y validada;
3. validar manualmente en sobremesa con informes ficticios:
   - referencia editable y persistida en `DESF-Q01` a `DESF-Q08`;
   - salto al siguiente punto tras `Enter`;
   - busqueda por numero de serie;
   - coherencia del PDF con la referencia guardada;
4. abrir nuevo correctivo solo si la severidad de campo o la validacion local
   detectan un desajuste real;
5. si no aparece ese desajuste, volver al frente transversal ya recomendado en
   el roadmap maestro.

Tests a preparar para cerrar esa tarea:

- no fijar tests de codigo hasta que exista incidencia concreta priorizada;
- mantener como prueba base disponible la validacion manual real
  `maxgesth -> maxgesth_port` si aparece una regresion en ese flujo.

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

- decision funcional adoptada:
  - crear por defecto un primer rol `superusuario` con poderes plenos;
  - este rol sera quien pueda crear nuevos roles y asignar permisos por
    seleccion explicita tipo `checking`;
  - mantener compatibilidad transitoria con el esquema actual mientras no exista
    el modelo completo de roles, usando `es_tecnico` solo como puente tecnico y
    no como contrato final de autorizacion.
- permisos base a contemplar en la primera matriz:
  - `acceso_total`;
  - `borrar_informes` como permiso explicito y separado, aunque el
    `superusuario` lo tenga concedido por defecto;
  - acceso a todos los CRUD de la aplicacion;
  - crear informes;
  - ver informes;
  - rellenar o modificar informes;
  - cerrar informes;
  - imprimir informes;
  - importar campanas;
  - exportar e importar trabajo de campo;
  - ampliaciones futuras sin romper el modelo.
- criterio de implantacion:
  - no dejar permisos destructivos implicitos dentro de roles intermedios;
  - cualquier visibilidad o accion sensible debe colgar del permiso asociado y
    no solo del nombre del rol.

### Auditoria

- decision funcional adoptada:
  - si habra acceso desde UI para consulta y exportacion documental de logs;
  - ese acceso quedara restringido a roles de alto nivel;
  - la interfaz vivira en la nueva seccion de `Gestion` y solo sera visible si
    el usuario dispone del rol o permiso correspondiente.
- pendientes que siguen abiertos:
  - politica de retencion;
  - alcance exacto de impresion y reimpresion en todos los modulos.

### Centros

- decision funcional adoptada:
  - el maestro tecnico `cecos` debe evolucionar funcionalmente a `Centros`;
  - ademas de los campos actuales, la ampliacion minima debe incluir:
    - direccion completa del centro o CECO;
    - codigo postal;
    - ciudad;
    - persona de contacto;
    - telefono principal;
    - telefono alternativo;
    - correo electronico;
    - contacto de mantenimiento con nombre, telefono y correo electronico;
    - observaciones;
    - subida o vinculacion de documentos;
    - cualquier dato operativo adicional que resulte necesario para el trabajo
      real dentro de la app.
- criterio de modelado:
  - separar claramente datos del centro, datos del contacto principal y datos
    del contacto de mantenimiento;
  - preparar validaciones de formato para telefonos, correo y completitud
    minima antes de llevarlo a produccion.

### Informes y analitica

- destinatario real de cada informe;
- diseno y filtros finales;
- prioridad relativa frente a salida a produccion.

### Mobile

- que incidencias de campo escalan a bloqueante;
- cuales quedan como mejora acumulada.
- decision operativa adoptada:
  - la validacion principal de `maxgesth_port` en movil se hara por compilacion
    `APK`, descarga e instalacion en terminal real;
  - el preview Flet por web o QR deja de ser via prioritaria en este entorno,
    salvo que en otra sesion aparezca una necesidad concreta que lo justifique.

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
