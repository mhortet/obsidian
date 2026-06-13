# Estado de continuidad
[[masgesth]]
Fecha: 2026-06-12

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
  - primer corte funcional `CECOS -> Centros` en `Gestion`, `Usuarios` y
    portada, con compatibilidad sobre esquema legacy y migracion SQL
    documentada para ampliar el maestro;
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
- Avance confirmado el 2026-06-12 en el retorno al roadmap transversal:
  - `Gestion/Centros` ya tiene un primer corte compatible con la tabla tecnica
    `cecos`;
  - la pantalla de mantenimiento detecta si la BD sigue en modo legacy y, en
    ese caso, limita el alta/edicion a nombre y estado sin autoajustes de
    esquema;
  - si la BD ya dispone de los nuevos campos, la misma pantalla habilita
    direccion, contactos, mantenimiento, referencia documental y
    observaciones;
  - tras validacion manual de UI, se reajusta la maquetacion de contactos y
    telefonos para dar mas anchura a los nombres de contacto y bajar los
    telefonos a una fila propia;
  - `documentacion_ref` deja de presentarse como caja de texto simple y pasa a
    usarse desde la UI como selector de archivo enlazado al centro;
  - tras nuevas verificaciones de usuario, la validacion del maestro se
    endurece para exigir 9 digitos en todos los telefonos y formato valido en
    correos electronicos;
  - el guardado y el cambio de estado del centro recuperan el foco en la
    propia ventana tras el emergente de exito, evitando salto al menu
    principal;
  - queda creada la migracion `docs/migracion_centros_gestion.sql` como paso
    explicito para evolucionar el maestro sin tocar runtime.
- Excepcion activa de esta sesion:
  - correccion de campo en Preventivos para preparar campana real con 144
    desfibriladores.
- Cambio de prioridad operativa acordado al cierre del 2026-06-12:
  - antes de abrir `roles/permisos` avanzados, se lanza la preparacion del
    upgrade de `MySQL 8.0.44` a `MySQL 8.4 LTS`;
  - el primer entregable inmediato de esa linea no es codigo de negocio sino
    backup verificado, restauracion de prueba y checklist de ejecucion.
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
  - a fecha 2026-06-11, la cola incorpora dos nuevos paquetes de ergonomia de
    escritorio centrados en `informe_preventivo_ui` y `pc_preventivos_ui`,
    ambos con severidad provisional `media`;
  - en `maxgesth` ya queda implementado sobre datos de prueba:
    - mantenimiento de filtro y orden en `Puntos de control preventivo`;
    - carga de referencia editable por informe para `DESF-Q01` a `DESF-Q08`
      usando persistencia en `resultados_preventivo` y sin sobrescribir el
      maestro de `puntos_control`;
    - busqueda de equipo por inventario o numero de serie en
      `informe_preventivo_ui`;
    - coherencia del limite visual y del PDF con la referencia guardada por
      informe cuando exista;
    - paquete de ergonomia de cabecera y flujo en `informe_preventivo_ui` con
      selector complementario por serie, atajo `N` para `NA`, estado visual de
      ciclo de vida y logo en cabecera;
    - paquete de ergonomia en `pc_preventivos_ui` con busqueda viva, avance
      con `Enter` y logo en cabecera;
    - validacion manual en sobremesa ya completada para ambos paquetes de
      ergonomia, incluyendo flujo `NA -> Enter -> siguiente punto` en
      cuantitativos;
  - criterio operativo vigente: mientras no haya volumen significativo de
    evidencia, documentar primero y no abrir correctivo de codigo salvo
    recurrencia clara o bloqueo real de operativa.

## Tarea recomendada de la proxima sesion

### Tarea principal recomendada

`Hardening transversal: siguiente escalon en roles y auditoria`

Objetivo inmediato:

- aprovechar que la base ya queda subida a `MySQL 8.4.9` para retomar el
  siguiente frente natural del roadmap;
