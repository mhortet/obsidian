# Evaluación y plan de acción: repositorio remoto y piloto Qontrolmed

Fecha de elaboración: 2026-10-08 (`Europe/Madrid`)  
Estado: **propuesta para validación; ninguna fase de ejecución autorizada**  
Ámbito: `srv-mm-01`, repositorio documental privado y piloto de Qontrolmed  
Documento de origen: `PROPUESTA-REPOSITORIO-REMOTO-DOCUMENTOS-2026-10-06.md`

## 1. Objeto y límite de este documento

Este documento valora las respuestas incorporadas a la Fase 0 y propone una secuencia ejecutable por fases. Su aprobación permitirá preparar después planes de cambio concretos, pero **no autoriza por sí sola** a instalar servicios, arrancar MySQL, crear usuarios, abrir puertos, modificar UFW, cambiar la red, reutilizar discos ni alterar Qontrolmed.

El repositorio documental y Qontrolmed se tratarán como dos líneas de trabajo separadas que comparten infraestructura y controles. No se permitirá que la urgencia de una línea rebaje los requisitos de la otra.

Se mantiene fuera de alcance cualquier dato de pacientes, historia clínica, diagnóstico, imagen médica o identificador clínico. Los datos de trabajadores, técnicos, proveedores, contactos, autenticación y actividad siguen siendo datos personales protegidos.

## 2. Valoración ejecutiva

### 2.1. Repositorio documental

La necesidad inicial queda suficientemente acotada para mantener la recomendación de **SFTPGo WebClient** como piloto:

- carga y descarga manual, sin sincronización automática;
- hasta diez usuarios en la primera etapa;
- acceso desde fuera de la sede;
- una carpeta común en la que los usuarios autorizados puedan crear subcarpetas;
- uso predominante de PDF pequeños;
- sin enlaces públicos, papelera funcional, versionado ni trabajo sin conexión;
- objetivo inicial de recuperación de hasta 24 horas (`RTO <= 24 h`);
- tolerancia a perder, como máximo, el trabajo desde la última copia diaria (`RPO <= 24 h`).

La propuesta es adecuada para un piloto siempre que se incorporen estas condiciones:

1. Cada persona tendrá una cuenta nominal, aunque todas accedan a una carpeta común.
2. La carpeta común será una carpeta virtual compartida; su ruta física y sus directorios superiores permanecerán bajo control administrativo.
3. Se definirán permisos de borrado, renombrado y creación de subcarpetas. "Carpeta general" no debe equivaler a permisos administrativos.
4. Se fijarán una cuota global, un tamaño máximo por archivo y umbrales de alerta antes de introducir datos reales.
5. El acceso remoto se realizará únicamente a través de una VPN; el WebClient, SFTP, SMB y MySQL no se publicarán directamente en Internet.
6. La copia diaria tendrá un destino independiente del volumen de producción. Una copia mensual externa, por sí sola, no cumple el RPO diario ni una estrategia 3-2-1.
7. Los PDF recibidos desde equipos externos se someterán a restricción de tipo/tamaño y a análisis antimalware o cuarentena antes de su uso ordinario.

### 2.2. VPN sin proveedor externo

El rechazo provisional a una VPN o identidad gestionada es compatible con una solución **WireGuard autogestionada**, pero no basta para cerrar el diseño. Antes hay que confirmar:

- si la sede dispone de IP pública o se encuentra bajo CGNAT;
- quién controla el router o cortafuegos perimetral;
- si puede publicarse exclusivamente el puerto UDP de la VPN;
- si existe un nombre DNS estable o se requiere DNS dinámico;
- si WireGuard residirá en una pasarela dedicada o, solo para el piloto, en `srv-mm-01`;
- quién custodiará, entregará y revocará las claves de los dispositivos;
- qué persona podrá recuperar el servicio si falla la VPN.

Si no existe un extremo alcanzable desde Internet y se mantiene el rechazo a un servicio externo, **el acceso remoto no es técnicamente realizable** sin cambiar la conectividad o instalar la VPN en otra pasarela accesible.

### 2.3. Copias

El RPO y el RTO propuestos son razonables para el repositorio documental inicial, pero falta decidir los destinos y la retención. Se propone para validación:

