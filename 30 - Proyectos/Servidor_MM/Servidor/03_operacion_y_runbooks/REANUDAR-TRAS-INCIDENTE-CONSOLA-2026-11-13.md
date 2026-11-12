---
title: "Reanudar srv-mm-01 tras el incidente de consola"
type: process
status: active
created: 2026-11-12
updated: 2026-11-12
sources:
  - "../00_seguimiento/estados/ESTADO-INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12.md"
  - "../05_evidencias/INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12.txt"
  - "../CONTINUAR-SIGUIENTE-SESION.md"
  - "../../../Qontrolmed/01_gobierno_y_decisiones/CONTINUAR-SIGUIENTE-SESION.md"
tags: [documentacion, seguridad, administracion]
review_after: 2026-11-14
---

# Sesión preparada para el 13/11/2026

## Objetivo

Recuperar `srv-mm-01` desde apagado completo, demostrar que conserva el cierre seguro del incidente del 12/11 y dejar una línea base fechada. Solo después podrá continuarse con trabajo de auditoría de solo lectura y preparación local. Esta sesión no autoriza cambios nuevos en GRUB, BIOS/UEFI, hardware, discos, red, servicios ni paquetes.

## Situación de partida

- El servidor quedó apagado de forma controlada el 12/11/2026.
- La NVIDIA GA106 permanece físicamente retirada.
- `nomodeset` quedó aplicado de forma persistente y aceptado en tres arranques: dos por VGA y uno por DisplayPort.
- La copia de reversión de GRUB es `/etc/default/grub.pre-nomodeset-20261112T1325`.
- La última dirección doméstica observada fue `192.168.1.31`; es una referencia temporal, no una configuración garantizada.
- MySQL y SFTPGo quedaron `inactive/disabled`; `cloudflared`, `inactive/masked`.
- SSH y UFW quedaron activos, sin unidades fallidas y sin escuchas de aplicación.
- La identidad administrativa se retiró de `ssh-agent` al cerrar.
- Siguen separados de esta sesión el diagnóstico físico de la NVIDIA y la revisión de la partición FAT `sdb1`.

## Preparación antes de encender

1. Leer `AGENTS.md`, `CONTINUAR-SIGUIENTE-SESION.md` y el estado del incidente enlazado en el frontmatter.
2. Confirmar que la NVIDIA continúa retirada y que no hay componentes o cables sueltos. No reinstalarla ni cambiar BIOS/UEFI.
3. Conectar teclado y un monitor conocido. Para la comprobación principal puede usarse VGA, ya aceptado con `nomodeset`; DisplayPort queda como contingencia conocida.
4. Comprobar visualmente alimentación, cable de red y puerto del switch. El 3Com limita el enlace a 100 Mb/s; eso no es un fallo.
5. Tener disponible localmente la frase LUKS. No escribirla en el chat, comandos, notas ni evidencias.
6. En el puesto de administración, confirmar que FortiClient no altera la LAN y que `ssh-agent` está vacío.

## Puerta 1 — arranque físico controlado

1. Encender una sola vez y observar POST, GRUB, petición LUKS, mensajes de arranque y login.
2. Desbloquear LUKS localmente.
3. No editar GRUB ni usar opciones temporales si el arranque normal funciona.
4. Esperar a que aparezca el login y verificar que la consola sigue visible y responde al teclado.
5. Confirmar enlace físico de red. Si no aparece, revisar únicamente cable y puerto; no cambiar Netplan, UFW o direccionamiento.

Detener y apagar de forma controlada si reaparecen pitidos, olor, calor anormal, reinicios, errores de almacenamiento, ausencia de LUKS o pérdida de consola que impida operar con seguridad. Si la consola se pierde pero el sistema parece continuar, no forzar apagado: comprobar primero el estado por el canal seguro disponible.

## Puerta 2 — revalidación remota de solo lectura