- preparar el primer corte real de `roles` sobre `gestion.usuarios` sin romper
  la compatibilidad transitoria con `es_tecnico`;
- revisar el alcance minimo de `auditoria` ya implantada y decidir si la
  siguiente sesion abre consulta visible desde UI, ampliacion de eventos o
  consolidacion documental;
- mantener Preventivos escritorio solo en seguimiento pasivo salvo que aparezca
  una incidencia real nueva en la operativa.

Ataque recomendado:

1. cerrar documentalmente la ejecucion real del upgrade ya completado,
   incluyendo warning de Workbench y cambio de plugin de autenticacion;
2. revisar el estado actual de `usuarios`, `login`, `rol` y
   `auditoria_eventos` para elegir una pieza pequena y cerrable en una sesion;
3. priorizar como primer bloque:
   - visibilidad/control de rol en `Usuarios`, o
   - consulta minima de auditoria desde `Gestion`;
4. no reabrir cambios en `informe_preventivo_ui` ni `pc_preventivos_ui` salvo
   regresion reproducible o nueva necesidad de campo con evidencia.

Documentos operativos a usar:

- `docs/plan_upgrade_mysql_8_0_44_a_8_4_lts.md`
- `docs/checklist_ejecucion_upgrade_mysql_8_4_lts.md`
- `scripts/db/registrar_backup_mysql.ps1`

Tests a preparar para cerrar esa tarea:

- definirlos segun el frente exacto entre `roles` y `auditoria`;
- `python -m compileall main.py src`;
- validacion manual pendiente:
  - login con usuario administrador;
  - crear/modificar usuario o revisar consulta de auditoria segun el bloque
    elegido;
  - verificar que no se rompe la operativa actual basada en `es_tecnico`;
  - confirmar trazabilidad y naming visible en `Gestion`.

Checklist operativa recomendada para esta misma validacion:

1. Verificar base de datos:
   - verificado el 2026-06-13: servidor ya actualizado a `MySQL 8.4.9`;
   - decision operativa adoptada el 2026-06-12:
     - la version `8.0` no debia mantenerse como linea de evolucion futura;
     - la rama `8.0` ya no debe tomarse como linea objetivo de evolucion
       futura;
     - la version objetivo recomendada pasa a ser `MySQL 8.4 LTS`;
     - no se recomienda saltar ahora a `9.7 LTS` como primera evolucion del
       proyecto, porque `8.4 LTS` ofrece mejor equilibrio entre estabilidad,
       soporte prolongado y menor riesgo de compatibilidad para una aplicacion
       de escritorio Python con carga operativa sanitaria.
   - ejecucion real confirmada el 2026-06-13:
     - upgrade del servicio `MySQL80` completado por cambio manual de binario
       a `C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe`,
       manteniendo `my.ini` y `datadir` de `C:\ProgramData\MySQL\MySQL Server 8.0`;
     - `SELECT VERSION();` devuelve `8.4.9`;
     - la app vuelve a abrir correctamente tras ajustar el usuario
       `administrador@%` a `caching_sha2_password`;
     - criterio operativo aprendido: en futuras subidas a `MySQL 8.4+`,
       revisar siempre el `plugin` de los usuarios de aplicacion antes de dar
       por cerrada la validacion.
   - verificado el 2026-06-12: `docs/migracion_centros_gestion.sql` aplicada
     con columnas ampliadas presentes en `gestion.cecos`;
   - verificado el 2026-06-12 en `SHOW COLUMNS FROM gestion.cecos;`:
     `direccion`, `codigo_postal`, `ciudad`, `contacto_principal`,
     `telefono_principal`, `telefono_alternativo`, `correo_electronico`,
     `contacto_mantenimiento`, `telefono_mantenimiento`,
     `correo_mantenimiento`, `documentacion_ref`, `observaciones` y `activo`.
