---
title: "Continuación de srv-mm-01"
type: register
status: active
created: 2026-11-01
updated: 2026-11-05
sources:
  - "00_seguimiento/estados/ESTADO-OPERATIVO-SRV-MM-01-2026-11-01.md"
tags: [documentacion, seguridad, administracion]
review_after: 2026-11-08
---

# Continuación de `srv-mm-01` — siguiente sesión

## Último estado: certificado del cambio 03 completado

[Estado vigente del piloto](00_seguimiento/estados/ESTADO-CAMBIO-01-PILOTO-2026-11-05.md): configuración local validada, MySQL detenido/deshabilitado. [Cambio 02 ejecutado con resultado parcial](00_seguimiento/estados/ESTADO-CAMBIO-02-PILOTO-2026-11-05.md): MySQL detenido/deshabilitado, sin escucha. Pendiente completar prueba sin TLS con cuenta apropiada; [Cambio 03 completado y verificado](00_seguimiento/estados/ESTADO-CAMBIO-03-PILOTO-2026-11-05.md), MySQL detenido/deshabilitado. Plan conjunto restante autorizado con este PC como piloto. Fase local y adaptación aislada preparadas; pendiente ejecución sudo de piloto-local-20261105.py y recogida de resultado antes de LAN. Aplicar autorización por plan según AGENTS.md, sin permisos por cada paso incluido. Las referencias posteriores a cambio 01 pendiente son históricas.

## Actualización de continuidad — 2026-11-05

- Revalidación reciente: [estado del 5 de noviembre](00_seguimiento/estados/ESTADO-REVALIDACION-SRV-MM-01-2026-11-05.md). SSH accesible, sistema sano y MySQL disabled/inactive; sin escucha 3306/33060. Las reglas de UFW no se revalidaron por requerir sudo local.
- Aceptado por el propietario: piloto doméstico con un único puesto y datos ficticios. No equivale a aprobar arranque MySQL, cuentas, esquemas o apertura de puertos.
- [Propuesta de preparación y pruebas](02_planes_y_arquitectura/PROPUESTA-MYSQL-SRV-MM-01-2026-11-05.md).
- [Diario de sesión](00_seguimiento/diario/2026-11-05-revalidacion-y-plan-piloto-mysql.md).
- Completar IP del puesto, nombre estable/certificados, destino de copia y revisión de Qontrolmed antes de presentar el cambio ejecutable.
- Guardar toda documentación nueva en las carpetas de la estructura existente, manteniendo estado, diario y relevo coordinados.
- El detalle siguiente corresponde al cierre del 1 de noviembre salvo las comprobaciones explícitas de esta actualización.
## Punto seguro de reanudación

- Última validación: 2026-11-01, después de un reinicio controlado.
- Host: `srv-mm-01`; kernel activo `6.8.0-147-generic`.
- LAN doméstica temporal: `192.168.1.0/24`.
- Reserva DHCP: `192.168.1.31` para `eno1`, MAC `74:fe:48:67:be:cc`.
- Gateway y DNS observados: `192.168.1.1`.
- SSH: `ssh.socket` habilitado y activo; acceso por clave validado.
- UFW: habilitado y activo. Antes del reinicio se observaron únicamente reglas TCP/22 desde `192.168.1.0/24` y `192.168.0.0/24`.
- Prueba externa posterior: TCP/22 abierto; 3306, 33060 y 445 cerrados.
- MySQL Community Server 8.4.11: `disabled`, `inactive`, sin proceso y con `MYSQL_PORTS_CLOSED`.
- No hay usuarios ni esquemas Qontrolmed creados.
- Montajes `/var/lib/mysql` y `/srv/compartido` correctos.
- Sistema `running`, sin unidades fallidas y sin reinicio pendiente.
- La consola física quedó disponible como recuperación.

El detalle completo está en [ESTADO-OPERATIVO-SRV-MM-01-2026-11-01.md](00_seguimiento/estados/ESTADO-OPERATIVO-SRV-MM-01-2026-11-01.md).

## Qué ocurrió el 2026-11-01