- copia cifrada diaria a un destino independiente, con 30 puntos diarios;
- copia cifrada mensual, desconectada y preferiblemente fuera de la sede, con 12 puntos mensuales;
- verificación automática de la copia y restauración de muestra al menos trimestral;
- una restauración completa controlada antes de declarar el repositorio como ubicación única;
- responsable nominal de conectar, retirar, custodiar y rotar el soporte externo.

El SSD de 1 TB (`/dev/sdb`) no se considera destino aprobado y permanecerá intacto hasta conocer su contenido, custodia y uso autorizado. Una copia en ese mismo servidor tampoco sería suficiente como única copia independiente.

### 2.4. Propuesta de Qontrolmed

La propuesta de conservar temporalmente Qontrolmed y separar puestos locales de puestos remotos es razonable como estrategia de evaluación, pero **no es segura ni operativamente aceptable si se interpreta como importar volcados completos de bases de datos remotas sobre MySQL central**.

Riesgos principales:

- colisión de claves e identificadores entre bases creadas de forma independiente;
- duplicación o sustitución de registros ya existentes;
- pérdida de relaciones entre tablas o de trazabilidad histórica;
- diferencias de versión de esquema entre puestos;
- reimportación accidental del mismo paquete;
- exposición de credenciales, definiciones de usuarios u otros elementos incluidos en un volcado SQL;
- importación parcial si falla una operación;
- conflicto entre modificaciones concurrentes realizadas en sede y fuera de ella;
- incorporación de ficheros manipulados o no validados desde la carpeta común.

La documentación disponible ya muestra que uno de los flujos de movilidad de Qontrolmed impide importar sobre una base local no vacía. Por tanto, no se puede asumir que el mecanismo actual sirva para fusionar trabajo procedente de varias bases en una base central con datos reales.

La idea se acepta únicamente con este cambio de enfoque:

- los puestos remotos trabajarán sin conexión con una base local solo después de delimitar qué datos pueden crear o modificar;
- exportarán un **paquete de intercambio definido y versionado**, no una copia arbitraria de la base;
- cada paquete tendrá origen, identificador único, versión de esquema, fecha, recuentos, hash e información mínima de trazabilidad;
- la recepción se realizará en una ruta separada de la carpeta documental general;
- el importador validará el paquete en una zona de preparación, detectará duplicados y conflictos, y solo después aplicará una transacción controlada;
- un paquete aceptado no podrá procesarse por segunda vez;
- antes de importar se realizará una copia recuperable y después se registrarán resultado, recuentos y responsable;
- los paquetes rechazados se conservarán aislados con su causa, sin aplicar cambios parciales.

Este mecanismo requiere revisión del código y del esquema de Qontrolmed antes de diseñarse. Si Qontrolmed no dispone actualmente de identificadores estables, reglas de conflicto e importación transaccional, esa capacidad será un desarrollo del piloto y no una simple configuración del servidor.

### 2.5. Conexión de los puestos locales a MySQL

Mantener Qontrolmed "tal y como está" no es compatible con una conexión MySQL directa de varios puestos por la LAN de producción: el cliente actual no exige validación TLS, no verifica la identidad del servidor y carece de timeouts completos y reconexión controlada.

Para un primer puesto local se recomienda:

- túnel SSH persistente y supervisado;
- Qontrolmed apuntando a `127.0.0.1` y a un puerto local reenviado;
- MySQL sin publicación en Internet y sin necesidad de abrir 3306 a toda la LAN;
- cuenta MySQL propia, privilegios mínimos y credenciales separadas de las cuentas administrativas.

Si el piloto exige varios puestos locales, habrá que elegir expresamente entre:

1. mantener un túnel por puesto, aceptando su carga operativa durante el piloto; o
2. actualizar antes Qontrolmed para usar LAN segmentada con TLS obligatorio, CA validada, verificación de identidad y timeouts completos.

La segunda opción es la adecuada para una implantación estable con varios equipos. En ningún caso se expondrán 3306 o 33060 a Internet.

### 2.6. Preparación para una integración futura

"Dejar preparado" el servidor no debe significar instalar componentes sin uso, abrir puertos o crear cuentas anticipadas. En esta etapa significa:

