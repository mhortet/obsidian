---
title: "Diario srv-mm-01 2026-11-05"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../estados/ESTADO-REVALIDACION-SRV-MM-01-2026-11-05.md"
  - "../../02_planes_y_arquitectura/PROPUESTA-MYSQL-SRV-MM-01-2026-11-05.md"
tags: [documentacion, auditoria, mysql]
review_after:
---

# Diario de sesión — 2026-11-05

Se revisaron AGENTS.md, README, relevo, estado del 1 de noviembre y planes de Qontrolmed. Se recuperó el acceso por clave después de que el propietario cargara la identidad desde PowerShell. Se revalidaron identidad, salud, servicios, red, escuchas y montajes sin modificar el servidor.

Se redactó una propuesta MySQL con permisos por equipo, TLS, piloto, criterios de aceptación y reversión. El propietario aceptó un piloto doméstico con un puesto y datos ficticios; la ejecución técnica sigue pendiente de propuesta exacta y aprobación.

El propietario pidió que toda documentación generada se guarde en su carpeta correspondiente dentro de la estructura existente. Se incorporan propuesta en 02_planes_y_arquitectura, estado en 00_seguimiento/estados y diario en 00_seguimiento/diario; se actualizan README y relevo. No se crea una estructura alternativa.

Pendientes: IP del primer puesto, nombre/certificados, destino y política de copias, revisión actual de Qontrolmed, auditoría privilegiada y aprobación de cambios concretos. No se arrancó MySQL ni se cambiaron UFW, red, cuentas o esquemas.

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

## Estructura funcional creada; interfaz preparada

Preparación funcional completada: 33 tablas y bootstrap sintético; MySQL detenido y sin fallos. Evidencia archivada y estado en 00_seguimiento/estados/ESTADO-ESTRUCTURA-FUNCIONAL-Y-GUI-2026-11-05.md.

Entorno aislado con todas las dependencias, importación de interfaz correcta y suite completa de 36 pruebas superadas. Harness GUI preparado con autenticación por servicio y sesión ficticia, sin automatizar diálogo de credenciales ni modificar login de producción. Ventana LAN --resume lista; mantiene el plan ya autorizado y sus límites. Pendiente sudo local para abrirla y pruebas de pantallas; no pedir nueva aprobación.

## Prueba funcional parcial y corrección de marcas preparada

Aplicación arrancada y autenticación por servicio probada. Control visual falló dos veces por timeout de captura; no se realizó revisión de pantallas. Pruebas de negocio independientes: Quirófanos y punto de Preventivos correctos; Gestión detectó idMarcas sin AUTO_INCREMENT frente a alta que omite ID (1364). Base original intacta.

Ventana LAN cerrada; proceso propio del harness terminado tras verificar identidad, cuenta bloqueada, regla retirada, escucha local restaurada y MySQL parado. Estado detallado: 00_seguimiento/estados/ESTADO-SERVICIOS-Y-AJUSTE-MARCAS-2026-11-05.md.

Pendiente sudo de corregir-marcas-y-abrir-piloto.py pasando SSH_CONNECTION: corrige solo tabla ficticia vacía, verifica y abre ventana LAN --resume. Avisar al ver PILOTO_LAN_LISTO_15_MINUTOS. Entonces ejecutar probar-servicios-funcionales.py con venv y directorio runtime privado; cerrar ventana al terminar. No reintentar automatización visual fallida sin recuperación adecuada; no afirmar GUI validada. No requiere nueva autorización: incluido en plan conjunto.

## Aclaración del propietario y corrección del alta manual

El propietario confirma origen importado de los ID de marcas y asignación manual intencional; también confirma que la portada sí se abrió al inicio. Decisión vigente en 01_gobierno_y_decisiones/DECISION-IDS-MARCAS-MANUALES-2026-11-05.md. Sustituye la propuesta de autoincremento, retirada por inapropiada para este contexto.

ALTER rechazado por MySQL con 1833 (relación foránea); servicio detenido y sin apertura LAN, revalidado. Script anterior archivado y sustituido por stub de aviso sin acciones, también en el servidor. No intentar sortear las claves foráneas.

Corregidos solo el servicio y formulario de la copia aislada: ID explícito validado e insertado; no cambia esquema ni datos históricos. Tres pruebas nuevas; suite completa 39 correctas. Pendiente reabrir únicamente piloto-lan-20261105.py --resume y repetir probar-servicios-funcionales.py, ahora con ID manual sintético 1207. No requiere autorización adicional dentro del plan.