1. `192.168.1.30` ya pertenecía a otro dispositivo; la MAC documentada del servidor apareció en `192.168.1.31`.
2. Se verificó `.31` mediante MAC, clave SSH conocida, usuario y hostname.
3. El propietario reservó `.31` en el router para la MAC de `eno1`.
4. Se detectó que MySQL había arrancado automáticamente por estar habilitado y escuchaba en `*:3306` y `*:33060`; UFW impedía alcanzarlo desde Windows.
5. La auditoría confirmó valores predeterminados: `bind_address=*`, `mysqlx_port=33060`, `require_secure_transport=OFF` y sin cuentas Qontrolmed.
6. Con aprobación explícita se ejecutó `sudo systemctl disable --now mysql`.
7. `unattended-upgrade` instaló actualizaciones de seguridad y el kernel 6.8.0-147; se realizó un reinicio controlado.
8. Tras reiniciar se validaron red, SSH, kernel, UFW, MySQL, puertos, montajes y salud del sistema.

## Próxima fase recomendada

Diseñar primero, sin arrancar MySQL:

1. cuentas por puesto con IP reservada y sin comodín `%`;
2. roles separados para operación, mantenimiento y provisión de accesos;
3. administración mediante MySQL Workbench sobre SSH, sin root remoto;
4. TLS obligatorio con CA y certificado cuyo nombre estable pueda verificarse;
5. cambios de Qontrolmed para verificar CA e identidad y añadir timeouts;
6. desactivación de MySQL X/33060;
7. UFW TCP/3306 limitado a IP concretas `/32`;
8. copia y restauración probadas antes de datos de producción.

No arrancar MySQL ni crear usuarios, esquemas o reglas 3306 hasta aprobar el plan exacto.

## Pendientes adicionales

- Normalizar `known_hosts` para registrar `192.168.1.31`; temporalmente se utilizó `HostKeyAlias=192.168.1.30` para comprobar la clave ya conocida.
- Revisar la política de `unattended-upgrades` y acordar ventanas/notificaciones de reinicio; no desactivarla sin un plan.
- Confirmar los puestos Qontrolmed, sus reservas DHCP y privilegios funcionales reales.
- Confirmar en la sede IP, gateway, DHCP, DNS, VLAN, conflicto y origen administrador para `192.168.0.0/24`.
- No trasladar `192.168.1.31` a la configuración de producción: pertenece a la red doméstica temporal.
- No ejecutar `do-release-upgrade`.

## Inicio recomendado de la siguiente sesión

Revalidar en solo lectura:

```bash
hostnamectl --static
uname -r
ip -br link show eno1
ip -br -4 addr show eno1
ip route
systemctl is-enabled ssh.socket
systemctl is-active ssh.socket
systemctl is-enabled ufw
systemctl is-active ufw
systemctl is-enabled mysql
systemctl is-active mysql
sudo ss -ltnp | grep -E ':(22|3306|33060)([[:space:]]|$)' || true
sudo ufw status numbered
systemctl --failed --no-legend --plain
test -e /var/run/reboot-required && cat /var/run/reboot-required || echo NO_REBOOT_REQUIRED
findmnt /var/lib/mysql
findmnt /srv/compartido
```

Esperado: `srv-mm-01`, kernel 147 o posterior aprobado, IP doméstica reservada mientras siga en esta ubicación, SSH y UFW activos, MySQL `disabled/inactive`, 3306/33060 cerrados, sin unidades fallidas.

## Prompt reutilizable

```text
Continuamos srv-mm-01 desde el cierre seguro del 2026-11-01. Lee AGENTS.md, README.md, CONTINUAR-SIGUIENTE-SESION.md, 00_seguimiento/estados/ESTADO-OPERATIVO-SRV-MM-01-2026-11-01.md y 04_guias_didacticas/GUIA-DIDACTICA-RESERVA-DHCP-MYSQL-Y-REINICIO-SEGURO-2026-11-01.md.

Empieza con una revalidación de solo lectura. En la red doméstica temporal, srv-mm-01 tiene una reserva DHCP 192.168.1.31 para la MAC 74:fe:48:67:be:cc. El kernel 6.8.0-147 quedó validado. SSH y UFW están activos. MySQL 8.4.11 debe seguir disabled/inactive y 3306/33060 cerrados.

La próxima fase es exclusivamente diseñar la configuración MySQL LAN: cuentas por IP reservada, roles, administración por Workbench sobre SSH, TLS verificado, cierre de 33060 y UFW por /32. No arranques MySQL, no crees usuarios/esquemas y no abras puertos hasta presentar propósito, riesgo, aceptación y reversión y obtener mi aprobación expresa. No asumas que 192.168.1.31 es la IP de producción ni modifiques Netplan.
```