- conservar el volumen separado de MySQL y la reserva de almacenamiento;
- definir nombres, segmentación, certificados, copias y monitorización de forma compatible con una evolución posterior;
- reservar rutas y permisos separados para documentos y paquetes de intercambio;
- documentar las decisiones y evitar dependencias provisionales irreversibles;
- diseñar la futura versión de Qontrolmed con una interfaz de aplicación autenticada o, si se mantiene acceso SQL, con TLS verificado y mínimo privilegio.

## 3. Decisiones que pueden considerarse cerradas

| Decisión | Valor propuesto |
| --- | --- |
| Servicio documental piloto | SFTPGo WebClient |
| Experiencia | Carga y descarga manual |
| Escala inicial | Hasta 10 usuarios nominales |
| Organización inicial | Una carpeta común con creación de subcarpetas |
| Acceso remoto | Sí, exclusivamente por VPN |
| Dependencia de VPN gestionada | Rechazada provisionalmente |
| VPN candidata | WireGuard autogestionada, condicionada a la conectividad de la sede |
| Versionado, enlaces públicos y modo sin conexión | No requeridos en el piloto |
| RPO documental | Hasta 24 horas |
| RTO documental | Hasta 24 horas |
| Publicación directa de WebClient/SFTP/SMB/MySQL | No permitida |
| MySQL 33060 | No requerido; debe permanecer cerrado |
| Datos de pacientes | Fuera de alcance |

## 4. Decisiones pendientes antes de ejecutar

1. Red definitiva de la sede, IP pública o CGNAT, control del router y ubicación del extremo WireGuard.
2. Nombre DNS estable y responsable de su mantenimiento.
3. Lista inicial de usuarios y dispositivos; responsable de altas, bajas y revocaciones.
4. Derechos exactos en la carpeta común: borrado, renombrado y recuperación por error.
5. Cuota global, tamaño máximo por fichero y crecimiento previsto. Propuesta de partida: cuota lógica de 50 GB para el piloto y límite de 25 MB por archivo, ambos revisables tras medir el uso.
6. Destino de la copia diaria, soporte de la copia mensual y responsable de custodia.
7. Retención final. Propuesta de partida: 30 diarias y 12 mensuales.
8. Número de puestos locales de Qontrolmed y disponibilidad esperada.
9. Datos que puede crear o modificar un puesto remoto de Qontrolmed y regla de autoridad ante conflictos.
10. Capacidad real de exportación/importación de Qontrolmed y compatibilidad entre versiones del esquema.
11. Responsable de validar e importar los paquetes remotos.
12. Responsable de aprobación de la entrada en servicio.

Los valores de 50 GB, 25 MB y las retenciones son propuestas de diseño, no configuraciones autorizadas.

## 5. Plan de acción por fases

Cada fase termina en una puerta de aprobación. No se continúa automáticamente a la siguiente.

### Fase 0. Validación del plan y cierre de decisiones

**Propósito**

Convertir las respuestas actuales en un alcance aprobado y resolver las decisiones de la sección 4.

**Acciones documentales**

- Validar o corregir las decisiones de la sección 3.
- Recoger la información de red, usuarios, copias y responsables sin solicitar secretos.
- Elegir la ubicación de WireGuard y los destinos de copia.
- Confirmar el número de puestos locales y remotos de Qontrolmed.
- Acordar que el intercambio remoto de Qontrolmed no utilizará volcados completos sin una validación técnica previa.

**Criterio de aceptación**

- Registro de decisión completo, responsable y fecha de aprobación.
- Ninguna contradicción entre acceso remoto, rechazo de proveedor y conectividad real de la sede.
- Destinos de copia y custodia definidos.

**Reversión**

- No aplica: es una fase documental sin cambios técnicos.

**Puerta 0**

- Aprobación explícita del propietario para realizar solo la revalidación de la Fase 1.

### Fase 1. Revalidación de solo lectura

**Propósito**

Confirmar que el servidor continúa en el estado seguro documentado antes de redactar comandos o planes de cambio.

**Acciones**

- Validar de nuevo el acceso SSH por clave y la huella del host desde una consola controlada.
- Conservar una sesión de recuperación cuando posteriormente se prueben cambios de red o UFW.
- Recoger evidencia fechada de sistema, paquetes pendientes, servicios fallidos, montajes, espacio, permisos, UFW, escuchas y estado de MySQL.
- Confirmar que MySQL sigue inactivo y que 3306/33060 permanecen cerrados.
- No leer ni mostrar credenciales, `.env`, claves privadas ni datos reales.
- No modificar el SSD de 1 TB.

