# Auditoría de continuación de `srv-mm-01` — 2026-10-02

Fecha de captura: 2026-10-02, aproximadamente 12:06 Europe/Madrid.

## Alcance

La jornada comenzó con comprobaciones remotas de solo lectura desde el ordenador administrador. Después de presentar propósito, riesgo, aceptación y reversión, el propietario aprobó y aplicó el primer bloque de endurecimiento. No se modificaron PAM, los paquetes, el almacenamiento ni la red.

## Acceso administrativo

- El servidor respondió en `192.168.2.104:22` desde la red de preparación.
- Se validó acceso no interactivo como usuario nominativo `vicente` mediante la clave ED25519 específica ya instalada.
- En el ordenador administrador, `ssh-agent` quedó en ejecución con inicio manual y una sola identidad cargada:
  - huella: `SHA256:pShSmmnPLAJjNmbJ91Ib/Zf/gaW8rLAGXZXLPLPckRs`;
  - comentario: `vicente@srv-mm-01 admin`.
- No se registraron ni copiaron la clave privada ni su frase.

## Estado observado

- Hostname: `srv-mm-01`.
- Sistema en funcionamiento, sin reinicio pendiente.
- Red temporal: `eno1`, `192.168.2.104/24` por DHCP.
- Solo SSH escucha externamente en TCP/22, para IPv4 e IPv6.
- SSH funciona mediante activación por `ssh.socket`; `ssh.socket` está habilitado y activo.
- UFW quedó habilitado con entrada denegada por defecto, salida permitida y TCP/22 permitido desde la red temporal `192.168.2.0/24`.
- Zona horaria: `Europe/Madrid`; NTP activo, reloj sincronizado y RTC en UTC.
- Secure Boot: deshabilitado.
- Actualizaciones automáticas: servicio y temporizadores activos; actualización diaria de índices y `unattended-upgrades` habilitados.
- Tras actualizar los índices, la simulación propone 15 paquetes actualizables. No se instaló ningún paquete en esta fase.
- Errores del arranque actual: únicamente `SGX disabled by BIOS`; no reapareció el error de `pam_lastlog.so` en la captura de este arranque.

## Hallazgo PAM

- `/etc/pam.d/login` pertenece al paquete `login` versión `1:4.13+dfsg1-4ubuntu3.2`.
- La línea 82 conserva `session optional pam_lastlog.so`.
- El módulo `pam_lastlog.so` no existe en el sistema ni lo aporta el paquete `libpam-modules` instalado (`1.5.3-5ubuntu5.7`).
- `dpkg -V` no detectó modificaciones en `login`, `libpam-modules` ni `libpam-runtime`; la referencia no parece una edición local.
- No modificar PAM por ahora. Revisar de nuevo tras actualizar paquetes y antes de convertir una observación puntual en una corrección manual.

## Pendientes priorizados

1. Actualizar Ubuntu 24.04 sin ejecutar una actualización de versión.
2. Revisar de nuevo PAM y el estado de reinicio después de las actualizaciones.
3. Instalar las herramientas de estado SMART solo tras aprobación.
4. Diseñar los volúmenes LVM antes de crearlos.
5. Tratar Secure Boot como cambio separado de firmware, con presencia física y plan de recuperación.

## Cambios aprobados y aplicados

- Zona horaria cambiada de `Etc/UTC` a `Europe/Madrid`.
- UFW activado sin reiniciar el servidor.
- Configuración SSH completada con `MaxAuthTries 3` y `X11Forwarding no`.
- Copia de seguridad y reversión conservadas en `/root/srv-mm-change-20261002-01`; la reversión se ejecuta desde consola con `sudo /root/srv-mm-change-20261002-01/rollback.sh`.

## Pruebas de aceptación