## Preparación inicial del piloto doméstico

El propietario pidió comenzar el piloto. Se revisaron src/compartido/configuracion.py, src/compartido/db.py, requirements.txt y .env.example del repositorio D:\trabajo\Proyectos\maxgesth, sin leer configuración real ni modificar código. Sigue pendiente implementar verificación CA/identidad y timeouts de lectura/escritura. Se detectaron cambios documentales previos; se conservaron.

IP actual del puesto administrador/piloto: 192.168.1.107 en Ethernet. No consta reserva DHCP confirmada; no usar todavía para abrir UFW.

Se preparó 06_herramientas/scripts/auditoria-piloto-20261105.sh y se copió a /home/vicente/auditoria-piloto-20261105.sh. Es una auditoría de solo lectura de versión MySQL, servicios, reglas UFW, escuchas, opciones no secretas y metadatos de certificados. No inicia MySQL ni cambia configuración. Pendiente de ejecución local por el propietario mediante sudo; resultado previsto en /home/vicente/auditoria-piloto-20261105.txt para recogerlo después como evidencia.

No hay aprobación de un cambio técnico exacto ni se han modificado servicios, firewall, cuentas o esquemas. Tras la auditoría, concretar el primer bloque de configuración y presentar propósito, riesgo, aceptación y reversión.

## Auditoría privilegiada recogida y cambio 01 preparado

Recogido 05_evidencias/AUDITORIA-PILOTO-2026-11-05.txt: MySQL 8.4.11 inactive/disabled, UFW activo solo con las dos reglas SSH documentadas, sin escucha 3306/33060. Certificados presentes; identidad y validez aún no verificadas.

Preparado 02_planes_y_arquitectura/CAMBIO-01-PILOTO-MYSQL-LOCAL-2026-11-05.md: archivo nuevo limitado a loopback, mysqlx OFF y transporte seguro obligatorio; validar sin arrancar. Pendiente de aprobación expresa. No se aplicaron cambios de configuración. La prueba LAN y el arranque se aprobarán en bloques posteriores.

## Cambio 01 autorizado; pendiente de ejecución local

El propietario autorizó expresamente el cambio 01 («si autorizado»). Se preparó 06_herramientas/scripts/cambio01-piloto-20261105.sh y se copió a /home/vicente/cambio01-piloto-20261105.sh; sintaxis Bash y hash comprobados. El script verifica precondiciones, conserva hashes de configuración previa y logs solo en un directorio root restringido, añade atómicamente el archivo aprobado, valida opciones y mantiene MySQL detenido/deshabilitado. Ante fallo posterior a la instalación retira únicamente el archivo propio si su contenido no ha cambiado y revalida la configuración anterior. No arranca MySQL ni toca firewall, cuentas, esquemas o certificados.

sudo no está disponible sin contraseña en esta sesión: pendiente ejecución por el propietario desde PowerShell. Resultado público previsto en /home/vicente/cambio01-piloto-20261105.txt. No marcar el cambio como aplicado hasta recoger CAMBIO01_COMPLETADO y revalidar el estado.

## Cambio 01 completado y verificado

Recogida evidencia 05_evidencias/CAMBIO-01-PILOTO-2026-11-05.txt y creado estado 00_seguimiento/estados/ESTADO-CAMBIO-01-PILOTO-2026-11-05.md. Archivo nuevo correcto y validado; MySQL inactive/disabled y sin escucha 3306/33060. Sin cambios en firewall, certificados, cuentas o esquemas. Sustituye las notas anteriores de ejecución pendiente del cambio 01.

Preparado 02_planes_y_arquitectura/CAMBIO-02-PILOTO-ARRANQUE-LOCAL-2026-11-05.md: arranque manual breve, comprobaciones locales y parada al finalizar. Pendiente de autorización; no ejecutarlo hasta obtenerla. TLS y certificados aún no validados en ejecución.

## Cambio 02 autorizado; script preparado

El propietario autorizó el arranque local breve y la parada al finalizar. Script 06_herramientas/scripts/cambio02-piloto-20261105.sh preparado, copiado al servidor y comprobado (sintaxis y hash). Revalidación previa por SSH: MySQL inactive/disabled, hash del cambio 01 correcto. sudo sigue requiriendo autenticación local.

