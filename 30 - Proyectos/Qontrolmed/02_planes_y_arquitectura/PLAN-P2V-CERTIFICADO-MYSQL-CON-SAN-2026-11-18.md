---
title: "P2V — Certificado MySQL con identidad verificable"
type: plan
status: cancelled-not-needed
created: 2026-11-18
updated: 2026-11-18
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2U-CUENTA-RUNTIME-MINIMO-PRIVILEGIO-2026-11-18.md"
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P1-LOCAL-2026-11-11.md"
tags: [qontrolmed, mysql, tls, certificados, san, p2v]
review_after: 2026-11-25
---

# P2V — Certificado MySQL con identidad verificable

## Estado

Plan autorizado, detenido en el precheck y cancelado por innecesario. No se
emitieron ni sustituyeron certificados y MySQL no se reinició.

## Motivo

P2U demostró que la CA y el certificado de servidor actuales forman una cadena
válida y vigente, pero el certificado no contiene `subjectAltName`. La
aplicación debe mantener `ssl_verify_cert=True` y
`ssl_verify_identity=True`; desactivar cualquiera de esos controles no es una
solución aceptable.

## Objetivo

Emitir e instalar un certificado de servidor MySQL firmado por la CA vigente,
con identidad verificable para el canal actual de validación, preservando la
clave privada y la CA con permisos restrictivos, y demostrando la reversión al
par anterior.

## Identidades propuestas

- SAN obligatorio: `IP:127.0.0.1`, usado a través del túnel SSH actual.
- SAN de nombre: `DNS:srv-mm-01`, sujeto a que la conexión futura utilice ese
  nombre de forma estable.
- No incluir direcciones domésticas ni una IP de sede todavía no validada.
- La futura identidad LAN deberá añadirse en sede mediante una nueva emisión o
  el diseño definitivo de DNS/CA; P2V no decide ese dato por anticipado.

## Precondiciones

- Autorización explícita del bloque P2V en ambos ámbitos.
- MySQL `active/enabled`, solo en loopback y sin unidades fallidas.
- Inventario de `@@ssl_ca`, `@@ssl_cert`, `@@ssl_key` y permisos, sin mostrar
  material privado.
- Copia previa de CA, certificado, clave y configuración TLS con SHA-256,
  propietario y modo registrados; directorio `0700`.
- Confirmación de que la CA vigente permite firmar el nuevo certificado y de
  que su clave privada está presente y protegida.
- Ventana breve de reinicio con comprobación previa de conexiones activas.

## Ejecución propuesta

1. Auditar metadatos, rutas, permisos, vigencia y huellas del material actual.
2. Crear la copia previa verificable y un directorio de trabajo `0700`.
3. Generar una nueva clave privada de servidor con modo `0600` y una CSR cuyo
   perfil incluya los SAN aprobados.
4. Firmar el certificado con la CA vigente sin exponer su clave ni copiarla al
   repositorio.
5. Verificar cadena, uso de clave, SAN, correspondencia clave-certificado y
   fechas antes de instalar.
6. Instalar mediante sustitución atómica con propietario/grupo de MySQL y
   permisos mínimos; conservar las rutas configuradas si son adecuadas.
7. Validar configuración y reiniciar MySQL una sola vez.
8. Comprobar servicio, unidades fallidas, escucha loopback, TLS negociado y
   certificado presentado.
9. Probar desde Windows el túnel con CA fijada, verificación de certificado e
   identidad para `127.0.0.1`.
10. Solo tras pasar TLS, reanudar P2U desde una cuenta runtime nueva; no
    reutilizar una cuenta parcial.

## Aceptación

- `openssl verify` correcto y SAN con `IP Address:127.0.0.1`.
- Clave y certificado coinciden; clave privada no legible por otros usuarios.
- MySQL `active/enabled`, cero unidades fallidas y escucha solo en loopback.
- Qontrolmed/mysql-connector conecta con `ssl_verify_cert=True` y
  `ssl_verify_identity=True`.
- Certificado incorrecto, CA incorrecta e identidad distinta son rechazados.
- No se registran claves, contraseñas ni contenido privado en evidencias.

## Reversión

Ante cualquier fallo de validación o arranque, detener la continuación,
restaurar atómicamente certificado, clave y configuración desde la copia
previa, restablecer propietario/modo, validar configuración y reiniciar MySQL.
La reversión debe terminar con la línea base anterior: servicio operativo en
loopback, aunque siga sin superar la identidad fuerte; P2U permanecerá
detenido.

## Límites

P2V no abre 3306 en LAN, no modifica UFW/DNS, no instala una RC, no crea la
cuenta runtime, no rota la CA y no define todavía el certificado final de sede.

## Cancelación tras precheck

P2V se autorizó, pero el primer precheck se detuvo antes de crear copia,
certificado o reiniciar MySQL porque las rutas activas no eran las automáticas
supuestas. El diagnóstico exacto observó que MySQL usa:

- `/var/lib/mysql/piloto-tls/ca.pem`;
- `/var/lib/mysql/piloto-tls/server-cert.pem`;
- `/var/lib/mysql/piloto-tls/server-key.pem`.

La cadena activa es correcta y el certificado presentado contiene
`DNS:srv-mm-01`, `IP Address:127.0.0.1` e `IP Address:192.168.1.31`, con
vigencia hasta el 3/02/2027. Por tanto, P2V se cancela por innecesario. El
fallo de P2U procedía de haber copiado la CA automática inactiva de
`/var/lib/mysql/ca.pem`, no de un defecto del certificado activo.

No se modificaron certificados, claves, configuración o servicio. La
continuación correcta es repetir P2U con una cuenta nueva y obtener la CA desde
`@@ssl_ca`, verificando que corresponda al certificado activo.