2. Verificar formulario `Gestion -> Centros`:
   - verificado el 2026-06-12 con usuario: apertura de la ventana y carga sin
     errores;
   - verificado el 2026-06-12 con usuario: modo ampliado correcto con
     contactos, telefonos, documento asociado, observaciones y avance por
     `Enter`;
   - verificado el 2026-06-12 con usuario: el selector de documento guarda la
     ruta elegida en `documentacion_ref`;
3. Verificar persistencia real:
   - verificado el 2026-06-12 con usuario: alta de centro de prueba
     reconocible;
   - verificado el 2026-06-12 con usuario: edicion del mismo centro cambiando
     contacto, telefono, correo y documento asociado;
   - verificado el 2026-06-12 con usuario: activar/desactivar desde la propia
     ventana;
   - verificado el 2026-06-12 con contraste SQL:
     - `idCECOS=709`
     - `Proyecto='Centro Prueba Validacion'`
     - `ciudad='Aqui mismo'`
     - `contacto_principal='Yo mismo'`
     - `telefono_principal='546859548'`
     - `correo_electronico='el_ismo@hola.com'`
     - `documentacion_ref=''`
     - `activo=1`
   - pendiente funcional diferida:
     - decidir si al activar/desactivar debe mantenerse el centro visible y
       seleccionado en pantalla o si el comportamiento actual de limpiar el
       formulario es el deseado;
     - estudiar una evolucion de `documentacion_ref` para soportar multiples
       documentos asociados por centro y no solo una ruta unica.
   Secuencia recomendada:
   - alta:
     - nombre: `Centro prueba validacion`
     - ciudad: valor corto reconocible
     - contacto principal: valor reconocible
     - telefono principal: 9 digitos validos
     - correo electronico: cuenta de prueba con formato correcto
   - edicion:
     - cambiar contacto principal;
     - cambiar telefono principal;
     - cambiar correo electronico;
     - seleccionar un documento distinto o quitarlo;
   - comprobacion SQL:
     - `SELECT idCECOS, Proyecto, ciudad, contacto_principal, telefono_principal, correo_electronico, documentacion_ref, activo FROM gestion.cecos WHERE Proyecto = 'Centro prueba validacion';`
   - criterio de exito:
     - los datos editados coinciden con lo mostrado en UI;
     - `activo` cambia entre `1` y `0` al activar/desactivar;
     - `documentacion_ref` refleja la ruta esperada o queda vacio si se ha quitado.
4. Verificar impacto transversal minimo:
   - verificado el 2026-06-12 con usuario: `Gestion -> Usuarios` y portada
     principal mantienen naming funcional `Centro/Centros`;
   - verificado el 2026-06-12 con usuario: ajuste visual del texto superior de
     `Gestion` a `Acceso a maestros, operativa de compras e importacion de historicos`;
   - decision documentada:
     - los centros inactivos no deben salir en selectores; no se abre cambio
       adicional en Preventivos por este motivo;
     - Quirofanos queda diferido para una revision especifica de ese modulo y
       no condiciona el cierre de esta tanda de `Centros`.

### Tarea alternativa valida

`Seguimiento pasivo de Preventivos escritorio`

Objetivo inmediato:

- intervenir solo si reaparece una incidencia real en `Preventivos` escritorio
  tras la tanda ya cerrada;
- en ausencia de nueva evidencia, no consumir otra sesion en ergonomia ya
  validada.

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

### Base de datos y versionado del servidor

- verificado el 2026-06-13: el servidor actual del entorno queda ya en
  `MySQL 8.4.9`;
- revisar compatibilidad de sintaxis antes de ejecutar nuevas migraciones de
  `gestion`, en especial `docs/migracion_centros_gestion.sql`;
- decision operativa adoptada el 2026-06-12:
  - fijar `MySQL 8.4 LTS` como version objetivo recomendada para la siguiente
    evolucion controlada del servidor;
  - no priorizar por ahora un salto inicial a `9.7 LTS`, salvo que en otra
    revision aparezca una necesidad tecnica concreta que lo justifique.
