# Estado de continuidad
[[masgesth]]
Fecha: 2026-06-14

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
  se ha ejecutado `bd/migraciones/migracion_tablet_tracking_preventivos.sql`.

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
  - queda creada la migracion `bd/migraciones/migracion_centros_gestion.sql` como paso
    explicito para evolucionar el maestro sin tocar runtime.
- Avance confirmado el 2026-06-13 en `roles/permisos`:
  - ya existe pantalla operativa de `Roles` en `Gestion/Seguridad` con alta,
    edicion, desactivacion y asignacion de permisos por modulo;
  - `Usuarios` ya asigna rol y no permisos directos;
  - ya queda endurecido el aislamiento de `superusuario` para que solo otro
    `superusuario` pueda:
    - asignarlo;
    - retirarlo;
    - modificar una cuenta que ya lo tenga;
    - desactivar una cuenta que ya lo tenga;
  - la UI ya oculta `superusuario` del selector de rol cuando el operador no
    lo es, y el servicio bloquea igualmente cualquier intento directo;
  - queda ya resuelta la correccion transversal para impedir abrir varias
    instancias de la misma ventana si ya hay una abierta, al menos en la
    portada, menus principales y pantallas operativas maestras de
    `Gestion`, `Preventivos` y `Quirofanos`;
  - queda ampliada la matriz de permisos sobre `Preventivos` y `Quirofanos`
    con control visible y funcional por permiso, incluyendo acceso a modulo,
    menus, historicos, libro, mantenimiento y flujos de informe.
- Avance confirmado el 2026-06-13 en endurecimiento transversal de ventanas y
  permisos:
  - creado helper comun `src/compartido/utils/window_manager.py`;
  - las ventanas ya abiertas recuperan foco en lugar de duplicarse en los
    accesos principales y pantallas no modales cubiertas;
  - la portada principal ya filtra modulos visibles segun permisos reales del
    usuario;
  - `Preventivos` ya distingue entre:
    - consulta de informes;
    - edicion;
    - cierre;
    - impresion;
    - import/export y mantenimiento;
  - `Quirofanos` ya distingue entre:
    - consulta de informes;
    - edicion;
    - cierre;
    - impresion;
    - libro;
    - import/export Android;
    - mantenimiento y plantillas en blanco;
  - validacion tecnica completada con `python -m compileall main.py src`.
- Validacion manual confirmada el 2026-06-14 sobre hardening transversal:
  - smoke test manual completado con perfiles amplios y restringidos sobre
    `Gestion`, `Preventivos` y `Quirofanos`;
  - el control visible y funcional por permisos se comporta como se esperaba en
    las pruebas ejecutadas;
  - la regla de ventana unica queda verificada en las pantallas principales
    cubiertas, sin duplicidad ni salto de foco al menu principal;
  - en `Quirofanos` queda confirmada tambien la recuperacion de foco al volver
    de los selectores de ruta de import/export;
  - no aparece bloqueo funcional nuevo ni regresion clara sobre la operativa
    legacy basada en `es_tecnico`.
- Remate visual confirmado el 2026-06-14 sobre modo consulta:
  - `Informe preventivo` e `Informes Quirofanos` ya resaltan `Modo lectura`
    en cabecera cuando el usuario abre la pantalla sin permisos de
    modificacion;
  - con este ajuste queda rematado el bloque corto de UX asociado al smoke test
    de permisos y ventanas.
