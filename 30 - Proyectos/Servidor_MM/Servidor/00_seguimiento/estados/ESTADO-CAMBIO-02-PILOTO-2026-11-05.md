---
title: "Estado tras prueba local de MySQL"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../05_evidencias/CAMBIO-02-PILOTO-2026-11-05.txt"
tags: [mysql, seguridad, auditoria]
review_after: 2026-11-12
---

# Prueba local MySQL — 2026-11-05

Arranque manual autorizado y ejecutado a partir de las 11:37 Europe/Madrid. MySQL 8.4.11 arrancó con escucha exclusiva 127.0.0.1:3306, require_secure_transport=1, TLSv1.2/TLSv1.3 y mysqlx DISABLED. Consulta administrativa por socket correcta.

CA y certificado automáticos: cadena verificada, vigentes desde 2026-10-04 hasta 2036-10-01. Sin extensiones SAN; CN genérico de MySQL, sin identidad srv-mm-01 ni su IP. No aptos para la verificación de identidad prevista con esos destinos.

La prueba TCP sin TLS devolvió ERROR 1698, no el rechazo inequívoco de transporte inseguro esperado (3159). Queda INCONCLUSA; no demuestra aceptación de tráfico sin TLS ni fallo del ajuste. Se necesita una cuenta de prueba apropiada para completar la comprobación, previa autorización.

Parada confirmada por el script y revalidada por SSH: inactive/disabled, sin proceso mysqld ni escucha 3306/33060, sin unidades fallidas. No se alteraron cuentas, esquemas, certificados o firewall. No se ha probado una sesión TCP TLS autenticada de aplicación.

Registro administrativo: /root/srv-mm-piloto-20261105/cambio02.LmrGkZWM. Resultado: CAMBIO02_FINALIZADO_CON_PRUEBA_INCONCLUSA. El bloque se ejecutó con parada correcta, pero no satisface todavía toda la aceptación del plan.