- La sesión SSH abierta antes de activar UFW permaneció operativa.
- Se abrió una segunda conexión SSH correcta como `vicente` mediante clave pública.
- Un intento limitado a autenticación por contraseña fue rechazado con `Permission denied (publickey)`.
- `timedatectl` mostró `Europe/Madrid (CEST, +0200)`, reloj sincronizado, NTP activo y RTC en UTC.
- `/etc/ufw/ufw.conf` mostró `ENABLED=yes`; `ufw.service` quedó habilitado y activo.
- El archivo aplicado contiene `MaxAuthTries 3` y `X11Forwarding no` además de la prohibición de contraseña y acceso directo de `root`.
- Solo TCP/22 continúa escuchando externamente.

El SSD Samsung de 1 TB y el espacio LVM libre no se tocaron.

## Simulación de actualizaciones

- Se ejecutó `apt-get update` seguido de `apt-get --simulate upgrade`.
- Resultado: 15 actualizados, 0 nuevos, 0 eliminados y 0 retenidos.
- No se incluyeron kernel, `systemd`, OpenSSH ni actualización de versión.
- Captura preservada en `apt-simulacion-srv-mm-01-2026-10-02.txt` con SHA-256 `43CA242092D84E728FCFFC7C10AAE3014D8EE0E7B53A2EF521BA8EB20FE9D2C8`.

## Aplicación de actualizaciones

- El primer intento se detuvo antes de instalar por un falso positivo del comparador: la configuración regional ordenó `libaudit1` y `libaudit-common` de forma distinta. Se corrigió el script para usar ordenación `LC_ALL=C` en ambos lados y se volvió a comprobar la igualdad exacta.
- Se instalaron los 15 paquetes aprobados: 0 nuevos, 0 eliminados y 0 retenidos.
- No quedan actualizaciones pendientes según los índices capturados, no hay reinicio pendiente y no existen unidades systemd fallidas.
- AppArmor, red, resolución, sincronización horaria y SSH se reiniciaron o recargaron durante el proceso sin pérdida de acceso.
- La sesión SSH previa permaneció viva, una conexión nueva mediante clave tuvo éxito y la autenticación por contraseña siguió rechazada.
- Registro preservado en `apt-upgrade-srv-mm-01-2026-10-02.txt` con SHA-256 `BE4F481A8D715D6DC6E2DA930198E42F6CE3DC782C2CD47E0B66CC2F439CBF14`.

### Observaciones posteriores

- AppArmor emitió `Illegal number: yes`, pero quedó habilitado y activo; la restricción `kernel.apparmor_restrict_unprivileged_userns` conserva el valor `1`. El comportamiento coincide con el fallo confirmado [Launchpad #2105840](https://bugs.launchpad.net/ubuntu/+source/apparmor/+bug/2105840). No se modificaron scripts empaquetados.
- El aviso de `pam_lastlog.so` reapareció al iniciar una sesión local. El módulo sigue ausente y `/etc/pam.d/login` no presenta modificaciones respecto del paquete. PAM no se modificó.

## Captura SMART

- Se instaló únicamente `smartmontools 7.4-2build1`: 1 paquete nuevo, 0 actualizados y 0 eliminados.
- Se ejecutó lectura extendida de información con `smartctl --xall` sobre `/dev/sda` y `/dev/sdb`; ambos comandos devolvieron código `0`.
- Ambos SSD informan salud global `PASSED`, temperatura actual de 29 °C y ausencia de sectores reasignados, errores incorregibles y errores CRC.
- El SSD de 512 GB informa 5.303 horas y 1 % de resistencia consumida; el SSD de 1 TB, 5.414 horas y 0 %.
- No se lanzaron autotests ni se realizaron comandos de escritura sobre los discos.
- El paquete habilitó `smartd` automáticamente. Quedó activo y monitorizando los dos SSD con valores predeterminados; alertas y autotests programados quedan pendientes de diseño.
- Evidencia preservada en `smart-srv-mm-01-2026-10-02.txt` con SHA-256 `4F081CD54178C57DBAB937C83622916335ABBBE647344FEBBA060F502DBB72D7`.
