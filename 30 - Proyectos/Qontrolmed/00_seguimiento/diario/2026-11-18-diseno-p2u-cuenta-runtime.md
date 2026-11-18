---
title: "Diseño P2U de cuenta runtime MySQL"
type: state
status: completed
created: 2026-11-18
updated: 2026-11-18
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2U-CUENTA-RUNTIME-MINIMO-PRIVILEGIO-2026-11-18.md"
tags: [qontrolmed, sesion, mysql, runtime, p2u]
review_after: 2026-11-25
---

# Sesión 2026-11-18: diseño P2U de cuenta runtime

## Objetivo y punto de partida

Se retomó el cierre P2R/P2T del 17/11. El bootstrap funcional está completo,
el ledger canónico quedó compatible y no existe todavía una cuenta runtime
definitiva. El árbol conserva cambios locales documentados de las sesiones
P2P–P2T; no se sobrescribieron ni consolidaron en esta sesión.

## Trabajo realizado

- Se leyeron los relevos de Qontrolmed y Servidor_MM y la documentación
  obligatoria de Qontrolmed.
- Se comprobó la rama `codex/produccion-readiness` y el estado local.
- Se revisó la propuesta P0 de cuenta técnica, el cierre P2R y las operaciones
  SQL del código vigente.
- Se confirmó que el runtime no contiene DDL activo y que el guard requiere
  lectura del ledger de Quirófanos.
- Se redactó P2U con identidad por puesto, privilegios por tabla, TLS,
  aceptación, denegaciones y reversión.

## Resultado y límites

P2U queda **propuesto y pendiente de autorización explícita**. No se conectó al
servidor, no se creó ninguna cuenta, no se modificó `.env`, no se abrió la LAN
y no se construyó ni instaló una RC.

Antes de ejecutar P2U debe revisarse la matriz final contra los casos de uso y
registrarse la autorización del bloque completo.

## Ejecución y cierre revertido

El propietario autorizó P2U y ejecutó localmente las entradas de `sudo` y de
contraseña sin compartir secretos. El precheck validó 24 objetos, ledger v1/v2
`applied` y copias completas con SHA-256 correcto. Tras corregir controles del
arnés, la cuenta se creó con `ssl_type=ANY` y sin privilegios globales, DDL,
administración ni `GRANT OPTION`.

La prueba mediante túnel falló de forma segura en la verificación del
certificado. El diagnóstico posterior observó cadena correcta y vigencia hasta
2036, pero ninguna extensión SAN en el certificado de servidor. Se mantuvo la
verificación fuerte; no se conectó Qontrolmed ni se modificaron datos.

La cuenta runtime fue retirada y los temporales remotos eliminados. La línea
base final fue MySQL `active/enabled`, cero unidades fallidas y
`127.0.0.1:3306` como única escucha. P2V queda propuesto para corregir el
certificado antes de repetir P2U.

### Corrección de diagnóstico y cierre definitivo

P2V se autorizó, pero su precheck se detuvo sin cambios al descubrir que MySQL
no usa los certificados automáticos inspeccionados inicialmente. Las variables
activas apuntan a `/var/lib/mysql/piloto-tls/`; ese certificado sí contiene SAN
para `srv-mm-01`, `127.0.0.1` y `192.168.1.31`. P2V se canceló por
innecesario.

P2U se repitió con la CA resuelta desde `@@ssl_ca`. La cuenta definitiva pasó
TLS con identidad, lectura de los tres esquemas, denegaciones de Compras,
ledger y DDL, y rechazo sin TLS. El cierre retiró CA, túnel, variable de
contraseña y arneses temporales. La cuenta runtime queda activa; MySQL continúa
`active/enabled`, sin unidades fallidas y solo en loopback.

## P2W — smoke funcional

P2W ejecutó el código actual con configuración efímera de proceso y sin tocar
`.env`. El primer intento detectó que `python-dotenv` sobrescribía el entorno;
se corrigió la precedencia y se añadió una regresión. El smoke posterior validó
login, Gestión, Preventivos y Quirófanos, pero reveló que el superusuario aún
mostraba Compras. Se añadió una puerta central de alcance para ocultar Compras,
analítica y funciones relacionadas sin eliminar su código.

La repetición final abrió y cerró correctamente los tres módulos permitidos,
mantuvo diferidas las funciones excluidas y terminó con
`P2W_QONTROLMED_CERRADO=OK`, `P2W_ENV_INTACTO=OK` y
`P2W_LIMPIEZA_LOCAL=OK`. Pasaron 95 pruebas. No hubo escrituras funcionales,
RC, instalación ni apertura de red.
