# Manual de usuario final para tecnicos hospitalarios

Fecha de revision: 30/05/2026  
Proyecto: Qontrolmed (`maxgesth`)  
Perfil destinatario: tecnicos hospitalarios no informaticos

## 1. Objetivo de este manual

Este manual explica el uso diario de la aplicacion desde el punto de vista del tecnico que trabaja con compras, revisiones de quirofano y mantenimiento preventivo.

No es un manual informatico. La idea es que sirva para trabajar con seguridad, entender el orden correcto de cada tarea y saber donde quedan guardados los resultados.

Las capturas y ejemplos incluidos se han preparado con datos reales de la instalacion revisada.

## 2. Vision general

La aplicacion se abre con un acceso inicial de usuario y despues muestra una portada con tres modulos:

- `Compras`
- `Quirofanos`
- `Preventivos`

El trabajo normal suele seguir este orden:

1. Entrar con el usuario personal.
2. Elegir el modulo segun la tarea del dia.
3. Crear o cargar el registro que corresponda.
4. Revisar los datos principales antes de guardar.
5. Generar el documento final cuando proceda.
6. Cerrar el informe solo cuando ya no vaya a modificarse.
7. Confirmar que el archivo final ha quedado guardado en la carpeta `output`.

## 3. Flujo de trabajo general recomendado

1. Identificarse siempre con el usuario correcto. El programa usa ese dato para asociar técnicos, centros y trazabilidad.
2. Trabajar primero sobre registros abiertos. Si un informe ya esta cerrado, el sistema lo deja en modo lectura o limita cambios.
3. Generar PDF antes de imprimir o enviar documentación.
4. Hacer exportaciones a Tablet o Android solo cuando se vayan a usar realmente en campo.
5. Antes de importaciones masivas o cambios de configuración, hacer copia de seguridad.

## 4. Compras

## 4.1 Para que sirve

El modulo `Compras` se usa para:

- registrar compras de material y repuestos,
- asociarlas a una `OT`,
- vincularlas a un equipo,
- sacar un Excel de compra,
- sacar un Excel de peticion de presupuesto,
- consultar historicos y datos economicos.


![[compras_menu.png]]

Figura 1. Pantalla de entrada al modulo Compras.

## 4.2 Pantalla principal de trabajo

La ventana de `Compras` esta pensada para rellenar una cabecera y despues ir anadiendo lineas de detalle.


Figura 2. Formulario de alta y consulta de compras.

Campos que conviene revisar siempre:

- `Fecha`
- `CECO`
- `OT`
- `Equipo`
- `Solicitado por`
- `Repuesto`
- `Proveedor`
- `Cantidad`
- `Precio`
- `Tipo trabajo`
- `Refacturable`

## 4.3 Flujo recomendado

1. Entrar en `Compras > Compras`.
2. Comprobar fecha y `CECO`.
3. Indicar la `OT`.
4. Pulsar `Seleccionar equipo` para buscar el equipo correcto.
5. Pulsar `Identificate` si hace falta actualizar el solicitante.
6. En `Detalle`, pulsar `Seleccionar repuesto`.
7. Revisar proveedor, referencia, precio y cantidad.
8. Pulsar `Anadir linea`.
9. Repetir el paso anterior si la compra tiene varias lineas.
10. Pulsar `Guardar compra`.
11. Si hace falta enviarla o archivarla fuera de la aplicacion, generar `Excel compra` o `Excel presupuesto`.

## 4.4 Busqueda y recuperacion de compras

Si una compra ya existe:

1. Pulsar `Buscar compra`.
2. Filtrar por fechas, `CECO`, `OT`, equipo, proveedor o texto libre.
3. Seleccionar la compra en el listado.
4. Pulsar `Abrir compra`.

Este flujo es util cuando hay que:

- completar una compra ya empezada,
- revisar importes,
- volver a exportar el Excel,
- comprobar si una `OT` ya tuvo gasto asociado.

## 4.5 Ejemplos reales

Ejemplo 1:

- Fecha: `11/05/2026`
- OT: `1098485`
- Hospital: `Hospital U. San Agustin`
- Equipo: `MUESTREADOR DE AIRE`
- Marca y modelo: `VWR SUPER 360`
- Repuesto/servicio: `CALIBRACION STANDARD MUESTREADOR DE AIRE SUPER 360 SN 24-D-20761`
- Proveedor: `Laborat`
- Importe: `831 EUR`
- Tipo de trabajo: `Intervencion casa Externa`

Ejemplo 2:

- Fecha: `07/05/2026`
- OT: `89961`
- Equipo: `CAMILLA ELECTRICA`
- Repuesto: `Bateria HEYCAR AGM 12V 1.2Ah`
- Proveedor: `BATSOL`
- Cantidad: `2`

## 4.6 Botones utiles

- `Dashboard`: resumen economico y graficas.
- `Historicos Excel`: importacion masiva desde carpetas de Excel.
- `Importar PDF`: en esta revision aparece en menu, pero sigue en construccion y no debe usarse como flujo normal.

## 4.7 Buenas practicas

- No guardar una compra sin `OT`, salvo que el procedimiento interno del hospital lo permita.
- Si una compra lleva varias lineas, revisar el total antes de exportar.
- Usar `Excel presupuesto` cuando se necesite pedir oferta a proveedor.
- Usar `Excel compra` cuando ya se quiera dejar trazado el detalle final.

## 5. Quirofanos

## 5.1 Para que sirve

El modulo `Quirofanos` se usa para:

- crear informes mensuales por quirofano,
- registrar puntos de control,
- generar PDF del informe,
- cerrar el informe final,
- generar el `Libro de quirofano`,
- exportar e importar trabajo de campo con Android,
- mantener catalogos de quirofanos, puntos y equipos de medida.

![Menu de Quirofanos](capturas/quirofanos_menu.png)

Figura 3. Pantalla principal del modulo Quirofanos.

## 5.2 Configuracion basica del modulo

Antes de hacer informes, el modulo debe tener bien definidos los quirofanos y los puntos de control.

![Catalogo de Quirofanos](capturas/quirofanos_catalogo.png)

Figura 4. Catalogo de quirofanos activos.

En la instalacion revisada aparecen, por ejemplo:

- `Q1 - Quirofano 1`
- `HEM1 - Cama 1`
- varios puestos `HEM2` a `HEM20`

## 5.3 Flujo normal de informe mensual

1. Entrar en `Quirofanos > Informes quirofanos`.
2. Elegir el `Quirofano`.
3. Rellenar `Ano / Mes`.
4. Indicar `Fecha realizacion`.
5. Seleccionar `Equipo medida`.
6. Seleccionar `Tecnico`.
7. Pulsar `Crear`.
8. Revisar los puntos de control y marcar cada uno como `OK` o `MAL`.
9. Anotar observaciones cuando proceda.
10. Pulsar `Generar PDF` para revisar el documento.
11. Cuando el informe este terminado, pulsar `Cerrar informe`.

Importante:

- si el equipo de medida esta caducado, el sistema puede bloquear la creacion del informe;
- un informe cerrado ya no debe tratarse como borrador.

## 5.4 Ejemplos reales

Ejemplo 1:

- Quirofano: `Q1`
- Nombre: `Quirofano 1`
- Ano/mes: `09/2026`
- Fecha de realizacion: `15/05/2026`
- Tecnico: `Maximo A. Hortet`
- Estado: `cerrado`
- Calibracion: `OK`
- PDF generado: `output/Q1_2026_09.pdf`

Ejemplo 2:

- Quirofano: `HEM1`
- Nombre: `Cama 1`
- Ubicacion: `Hemodialisis 1a S`
- Ano/mes: `09/2026`
- Estado actual en la revision: `abierto`

Puntos de control reales detectados en `HEM1`:

- `I_Luminosos`
- `Pulsadores`
- `T_medida`
- `Corriente_fuga`
- `Suelo`
- `T_Corriente`

## 5.5 Trabajo de campo con Android

