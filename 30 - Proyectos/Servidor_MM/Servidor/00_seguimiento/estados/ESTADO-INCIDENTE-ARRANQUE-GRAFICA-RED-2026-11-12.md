---
title: "Estado del incidente de arranque, video y red de srv-mm-01"
type: register
status: needs-review
created: 2026-11-12
updated: 2026-11-12
sources:
  - "../../05_evidencias/INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12.txt"
tags: [seguridad, gobierno, documentacion]
review_after: 2026-11-19
---

# Estado del incidente de arranque, vídeo y red — 2026-11-12

## Resultado

`srv-mm-01` arranca, desbloquea LUKS, monta sus volúmenes y atiende apagados controlados. La pérdida de señal no equivale a un cuelgue del sistema: aparece al cargar `i915` sobre la Intel UHD 630 después de retirar la NVIDIA GA106. La consola del firmware funciona hasta LUKS, pero Linux no detecta ningún conector o modo válido para la conexión SVGA utilizada.

La ausencia inicial de SSH fue una incidencia separada de enlace físico. `eno1` permaneció sin portadora; después de manipular cable/puerto, el enlace osciló y obtuvo finalmente `192.168.1.31`. No se observó un fallo de Netplan, DHCP o UFW. El switch es un 3Com `3C16792B` limitado a 10/100BASE-TX, por lo que la negociación a 100 Mb/s full-duplex es la esperada.

En la primera fase, la reubicación y conexión directa por DisplayPort resolvieron operativamente la consola: después de LUKS permaneció visible la petición de login. La red volvió con la MAC esperada, respuesta ICMP y TCP/22 accesible. En ese momento aún no se había modificado GRUB ni aplicado `nomodeset`; la solución persistente se validó después, como se documenta a continuación.

El propietario fija un requisito adicional de entrega: la consola local no puede depender de que el cliente disponga de monitor DisplayPort. Un conmutador DisplayPort puede utilizarse provisionalmente en el banco de pruebas, pero no constituye por sí solo la solución final del cliente.

Posteriormente se ensayó un arranque temporal con VGA y `nomodeset`, sin modificar archivos. La consola permaneció visible desde GRUB y LUKS hasta el login, y la red/SSH quedaron disponibles. El resultado demuestra que el cambio mínimo candidato es añadir `nomodeset`; no se necesita fijar aún una resolución concreta de GRUB.

En el ensayo, GRUB mostró directamente su menú sin pulsar ninguna tecla. Debe revalidarse después de un arranque limpio: puede ser la configuración habitual o el comportamiento `recordfail` provocado por los intentos anteriores, por lo que todavía no se asume como garantía permanente de recuperación.

El propietario autorizó después el cambio persistente mínimo. Se añadió únicamente `nomodeset` a `GRUB_CMDLINE_LINUX_DEFAULT`, con copia de seguridad, precondición por hash, edición atómica, `update-grub`, validación sintáctica y reversión automática ante fallo. El primer reinicio limpio con VGA superó la aceptación: consola visible hasta login, `nomodeset` presente en `/proc/cmdline`, framebuffer `simpledrm`, red y SSH operativos, montajes correctos y cero unidades fallidas.

## Estado seguro confirmado

- Ubuntu 24.04.5 LTS, kernel `6.8.0-147-generic`.
- LUKS2/LVM y volúmenes operativos, con espacio disponible normal.
- Temperaturas y memoria normales; sin errores de hardware críticos en los registros revisados.
- `smartd` activo y ambos SSD reconocidos, sin avisos de fallo encontrados.
- MySQL y SFTPGo `inactive/disabled`; `cloudflared` `inactive/masked`.
- UFW y SSH activos; sin puertos MySQL o servicios de aplicación en escucha.
- Única unidad fallida: `systemd-networkd-wait-online`, coherente con la falta de portadora durante el arranque.
- La identidad administrativa fue retirada de `ssh-agent` al cerrar; el agente quedó vacío. Windows no permitió detener el servicio, que conserva inicio manual.

## Diagnóstico

### Vídeo

Hecho confirmado: `i915` registra `dotclock = 0`, advertencia DRM y `Cannot find any crtc or sizes`; durante las pruebas SVGA todos los conectores digitales aparecen desconectados y sin modos. El propietario confirma que esa pantalla VGA funcionaba antes de retirar la NVIDIA.

Inferencia de alta confianza: al retirar la NVIDIA cambia el dispositivo gráfico principal y, al sustituir el framebuffer del firmware por `i915`, Linux pierde la salida utilizada y el monitor informa de ausencia de señal. No se ha demostrado un fallo del monitor, CPU, RAM, almacenamiento ni del sistema operativo completo.

La NVIDIA retirada era antes el dispositivo `boot VGA` y `nouveau` proporcionaba el framebuffer principal. Los cuatro pitidos cesaron al retirarla, pero no se identifica su causa exacta sin el modelo físico de la placa y una prueba de hardware controlada.

### Red

Hecho confirmado: el enlace quedó estable a 100 Mb/s full duplex después de varias transiciones de portadora. El 3Com `3C16792B` solo ofrece 10/100BASE-TX, de modo que no se espera Gigabit en este tramo. Las transiciones coinciden con la manipulación física; no hay errores RX/TX ni evidencia actual de fallo del I219-LM.

## Estado aplicado y actuaciones separadas

1. Mantener el cambio persistente aplicado: `nomodeset` en `GRUB_CMDLINE_LINUX_DEFAULT`; copia de reversión `/etc/default/grub.pre-nomodeset-20261112T1325` y script conservado. No añadir resolución fija salvo nueva evidencia.
2. Aceptación completada: desde apagado completo se ven firmware, petición LUKS, mensajes posteriores y login; el teclado permite desbloqueo y apagado; después aparecen red y SSH. Se comprobaron tres arranques persistentes en total: dos con VGA y uno con DisplayPort.
3. Mantener un adaptador activo DisplayPort a HDMI/VGA solo como opción de contingencia, no como requisito principal, dado que `nomodeset` superó la aceptación.
4. Si se usa un KVM o conmutador provisional, debe probarse seleccionado antes de encender y comprobarse su comportamiento de EDID/HPD al cambiar de equipo. No asumir que todos mantienen el monitor presente para el sistema.
5. Mantener 100 Mb/s como comportamiento esperado mientras se use el 3Com `3C16792B`; evaluar un switch Gigabit solo como mejora de capacidad, no como reparación del incidente.
6. Identificar físicamente placa y gráfica retirada antes de interpretar pitidos, cambiar BIOS/UEFI o reinstalar la tarjeta.
7. Revisar la partición FAT `sdb1` del disco secundario en un plan separado; no ejecutar `fsck` ni montarla por este incidente.

## Aceptación completada

- Primer arranque limpio con VGA: superado, boot ID `c6d75bb5-2121-4b70-88c9-8206c0f4de01`.
- Segundo arranque con VGA: superado y confirmado visualmente por el propietario.
- Tercer arranque con DisplayPort: superado y confirmado visualmente por el propietario.
- Verificación remota final: `nomodeset` persistente, `simpledrm`, sin errores `dotclock`/DRM, apagado intermedio limpio, red `.31`, SSH/UFW activos, cero unidades fallidas y servicios de aplicación detenidos.

La aceptación de consola queda completada. Permanecen como asuntos separados el diagnóstico físico de la NVIDIA retirada, la identificación exacta de la placa y la advertencia FAT de `sdb1`.

## Evidencia

Véase [INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12](../../05_evidencias/INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12.txt).