Pendiente ejecución por el propietario; resultado previsto /home/vicente/cambio02-piloto-20261105.txt. No se ha arrancado el servicio desde esta sesión. Se exige recoger CAMBIO02_COMPLETADO (o analizar resultado inconcluso/fallo) y verificar parada final. No se crean cuentas, esquemas ni reglas de firewall.

## Incidencia de pegado antes de cambio 02

El comando SSH apareció duplicado en una misma línea de PowerShell; tee informó opción inválida y se cerró la conexión. Revalidación por SSH a las 11:36 Europe/Madrid: MySQL inactive/disabled, sin proceso mysqld ni escucha 3306/33060 ni script en ejecución; archivo de resultado vacío. No existe evidencia de ejecución satisfactoria del cambio 02. Se propone repetir en dos pasos: abrir SSH y ejecutar dentro del servidor el script ya autorizado, sin cambiar su alcance.

## Cambio 02 ejecutado: resultado parcial y parada confirmada

Evidencia en 05_evidencias/CAMBIO-02-PILOTO-2026-11-05.txt; estado actualizado en 00_seguimiento/estados/ESTADO-CAMBIO-02-PILOTO-2026-11-05.md. Arranque local y parámetros correctos. Certificado automático sin SAN ni identidad de srv-mm-01/IP. Prueba TCP sin TLS inconclusa (ERROR 1698). MySQL detenido/deshabilitado al finalizar y revalidado por SSH, sin puertos ni procesos MySQL y sin unidades fallidas.

Preparado cambio 03 de certificado verificable de piloto, pendiente de autorización. No crear cuentas ni arrancar MySQL nuevamente con la autorización de los bloques anteriores. El estado nuevo sustituye las referencias históricas a ejecución pendiente del cambio 02.

## Autorización por plan y preparación del certificado

Por instrucción expresa del propietario se modificó AGENTS.md: la aprobación del plan cubre sus pasos, pruebas, documentación y reversión; solo se vuelve a pedir autorización ante ampliación material, riesgo nuevo relevante o decisión pendiente necesaria. La autenticación sudo local no es una nueva autorización. README actualizado con la misma convención. No se modificó la regla separada de confirmación de Google Calendar.

El propietario autorizó el plan de certificado del cambio 03. Script guardado en 06_herramientas/scripts/cambio03-piloto-20261105.sh y copiado a /home/vicente/cambio03-piloto-20261105.sh; sintaxis y hash comprobados. Prepara CA exclusiva y certificado con SAN DNS:srv-mm-01, IP:127.0.0.1 e IP:192.168.1.31, conserva configuración previa y valida sin arrancar MySQL. No exporta claves privadas. Pendiente de ejecución con contraseña sudo introducida localmente; resultado previsto /home/vicente/cambio03-piloto-20261105.txt. No se ha aplicado todavía ni se ha arrancado MySQL.

Las notas anteriores que pidan aprobar cada paso de un mismo plan quedan sustituidas por la nueva regla de AGENTS.md. No interpretar como autorización de acciones expresamente excluidas del plan aprobado.

## Cambio 03 completado y revalidado

Recogida evidencia 05_evidencias/CAMBIO-03-PILOTO-2026-11-05.txt y creado estado 00_seguimiento/estados/ESTADO-CAMBIO-03-PILOTO-2026-11-05.md. CA y certificado exclusivos del piloto generados; cadena, propósito, identidad y rechazo de nombre erróneo comprobados. Configuración validada; MySQL sigue inactive/disabled, sin proceso ni escucha y sin unidades fallidas.

Pendientes: sesión TLS autenticada con nueva cuenta de prueba, rechazo sin TLS, adaptación de Qontrolmed, LAN restringida y copia/restauración ficticia. El bloque 03 no autorizaba arranque ni creación de cuentas. Para evitar aprobaciones por cada paso, agrupar el alcance restante en un plan completo; una vez autorizado, ejecutar sus fases sin pedir permiso individual, conforme a AGENTS.md.

Preparado 02_planes_y_arquitectura/PLAN-CONJUNTO-CIERRE-PILOTO-DOMESTICO-2026-11-05.md para agrupar conexión TLS, cuentas/esquemas ficticios, adaptación aislada de Qontrolmed, LAN /32, restauración y cierre seguro. Pendiente de aprobación conjunta; una aprobación cubrirá todas sus fases conforme a AGENTS.md.