- criterio de calendario:
  - la subida de servidor deja de ser pendiente y pasa a fase de
    estabilizacion ligera;
  - ya puede retomarse `roles/permisos` avanzados como siguiente frente
    principal, evitando mezclar en la misma ventana nuevas incidencias de
    infraestructura;
  - mantener `auditoria` documental o minima si ayuda a cerrar el frente sin
    ensanchar de golpe la matriz de permisos.
- cierre documental:
  - la comprobacion de version queda resuelta;
  - queda registrada evidencia de backup logico base el `2026-06-12` sobre
    `D:\Copias Seguridad\Proyectos\bd\Completa`, con manifest y hashes en
    `output/backup_mysql/backup_manifest_2026-06-12_22-05-34.(md|csv)`;
  - queda creada copia congelada de trabajo en
    `E:\backup_mysql_2026-06-12_19-51_completa`, destinada a restauracion de
    prueba y validacion previa al upgrade;
  - la evidencia actual cubre `gestion`, `quirofanos` y `preventivos`, con
    frescura validada dentro de la ventana prevista;
  - validacion operativa confirmada por usuario el `2026-06-12`:
    - el patron de export/restauracion ya se habia ejecutado con exito varias
      veces entre equipos para trabajo fuera de sede;
    - en esta misma tarde se ha repetido al menos tres veces por cada base;
    - la app abre correctamente tras la restauracion y los datos esperados
      quedan presentes;
    - dado que el contenido actual es ficticio y previo a pruebas de campo
      reales, el riesgo principal deja de ser la perdida de datos y pasa a ser
      la compatibilidad tecnica del servidor y del esquema.
  - cierre tecnico confirmado el 2026-06-13:
    - el configurador de MySQL no detecto la instancia existente como
      `in-place upgrade` y la trato como configuracion nueva;
    - se resolvio reapuntando manualmente el servicio `MySQL80` al binario
      `8.4`, manteniendo configuracion y datos existentes;
    - tras el upgrade, la app fallo inicialmente con
      `Plugin 'mysql_native_password' is not loaded`;
    - la causa fue el usuario `administrador@%` aun ligado a
      `mysql_native_password`;
    - la resolucion fue migrarlo a `caching_sha2_password`, quedando la app
      operativa de nuevo;
    - `MySQL Workbench 8.0.44` abre contra `8.4.9` con warning de
      compatibilidad, pero permite continuar; queda recomendado actualizar
      Workbench cuando se abra otra ventana de mantenimiento.
  - la validacion funcional de `Centros` ya no queda bloqueada por falta de
    visibilidad sobre la version del servidor;
  - el nuevo pendiente real vuelve a ser funcional: retomar
    `roles/auditoria` sobre una base ya estabilizada en `8.4.9`.

### Roles

- decision funcional adoptada:
  - crear por defecto un primer rol `superusuario` con poderes plenos;
  - este rol sera quien pueda crear nuevos roles y asignar permisos por
    seleccion explicita tipo `checking`;
  - en la futura instalacion o primer arranque guiado, debe obligarse la
    creacion de ese `superusuario` con contrasena valida antes de dar la app
    por operativa;
  - mantener compatibilidad transitoria con el esquema actual mientras no exista
    el modelo completo de roles, usando `es_tecnico` solo como puente tecnico y
    no como contrato final de autorizacion.
- fuente viva de diseno:
  - `docs/propuesta_modelo_roles_permisos.md` fija el modelo objetivo
    `usuario -> rol -> permisos`, el bootstrap del `superusuario`, el catalogo
    inicial y el orden de implantacion.
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
- La version real del servidor de base de datos puede condicionar la sintaxis
  aceptable de futuras migraciones y debe revisarse antes de seguir ampliando
  `gestion.cecos`.
- `cecos` sigue siendo demasiado pobre para operar como maestro maduro de
  centros.
- Preventivos y Quirofanos pueden seguir revelando incidencias de campo, pero no
  deben arrastrar el roadmap salvo severidad alta o bloqueante.
