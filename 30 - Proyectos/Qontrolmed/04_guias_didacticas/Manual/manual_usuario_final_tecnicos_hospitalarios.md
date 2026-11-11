# Manual de usuario final para técnicos hospitalarios

| Control documental | Valor |
| --- | --- |
| Versión documental | 0.2 |
| Fecha de revisión | 17/07/2026 |
| Versión de referencia | Qontrolmed RC5 |
| Estado | Borrador funcional pendiente de capturas definitivas del piloto |
| Perfil destinatario | Técnicos hospitalarios y responsables operativos no informáticos |

## 1. Objetivo y alcance

Este manual explica el uso diario de Qontrolmed desde el punto de vista del
técnico que trabaja con compras, revisiones de quirófano y mantenimiento
preventivo.

Su finalidad es ayudar a:

- acceder con una cuenta personal;
- identificar qué opciones corresponden a cada tarea;
- crear, revisar y cerrar informes con un orden seguro;
- generar y localizar los documentos resultantes;
- actuar correctamente ante avisos, conflictos o falta de permisos.

No es un manual de instalación ni de administración de MySQL. Las copias de
seguridad, restauraciones, cambios en el archivo de configuración y
actualizaciones de la aplicación corresponden al responsable autorizado.

Las funciones visibles dependen del rol y de los permisos concedidos. Por
tanto, es normal que dos usuarios no vean exactamente los mismos módulos,
menús o botones.

## 2. Convenciones utilizadas

En este manual:

- los nombres de botones y menús se muestran en **negrita**;
- “informe abierto” significa que todavía puede modificarse;
- “informe cerrado” significa que ha finalizado su circuito normal y queda en
  modo de consulta;
- “sobremesa” se refiere a la aplicación Qontrolmed instalada en Windows;
- “responsable” se refiere al usuario con permisos de coordinación,
  configuración o administración.

Cuando un aviso de la aplicación ofrezca **Sí**, **No** y **Cancelar**, debe
leerse el texto completo antes de responder. En importaciones, cada opción
puede conservar o reemplazar información diferente.

## 3. Acceso y portada principal

### 3.1 Inicio de sesión

1. Abra Qontrolmed desde el acceso facilitado por el responsable.
2. Seleccione o escriba su usuario, según la pantalla disponible.
3. Introduzca su contraseña.
4. Compruebe que la portada muestra su nombre, rol y centro.

Utilice siempre una cuenta nominal. No comparta contraseñas ni trabaje con la
cuenta de otra persona: el usuario activo forma parte de la trazabilidad de
operaciones, informes y auditoría.

Si la cuenta inicial **administrador** muestra **Centro: -**, no implica un
fallo. En una instalación nueva esa cuenta puede existir sin centro asignado.
Los usuarios nominales deben configurarse después de acuerdo con la
organización real del piloto.

### 3.2 Módulos de la portada

La portada puede mostrar estas tarjetas:

| Módulo | Uso principal |
| --- | --- |
| **Gestión** | Compras, estadísticas, maestros, usuarios, roles y auditoría, según permisos. |
| **Quirófanos** | Informes mensuales, libro de quirófano, trabajo con Android y configuración del módulo. |
| **Preventivos** | Informes preventivos, campañas, trabajo con tablet y plantillas. |

Si no aparece un módulo o una entrada concreta, no debe intentarse acceder por
otra vía. Primero confirme con el responsable si su perfil necesita ese
permiso.

### 3.3 Botones de la portada

- **Abrir**: entra en el módulo correspondiente.
- **Abrir salidas**: abre la carpeta común donde Qontrolmed guarda los
  documentos generados.
- **Salir**: cierra la aplicación y libera la conexión de trabajo.

Utilice **Salir** al terminar. No deje una sesión abierta en un puesto
compartido.

## 4. Flujo general recomendado

Para cualquier módulo, siga esta secuencia:

1. Confirme que ha accedido con su usuario.
2. Seleccione el módulo adecuado.
3. Busque primero si el registro o informe ya existe.
4. Cree un registro nuevo solo cuando haya comprobado que no está duplicado.
5. Revise los datos de cabecera antes de introducir resultados.
6. Guarde los cambios durante el trabajo.
7. Genere el documento y compruebe su contenido.
8. Cierre el informe únicamente cuando esté completo y validado.
9. Verifique el mensaje final y la ruta del archivo generado.
10. Cierre la ventana del módulo o salga de la aplicación.