**Criterio de aceptación**

- Informe de diferencias respecto de la línea base, o confirmación de que no existen diferencias relevantes.
- Montajes y espacio adecuados; ningún servicio o puerto inesperado.

**Reversión**

- No aplica: todas las comprobaciones serán de solo lectura.

**Puerta 1**

- Aprobación de un plan de cambio exacto para la preparación local del repositorio.

### Fase 2. Repositorio local sin exposición

**Propósito**

Instalar y probar el servicio documental sin acceso desde Internet y sin datos reales.

**Acciones previstas**

- Copiar y registrar la configuración previa afectada.
- Crear la estructura física definitiva bajo `/srv/compartido/repositorio/`.
- Separar la carpeta documental común de una futura cola restringida de Qontrolmed.
- Aplicar propietario, grupo, permisos y ACL de mínimo privilegio.
- Instalar SFTPGo desde una fuente oficial verificada y documentar su actualización.
- Crear una cuenta de servicio sin shell y separar configuración, registros y documentos.
- Mantener la escucha en loopback o en una interfaz privada de prueba.
- Crear una cuenta administrativa separada y una cuenta piloto nominal.
- Configurar la carpeta virtual común, cuota de prueba y límite de tamaño.
- Deshabilitar protocolos no utilizados.
- Probar subida, descarga, creación de carpeta, renombrado, borrado, denegación, cuota, bloqueo, registro y MFA con ficheros no sensibles.

**Criterio de aceptación**

- La cuenta piloto solo ve las rutas autorizadas.
- El servicio no queda accesible desde redes no aprobadas.
- Los directorios superiores no son escribibles por el usuario del servicio ni por usuarios ordinarios.
- La cuota y los registros funcionan sin exponer secretos.

**Reversión**

- Detener y deshabilitar SFTPGo.
- Restaurar la configuración previa.
- Revocar las cuentas piloto.
- Conservar los ficheros de prueba para revisión o retirarlos en una acción separada autorizada.

**Puerta 2**

- Aprobación del diseño de WireGuard y del cambio de red/UFW correspondiente.

### Fase 3. Acceso remoto privado

**Propósito**

Permitir acceso remoto al repositorio sin publicar el servicio documental directamente.

**Acciones previstas**

- Implantar WireGuard en la ubicación aprobada.
- Abrir únicamente el puerto UDP de la VPN en el perímetro y en UFW cuando sea necesario.
- Crear una clave diferente por dispositivo; no compartir claves entre usuarios.
- Limitar las rutas de cada par al servidor y servicios estrictamente necesarios.
- Servir el WebClient mediante HTTPS con nombre y certificado validables dentro de la VPN.
- Mantener WebClient, SFTP, SSH administrativo, SMB, 3306 y 33060 fuera de exposición directa a Internet.
- Probar desde una conexión externa autorizada y desde un dispositivo no enrolado.
- Probar revocación de dispositivo y recuperación operativa.

**Criterio de aceptación**

- Un dispositivo autorizado accede únicamente al servicio aprobado.
- Un dispositivo no enrolado no alcanza el servicio.
- La revocación elimina el acceso en el tiempo acordado.
- Un escaneo externo no muestra WebClient, SFTP, SMB ni MySQL publicados.

**Reversión**

- Revocar los pares piloto.
- Retirar solo las reglas y rutas creadas para WireGuard.
- Restaurar las configuraciones de red y UFW fechadas.
- Verificar de nuevo SSH desde una conexión nueva antes de cerrar la sesión de recuperación.

**Puerta 3**

- Aprobación para implantar copias, cuarentena y monitorización antes de usar datos reales.

### Fase 4. Copias, restauración y controles de contenido

**Propósito**

Evitar que el piloto convierta el servidor en la única copia y reducir el riesgo de ficheros dañinos.

**Acciones previstas**

- Implantar la copia cifrada diaria al destino independiente aprobado.
- Implantar la rotación mensual externa y desconectada.
- Verificar integridad y alertar de fallos o falta de ejecución.
- Restaurar una muestra aislada y realizar una restauración completa de ensayo.
- Restringir extensiones y tamaños a los necesarios para el piloto.
- Incorporar análisis antimalware o cola de cuarentena para entradas externas.
- Definir retención de registros y copias sin conservar datos indefinidamente.
- Documentar pérdida de dispositivo, recuperación de MFA, restauración y respuesta a una carga sospechosa.

