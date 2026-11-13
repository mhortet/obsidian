---
title: "Ventana de servidor P2C para ledger MySQL sintético"
type: plan
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "D:\\trabajo\\Proyectos\\maxgesth\\docs\\02_planes_y_arquitectura\\PLAN-EJECUCION-P2C-INTEGRACION-LEDGER-MYSQL-SINTETICO-2026-11-13.md"
  - "../DOCUMENTACION-SERVIDOR-UBUNTU.md"
  - "../03_operacion_y_runbooks/REANUDAR-TRAS-INCIDENTE-CONSOLA-2026-11-13.md"
tags: [servidor, mysql, qontrolmed, ledger, integracion]
review_after: 2026-11-20
---

# Ventana de servidor P2C para ledger MySQL sintético

## 1. Finalidad

Proporcionar una ventana contenida en `srv-mm-01` para ejecutar el plan P2C de
Qontrolmed contra MySQL Community Server 8.4.11 con datos exclusivamente
sintéticos. Este documento gobierna la parte de infraestructura; el contrato,
el SQL versionado y la interpretación de compatibilidad pertenecen a
Qontrolmed.

El plan está propuesto y no autoriza todavía encender el servidor ni iniciar
MySQL.

## 2. Estado inicial exigido

- servidor apagado tras `REVALIDACION_TRAS_INCIDENTE=OK` del 13/11/2026;
- NVIDIA retirada y `nomodeset` persistente, sin nuevos cambios de hardware;
- MySQL 8.4.11 `inactive/disabled`, sin 3306/33060;
- SFTPGo `inactive/disabled` y `cloudflared` `inactive/masked`;
- UFW y SSH activos, cero unidades fallidas y montajes esperados;
- IP doméstica reservada `192.168.1.31`; `.30` solo como alias histórico SSH;
- sin datos de cliente, secretos documentados ni servicios del piloto activos.

## 3. Cambios temporales permitidos

Dentro de una única ventana aprobada se permite:

1. arrancar y desbloquear LUKS localmente;
2. revalidar en solo lectura la línea base;
3. iniciar MySQL manualmente, sin habilitarlo al arranque;
4. confirmar escucha exclusiva `127.0.0.1:3306`, X Plugin deshabilitado,
   `require_secure_transport=ON` y TLS 1.2/1.3;
5. crear exclusivamente el esquema `qontrolmed_ledger_it_20261113`;
6. crear exclusivamente `qontrolmed_ledger_reader`@`localhost` con `SELECT`
   sobre la tabla temporal del ledger;
7. crear una copia lógica sin datos del esquema temporal, con permisos
   restringidos y SHA-256;
8. ejecutar los casos sintéticos definidos por el plan Qontrolmed;
9. retirar cuenta, esquema, credencial y copia temporales;
10. detener MySQL y devolver el servidor a su línea base segura.

No se permite cambiar UFW, bind LAN, Netplan, DNS, CA, paquetes, configuración
persistente, otros esquemas o servicios.

## 4. Prechecks y parada segura

Antes de iniciar MySQL se confirmarán identidad, hora, versión, boot ID,
unidades fallidas, espacio, montajes, servicio/habilitación, listeners y
configuración efectiva. Se comprobará por sesión administrativa local que el
esquema y la cuenta temporales no existen.

Detener la ventana sin corregir automáticamente si aparecen:

- clave SSH inesperada, errores LUKS/almacenamiento o montajes ausentes;
- MySQL activo, habilitado, actualizado o escuchando fuera de loopback;
- esquema o cuenta temporales preexistentes;
- contenido no sintético o cualquier servicio no previsto;
- imposibilidad de verificar la reversión.

## 5. Evidencia y secretos

La evidencia conservará comandos, versiones, estados, estructura, resultados
de aceptación/denegación y hashes, pero no contraseñas, claves privadas,
certificados privados, contenido de `mysql.user`, datos reales ni salidas que
permitan reconstruir credenciales.

La contraseña temporal se genera e introduce durante la ventana y se elimina
al cerrar. La identidad SSH se carga solo mientras sea necesaria.

## 6. Reversión y aceptación de infraestructura

La reversión consiste en eliminar exclusivamente la cuenta y el esquema
temporales después de validar sus nombres exactos y su contenido sintético,
retirar la copia temporal y detener MySQL. Si se ensaya restauración, se hará
solo sobre el mismo esquema temporal vacío y se retirará después.

La ventana se acepta cuando:

- la prueba P2C de Qontrolmed alcanza su puerta o registra un fallo seguro;
- no quedan cuenta, esquema, credencial ni copia temporales;
- MySQL vuelve a `inactive/disabled` y 3306/33060 están cerrados;
- SFTPGo y cloudflared conservan su estado seguro;
- cero unidades fallidas y montajes correctos;
- identidad SSH retirada y agente vacío;
- el servidor queda apagado con `sudo systemctl poweroff`, salvo decisión
  explícita de mantenerlo encendido para otro plan aprobado.

## 7. Coordinación y autorización

Este plan solo es ejecutable junto con
`PLAN-EJECUCION-P2C-INTEGRACION-LEDGER-MYSQL-SINTETICO-2026-11-13.md` de
Qontrolmed. La aprobación debe mencionar el bloque transversal P2C y cubre la
ventana completa, pruebas, evidencias, cierre y reversión descritos. Cualquier
necesidad de LAN MySQL, actualización, cambio persistente o uso de datos reales
queda fuera y requiere un plan nuevo.

## 8. Aprobación

El propietario aprobó expresamente el bloque transversal P2C el 13/11/2026.
La autorización cubre el arranque, prechecks, inicio manual contenido de MySQL,
pruebas sintéticas, evidencias, retirada completa, parada y apagado descritos.

## 9. Ampliación TLS temporal aprobada

Tras el fallo seguro del primer intento por ausencia de SAN en el certificado
automático presentado por MySQL, el inventario localizó los artefactos piloto
ya existentes bajo `/var/lib/mysql/piloto-tls/`. El propietario aprobó usar un
drop-in temporal y reversible para seleccionar esa CA, certificado y clave,
validar `VERIFY_IDENTITY` y retirarlo al cerrar.

La ampliación no autoriza regenerar certificados, copiar claves privadas,
degradar a `VERIFY_CA`, cambiar UFW/bind ni conservar el drop-in. La aplicación
y retirada deben verificar rutas, permisos, cadena, correspondencia de clave,
hash del archivo temporal, servicio detenido y puertos cerrados.

## 10. Resultado

La ventana terminó correctamente. El primer intento descubrió de forma segura
que el certificado automático de MySQL carecía de SAN; la limpieza retiró los
objetos temporales y detuvo el servicio. Tras la ampliación aprobada, MySQL usó
temporalmente el certificado piloto preexistente con SAN, P2C superó sus casos
y el drop-in se retiró con verificación de hash.

Estado final: MySQL `inactive/disabled`, sin proceso ni 3306/33060; drop-in y
estado temporal ausentes; SFTPGo `inactive/disabled`; cloudflared
`inactive/masked`; montaje correcto. No quedaron objetos temporales según el
cierre correcto del arnés.
