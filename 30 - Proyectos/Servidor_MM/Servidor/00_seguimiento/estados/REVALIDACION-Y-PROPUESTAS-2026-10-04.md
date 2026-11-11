# Revalidación y propuestas de `srv-mm-01` — 2026-10-04

Fecha de captura: 2026-10-04 16:44 CEST (`Europe/Madrid`)

## Alcance

Revalidación breve realizada por SSH mediante clave, con consultas de solo lectura. No se instalaron paquetes, no se actualizaron índices, no se montaron discos, no se inició ningún autotest SMART y no se modificaron UFW, LVM, PAM ni Secure Boot.

## Resultado de la revalidación

- Identidad y sistema: `srv-mm-01`, Ubuntu Server 24.04.5 LTS, kernel `6.8.0-146-generic`; tiempo encendido aproximado de 2 días y 5 horas.
- Red temporal: `eno1` activa con `192.168.2.104/24`, DHCP y ruta predeterminada por `192.168.2.1`. Sigue siendo una red de preparación y no debe trasladarse al cliente.
- Hora: `Europe/Madrid`, NTP activo y sincronizado, RTC en UTC.
- UFW: la unidad está activa. La política y las reglas detalladas no pudieron releerse porque `sudo -n` exigió contraseña; se conserva como última evidencia detallada válida la captura del 2026-10-02.
- Puertos: solo SSH TCP/22 escucha en todas las interfaces. Los demás sockets observados corresponden a resolución DNS local y al cliente DHCP.
- Actualizaciones: `apt list --upgradable` no enumeró paquetes actualizables usando los índices ya instalados. No se ejecutó `apt update`.
- Reinicio y servicios: no hay reinicio pendiente ni unidades `systemd` fallidas.
- SMART: `smartmontools.service` continúa habilitado y activo, monitorizando los dos SSD. El diario consultado desde el 2026-10-02 no muestra fallos SMART; recoge variaciones del atributo de temperatura.
- Almacenamiento: `/dev/sda` conserva Ubuntu sobre LUKS2 y LVM, con un LV raíz de 100 GB. `/dev/sdb` conserva sus particiones VFAT/NTFS anteriores, sigue sin montar y no recibió escrituras.
- LVM: no fue posible repetir `pvs`, `vgs` y `lvs` con privilegios porque `sudo -n` exigió contraseña. Por tanto, los 373,9 GB libres de `ubuntu-vg` siguen siendo la cifra documentada el 2026-10-02, no una medición privilegiada nueva.

La clave se descargó correctamente de `ssh-agent` al terminar. El servicio local `ssh-agent` quedó iniciado, con arranque manual y sin identidades, porque Windows denegó su parada.

## Propuesta de autotest SMART corto — no ejecutada

### Cambio propuesto

1. Confirmar que no hay otro autotest en curso y leer el tiempo recomendado por cada unidad:

   ```bash
   sudo smartctl -c /dev/sda
   sudo smartctl -c /dev/sdb
   ```

2. Iniciar el autotest corto interno de ambos SSD:

   ```bash
   sudo smartctl -t short /dev/sda
   sudo smartctl -t short /dev/sdb
   ```

3. Transcurrido el tiempo indicado por cada dispositivo, leer salud, atributos y registro:

   ```bash
   sudo smartctl -H -A -l selftest /dev/sda
   sudo smartctl -H -A -l selftest /dev/sdb
   ```

### Control del cambio

- Propósito: detectar fallos eléctricos o de lectura interna que no aparecen en la consulta pasiva y crear una línea base verificable.
- Riesgo: bajo, pero no nulo; puede añadir una carga breve de E/S y el propio firmware registra el resultado en el área SMART. No monta ni modifica sistemas de archivos ni datos de usuario.
- Condición especial de `/dev/sdb`: aunque no escribe datos de usuario, el autotest sí actualiza el registro SMART interno del SSD de 1 TB. Su ejecución requiere una autorización expresa que exceptúe únicamente esa escritura técnica.
- Prueba de aceptación: ambos registros deben mostrar el último autotest como `Completed without error`; la salud global debe continuar `PASSED` y no deben aparecer nuevos errores incorregibles, reasignaciones o errores CRC.
- Reversión: un autotest en curso puede abortarse con `sudo smartctl -X /dev/sdX`. Un resultado ya escrito en el registro SMART no se puede deshacer, aunque no altera los datos de usuario.
- Fuera de alcance: no se propone todavía el autotest largo ni cambios en la configuración de `smartd`.

