---
title: "srv-mm-01 — Documentación del servidor Ubuntu y guía de mantenimiento"
type: project
status: active
created: 2026-11-05
updated: 2026-11-13
sources:
  - "00_seguimiento/estados/ESTADO-INSTALACION-2026-10-01.md"
  - "00_seguimiento/estados/REVALIDACION-Y-PROPUESTAS-2026-10-04.md"
  - "00_seguimiento/estados/ESTADO-OPERATIVO-SRV-MM-01-2026-11-01.md"
  - "00_seguimiento/estados/ESTADO-RESTAURACION-FUNCIONAL-COMPLETA-2026-11-05.md"
  - "02_planes_y_arquitectura/PLAN-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "00_seguimiento/estados/ESTADO-PAUSA-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "03_operacion_y_runbooks/INICIAR-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "00_seguimiento/estados/ESTADO-INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12.md"
tags: [documentacion, seguridad, administracion]
review_after: 2026-11-19
---

# srv-mm-01 — Documentación del servidor Ubuntu y guía de mantenimiento

**Versión:** 1.7 · **Fecha de corte:** 13 de noviembre de 2026 · **Zona horaria:** Europe/Madrid.
**Estado de entrega:** documentación consolidada de preparación y piloto; puesta en producción y aceptación del cliente pendientes.  
**Clasificación:** uso del cliente y personal de mantenimiento autorizado. Contiene información de infraestructura; distribuir de forma controlada.

Este es el documento maestro que se actualizará al recibir nueva información. Los registros originales se conservan como evidencia e historial técnico. La versión 1.7 incorpora la validación P2C del ledger contra MySQL sintético y el hallazgo de selección de certificado TLS. No autoriza producción ni datos reales.

## Índice