Antes de una importación masiva, un cambio de maestros o una sustitución de
datos por conflicto, confirme que existe una copia de seguridad válida. El
técnico no debe ejecutar la copia si no tiene asignada esa responsabilidad;
debe solicitarla.

## 5. Gestión y Compras

### 5.1 Mapa del módulo

El módulo **Gestión** puede contener:

| Bloque | Entradas habituales | Finalidad |
| --- | --- | --- |
| **Maestros** | **Equipos**, **Centros** | Consulta o mantenimiento de datos compartidos. |
| **Seguridad** | **Roles**, **Usuarios**, **Auditoría** | Administración de accesos y revisión de eventos. |
| **Operativa** | **Compras**, **Estadísticas**, **Proveedores**, **Repuestos**, **Marcas**, **Tipos trabajo** | Trabajo económico y mantenimiento de catálogos. |
| **Importación** | **Históricos Excel**, **Importar PDF** | Carga de históricos. **Importar PDF** sigue en construcción y no forma parte del flujo normal. |

Para un técnico de actividad diaria, la opción más habitual es
**Gestión > Compras**. Los cambios en maestros o seguridad deben reservarse a
usuarios autorizados.

### 5.2 Crear una compra

La compra se compone de una cabecera y una o varias líneas de detalle.

Revise especialmente:

- **Fecha**;
- **CECO** o centro;
- **OT**;
- equipo, marca, modelo y número de serie;
- **Solicitado por**;
- repuesto o servicio;
- proveedor y referencia;
- cantidad y precio;
- tipo de trabajo;
- condición **Refacturable**;
- observaciones.

Procedimiento recomendado:

1. Entre en **Gestión > Compras**.
2. Compruebe la fecha y el CECO.
3. Indique la OT conforme al procedimiento interno.
4. Pulse **Seleccionar equipo** y elija el equipo correcto.
5. Use **¡Identifícate!** solo si necesita actualizar el solicitante.
6. En el bloque de detalle, pulse **Seleccionar repuesto**.
7. Revise proveedor, referencia, precio, cantidad y tipo de trabajo.
8. Pulse **Añadir línea**.
9. Repita la selección si la compra contiene más líneas.
10. Compruebe el total y las observaciones.
11. Pulse **Guardar compra**.

No use **Actualizar repuesto** sin comprender su alcance: puede modificar el
dato maestro compartido y no únicamente la línea visible.

### 5.3 Buscar y recuperar una compra

1. Pulse **Buscar compra**.
2. Filtre por los datos disponibles, como fecha, CECO, OT, equipo o proveedor.
3. Seleccione la fila correcta.
4. Pulse **Abrir compra**.
5. Confirme que el identificador y el contenido corresponden al registro
   esperado antes de modificarlo.

Este flujo sirve para completar una compra, revisar importes, comprobar gasto
asociado a una OT o volver a generar un documento.

### 5.4 Exportar documentos de compra

- **Excel compra** genera el detalle destinado al circuito de compra.
- **Excel presupuesto** genera el documento para solicitud de oferta.

La aplicación solicita una ubicación de guardado. Anote o compruebe esa ruta:
estos Excel no tienen por qué quedar en la carpeta general de salidas.

### 5.5 Buenas prácticas

- No cree una segunda compra para corregir una existente sin revisar antes el
  buscador.
- No deje líneas con cantidad, precio o proveedor sin verificar.
- Evite registrar una compra sin OT, salvo que el procedimiento de la empresa
  lo permita.
- No modifique proveedores, repuestos, marcas o tipos de trabajo para resolver
  una duda puntual sin autorización.
- Si se equivoca en un maestro compartido, detenga el trabajo y comuníquelo.

## 6. Quirófanos

### 6.1 Finalidad y requisitos previos

El módulo **Quirófanos** permite:

- crear y consultar informes mensuales;
- registrar los puntos de control;
- generar el PDF del informe;
- cerrar el informe;
- crear el libro de quirófano;
- intercambiar trabajo con Android;
- generar plantillas en blanco;
- mantener quirófanos, puntos y equipos de medida, según permisos.

Antes de crear informes deben existir:

- el quirófano o ubicación de trabajo;
- los puntos de control asignados;
- el técnico;
- el equipo de medida, cuando sea obligatorio;
- la calibración y el certificado correspondientes.

Si falta alguno de estos maestros, solicite su configuración. No cree nombres
provisionales para continuar un informe real.

### 6.2 Crear o cargar un informe mensual

1. Entre en **Quirófanos > Informes quirófanos**.
2. Seleccione la ubicación y el quirófano.
3. Indique la **Fecha realización**. El año y el mes del informe se
   sincronizan con esa fecha.
4. Indique la **Fecha firma** cuando corresponda. Debe ser coherente con el
   mes del informe.
5. Seleccione el **Equipo medida**.
6. Seleccione el **Técnico**.
7. Pulse **Crear**.

Si ya existe un informe para ese quirófano, año y mes, la aplicación carga el
existente en lugar de crear un duplicado. También puede utilizar **Cargar**
para recuperar un informe.

Estado del equipo de medida:

- **OK**: puede utilizarse;
- **PRÓXIMO**: la aplicación avisa, pero permite crear el informe;
- **CADUCADO**: la aplicación bloquea la creación;
- **SIN EQUIPO** o sin datos suficientes: revise la configuración antes de
  continuar.

### 6.3 Registrar puntos de control

1. Seleccione el punto en la lista.
2. Introduzca el valor medido cuando el punto lo requiera.
3. Añada una observación si aporta información útil.
4. Marque el resultado:

| Estado | Significado operativo |
| --- | --- |
| **OK** | El punto cumple. |
| **MAL** | El punto no cumple o requiere actuación. |
| **NA** | El punto no aplica; úselo solo cuando esté justificado. |

5. Use **Obs. informe** para observaciones generales que no pertenecen a un
   único punto.
6. Revise ambos listados de puntos antes del cierre.

No utilice **NA** para ocultar una medición pendiente o un resultado
desfavorable.

### 6.4 Actualizar, generar PDF y cerrar

- **Actualizar** guarda los cambios de cabecera.
- **Generar PDF** crea una versión revisable del informe.
- **Cerrar informe** finaliza el circuito normal y deja el informe en modo de
  lectura.
- **Nuevo** limpia el formulario para iniciar otra operación.

Antes de cerrar, compruebe:

- técnico seleccionado;
- equipo de medida válido;
- fecha de realización;
- fecha de firma;
- todos los puntos revisados;
- observaciones de resultados desfavorables;
- contenido del PDF.

Al cerrar, Qontrolmed intenta actualizar automáticamente el PDF y muestra su
ruta. Si el informe queda cerrado pero aparece un aviso sobre el PDF, no repita
el cierre: anote el mensaje y solicite revisión.

### 6.5 Libro de quirófano

El **Libro de quirófano** agrupa informes cerrados de un año hasta el mes
indicado.

1. Seleccione el año.
2. Indique un mes entre 1 y 12.
3. Filtre por ubicación si procede.
4. Seleccione todos los quirófanos o solo los necesarios.
5. Pulse **Generar libro**.
6. Abra el PDF resultante y revise portada, periodo y contenido.

Los informes abiertos no se incluyen. Si no existen informes cerrados para los
filtros seleccionados, la aplicación lo indicará.

### 6.6 Trabajo de campo con Android

El bloque **Trabajo de campo** contiene:

- **Exportar para Android**;
- **Importar desde Android**;
- **Plantillas en blanco**.

Secuencia recomendada:

1. Exporte el paquete inmediatamente antes de transferirlo al dispositivo.
2. Conserve una sola copia de trabajo identificable.
3. Realice y cierre en Android los informes terminados.
4. Copie el archivo de retorno a la carpeta prevista.
5. Importe el archivo desde la aplicación de sobremesa.
6. Revise el resumen de importación.
7. Abra los informes importados y valídelos antes de cerrarlos en sobremesa.

La importación omite los informes que sigan abiertos en Android. Además, los
informes aplicados quedan **no cerrados** en sobremesa para permitir su
revisión final.

Si existe un informe del mismo quirófano y mes, el aviso de conflicto ofrece:

- **Sí**: conservar la versión de Android y reemplazar la de sobremesa;
- **No**: conservar la versión que ya existe en sobremesa;
- **Cancelar**: detener la importación completa.

