---
title: "Fase local completada y prueba LAN preparada"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../05_evidencias/PILOTO-LOCAL-COMPLETADO-2026-11-05.txt"
tags: [mysql, seguridad, auditoria]
review_after: 2026-11-12
---

# Fase local completada — 2026-11-05

Continuación ejecutada a las 11:55 Europe/Madrid, resultado PILOTO_LOCAL_COMPLETADO. Sesión TCP con CA e identidad verificadas y TLS_AES_128_GCM_SHA256; sin TLS rechazado con 1045 tras conectar correctamente con la misma cuenta y credencial. Esto demuestra REQUIRE SSL de la cuenta; require_secure_transport=1 se comprobó por consulta en ejecución, sin aislar experimentalmente la política global. CA incorrecta rechazada con 2026. Acceso fuera de alcance denegado. Copia y restauración de los tres esquemas ficticios verificadas en destinos separados.

Cuenta local bloqueada al finalizar; MySQL inactive/disabled, sin proceso ni escucha 3306/33060 y sin unidades fallidas, revalidado por SSH. Se conservan esquemas y restauraciones ficticios. No se han abierto todavía reglas LAN.

## Preparación LAN incluida en el plan autorizado

IP del puesto confirmada por Windows y SSH_CONNECTION: 192.168.1.107. No consta reserva DHCP; revalidar antes de cada ventana. Script 06_herramientas/scripts/piloto-lan-20261105.py, copiado al servidor con sintaxis y hash comprobados. Ejecutar desde esta sesión SSH pasando SSH_CONNECTION mediante sudo env para que el script pueda comprobar el origen.

Crea cuenta mm_piloto_pc@192.168.1.107 con REQUIRE SSL y DML solo en tres esquemas ficticios. Configuración temporal bind-address=127.0.0.1,192.168.1.31; UFW solo TCP/3306 en eno1 desde 192.168.1.107 a 192.168.1.31. No cambia SSH ni arranque automático. Espera como máximo 900 segundos o la marca /home/vicente/piloto-runtime-20261105/FINALIZAR. La ventana requiere mantener la sesión abierta; al salir intenta bloquear cuenta, parar MySQL, retirar solo la regla propia y restaurar configuración local. Una interrupción no capturable o caída de alimentación exige revalidación manual, no se promete cierre infalible.

Exporta solo CA pública y configuración exclusiva de la cuenta piloto en /home/vicente/piloto-runtime-20261105, directorio vicente 0700 y .env 0600. No exporta claves privadas. Descargar esa configuración a un directorio Windows protegido fuera de repositorios y no mostrarla en herramientas/chat. No instalar la CA como confianza global. Cuenta bloqueada al cerrar la ventana; conservar credenciales protegidas para diagnóstico, nunca en el proyecto.

Cliente de pruebas preparado en work/probar-piloto-windows.py, copia documental en 06_herramientas/scripts. Usa el código real de conexiones Qontrolmed en el worktree aislado, configuración externa, DML sintético en tres módulos, reconexión de sesión cerrada, rechazo sin TLS e identidad incorrecta y timeout de lectura real. Pendiente ejecución contra la ventana LAN.

Qontrolmed: añadido código de recuperación acotada antes de una operación nueva, sin repetir escrituras; cierre de sesiones desconectadas. Cuatro pruebas nuevas superadas de reconexión limitada, no repetir escritura y cierre idempotente. Total acotado hasta ahora: 24 pruebas unitarias superadas. No confundirlas con flujos GUI, esquema funcional completo o prueba de caída física de red: aún pendientes.

Otro origen de red no está conectado: no afirmar prueba externa del rechazo a equipos no autorizados. La regla /32 se verificará, pero no sustituye esa prueba.
