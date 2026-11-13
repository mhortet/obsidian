---
title: "Revalidación de srv-mm-01 tras el incidente de consola"
type: session-log
status: completed
created: 2026-11-13
updated: 2026-11-13
sources:
  - "../../03_operacion_y_runbooks/REANUDAR-TRAS-INCIDENTE-CONSOLA-2026-11-13.md"
  - "../../05_evidencias/REVALIDACION-TRAS-INCIDENTE-CONSOLA-2026-11-13.txt"
tags: [servidor, sesion, consola, revalidacion]
---

# Revalidación tras el incidente de consola

El propietario encendió el equipo, desbloqueó LUKS y confirmó consola VGA
visible hasta el login. La comprobación SSH estricta y de solo lectura confirmó
la línea base segura. Resultado: `REVALIDACION_TRAS_INCIDENTE=OK`.

La IP `.31` está reservada en el router. `.30` fue la dirección anterior y se
conserva únicamente como alias histórico de la clave de host SSH.

## Aprendizaje operativo: apagado local

Después de iniciar sesión en la consola, el apagado controlado se solicita con:

```bash
sudo systemctl poweroff
```

La contraseña se introduce solo en la consola, nunca en el chat o la evidencia.
Después se espera al apagado físico y se comprueba que SSH deja de responder.

Se observaron avisos por una referencia a `pam_lastlog.so` ausente. No
impidieron el acceso finalmente realizado y no se corrigieron. La identidad SSH
se retiró del agente y el servidor terminó apagado.

## Continuación P2C

El servidor se encendió de nuevo tras la aprobación transversal de P2C. MySQL
8.4.11 se inició manualmente, deshabilitado y limitado a loopback. El primer
intento falló de forma segura porque el certificado automático no contenía SAN;
la limpieza retiró cuenta y esquema sintéticos y detuvo MySQL.

El inventario localizó el certificado piloto preexistente con SAN
`srv-mm-01`, `127.0.0.1` y `192.168.1.31`. Una ampliación aprobada aplicó un
drop-in TLS temporal protegido por hash. El segundo intento superó verificación
de identidad, estructura, restricciones y denegaciones. Después se retiró el
drop-in y se confirmó MySQL inactivo/deshabilitado, puertos cerrados y servicios
del bloque en su estado seguro.