1. [Objetivo y alcance](#1-objetivo-y-alcance)
2. [Estado confirmado y límites](#2-estado-confirmado-y-límites)
3. [Hardware y almacenamiento](#3-hardware-y-almacenamiento)
4. [Instalación y configuración base](#4-instalación-y-configuración-base)
5. [Red y acceso administrativo](#5-red-y-acceso-administrativo)
6. [Servicios y aplicaciones](#6-servicios-y-aplicaciones)
7. [Actuaciones y comandos ejecutados](#7-actuaciones-y-comandos-ejecutados)
8. [Decisiones tomadas](#8-decisiones-tomadas)
9. [Pruebas y resultados](#9-pruebas-y-resultados)
10. [Guía de mantenimiento](#10-guía-de-mantenimiento)
11. [Copias, recuperación e incidencias](#11-copias-recuperación-e-incidencias)
12. [Pendientes y aceptación de entrega](#12-pendientes-y-aceptación-de-entrega)
13. [Fuentes y trazabilidad](#13-fuentes-y-trazabilidad)
14. [Actualizaciones e historial de cambios](#14-actualizaciones-e-historial-de-cambios)

## 1. Objetivo y alcance

Preparar un servidor dedicado para una pequeña empresa que gestiona instalaciones y equipos de hospitales y clínicas. Los servicios previstos son un repositorio documental con acceso seguro y una base MySQL para Qontrolmed, con administración, copias y recuperación verificables.

El alcance de información comprende inventario, mantenimiento, documentación técnica, ubicaciones, contratos, incidencias y configuración de instalaciones y equipos. Quedan excluidos datos de pacientes, historias clínicas, diagnósticos, imágenes médicas e identificadores clínicos. Los datos de contacto y registros que identifiquen a personas requieren protección, aunque no sean clínicos.

El piloto del 5 de noviembre se limita a la vivienda de preparación, un puesto Windows y datos ficticios. Sus resultados no constituyen autorización para cargar datos reales ni aceptación de producción. Los nombres de módulos, incluido «Quirófanos», no amplían el alcance permitido de datos.

## 2. Estado confirmado y límites

**Confirmado** significa respaldado por la fuente y fecha indicadas, no comprobado continuamente. **Comunicado** identifica información recibida sin validación técnica en sede. **Propuesto** identifica un diseño sin evidencia de despliegue. **Pendiente** significa que falta una comprobación o decisión.

| Elemento | Última situación documentada | Fecha / condición |
| --- | --- | --- |
| Equipo | `srv-mm-01`, Ubuntu 24.04.5 LTS, x86-64 | Confirmado en auditoría y revalidación [F1, F5] |
| Kernel | `6.8.0-147-generic` | Confirmado tras reinicio del 01/11 y revalidación del 05/11 [F4, F5] |
| Salud | Sin unidades fallidas; servicios del bloque detenidos al cierre | Confirmado 06/11; no equivale a auditoría integral [F15] |
| Red | `eno1`, `192.168.1.31/24`, DHCP con reserva doméstica | Confirmado 01/11 y 05/11; temporal [F4, F5] |
| Administración | SSH por clave, TCP/22; UFW activo | Confirmado; detalle de reglas con límites descritos en §5 |
| MySQL | 8.4.11 instalado; `inactive/disabled`, sin proceso ni 3306/33060 | Versión auditada 05/11; cierre independiente posterior a restauración [F6, F7] |
| Datos del piloto | Tres esquemas ficticios; 33 tablas funcionales | Confirmado; copias y restauraciones conservadas [F7] |
| Aplicación | Qontrolmed probado en copia aislada del puesto Windows | No instalado como aplicación de servidor ni desplegado sobre la habitual [F6, F8] |
| Documentos y acceso remoto externo | SFTPGo aceptado en ensayo ficticio solo por loopback; `cloudflared` instalado pero inerte | Al cierre SFTPGo `inactive/disabled`, `cloudflared inactive/masked`; sin túnel, DNS o exposición externa [F15] |
| Producción | No aceptada | Faltan requisitos, controles y pruebas de §12 |

La documentación antigua contiene pendientes que después se completaron. Esta guía aplica la evidencia posterior: la restauración funcional de 33 tablas **sí está completada**. La IP doméstica vigente es `.31`; `.30` es histórica y no debe reutilizarse por suposición.

## 3. Hardware y almacenamiento

### 3.1. Inventario físico

| Componente | Dato documentado | Evidencia / falta |
| --- | --- | --- |
| CPU | Intel Core i7-9700K, 8 núcleos y 8 hilos | Auditoría Linux 01/10 [F1] |
| RAM | Aproximadamente 32 GB; Linux presenta 31 GiB | Auditoría Linux 01/10 [F1] |
| Disco sistema | Samsung SSD 860 PRO 512 GB, `/dev/sda`, 476,9 GiB observados | Instalación y SMART [F1, F2] |
| Segundo disco | Samsung SSD 860 PRO 1 TB, `/dev/sdb`, 953,9 GiB observados | Particiones anteriores VFAT/NTFS; no autorizado para reutilización [F1, F3] |
| Red activa | Intel I219-LM, `eno1`, MAC `74:fe:48:67:be:cc` | Identidad contrastada en cambios de red [F1, F4] |
| Otras interfaces | `enp5s0`, `enp6s0`, `enp7s0`, inactivas en auditoría inicial | Revalidar disponibilidad, modelo y cableado antes de usarlas [F1] |
| Consola gráfica | Intel UHD 630 integrada; NVIDIA GA106 retirada el 12/11 | VGA y DisplayPort aceptados con `nomodeset`; NVIDIA pendiente diagnóstico físico [F17] |
| Firmware | AMI 5.13, fecha 23/04/2021 | DMI identifica sistema/placa como `Default string`; modelo físico pendiente [F1, F3] |
| Arranque | UEFI; Secure Boot deshabilitado | Confirmado en preparación; no consta cambio posterior [F1–F3] |
| Alimentación / SAI | Sin inventario o ensayo operativo confirmado | Faltan modelo de fuente, SAI, autonomía y recuperación de energía |

No consta inventario físico completo de chasis, placa, módulos RAM, ubicación definitiva, garantía o equipo de sustitución. Los nombres `/dev/sda` y `/dev/sdb` son los observados: antes de operaciones de disco se debe contrastar identidad física, modelo y capacidad.

#### Consola tras retirar la NVIDIA — 12/11/2026

La NVIDIA GA106 de 12 GiB, que los arranques anteriores identificaban como `boot VGA` con framebuffer `nouveau`, produjo cuatro pitidos de POST y fue retirada por el propietario. Sin ella, la Intel UHD 630 pasó a asumir la consola: el firmware y LUKS se veían por VGA, pero al cargar `i915` aparecieron `dotclock = 0`, advertencia DRM y ausencia de modos, perdiéndose la señal. El sistema no estaba bloqueado; continuaba arrancando y atendía apagados controlados.

Tras un ensayo temporal satisfactorio, el propietario autorizó añadir solo `nomodeset` a `GRUB_CMDLINE_LINUX_DEFAULT`. Se conservó `/etc/default/grub.pre-nomodeset-20261112T1325`, se ejecutó `update-grub` y se validó el archivo generado. El hash vigente de `/etc/default/grub` es `b9aede8e2827937cb4e0d6f087e0f8f6813e5e93c17a0e090a082820b728c361`. Se completaron tres arranques persistentes: dos con VGA y uno con DisplayPort; `simpledrm` conservó la consola hasta login, red y SSH funcionaron, y no reaparecieron los errores de `i915` [F17].

`nomodeset` limita la gestión gráfica avanzada y el audio HDMI/DP, pero no afecta al uso previsto de consola. No fijar resolución ni reinstalar la NVIDIA sin un nuevo plan. La reversión consiste en retirar `nomodeset`, ejecutar `update-grub` y validar, o restaurar la copia fechada. La entrega debe incluir una ruta de consola probada para firmware, LUKS y login; no debe depender de que el cliente aporte un monitor DisplayPort.

### 3.2. Estructura de almacenamiento

El SSD del sistema contiene `/dev/sda1` FAT32 para `/boot/efi` (aprox. 1 GiB), `/dev/sda2` ext4 para `/boot` (aprox. 2 GiB) y `/dev/sda3` LUKS2 con LVM. El cifrado no incluye las particiones de arranque. El grupo `ubuntu-vg` reside dentro del contenedor cifrado.

| Volumen | Tamaño asignado documentado | Uso / montaje | Estado |
| --- | ---: | --- | --- |
| `ubuntu-lv` | 100 GiB | `/`, ext4 | Creado en instalación |
| `mysql_data` | 64 GiB | `/var/lib/mysql`, ext4, `nosuid,nodev` | Creado y probado 04/10; montado en revalidación 05/11 |
| `shared_data` | 224 GiB | `/srv/compartido`, ext4, `nosuid,nodev,noexec` | Creado y probado 04/10; montado en revalidación 05/11 |
| Reserva del VG | 85,87 GiB | Sin asignar según registro del 04/10 | Pendiente nueva lectura privilegiada si se va a utilizar |
| Swap | 8 GiB, `/swap.img` en auditoría inicial | Intercambio | Revalidar estado actual si se modifica memoria/almacenamiento |

Los montajes de datos son persistentes por UUID en `/etc/fstab`. UUID documentados: MySQL `cdbcfa54-5c45-4cc6-9b46-914b68a6ca2c`; compartido `cae9d953-19f8-44fd-86be-14b02e1ecd5c`. MySQL quedó con propietario `mysql:mysql` y modo `0750` tras instalarse. El compartido tenía `root:root 0750` en su preparación; faltan permisos de usuarios documentales definitivos.

La diferencia entre LV asignado y capacidad presentada por `df` corresponde a medidas y sistema de archivos: el 05/11 se documentaron unos 82 GiB libres en raíz, 62 GiB en MySQL y 218 GiB en compartido. Son una captura, no capacidad garantizada futura.

### 3.3. Salud de discos

El 02/10 ambos SSD mostraron SMART `PASSED`, sin sectores reasignados, errores incorregibles ni CRC. El 04/10 ambos autotests cortos terminaron `Completed without error`, sin LBA de error. El SSD de 1 TB solo recibió la escritura técnica del registro SMART autorizada para el test; no se montaron ni alteraron sus datos [F2, F3].

No consta autotest largo ni sistema de avisos SMART entregado. Dos discos en el equipo no acreditan RAID, copia independiente ni tolerancia a averías.

## 4. Instalación y configuración base

### 4.1. Instalación realizada el 1 de octubre de 2026

Se instaló Ubuntu Server 24.04.5 LTS sobre el SSD de 512 GB, cuyo borrado había sido autorizado. El SSD de 1 TB se conservó. Se configuraron hostname `srv-mm-01`, cuenta administrativa `vicente`, OpenSSH, UEFI y LUKS2/LVM. No se vinculó Ubuntu Pro ni se seleccionaron snaps adicionales [F1].

Se creó una identidad SSH ED25519 específica en el ordenador administrador, protegida mediante frase secreta. Únicamente su parte pública se instaló en el servidor. La frase y la clave privada no forman parte de esta guía.

No consta en la documentación revisada la huella del ISO utilizado ni un registro completo de todas las selecciones del instalador. No consta una imagen recuperable del Windows anterior.

### 4.2. Cifrado y arranque

El instalador generó un medio de recuperación LUKS, que se comprobó al arrancar. La frase inicialmente introducida no desbloqueó el primer arranque; se recuperó el acceso, se añadió una nueva frase y se validó mediante prueba y arranque posterior. Se documentó custodia externa y retirada de la copia temporal de recuperación del instalador [F1].

**Pendiente para entrega:** verificar custodio, acceso efectivo a los medios de recuperación y procedimiento ante ausencia de la persona local. No consta desbloqueo remoto previo al arranque. SSH y los futuros túneles solo funcionan una vez arrancado Ubuntu y desbloqueado LUKS. No retirar keyslots sin comprobar al menos dos medios funcionales de recuperación.

### 4.3. Endurecimiento y actualizaciones

El 02/10 se fijó `Europe/Madrid`, conservando NTP y RTC en UTC; se activó UFW y se reforzó SSH. Se aplicaron 15 actualizaciones previamente simuladas y se instaló `smartmontools 7.4-2build1`. `smartd` quedó activo por defecto, sin alertas ni calendario definidos [F2].

El 01/11 una actualización automática instaló, entre otros, systemd, OpenSSH y el kernel `6.8.0-147`; se completó un reinicio controlado y se validaron acceso, montajes y servicio MySQL detenido. La actualización disponible de MySQL 8.4.13 no se incluyó. Esto es un hallazgo histórico: el catálogo de actualizaciones disponible hoy requiere consulta nueva [F4].

AppArmor estaba habilitado. Quedan dos incidencias documentadas sin cierre acreditado: referencia opcional al módulo ausente `pam_lastlog.so` en login y aviso `Illegal number: yes` al recargar AppArmor. Falta comprobar su situación actual. No se modificará PAM ni código de paquetes sin diagnóstico y plan [F2].

En firmware se detectaron actualizaciones de KEK, base UEFI y dbx, con una Platform Key de pruebas marcada insegura. Se aplazaron hasta identificar físicamente la placa y disponer de recuperación. No consta habilitación posterior de Secure Boot [F3].

## 5. Red y acceso administrativo

### 5.1. Direccionamiento e identidad

| Entorno / fecha | Configuración | Uso permitido de este dato |
| --- | --- | --- |
| Preparación inicial, octubre | `192.168.2.104/24`, DHCP; gateway `192.168.2.1` | Histórico; no usar como producción |
| Cambio de LAN, 31/10 | Se documentó temporalmente `192.168.1.30` | Histórico; el 01/11 `.30` correspondía a otro equipo |
| Preparación vigente, 01–05/11 | `192.168.1.31/24`, reserva DHCP para MAC `74:fe:48:67:be:cc`; gateway/DNS `192.168.1.1` documentados 01/11 | Solo entorno doméstico |
| Puesto de piloto, 05/11 | Windows `192.168.1.107` | Único origen LAN autorizado durante ventanas del piloto |
| Sede del cliente | Rango comunicado `192.168.0.0/24` | Sin validación in situ; IP, gateway, DNS, DHCP y VLAN pendientes |

La reserva `.31` se comprobó tras reiniciar. Ubuntu sigue utilizando DHCP; no se convirtió en IP estática por Netplan. No asumir una IP de sede por similitud con la doméstica.

### 5.2. SSH y firewall

Configuración SSH documentada en `/etc/ssh/sshd_config.d/00-srv-mm-ssh-hardening.conf`: claves públicas habilitadas; contraseña, autenticación interactiva, contraseñas vacías y login directo de root deshabilitados; `MaxAuthTries 3` y `X11Forwarding no` [F2, F10].

SSH utiliza activación por `ssh.socket`; que `ssh.service` aparezca inactivo sin sesiones no prueba una avería. El puerto 22 se observó en IPv4 e IPv6; el detalle completo de reglas IPv6 debe incluirse en la revalidación privilegiada.

UFW: entrada denegada y salida permitida. La auditoría privilegiada del 05/11 a las 11:27 confirmó únicamente TCP/22 desde `192.168.1.0/24` y desde `192.168.0.0/24`. Esta última regla prepara el rango comunicado por el cliente, pero no acredita conectividad en sede. Durante el piloto se añadió temporalmente MySQL desde el puesto `/32` y se retiró al cerrar. El script confirmó su retirada; no se repitió después una lectura privilegiada independiente de todas las reglas [F4, F6].

No consta apertura de puertos en el router ni publicación directa de SSH, SMB o MySQL en Internet. Antes de producción debe comprobarse también el router y la exposición desde fuera.

La conexión de preparación usó temporalmente `HostKeyAlias=192.168.1.30` para contrastar la clave de host ya conocida en `.31`. Falta normalizar `known_hosts` de forma segura; no eliminar advertencias ni aceptar claves nuevas sin verificación independiente.

### 5.3. Acceso externo propuesto

El diseño propone SFTPGo WebClient detrás de Cloudflare Tunnel + Access para documentos y un canal privado separado hacia SSH para mantenimiento, con identidad y MFA. El ensayo doméstico instaló SFTPGo y `cloudflared`, pero no creó túnel, token, DNS, Access o exposición externa. WebClient y WebAdmin solo se probaron mediante reenvío SSH hacia `127.0.0.1:18080/18081`. Dominio, cuenta Cloudflare, recuperación de identidad y políticas reales siguen pendientes [F9, F13, F14].

## 6. Servicios y aplicaciones

| Servicio | Instalado / probado | Situación y límites |
| --- | --- | --- |
| OpenSSH | Sí | Acceso local por clave validado; acceso externo pendiente |
| UFW | Sí | Activo; reglas y límites en §5 |
| Sincronización horaria | NTP activo y reloj sincronizado en preparación | Revalidar periódicamente; no se establece aquí un daemon concreto |
| SMART / smartd | Sí | Lecturas y autotests cortos correctos; avisos pendientes |
| MySQL Community Server 8.4.11 | Sí | Parado/deshabilitado al cierre; configuración de piloto, no servicio de producción |
| Qontrolmed | Copia Windows aislada | Pruebas funcionales parciales completadas; paquete y aceptación pendientes |
| SFTPGo, `cloudflared`, `restic`, `acl` | Instalados y aceptados en ensayo doméstico ficticio | SFTPGo `inactive/disabled`; `cloudflared inactive/masked`; restauración local `restic` verificada; ACL nominal mínima para tránsito. Sin túnel, DNS, destino externo o 3-2-1 [F15] |
| Samba/SMB, Cockpit, VPN, Docker o virtualización | Sin evidencia de despliegue operativo en las fuentes revisadas | Las comparativas iniciales son alternativas, no inventario de servicios |

### 6.1. MySQL

Se instaló el 04/10 desde el repositorio oficial MySQL, rama `mysql-8.4-lts`, para Ubuntu `noble` y `amd64`, después de verificar firma y metadatos. Fuente: `/etc/apt/sources.list.d/mysql-8.4-lts.sources`; keyring: `/usr/share/keyrings/mysql-2025.gpg`. Se documentaron 12 paquetes nuevos, sin retiradas ni actualizaciones adicionales en esa instalación [F3].

`root@localhost` usa `auth_socket`; esto no equivale a acceso remoto de root sin contraseña. Las cuentas internas estaban bloqueadas. Las cuentas del piloto quedaron bloqueadas al cierre; no existe evidencia de cuentas de aplicación productivas aceptadas.

Archivo de piloto `/etc/mysql/mysql.conf.d/90-qontrolmed-piloto.cnf`, `root:root 0644`:

```ini
[mysqld]
bind-address=127.0.0.1
mysqlx=OFF
require_secure_transport=ON
ssl-ca=/var/lib/mysql/piloto-tls/ca.pem
ssl-cert=/var/lib/mysql/piloto-tls/server-cert.pem
ssl-key=/var/lib/mysql/piloto-tls/server-key.pem
```

Estas son rutas de referencia; no se incluyen contenidos de claves. La escucha LAN solo se habilitó durante ventanas controladas y se restituyó a loopback. Hash SHA-256 del archivo al cierre: `4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927` [F6, F7].

Certificado exclusivo del piloto: SAN `srv-mm-01`, `127.0.0.1` y `192.168.1.31`; vencimiento de servidor documentado 03/02/2027 y CA 05/11/2027. No reutilizar esta identidad doméstica como identidad de sede. La clave de servidor está restringida a MySQL y la privada de CA permanece bajo administración del servidor; ninguna se incorpora a esta guía [F6, F10].

### 6.2. Qontrolmed

La aplicación se ejecutó en Windows y conectó a MySQL por LAN con TLS verificado durante el piloto. No es una aplicación web desplegada en Ubuntu según la evidencia revisada.

En la copia aislada se incorporaron verificación de CA e identidad, timeouts finitos, desactivación de `LOCAL INFILE`, recuperación acotada antes de una operación nueva y cierre de sesiones. Las escrituras de resultado incierto no se repiten automáticamente. El alta de marcas conserva ID manuales históricos; el formulario/servicio se corrigió para transmitirlos y validarlos [F6, F8].

La copia revisada está en `C:\Users\Maxi\Documents\Codex\2026-11-05\u\work\qontrolmed-piloto`, rama `pilot/mysql-tls-20261105`, base `014bf7c7b3c80c514786c36d1135efe00202b7a0`. Cambios sin commit, merge ni despliegue sobre la aplicación habitual al corte documental. El ZIP de revisión conservado en el proyecto es una instantánea, no un instalador.

**Bloqueo de empaquetado:** el instalador aún no proporciona/exige de forma coherente la CA pública de sede en la ruta usada por la aplicación. Falta alinear plantilla, instalador, configurador, verificador, permisos y pruebas. El código falla de forma segura si falta la CA, pero eso no hace reproducible la instalación [F8].

## 7. Actuaciones y comandos ejecutados

Registro resumido de operaciones acreditadas. No es un historial exhaustivo de terminal ni una receta para repetir la instalación. Cuando las fuentes describen una operación sin conservar su invocación completa, se indica expresamente. Los scripts del proyecto contienen más detalle, pero su existencia por sí sola no demuestra ejecución.

| Fecha | Actuación acreditada / comando conservado | Resultado y alcance |
| --- | --- | --- |
| 01/10 | Instalador Ubuntu, particionado y LUKS/LVM | Instalación en SSD 512 GB; SSD 1 TB conservado [F1] |
| 01/10 | `cryptsetup luksAddKey`; `cryptsetup open --test-passphrase` | Nueva frase validada, código 0; argumentos y secretos omitidos [F1] |
| 01/10 | Retirada autorizada del archivo temporal de recuperación; `test ! -e` | Ausencia confirmada; no se reproduce comando destructivo sin contexto [F1] |
| 02/10 | `timedatectl set-timezone Europe/Madrid` | Hora local configurada, NTP activo [F2, F10] |
| 02/10 | `ufw default deny incoming`; `ufw default allow outgoing`; `ufw allow from 192.168.2.0/24 to any port 22 proto tcp`; `ufw --force enable` | Baseline histórico ejecutado con privilegios; origen sustituido después [F2, F10] |
| 02/10 | `sshd -t`; `systemctl reload ssh.service` | Configuración validada y acceso nuevo por clave [F2, F10] |
| 02/10 | `LC_ALL=C apt-get --simulate upgrade`; `LC_ALL=C apt-get upgrade` | 15 actualizados; 0 nuevos, retirados o retenidos [F2, F10] |
| 02/10 | Instalación de smartmontools y captura SMART | Paquete y resultados acreditados; consultar script original para invocación completa [F2, F10] |
| 04/10 | Creación `mysql_data` y `shared_data`, formateo ext4 y cambios `fstab` | Acreditados resultados y autorizaciones; no se reconstruyen aquí líneas `lvcreate`/`mkfs` [F3] |
| 04/10 | `e2fsck -fn`; `findmnt --verify --verbose`; `mount -a` | Sistemas limpios, montajes recuperados, pruebas de escritura correctas [F3] |
| 04/10 | `smartctl -t short /dev/sda`; `smartctl -t short /dev/sdb` | Autotests autorizados y completados sin error [F3] |
| 04/10 | Verificación de firma de repositorio; `apt-get update`; instalación MySQL | Firma correcta e instalación 8.4.11; sintaxis completa de instalación no reproducida [F3] |
| 31/10 | `sudo install -d -o root -g root -m 0755 /run/sshd`; `sudo sshd -t` | Validación sin error; sin cambiar activación por socket [F11] |
| 31/10 | Reglas UFW para SSH desde `192.168.1.0/24` y `192.168.0.0/24`; retirada de `192.168.2.0/24` | Nueva conexión por clave válida; sede aún no probada [F11] |
| 01/11 | Reserva DHCP en router; `sudo systemctl disable --now mysql`; `sudo systemctl reboot` | `.31` estable tras reiniciar, MySQL detenido/deshabilitado [F4] |
| 05/11 | Scripts `cambio01-piloto-20261105.sh`, `cambio02-piloto-20261105.sh`, `cambio03-piloto-20261105.sh`; `mysqld --user=mysql --validate-config` | Configuración local, arranque breve y certificado del piloto; resultados en evidencias [F10] |
| 05/11 | Scripts de piloto local/LAN, pruebas Windows y servicios funcionales | TLS, permisos, operaciones ficticias y cierre probados [F6, F10] |
| 05/11 | Intento `ALTER` para autoincremento | Rechazado con error 1833 por relación foránea; no se forzó. Propuesta retirada al confirmar ID manuales [F6] |
| 05/11 | Script `copiar-restaurar-esquema-funcional-20261105.py`, revisión R3 | Restauración funcional de 33 tablas y cierre seguro [F7] |
| 05/11 | `git diff --check`; suite automatizada de aplicación | Sin incidencias de formato; 39/39 pruebas correctas [F8] |
| 06/11 | Auditoría remota de solo lectura por SSH estricto | Estado esperado: kernel `6.8.0-147`, sin reinicio/fallos, MySQL parado, SSH por socket, solo 22; paquetes documentales ausentes y `/srv/compartido/repositorio` sin crear [F13] |
| 06/11 | Scripts de aplicación y corrección ACL del bloque doméstico | SFTPGo, `cloudflared`, `restic` y `acl` instalados; bindings solo loopback, plantilla inerte y tránsito mínimo `u:sftpgo:--x` [F14] |
| 06/11 | `aceptar-bloque-domestico-20261106.sh` corregido, pruebas WebClient y restauración `restic` | Descarga/sobrescritura, límites, autenticación, revocación, hashes, `restic check` y `SQLITE_INTEGRITY=ok`; cierre seguro [F15] |

Los comandos de las filas históricas modificadoras se ejecutaron bajo planes autorizados. No deben copiarse en bloque al servidor actual. Esta consolidación no ejecutó ninguno de ellos.

## 8. Decisiones tomadas

| Fecha | Decisión | Motivo / condición actual |
| --- | --- | --- |
| 01/10 | Ubuntu dedicado en SSD 512 GB; conservar SSD 1 TB | Instalación autorizada; no hay imagen recuperable de Windows acreditada |
| 01/10 | LUKS2 y SSH por clave; sin root remoto ni contraseña SSH | Proteger datos y limitar acceso; custodia/recuperación de entrega pendientes |
| 04/10 | Reparto A: raíz 100, MySQL 64 y compartido 224 GiB | Separar consumos y mantener reserva de crecimiento; ejecutado |
| 04/10 | MySQL 8.4 LTS mediante repositorio oficial auditado | Compatibilidad de Qontrolmed; no instalar por defecto la rama 8.0 propuesta por Ubuntu |
| 04/10 | Aplazar firmware/Secure Boot | Placa sin identificar, claves UEFI de pruebas y recuperación no preparada |
| 01/11 | Reserva DHCP doméstica `.31` y MySQL deshabilitado | Evitar confusión de IP y arranque automático con exposición por defecto |
| 05/11 | Piloto de un puesto y datos ficticios | Validar TLS, permisos y recuperación sin datos reales |
| 05/11 | Mantener ID manuales en `marcas` | Son identificadores históricos importados; corregir transmisión del ID, sin renumerar |
| 05/11 | Aprobar planes por alcance completo | Incluye pasos, pruebas, documentación y reversión; ampliar alcance requiere nueva aprobación |
| 05/11 | Preparar documentos, administración y recuperación antes del traslado | Prioridad documentada; plan técnico ejecutable aún pendiente de concreción/aprobación [F9] |
| 05/11 | Posponer instalación habitual de Qontrolmed | Falta provisión de CA y aceptación; MySQL seguirá detenido en la primera entrega documental propuesta |
| 06/11 | Aceptar el bloque doméstico documental dentro de alcance ficticio | SFTPGo/restic validados sin datos reales; Cloudflare sigue inerte y producción continúa pendiente [F15] |

## 9. Pruebas y resultados

| Prueba | Resultado documentado | Límite |
| --- | --- | --- |
| Instalación, UEFI y desbloqueo LUKS | Arranques correctos y recuperación probada, 01/10 | No cubre recuperación tras corte eléctrico en sede |
| SSH por clave / rechazo de contraseña | Correcto en sesiones nuevas, 01–02/10 y 31/10 | Acceso externo no validado |
| Montajes y escritura de volúmenes | `mount -a`, verificación `fstab` y archivos de prueba correctos, 04/10; montajes tras reinicio 01/11 | Reserva y permisos finales requieren revalidación |
| SMART corto | Ambos discos sin errores, 04/10 | No sustituye copia ni ensayo largo |
| Reserva DHCP y reinicio | `.31` conservada, kernel nuevo, SSH/UFW correctos, 01/11 | Solo LAN doméstica |
| TLS MySQL positivo y negativo | Conexión con CA/identidad válida; rechazo sin TLS, con CA errónea y nombre incorrecto, 05/11 | Certificados del piloto |
| Privilegios de aplicación | Cuenta por IP limitada; operaciones fuera de alcance denegadas | No acredita cuentas productivas |
| DML y autenticación | Operaciones ficticias en Gestión, Quirófanos y Preventivos; autenticación correcta/incorrecta y sesión probadas | Servicios representativos, no todos los flujos visuales |
| Marcas | ID manual 1207: alta, consulta y modificación correctas | Corrección en copia aislada |
| Resiliencia | Reconexión antes de nueva operación, timeout real de lectura y cancelación de escritura propia con error explícito y sin duplicación observada | Timeout real de escritura y pérdidas físicas de red pendientes |
| Restauración inicial | Tres bases ficticias sencillas restauradas en destinos separados | Superada después por ensayo funcional; no es copia productiva |
| Restauración funcional R3 | 33 tablas funcionales: Gestión 13, Quirófanos 7, Preventivos 13; comparadas tablas, recuentos, columnas, índices y relaciones | No es comparación exhaustiva de contenido ni ensayo con datos reales [F7] |
| Suite de aplicación | 39/39 pruebas correctas con mysql-connector-python 9.7.0; ZIP de revisión coincidente | No acredita instalación RC ni aceptación del usuario [F8] |
| Interfaz | Propietario confirmó apertura de portada | Capturas automatizadas fallaron; revisión visual completa pendiente |
| WebClient documental | TOTP, descarga, sobrescritura, límite 50 MiB, cuota 250 MiB, credencial incorrecta y revocación/reactivación correctos | Cuenta y datos ficticios; renombrado/copia/borrado/enlaces se validaron como no disponibles en UI, sin llamada API forzada [F15] |
| `restic` local | Copia cifrada, `check`, restauración aislada, hashes de documentos y `SQLITE_INTEGRITY=ok` | Mismo servidor y disco físico; no es copia independiente, 3-2-1 ni recuperación integral [F15] |
| Segundo origen LAN no autorizado | Pendiente | Requiere otro equipo real para probar rechazo mientras el autorizado conecta |
| Cierre final tras restauración | MySQL `inactive/disabled`, proceso ausente, 3306/33060 cerrados, cero unidades fallidas | No se apagó Ubuntu; SSH seguía disponible [F7] |

La restauración R3 creó `piloto_mm_restore_func3_gestion`, `piloto_mm_restore_func3_quirofanos` y `piloto_mm_restore_func3_preventivos`, con 14, 8 y 14 tablas totales, respectivamente; cada una incluye una tabla auxiliar `prueba_conexion`. Se verificaron 10, 7 y 13 relaciones. Un intento previo R2 se detuvo por el tratamiento de un tabulador antes de crear destino; R3 corrigió la consulta y empleó rutas nuevas, conservando evidencia anterior [F7].

## 10. Guía de mantenimiento

Los siguientes procedimientos son una guía propuesta para la persona autorizada. Frecuencias, responsables y ventanas deben acordarse con el cliente. Las consultas permiten comprobar el estado; las acciones de cambio requieren plan con propósito, riesgo, aceptación y reversión.

### 10.1. Comprobación rutinaria de solo lectura

Entrar mediante el perfil SSH autorizado y contrastar la clave de host. La dirección doméstica de esta edición no sirve como dirección definitiva de sede. Ejecutar en Ubuntu:

```bash
hostnamectl
timedatectl
uptime
systemctl --failed
systemctl is-active ssh.socket ufw
systemctl is-active mysql
systemctl is-enabled mysql
ip -br address
ip route
df -hT
findmnt /var/lib/mysql
findmnt /srv/compartido
ss -lnt
test -e /var/run/reboot-required && echo REINICIO_PENDIENTE
```

En el estado actual se espera MySQL `inactive` y `disabled`, ningún listener 3306/33060, montajes presentes y ninguna unidad fallida. Las consultas `is-active`/`is-enabled` pueden devolver código distinto de cero precisamente por estar MySQL detenido/deshabilitado; se debe interpretar su texto. La ausencia del archivo de reinicio no acredita por sí sola que el sistema esté actualizado.

Comprobaciones con privilegios, introduciendo la contraseña solo en la consola local cuando se solicite:

```bash
sudo ufw status verbose
sudo sshd -T
sudo pvs
sudo vgs
sudo lvs
sudo smartctl -H -A -l selftest /dev/sda
sudo smartctl -H -A -l selftest /dev/sdb
sudo journalctl -p err -b --no-pager
dpkg --audit
apt list --upgradable
```

Contrastar inventario de discos antes de consultas que dependan de su nombre. La lista APT usa los índices locales: su fecha determina el valor de la comprobación. Los registros pueden contener información personal o sensible; revisar y depurar antes de compartirlos. No volcar variables de entorno, configuraciones privadas ni historiales completos al documento.

### 10.2. Rutina propuesta

| Frecuencia propuesta | Actividad | Evidencia de aceptación |
| --- | --- | --- |
| Diaria, cuando haya producción | Revisar disponibilidad, espacio, alertas y resultado de copias | Estado registrado, incidencias asignadas y copias dentro del objetivo acordado |
| Semanal | Revisar errores, intentos de acceso, SMART y actualizaciones disponibles | Sin fallos nuevos sin tratar; cambios planificados |
| Mensual | Revisar cuentas, permisos, firewall, acceso remoto, vencimientos y restauración de muestra | Acta breve con fecha, resultado, responsable y pendientes |
| Tras cada cambio o reinicio | Validar identidad, red, SSH, montajes, puertos y servicios previstos | Comparación contra estado aprobado y pruebas desde un cliente |
| Antes de vencimientos | Renovar certificados e identidades bajo plan | Certificado nuevo verificado en cliente y procedimiento de reversión probado |

### 10.3. Actualización del sistema

1. Revisar incidencias y compatibilidad de Ubuntu, MySQL y aplicaciones; no actualizar de distribución ni cambiar rama MySQL implícitamente.
2. Asegurar copia recuperable y acceso de consola, especialmente por LUKS.
3. Documentar paquetes previstos, ventana, riesgo y reversión; obtener aprobación del plan.
4. Actualizar índices y simular la operación dentro del plan; si aparecen retiradas o cambios no contemplados, revisar alcance antes de aplicar.
5. Ejecutar el cambio y comprobar APT/dpkg, servicios y necesidad de reinicio.
6. Si el reinicio está incluido y procede, verificar antes quién desbloqueará LUKS; comprobar después montajes, red, acceso y puertos.
7. Registrar resultado y nueva versión en esta guía. Si falla aceptación, aplicar la recuperación prevista.

La política de actualizaciones automáticas, avisos y reinicios todavía necesita decisión operativa; no darla por definida por el hecho de existir `unattended-upgrades`.

### 10.4. Reinicio, apagado y cambios de red

Antes de un reinicio o apagado: acordar la interrupción, comprobar que no hay copias ni transacciones activas y confirmar disponibilidad de recuperación LUKS. No se ha acreditado recuperación remota autónoma desde arranque en frío.

Para un apagado local controlado, iniciar sesión en la consola con el usuario
administrativo y ejecutar:

```bash
sudo systemctl poweroff
```

La contraseña se introduce solo en la consola y nunca se copia a documentación
o evidencias. Esperar al apagado físico y verificar desde el puesto de
administración que SSH deja de responder. Este procedimiento fue ejecutado y
comprobado el 13/11/2026.

Antes de cambiar firewall o red: mantener una sesión de recuperación, guardar la configuración y validar una **conexión nueva** desde el origen autorizado antes de retirar la regla anterior. Una sesión ya abierta no demuestra que el acceso nuevo funcione. No restaurar una copia antigua de UFW sin revisar qué subred habilita.

No iniciar MySQL para una consulta rutinaria. Una futura ventana de prueba debe limitar escucha y origen, definir tiempo máximo y cerrar cuentas, regla temporal y servicio al terminar. El arranque permanente requiere aceptación específica de la fase productiva.

## 11. Copias, recuperación e incidencias

### 11.1. Copias disponibles y límites

Hay copias lógicas ficticias y restauraciones verificadas del piloto. Las de R3 permanecen en el servidor bajo `/root/srv-mm-piloto-20261105/restauracion-funcional-r3`, con hashes registrados y acceso restringido. Estar en el mismo servidor no las convierte en copia externa ni independiente [F7].

El 06/11 se añadió un ensayo `restic` cifrado bajo `/root/srv-mm-preparacion-20261106/restic-ensayo`. Copió documentos ficticios y configuración consistente de SFTPGo con el servicio detenido, superó `restic check`, restauró 245,364 MiB en una ruta nueva y confirmó hashes documentales y `SQLITE_INTEGRITY=ok`. El snapshot `ad68b9ac` sigue siendo local al mismo servidor/disco y no cambia la ausencia de 3-2-1 [F15].

No se acredita política 3-2-1 operativa, destino externo, cifrado de las copias, retención, automatización, alertas, responsable ni restauración completa del sistema. LUKS protege almacenamiento en reposo, pero no sustituye copias. El SSD de 1 TB conserva datos anteriores y no puede formatearse para copias sin orden explícita y plan de reversión.

Antes de producción se deben acordar pérdida máxima de datos admisible (RPO) y tiempo máximo de recuperación (RTO), destino independiente, custodia externa de recuperación, retención, control de acceso y ensayo documentado. La restauración debe realizarse en un destino nuevo y comparar estructura y datos adecuados al uso; no sobrescribir producción como prueba.

### 11.2. Recuperación y reversión documentadas

| Elemento conservado | Finalidad | Precaución |
| --- | --- | --- |
| `/root/srv-mm-change-20261002-01` | Respaldo y rollback del baseline de hora/SSH/UFW | Histórico: su rollback desactiva UFW; no usar como estado objetivo actual |
| `/root/srv-mm-storage-20261004-01/fstab.before` | `fstab` anterior a volúmenes de datos | Restaurarlo puede dejar fuera los montajes actuales |
| `/root/srv-mm-mysql-20261004-01` | Fuentes APT previas a repositorio MySQL | No restaura bases ni paquetes por sí solo |
| `/root/srv-mm-change-20261031-red` | Reglas UFW anteriores a cambio de LAN | Recupera la red doméstica obsoleta `192.168.2.0/24` |
| `/root/srv-mm-piloto-20261105` | Evidencias, configuración y artefactos restringidos del piloto | No copiar íntegramente a documentación: puede contener material privado |
| `/root/srv-mm-preparacion-20261106` | Repositorio `restic`, restauración aislada y secretos locales del ensayo documental | Mismo servidor; contiene material sensible y no es copia externa ni 3-2-1 [F15] |

Las rutas están documentadas históricamente; verificar presencia e integridad antes de depender de ellas. Una copia de configuración no es una copia del sistema ni de las bases de datos.

### 11.3. Actuación ante incidencias

- **Sin SSH:** contrastar alimentación, estado de arranque/LUKS y concesión DHCP desde consola o router autorizado; verificar MAC/clave de host y reglas antes de modificar. No aceptar otra máquina por coincidencia de IP.
- **Disco lleno o errores SMART:** preservar registros, detener nuevas cargas no esenciales y evaluar copia y sustitución; no borrar ni formatear para recuperar espacio sin diagnóstico y autorización.
- **Fallo TLS:** revisar hora, identidad, cadena, vencimiento y permisos; no desactivar TLS ni la verificación de identidad para sortearlo.
- **Sospecha de acceso indebido:** registrar fecha, síntomas y sistemas afectados, informar al responsable y aplicar aislamiento bajo el plan de incidentes que se acuerde. Preservar evidencia y evitar difundir registros sin depuración.
- **Fallo de actualización:** no encadenar cambios sin diagnóstico; aplicar la reversión prevista y registrar la desviación. No existe aún recuperación integral acreditada que permita prometer tiempos de vuelta al servicio.

Falta asignar responsable de incidencias, contacto alternativo y canal de aviso; sus datos se custodiarán de forma controlada, sin secretos en esta guía.

## 12. Pendientes y aceptación de entrega

Todos los responsables de validación quedan **por designar por el cliente**, salvo las decisiones históricas atribuidas al propietario. Las prioridades siguientes ordenan el trabajo; no conceden autorización para ejecutarlo.

| ID | Prioridad | Pendiente | Criterio de cierre |
| --- | --- | --- | --- |
| P01 | Antes de sede | Confirmar usuarios, volumen/crecimiento, disponibilidad, responsabilidades y alcance de datos | Ficha de requisitos validada por cliente |
| P02 | Antes de sede | Inventario físico final: placa, fuente, ubicación, cableado y recuperación | Inventario firmado/validado, con fecha |
| P03 | Antes de sede | Red definitiva: IP, DHCP, gateway, DNS, VLAN y administración | Configuración contrastada y conexión nueva probada in situ |
| P04 | Antes de sede | Arranque en frío, recuperación LUKS, energía y SAI | Ensayo documentado con persona/medio de recuperación disponible y sin pérdida de acceso |
| P05 | Antes de datos reales | Copias independientes y política 3-2-1, cifrado, retención, RPO/RTO | Restauración desde destino independiente y tiempos medidos |
| P06 | Antes de acceso externo | Dominio/cuenta/MFA/recuperación y despliegue SFTPGo/Cloudflare | Políticas, permisos y pruebas desde fuera, incluido rechazo no autorizado |
| P07 | Antes de sede | Simular solapamiento de redes y separar administración/documentos | Acceso probado desde redes coincidentes; diseño y reversión aprobados |
| P08 | Antes de entrega | Revalidar UFW completo, IPv6, SSH efectivo, actualizaciones, cuentas y permisos | Evidencia privilegiada fechada y sin exposición no autorizada |
| P09 | Antes de producción MySQL | CA/identidad de sede, cuentas mínimas, red y copia | TLS positivo/negativo, privilegios, restauración y cierre aceptados |
| P10 | Antes de instalar Qontrolmed | Resolver provisión de CA y pruebas del empaquetado | Instalación aislada reproducible, permisos de CA y suite correctos |
| P11 | Antes de aceptar Qontrolmed | Revisión visual de pantallas y flujos completos | Acta de aceptación del propietario/usuario |
| P12 | Antes de aceptar LAN MySQL | Probar segundo origen LAN no autorizado | Autorizado conecta, segundo equipo rechazado |
| P13 | Según aceptación de resiliencia | Timeout real de escritura y pérdidas físicas de red | Resultado explícito, sin repetición indebida, recuperación documentada |
| P14 | Antes de producción | Resolver o aceptar con justificación PAM, AppArmor y riesgo de Secure Boot/firmware | Diagnóstico actual, decisión responsable y recuperación prevista |
| P15 | Antes de entrega | Alertas SMART, espacio, servicios, copias y vencimientos; política de parches/reinicio | Aviso real recibido y procedimiento operativo validado |
| P16 | Antes de entrega | Normalizar `known_hosts` e identidades de mantenimiento | Host contrastado sin alias histórico y acceso/retirada de identidad probados |
| P17 | Antes de entrega | Custodia externa de documentación y recuperación | Copia accesible a responsable autorizado incluso si falla el servidor |

La primera entrega propuesta comprende documentos y administración, manteniendo MySQL/Qontrolmed fuera del servicio productivo. Para declararla operativa hay que cerrar sus dependencias de red, identidad, copias, energía y aceptación; no basta con instalar SFTPGo o un túnel. La fase MySQL/Qontrolmed requiere además sus pendientes específicos.

Los anteriores P18 y P19 se cerraron el 06/11: el bloque doméstico fue aprobado, ejecutado y aceptado con datos ficticios; sus servicios quedaron detenidos y la evidencia depurada se conserva en F15. Este cierre no resuelve P01–P17 ni autoriza producción.

Mientras se esperan P01–P07, puede continuarse con el bloque no intrusivo de F16: auditar en solo lectura la instalación existente y preparar localmente comprobaciones, plantillas y runbooks sin valores reales. Ese bloque permanece propuesto; no permite arrancar servicios, instalar o actualizar paquetes, cambiar configuración ni crear recursos externos. Cualquier mejora remota resultante deberá describirse en un plan técnico independiente y aprobarse antes de ejecutarla.

**Acta de entrega pendiente:** fecha efectiva, versión entregada, responsable del cliente, responsable de mantenimiento, servicios incluidos, pruebas aceptadas, excepciones con plazo, ubicación de copias y aprobación final. No se consignan firmas ni aceptación inexistentes.

## 13. Fuentes y trazabilidad

Fuentes internas revisadas para esta consolidación. Los enlaces conservan el detalle original; la guía es autosuficiente para conocer el estado, mientras los originales respaldan auditoría y diagnóstico. Algunas referencias antiguas dentro de esos originales pueden preceder a la reorganización de carpetas.

| Ref. | Fuente |
| --- | --- |
| F1 | [Instalación 01/10](00_seguimiento/estados/ESTADO-INSTALACION-2026-10-01.md) y [auditoría Linux inicial](05_evidencias/auditorias/auditoria-srv-mm-01-2026-10-01.txt) |
| F2 | [Configuración, actualizaciones y SMART 02/10](00_seguimiento/estados/ESTADO-INSTALACION-2026-10-02.md) |
| F3 | [Almacenamiento, SMART, firmware e instalación MySQL 04/10](00_seguimiento/estados/REVALIDACION-Y-PROPUESTAS-2026-10-04.md) |
| F4 | [Estado operativo y reserva DHCP 01/11](00_seguimiento/estados/ESTADO-OPERATIVO-SRV-MM-01-2026-11-01.md) |
| F5 | [Revalidación 05/11 y límites](00_seguimiento/estados/ESTADO-REVALIDACION-SRV-MM-01-2026-11-05.md) |
| F6 | [Cierre técnico del piloto](00_seguimiento/estados/CIERRE-TECNICO-PILOTO-DOMESTICO-2026-11-05.md) |
| F7 | [Restauración funcional completa](00_seguimiento/estados/ESTADO-RESTAURACION-FUNCIONAL-COMPLETA-2026-11-05.md) y [evidencia R3 y cierre independiente](05_evidencias/RESTAURACION-FUNCIONAL-COMPLETA-2026-11-05.txt) |
| F8 | [Revisión de código y bloqueo de empaquetado](00_seguimiento/estados/REVISION-CODIGO-Y-EMPAQUETADO-QONTROLMED-2026-11-05.md) |
| F9 | [Plan propuesto de preparación y puesta en sede](02_planes_y_arquitectura/PLAN-PREPARACION-PREVIA-Y-PUESTA-EN-SEDE-2026-11-05.md) |
| F10 | [Scripts conservados](06_herramientas/scripts), [baseline SSH](06_herramientas/configuracion/00-srv-mm-ssh-hardening.conf), [cambio local MySQL](02_planes_y_arquitectura/CAMBIO-01-PILOTO-MYSQL-LOCAL-2026-11-05.md) y [certificado del piloto](02_planes_y_arquitectura/CAMBIO-03-PILOTO-CERTIFICADO-2026-11-05.md) |
| F11 | [Cambio de red y SSH 31/10](00_seguimiento/estados/ESTADO-ACCESO-SSH-Y-RED-2026-10-31.md) |
| F12 | [Continuidad vigente](CONTINUAR-SIGUIENTE-SESION.md), [cuestionario de requisitos](01_gobierno_y_decisiones/cuestionario-descubrimiento-cliente.md) y [reglas del proyecto](AGENTS.md) |
| F13 | [Bloque doméstico sin datos del cliente](02_planes_y_arquitectura/PLAN-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md) y revalidación remota de solo lectura del 06/11 documentada en el diario |
| F14 | [Estado de pausa del bloque doméstico](00_seguimiento/estados/ESTADO-PAUSA-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md), [aplicación](05_evidencias/APLICACION-BLOQUE-DOMESTICO-2026-11-06.txt), [corrección ACL](05_evidencias/CORRECCION-ACL-SFTPGO-2026-11-06.txt) y [cierre](05_evidencias/CIERRE-BLOQUE-DOMESTICO-PAUSA-2026-11-06.txt) |
| F15 | [Aceptación final del bloque doméstico](00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md), [pruebas WebClient](05_evidencias/ACEPTACION-FUNCIONAL-WEBCLIENT-2026-11-06.txt), [restic y cierre técnico](05_evidencias/ACEPTACION-BLOQUE-DOMESTICO-2026-11-06.txt) y [manifiesto](05_evidencias/MANIFIESTO-BLOQUE-DOMESTICO-2026-11-06.txt) |
| F16 | [Plan posterior a la aceptación sin datos del cliente](02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md) y [runbook de inicio](03_operacion_y_runbooks/INICIAR-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md); propuesta documental, sin nueva conexión ni cambio del servidor |
| F17 | [Estado del incidente de arranque, vídeo y red](00_seguimiento/estados/ESTADO-INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12.md), [evidencia técnica](05_evidencias/INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12.txt) y [script reversible de `nomodeset`](06_herramientas/scripts/aplicar-nomodeset-consola-20261112.sh) |
| F18 | [Revalidación tras el incidente](05_evidencias/REVALIDACION-TRAS-INCIDENTE-CONSOLA-2026-11-13.txt), [diario de sesión](00_seguimiento/diario/2026-11-13-revalidacion-tras-incidente.md) y [runbook ejecutado](03_operacion_y_runbooks/REANUDAR-TRAS-INCIDENTE-CONSOLA-2026-11-13.md) |

Las comparativas y cuestionarios en la carpeta superior `Servidor_MM` aportan contexto de objetivos y alternativas. Sus menciones a Samba, Cockpit, Windows Server o virtualización no demuestran una instalación. La auditoría Windows archivada es una línea base anterior, no el estado de Ubuntu actual. No se ha importado al documento ningún secreto ni contenido de archivos privados.

## 14. Actualizaciones e historial de cambios

### Regla de continuidad

Actualizar siempre este archivo con la nueva información, sin generar otra guía competidora. Para cada cambio:

1. Registrar fecha del hecho, fuente, alcance y grado de confirmación. Lo comunicado se mantiene como tal hasta su verificación.
2. Corregir el apartado operativo y los pendientes afectados. Conservar en el historial el valor anterior cuando cambien configuración, decisión o resultado.
3. Distinguir propuesta, aprobación, ejecución y aceptación. Ninguna equivale automáticamente a la siguiente.
4. Incrementar versión y fecha de actualización; añadir fila al historial con motivo y referencia. No sobrescribir ni borrar entradas anteriores.
5. Conservar las evidencias originales. No incorporar contraseñas, frases secretas, claves privadas, tokens, archivos `.env` reales ni datos de pacientes.
6. Antes de una entrega formal, registrar aceptación y producir, si se solicita, una copia de esa versión. El maestro editable sigue siendo este archivo.

### Historial del documento

| Versión | Fecha | Cambio | Evidencia / validación |
| --- | --- | --- | --- |
| 1.7 | 2026-11-13 | Ventana P2C con MySQL 8.4.11 en loopback; detección segura del certificado automático sin SAN, selección TLS piloto temporal, validación del ledger y reversión completa. | Plan P2C coordinado; MySQL final `inactive/disabled`, puertos y drop-in ausentes. |
| 1.6 | 2026-11-13 | Reanudación desde apagado completo, revalidación remota de solo lectura, aclaración de IP reservada `.31`, cierre controlado y comando local `sudo systemctl poweroff`. | F18; `REVALIDACION_TRAS_INCIDENTE=OK`, TCP/22 cerrado después del apagado y agente SSH vacío. |
| 1.5 | 2026-11-12 | Incidente de gráfica, auditoría de arranque/red, retirada de NVIDIA y aceptación reversible de consola con `nomodeset` en dos arranques VGA y uno DisplayPort. | F17; consola, red, SSH, montajes y servicios validados; NVIDIA pendiente diagnóstico físico. |
| 1.4 | 2026-11-06 | Preparación del siguiente bloque posible sin datos del cliente: auditoría remota de solo lectura, revisión local y artefactos parametrizados. | F16; plan propuesto, sin conexión nueva ni cambio del servidor. |
| 1.3 | 2026-11-06 | Aceptación completa del bloque doméstico: WebClient, límites, autenticación, revocación/reversión, copia/restauración `restic`, corrección del script y cierre final. | F15; servicios detenidos, sin datos reales ni recursos Cloudflare, copia local no 3-2-1. |
| 1.2 | 2026-11-06 | Ejecución parcial del bloque doméstico: paquetes, bindings loopback, cuentas ficticias con TOTP, ACL mínima, creación de carpeta y primera carga; pausa segura con servicios detenidos. | F14; pendientes funcionales y `restic` conservados, sin datos reales ni recursos Cloudflare. |
| 1.1 | 2026-11-06 | Revalidación remota sin cambios; aclaración de activación SSH por socket; confirmación de ausencia de SFTPGo, `cloudflared`, `restic` y de la ruta documental; incorporación del bloque doméstico propuesto y sus límites. | F13; sin instalación ni cambios del servidor. Aprobación del bloque pendiente. |
| 1.0 | 2026-11-05 | Primera consolidación para entrega y mantenimiento: objetivo, inventario, instalación, red, servicios, comandos acreditados, decisiones, pruebas, recuperación y pendientes. Se recoge la restauración R3 posterior al cierre inicial y se separa preparación de producción. | Revisión documental F1–F12; sin nueva auditoría del servidor. Aceptación del cliente pendiente. |

### Hitos anteriores incorporados

| Fecha | Hito histórico |
| --- | --- |
| 2026-10-01 | Instalación Ubuntu, LUKS, recuperación y SSH por clave |
| 2026-10-02 | Baseline de seguridad, actualizaciones y SMART |
| 2026-10-04 | Volúmenes, autotests, repositorio e instalación MySQL; aplazamiento de firmware |
| 2026-10-31 | Cambio de LAN de preparación y reglas SSH |
| 2026-11-01 | Identificación correcta `.31`, reserva DHCP, MySQL deshabilitado y reinicio validado |
| 2026-11-05 | Piloto TLS/funcional, ID manuales, restauración completa ficticia, revisión de código y plan previo al traslado |
| 2026-11-06 | Instalación y aceptación doméstica SFTPGo/restic con datos ficticios; Cloudflare inerte y cierre seguro |
| 2026-11-12 | Incidente de gráfica y red; retirada de NVIDIA, auditoría y aceptación de consola VGA/DisplayPort con `nomodeset` reversible |

## Actualización P2G — 13/11/2026

Se ejecutó una ventana temporal autorizada para validar
`quirofanos-0002-certificados-equipos-medida` contra MySQL 8.4.11 con esquema,
cuenta y datos exclusivamente sintéticos. Tras la aceptación se retiraron los
objetos y TLS temporales. MySQL quedó `inactive/disabled`, sin 3306/33060;
SFTPGo `inactive/disabled` y Cloudflared `inactive/masked`. El servidor quedó
encendido por decisión del propietario. Detalle en
`02_planes_y_arquitectura/PLAN-VENTANA-P2G-CERTIFICADOS-MYSQL-SINTETICO-2026-11-13.md`.