## Alternativas de reparto de los 373,9 GB libres — no ejecutadas

Las cifras son de diseño y deberán ajustarse a extensiones físicas LVM cuando se autorice la ejecución. En ambos casos se proponen LVs normales, no thin provisioning, dentro del LUKS2 existente de `/dev/sda`; `/dev/sdb` queda totalmente fuera.

| Alternativa | MySQL | Archivos compartidos | Libre en `ubuntu-vg` | Reserva aproximada |
| --- | ---: | ---: | ---: | ---: |
| A. Conservadora y ampliable | 64 GB | 224 GB | 85,9 GB | 23,0 % |
| B. Capacidad inicial alta | 96 GB | 240 GB | 37,9 GB | 10,1 % |

### Alternativa A — recomendada mientras no exista una previsión de crecimiento

- Justificación: mantiene casi una cuarta parte del VG sin asignar para ampliar MySQL, los archivos o incluso la raíz según el uso real. Los tamaños iniciales son suficientes para una implantación pequeña si la base y los documentos actuales lo permiten.
- Ventaja: reduce el riesgo de asignar capacidad al destino equivocado. Ampliar un LV y un sistema de archivos `ext4` es una operación habitual; reducirlos es más delicado y normalmente exige parada.
- Riesgo: puede requerir una ampliación antes que la alternativa B si la carga inicial ya es elevada.

### Alternativa B — solo si las mediciones justifican mayor capacidad desde el inicio

- Justificación: concede 32 GB adicionales a MySQL y 16 GB adicionales a archivos para una carga inicial o crecimiento inmediato mayor.
- Ventaja: disminuye la probabilidad de una ampliación temprana.
- Riesgo: la reserva se reduce a alrededor del 10 %, con menos margen para crecimiento imprevisto, mantenimiento o instantáneas temporales. Una instantánea LVM no debe considerarse copia de seguridad.

### Diseño común propuesto

- Un LV dedicado para MySQL, previsto para `/var/lib/mysql`, y otro para archivos, previsto para `/srv/compartido`.
- `ext4` como opción conservadora para ambos volúmenes, pendiente de confirmar requisitos de la aplicación, permisos, cuotas y copias.
- La separación evita que los archivos compartidos consuman el espacio de MySQL o del sistema raíz.
- Antes de crear nada deben confirmarse: tamaño actual de la base, crecimiento previsto, volumen inicial de archivos, retención, cuotas, RPO/RTO y método de copia/restauración consistente de MySQL.

### Control del futuro cambio LVM

- Propósito: aislar datos, limitar el impacto de llenado y facilitar crecimiento, copias y administración.
- Riesgo: elegir tamaños, permisos o montajes incorrectos; una entrada errónea en `/etc/fstab` puede afectar al arranque. El formateo y una futura eliminación de LVs son destructivos para su contenido.
- Prueba de aceptación: validar `pvs/vgs/lvs`, UUID, `findmnt`, `df`, `mount -a`, permisos con cuentas no privilegiadas y arranque controlado; después, probar copia y restauración de MySQL antes de producción.
- Reversión: antes de migrar datos, desmontar, retirar las entradas de `fstab` y eliminar los LVs vacíos previa autorización. Después de almacenar datos, la reversión exige copia verificada y restauración; no debe basarse en reducir volúmenes.

## Decisión y ejecución de la opción A

El propietario seleccionó la alternativa A el 2026-10-04 como diseño de almacenamiento: 64 GB para MySQL, 224 GB para archivos compartidos y 85,9 GB de reserva. Esta selección no autoriza todavía `lvcreate`, `mkfs`, montajes ni cambios en `/etc/fstab`. Antes de ejecutar debe revalidarse el espacio libre del VG con privilegios y confirmarse el volumen inicial y el crecimiento esperado.

