---
title: "Preparación sin datos del cliente — 2026-11-06"
type: register
status: active
created: 2026-11-06
updated: 2026-11-06
sources:
  - "../../03_operacion_y_runbooks/INICIAR-PREPARACION-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "../../05_evidencias/PREFLIGHT-SIN-CAMBIOS-2026-11-06.txt"
  - "../../02_planes_y_arquitectura/PLAN-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
tags: [documentacion, seguridad, administracion, testing]
review_after: 2026-11-13
---

# Preparación sin datos del cliente — 2026-11-06

## Alcance de apertura

El propietario reanuda la preparación de `srv-mm-01` por la rama que no depende de información del cliente. Se mantienen excluidos datos reales, DNS, recursos Cloudflare, red definitiva, LUKS, discos, UFW/SSH y producción. MySQL debe permanecer detenido.

## Revalidación local y remota

El puesto conserva `192.168.1.107/24`. Los dos adaptadores Fortinet aparecen desconectados y la tabla de rutas no mostró una ruta VPN activa. TCP/22 de `192.168.1.31` respondió.

`ssh-agent` estaba detenido con inicio manual. Se inició sin cambiar su tipo de inicio y el propietario cargó localmente la identidad protegida, sin compartir su frase. La primera prueba directa sin agente falló de forma segura; la identidad y la clave de host se utilizaron después con comprobación estricta.

Auditoría remota de solo lectura:

- `srv-mm-01`, kernel `6.8.0-147-generic`, sin reinicio pendiente ni unidades fallidas;
- MySQL `inactive/disabled`, sin `mysqld` ni 3306/33060;
- SSH activo en 22; `ssh.socket` activo/habilitado explica que `ssh.service` figure `disabled`;
- UFW activo/habilitado; detalle de reglas pendiente de lectura privilegiada dentro del bloque aprobado;
- ninguna escucha inesperada;
- `/srv/compartido` montado `rw,nosuid,nodev,noexec`, 218 GiB disponibles;
- hash de `90-qontrolmed-piloto.cnf` coincidente;
- SFTPGo, `cloudflared` y `restic` no instalados; `/srv/compartido/repositorio` ausente;
- sin errores del día visibles para la cuenta administrativa.

Evidencia depurada: `05_evidencias/PREFLIGHT-SIN-CAMBIOS-2026-11-06.txt`.

## Verificación de fuentes actuales

Se contrastaron las fuentes oficiales vigentes de SFTPGo Community y Cloudflare. La documentación anterior mezclaba referencias Community y Enterprise; el bloque nuevo fija explícitamente Community y no presupone funciones comerciales. La versión Community `2.7.6` incorpora correcciones de seguridad relevantes y se establece como mínimo del ensayo.

Cloudflare requiere regla final de ingress, permite validación local y mantiene una ventana de soporte de un año para `cloudflared`. No se crearán túneles ni se usará Quick Tunnel. El ensayo limita archivos ficticios a 50 MiB; la necesidad de cargas mayores y de TUS queda como decisión posterior porque no se ha confirmado esa capacidad en la edición Community actual.

## Plan preparado

Creado `02_planes_y_arquitectura/PLAN-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md` con:

- procedencia y simulación de paquetes;
- prevención de arranque con bindings por defecto;
- SFTPGo solo en `127.0.0.1:18080/18081`, protocolos restantes deshabilitados;
- cuenta y datos ficticios, TOTP, cuota y permisos mínimos;
- `cloudflared` instalado pero sin recursos, token o servicio activo;
- copia/restauración local ficticia con `restic`, sin declararla 3-2-1;
- aceptación, riesgos, reversión y exclusiones expresas;
- scripts y configuraciones previstos después de la aprobación.

El propietario aprobó expresamente el plan completo el 2026-11-06 y avisó de que estará en remoto, por lo que las intervenciones locales pueden demorarse. La aprobación cubre los artefactos, la ejecución técnica, las pruebas, la documentación y la reversión descritas. No amplía las exclusiones. En el momento de la aprobación todavía no se habían instalado paquetes ni creado la ruta documental.

## Artefactos preparados y transferidos

