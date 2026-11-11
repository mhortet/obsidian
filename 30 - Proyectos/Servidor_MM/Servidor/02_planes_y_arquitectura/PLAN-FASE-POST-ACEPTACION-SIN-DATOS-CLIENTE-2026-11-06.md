---
title: "Fase posterior a la aceptación doméstica sin datos del cliente"
type: plan
status: proposed
created: 2026-11-06
updated: 2026-11-06
sources:
  - "../00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "PLAN-PREPARACION-PREVIA-Y-PUESTA-EN-SEDE-2026-11-05.md"
  - "../DOCUMENTACION-SERVIDOR-UBUNTU.md"
tags: [arquitectura, seguridad, administracion, testing]
review_after: 2026-11-13
---

# Plan propuesto: fase posterior a la aceptación doméstica sin datos del cliente

## 1. Decisión solicitada

Autorizar en una próxima sesión un bloque de **auditoría de solo lectura y preparación local de artefactos** que no depende de datos del cliente. Este plan no autoriza cambios en el servidor, instalaciones, arranque de SFTPGo/MySQL, recursos Cloudflare, DNS, red, LUKS, discos, usuarios reales ni copias externas.

El bloque debe terminar con una propuesta técnica concreta para los cambios que resulten necesarios. Esa propuesta posterior tendrá su propio propósito, riesgos, aceptación y reversión y requerirá aprobación explícita antes de modificar el servidor.

## 2. Propósito

Aprovechar el estado doméstico ya aceptado para cerrar la preparación técnica que puede realizarse sin inventar dominio, red, identidades, proveedor de copia o responsable local:

1. auditar la instalación y el endurecimiento real de SFTPGo sin arrancarla;
2. revisar permisos, rutas, logs, unidades y exposición esperada;
3. preparar comprobaciones de salud y unidades deshabilitadas como plantillas;
4. preparar el modelo de copia externa y restauración sin elegir proveedor ni crear secretos;
5. completar runbooks de operación, incidencias, mantenimiento y traslado;
6. convertir los datos ausentes del cliente en parámetros y puertas de decisión explícitas.

## 3. Línea base que debe preservarse

- SFTPGo `2.7.6-1`, `inactive/disabled`.
- `cloudflared 2026.10.7`, `inactive/masked`, sin recursos reales.
- MySQL `inactive/disabled`, sin proceso ni 3306/33060.
- Cero unidades fallidas y ausencia de listeners documentales.
- `/srv/compartido` con `root:root 0750`, `nosuid,nodev,noexec` y ACL `u:sftpgo:--x`.
- Cuenta ficticia `documental-piloto` en estado `Active` y cuentas ficticias con TOTP.
- Túnel local cerrado y agente SSH vacío.
- Copia `restic` local aceptada solo como ensayo, no como 3-2-1.

Si la revalidación difiere, se detendrá el trabajo dependiente y se documentará la desviación antes de proponer cambios.

## 4. Alcance

### 4.1. Auditoría remota de solo lectura

- Revalidar identidad, fecha, kernel, reinicio pendiente, unidades fallidas, montajes, espacio, procesos y escuchas.
- Confirmar estados activo/habilitado de SSH, UFW, MySQL, SFTPGo y `cloudflared`.
- Inventariar versiones, procedencia APT y actualizaciones candidatas sin ejecutar `apt upgrade`.
- Revisar `systemctl cat/show` de SFTPGo y `cloudflared`, incluidos drop-ins, dependencias, usuario de servicio, rutas de escritura y política de reinicio.
- Ejecutar `systemd-analyze verify` y `systemd-analyze security` contra las unidades existentes, interpretando falsos positivos y compatibilidad con SQLite.
- Revisar propietarios, modos y ACL de `/etc/sftpgo`, `/var/lib/sftpgo`, `/srv/compartido` y la hoja ficticia sin leer ni copiar secretos.
- Inventariar archivos estáticos de idiomas y confirmar que SFTPGo 2.7.6 no incorpora `es`; no instalar traducciones personalizadas.
- Revisar logs recientes de SFTPGo y sistema solo para errores técnicos, depurando usuarios, direcciones y datos antes de cualquier evidencia.
- Confirmar que el repositorio `restic` de ensayo y su contraseña permanecen restringidos a root, sin mostrar rutas secretas o contenido.

La auditoría no usará `sftpgo dumpdata`, copias de SQLite a la bóveda ni comandos que impriman hashes de contraseña, secretos TOTP, cookies, tokens o contraseñas.

### 4.2. Revisión local de artefactos existentes

- Comparar scripts y plantillas con el estado final aceptado y sus hashes.
- Revisar idempotencia, `set -Eeuo pipefail`, condiciones de error, cierre seguro y mensajes de aceptación.
- Incorporar una prueba para evitar regresiones del fallo corregido en `assert_mysql_safe`.
- Revisar que los scripts no inicien MySQL, no publiquen bindings y no registren secretos.
- Separar claramente artefactos de ensayo, producción y sede.

### 4.3. Artefactos nuevos preparados localmente

Se podrán crear y validar en la bóveda, pero **no transferir ni instalar** en el servidor dentro de este plan:

1. script de salud documental de solo lectura;
2. plantillas `systemd` de servicio/timer deshabilitadas para salud y futura copia;
3. plantilla de parámetros de copia externa sin proveedor ni credenciales;
4. matriz de retención, RPO/RTO y pruebas de restauración;
5. runbook de arranque/parada segura de SFTPGo;
6. runbook de alta, revocación y baja de usuarios sin secretos;
7. runbook de copia/restauración y custodia de claves;
8. checklist mensual de salud, permisos, espacio, logs y actualizaciones;
9. checklist de traslado y no abandono de sede;
10. registro de parámetros pendientes del cliente con estado `pendiente/confirmado/verificado`.

### 4.4. Diseño de integración futura

- Mantener separados plano documental y plano administrativo.
- Definir interfaces parametrizadas para dos túneles y políticas Access, sin UUID, hostname, cuenta o token reales.
- Definir qué valores se incorporarán cuando lleguen dominio, usuarios, red y copia externa.
- Preparar criterios de selección del destino de copia: residencia, cifrado, retención, coste, API, inmutabilidad, restauración y custodia.
- Preparar una simulación documental de `192.168.0.0/24`; no tocar interfaces, router, DHCP o Netplan.
- Registrar que la interfaz española se aplaza hasta una versión estable de SFTPGo que incluya `es`; no parchear los recursos de 2.7.6.

## 5. Entregables previstos

| Entregable | Resultado esperado |
| --- | --- |
| Estado de auditoría posterior a aceptación | Hallazgos confirmados, inferencias y pendientes separados |
| Registro de riesgos y brechas | Severidad, evidencia, mitigación propuesta y decisión necesaria |
| Script de salud local | Solo lectura, sin secretos, sintaxis y pruebas locales correctas |
| Plantillas `systemd` deshabilitadas | Verificadas, parametrizadas y no instaladas |
| Runbooks operativos | Inicio/parada, usuarios, copia/restauración, incidencias y mantenimiento |
| Matriz de integración del cliente | Parámetro, fuente, validación, consumidor y bloqueo asociado |
| Propuesta de siguiente cambio | Alcance exacto, aceptación y reversión para una aprobación posterior |

## 6. Pruebas de aceptación

El bloque documental/auditor se considerará completado si:

1. el servidor termina en la misma línea base de servicio, puertos, UFW, SSH, ACL y MySQL;
2. no se inicia SFTPGo, MySQL o `cloudflared`;
3. no se crea ni modifica ningún recurso externo;
4. no se extrae o documenta ningún secreto;
5. cada hallazgo conserva comando/fuente, fecha, impacto y grado de confianza;
6. los scripts nuevos pasan revisión de sintaxis, análisis estático y pruebas con fixtures locales;
7. las plantillas `systemd` pasan verificación sin instalarse;
8. los runbooks distinguen operación normal, incidente, reversión y decisiones del cliente;
9. el estado, diario, maestro y relevo quedan actualizados;
10. la identidad SSH se retira y se confirma ausencia de conexiones al cerrar.

## 7. Riesgos y mitigaciones

| Riesgo | Mitigación |
| --- | --- |
| Leer o archivar secretos de SQLite/configuración | Inventario y permisos, no contenidos; evidencia depurada; prohibido `dumpdata` |
| Confundir una plantilla con configuración aplicada | Sufijos `.example`, encabezado `NO INSTALADO` y registro explícito |
| Convertir hallazgos en cambios no autorizados | Detenerse en la propuesta; ningún `sudo` modificador |
| Duplicar runbooks o documento maestro | Actualizar piezas existentes y enlazarlas desde el maestro |
| Basarse en documentación de una versión distinta | Contrastar paquete 2.7.6, archivos instalados y documentación de esa versión |
| Falsa sensación de copia/monitorización operativa | Marcar plantillas como inactivas y copia actual como local no 3-2-1 |
| Simulación de red que afecte al puesto o servidor | Diseño documental únicamente; cualquier laboratorio real tendrá plan separado |

## 8. Exclusiones

- inicio de SFTPGo, MySQL/Qontrolmed o `cloudflared`;
- instalación, actualización o retirada de paquetes;
- cambios en unidades, drop-ins, ACL, propietarios, permisos o rutas del servidor;
- DNS, dominio, Cloudflare, túneles, Access, dispositivos o tokens reales;
- usuarios, correos, documentos o datos reales del cliente;
- proveedor/destino de copia real, temporizadores activos o declaración 3-2-1;
- red, UFW, SSH, router, DHCP, Netplan o simulación física de subred;
- LUKS, BIOS, SAI, apagado, reinicio o prueba de corte eléctrico;
- traducción personalizada de SFTPGo 2.7.6;
- instalación o ejecución de Qontrolmed.

## 9. Reversión

No se prevén cambios remotos. Si un artefacto local resulta incorrecto:

1. conservar la versión anterior y el diff;
2. retirar únicamente el archivo nuevo no aceptado;
3. restaurar enlaces del índice/relevo mediante parche;
4. registrar la causa y no transferir el artefacto;
5. revalidar que el servidor no cambió.

## 10. Puerta de decisión posterior

Al terminar, clasificar cada recomendación:

- **lista para aprobar sin datos del cliente**: endurecimiento o monitorización local que no dependa de valores reales;
- **requiere dato del cliente**: dominio, identidad, red, copia, recuperación o RPO/RTO;
- **requiere presencia/medio físico**: LUKS, BIOS, SAI, KVM, apagado o red de sede;
- **aplazada a Qontrolmed**: CA, instalador, MySQL y puestos autorizados.

No se ejecutará la primera categoría hasta presentar un plan técnico exacto y obtener una única aprobación.
