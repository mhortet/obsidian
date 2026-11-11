# Plan separado de actualizaciones de Qontrolmed para MySQL en LAN

Fecha: 2026-10-25 (`Europe/Madrid`)  
Estado: **planificación; no autoriza cambios en Qontrolmed ni en el servidor**  
Objetivo: preparar Qontrolmed para menos de diez equipos concurrentes en la LAN de `srv-mm-01`

## 1. Conclusión

Qontrolmed necesita cambios antes de considerarse apto para una conexión MySQL directa de producción por LAN. Los cambios obligatorios son acotados y se concentran en la configuración de conexión, TLS, timeouts, tratamiento de desconexiones, pruebas y documentación.

No se propone reescribir la aplicación, introducir una API ni añadir conexión remota. Tampoco se considera necesario un pool de conexiones para el MVP: cada instalación abre tres conexiones y, con menos de diez equipos, la carga base esperada es inferior a treinta sesiones, más operaciones auxiliares. Este supuesto deberá comprobarse durante el piloto.

## 2. Estado del código revisado

Revisión de solo lectura realizada el 2026-10-25, excluyendo cualquier `.env` real:

- `requirements.txt` fija `mysql-connector-python==9.7.0`.
- `src/compartido/configuracion.py` admite `DB_HOST`, `DB_PORT`, usuario, contraseña y los tres nombres de esquema.
- La conexión usa `use_pure=True` y `connection_timeout=5`.
- `src/compartido/db.py` abre tres conexiones clásicas para `gestion`, `quirofanos` y `preventivos`.
- `src/Quirofanos/db/connection.py` reutiliza la misma configuración.
- No se configuran `ssl_ca`, `ssl_verify_cert`, `ssl_verify_identity`, `tls_versions`, `read_timeout` ni `write_timeout`.
- No existe una política explícita de reconexión controlada.
- No se encontró uso de X DevAPI; Qontrolmed no necesita TCP/33060.

La biblioteca actual soporta los parámetros anteriores. MySQL Connector/Python intenta cifrar si el servidor lo permite, pero puede retroceder a una conexión sin cifrar si no se exige y valida TLS. Ese comportamiento no es suficiente para producción.

## 3. Cambios mínimos obligatorios

### QAPP-1. Configuración TLS explícita

Ampliar la configuración para admitir, al menos:

- ruta del certificado de la CA;
- `ssl_verify_cert=True`;
- `ssl_verify_identity=True`;
- `tls_versions=["TLSv1.2", "TLSv1.3"]`;
- opción de cliente TLS siempre activa en producción, sin retroceso silencioso.

El `DB_HOST` de producción debe ser un nombre estable incluido en el certificado del servidor. No debe resolverse el problema desactivando la verificación de identidad ni aceptando cualquier certificado.

**Aceptación**

- La conexión válida usa TLS y presenta un cifrado no vacío.
- Un certificado no confiable, caducado o con nombre incorrecto impide conectar.
- La aplicación muestra un error comprensible sin revelar credenciales ni detalles innecesarios.

**Reversión**

- Volver a la versión anterior únicamente en un entorno aislado de prueba. No se autoriza producción LAN sin validación TLS.

### QAPP-2. Timeouts completos y configurables

Conservar un timeout de conexión corto y añadir `read_timeout` y `write_timeout` con valores iniciales prudentes y configurables. Los valores exactos deberán medirse con consultas reales; no se fijan en este documento.

**Aceptación**

- Servidor inaccesible, lectura bloqueada y escritura bloqueada terminan con error controlado.
- La interfaz no queda esperando indefinidamente.
- Una consulta válida de larga duración no falla por un valor arbitrariamente bajo.

**Reversión**

- Ajustar los valores desde configuración y restaurar los anteriores; no eliminar los límites por completo sin una incidencia documentada.

### QAPP-3. Gestión de desconexión y reconexión

Centralizar la creación y validación de conexiones. Permitir reconectar de forma acotada **antes de iniciar una nueva operación** cuando la sesión esté cerrada o caducada.