- Primer corte de auditoria confirmado en codigo el 2026-06-14:
  - `Preventivos` ya registra auditoria en:
    - `exportar_tablet`;
    - `importar_tablet`;
  - `Quirofanos` ya registra auditoria en:
    - `exportar_android`;
    - `importar_android`;
  - el registro cubre tanto resultado `ok/parcial` como errores de ejecucion o
    validacion temprana del fichero;
  - el `detalle` deja trazada la ruta de salida o entrada y el resumen tecnico
    de la operativa;
  - `usuario` y `fecha_hora` se mantienen en sus columnas propias de
    `auditoria_eventos`, sin duplicarlos dentro de `detalle`;
  - la validacion visual funcional de las 4 operativas de import/export ya
    queda completada;
  - validacion manual/SQL ya confirmada en `gestion.auditoria_eventos`:
    - `Preventivos/exportar_tablet`;
    - `Preventivos/importar_tablet`;
    - `Quirofanos/exportar_android`;
    - `Quirofanos/importar_android`;
  - la consulta minima ya queda abierta en `Gestion/Seguridad/Auditoria` con:
    - filtro por fechas `De/A`;
    - filtro por modulo;
    - filtro por familia de accion:
      - `Importar/Exportar`;
      - `Gestion informes`;
    - detalle ampliado en emergente;
    - scroll horizontal en la tabla;
  - la exportacion CSV inicial ya queda implementada desde el boton
    `Imprimir`, respetando filtros activos y creando salida en
    `output/auditoria`;
  - el CSV deja 5 columnas base, 18 columnas intermedias reservadas para
    componentes estructurados de detalle y `detalle` completo al final;
  - validacion funcional de esta consulta minima ya confirmada por usuario:
    - la tabla y el detalle emergente se visualizan correctamente;
    - el CSV sale limpio con los filtros aplicados;
  - esta linea puede darse por cerrada en primera aproximacion y pasar a
    mantenimiento, salvo remate UX puntual o nueva necesidad real.
- Primer corte de `login/acceso` productivo confirmado en codigo el 2026-06-14:
  - desaparece el acceso implicito al primer usuario activo cuando no hay
    contrasenas;
  - el bootstrap temporal pasa a flujo guiado y acotado:
    - solo sobre cuentas `superusuario` si existen;
    - o sobre usuario activo unico, promoviendolo a `superusuario` cuando el
      entorno lo soporta;
    - y bloqueandose si hay varios usuarios activos sin candidato seguro;
  - el bootstrap ya exige configurar contrasena inicial antes de abrir sesion;
  - el login normal añade bloqueo temporal en memoria de proceso tras 3 intentos
    fallidos sobre la misma cuenta;
  - quedan trazados en `auditoria_eventos`:
    - `bootstrap_password` o `bootstrap_superusuario`;
    - `login_bootstrap`;
    - `login_bloqueado_intentos`;
  - validacion tecnica completada con:
    - `python -m compileall main.py src`;
    - `python -m py_compile src/Compras/ui/login_ui.py src/Compras/services/usuarios_service.py src/compartido/auth.py src/compartido/auditoria_service.py`;
  - validacion manual ya confirmada en entorno real:
    - el `superusuario` entra correctamente y recupera acceso a todos los
      modulos esperados;
    - con un usuario de prueba, 3 intentos fallidos consecutivos bloquean el
      acceso durante 5 minutos;
    - en `gestion.auditoria_eventos` quedan trazados los 3 intentos fallidos y
      el evento de bloqueo temporal;
    - pasado el periodo de bloqueo, el mismo usuario vuelve a entrar con normalidad
      al usar la contrasena correcta;
  - pendiente todavia:
    - decidir si el bloqueo por intentos debe persistir mas alla del proceso
      local o si basta como primer corte de piloto controlado;
    - validar el flujo de bootstrap en una base de prueba aislada, sin tocar
      la base buena ya saneada.
  - regularizacion operativa posterior confirmada en entorno real:
    - tras una prueba manual sobre tabla `usuarios`, se detecto una importacion
      legacy que habia dejado la cuenta activa sin `id_rol`;
    - la base vuelve a quedar ya saneada con:
      - una sola cuenta activa;
      - rol real `superusuario`;
      - contrasena valida;
      - copia de seguridad ya generada sobre ese estado;
    - retirado el fallback mas laxo que abria `Gestion` por nombre de rol alto;
    - se mantiene la compatibilidad robusta por resolucion de rol y la
      regularizacion segura de cuenta unica como red de seguridad controlada.
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

`Rematar login/acceso y validar bootstrap en base de prueba`

Objetivo inmediato:

- dar por estable el primer corte de `login/acceso` ya validado en entorno
  real sobre la base buena;
- cerrar lo que queda pendiente de verdad:
  - prueba de bootstrap en base aislada;
  - decision sobre persistencia del bloqueo por intentos;
  - remate documental del bootstrap de instalacion;
- mantener documentado, pero sin implementar todavia, el futuro bloque de
  avisos por correo.

Arranque operativo ya preparado para esta sesion:

