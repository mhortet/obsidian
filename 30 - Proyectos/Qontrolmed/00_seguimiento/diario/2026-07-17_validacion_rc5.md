# Validacion manual de instalacion RC5

Fecha: 2026-07-17

## Resultado comunicado

La RC `2026.07.16-rc5` se ha instalado sin incidencias en el entorno de prueba.

Se confirma:

- instalacion correcta del paquete;
- creacion correcta de `C:\ProgramData\Qontrolmed\config\.env` mediante el
  procedimiento administrativo de RC5;
- generacion de informes PDF correcta;
- publicacion de los PDF en las rutas previstas bajo
  `C:\ProgramData\Qontrolmed\output`.

La incidencia de RC4 que obligaba a intervenir manualmente sobre permisos y
propiedad para crear o actualizar el `.env` no se ha reproducido.

## Alcance de la evidencia

La confirmacion cubre instalacion, creacion del `.env`, resolucion de las rutas
PDF y prueba con un usuario Windows normal. El usuario puede ejecutar la
aplicacion y no puede modificar los binarios ni la configuracion.

El usuario confirma que las ACL generales y los accesos funcionales segun los
permisos de cada perfil ya se probaron en RC3/RC4. Esa evidencia se mantiene:
RC5 no introduce cambios en login, roles o autorizacion. No se requiere repetir
la matriz completa. La regresion puntual del nuevo script que crea el `.env` y
reaplica su ACL queda confirmada.

## Siguiente paso

### Backup registrado

Pasos 1 a 3 completados:

- ruta: `E:\backup_mysql_2026-07-17_completa`;
- tres ficheros SQL;
- tamano total: 0,74 MiB;
- cobertura de `gestion`, `quirofanos` y `preventivos`: `ok`;
- antiguedad al registrar: 0,18 horas, estado `ok`;
- manifiesto: `output/backup_mysql/backup_manifest_2026-07-17_17-54-25.md`;
- CSV con hashes SHA-256 generado junto al manifiesto.
- segunda copia: `K:\backup_mysql_2026-07-17_completa`;
- integridad de la segunda copia: 3 de 3 ficheros, tamanos y SHA-256
  coincidentes con el origen de `E:`.

Los SQL estan dentro de subcarpetas por esquema. El generador actual busca
ficheros solo en la raiz del backup, por lo que no debe ejecutarse sin adaptar
el paso a esta estructura.

La restauracion se realizo directamente con MySQL Workbench, importando cada
fichero como `Self-Contained File` y seleccionando explicitamente su destino:

- `gestion_restore`;
- `quirofanos_restore`;
- `preventivos_restore`.

Las tres importaciones finalizaron correctamente. Antes de importarlas se
comprobo que los dumps no contenian `CREATE/DROP DATABASE`, `USE` ni referencias
calificadas a los esquemas originales.

### Continuacion

Pasos 1 a 6 completados sin incidencias:

- tablas y registros presentes en los tres esquemas `_restore`;
- Qontrolmed configurado temporalmente contra la restauracion;
- login correcto;
- apertura correcta de `Gestion`, Preventivos y Quirofanos;
- comprobacion de una muestra de 4 o 5 accesos por cada UI;
- configuracion operativa restaurada al terminar.

La cobertura se acepta como smoke test representativo. No se declara una
regresion exhaustiva del 100 % de enlaces.

Backup, restauracion y arranque contra la restauracion quedan ensayados. El
siguiente bloque recomendado es definir y revisar los maestros minimos y datos
iniciales del piloto.

La restauracion ensayada ya dispone de evidencia real y queda cerrada como
criterio tecnico de entrada al piloto.

## Politica de datos iniciales acordada

- `Centros` comienza vacio;
- `administrador` no requiere centro inicial: el bootstrap usa
  `id_ceco = NULL`;
- se mantienen roles, permisos y sus asignaciones oficiales;
- se conserva el catalogo base de puntos de control de Quirofanos;
- se conservan provisionalmente tipos, puntos, plantillas y relaciones de
  Preventivos;
- las plantillas se cruzaran con las aportadas por la empresa y se decidira por
  cada una si se mantiene, adapta o sustituye;
- el resto se introduce por usuarios autorizados o mediante una configuracion
  controlada tras la primera toma de contacto.

Detalle: `docs/politica_datos_iniciales_piloto.md`.

## Cierre previo a vacaciones

El bloque previsto queda completado siete dias antes de la fecha objetivo. No
se espera contacto con la empresa piloto hasta, al menos, la segunda quincena
de agosto.

RC5 queda como referencia congelada del piloto. El trabajo intermedio sobre
funcionalidad futura de la aplicacion o sobre la web debe desarrollarse de
forma separada para no introducir regresiones en esta base validada.