El bloque `Trabajo de campo` tiene tres funciones:

- `Exportar para Android`
- `Importar desde Android`
- `Plantillas en blanco`

Uso recomendado:

1. Exportar antes de salir a campo.
2. Trabajar en Android con el paquete exportado.
3. Importar despues el fichero de vuelta.
4. Revisar conflictos si el programa avisa de que ya existe un informe para ese mismo quirofano y mes.

Los intercambios se guardan en:

- `output/export_tablet/quirofanos/desktop_a_android`
- `output/export_tablet/quirofanos/android_a_desktop`

## 5.6 Libro de quirofano

`Libro de quirofano` sirve para sacar un documento conjunto por ano y hasta un mes concreto.

Flujo:

1. Elegir el ano.
2. Elegir el ultimo mes que debe incluirse.
3. Seleccionar todos los quirofanos o solo algunos.
4. Pulsar `Generar libro`.

El libro usa informes cerrados. Si un informe sigue abierto, no debe esperarse que aparezca en el libro final.

## 5.7 Equipos de medida

Los equipos de medida son especialmente importantes porque afectan a la validez del informe.

![Equipos de medida de Quirofanos](capturas/quirofanos_equipos_medida.png)

Figura 5. Mantenimiento de equipos de medida y certificado.

En la instalacion revisada hay, por ejemplo:

- `ALTHAE 34947`
- marca `CHAUVIN ARNAUX`
- modelo `C.A 6116`

Antes de usar un equipo de medida conviene revisar:

- fecha de calibracion,
- fecha de caducidad,
- certificado cargado.

## 6. Preventivos

## 6.1 Para que sirve

El modulo `Preventivos` se usa para:

- importar inventario desde `Excel GMAO`,
- crear informes preventivos por equipo,
- registrar comprobaciones cualitativas, cuantitativas y de seguridad,
- generar PDF final,
- marcar el informe como cerrado,
- sacar historico e impresion multiple,
- exportar e importar trabajo con tablet.

![Menu de Preventivos](capturas/preventivos_menu.png)

Figura 6. Pantalla principal del modulo Preventivos.

## 6.2 Flujo recomendado

1. Si es una carga nueva de equipos, usar `Importar Excel GMAO`.
2. Entrar en `Informes preventivos`.
3. Buscar el equipo por inventario, centro o seleccion directa.
4. Rellenar `Fecha realizacion`, `Tecnico`, `OT` y `Clase / Tipo`.
5. Crear o cargar el informe.
6. Registrar cada comprobacion.
7. Revisar el resultado global.
8. Generar PDF.
9. Cerrar el informe cuando todo este revisado.

## 6.3 Ejemplo real

Informe preventivo cerrado detectado en la instalacion:

- Fecha: `26/05/2026`
- OT: `1097626`
- Inventario: `33435`
- Equipo: `ELECTROCARDIOGRAFO`
- Marca: `PHILIPS`
- Modelo: `PAGEWRITER TC20`
- Ubicacion: `URGENCIAS AMARILLO 2`
- PDF generado: `output/preventivos/informe_preventivo_OT_1097626.pdf`

Comprobaciones reales extraidas del PDF:

- `ECG-Q03` Chequeo funcionamiento ECG
- `ECG-Q04` Chequeo amplitud 1 mV
- `ECG-Q01` Velocidad de papel
- `ECG-Q02` Sensibilidad

## 6.4 Plantillas de preventivo

Las plantillas permiten normalizar los puntos de control por tipologia de equipo.

![Plantillas de Preventivos](capturas/preventivos_plantillas.png)

Figura 7. Mantenimiento de plantillas preventivas.

En la instalacion revisada existen, entre otras:

- `Electrocardiografos`
- `Mesa de Anestesia`
- `Preventivo ECOG`
- `Preventivo MICRO`

Esto significa que antes de crear muchos informes conviene comprobar que la plantilla correcta existe y esta activa.

## 6.5 Acciones de campana

Desde `Imprimir multiples` se anaden dos acciones para acelerar campanas completas:

- `Cargar equipos de medida`: permite elegir una tipologia concreta y asignar uno o varios equipos de medida a todos los informes abiertos de esa tipologia en la campana activa.
- `Cerrar correctos sin comentarios`: cierra en bloque solo los informes abiertos que estan completos, tienen todos los controles en `B` o `NA`, no tienen incidencias, no tienen observaciones/comentarios y ya tienen equipos de medida cargados.

La carga por tipologia es util porque los equipos de medida, aunque habitualmente roten entre distintos centros de trabajo, cuando se reciben suelen cubrir toda la campana. Cargarlos de una vez evita repetir la misma asignacion informe por informe y reduce tiempo administrativo al preparar los PDF y sus certificados.

Antes de usar el cierre masivo conviene revisar el aviso de confirmacion: el sistema muestra cuantos informes cumplen las condiciones y una muestra de los equipos que se cerraran.

## 6.6 Historico e impresion

Desde `Historico de informes` se puede:

- localizar informes antiguos,
- abrir un informe ya realizado,
- regenerar su PDF,
- marcarlo como `impreso`.

Este apartado es util cuando:

- hay que volver a sacar un PDF,
- se quiere comprobar si un equipo ya tuvo preventivo,
- se necesita confirmar si un informe ya se imprimio.

## 6.7 Importacion desde tablet

El programa permite exportar datos para trabajo en tablet e importar despues los resultados.

Recomendacion:

1. Exportar solo cuando el tecnico vaya a trabajar fuera del puesto fijo.
2. Importar los resultados en cuanto vuelvan para evitar duplicidades.
3. Si el sistema detecta conflictos, leer bien el aviso antes de reemplazar datos.

## 7. Configuracion

## 7.1 Que entra en configuracion

La configuracion no es solo "parametros tecnicos". En esta aplicacion incluye catalogos y datos maestros que afectan al trabajo diario:

- usuarios,
- `CECOS`,
- equipos,
- proveedores,
- repuestos,
- tipos de trabajo,
- quirofanos,
- puntos de control,
- equipos de medida,
- plantillas de preventivo,
- asignacion de puntos a plantillas o quirofanos.

## 7.2 Usuarios

![Configuracion de usuarios](capturas/configuracion_usuarios.png)

Figura 8. Mantenimiento de usuarios.

Uso correcto:

1. Crear usuarios nominales.
2. Asignar su `CECO`.
3. Marcar si es `Tecnico`.
4. Desactivar usuarios que ya no deban entrar.

En la instalacion revisada aparecen usuarios reales como:

- `Adrian Amaro Garcia`
- `Adrian Rodriguez`
- `Jorge Valdes`
- `Maximo A. Hortet`

## 7.3 Recomendaciones de configuracion

- No cambiar configuracion mientras otro tecnico este usando ese mismo modulo.
- No desactivar puntos, plantillas o usuarios sin confirmar antes el impacto.
- Si se cambia un equipo de medida, revisar tambien el certificado asociado.
- Tras cambios grandes, hacer una prueba corta antes de seguir trabajando con normalidad.

## 8. Copias de seguridad

## 8.1 Cuando hacer copia

Se recomienda hacer copia de seguridad:

- antes de importaciones masivas de `Excel GMAO`,
- antes de importar resultados desde tablet o Android,
- antes de cambiar catalogos o configuracion,
- antes de una actualizacion del programa,
- al cierre de mes, antes de emitir documentacion final.

## 8.2 Que hay que guardar

Minimo recomendado:

1. Bases de datos:
- `gestion`
- `quirofanos`
- `preventivos`

2. Carpeta de salidas:
- `output`

3. Carpeta de intercambio con tablet:
- `output/export_tablet`
- revisar especialmente las subcarpetas por dominio y sentido del flujo

4. Certificados y documentos externos asociados a equipos de medida, si estan guardados fuera de la base de datos.

## 8.3 Que informacion contiene la carpeta output

Dentro de `output` pueden quedar:

- PDFs de quirofano,
- PDFs de preventivos,
- libros de quirofano,
- plantillas en blanco,
- ficheros JSON de intercambio con tablet o Android.