- repo a tocar por defecto: solo `maxgesth`;
- repos que quedan en observacion y no deben tocarse salvo hallazgo real:
  - `maxgesth_port`;
  - `maxgestq_mov`;
- punto real de entrada en codigo:
  - `src/main.py`;
  - `src/Compras/ui/login_ui.py`;
  - `src/Compras/services/usuarios_service.py`;
  - `src/compartido/auth.py`;
  - `src/compartido/auditoria_service.py`;
- foto tecnica confirmada antes de programar:
  - el acceso principal entra unicamente por `solicitar_login(...)`;
  - el hash actual ya usa `PBKDF2-SHA256` con iteraciones altas y no es hoy el
    punto debil prioritario;
  - el bypass temporal sigue dependiendo de
    `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=1`, pero ya no concede acceso
    implicito a una cuenta sin fijar contrasena inicial;
  - el login fallido ya audita error por intento y aplica enfriamiento temporal
    en memoria de proceso, aunque todavia no deja bloqueo persistente entre
    reinicios;
  - el bootstrap ya existe como flujo guiado, pero queda pendiente su
    validacion manual y su cierre documental para instalacion o primer arranque.

Estado actual tras el corte tecnico de esta sesion:

- el bootstrap guiado ya sustituye al acceso implicito sin contrasena;
- el arranque temporal ya no entra sobre "el primer usuario activo" sino sobre
  candidato seguro o se bloquea;
- el login normal ya aplica enfriamiento temporal por cuenta dentro del proceso;
- la deuda abierta ya no es de implementacion base sino de:
  - validacion manual de bootstrap en base de prueba;
  - decision de persistencia del bloqueo por intentos;
  - documentacion del bootstrap de instalacion.

Ataque recomendado:

1. clonar o restaurar una base de prueba aislada antes de tocar el escenario de
   bootstrap;
2. validar manualmente el caso bloqueado sin contrasena y sin
   `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN`;
3. validar el bootstrap guiado con la variable activa en escenario seguro y en
   escenario bloqueado;
4. comprobar la trazabilidad real en `gestion.auditoria_eventos` para:
   - `bootstrap_password` o `bootstrap_superusuario`;
   - `login_bootstrap`;
   - `login_bloqueado_intentos`;
5. decidir si el siguiente corte entra como:
   - remate tecnico con persistencia mayor del bloqueo por intentos;
   - o cierre documental y de instalacion del bootstrap;
6. mantener fuera de implementacion, de momento, los avisos por correo, pero
   dejar claro donde enganchan con los eventos de seguridad.

Estado del bloque previo:

- `auditoria` minima ya implementada en codigo;
- commit base ya cerrado: `4e1dd9e` (`Audita import/export de campo`);
- validado visualmente en 4 de 4 operativas;
- contraste funcional/SQL confirmado en 4 de 4 operativas;
- consulta minima de UI ya implementada;
- exportacion CSV inicial ya implementada;
- validacion funcional final de consulta y CSV ya confirmada por usuario;
- esta linea puede pasar a mantenimiento.

Documentos operativos a usar:

- `docs/plan_seguridad_consistencia.md`
- `docs/propuesta_modelo_roles_permisos.md`
- `docs/security_delivery_playbook.md`
- `docs/estado_continuidad.md`

Tests a preparar para cerrar esa tarea:

- `python -m compileall main.py src`;
- `python -m py_compile src/Compras/ui/login_ui.py src/Compras/services/usuarios_service.py src/compartido/auth.py src/compartido/auditoria_service.py`;
- caso feliz de login con usuario permitido;
- denegacion correcta en credenciales invalidas o usuario inactivo;
- bootstrap guiado correcto con `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=1` en
  escenario seguro;
- bloqueo correcto del bootstrap cuando hay varios usuarios activos sin
  candidato seguro;
- comprobacion de que no existe camino no controlado para elevar o saltar
  autenticacion;
- validacion del bloqueo temporal tras 3 intentos fallidos sobre la misma
  cuenta;
- verificar trazabilidad coherente en
  `gestion.auditoria_eventos`.

Punto de reentrada recomendado para la siguiente sesion:

1. leer esta seccion y `docs/diario_sesiones/2026-06-14.md`;
2. asumir ya validado el login real sobre la base buena con `superusuario`;
3. preparar una base de prueba aislada para no tocar el entorno ya saneado;
4. ejecutar solo la validacion pendiente del bootstrap guiado y su auditoria;
5. decidir si el siguiente commit sera de remate tecnico sobre persistencia de
   intentos o de cierre documental del bootstrap;
6. mantener como nota aparte, no implementada, los avisos por correo ligados a
   eventos de seguridad.

Plan de commits recomendado:

1. `Remata login productivo y bootstrap seguro`;
2. `Documenta bootstrap seguro de superusuario` si se separa del cambio
   tecnico.

Validacion manual ya cerrada en esta linea:

- portada:
  - modulos visibles correctos segun permiso en los perfiles probados;
- `Preventivos`:
  - permisos visibles y funcionales validados en las combinaciones probadas;
- `Quirofanos`:
  - permisos visibles y funcionales validados en las combinaciones probadas;
  - foco de import/export validado tras el selector de ruta;
- ventanas:
  - segunda apertura devuelve foco y no crea nueva instancia en las pantallas
    principales revisadas.

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
   - verificado el 2026-06-12: `bd/migraciones/migracion_centros_gestion.sql` aplicada
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
- dejar prevista una futura configuracion de avisos por correo electronico,
  sin implementarla todavia en esta tanda;
- variables funcionales ya identificadas para ese futuro bloque:
  - asignar correo electronico destino;
  - aviso en caso de intentos de entrada erroneos tras 2 series de 3 intentos
    fallidos;
  - apertura a nuevos tipos de avisos configurables.

### Base de datos y versionado del servidor

- verificado el 2026-06-13: el servidor actual del entorno queda ya en
  `MySQL 8.4.9`;
- revisar compatibilidad de sintaxis antes de ejecutar nuevas migraciones de
  `gestion`, en especial `bd/migraciones/migracion_centros_gestion.sql`;
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
- entregable tecnico ya preparado en repo:
  - `bd/base/gestion_roles.sql`;
  - `bd/base/gestion_permisos.sql`;
  - `bd/base/gestion_roles_permisos.sql`;
  - `bd/migraciones/migracion_gestion_roles_permisos_base.sql`.
  - `bd/migraciones/migracion_gestion_roles_permisos_backfill_usuarios.sql`.
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
  - siguiente corte natural tras ejecutar la migracion base:
    - backfill controlado de `usuarios.id_rol`;
    - helpers comunes de autorizacion;
    - mantenimiento UI de roles y asignacion real en usuarios.
  - criterio de backfill inicial ya adoptado:
    - `es_tecnico = 1` migra a `tecnico`;
    - el resto migra a `administrativo`;
    - `superusuario` requiere promocion manual consciente y no se asigna en
      bloque de forma automatica.
  - criterio de enforcement ya implantado en aplicacion:
    - `seguridad.usuarios_gestionar` no basta por si solo para tocar cuentas
      o asignaciones de `superusuario`;
    - solo un `superusuario` autenticado puede promover, degradar, modificar
      o desactivar una cuenta con ese rol.

### Auditoria

- decision funcional adoptada:
  - si habra acceso desde UI para consulta y exportacion documental de logs;
  - ese acceso quedara restringido a roles de alto nivel;
  - la interfaz vivira en la nueva seccion de `Gestion` y solo sera visible si
    el usuario dispone del rol o permiso correspondiente.
- pendientes que siguen abiertos:
  - politica de retencion;
  - alcance exacto de impresion y reimpresion en todos los modulos.
  - valorar el mejor momento para introducir avisos por correo apoyados en
    eventos de seguridad, empezando por intentos de acceso erroneos repetidos.

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
- la matriz de permisos de `Preventivos` y `Quirofanos` ya queda implantada en
  primer corte, pero su cierre real depende aun de validacion manual con
  perfiles de usuario;
- La version real del servidor de base de datos puede condicionar la sintaxis
  aceptable de futuras migraciones y debe revisarse antes de seguir ampliando
  `gestion.cecos`.
- `cecos` sigue siendo demasiado pobre para operar como maestro maduro de
  centros.
- Preventivos y Quirofanos pueden seguir revelando incidencias de campo, pero no
  deben arrastrar el roadmap salvo severidad alta o bloqueante.

