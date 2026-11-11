---
title: "Cambio 01 piloto MySQL: configuración local sin arranque"
type: plan
status: completed
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../05_evidencias/AUDITORIA-PILOTO-2026-11-05.txt"
tags: [mysql, seguridad, documentacion]
review_after: 2026-11-12
---

# Cambio 01: preparar configuración local sin arrancar MySQL

Estado: aprobado expresamente por el propietario el 2026-11-05 mediante «si autorizado». Aplicado y verificado el 2026-11-05 a partir de las 11:31 Europe/Madrid. Evidencia: ../05_evidencias/CAMBIO-01-PILOTO-2026-11-05.txt. MySQL permanece inactive/disabled.

## Evidencia

Auditoría del 2026-11-05 a las 11:27 Europe/Madrid: MySQL 8.4.11 inactive/disabled, UFW activo con únicamente dos reglas SSH para 192.168.1.0/24 y 192.168.0.0/24. Sin escucha 3306/33060. Existen certificados y claves con metadatos registrados; su validez e identidad no se han comprobado. El grep de opciones no encontró ajustes explícitos de red/TLS en archivos .cnf, pero no equivale a inspección completa de la configuración efectiva.

Se confirmó que /etc/mysql/my.cnf incluye /etc/mysql/mysql.conf.d/. La ayuda del binario reconoce mysqlx, require-secure-transport, bind-address y validate-config.

## Propósito y alcance exacto

Preparar una base local de prueba que impida una escucha general cuando se apruebe después el arranque. Este bloque solo añade un archivo de configuración y lo valida, sin arrancar el servicio, abrir firewall, habilitar arranque automático ni crear usuarios/esquemas.

Archivo nuevo: /etc/mysql/mysql.conf.d/90-qontrolmed-piloto.cnf, propietario root:root, modo 0644.

```ini
[mysqld]
bind-address=127.0.0.1
mysqlx=OFF
require_secure_transport=ON
```

La fase local precede a la prueba LAN. No permite aún conexión directa desde Windows. Una fase posterior deberá preparar certificados verificables, arranque manual y datos ficticios; después se aprobará la apertura /32 para probar LAN. No se sustituyen certificados ni se reutilizan como confiables sin inspección.

## Procedimiento

1. Verificar que mysql sigue inactive/disabled y que no existen procesos mysqld ni escuchas 3306/33060. Si difiere, detener el procedimiento sin cambiar nada.
2. Comprobar que el archivo nuevo no existe. Si existe, no sobrescribirlo: volver a revisar.
3. Registrar los hashes de los archivos .cnf actuales como línea base y guardarlos en /root/srv-mm-piloto-20261105/ con permisos restringidos. No copiar claves, certificados privados ni contenidos de configuración al repositorio. La línea base no sustituye una copia de la base de datos.
4. Validar primero la configuración existente con mysqld --user=mysql --validate-config. Si falla, no instalar el archivo.
5. Crear el archivo con el contenido exacto anterior mediante instalación atómica; no editar otros archivos.
6. Ejecutar nuevamente mysqld --user=mysql --validate-config y comprobar opciones relevantes mediante la ayuda efectiva del binario. No imprimir toda la configuración ni opciones con credenciales.
7. Comprobar que MySQL permanece inactive/disabled y que siguen sin existir escuchas 3306/33060.
8. Registrar resultados y hashes. No continuar al arranque automáticamente.

## Aceptación

Validación sin errores; valores efectivos bind-address=127.0.0.1, mysqlx=OFF y require-secure-transport=TRUE/ON; archivo root:root 0644; MySQL sigue parado y deshabilitado; sin escuchas nuevas. La validación sintáctica no demuestra todavía que TLS o los certificados funcionen: eso se probará al autorizar el arranque.

## Riesgos y reversión

Riesgo acotado: un error o conflicto puede impedir un arranque futuro. El servicio permanece detenido durante todo el bloque.

Si la validación falla, retirar el archivo recién creado moviéndolo a /root/srv-mm-piloto-20261105/ con un nombre fechado y fuera de los directorios incluidos; validar de nuevo la configuración anterior y mantener MySQL parado/deshabilitado. No borrar otros archivos, reiniciar ni iniciar MySQL. Si la validación previa ya fallaba, no aplicar cambios.

## Fuentes técnicas

- https://dev.mysql.com/doc/refman/8.4/en/server-configuration-validation.html
- https://dev.mysql.com/doc/refman/8.4/en/x-plugin-options-system-variables.html
- https://dev.mysql.com/doc/refman/8.4/en/server-system-variables.html