No seleccione **Sí** por defecto. Compare fecha, número de resultados,
observaciones y origen de cada versión.

### 6.7 Equipos de medida y certificados

Los equipos de medida afectan a la validez documental del informe. Antes de
usarlos, revise:

- nombre, marca, modelo y número de serie;
- fecha de calibración;
- fecha de caducidad;
- meses de preaviso;
- certificado asociado.

Los certificados administrados por Qontrolmed se conservan normalmente en:

    C:\ProgramData\Qontrolmed\docs\certificados

No cambie el nombre ni mueva un certificado desde el Explorador de archivos si
ya está asociado en la aplicación.

## 7. Preventivos

### 7.1 Finalidad

El módulo **Preventivos** permite:

- importar campañas o inventario desde Excel GMAO;
- crear informes preventivos por equipo;
- registrar comprobaciones cualitativas, cuantitativas y textuales;
- asociar equipos de medida;
- generar PDF y anexar certificados;
- cerrar informes;
- consultar el histórico;
- imprimir varios informes;
- intercambiar trabajo con tablet;
- administrar plantillas y puntos, según permisos.

### 7.2 Crear o cargar un informe

1. Entre en **Preventivos > Informes preventivos**.
2. Busque el equipo por centro, inventario, serie o selector disponible.
3. Compruebe descripción, marca, modelo, inventario y número de serie.
4. Indique **Fecha realización**, **Técnico**, **OT** y **Clase / Tipo**.
5. Pulse **Crear / cargar informe**.
6. Si ha cambiado datos de cabecera, pulse **Guardar cabecera**.

Qontrolmed puede mostrar equipos pendientes de una campaña y también informes
abiertos. Asegúrese de escoger el registro correcto antes de introducir
resultados.

### 7.3 Registrar resultados

La tabla muestra código, tipo, descripción, límite, estado, valor y referencia.

Para cada punto:

1. Seleccione la fila.
2. Introduzca el valor o texto requerido.
3. Pulse **Guardar valor** o **Guardar texto**, según el tipo.
4. Cuando proceda, marque:

| Estado | Significado |
| --- | --- |
| **B** | Resultado bueno o conforme. |
| **M** | Resultado malo o no conforme. |
| **NA** | Punto no aplicable. |
| **P** | Pendiente de completar. |

En puntos cuantitativos, la aplicación puede calcular el estado a partir del
valor y del criterio configurado. No fuerce manualmente un estado sin revisar
el límite y la referencia.

Use **Observaciones informe** para información general. Si activa
**Forzar NO APTO**, deje una justificación clara.

### 7.4 Equipos de medida

Pulse **Equipos de medida** para asociar al informe los instrumentos
utilizados. Compruebe su calibración y certificado.

Esta asociación debe completarse antes de generar el PDF definitivo si el
procedimiento exige anexar certificados.

### 7.5 Generar PDF

1. Cargue el informe correcto.
2. Pulse **Generar PDF**.
3. Responda si desea adjuntar certificados.
4. Revise los avisos:

- si no hay equipos de medida, no se adjunta ningún certificado;
- si ningún equipo tiene certificado, el PDF se genera sin anexos;
- si solo algunos tienen certificado, se adjuntan únicamente los disponibles.

5. Abra el archivo y revise datos de equipo, OT, resultados, observaciones,
   firmas y anexos.

Los PDF se guardan normalmente en:

    C:\ProgramData\Qontrolmed\output\preventivos

### 7.6 Cerrar un informe

Antes de cerrar:

- confirme la cabecera;
- revise que no quedan puntos pendientes;
- compruebe resultados **M** y observaciones;
- confirme los equipos de medida;
- genere y revise el PDF.

Al pulsar **Cerrar informe**, la aplicación valida los datos obligatorios. Si
faltan, muestra una lista y no permite cerrar.

Si quedan puntos pendientes, Qontrolmed puede preguntar si desea cerrar de
todos modos. La práctica recomendada es responder **No**, completar los puntos
y repetir la revisión. Use el cierre con pendientes solo si el procedimiento
de la empresa lo autoriza y queda documentada la causa.

Un informe cerrado queda bloqueado para edición.

### 7.7 Histórico e impresión múltiple

Desde **Histórico de informes** puede:

- localizar informes anteriores;
- abrirlos en consulta;
- regenerar su PDF, si dispone de permiso;
- comprobar o actualizar su estado de impresión según el flujo disponible.

Desde **Imprimir múltiples** puede trabajar con una campaña:

- generar un PDF conjunto;
- usar **Cargar equipos de medida** para asignarlos a los informes abiertos de
  una tipología;
- usar **Cerrar correctos sin comentarios** para cerrar en bloque únicamente
  los informes que cumplen todos los criterios.

El cierre masivo solo incluye informes completos, con resultados **B** o
**NA**, sin incidencias ni comentarios y con equipos de medida asociados.
Revise siempre el número de informes y la muestra mostrada en la confirmación.

### 7.8 Importación Excel GMAO

La importación GMAO es una operación masiva. Debe realizarla un usuario
autorizado y con una copia de seguridad confirmada.

Antes de importar:

1. verifique que el archivo corresponde a la campaña y centro correctos;
2. conserve el archivo original sin modificar;
3. confirme la estructura esperada;
4. asegúrese de que ningún usuario está modificando simultáneamente esa
   campaña;
5. revise el resumen y las incidencias al finalizar.

No repita una importación solo porque tarde o no vea inmediatamente un equipo.
Primero compruebe el resultado y los filtros.

### 7.9 Trabajo con tablet

#### Exportación

1. Pulse **Exportar para tablet**.
2. Seleccione la tipología.
3. Seleccione el técnico asignado.
4. Guarde el JSON en la ubicación propuesta o en la acordada.
5. Compruebe el resumen de equipos incluidos.
6. Transfiera ese archivo a la tablet.

#### Importación

1. Copie el archivo de retorno a la carpeta acordada.
2. Pulse **Importar desde tablet**.
3. Seleccione el JSON correcto.
4. Revise la vista previa y los conflictos.

Ante conflictos:

- **Sí** reemplaza en la base de datos el informe existente por el de la
  tablet;
- **No** conserva la base de datos y omite esos informes de tablet;
- **Cancelar** no importa nada.

Si el archivo contiene equipos que no existen en sobremesa, la aplicación
avisa y los omite si decide continuar. Conserve el archivo original hasta
verificar todos los resultados.

### 7.10 Plantillas y puntos de control

Las plantillas normalizan los puntos por tipología de equipo. En el piloto se
entregan como base provisional y deben compararse con las plantillas reales de
la empresa.

No modifique una plantilla, su tipología o sus puntos sin coordinación: el
cambio puede afectar a todos los informes nuevos que la utilicen.

## 8. Configuración, usuarios y seguridad

### 8.1 Datos de configuración

Según los permisos, la aplicación permite mantener:

- centros;
- usuarios;
- equipos;
- proveedores, repuestos, marcas y tipos de trabajo;
- quirófanos y sus puntos;
- equipos de medida y certificados;
- plantillas de Preventivos y sus puntos.

En una instalación nueva, los centros pueden estar vacíos. Se darán de alta
durante el piloto o tras la primera toma de contacto con la empresa.

### 8.2 Usuarios

La gestión de usuarios debe seguir estas reglas:

1. crear cuentas nominales;
2. asignar el rol correcto;
3. asignar el centro cuando proceda;
4. marcar **Técnico** solo a quien deba aparecer como ejecutor;
5. desactivar las cuentas que ya no deban acceder;
6. no reutilizar cuentas de personas anteriores;
7. no compartir la cuenta **administrador**.

No incluya contraseñas en correos, capturas, documentos ni incidencias.

### 8.3 Roles, permisos y auditoría

Los menús y acciones están protegidos por permisos. Que una ventana no aparezca
es normalmente una restricción prevista, no un fallo.

La auditoría permite revisar eventos relevantes y, con el permiso específico,
exportarlos. No debe alterarse la configuración de roles para resolver una
necesidad puntual sin aprobación del responsable.

### 8.4 Datos sensibles

Los informes pueden contener identificadores de equipos, ubicaciones,
observaciones técnicas y nombres de profesionales. Aplique estas normas:

- no copie los archivos a dispositivos personales;
- no envíe documentos por canales no autorizados;
- no publique capturas con datos reales;
- no deje sesiones abiertas;
- conserve los archivos solo en las ubicaciones acordadas;
- comunique cualquier acceso o envío incorrecto.