Se crearon cuatro scripts y tres plantillas sin secretos para preflight, instalación/configuración, aceptación/restauración y reversión. Se corrigió antes de ejecutar una tubería DNS incompatible con `pipefail` y se añadió parada automática de SFTPGo si la fase de configuración aborta.

Los siete archivos se copiaron a `/home/vicente/bloque-domestico-20261106`, con modo privado de directorio. Los SHA-256 local/remoto coincidieron y los cuatro scripts superaron `bash -n` en Ubuntu. Manifiesto: `05_evidencias/MANIFIESTO-BLOQUE-DOMESTICO-2026-11-06.txt`.

El preflight privilegiado requiere que el propietario introduzca localmente su contraseña `sudo`; `sudo -n` confirmó que no existe una sesión privilegiada reutilizable. No se pidió ni transmitió la contraseña.

## Preflight privilegiado superado

El propietario ejecutó el preflight mediante una terminal SSH con TTY. Resultado `PREFLIGHT_RESULT=OK` a las 11:06 CET:

- MySQL `inactive/disabled`, sin proceso ni escuchas;
- cero unidades fallidas y hash de configuración correcto;
- `ssh.socket` y UFW activos/habilitados;
- UFW contiene únicamente TCP/22 desde `192.168.1.0/24` y `192.168.0.0/24`;
- ninguna escucha inesperada;
- montaje compartido y espacio correctos;
- SFTPGo, `cloudflared` y `restic` ausentes;
- DNS y descarga HTTPS de ambos keyrings correctos.

Evidencia archivada en `05_evidencias/PREFLIGHT-BLOQUE-DOMESTICO-2026-11-06.txt`. Se revisó de nuevo el script de aplicación antes de instalar; hash actualizado en el manifiesto y sintaxis remota correcta.

Al pausar para solicitar la aprobación se retiró exclusivamente `id_ed25519_srv_mm` del agente. `ssh-add -l` confirmó que no quedan identidades y no había conexiones establecidas al servidor. `ssh-agent` permanece `Running` con inicio `Manual`.

## Estado para continuar

Presentar el plan al propietario para una única aprobación explícita. Si se aprueba, volver a cargar localmente la identidad protegida, preparar y revisar los artefactos enumerados antes de transferirlos o ejecutar `sudo`. Si cambia el alcance o aparece un riesgo nuevo, detener y solicitar decisión. Al cerrar la futura ejecución, dejar SFTPGo/`cloudflared` detenidos y deshabilitados, MySQL en su estado actual y retirar la identidad del agente.

## Ejecución y corrección ACL

El preflight y las fases `packages` y `configure` terminaron correctamente. Se instalaron SFTPGo `2.7.6-1`, `cloudflared 2026.10.7` y `restic 0.16.4-2ubuntu0.24.04.3`; SFTPGo quedó temporalmente activo pero deshabilitado al arranque y limitado a `127.0.0.1:18080/18081`. `cloudflared` permaneció inactivo/enmascarado y MySQL `inactive/disabled`.

El propietario creó localmente `admin-piloto` con TOTP y `documental-piloto` con cuota de 250 MiB, carga máxima de 50 MiB, TOTP obligatorio para HTTP, protocolos restantes denegados y permisos `list`, `download`, `upload`, `overwrite` y `create_dirs`. Las contraseñas, secretos TOTP y códigos de recuperación no se compartieron ni documentaron.

La primera sesión documental autenticó correctamente, pero el listado del hogar devolvió HTTP 403. La causa confirmada fue la falta de permiso de tránsito de la cuenta de servicio sobre `/srv/compartido`, que conservaba `root:root 0750`. La simulación de `acl` propuso solo ese paquete, sin actualizaciones o retiradas. Por tratarse de un cuarto paquete fuera de la lista inicial, se detuvieron las pruebas y el propietario aprobó expresamente el bloque correctivo: instalar `acl`, aplicar solo `u:sftpgo:--x`, comprobar tránsito sin capacidad de listado y añadir la reversión `setfacl -x u:sftpgo /srv/compartido`.