**Criterio de aceptación**

- Copia diaria completada y verificada.
- Restauración de muestra y restauración completa de ensayo satisfactorias.
- Una carga rechazada o sospechosa no se incorpora al área ordinaria.
- Alertas recibidas por la persona responsable.

**Reversión**

- Deshabilitar las tareas nuevas conservando la última copia válida.
- Restaurar configuración previa.
- No borrar copias ni cuarentena hasta autorizar su disposición.

**Puerta 4**

- Aprobación formal de entrada en piloto con datos de trabajo permitidos.

### Fase 5. Piloto documental con usuarios reales

**Propósito**

Validar la operativa con un grupo reducido antes de llegar a diez usuarios.

**Acciones previstas**

- Alta escalonada: primero dos usuarios, después ampliación si no hay incidencias.
- Entrega individual de acceso y MFA; ninguna credencial compartida.
- Registro de incidencias, espacio, intentos fallidos, cargas rechazadas y tiempos de recuperación.
- Revisión a los 7 y 30 días.
- Prueba de baja de usuario y revocación de dispositivo.
- Decisión documentada de continuar, corregir, migrar a Nextcloud o retirar el servicio.

**Criterio de aceptación**

- Operativa comprensible para los usuarios.
- Sin accesos cruzados no autorizados ni publicación accidental.
- RPO/RTO y soporte asumibles por la empresa.
- Restauración y baja de usuario verificadas.

**Reversión**

- Revocar usuarios y dispositivos.
- Detener el acceso sin borrar documentos.
- Exportar y custodiar los documentos si se decide retirar la plataforma.

## 6. Línea paralela de Qontrolmed

Esta línea no comenzará por modificar MySQL. Comenzará por demostrar que el flujo de datos es seguro y repetible.

### Q0. Análisis del intercambio y decisión de autoridad

**Acciones**

- Revisar código, esquema y funciones actuales de exportación/importación sin abrir `.env` reales.
- Inventariar tablas y relaciones afectadas por el trabajo remoto.
- Identificar claves, autoincrementos, restricciones, historiales y campos de versión.
- Definir qué sistema es autoridad para cada tipo de dato.
- Definir conflictos: duplicado, edición simultánea, registro borrado y versión de esquema distinta.
- Diseñar el formato del paquete y el flujo `entrada -> preparación -> aceptado/rechazado -> archivo`.
- Diseñar idempotencia, copia previa, transacción, validación y auditoría.
- Preparar pruebas con datos ficticios.

**Criterio de aceptación**

- Se demuestra que un paquete puede aplicarse una sola vez, sin sobrescribir datos no autorizados y sin dejar cambios parciales.
- Los conflictos producen rechazo o revisión explícita, nunca una sustitución silenciosa.

**Puerta Q0**

- Si no se puede demostrar lo anterior, no habrá importación remota durante el piloto. El trabajo remoto se limitará a documentos o se desarrollará primero la función de sincronización.

### Q1. Piloto local centralizado

**Acciones previstas**

- Empezar con un único puesto Windows controlado.
- Aprobar por separado el arranque y endurecimiento de MySQL, la creación de esquemas, la cuenta mínima y la carga inicial.
- Usar un túnel SSH persistente y supervisado para conservar el modelo local de Qontrolmed.
- Probar desconexión, reconexión, caída del túnel, reinicio del puesto y restauración de base.
- Mantener 3306/33060 fuera de Internet.

**Criterio de aceptación**

- El puesto no puede conectar si se retira el túnel o su autorización.
- No se usan cuentas administrativas desde Qontrolmed.
- La caída de red no produce corrupción ni operaciones ambiguas.
- La restauración de ensayo es satisfactoria.

**Puerta Q1**

- Antes de añadir más puestos: aceptar túneles por puesto o aprobar el desarrollo TLS para LAN segmentada.

### Q2. Piloto remoto desconectado

**Acciones previstas**