## 9. Archivos y ubicaciones

En la instalación RC5, la raíz compartida habitual es:

    C:\ProgramData\Qontrolmed

Principales ubicaciones:

| Contenido | Ruta |
| --- | --- |
| Salidas generales | C:\ProgramData\Qontrolmed\output |
| Informes de quirófano y libros | C:\ProgramData\Qontrolmed\output\quirofanos |
| Plantillas en blanco de quirófano | C:\ProgramData\Qontrolmed\output\quirofanos\plantillas_blanco |
| Informes preventivos | C:\ProgramData\Qontrolmed\output\preventivos |
| Plantillas en blanco de Preventivos | C:\ProgramData\Qontrolmed\output\preventivos\plantillas_blanco |
| Intercambio con Android | C:\ProgramData\Qontrolmed\output\export_tablet\quirofanos |
| Intercambio con tablet | C:\ProgramData\Qontrolmed\output\export_tablet\preventivos |
| Certificados | C:\ProgramData\Qontrolmed\docs\certificados |

La forma más sencilla de localizar las salidas es usar **Abrir salidas** desde
la portada.

No edite manualmente los JSON de intercambio ni cambie la estructura de sus
carpetas.

## 10. Copias de seguridad

### 10.1 Responsabilidad del usuario final

El usuario final no debe realizar copias o restauraciones de MySQL salvo que
tenga esa función asignada y haya recibido el procedimiento técnico.

Antes de una operación de riesgo, su responsabilidad es:

1. detenerse;
2. confirmar con el responsable que existe una copia reciente;
3. anotar qué operación va a realizar;
4. conservar los archivos de origen;
5. revisar el resultado antes de continuar.

Copiar únicamente la carpeta **output** no sustituye una copia de las bases de
datos.

### 10.2 Cobertura mínima para el responsable

La copia técnica debe contemplar:

- bases de datos **gestion**, **quirofanos** y **preventivos**;
- carpeta C:\ProgramData\Qontrolmed\output;
- carpeta C:\ProgramData\Qontrolmed\docs;
- configuración, tratada como información sensible;
- archivos externos que la empresa haya decidido almacenar fuera de esas
  carpetas.

El procedimiento detallado se mantiene en la documentación técnica de
instalación y preproducción, no en este manual de usuario.

## 11. Problemas frecuentes

### 11.1 No puedo iniciar sesión

Revise:

- usuario seleccionado;
- mayúsculas y minúsculas de la contraseña;
- bloqueo de mayúsculas del teclado;
- mensaje exacto mostrado.

Si persiste:

1. no pruebe repetidamente contraseñas ajenas;
2. pida que comprueben si su cuenta está activa;
3. si el error aparece antes del acceso, comuníquelo como posible problema de
   conexión o configuración.

No modifique el archivo .env.

### 11.2 No aparece un módulo o botón

Probablemente su usuario no tiene el permiso correspondiente.

1. Compruebe que ha entrado con su cuenta.
2. Anote el módulo y la acción que necesita.
3. Solicite al responsable que revise su rol.

No es necesario reinstalar la aplicación.

### 11.3 No encuentro una compra o un equipo

- limpie filtros demasiado restrictivos;
- compruebe CECO o centro;
- revise inventario, serie y OT;
- confirme que el elemento está activo;
- verifique que la importación correspondiente terminó correctamente.

No cree un duplicado hasta descartar que el registro exista con otro filtro.

### 11.4 No puedo crear un informe de Quirófanos

Motivos habituales:

- falta seleccionar quirófano;
- fecha inválida;
- ya existe un informe del mismo mes;
- equipo de medida caducado;
- falta configuración del quirófano o sus puntos;
- falta permiso de edición.

Use **Cargar**, revise el equipo y confirme la fecha antes de pedir soporte.

### 11.5 No puedo modificar un informe

Compruebe si muestra **CERRADO** o **MODO LECTURA**. En ese estado no debe
rehacerse por encima.

Anote el identificador del informe y consulte el procedimiento de corrección.
No cree otro informe para el mismo equipo o periodo sin autorización.

### 11.6 No encuentro el PDF

