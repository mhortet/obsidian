# Continuación de `srv-mm-01` — siguiente sesión

## Actualización operativa 2026-10-31

El servidor está encendido en una nueva red doméstica de preparación. Se realizó un cambio controlado de acceso SSH/UFW y se conservó evidencia en `ESTADO-ACCESO-SSH-Y-RED-2026-10-31.md`. Para estudiar el procedimiento, consultar `GUIA-DIDACTICA-CAMBIO-DE-RED-SSH-UFW.md`.

Estado validado en esta sesión:

- `srv-mm-01` obtuvo por DHCP `192.168.1.30/24` en `eno1`, con puerta de enlace observada `192.168.1.1`;
- la MAC `74:fe:48:67:be:cc` coincidió con el inventario previo de `eno1`;
- `ssh.socket` escuchaba TCP/22 mediante `systemd`;
- se creó transitoriamente `/run/sshd` como `root:root` y modo `0755`; `sudo sshd -t` terminó sin salida y con código `0`;
- UFW permite actualmente TCP/22 desde `192.168.1.0/24` y desde `192.168.0.0/24`;
- `192.168.1.0/24` es la LAN temporal actual y su acceso quedó validado con TCP, SSH por clave y rechazo deliberado de contraseña;
- `192.168.0.0/24` es únicamente la subred comunicada por el cliente; está preautorizada en UFW, pero no se ha validado desde la sede ni constituye todavía direccionamiento completo de producción;
- la regla obsoleta `192.168.2.0/24` fue eliminada después de probar una conexión nueva;
- la copia previa de UFW está en `/root/srv-mm-change-20261031-red/` y representa el estado anterior con `192.168.2.0/24`;
- no se cambió Netplan, no se reinició el servidor, no se abrió el router y no se modificaron MySQL, almacenamiento, firmware, usuarios ni servicios de aplicación.

Antes de trasladar el servidor faltan la IP concreta, puerta de enlace, rango DHCP, DNS, reserva para la MAC `74:fe:48:67:be:cc`, posible VLAN, comprobación de conflicto y origen de administración. No asumir `192.168.0.30`.

Se creó en Gmail un borrador sin destinatario y sin enviar, con asunto `Datos de red necesarios para configurar el servidor`. Solicita al cliente los parámetros anteriores, no pide credenciales y deberá revisarse antes de completar destinatario o envío.

Tema propuesto para la próxima sesión, todavía sin analizar ni configurar: estudiar cómo seguir el progreso e interactuar con Codex desde el teléfono sin exponer el servidor ni trasladar credenciales al móvil.

Al reanudar:

1. Confirmar que el equipo Windows no conserva innecesariamente la identidad cargada: `ssh-add -l`; descargarla con `ssh-add -d "$env:USERPROFILE\.ssh\id_ed25519_srv_mm"` si no se está usando.
2. Revalidar en solo lectura IP, ruta, `ssh.socket`, UFW, escuchas, MySQL detenido, `MYSQL_PORTS_CLOSED`, actualizaciones y unidades fallidas.
3. Recoger los datos definitivos del cliente antes de configurar Netplan o una reserva DHCP.
4. Mantener `192.168.1.0/24` hasta validar una conexión nueva desde la red del cliente; retirarla después.
5. No arrancar MySQL ni abrir 3306/33060 como parte del cambio de red.
6. Revisar el borrador de Gmail antes de enviarlo y estudiar por separado el acceso móvil a Codex, empezando por requisitos y límites de seguridad.

Prompt vigente para reanudar:

```text
Continuamos srv-mm-01 desde el cierre operativo del 2026-10-31. Lee AGENTS.md, ESTADO-ACCESO-SSH-Y-RED-2026-10-31.md, GUIA-DIDACTICA-CAMBIO-DE-RED-SSH-UFW.md, REVISION-DOCUMENTAL-Y-RUTA-MVP-2026-10-25.md, PLAN-ACCESO-ADMINISTRATIVO-REMOTO-2026-10-25.md y CONTINUAR-SIGUIENTE-SESION.md.

Empieza con una revalidación de solo lectura. La red doméstica temporal es 192.168.1.0/24 y el servidor obtuvo por DHCP 192.168.1.30. UFW permite SSH desde 192.168.1.0/24, acceso ya validado, y desde 192.168.0.0/24, subred comunicada por el cliente pero aún no validada en la sede. La antigua 192.168.2.0/24 fue retirada. No asumas 192.168.0.30 ni cambies Netplan hasta confirmar IP reservada, gateway, DHCP, DNS, VLAN, conflicto y origen administrador.

MySQL debe permanecer detenido y 3306/33060 cerrados. No abras SSH, MySQL o SMB a Internet. Mantén recuperación presencial y una sesión validada durante cualquier cambio de red o UFW. Presenta propósito, riesgo, aceptación y reversión antes de modificar el servidor.
```

## Actualización documental histórica 2026-10-25

El servidor está apagado y el trabajo de esta fecha fue exclusivamente documental. Leer primero:

1. `REVISION-DOCUMENTAL-Y-RUTA-MVP-2026-10-25.md`;
2. `PLAN-ACTUALIZACIONES-QONTROLMED-LAN-2026-10-25.md`;
3. `PLAN-ACCESO-ADMINISTRATIVO-REMOTO-2026-10-25.md`;
4. este relevo para la línea base técnica histórica.

Información confirmada por conversación con el cliente:

- servicio documental básico de carga y descarga, sin sincronización tipo OneDrive;
- acceso remoto necesario para el repositorio documental, con Cloudflare Tunnel como opción elegida para el diseño;
- alcance declarado sin datos de pacientes ni datos de personal;
- Qontrolmed solo desde la LAN del servidor;
- menos de diez equipos simultáneos;
- prioridad de entrada en producción rápida;
- red definitiva todavía pendiente de confirmar.

Decisión provisional: SFTPGo WebClient publicado únicamente mediante Cloudflare Tunnel y protegido por Cloudflare Access; Qontrolmed mediante MySQL LAN restringido con TLS verificado. El túnel solo llevará el WebClient: WebAdmin, SSH, SFTP, SMB, MySQL 3306 y 33060 no se publicarán. VPN de red completa, Nextcloud, sincronización, trabajo desconectado y Qontrolmed remoto quedan fuera del MVP.

Para mantenimiento remoto se diseña un plano separado: ruta privada de Cloudflare hacia SSH, accesible solo desde el ordenador de mantenimiento enrolado. El propietario conserva las credenciales; Codex trabaja mediante la terminal local y una sesión supervisada, sin clave propia permanente. No abrir TCP/22 en Internet. Mantener recuperación presencial porque el túnel no funciona si el servidor, Internet o `cloudflared` están caídos.

La dirección `192.168.2.104/24` y la regla temporal `192.168.2.0/24` no son datos de producción. No se debe encender MySQL, cambiar red, instalar servicios, crear usuarios, abrir puertos ni tocar UFW hasta revalidar el servidor en solo lectura y aprobar un plan de cambio exacto.

Antes de ejecutar faltan como mínimo: red real y rango DHCP, dirección estable del servidor, dominio y titular de la cuenta Cloudflare, correos autorizados en Access, usuarios y permisos de SFTPGo, tamaño máximo de archivo, destino de copia, equipos Qontrolmed, nombre estable para TLS y responsable de aceptación.

Prompt del 2026-10-25, sustituido por la actualización anterior:

```text
Continuamos srv-mm-01 exclusivamente desde la documentación vigente. Lee AGENTS.md, REVISION-DOCUMENTAL-Y-RUTA-MVP-2026-10-25.md, PLAN-ACTUALIZACIONES-QONTROLMED-LAN-2026-10-25.md, PLAN-ACCESO-ADMINISTRATIVO-REMOTO-2026-10-25.md y después CONTINUAR-SIGUIENTE-SESION.md. El servidor estaba apagado el 2026-10-25: empieza con una revalidación de solo lectura y no apliques cambios sin un plan exacto aprobado.

El MVP documental será SFTPGo WebClient sin sincronización tipo OneDrive. Se necesita acceso remoto mediante Cloudflare Tunnel protegido por Cloudflare Access. El túnel solo puede publicar el binding del WebClient; WebAdmin, REST administrativa, SSH, SFTP, SMB, MySQL 3306 y 33060 deben quedar fuera. No crees un hostname accesible sin una política Access restrictiva. Qontrolmed seguirá siendo solo LAN, para menos de diez equipos, y requiere TLS verificado, timeouts y gestión controlada de desconexión según su plan separado.

Antes de proponer ejecución confirma red real, dirección estable, dominio/cuenta Cloudflare, correos autorizados, permisos de SFTPGo, tamaño máximo de archivo, destino de copia, equipos Qontrolmed, nombre estable para TLS y responsable de aceptación. No reutilices 192.168.2.104/24 ni 192.168.2.0/24 como datos de producción. Mantén MySQL detenido y 3306/33060 cerrados durante la revalidación.
```

Relevo actualizado el 2026-10-04 (`Europe/Madrid`). Leer primero `AGENTS.md`, este documento y `REVALIDACION-Y-PROPUESTAS-2026-10-04.md`. `ESTADO-INSTALACION-2026-10-02.md` conserva la línea base anterior, pero no refleja los cambios del 2026-10-04.

## Punto seguro de reanudación

- Ubuntu Server 24.04.5 LTS, kernel `6.8.0-146-generic`, hostname `srv-mm-01`.
- Acceso temporal por SSH con clave como `vicente` en `192.168.1.30`; dirección DHCP de preparación, no válida como diseño definitivo.
- SSH solo por clave. UFW activo con entrada denegada y TCP/22 autorizado desde `192.168.1.0/24` y `192.168.0.0/24`; solo la primera ruta está validada actualmente.
- Zona horaria `Europe/Madrid`; NTP sincronizado.
- No había paquetes APT pendientes, reinicio pendiente ni unidades fallidas durante las últimas comprobaciones.
- No ejecutar `do-release-upgrade`: el aviso de Ubuntu 26.04.1 no está autorizado.

## Almacenamiento ya terminado

Se ejecutó la opción A dentro del LUKS2 de `/dev/sda`:

| Destino | LV | Tamaño | UUID | Montaje y opciones |
| --- | --- | ---: | --- | --- |
| MySQL | `ubuntu-vg/mysql_data` | 64 GB | `cdbcfa54-5c45-4cc6-9b46-914b68a6ca2c` | `/var/lib/mysql`, `ext4`, `rw,nosuid,nodev` |
| Compartido | `ubuntu-vg/shared_data` | 224 GB | `cae9d953-19f8-44fd-86be-14b02e1ecd5c` | `/srv/compartido`, `ext4`, `rw,nosuid,nodev,noexec` |

- El VG conserva aproximadamente 85,87 GB libres.
- `/etc/fstab` fue validado con `mount -a` y `findmnt --verify` sin errores; SHA-256 final `febf646568dee762daa9f93a1f2123210f95301267fed45d9497cb365d654ec8`.
- Respaldo anterior: `/root/srv-mm-storage-20261004-01/fstab.before`.
- No se reinició el servidor.

## SMART y SSD de 1 TB

- Los autotests cortos autorizados de `/dev/sda` y `/dev/sdb` finalizaron `Completed without error`.
- Ambos SSD continúan `PASSED`, sin reasignaciones, errores incorregibles ni CRC.
- `/dev/sdb`, Samsung SSD 860 PRO de 1 TB, conserva sus particiones y datos anteriores. No montar con escritura, borrar, formatear ni reutilizar sin autorización expresa.