## Plan conjunto autorizado: preparación local y Qontrolmed

El propietario aprobó todo el plan restante y autorizó este PC Windows como puesto piloto. No pedir aprobación por cada fase. Preparación y pruebas documentadas en 00_seguimiento/estados/PREPARACION-PLAN-CONJUNTO-PILOTO-2026-11-05.md. Qontrolmed tiene worktree aislado y entorno Python dedicado; 20 pruebas acotadas correctas. No se ha probado todavía la aplicación contra el servidor.

Pendiente ejecución con sudo de /home/vicente/piloto-local-20261105.py para completar pruebas locales, crear solo datos ficticios y probar restauración. Salida prevista /home/vicente/piloto-local-20261105.txt. Recoger resultado y revalidar parada antes de LAN. Otro equipo no necesario aún; serviría para prueba activa de origen no autorizado.

## Fase local: sesión TLS correcta, continuación necesaria

Evidencia conservada en 05_evidencias/PILOTO-LOCAL-INTENTO-01-2026-11-05.txt. Conexión TLS con identidad y DML ficticio correctos. Prueba sin TLS inconclusa porque el comprobador solo aceptaba 3159 y no registró el código real. Restauración y resto de negativas no ejecutadas. Cuenta propia bloqueada y MySQL detenido/deshabilitado, revalidado por SSH.

Estado detallado: 00_seguimiento/estados/ESTADO-PILOTO-LOCAL-INTENTO-01-2026-11-05.md. Script corregido con modo --resume, preservando los datos existentes. Pendiente ejecución sudo de piloto-local-20261105.py --resume; salida piloto-local-reanudacion-20261105.txt. Dentro del plan ya autorizado, sin nueva aprobación por paso. No repetir el script sin --resume ni borrar objetos para recomenzar.

## Fase local completada; ventana LAN preparada

Evidencia PILOTO_LOCAL_COMPLETADO archivada. TLS/identidad, rechazo sin TLS por cuenta REQUIRE SSL (1045), CA incorrecta (2026), permisos y las tres restauraciones ficticias correctos. Cuenta local bloqueada y MySQL detenido, revalidado por SSH.

Detalle en 00_seguimiento/estados/ESTADO-PILOTO-LOCAL-COMPLETADO-2026-11-05.md. Script LAN listo con regla /32 para este PC (192.168.1.107 comprobada), ventana de 15 minutos y limpieza al finalizar. Pendiente ejecución sudo y pruebas Windows antes del límite; pedir al propietario avisar en cuanto aparezca PILOTO_LAN_LISTO_15_MINUTOS sin cerrar la sesión. Cliente probar-piloto-windows.py preparado. Configuración secreta debe descargarse solo fuera de repositorios con permisos restrictivos, sin mostrar contenidos.

No pedir nueva aprobación: fases ya incluidas en plan conjunto. Pendientes GUI/esquema completo, interrupción de red en escritura y prueba desde otro origen. Qontrolmed aislado: cuatro pruebas de recuperación adicionales superadas.

## Prueba LAN de conexiones superada y cerrada

Pruebas reales desde este PC: DML y TLS/identidad en tres conexiones, rechazo sin TLS e identidad errónea, recuperación de sesión, timeout de lectura y cancelación de escritura propia sin repetición ni fila duplicada. Evidencia en 05_evidencias/PRUEBAS-QONTROLMED-WINDOWS-2026-11-05.md; cierre LAN en PILOTO-LAN-CIERRE-2026-11-05.txt. MySQL parado/deshabilitado y configuración local restaurada, comprobados por SSH.

Preparación funcional: solo metadatos obtenidos de MySQL80 local, sin registros. Script preparar-esquema-funcional.py listo en servidor para crear 33 tablas en los esquemas ficticios y aplicar bootstrap estático; pendiente ejecución sudo, salida prevista /home/vicente/preparacion-funcional-20261105.txt. No volver a ejecutar la ventana LAN original: sus destinos ya existen y aborta; una nueva ventana necesitará continuación controlada de la cuenta y configuración existentes dentro del plan autorizado.

Detalle vigente: 00_seguimiento/estados/ESTADO-PILOTO-LAN-Y-PREPARACION-FUNCIONAL-2026-11-05.md. Pendientes interfaz/flujo funcional completo y segundo origen de red; no declarar piloto finalizado.
