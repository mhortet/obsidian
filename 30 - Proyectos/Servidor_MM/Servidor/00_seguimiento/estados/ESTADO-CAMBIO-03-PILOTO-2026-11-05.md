---
title: "Estado tras certificado verificable del piloto"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../05_evidencias/CAMBIO-03-PILOTO-2026-11-05.txt"
tags: [mysql, seguridad, auditoria]
review_after: 2026-11-12
---

# Certificado del piloto — cambio 03 completado

Ejecutado el 2026-11-05 a las 11:43 Europe/Madrid; evidencia CAMBIO03_COMPLETADO recogida. Revalidación SSH independiente: configuración y hash correctos, MySQL inactive/disabled, sin proceso mysqld ni escucha 3306/33060 y sin unidades fallidas.

## Certificados y comprobaciones

- CA de piloto válida hasta el 2027-11-05 a las 11:43 Europe/Madrid; clave privada root:root 0600 en directorio root 0700.
- Certificado servidor válido hasta el 2027-02-03 a las 11:43 Europe/Madrid. SAN: DNS:srv-mm-01, IP:127.0.0.1, IP:192.168.1.31.
- Cadena y propósito serverAuth verificados para el nombre y ambas IP; nombre incorrecto rechazado. CA:TRUE, servidor CA:FALSE comprobados por el script.
- Lectura de certificados y acceso al archivo de clave comprobados como mysql. Directorio de despliegue /var/lib/mysql/piloto-tls mysql:mysql 0750; clave servidor 0600, certificados públicos 0644.
- Claves privadas generadas y mantenidas en el servidor; no exportadas al proyecto ni mostradas en el chat.
- Validación de configuración correcta sin arrancar MySQL. Valores efectivos: bind-address 127.0.0.1, mysqlx OFF, require-secure-transport TRUE y rutas ssl-ca/ssl-cert/ssl-key del directorio de piloto.

SHA256 de /etc/mysql/mysql.conf.d/90-qontrolmed-piloto.cnf: 4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927.

Registro administrativo y copia previa: /root/srv-mm-piloto-20261105/cambio03.VMDmZx9j. Certificados automáticos anteriores conservados. No se modificaron firewall, cuentas, esquemas ni arranque automático.

## Pendientes reales

No se ha probado el nuevo certificado en una sesión TLS autenticada ni con Qontrolmed. La prueba negativa sin TLS del cambio 02 continúa inconclusa y debe repetirse con una cuenta de prueba. El piloto LAN, las operaciones ficticias y la restauración siguen pendientes.
