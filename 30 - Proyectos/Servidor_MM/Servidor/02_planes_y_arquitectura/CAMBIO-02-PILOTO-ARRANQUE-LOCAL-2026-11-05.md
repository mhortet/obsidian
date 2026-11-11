---
title: "Cambio 02 piloto MySQL: arranque local breve y parada"
type: plan
status: partial
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../00_seguimiento/estados/ESTADO-CAMBIO-01-PILOTO-2026-11-05.md"
tags: [mysql, seguridad, documentacion]
review_after: 2026-11-12
---

# Cambio 02: arranque local breve y parada

Aprobado expresamente por el propietario el 2026-11-05 mediante «si,». Ejecutado con parada verificada. Resultado parcial: escucha y parámetros correctos; prueba negativa sin TLS inconclusa por ERROR 1698. Véase ../00_seguimiento/estados/ESTADO-CAMBIO-02-PILOTO-2026-11-05.md.

## Propósito

Verificar que la configuración ya validada funciona realmente: solo escucha local, protocolo X desactivado y TLS disponible/obligatorio. Inspeccionar certificados públicos sin exportar claves. No es todavía una prueba de Qontrolmed ni de identidad TLS desde Windows.

## Alcance exacto

1. Comprobar inactive/disabled, ausencia de proceso/puertos, hash del archivo del cambio 01 y validación sintáctica satisfactoria. Si hay discrepancias, abortar sin arrancar.
2. Inspeccionar CA y certificado públicos con openssl x509: sujeto, emisor, vigencia y subjectAltName. Comprobar cadena con openssl verify y caducidad. No leer ni mostrar claves privadas. Registrar si el certificado carece del nombre necesario para la futura prueba del cliente.
3. Preparar un manejador de salida que ejecute systemctl stop mysql y verifique inactive/disabled sin escucha. Mantenerlo activo durante toda la prueba, también ante errores.
4. Ejecutar systemctl start mysql, con límite de espera de 90 segundos. No habilitar arranque automático. Si el arranque falla o supera el límite, detener y recoger diagnóstico acotado.
5. Comprobar ss -ltnp: únicamente 127.0.0.1:3306 para MySQL, sin 33060 ni interfaces LAN/IPv6 para MySQL.
6. Mediante cliente local y autenticación Unix socket existente, ejecutar únicamente consultas de lectura: SELECT VERSION(), @@bind_address, @@require_secure_transport, @@tls_version; SHOW GLOBAL STATUS LIKE 'Ssl_server_not_after'; SHOW GLOBAL VARIABLES LIKE 'mysqlx_port'. Comprobar estado de X Plugin consultando INFORMATION_SCHEMA.PLUGINS. Si root local no autentica, no alterar cuentas y parar.
7. Probar con el cliente TCP local --ssl-mode=DISABLED y --connect-timeout=5: se espera rechazo por transporte inseguro. Cualquier error distinto no demuestra esta condición y debe registrarse como prueba inconclusa. No crear cuentas para completar esta fase.
8. Parar MySQL y comprobar inactive/disabled y ausencia de 3306/33060; registrar evidencias en el proyecto. Duración prevista: pocos minutos.

No se crean usuarios/esquemas, no se importan datos, no se cambian certificados ni firewall. No se prueba todavía una sesión TLS autenticada de aplicación: requerirá posteriormente cuenta piloto y certificado verificable.

## Riesgo y reversión

El arranque puede escribir logs, metadatos internos y ejecutar recuperación normal de MySQL; no es una operación de solo lectura. No se propone cambio de versión ni migración ni inicialización del directorio de datos. Las configuraciones previas quedan conservadas. El servidor estaba recién instalado sin cuentas Qontrolmed según el registro anterior; no se dará por probado que esté vacío sin verificación.

Si falla, detener MySQL y dejarlo deshabilitado. Mantener el archivo seguro del cambio 01. No forzar recuperación, borrar archivos ni restaurar datos automáticamente. Si systemctl stop no consigue detenerlo, informar y no usar kill -9 como reversión automática. No se revierte el contenido interno de la base mediante este procedimiento.

## Aceptación

Arranque satisfactorio, escucha exclusiva 127.0.0.1:3306, X Plugin desactivado, transporte seguro obligatorio y parámetros esperados; parada final confirmada. Validez/nombre de certificados documentados, sin asumir que sean aptos para producción. La prueba sin TLS debe devolver un rechazo inequívoco para contarse como superada.

## Script de ejecución

06_herramientas/scripts/cambio02-piloto-20261105.sh, copiado a /home/vicente/cambio02-piloto-20261105.sh. Sintaxis Bash y hash comprobados. Certificado inválido/caducado o cadena errónea abortan antes del arranque. Si la prueba TCP devuelve un error distinto de 3159 por transporte inseguro, se registra como inconclusa y se detiene igualmente MySQL. Los registros detallados permanecen bajo /root/srv-mm-piloto-20261105/. El manejador de salida intenta parar y verificar MySQL ante errores y señales capturables; no protege frente a pérdida de alimentación o SIGKILL. No afirmar finalización sin recoger la salida y revalidar el servicio.


