---
title: "Ventana P2G de certificados MySQL sintético"
type: plan
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "D:\\trabajo\\Proyectos\\maxgesth\\docs\\02_planes_y_arquitectura\\PLAN-EJECUCION-P2G-INTEGRACION-CERTIFICADOS-MYSQL-2026-11-13.md"
tags: [servidor, mysql, qontrolmed, p2g]
review_after: 2026-11-20
---

# Ventana P2G de certificados MySQL sintético

## Finalidad y destinos

Ventana temporal de infraestructura para validar `quirofanos-0002` en MySQL
8.4.11. Solo puede crear `qontrolmed_cert_v2_it_20261113`,
`qontrolmed_cert_v2_reader`@`localhost`, `/tmp/qontrolmed-p2g-20261113` y un
drop-in TLS temporal identificado y protegido por hash.

## Cambios permitidos

- revalidación de solo lectura de la línea base;
- inicio manual de MySQL, nunca habilitación al arranque;
- escucha exclusiva loopback, TLS obligatorio y X Plugin deshabilitado;
- esquema, cuenta, tablas, ledger, datos y copia exclusivamente sintéticos;
- uso temporal del certificado piloto preexistente, sin modificarlo;
- retirada completa y detención de MySQL al cerrar.

No se permiten cambios UFW, LAN, paquetes, red, CA, certificados, otros
esquemas, servicios ni datos reales. El servidor permanecerá encendido tras la
ventana salvo petición expresa.

## Precheck, aceptación y reversión

Se detendrá ante diferencias de identidad, montajes, unidades, listeners,
servicios u objetos temporales preexistentes. La aceptación exige prueba v1→v2,
mínimo privilegio, limpieza exacta, MySQL `inactive/disabled`, puertos cerrados
y servicios base sin cambios. La trampa de limpieza elimina solo los destinos
declarados y verifica el hash del drop-in antes de retirarlo.

## Autorización

Plan compatible con P2G de Qontrolmed. El propietario autorizó el bloque
completo el 13/11/2026 e informó que el servidor estaba en línea sin sesión
abierta.

## Resultado

Ventana completada. P2G validó la migración v2 y el ledger contra MySQL 8.4.11.
La limpieza retiró esquema, cuenta y TLS temporal; MySQL volvió a
`inactive/disabled`, sin puertos, y SFTPGo/Cloudflared conservaron su estado.
El servidor permaneció encendido según lo acordado.