## Firmware y Secure Boot

El aviso de tres actualizaciones corresponde a KEK, UEFI CA y UEFI dbx, no a los SSD. Secure Boot está deshabilitado; la Platform Key aparece como `DO NOT TRUST - AMI Test PK` y los datos DMI no identifican la placa. No aplicar firmware ni activar Secure Boot hasta identificar físicamente la placa y disponer de recuperación presencial.

## Repositorio e instalación de MySQL

- Repositorio oficial MySQL 8.4 LTS auditado e incorporado para Ubuntu `noble`, `amd64`.
- Clave oficial verificada con huella `BCA43417C3B485DD128EC6D4B7B3B788A8D3785C`.
- Fuente: `/etc/apt/sources.list.d/mysql-8.4-lts.sources`.
- Keyring: `/usr/share/keyrings/mysql-2025.gpg`.
- Recuperación previa: `/root/srv-mm-mysql-20261004-01/`.
- MySQL Community Server `8.4.11-1ubuntu24.04` instalado.
- `root@localhost` usa `auth_socket`; no se estableció contraseña de root.
- No se han creado usuarios de aplicación ni los esquemas `gestion`, `quirofanos` y `preventivos`.
- El directorio `/var/lib/mysql` está inicializado sobre el LV dedicado, con propietario `mysql:mysql` y modo `0750`.

## Estado crítico de MySQL al reanudar

**MySQL está habilitado pero detenido. No arrancarlo antes de cerrar el diseño de red.**

La instalación predeterminada escuchó en `*:3306` y `*:33060`. Se detuvo inmediatamente y se verificó `MYSQL_PORTS_CLOSED`. No se modificó todavía `/etc/mysql/mysql.conf.d/mysqld.cnf`.

Comprobaciones iniciales de solo lectura recomendadas:

```bash
systemctl is-enabled mysql
systemctl is-active mysql
sudo ss -ltnp | grep -E ':(3306|33060)([[:space:]]|$)' || echo MYSQL_PORTS_CLOSED
sudo ufw status verbose
```

Resultado esperado: `enabled`, `inactive`, `MYSQL_PORTS_CLOSED` y ninguna regla MySQL en UFW.

## Conclusión sobre Qontrolmed

La documentación de `D:\trabajo\Proyectos\maxgesth` confirma que:

- Qontrolmed se ejecuta en Windows y conecta directamente mediante `mysql-connector-python` a tres esquemas MySQL.
- `DB_HOST=127.0.0.1` corresponde al MySQL anterior instalado en el mismo Windows.
- Si el nuevo MySQL Ubuntu queda limitado a `127.0.0.1`, Qontrolmed no podrá conectarse directamente desde Windows salvo que exista un túnel SSH.
- La cuenta prevista es `maxgesth_user`, de mínimo privilegio y limitada por esquemas y origen.
- No hay soporte TLS documentado en `.env.example`; debe confirmarse en el código sin leer ni mostrar el `.env` real.
- La aplicación documenta el puerto clásico 3306; no se ha justificado el puerto X 33060.

La autorización dada inicialmente para configurar loopback quedó anulada al detectarse este malentendido. No se editó ningún archivo.

## Secuencia recomendada para la próxima sesión

1. Revalidar en solo lectura SSH, UFW, estado de MySQL, puertos, actualizaciones y unidades fallidas.
2. Revisar exclusivamente el código de conexión de Qontrolmed —sin abrir ningún `.env` real— para comprobar:
   - construcción de las tres conexiones;
   - compatibilidad con nombre/IP remota;
   - parámetros disponibles para TLS (`ssl_ca`, `ssl_cert`, `ssl_key`, verificación de identidad);
   - timeouts, reconexión y tratamiento de errores;
   - uso exclusivo del protocolo clásico 3306.
3. Presentar dos diseños, sin ejecutarlos:
   - conexión LAN directa restringida y cifrada;
   - túnel SSH persistente desde el ordenador Qontrolmed.
