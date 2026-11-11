---
title: "Fase local: conexion TLS correcta, prueba negativa pendiente"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../05_evidencias/PILOTO-LOCAL-INTENTO-01-2026-11-05.txt"
tags: [mysql, seguridad, auditoria]
review_after: 2026-11-12
---

# Fase local — primer intento y continuación preparada

Ejecución del 2026-11-05 a las 11:51 Europe/Madrid. Sesión TCP con CA e identidad verificadas correcta; cifrado TLS_AES_128_GCM_SHA256. Se crearon la cuenta local limitada y los tres esquemas ficticios; las operaciones de inserción, actualización, borrado de fila ficticia y consulta preceden a la marca de éxito TLS en el script y completaron sin error.

La prueba sin TLS esperaba exclusivamente ERROR 3159 y terminó como inconclusa; el primer script no registró el código real. No afirmar que fuera 1045 o 2061: todavía no está observado. Copia/restauración y prueba de CA errónea NO se ejecutaron porque eran posteriores al fallo.

Cierre: cuenta mm_piloto_local@127.0.0.1 bloqueada y MySQL inactive/disabled, sin proceso ni escucha 3306/33060. Parada revalidada de forma independiente por SSH; sin unidades fallidas.

## Ajuste incluido en el plan autorizado

Se conserva script inicial y evidencia. Se prepara modo --resume que verifica archivos de credenciales root 0600, cuenta única bloqueada con REQUIRE SSL y tablas/datos esperados. No elimina ni recrea los tres esquemas y no cambia la contraseña. Si hay diferencias, aborta.

Desbloquea solo la cuenta propia durante la prueba y repite sesión TLS correcta. La prueba sin TLS solicita la clave publica RSA para no confundir el requisito del plugin caching_sha2_password con la política TLS. Registra solo códigos, sin credenciales. Acepta 3159 como rechazo global; 1045 solo como rechazo por REQUIRE SSL de la misma cuenta/credencial previamente validada con TLS, comprobando también require_secure_transport=1 en runtime. No interpreta errores arbitrarios como éxito. No desactiva REQUIRE SSL ni la política global.

Continúa con CA incorrecta, permisos y copia/restauración en tres destinos nuevos si los anteriores pasos pasan. Si un destino de restauración ya existe, aborta sin sobrescribir. Al terminar bloquea cuenta y detiene MySQL; no abre UFW ni cambia escucha.

Script actualizado en 06_herramientas/scripts/piloto-local-20261105.py y /home/vicente/piloto-local-20261105.py. Sintaxis y hash comprobados. Pendiente ejecución sudo --resume; salida prevista /home/vicente/piloto-local-reanudacion-20261105.txt. No solicitar nueva aprobación: es corrección de la prueba y continuación dentro del plan conjunto aprobado.

## Referencias

- https://dev.mysql.com/doc/refman/8.4/en/using-encrypted-connections.html
- https://dev.mysql.com/doc/refman/8.4/en/caching-sha2-pluggable-authentication.html

Las causas de 1045/2061 son hipótesis orientadas a mejorar el diagnóstico; el código real del intento anterior no se conserva en la salida pública.
