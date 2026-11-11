# Politica de datos iniciales del piloto

Fecha de revision: 2026-07-17

## Objetivo

Definir que datos se entregan como base del sistema y cuales se crean durante
la implantacion. El piloto no debe heredar historicos, usuarios, centros ni
datos operativos del entorno de desarrollo.

## Centro inicial y administrador

La instalacion comienza con `gestion.cecos` vacia. No se crea un centro
ficticio para el usuario `administrador`.

Esta decision es compatible con la aplicacion:

- `gestion.usuarios.id_ceco` admite `NULL`;
- `bd/bootstrap/gestion_administrador_inicial.sql` crea `administrador` con
  `id_ceco = NULL`;
- la portada muestra `Centro: -` hasta que se asigne uno;
- el nombre `Administrador inicial` y el rol `superusuario` no dependen de un
  centro.

Los centros reales se daran de alta desde `Gestion -> Centros` segun las
necesidades identificadas por el usuario durante el piloto.

## Maestros que se conservan

### Seguridad del sistema

Se conservan o regeneran mediante el bootstrap oficial:

- `gestion.roles`;
- `gestion.permisos`;
- `gestion.roles_permisos`.

No se copian usuarios del desarrollo. La unica cuenta inicial es
`administrador`, creada mediante el bootstrap controlado y sin contrasena
predefinida.

### Quirofanos

Se conserva como base de trabajo:

- `quirofanos.puntos_control`.

No se conservan asignaciones a quirofanos de desarrollo. La tabla
`quirofanos.quirofano_puntos_control` se completa cuando existan los quirofanos
reales y se decida que puntos corresponden a cada uno.

### Preventivos

Se conserva provisionalmente como base de trabajo el conjunto completo de
plantillas y sus dependencias:

- `preventivos.tipos_equipo`;
- `preventivos.puntos_control`;
- `preventivos.plantillas_preventivo`;
- `preventivos.plantilla_puntos`.

La mayoria de los puntos de control previsiblemente coincidiran con los de la
empresa, pero pueden existir diferencias. Antes de considerar definitivo este
maestro se cruzara cada plantilla actual con la plantilla equivalente aportada
o validada por el usuario.

El resultado del contraste se decide por plantilla:

1. mantenerla si coincide;
2. adaptarla de forma controlada si solo hay diferencias justificadas;
3. sustituirla si el circuito de la empresa es distinto.

No debe cargarse, modificar ni retirar una plantilla sin tratar conjuntamente
su tipo de equipo, sus puntos y las relaciones de `plantilla_puntos`.

## Datos que comienzan vacios o se configuran despues

El resto de datos no se migra automaticamente desde desarrollo. Se incorpora
por una de estas vias:

1. alta normal por usuarios autorizados durante el piloto;
2. configuracion controlada tras la primera toma de contacto con la empresa;
3. migracion SQL explicita, revisada y respaldada, si el volumen o las
   dependencias hacen inadecuada la carga manual.

Esto incluye, entre otros:

- centros;
- usuarios nominales distintos de `administrador`;
- quirofanos y sus asignaciones de puntos;
- equipos de medida y certificados;
- equipos GMAO, campanas e informes;
- resultados, observaciones, auditoria e historicos;
- intercambios, exports y PDF operativos.

## Criterio antes de preparar el paquete de datos

Antes de generar un script de limpieza o carga se debe obtener de la empresa:

- centros iniciales, si desea precarga en lugar de alta manual;
- usuarios nominales y roles;
- quirofanos que entran en el piloto;
- catalogo de puntos de control que acepta para cada circuito;
- plantillas de Preventivos del usuario para cruzarlas con la base provisional;
- equipos de medida iniciales y certificados disponibles.

Hasta disponer de esa informacion, no se ejecuta ningun borrado masivo ni se
convierte el contenido actual de desarrollo en semilla del piloto.
