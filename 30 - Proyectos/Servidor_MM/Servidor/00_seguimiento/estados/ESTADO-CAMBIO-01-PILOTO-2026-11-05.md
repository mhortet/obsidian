---
title: "Estado tras cambio 01 piloto MySQL"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../05_evidencias/CAMBIO-01-PILOTO-2026-11-05.txt"
tags: [mysql, seguridad, auditoria]
review_after: 2026-11-12
---

# Estado tras cambio 01 — 2026-11-05

Cambio autorizado expresamente y ejecutado por el propietario mediante sudo a las 11:31 Europe/Madrid. Resultado CAMBIO01_COMPLETADO recogido y estado revalidado por SSH.

Archivo /etc/mysql/mysql.conf.d/90-qontrolmed-piloto.cnf, root:root 0644:

```ini
[mysqld]
bind-address=127.0.0.1
mysqlx=OFF
require_secure_transport=ON
```

Validación previa y posterior satisfactorias. Ayuda efectiva: bind-address 127.0.0.1, mysqlx OFF, require-secure-transport TRUE. Hash SHA256 del archivo: 94069a958ccf6f51fddcedc3e480028dc86e443709861fec996bd525f89b13c7.

El script completó la comprobación de hashes de los archivos .cnf previos. Registro administrativo restringido: /root/srv-mm-piloto-20261105/cambio01.8hrxnujl.

Revalidación independiente: contenido, propietario, modo y hash correctos; mysql inactive/disabled; sin escucha 3306/33060; sin unidades fallidas. No se cambiaron firewall, certificados, cuentas ni esquemas. La configuración está preparada, pero TLS todavía no se ha probado en ejecución.

Siguiente paso propuesto: arranque manual breve, exclusivamente local, comprobación de variables/TLS/certificados y parada garantizada al terminar. Pendiente de aprobación expresa. No autoriza cuentas, datos ni acceso LAN.