1. Obtener la dirección únicamente desde DHCP/router o una comprobación dirigida a la identidad conocida; no explorar otros equipos de la red.
2. Verificar la clave de host estrictamente. No aceptar una clave nueva sin investigar la causa.
3. Cargar `id_ed25519_srv_mm` solo con intervención local del propietario y sin exponer su frase.
4. Recoger en una evidencia nueva, depurada y fechada:
   - hostname, fecha, zona horaria, versión de Ubuntu, kernel, boot ID y tiempo de actividad;
   - `/proc/cmdline`, presencia de `nomodeset` y framebuffer utilizado;
   - errores de prioridad alta del arranque actual y estado de unidades fallidas;
   - estado y habilitación de MySQL, SFTPGo y `cloudflared`;
   - estado de SSH y UFW;
   - listeners TCP/UDP, sin iniciar servicios;
   - interfaces, dirección, portadora y velocidad negociada;
   - montajes y espacio, sin montar ni reparar `sdb1`;
   - estado resumido de `smartd`, sin ejecutar pruebas destructivas o largas.
5. Confirmar específicamente:
   - `nomodeset` presente y consola operativa;
   - cero unidades fallidas;
   - MySQL y SFTPGo `inactive/disabled`;
   - `cloudflared` `inactive/masked`;
   - ningún puerto MySQL o de aplicación en escucha;
   - SSH/UFW activos;
   - montajes esperados disponibles.

## Decisión tras la revalidación

### Si todo coincide

Registrar `REVALIDACION_TRAS_INCIDENTE=OK` y elegir el bloque sin mezclar estados:

1. **Qontrolmed, prioridad funcional:** abrir `../../../Qontrolmed/01_gobierno_y_decisiones/CONTINUAR-SIGUIENTE-SESION.md`, creado el 10/11 y actualizado el 11/11; revalidar `codex/produccion-readiness`, diff y las 44 pruebas antes de editar. Continuar el siguiente bloque local proporcional al piloto privado. No construir RC, usar datos reales ni tocar MySQL real.
2. **Plataforma del servidor:** continuar únicamente con las partes locales y de solo lectura de `03_operacion_y_runbooks/INICIAR-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md`.

Retirar la identidad SSH en cuanto deje de ser necesaria, incluso si la sesión continúa con trabajo local de Qontrolmed.

El plan posterior a la aceptación sigue propuesto, no aprobado para cambios remotos. Un hallazgo que requiera modificar el servidor se convertirá en un plan técnico separado con propósito, riesgo, aceptación y reversión.

### Si hay diferencias

Registrar el hecho y detener el trabajo dependiente. No arrancar servicios, no reparar automáticamente y no normalizar el estado sin identificar antes la causa. Tendrán prioridad de investigación:

1. errores de almacenamiento, LUKS o montajes;
2. unidades fallidas o reinicios inesperados;
3. servicios o puertos de aplicación activos;
4. ausencia de `nomodeset` o regresión de consola;
5. cambio de clave SSH;
6. red inestable que no se explique por cable/puerto.

## Cierre obligatorio

1. Repetir estados de servicios, unidades fallidas y listeners.
2. Confirmar si el servidor queda encendido o apagarlo de forma controlada por decisión del propietario.
3. Cerrar SSH y retirar la identidad del agente.
4. Actualizar evidencia, diario, estado del incidente si cambia, documento maestro y relevo.
5. Separar hechos, inferencias, recomendaciones y pendientes; no declarar resuelto un asunto físico no probado.

## Criterio de éxito

- Arranque normal desde apagado completo sin intervención excepcional en GRUB.
- Consola local visible desde firmware/LUKS hasta login.
- Línea base remota coincidente con el cierre seguro del 12/11.
- Ningún servicio de aplicación iniciado ni archivo remoto modificado.
- Evidencia fechada y sesión cerrada sin secretos ni datos personales.

## Prompt de arranque

> Retomamos `srv-mm-01` el 13/11/2026 con el servidor apagado. Lee `AGENTS.md`, `CONTINUAR-SIGUIENTE-SESION.md` y `03_operacion_y_runbooks/REANUDAR-TRAS-INCIDENTE-CONSOLA-2026-11-13.md`. Empieza por el arranque físico controlado y la revalidación de solo lectura. No reinstales la NVIDIA, no cambies GRUB/BIOS/red/discos/servicios/paquetes y no arranques MySQL, SFTPGo ni cloudflared. Si la línea base coincide, abre el relevo Qontrolmed creado el 10/11 y actualizado el 11/11, revalida `codex/produccion-readiness`, diff y pruebas, y continúa solo trabajo local autorizado; si el servidor difiere, conserva evidencia y detente antes de corregir.