No reintentar automáticamente una escritura que haya fallado después de enviarse: su resultado puede ser ambiguo y repetirla podría duplicar cambios. En ese caso la aplicación debe informar, registrar un identificador de operación cuando exista y exigir comprobación o reintento explícito.

**Aceptación**

- Tras una pérdida de red en reposo, una nueva operación puede recuperar una sesión sin reiniciar toda la aplicación.
- Una pérdida durante una escritura no provoca una repetición silenciosa.
- Las tres conexiones se cierran correctamente al salir.

**Reversión**

- Desactivar el mecanismo de reconexión nuevo y conservar el error explícito; nunca sustituirlo por reintentos ilimitados.

### QAPP-4. Endurecimiento de opciones de cliente

- Deshabilitar `LOAD DATA LOCAL INFILE` mediante `allow_local_infile=False` si ninguna función validada de Qontrolmed lo necesita.
- No habilitar opciones de protocolo adicionales sin caso de uso.
- Mantener el puerto clásico configurable y no añadir 33060.
- No registrar contraseñas, cadenas completas de conexión ni contenidos de `.env`.

**Aceptación**

- Las funciones actuales pasan las pruebas sin `LOCAL INFILE`.
- Los registros identifican módulo, equipo y tipo de fallo sin secretos.

**Reversión**

- Si una función legítima y auditada requiere carga local, documentarla y habilitarla solo para ese flujo, no de forma global por defecto.

### QAPP-5. Documentación y empaquetado

Actualizar, sin incluir secretos:

- plantilla de variables de entorno;
- guía de instalación por puesto;
- ubicación protegida del certificado CA;
- procedimiento de cambio de `DB_HOST`/`DB_PORT`;
- diagnóstico de certificado, red y credenciales;
- renovación de certificados;
- baja de un equipo y revocación de su cuenta;
- compatibilidad de la versión de Connector/Python empaquetada.

La aplicación debe fallar al inicio con un mensaje claro si falta la CA o si la configuración exige TLS y está incompleta.

## 4. Cambios recomendables, no bloqueantes para el primer piloto

- Identificador no sensible de la instalación para correlacionar incidencias.
- Cuenta MySQL distinta por equipo, manteniendo el mismo modelo de privilegios mínimos.
- Métrica o registro de conexión, desconexión y latencia sin SQL sensible.
- Prueba periódica de disponibilidad fuera del hilo principal de la interfaz.
- Revisión de consultas lentas después de obtener mediciones reales.
- Evaluar un pool pequeño solo si las mediciones demuestran aperturas frecuentes, contención o problemas de recuperación; no introducirlo por anticipado.

## 5. Dependencias del servidor

Los cambios de aplicación solo son eficaces si el lado MySQL se prepara de forma coherente:

- nombre DNS o nombre interno estable incluido en el certificado;
- certificado y clave de servidor con permisos correctos;
- `require_secure_transport=ON`;
- escucha limitada a la interfaz LAN aprobada;
- UFW permitiendo 3306 solo desde equipos o segmento autorizados;
- 33060 cerrado y X Plugin deshabilitado si procede;
- usuarios de aplicación de privilegio mínimo, preferiblemente revocables por equipo;
- copias, restauración probada y monitorización;
- ningún puerto MySQL publicado en Internet.

Estas son dependencias de implantación, no cambios autorizados por este plan.

## 6. Pruebas necesarias

### Pruebas unitarias

- puerto válido e inválido;
- configuración TLS completa e incompleta;
- rutas de CA existentes e inexistentes;
- construcción de la configuración sin exponer secretos;
- valores de timeout;
- desactivación de `LOCAL INFILE`;
- cierre idempotente de las tres conexiones.

### Pruebas de integración en entorno aislado