4. Para cada diseño especificar propósito, riesgos, disponibilidad, prueba de aceptación y reversión.
5. No cambiar `bind-address`, UFW, direccionamiento, usuarios MySQL ni TLS hasta que el propietario elija una arquitectura y la red definitiva esté identificada.
6. Después de aprobar la arquitectura, preparar copia de la configuración MySQL, validar con `mysqld --validate-config` y arrancar solo durante una prueba controlada de puertos y conexión.

## Límites que siguen vigentes

- No abrir MySQL, SSH o SMB a Internet.
- No convertir `192.168.1.30` ni `192.168.1.0/24` en datos de producción; son valores de preparación.
- No asumir una IP concreta dentro de `192.168.0.0/24` hasta confirmar DHCP, gateway, DNS y ausencia de conflicto con el cliente.
- No leer, copiar ni mostrar contraseñas o el contenido de un `.env` real.
- No tocar PAM, Secure Boot, firmware, BIOS/UEFI ni `/dev/sdb` sin autorización específica.
- No ejecutar `mysql_secure_installation` de forma automática.
- No crear usuarios o esquemas de Qontrolmed hasta definir privilegios, origen y restauración.
- No instalar Samba ni reutilizar el SSD de 1 TB todavía.
- Mantener una sesión SSH de recuperación durante cambios de red o acceso.

## Acceso desde Windows

En PowerShell visible:

```powershell
Start-Service ssh-agent
ssh-add "$env:USERPROFILE\.ssh\id_ed25519_srv_mm"
ssh -o KexAlgorithms=curve25519-sha256 -o IdentitiesOnly=no vicente@192.168.1.30
```

Introducir la frase de la clave únicamente en PowerShell. Al finalizar:

```powershell
ssh-add -d "$env:USERPROFILE\.ssh\id_ed25519_srv_mm"
```

No borrar el archivo de clave privada.

## Prompt histórico del 2026-10-04, sustituido por la actualización anterior

```text
Continuamos la instalación segura de srv-mm-01. Lee primero AGENTS.md, CONTINUAR-SIGUIENTE-SESION.md y REVALIDACION-Y-PROPUESTAS-2026-10-04.md; usa ESTADO-INSTALACION-2026-10-02.md solo como línea base histórica. Empieza con una revalidación breve de solo lectura. MySQL Community Server 8.4.11 está instalado y habilitado, pero debe permanecer detenido: su configuración predeterminada abrió *:3306 y *:33060, se detuvo inmediatamente y se verificó MYSQL_PORTS_CLOSED. No reinicies MySQL ni cambies su configuración todavía.

Qontrolmed vive en el ordenador Windows, en D:\trabajo\Proyectos\maxgesth, y conecta directamente mediante mysql-connector-python a gestion, quirofanos y preventivos. La plantilla usa DB_HOST=127.0.0.1 porque el MySQL anterior estaba en ese mismo Windows; limitar el MySQL Ubuntu a loopback impediría la conexión directa salvo túnel SSH. Revisa en modo de solo lectura el código de conexión, sin abrir ni mostrar ningún .env real, para confirmar soporte TLS, timeouts y uso del protocolo clásico. Después presenta dos alternativas justificadas: LAN directa restringida y cifrada, o túnel SSH persistente. Para cada una incluye propósito, riesgos, prueba de aceptación y reversión. No ejecutes ninguna hasta mi aprobación expresa.

Conserva los límites: no abrir 3306/33060 a Internet; no crear reglas permanentes con la IP temporal 192.168.2.104; no crear usuarios o esquemas MySQL aún; no tocar PAM, Secure Boot, firmware ni el SSD de 1 TB; no instalar Samba; no ejecutar mysql_secure_installation; y no reiniciar el servidor sin aprobación. El almacenamiento opción A ya está terminado: mysql_data 64 GB, shared_data 224 GB y unos 85,87 GB libres en ubuntu-vg.
```