## Alta con ID manual y servicios verificados; cierre seguro

La integración corregida pasó: autenticación/roles, alta/consulta/modificación de marca con ID manual 1207, comprobación del instrumento ficticio previo e idempotencia del punto de Preventivos. Resultado SERVICIOS_FUNCIONALES_PILOTO_COMPLETADOS conservado. Cierre LAN recogido y estado revalidado: mysql inactive/disabled, sin proceso/puertos, sin fallos y configuración segura restaurada.

Informe vigente: 00_seguimiento/estados/CIERRE-TECNICO-PILOTO-DOMESTICO-2026-11-05.md. No declarar terminado todo el piloto: quedan revisión visual, segundo origen de red, restauración del esquema funcional y aceptación del código, entre otros límites documentados. La portada fue vista por el propietario. Ya no hay que ejecutar comandos de los relevos anteriores para corregir marcas ni abrir ventanas salvo nueva sesión de prueba prevista.

## Pausa y cierre solicitado por el propietario

Se guardó 05_evidencias/COMPROBACION-FINAL-PAUSA-2026-11-05.txt y se verificó MySQL inactive/disabled sin proceso/puertos/fallos. No había pruebas del piloto activas. Se cerró la sesión interactiva SSH identificada desde el servidor tras denegación local de Windows al intentar terminar el proceso; no se alteraron permisos. Se retiró solo la identidad SSH del servidor mediante su clave pública. Comprobación final Windows: cero conexiones SSH al servidor y cero procesos GUI del piloto.

Creado 00_seguimiento/estados/CIERRE-Y-PAUSA-PILOTO-2026-11-05.md y procedimiento 03_operacion_y_runbooks/REANUDAR-PILOTO-DOMESTICO-2026-11-05.md, con acceso, estado esperado, primera tarea propuesta, límites, cierre y prompt reutilizable. Relevo marcado en pausa e índice actualizado. El servidor no se apagó ni reinició; SSH permanece disponible para próxima sesión. No se creó calendario ni automatización. Detener el trabajo hasta nueva indicación del propietario.

## Reanudación y restauración del esquema funcional completo

El propietario reanudó el trabajo desde `CONTINUAR-SIGUIENTE-SESION.md`. Se comprobó la IP del puesto `192.168.1.107`, se cargó localmente la clave protegida sin exponer su frase y se revalidó por SSH estricto `srv-mm-01`: MySQL `inactive/disabled`, sin 3306/33060 ni unidades fallidas. La aparente discrepancia inicial de hash se debió a consultar `mysqld.cnf`; el archivo correcto `90-qontrolmed-piloto.cnf` conservaba el SHA256 esperado.

Se preparó un script nuevo sin borrados, cambios de cuentas ni firewall. R2 abortó antes de crear destinos por el escape del separador usado al leer charset/collation y cerró MySQL correctamente. R3 preservó R2, utilizó rutas y destinos inéditos y completó la copia/restauración de las 33 tablas funcionales: Gestión 13, Quirófanos 7 y Preventivos 13. Se compararon tablas, filas, columnas, índices y relaciones; resultados en `piloto_mm_restore_func3_*`.

Revalidación independiente final: MySQL `inactive/disabled`, sin proceso ni puertos, cero unidades fallidas y hash de configuración correcto. Evidencia en `05_evidencias/RESTAURACION-FUNCIONAL-COMPLETA-2026-11-05.txt` y estado en `00_seguimiento/estados/ESTADO-RESTAURACION-FUNCIONAL-COMPLETA-2026-11-05.md`. La prueba no cubre copias externas, 3-2-1, producción ni datos reales.

## Revisión del código y del empaquetado aislados

Revisados los cinco archivos modificados y los tres tests nuevos del worktree `pilot/mysql-tls-20261105`, sin cambiarlo. `git diff --check` correcto y suite completa 39/39 con mysql-connector-python 9.7.0. El ZIP documental conserva ocho archivos coincidentes por SHA256 más README, sin secretos.