- conexión correcta con certificado válido;
- rechazo por CA incorrecta;
- rechazo por identidad distinta del `DB_HOST`;
- rechazo de conexión TCP sin TLS;
- acceso correcto a los tres esquemas y denegación fuera de ellos;
- equipo no autorizado sin alcance a 3306;
- caída y recuperación de red en reposo;
- caída durante lectura;
- caída durante escritura sin duplicación silenciosa;
- reinicio controlado de MySQL;
- certificado renovado;
- copia y restauración de prueba.

### Prueba de carga proporcional

Probar primero un equipo, después dos y finalmente el máximo real previsto. Medir sesiones, latencia, errores, bloqueos y comportamiento de la interfaz. No es necesario simular una gran plataforma: la prueba debe representar menos de diez equipos y las operaciones reales de la empresa.

## 7. Secuencia propuesta

### QP0. Confirmación documental

- Confirmar equipos, nombres, sistema operativo y responsable.
- Elegir nombre estable del servidor y modelo de certificados.
- Acordar cuentas MySQL por equipo o justificar una cuenta común temporal.

### QP1. Desarrollo y pruebas sin servidor de producción

- Implementar QAPP-1 a QAPP-5 en una rama de Qontrolmed.
- Añadir pruebas unitarias.
- Crear un entorno MySQL de integración con datos ficticios.
- Verificar los casos de fallo.

### QP2. Preparación controlada del servidor

- Revalidar primero el servidor en solo lectura.
- Presentar y aprobar un plan de cambio exacto para MySQL, TLS, UFW, usuarios, copias y reversión.
- Validar la configuración antes de arrancar MySQL.

### QP3. Piloto con un equipo

- Instalar la versión candidata y la CA por un canal controlado.
- Probar los tres esquemas, caída de red, revocación y restauración.
- Mantener una vía de recuperación y no retirar la solución anterior hasta aceptar el piloto.

### QP4. Ampliación gradual

- Añadir un segundo equipo y observar.
- Incorporar los restantes por lotes pequeños.
- Revisar al alcanzar el máximo simultáneo real.

### QP5. Cierre de producción

- Registrar versión, hash del instalador, configuración no secreta, equipos, cuentas, certificado, copia inicial y resultado de aceptación.
- Definir responsable de renovaciones, altas, bajas, copias y alertas.

## 8. Criterio global de aceptación

Qontrolmed podrá considerarse preparado para la LAN cuando:

1. todos los puestos validen el certificado y la identidad de `srv-mm-01`;
2. el servidor rechace conexiones TCP no cifradas;
3. solo los equipos autorizados alcancen 3306;
4. cada cuenta tenga únicamente privilegios sobre los tres esquemas necesarios;
5. 33060 permanezca cerrado;
6. las desconexiones no bloqueen indefinidamente la interfaz ni dupliquen escrituras;
7. la copia y la restauración hayan sido probadas;
8. un equipo pueda darse de baja y perder acceso sin afectar a los demás;
9. exista aceptación explícita del propietario.

## 9. Elementos aplazados

- Acceso remoto, VPN o túneles por puesto.
- Trabajo desconectado y fusión de bases.
- API intermedia o versión web.
- Pool de conexiones salvo evidencia de necesidad.
- Alta disponibilidad o clúster MySQL.
- Protocolo X y puerto 33060.

## 10. Fuentes técnicas

- MySQL Connector/Python, argumentos de conexión: <https://dev.mysql.com/doc/connectors/en/connector-python-connectargs.html>
- MySQL 8.4, configuración de conexiones cifradas: <https://dev.mysql.com/doc/refman/8.4/en/using-encrypted-connections.html>
- MySQL 8.4, protocolos de transporte: <https://dev.mysql.com/doc/refman/8.4/en/transport-protocols.html>
- `D:\trabajo\Proyectos\maxgesth\src\compartido\configuracion.py`
- `D:\trabajo\Proyectos\maxgesth\src\compartido\db.py`
- `D:\trabajo\Proyectos\maxgesth\src\Quirofanos\db\connection.py`
- `D:\trabajo\Proyectos\maxgesth\requirements.txt`