- Habilitar un solo puesto remoto y un conjunto limitado de operaciones.
- Generar un paquete de prueba, subirlo a la cola restringida y verificar hash, versión y origen.
- Validar en preparación con datos ficticios; después realizar una prueba controlada con datos de trabajo permitidos.
- Importar con copia previa, transacción, recuentos antes/después y registro del responsable.
- Reintentar el mismo paquete para comprobar que se rechaza como duplicado.
- Simular conflicto y versión incompatible.

**Criterio de aceptación**

- Ninguna duplicación, pérdida, sustitución silenciosa ni importación parcial.
- Trazabilidad completa desde el puesto origen hasta el resultado central.
- El usuario remoto no puede leer paquetes de otros orígenes ni acceder a MySQL.

**Reversión**

- Suspender la importación remota.
- Restaurar la copia previa si la validación posterior detecta un defecto.
- Conservar el paquete y las evidencias para análisis.

### Q3. Decisión tras el piloto

Al terminar el piloto se elegirá una de estas rutas:

1. retirar el flujo remoto y mantener solo operación local;
2. mantener temporalmente paquetes controlados, con límites y responsable explícitos;
3. desarrollar sincronización robusta en Qontrolmed;
4. evolucionar a una arquitectura con API autenticada que evite entregar acceso directo a la base;
5. para varios puestos locales, actualizar el cliente para LAN segmentada con TLS verificado.

No se instalarán anticipadamente componentes de la opción futura hasta aprobar su arquitectura.

## 7. Orden recomendado

```text
Validar este plan
        |
        v
Cerrar red, copias, responsables y alcance de Qontrolmed
        |
        v
Revalidación SSH de solo lectura
        |
        +---------------------------+
        |                           |
        v                           v
Repositorio local              Q0: analizar intercambio
        |                           |
        v                           v
VPN privada                  Q1: un puesto local
        |                           |
        v                           v
Copias y cuarentena          Q2: un remoto, solo si Q0 pasa
        |                           |
        +-------------+-------------+
                      |
                      v
          Piloto limitado y evaluación
```

La línea documental puede avanzar hasta su propio piloto aunque Qontrolmed quede detenido en Q0. La línea Qontrolmed no puede saltarse Q0 por disponer ya de una carpeta de intercambio.

## 8. Condiciones de parada

Se detendrá la fase en curso si aparece cualquiera de estas condiciones:

- pérdida de acceso administrativo o fallo de la conexión SSH de prueba;
- discrepancia no explicada en red, UFW, montajes, paquetes o servicios;
- necesidad de usar la IP o la red temporal como configuración definitiva;
- falta de copia recuperable antes de un cambio de datos;
- publicación directa no prevista de WebClient, SFTP, SMB o MySQL;
- imposibilidad de revocar un usuario o dispositivo;
- copia diaria no independiente o restauración fallida;
- paquete Qontrolmed sin origen, versión, hash o identificador único;
- conflicto de datos no resuelto o importación no transaccional;
- aparición de datos de pacientes o de información fuera del alcance permitido;
- necesidad de tocar `/dev/sdb`, firmware, Secure Boot, PAM o componentes ajenos al plan.

## 9. Próxima decisión solicitada

Antes de cualquier acceso SSH o cambio técnico, el propietario debe:

1. validar, corregir o rechazar la valoración de las secciones 2 y 3;
2. responder las decisiones pendientes de la sección 4 que ya conozca;
3. aprobar únicamente la **Fase 1 de revalidación de solo lectura** cuando desee iniciar la ejecución.

Tras esa aprobación se validará el acceso SSH por clave y se presentará el resultado de la revalidación. Cada fase de cambio tendrá su propio propósito, comandos o acciones exactas, riesgo, aceptación y reversión antes de ejecutarse.

## 10. Referencias técnicas revisadas

Consultadas el 2026-10-08:

- SFTPGo, carpetas virtuales y cuotas: <https://docs.sftpgo.com/latest/virtual-folders/>
- WireGuard, configuración y comportamiento tras NAT/cortafuegos: <https://www.wireguard.com/quickstart/>
- MySQL 8.4, copias y recuperación: <https://dev.mysql.com/doc/refman/8.4/en/backup-and-recovery.html>
- MySQL 8.4, `mysqldump`: <https://dev.mysql.com/doc/refman/8.4/en/mysqldump.html>
- MySQL 8.4, restricciones de clave primaria, única y foránea: <https://dev.mysql.com/doc/refman/8.4/en/constraints.html>