Hallazgo bloqueante antes de instalar: la aplicación resuelve `DB_SSL_CA=ca-piloto.pem` junto al `.env`, pero el instalador RC no provisiona la CA en esa ruta y el verificador no exige TLS, variable/ruta CA ni sus ACL. La ausencia falla de forma segura, pero el paquete no reproduce el entorno probado. No construir, instalar ni sustituir la aplicación habitual hasta alinear plantilla, instalador, configurador, verificador y tests con una CA pública específica de la sede. Detalle en `00_seguimiento/estados/REVISION-CODIGO-Y-EMPAQUETADO-QONTROLMED-2026-11-05.md`.

## Cierre de la reanudación

Retirada exclusivamente la identidad `id_ed25519_srv_mm` del agente local; `ssh-add -l` confirmó que no quedan identidades. Cero conexiones SSH establecidas hacia el servidor. El servicio `ssh-agent` quedó `Running` con inicio `Manual`: Windows denegó detenerlo sin elevación administrativa, pero permanece vacío y no se cambió su tipo de inicio. No se forzó UAC por no ser necesario para la seguridad del cierre.

## Prioridad de preparación antes del traslado

El propietario expresa interés en trasladar el servidor a la red del cliente tan pronto como sea viable, con repositorio de archivos por Cloudflare y administración remota completa desde su ordenador. Aclara que prefiere dejar todo preparado y probado antes para evitar otra visita.

Se registra la decisión en `01_gobierno_y_decisiones/DECISION-PREPARAR-TODO-ANTES-TRASLADO-2026-11-05.md` y se crea la propuesta `02_planes_y_arquitectura/PLAN-PREPARACION-PREVIA-Y-PUESTA-EN-SEDE-2026-11-05.md`. Arquitectura recomendada: SFTPGo WebClient tras Cloudflare Access y túnel documental; ruta privada separada hacia SSH desde Cloudflare One Client; cuenta nominal con `sudo` interactivo, sin root remoto ni `NOPASSWD: ALL`; MySQL detenido durante la primera entrega.

La preparación previa incluye simulación de `192.168.0.0/24`, prueba de red solapada, copia externa/restauración, monitorización, reinicio en frío y rollback. LUKS2 es el principal límite para prometer recuperación sin visita: el túnel no existe antes de arrancar Ubuntu. Debe decidirse persona local, consola remota/KVM o mecanismo de desbloqueo expresamente auditado. El plan permanece `proposed`; no se instalaron servicios ni se crearon recursos externos.

## Preparación de la sesión del 2026-11-06 sin datos del cliente

El propietario prevé que la información solicitada al cliente probablemente no estará disponible al inicio y que puede ser necesaria una llamada. El correo quedó preparado y programado en Gmail para el 2026-11-06 a las 08:00; no se incluyeron credenciales ni secretos.

Se adopta una estrategia desacoplada: comenzar por revalidación de solo lectura, diseño detallado, parámetros provisionales explícitos, scripts reversibles y pruebas locales con datos ficticios. Dominio/DNS, cuenta Cloudflare, usuarios reales, red de sede, destino externo de copias y recuperación tras pérdida de alimentación quedan como puntos de integración posteriores. La ausencia de respuesta no autoriza a inventar valores ni a publicar servicios.

Creado `03_operacion_y_runbooks/INICIAR-PREPARACION-SIN-DATOS-CLIENTE-2026-11-06.md` y actualizados decisión, plan, README y relevo. El nuevo bloque técnico SFTPGo/Cloudflare no está todavía aprobado: mañana debe concretarse con propósito, riesgos, aceptación y reversión y obtener una única aprobación antes de modificar el servidor. MySQL permanecerá detenido.

## Consolidación de documentación para el cliente

Por petición del propietario se crea `DOCUMENTACION-SERVIDOR-UBUNTU.md`, versión 1.0, como documento maestro único de entrega y mantenimiento. Incluye objetivo, hardware, instalación, red, servicios, comandos acreditados, decisiones, pruebas, recuperación y pendientes. Distingue hechos confirmados, información comunicada, propuestas y verificaciones pendientes. Incorpora la restauración R3 de 33 tablas y el bloqueo de empaquetado de CA, posteriores a notas históricas ya superadas.

Se conservan las fuentes originales, se enlaza el maestro desde README y relevo y se establece actualizar siempre ese archivo con versiones e historial. No se incluyen secretos. Trabajo exclusivamente documental, sin conexión ni cambios al servidor; aceptación de producción pendiente.