Ejemplos reales encontrados:

- `output/Q1_2026_09.pdf`
- `output/HEM1_2026_09.pdf`
- `output/preventivos/informe_preventivo_OT_1097626.pdf`
- `output/preventivos/informes_multiples.pdf`
- `output/export_tablet/quirofanos/desktop_a_android/quirofanos_android_export_2026-05-17_17-13-52.json`

## 8.4 Procedimiento sencillo

1. Pedir a todos los usuarios que salgan de la aplicacion.
2. Guardar copia de las tres bases de datos.
3. Copiar la carpeta `output` completa a una ubicacion segura.
4. Si hay certificados o anexos fuera de `output`, copiarlos tambien.
5. Anotar fecha y motivo de la copia.

Si el tecnico no tiene permisos para copiar la base de datos, debe solicitar la operacion a soporte o al responsable informatico.

## 9. Problemas frecuentes

## 9.1 No puedo entrar en la aplicacion

Posibles causas:

- usuario o contrasena incorrectos,
- usuario desactivado,
- fallo de conexion con base de datos.

Que hacer:

1. Repetir acceso comprobando mayusculas y minusculas.
2. Pedir a un usuario con permisos que revise si su cuenta sigue activa.
3. Si el error aparece al arrancar, avisar a soporte porque puede ser problema de conexion.

## 9.2 No encuentro un equipo en Preventivos

Que revisar:

- inventario escrito correctamente,
- centro correcto,
- si el equipo fue importado desde `Excel GMAO`,
- si esta activo.

Si sigue sin aparecer:

- revisar en `Importar Excel GMAO`,
- comprobar si el equipo esta en otro `CECO`,
- pedir revision de la configuracion.

## 9.3 No puedo crear un informe de Quirofanos

Motivos habituales:

- falta seleccionar quirofano,
- fecha incorrecta,
- equipo de medida caducado,
- ya existe informe para ese quirofano y mes.

Accion recomendada:

1. Probar `Cargar` por si el informe ya existia.
2. Revisar el estado del equipo de medida.
3. Confirmar ano y mes.

## 9.4 El sistema no me deja modificar un informe

Lo mas habitual es que el informe este `cerrado`.

En ese caso:

- revisar el PDF ya emitido,
- no intentar rehacerlo por encima,
- consultar antes de reabrir o duplicar trabajo.

## 9.5 El PDF no aparece donde esperaba

Recordatorio de rutas:

- Quirofanos: `output`
- Plantillas en blanco de quirofano: `output/quirofanos/plantillas_blanco`
- Preventivos: `output/preventivos`
- Intercambio Quirofanos: `output/export_tablet/quirofanos/...`
- Intercambio Preventivos: `output/export_tablet/preventivos/...`

## 9.6 Al importar desde tablet o Android aparecen conflictos

Esto significa que ya existe un informe parecido en el puesto fijo.

Antes de aceptar reemplazos:

1. Comparar fechas.
2. Confirmar cual es la version buena.
3. Si hay duda, guardar copia del fichero importado antes de continuar.

## 9.7 Un equipo de medida no tiene certificado

Consecuencia:

- el informe puede quedar sin anexo documental,
- en algunos flujos la revision pierde trazabilidad.

Solucion:

1. Entrar en `Equipos de medida`.
2. Seleccionar el equipo.
3. Cargar o revisar el PDF del certificado.

## 10. Resumen final

Si se usa la aplicacion con un orden claro, el trabajo diario es sencillo:

1. `Compras` para registrar gasto y sacar Excel.
2. `Quirofanos` para revisar espacios, generar PDF y cerrar informes mensuales.
3. `Preventivos` para revisar equipos, generar informes y mantener historico.
4. `Configuracion` solo cuando haga falta ajustar datos maestros.
5. `Copias de seguridad` antes de cambios importantes y siempre al cierre de ciclos.

La regla mas importante para evitar problemas es esta: generar el documento final y revisar la carpeta `output` antes de dar el trabajo por terminado.