1. Lea la ruta indicada en el mensaje de generación.
2. Pulse **Abrir salidas**.
3. Entre en la subcarpeta **quirofanos** o **preventivos**.
4. Ordene por fecha de modificación.
5. Compruebe que estaba trabajando con el informe correcto.

Si el archivo no existe, anote el mensaje de error; no cierre repetidamente el
informe.

### 11.7 Aparecen conflictos al importar

Un conflicto significa que existe información para el mismo trabajo en el
dispositivo y en sobremesa.

Antes de decidir:

1. compare fecha, equipo, periodo y número de resultados;
2. identifique qué versión fue revisada más recientemente;
3. conserve el archivo de importación;
4. si no puede determinar la versión válida, pulse **Cancelar**.

### 11.8 Falta un certificado

1. Compruebe que el equipo de medida correcto está asociado.
2. Revise su ficha en **Equipos de medida**, si tiene permiso.
3. Compruebe la fecha de calibración.
4. Solicite al responsable que cargue el certificado.
5. Regenerar el PDF solo después de corregir la asociación.

### 11.9 La aplicación muestra un error inesperado

Para comunicar una incidencia, anote:

- fecha y hora;
- usuario;
- módulo y pantalla;
- operación realizada;
- identificador de compra o informe;
- texto completo del mensaje;
- si el registro estaba abierto o cerrado.

Puede adjuntar una captura solo si no expone contraseñas ni datos que no deban
salir del entorno autorizado.

## 12. Listas rápidas de comprobación

### Antes de cerrar un informe de Quirófanos

- [ ] Quirófano y periodo correctos.
- [ ] Fecha de realización y firma revisadas.
- [ ] Técnico correcto.
- [ ] Equipo de medida vigente.
- [ ] Todos los puntos revisados.
- [ ] Resultados MAL explicados.
- [ ] PDF generado y comprobado.

### Antes de cerrar un informe preventivo

- [ ] Equipo, inventario y serie correctos.
- [ ] Centro, técnico, fecha y OT revisados.
- [ ] Clase o tipo correcto.
- [ ] Sin puntos pendientes, salvo excepción autorizada.
- [ ] Resultados M y NO APTO justificados.
- [ ] Equipos de medida asociados.
- [ ] Certificados comprobados.
- [ ] PDF generado y revisado.

### Antes de importar desde Android o tablet

- [ ] Archivo y dispositivo de origen identificados.
- [ ] Copia de seguridad confirmada.
- [ ] Archivo original conservado.
- [ ] Nadie modifica simultáneamente el mismo trabajo.
- [ ] Conflictos leídos antes de responder.
- [ ] Resumen final revisado.
- [ ] Informes importados abiertos y comprobados.

## 13. Glosario

| Término | Significado |
| --- | --- |
| CECO | Centro de coste o centro organizativo utilizado por la instalación. |
| OT | Orden de trabajo. |
| GMAO | Sistema de gestión del mantenimiento asistido por ordenador. |
| Campaña | Agrupación de equipos y trabajos preventivos de un periodo. |
| Maestro | Dato compartido que condiciona otros registros, como centros, equipos o plantillas. |
| Informe abierto | Informe modificable y pendiente de validación final. |
| Informe cerrado | Informe finalizado y bloqueado para edición normal. |
| B / M / NA / P | Bueno, Malo, No aplica y Pendiente en Preventivos. |
| OK / MAL / NA | Conforme, No conforme y No aplica en Quirófanos. |

## 14. Regla final

Antes de dar un trabajo por terminado:

1. compruebe que ha trabajado con el usuario y registro correctos;
2. revise el documento generado;
3. confirme la ruta de salida;
4. cierre el informe solo cuando proceda;
5. cierre la sesión.

Si una decisión puede reemplazar datos, modificar un maestro compartido o
cerrar varios informes, deténgase ante cualquier duda y consulte al
responsable.

<!--
Control editorial interno:
- Las capturas anteriores se han retirado del cuerpo porque varias pertenecen
  a una interfaz anterior a RC5 y una contiene nombres de usuarios reales.
- Antes de entregar este manual a la empresa piloto, incorporar capturas RC5
  tomadas con una base de datos anonimizada o preparada específicamente para
  documentación.
- Revisar con la empresa la terminología local: CECO/centro, quirófano/sala,
  campaña y estados B/M/NA.
-->