La revalidación privilegiada de LVM se completó posteriormente el 2026-10-04: el PV `/dev/mapper/dm_crypt-0` y `ubuntu-vg` miden 473,87 GB, existe únicamente `ubuntu-lv` de 100,00 GB y quedan 373,87 GB libres. La opción A cabe y dejaría 85,87 GB libres en el VG, sujeto al redondeo por extensiones de LVM.

Las precondiciones de montaje también se comprobaron: `/var/lib/mysql` y `/srv/compartido` no existen ni son puntos de montaje; no están instalados `mysql-server`, `mysql-community-server` ni `mariadb-server`; `/etc/fstab` solo contiene raíz, `/boot`, `/boot/efi` y swap; `fstrim.timer` está habilitado y activo.

Tras autorización expresa se crearon `mysql_data` de 64,00 GB y `shared_data` de 224,00 GB en `ubuntu-vg`. `ubuntu-lv` permanece en 100,00 GB y el VG conserva 85,87 GB libres. `lsblk -f` y `wipefs --no-act` confirmaron que los dos nuevos LVs no tienen sistema de archivos, UUID, firma previa ni punto de montaje. `/dev/sdb` no fue modificado.

Tras una segunda autorización expresa, ambos LVs se formatearon como `ext4` con 1 % de bloques reservados. `MYSQL_DATA` tiene UUID `cdbcfa54-5c45-4cc6-9b46-914b68a6ca2c` y `SHARED_DATA` UUID `cae9d953-19f8-44fd-86be-14b02e1ecd5c`. Las comprobaciones `e2fsck -fn` completaron las cinco fases sin errores.

Tras una tercera autorización, se crearon los puntos de montaje y se montaron temporalmente por UUID. `/var/lib/mysql` quedó `ext4` con `rw,nosuid,nodev`, unos 62 GB disponibles y permisos `root:root 0750`; `/srv/compartido` quedó `ext4` con `rw,nosuid,nodev,noexec`, unos 218 GB disponibles y permisos `root:root 0750`. Se crearon y eliminaron archivos temporales en ambos destinos y se verificó la postcondición `WRITE_TEST_OK`.

Tras una cuarta autorización se creó el respaldo `/root/srv-mm-storage-20261004-01/fstab.before`, idéntico al `fstab` anterior con SHA-256 `6e28eee4b1bb8c769918b250d4d16e2ee2eabbd7d03c635ab9987060b7bf52e7`. Se añadieron las dos entradas persistentes por UUID con las opciones anteriores. `findmnt --verify --verbose` devolvió 0 errores de sintaxis y 0 errores; después se recargó `systemd`.

La aceptación del montaje persistente se probó sin reiniciar: ambos destinos se desmontaron limpiamente, `mount -a` terminó sin mensajes de error y los volvió a montar desde los LVs previstos. `/var/lib/mysql` conserva `rw,nosuid,nodev` y unos 62 GB disponibles; `/srv/compartido` conserva `rw,nosuid,nodev,noexec` y unos 218 GB disponibles. Ambos directorios conservan propietario `root:root` y modo `0750`.

La comprobación final posterior al remontaje quedó superada: `findmnt --verify --verbose` devolvió `0 parse errors, 0 errors, 1 warning`; la única advertencia corresponde al archivo normal `/swap.img`. La huella SHA-256 del `fstab` definitivo es `febf646568dee762daa9f93a1f2123210f95301267fed45d9497cb365d654ec8`. Se crearon y eliminaron correctamente archivos de prueba en ambos volúmenes, con resultado `POST_FSTAB_WRITE_OK`, y `systemctl --failed` no enumeró unidades fallidas. Esta fase queda aceptada sin necesidad de reiniciar.

El propietario autorizó el autotest SMART corto de ambos SSD, incluida únicamente la escritura técnica de su resultado en el registro SMART interno de `/dev/sdb`. Ambos tests se ejecutaron y finalizaron correctamente el 2026-10-04:

- `/dev/sda`, Samsung SSD 860 PRO 512 GB: salud global `PASSED`; test corto `Completed without error`, 0 % restante y sin LBA de error. Temperatura 27 °C, 0 sectores reasignados, 0 bloques reservados usados, 0 errores de programa/borrado, 0 errores incorregibles y 0 errores CRC.
- `/dev/sdb`, Samsung SSD 860 PRO 1 TB: salud global `PASSED`; test corto `Completed without error`, 0 % restante y sin LBA de error. Temperatura 28 °C, 0 sectores reasignados, 0 bloques reservados usados, 0 errores de programa/borrado, 0 errores incorregibles y 0 errores CRC.