La corrección terminó con `ACL_FIX_RESULT=OK`. El WebClient recuperó el listado, se creó `ensayo-ficticio` y el propietario cargó manualmente `PRUEBA-WEBCLIENT-FICTICIA-2026-11-06.txt` (147 bytes) porque el navegador integrado no permitía automatizar el selector Dropzone. La interfaz confirmó el archivo. Quedaron pendientes descarga, sobrescritura, negativas, revocación y aceptación/restauración `restic`.

El propietario pidió pausar por límite temporal de uso. Se cerró el túnel SSH local. La parada no interactiva falló de forma segura por falta de ticket `sudo`; el propietario ejecutó la parada interactiva y se verificó SFTPGo `inactive/disabled`, `cloudflared inactive/masked`, MySQL `inactive/disabled`, ausencia de `18080/18081/3306/33060` y cero unidades fallidas. Después se retiró `id_ed25519_srv_mm`; el agente quedó vacío. Estado detallado: `00_seguimiento/estados/ESTADO-PAUSA-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md`.

## Reanudación, aceptación y cierre final

La sesión revalidó antes de arrancar que SFTPGo, Cloudflare y MySQL seguían detenidos, sin unidades fallidas; la ACL y el hash MySQL coincidían. Se refrescó la evidencia de aplicación desde el servidor para incorporar la fase `configure` y se inició SFTPGo temporalmente solo en loopback.

El WebClient superó descarga y SHA-256 de la versión 1, sobrescritura y SHA-256 de la versión 2, creación previa de carpeta, carga y TOTP. La cuenta documental no expuso renombrado, copia, borrado, enlaces o comparticiones; los protocolos alternativos siguieron sin escucha. Un archivo de 50 MiB + 1 byte fue rechazado. Cinco archivos de 49 MiB se aceptaron y un archivo adicional de 10 MiB fue rechazado por cuota. Credencial incorrecta y TOTP ausente produjeron rechazo.

Se cambió temporalmente `documental-piloto` a `Inactive` con desconexión: la sesión existente recibió `Forbidden` y un nuevo acceso devolvió credenciales inválidas. La cuenta se restauró a `Active` y el acceso con contraseña+TOTP volvió a funcionar.

El primer intento de aceptación terminó seguro tras `ACCEPTANCE_START` por un retorno falso de `assert_mysql_safe` bajo `set -e`. Se corrigió el script con bloques `if` y `return 0`, se preservó el original remoto, se validó `bash -n` y se actualizó el manifiesto. La segunda ejecución produjo `ACCEPTANCE_RESULT=OK`: copia local cifrada de 245,364 MiB, `restic check` sin errores, restauración aislada con hashes coincidentes y `SQLITE_INTEGRITY=ok`, sin `prune`.

El cierre final confirmó SFTPGo `inactive/disabled`, `cloudflared inactive/masked`, MySQL `inactive/disabled`, cero unidades fallidas, ausencia de puertos del bloque, ACL/montaje/hash MySQL intactos y UFW/SSH sin cambios. Se cerró el túnel, se retiró la identidad del agente, se eliminaron únicamente temporales locales creados por la prueba y se conservaron las evidencias y artefactos remotos ficticios. Estado final: `00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md`.

## Plan posterior a la aceptación preparado

A petición del propietario se identificó el trabajo que puede continuar sin las evidencias ni decisiones del cliente. Se redactaron `02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md` y `03_operacion_y_runbooks/INICIAR-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md`.

El bloque propuesto limita la próxima sesión a auditoría remota de solo lectura, revisión de artefactos existentes y preparación local de comprobaciones, plantillas y runbooks parametrizados. Excluye arranque de servicios, paquetes, cambios de configuración, recursos Cloudflare/DNS, datos o usuarios reales, copia externa, red, UFW, SSH, LUKS, discos, BIOS, MySQL y Qontrolmed. Cualquier mejora remota descubierta deberá convertirse en otro plan técnico y detenerse antes de aplicarla.

Esta preparación fue exclusivamente documental: no se abrió una nueva conexión al servidor, no se modificó su estado y el plan permanece `proposed` hasta aprobación explícita.

