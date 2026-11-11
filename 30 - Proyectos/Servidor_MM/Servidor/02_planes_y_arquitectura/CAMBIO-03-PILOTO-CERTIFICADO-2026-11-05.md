---
title: "Cambio 03 piloto MySQL: certificado verificable"
type: plan
status: completed
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../00_seguimiento/estados/ESTADO-CAMBIO-02-PILOTO-2026-11-05.md"
tags: [mysql, seguridad, documentacion]
review_after: 2026-11-12
---

# Cambio 03 propuesto: certificado verificable del piloto

Autorizado expresamente por el propietario el 2026-11-05. Ejecutado y verificado el 2026-11-05 a partir de las 11:43 Europe/Madrid. Evidencia: ../05_evidencias/CAMBIO-03-PILOTO-2026-11-05.txt. La aprobación cubre todos los pasos, comprobaciones y reversión de este plan sin nuevas autorizaciones individuales.

## Propósito

Sustituir para el piloto el uso de certificados automáticos sin identidad verificable por una CA exclusiva y un certificado con SAN. Solo preparación de TLS, sin arrancar MySQL, crear cuentas o abrir LAN. El certificado es doméstico; no fija la identidad de producción.

## Cambio exacto propuesto

- Crear CA exclusiva de piloto en /root/srv-mm-piloto-20261105/ca-piloto/, directorio 0700 y clave privada 0600 root:root. RSA 3072, SHA-256, vigencia 365 días, extensión CA:TRUE y usos de firma de certificados/CRL. No instalarla globalmente como confiable en Windows.
- Crear clave privada nueva y certificado de servidor RSA 3072/SHA-256, vigencia 90 días, basicConstraints CA:FALSE, usos digitalSignature/keyEncipherment y extendedKeyUsage serverAuth. SAN: DNS:srv-mm-01, IP:127.0.0.1 e IP:192.168.1.31. La IP LAN solo corresponde a la reserva doméstica.
- Directorio de despliegue /var/lib/mysql/piloto-tls/, mysql:mysql 0750. Clave servidor mysql:mysql 0600; CA y certificado públicos 0644. La clave privada de la CA permanece únicamente bajo /root; no se copia al directorio de MySQL ni al proyecto.
- Conservar el archivo del cambio 01 en el directorio administrativo restringido antes de editarlo. Añadir únicamente ssl-ca=/var/lib/mysql/piloto-tls/ca.pem, ssl-cert=/var/lib/mysql/piloto-tls/server-cert.pem y ssl-key=/var/lib/mysql/piloto-tls/server-key.pem. Mantener bind-address=127.0.0.1, mysqlx=OFF y require_secure_transport=ON.
- No sobrescribir los certificados automáticos existentes ni reutilizar claves privadas. Si existen los destinos nuevos, detener y revisar antes de sobrescribir.

## Pruebas de aceptación

Precondición: MySQL inactive/disabled y configuración del cambio 01 intacta. Comprobar cadena, fechas, CA:TRUE/CA:FALSE, uso serverAuth e identidad mediante openssl verify para nombre srv-mm-01 y ambas IP. Un nombre distinto debe fallar. Verificar lectura de archivos como usuario mysql y validación de configuración sin arranque. Confirmar que el servicio sigue parado/deshabilitado y sin escucha. Guardar en el proyecto solo evidencia no secreta: metadatos, huellas y resultados. Esta fase no prueba TLS en ejecución.

## Riesgos y reversión

Riesgo: permisos, rutas o certificado incorrectos impiden un arranque futuro. Mitigación: validación previa, MySQL parado y conservar originales.

Si falla, restaurar solo el archivo .cnf del cambio 01 con propietario/permisos correctos y validarlo; mantener MySQL parado. Conservar los artefactos nuevos protegidos para diagnóstico, sin borrado automático ni cambio de certificados originales. No arrancar con transporte inseguro para sortear el fallo.

## Fase posterior separada

Crear una cuenta/esquema ficticio de prueba, probar TCP con TLS validado y rechazo sin TLS con esa cuenta. Se presentará el alcance exacto antes de crearla. Después adaptar Qontrolmed y hacer prueba LAN /32. No se declara piloto terminado hasta completar esas pruebas y recuperación.