No se montaron ni modificaron las particiones o datos de `/dev/sdb`. Las operaciones LVM ejecutadas se limitaron a los dos LVs aprobados dentro de `ubuntu-vg` en `/dev/sda` cifrado.

## Preflight de MySQL

La inspección de solo lectura posterior confirmó Ubuntu 24.04 `noble` en arquitectura `amd64`. Los repositorios configurados son únicamente los oficiales de Ubuntu. Su candidato `mysql-server` es MySQL `8.0.46-0ubuntu0.24.04.4`; la simulación instalaría 28 paquetes nuevos y ninguna actualización o retirada, pero no se ejecutó porque la documentación de Qontrolmed establece como referencia probada MySQL 8.4.9 y pide permanecer en la rama 8.4 LTS.

El repositorio APT oficial de MySQL publica actualmente para Ubuntu 24.04 `noble` y `amd64` la revisión `8.4.11-1ubuntu24.04` de MySQL Community Server. Antes de incorporar un repositorio externo se propone descargar temporalmente su clave pública y metadatos `InRelease`, comprobar la huella oficial `BCA4 3417 C3B4 85DD 128E C6D4 B7B3 B788 A8D3 785C` y verificar la firma. El volumen `/var/lib/mysql` continúa vacío salvo por `lost+found`, con propietario `root:root` y modo `0700` para esa entrada.

La auditoría temporal fue autorizada y superada. La clave descargada tiene SHA-256 `a4bcd9f16a53cc763f87b9955dbcdced33c7aa90296b157eb6ceef0f156f4327` y la huella oficial esperada. El `InRelease`, con SHA-256 `87bd78469a27ecd7212d7a44f8b1ae495ced3c6c707e547c342a50888ad723e5`, produjo `Good signature from MySQL Release Engineering`; declara `Origin: MySQL`, `Codename: noble`, arquitecturas `i386 amd64` y el componente `mysql-8.4-lts`. Los archivos permanecen en `/tmp/srv-mm-mysql-repo-audit-20261004`.

Efecto secundario observado: `gpg --show-keys` creó automáticamente `/home/vicente/.gnupg`, su `pubring.kbx` y `trustdb.gpg`; la clave no se importó. Este directorio no se eliminará sin autorización y deberá revisarse antes de una limpieza exacta.

Tras autorización, se comprobó que el directorio solo contenía `pubring.kbx` y `trustdb.gpg`; se movió de forma reversible a `/tmp/srv-mm-mysql-repo-audit-20261004/gnupg-autocreated`, restaurando el estado anterior del perfil de `vicente`.

Se incorporó manualmente el repositorio con confianza limitada al keyring `/usr/share/keyrings/mysql-2025.gpg` y una fuente Deb822 en `/etc/apt/sources.list.d/mysql-8.4-lts.sources`, restringida a HTTPS, `noble`, `amd64` y `mysql-8.4-lts`. Ambos archivos son `root:root 0644`; sus SHA-256 son, respectivamente, `6fb0e1f8b46961fe3046771d4b60c2fed434201c8c0fdd1dd2d235b8b47a19eb` y `d0196a33250479bc27bb221286b81ca9000b89d5648290377897013d4a1c2495`.

La recuperación previa queda en `/root/srv-mm-mysql-20261004-01/`: `sources.list.before` y `sources.list.d.before.tar`, este último con `ubuntu.sources` y `ubuntu.sources.curtin.orig` y sin la fuente nueva. `apt-get update` terminó sin errores ni advertencias de firma.

El candidato resultante fue MySQL `8.4.11-1ubuntu24.04` desde el repositorio oficial. La simulación contempló 12 paquetes nuevos —ocho paquetes MySQL y cuatro dependencias MeCab—, sin actualizar ni retirar ninguno. En una fase posterior, y tras autorización expresa, se ejecutó la instalación descrita más adelante.

## Aviso de tres actualizaciones de dispositivos

