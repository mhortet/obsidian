---
title: "Plan P2G: integración de certificados contra MySQL sintético"
type: plan
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "PLAN-EJECUCION-P2F-PROMOCION-CERTIFICADOS-2026-11-13.md"
  - "PLAN-EJECUCION-P2C-INTEGRACION-LEDGER-MYSQL-SINTETICO-2026-11-13.md"
  - "bd/migraciones/migracion_certificados_equipos_medida.sql"
tags: [qontrolmed, p2, mysql, integracion, certificados]
review_after: 2026-11-20
---

# Plan P2G: integración de certificados contra MySQL sintético

## Objetivo

Demostrar en MySQL 8.4.11 que `quirofanos-0002` añade exactamente
`equipos_medida.ruta_certificado`, que sus pre/postchecks son observables y que
el ledger pasa de `migration-required` en v1 a `compatible` en v2.

## Destinos exactos

- servidor `srv-mm-01`, `192.168.1.31`;
- esquema temporal `qontrolmed_cert_v2_it_20261113`;
- cuenta temporal `qontrolmed_cert_v2_reader`@`localhost`;
- trabajo remoto `/tmp/qontrolmed-p2g-20261113`;
- MySQL solo en `127.0.0.1:3306`, X Plugin deshabilitado y TLS obligatorio;
- datos exclusivamente sintéticos.

## Secuencia autorizada

1. Revalidar identidad, montajes, unidades, espacio, servicios y puertos.
2. Confirmar ausencia exacta de esquema, cuenta, carpeta y drop-in temporales.
3. Validar el certificado piloto preexistente sin mostrar la clave privada.
4. Instalar un drop-in TLS temporal protegido por hash e iniciar MySQL sin
   habilitarlo.
5. Crear esquema, tabla mínima `equipos_medida`, ledger y copia lógica previa.
6. Registrar v1 sintética y confirmar `migration-required`.
7. Ejecutar el SQL versionado de v2; comprobar columna, tipo, longitud,
   nulabilidad, defecto, fila sintética conservada y reejecución rechazada.
8. Registrar v2, leer el ledger con cuenta de solo lectura y confirmar
   `compatible`; comprobar rechazo de escritura.
9. Retirar cuenta, esquema, copia, carpeta y drop-in; detener MySQL y confirmar
   `inactive/disabled`, puertos cerrados y servicios base sin cambios.

## Límites

- sin esquemas, cuentas o datos reales;
- sin UFW, LAN MySQL, paquetes, CA, certificados o configuración persistente;
- sin RC, instalación de Qontrolmed ni promoción de otra migración;
- sin apagar el servidor al cerrar, salvo petición expresa, porque el
  propietario lo ha dejado en línea para esta sesión.

## Parada y reversión

Cualquier diferencia de identidad, almacenamiento, servicio, listener u
objeto temporal preexistente detiene la ventana. El arnés usa una trampa de
limpieza para retirar exclusivamente los destinos exactos, verificar el hash
del drop-in antes de borrarlo, detener MySQL y cerrar puertos. La copia lógica
sintética se usa como evidencia de recuperación prevista y se elimina al
cerrar.

## Aceptación

- prechecks 1 tabla y 0 columnas antes del DDL;
- postcheck exacto `varchar(500)`, nullable y defecto `NULL`;
- datos sintéticos previos conservados;
- reejecución rechazada sin alterar estructura ni datos;
- v1 `migration-required`, v1+v2 `compatible`;
- cuenta lectora sin DML/DDL;
- limpieza completa y línea base segura restaurada;
- evidencia depurada, pruebas locales y controles remotos correctos.

## Autorización

El propietario autorizó el bloque completo el 13/11/2026 e informó que el
servidor está en línea sin sesión abierta. La autorización cubre esta ventana,
sus cambios temporales, validaciones, limpieza, documentación, commits y
publicación, sin ampliar los límites anteriores.

## Resultado

P2G terminó correctamente el 13/11/2026 contra MySQL 8.4.11. El precheck
observó una tabla y cero columnas, el postcheck confirmó `VARCHAR(500)`, `NULL`
permitido y defecto `NULL`, y la fila sintética previa sobrevivió al `ALTER`.
La reejecución fue rechazada sin duplicar columna ni perder datos.

Las filas reales del ledger produjeron `migration-required` con v1 y
`compatible` con v1+v2. La cuenta lectora no pudo escribir. Al cerrar, esquema,
cuenta y TLS temporal se retiraron; MySQL quedó `inactive/disabled`, sin
3306/33060, y los demás servicios conservaron su estado seguro. Evidencia:
`docs/05_evidencias/VALIDACION-P2G-CERTIFICADOS-MYSQL-SINTETICO-2026-11-13.md`.

Publicado en `8c6b0e7`; CI `43469627567` y Security Checks `43469627563`
finalizaron correctamente.
