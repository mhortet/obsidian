# Estado de instalación de `srv-mm-01`

Fecha: 2026-10-01 (Europe/Madrid)

## Resultado alcanzado

- Instalación limpia completada con Ubuntu Server 24.04.5 LTS, sin entorno gráfico.
- Hostname: `srv-mm-01`.
- Cuenta administradora inicial: `vicente`; no se registran contraseñas en este proyecto.
- OpenSSH instalado. El puerto 22 responde en la red local de preparación.
- Se creó en el ordenador administrador una clave ED25519 específica, protegida con frase, y se instaló únicamente su parte pública para `vicente`.
- Se validó una sesión nueva mediante clave (`whoami` devolvió `vicente`) y se desactivaron la autenticación SSH por contraseña, la autenticación interactiva y el acceso directo de `root`.
- Ubuntu Pro no se vinculó y no se seleccionaron *snaps* adicionales.
- Arranque UEFI y desbloqueo del almacenamiento cifrado comprobados.

## Almacenamiento aplicado

- Disco del sistema: Samsung SSD 860 PRO 512 GB, observado en Linux como `/dev/sda`.
- Particiones del sistema:
  - `/dev/sda1`: FAT32, montada en `/boot/efi`.
  - `/dev/sda2`: ext4, montada en `/boot`.
  - `/dev/sda3`: LUKS2 con LVM en su interior.
- Volumen raíz: ext4 de aproximadamente 100 GB.
- El grupo LVM cifrado conserva aproximadamente 373,9 GB sin asignar para diseñar después volúmenes separados de MySQL y archivos compartidos.
- El Samsung SSD 860 PRO 1 TB aparece como `/dev/sdb` con sus particiones anteriores y no se modificó durante la instalación. No reutilizarlo para copias hasta aprobar y documentar expresamente su borrado y nuevo formato.

## Cifrado y recuperación

- Se activó LUKS para el grupo LVM.
- El instalador generó una clave de recuperación. Se comprobó que desbloquea el disco; su valor no se registró en el proyecto.
- La frase introducida inicialmente no desbloqueó el primer arranque.
- Se arrancó mediante la clave de recuperación, se añadió una nueva frase con `cryptsetup luksAddKey` y se validó con `cryptsetup open --test-passphrase` (resultado `0`).
- Se completó después un arranque correcto con la nueva frase.
- Tras confirmar la custodia externa, se eliminó `/var/log/installer/recovery-key.txt`; `test ! -e` devolvió `0`.
- No se han eliminado *keyslots*. Antes de retirar cualquier clave, verificar que existen al menos dos medios de recuperación funcionales y documentados fuera del servidor.

## Red de preparación

- Interfaz activa: `eno1`, Intel I219-LM.
- Dirección observada tras la instalación: `192.168.2.104`, asignada por DHCP.
- Esta dirección y esta red son temporales y no deben trasladarse a la sede del cliente.
- El 2026-10-01 se comprobó desde el ordenador administrador que TCP/22 responde en la LAN.
- No se ha autorizado ni configurado publicación de SSH, SMB, MySQL u otros servicios en Internet.

## Pendientes antes de instalar servicios o introducir datos

1. Aprobar y aplicar las actualizaciones pendientes. La auditoría inicial enumeró 15 paquetes; no se autorizó una actualización de versión a Ubuntu 26.04.1 LTS.
2. Activar un firewall local con reglas mínimas y probar una conexión nueva antes de cerrar la sesión de recuperación.
3. Ajustar la zona horaria de `Etc/UTC` a `Europe/Madrid`, manteniendo sincronización NTP y RTC en UTC.
4. Diagnosticar el aviso de PAM sobre `pam_lastlog.so`; no modificar PAM sin identificar antes paquete, ruta y configuración implicados.
5. Instalar o habilitar una herramienta soportada para revisar SMART; la auditoría no incluyó datos SMART porque la instalación base no aporta `smartctl`.
6. Diseñar los volúmenes LVM para MySQL y archivos compartidos antes de consumir el espacio libre.
7. Mantener intacto el SSD de 1 TB hasta aprobar su reutilización como destino local de copias.
8. Definir y probar copias 3-2-1, restauración, RPO/RTO, SAI, monitorización y respuesta a incidentes antes de producción.
9. Configurar la red definitiva únicamente en la sede del cliente, después de inventariar su infraestructura.

## Autorización, riesgo y reversión

- El propietario autorizó expresamente borrar el SSD Samsung de 512 GB y mantener intacto el SSD Samsung de 1 TB.
- Riesgo asumido: pérdida del contenido previo del SSD de 512 GB y sustitución del sistema instalado en ese disco.
- Prueba de aceptación realizada: instalación finalizada, desbloqueo LUKS, inicio de sesión local, estructura de discos revisada, arranque repetido, acceso SSH mediante clave y rechazo explícito de la autenticación por contraseña (`Permission denied (publickey)`).
- Reversión disponible: reinstalar el sistema y restaurar desde copias verificadas. No consta una imagen recuperable del Windows anterior.

## Evidencia local

Las fotografías `WhatsApp Image 2026-10-01 at *.jpeg` de esta carpeta documentan las pantallas de instalación. Deben tratarse como evidencia operativa; no contienen la frase LUKS ni la clave de recuperación.

La auditoría Linux inicial está conservada en `auditoria-srv-mm-01-2026-10-01.txt` con SHA-256 `C1F3B1ADB9568E45197DCAECDE65D8444985538F58278C555CE1B9FFDD26CDE3`. Hallazgos principales: NTP activo, zona horaria UTC, UFW inactivo, ningún servicio fallido, AppArmor cargado, 15 paquetes actualizables, solo SSH escuchando externamente y dos avisos de arranque que deben revisarse (`SGX disabled by BIOS` y carga fallida de `pam_lastlog.so`).