La consulta de solo lectura `fwupdmgr get-updates --no-metadata-check` confirmó que el aviso no corresponde a paquetes de Ubuntu ni a firmware de los SSD. Los tres dispositivos son componentes de las bases de confianza de UEFI/Secure Boot:

1. `KEK CA`, versión 2011, con dos publicaciones candidatas 2023 —variantes AMI y ASUS—;
2. `UEFI CA`, versión 2011, con una actualización de la base de firmas 2023;
3. `UEFI dbx`, versión 20250902, con una lista de revocación 20260402.

Hallazgos relevantes:

- Secure Boot permanece deshabilitado.
- La clave de plataforma se identifica como `DO NOT TRUST - AMI Test PK` y `fwupd` la marca como insegura.
- Los datos DMI de sistema y placa son `Default string`, por lo que no permiten distinguir con seguridad la variante AMI de la ASUS.
- La BIOS se identifica como American Megatrends 5.13, de 2021-04-23.
- Los SSD Samsung 860 PRO aparecen expresamente entre los dispositivos sin actualizaciones disponibles.

### Decisión provisional sobre firmware

No aplicar estas actualizaciones mientras no se identifique físicamente el fabricante y modelo de la placa, se consulte la documentación del fabricante y exista presencia física con un medio de recuperación probado. La actualización de `dbx` añade revocaciones y solo admite modernizaciones; su reversión puede no ser posible.

- Propósito futuro: actualizar certificados y revocaciones de Secure Boot para retirar firmas antiguas o vulnerables.
- Riesgo: selección incorrecta de variante, pérdida de arranque, invalidación de medios de recuperación antiguos y ausencia de reversión fiable. El riesgo aumenta por la Platform Key de pruebas y los datos DMI incompletos.
- Prueba de aceptación: identificar placa y firmware soportado; disponer de consola física, clave de recuperación LUKS y medio UEFI probado; tras una actualización aprobada, reiniciar y verificar arranque, LUKS, Ubuntu, estado de Secure Boot y acceso SSH.
- Reversión: no debe presumirse posible para KEK, `db` o especialmente `dbx`. La recuperación dependería del procedimiento del fabricante, restauración de claves UEFI o recuperación física del arranque. Por ello se pospone.

## Instalación y contención inicial de MySQL 8.4

Tras autorización expresa se instaló MySQL Community Server `8.4.11-1ubuntu24.04` desde el repositorio oficial previamente auditado. La instalación añadió los ocho paquetes MySQL previstos y cuatro dependencias MeCab, sin retirar ni actualizar otros paquetes.

La advertencia del instalador sobre la existencia de `/var/lib/mysql` era esperable porque el punto de montaje dedicado ya estaba preparado. Antes de instalar se había comprobado que solo contenía el directorio vacío `lost+found`; este se retiró con autorización expresa. El directorio de datos quedó inicializado sobre `/dev/mapper/ubuntu--vg-mysql_data`, con `ext4`, opciones `rw,nosuid,nodev`, propietario `mysql:mysql`, modo `0750` y aproximadamente 62 GB disponibles.

El propietario dejó en blanco la contraseña de `root` durante la instalación para usar autenticación local por socket Unix. La validación posterior mostró:

- servidor `8.4.11` y `datadir=/var/lib/mysql/`;
- `root@localhost` con plugin `auth_socket`;
- las cuentas internas `mysql.infoschema`, `mysql.session` y `mysql.sys` bloqueadas;
- servicio instalado y habilitado;
- conexión local por socket correcta mediante `mysqladmin ping`.

No se crearon todavía bases de datos, usuarios de aplicación ni credenciales de Qontrolmed.

### Hallazgo de exposición de red y parada preventiva

La configuración inicial no contenía directivas `bind-address` ni `mysqlx-bind-address`. MySQL 8.4 aplicó sus valores predeterminados `*` y abrió:

- protocolo clásico en `*:3306`;
- MySQL X en `*:33060`.

UFW continuaba denegando toda entrada salvo SSH desde la LAN de preparación, pero se decidió no depender únicamente del cortafuegos. Se detuvo inmediatamente MySQL y se verificó `MYSQL_PORTS_CLOSED`.

Estado al cerrar esta documentación:

- `mysql.service`: `enabled` pero `inactive`;
- puertos 3306 y 33060: cerrados;
- configuración sin cambios locales de escucha;
- `/etc/mysql/mysql.cnf` incluye `/etc/mysql/conf.d/` y después `/etc/mysql/mysql.conf.d/`;
- `/etc/mysql/mysql.conf.d/mysqld.cnf` solo define PID, socket, `datadir` y log de error;
- `mysqld --verbose --help` confirma `bind-address=*` y `mysqlx-bind-address=*` mientras no se configure lo contrario.

Se propuso inicialmente limitar ambos protocolos a `127.0.0.1`, pero la autorización quedó sin efecto al aclararse que Qontrolmed se ejecuta en otro ordenador. No se creó copia de configuración, no se editó ningún archivo y no se reinició MySQL.

## Revisión documental de Qontrolmed

Se revisó en modo de solo lectura la documentación de `D:\trabajo\Proyectos\maxgesth`, sin abrir ni mostrar ningún `.env` real y sin modificar el repositorio.

Conclusiones documentales:

- Qontrolmed es una aplicación Windows de escritorio que usa `mysql-connector-python` y abre conexiones independientes a los esquemas `gestion`, `quirofanos` y `preventivos`.
- La plantilla define `DB_HOST=127.0.0.1`, `DB_PORT=3306` y `DB_USER=maxgesth_user`. Ese `127.0.0.1` corresponde al entorno validado anterior, donde MySQL residía en el mismo Windows; no sirve para conectar directamente con el nuevo servidor Ubuntu.
- La instalación RC sitúa el `.env` real en `C:\ProgramData\Qontrolmed\config\.env`; los usuarios normales pueden leerlo porque la aplicación necesita la credencial, pero no deben modificarlo.
- La guía exige una cuenta técnica MySQL de mínimo privilegio, limitada a los esquemas y al origen de red necesarios.
- La documentación no define parámetros TLS/CA para la conexión. Esta ausencia es una inferencia documental y debe confirmarse mediante revisión de solo lectura del código de conexión, sin leer el `.env` real.
- Qontrolmed documenta el protocolo clásico por 3306; no hay necesidad documental demostrada de MySQL X en 33060.

Fuentes principales revisadas:

- `D:\trabajo\Proyectos\maxgesth\.env.example`;
- `docs/guia_instalacion_rc_qontrolmed.md`;
- `docs/checklist_configuracion_preproduccion.md`;
- `docs/documentacion_integral_proyecto_entregable.md`;
- `docs/roles_operativos_acceso.md`;
- `docs/plan_seguridad_consistencia.md`;
- `docs/checklist_ejecucion_upgrade_mysql_8_4_lts.md`;
- `requirements.txt`, que fija `mysql-connector-python==9.7.0`.

### Decisión pendiente de arquitectura

No debe abrirse MySQL ni cambiarse su escucha hasta elegir y documentar una de estas alternativas:

1. **Conexión directa por LAN protegida**: IP o nombre estable del servidor en la red definitiva; escucha solo en loopback y en la interfaz LAN necesaria; UFW limitado a los equipos Qontrolmed autorizados; cuenta `maxgesth_user` restringida por origen y esquemas; TLS verificado; 33060 deshabilitado o cerrado.
2. **Túnel SSH persistente desde el ordenador Qontrolmed**: MySQL permanece en loopback y Qontrolmed conserva un destino local, sin exponer 3306 en la LAN. Requiere diseñar disponibilidad del túnel, custodia de la clave, arranque automático, monitorización y recuperación.

La dirección `192.168.2.104` es DHCP y pertenece a la red temporal de preparación. No debe fijarse como destino definitivo ni utilizarse para una regla permanente de producción.

## Punto seguro de cierre del 2026-10-04

- MySQL 8.4.11 está instalado, habilitado y detenido.
- No hay puertos MySQL escuchando.
- No existen usuarios ni esquemas de Qontrolmed en el servidor nuevo.
- No se aplicó ninguna regla UFW para MySQL.
- No se modificó la configuración de escucha.
- El SSD de 1 TB conserva sus datos y particiones; solo recibió la escritura técnica SMART autorizada.
- PAM y Secure Boot permanecen sin cambios.
- No se reinició el servidor.
