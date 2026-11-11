---
title: "Preparación de Qontrolmed y fase local del piloto"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../02_planes_y_arquitectura/PLAN-CONJUNTO-CIERRE-PILOTO-DOMESTICO-2026-11-05.md"
tags: [mysql, seguridad, documentacion]
review_after: 2026-11-12
---

# Preparación del plan conjunto

Plan completo aprobado por el propietario, usando este ordenador para las pruebas. No volver a pedir autorización por sus fases incluidas. Otro equipo solo sería necesario para comprobar activamente desde un origen no autorizado el rechazo de UFW; su ausencia debe registrarse como limitación.

## Qontrolmed aislado

Worktree C:\Users\Maxi\Documents\Codex\2026-11-05\u\work\qontrolmed-piloto; rama pilot/mysql-tls-20261105, base 014bf7c. Los cambios documentales existentes en D:\trabajo\Proyectos\maxgesth se conservan y no se copian ni se sobrescriben.

Modificados src/compartido/configuracion.py y .env.example; añadido tests/test_db_tls.py. TLS obligatorio por defecto con CA e identidad verificadas, TLS 1.2/1.3, timeouts configurables finitos y LOCAL INFILE desactivado. Excepción sin TLS solo mediante opción explícita y dirección IP loopback. No se ha cambiado la instalación actual de Qontrolmed ni se han leído archivos .env reales. Pendientes las pruebas de integración y desconexión; no declarar completada toda la adaptación.

Entorno Python aislado C:\Users\Maxi\Documents\Codex\2026-11-05\u\work\venv-piloto con mysql-connector-python 9.7.0 y python-dotenv 1.2.2, versiones del proyecto. El conector del Python habitual es 8.4.0 y no se modificó.

Pruebas realizadas con el entorno aislado: 8 pruebas de política TLS/validación/configuración, 6 de bootstrap SQL y 6 de rutas, todas correctas. Las pruebas unitarias no abren conexiones ni usan configuración real. No sustituyen prueba en servidor.

## Fase local del servidor preparada

06_herramientas/scripts/piloto-local-20261105.py, copiado a /home/vicente/piloto-local-20261105.py, sintaxis y hash comprobados. Crea exclusivamente tres esquemas piloto y una cuenta local limitada con credencial aleatoria que permanece en /root/srv-mm-piloto-20261105/prueba-local/client.cnf (0600), nunca en chat o repositorio. Si ya existen destinos, aborta sin sobrescribirlos.

Arranca manualmente MySQL, verifica certificado configurado, prueba sesión TCP cifrada con identidad, rechazo sin TLS y CA incorrecta, permisos limitados y DML ficticio. Crea copias lógicas privadas y las restaura en tres esquemas nuevos de ensayo, sin borrar esquemas. Al finalizar bloquea su cuenta y detiene MySQL; conserva datos ficticios y copias. No abre UFW ni escucha LAN todavía. Los secretos no se emiten en la salida pública.

Pendiente de ejecución por el propietario mediante sudo. Recoger /home/vicente/piloto-local-20261105.txt y comprobar parada final antes de avanzar a LAN. El script puede dejar objetos propios parciales si falla: se conservan para diagnosticar, no se ejecuta borrado ni repetición automática.

## Revisión de SQL existente

Los archivos de bd/base incluyen DROP TABLE IF EXISTS. No se han ejecutado ni se importarán indiscriminadamente. La primera fase usa una tabla ficticia prueba_conexion en cada esquema; no representa todavía el esquema funcional completo de Qontrolmed. Se revisará y extraerá solo estructura necesaria para la fase de aplicación, sin datos empresariales ni DROP de objetos existentes.
