# Plan de upgrade MySQL 8.0.44 a 8.4 LTS
[[masgesth]]
Fecha de creacion: 2026-06-12

## Objetivo

Preparar una evolucion controlada del servidor desde `MySQL 8.0.44` a
`MySQL 8.4 LTS` antes de abrir una nueva fase de `roles/permisos` avanzados,
auditoria mas amplia o mas migraciones de esquema sobre `gestion`.

## Decision operativa

- Version actual confirmada: `MySQL 8.0.44`
- Version objetivo recomendada: `MySQL 8.4 LTS`
- Criterio: priorizar estabilidad, soporte prolongado y menor riesgo de
  compatibilidad para la aplicacion Python de escritorio
- Regla: no abrir como frente principal `roles/permisos` avanzados hasta dejar
  preparado o ejecutado este upgrade, salvo incidencia urgente

## Alcance minimo

Este plan debe cubrir al menos:

- backup completo previo;
- restauracion de prueba;
- validacion de conexion de la app;
- validacion funcional minima sobre modulos representativos;
- criterio de vuelta atras si algo falla.

## Prechecks tecnicos

Antes de tocar el servidor:

1. Confirmar edicion y sistema:
   - `SELECT VERSION();`
   - `SHOW VARIABLES LIKE 'version_comment';`
   - `SHOW VARIABLES LIKE 'sql_mode';`
   - `SHOW VARIABLES LIKE 'character_set_server';`
   - `SHOW VARIABLES LIKE 'collation_server';`
2. Confirmar motores y tablas criticas:
   - `SHOW ENGINES;`
   - revisar tablas principales de `gestion`, `quirofanos` y `preventivos`.
3. Confirmar conectores de la app:
   - version de `mysql-connector-python` instalada;
   - si hay otros clientes SQL embebidos en scripts o utilidades.
4. Confirmar compatibilidad operativa:
   - login;
   - lecturas y escrituras basicas;
   - PDFs o informes que dependan de consultas complejas.

## Secuencia recomendada

### 1. Congelar ventana

- elegir una ventana tranquila, sin carga de campo ni import/export critico;
- evitar mezclar este cambio con migraciones funcionales o de permisos;
- dejar identificado quien valida la app al terminar.

### 2. Backup completo

- export de las bases afectadas;
- copia de configuracion del servidor MySQL;
- si aplica, snapshot de maquina o VM antes del cambio.

Minimo esperado:

- backup de `gestion`;
- backup de `quirofanos`;
- backup de `preventivos`;
- evidencia de fecha y tamano de la copia.

### 3. Restauracion de prueba

Antes de produccion, restaurar el backup en entorno seguro y comprobar:

- que las bases abren sin errores;
- que el recuento de tablas cuadra;
- que una consulta simple por modulo devuelve datos;
- que la app puede arrancar contra ese entorno restaurado.

## 4. Upgrade a 8.4 LTS

- actualizar binarios o instancia segun la infraestructura real;
- mantener copia de la configuracion previa;
- revisar mensajes de upgrade, warnings y cambios de `sql_mode`;
- no ejecutar a la vez migraciones de `roles` ni cambios grandes de schema.

## 5. Validacion funcional minima post-upgrade

Checklist recomendada:

1. Login:
   - acceso con administrador valido;
   - cierre y reapertura sin errores.
2. `Gestion`:
   - abrir `Usuarios`;
   - abrir `Centros`;
   - alta o edicion controlada de un registro no critico.
3. `Preventivos`:
   - abrir vista principal;
   - localizar un equipo;
   - abrir un informe o registro representativo.
4. `Quirofanos`:
   - abrir modulo;
   - consultar un registro representativo.
5. SQL:
   - insertar o actualizar un dato no sensible de prueba;
   - confirmar persistencia;
   - revertir el dato de prueba si procede.

## Riesgos a vigilar

- cambios efectivos en `sql_mode`;
- diferencias de collation o charset;
- consultas legacy sensibles a ordenacion o comparaciones;
- triggers, vistas o procedimientos si existieran;
- incompatibilidades del conector Python o de dependencias empaquetadas.

## Criterio de exito

Se dara por bueno el upgrade si:

- el servidor queda en `MySQL 8.4 LTS`;
- la app conecta y autentica correctamente;
- los tres frentes `Gestion`, `Preventivos` y `Quirofanos` superan la prueba
  funcional minima;
- no aparece regresion bloqueante en escritura o lectura basica;
- queda documentada la fecha de cambio y el resultado.

## Criterio de rollback

Volver atras si ocurre cualquiera de estos puntos:

- la app no puede conectar o autenticar de forma estable;
- falla persistencia basica en `gestion`;
- aparece error bloqueante en flujos clave de `Preventivos` o `Quirofanos`;
- el tiempo de recuperacion supera la ventana aceptable sin confirmacion
  explicita del responsable operativo.

La vuelta atras debe apoyarse en:

- restauracion del backup previo;
- restauracion de configuracion anterior;
- validacion minima de que la operativa vuelve a quedar estable.

## Despues del upgrade

Orden recomendado:

1. estabilizar `MySQL 8.4 LTS`;
2. ejecutar `bd/migracion_gestion_auditoria.sql` si sigue pendiente;
3. retomar `roles/permisos` avanzados;
4. abrir nuevas migraciones de esquema de mayor calado.

## Evidencias a dejar

- version final del servidor;
- fecha de ejecucion;
- responsable tecnico;
- resultado de backup y restauracion;
- resultado de validacion funcional;
- incidencias detectadas y decision final.

## Cierre real de esta ejecucion

Resultado confirmado:

- upgrade completado a `MySQL 8.4.9`;
- la instancia no fue detectada por `MySQL Configurator` como `in-place
  upgrade`, sino como configuracion nueva;
- la resolucion practica fue reapuntar manualmente el servicio `MySQL80` al
  binario `8.4`, manteniendo `my.ini` y `datadir` previos;
- tras el cambio, la incidencia real no fue de datos sino de autenticacion:
  `administrador@%` seguia con plugin `mysql_native_password`;
- la app quedo operativa al migrar ese usuario a `caching_sha2_password`.

Lecciones aprendidas:

- en Windows, no confiar solo en que `MySQL Configurator` detecte la instancia
  existente;
- validar siempre:
  - binario real del servicio;
  - `my.ini` realmente usado por el servicio;
  - plugin de autenticacion de los usuarios de aplicacion;
- si `MySQL Workbench 8.0.x` queda por detras del servidor `8.4.x`, puede
  mostrar warning de compatibilidad sin impedir la administracion basica.
