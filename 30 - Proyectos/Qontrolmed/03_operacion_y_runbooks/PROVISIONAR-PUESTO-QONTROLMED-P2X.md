---
title: "Provisionar un puesto Qontrolmed — P2X"
type: runbook
status: draft-phase-b
created: 2026-11-19
updated: 2026-11-19
sources:
  - "docs/02_planes_y_arquitectura/CONTRATO-P2X-IDENTIDAD-RUNTIME-POR-PUESTO-2026-11-19.md"
tags: [qontrolmed, p2x, instalacion, tls, acl]
review_after: 2026-12-19
---

# Provisionar un puesto Qontrolmed — P2X

Este runbook describe el procedimiento futuro. No autoriza por sí mismo la
fase B ni debe ejecutarse hasta disponer del plan transversal de sede.

## Precondiciones

- puesto, MAC, IP reservada y origen MySQL confirmados;
- RC aprobada e instalada mediante su runbook;
- certificado del servidor válido para el nombre o IP configurado;
- CA pública, huella SHA-256 obtenida por canal independiente y secreto único;
- copia previa y reversión por puesto preparadas;
- ventana y contacto funcional confirmados.

## Ubicación canónica en Windows

- configuración: `C:\ProgramData\Qontrolmed\config\.env`;
- CA: `C:\ProgramData\Qontrolmed\config\ca\mysql-ca.pem`.

Administradores y `SYSTEM` conservan control total. El grupo local Usuarios
solo recibe lectura y ejecución en el directorio, y lectura en `.env` y CA. El
script `scripts/configurar_qontrolmed_env.ps1` aplica y repara estas ACL,
verifica el hash de la CA y evita mostrar credenciales.

## Secuencia futura por puesto

1. Completar y validar una copia de las plantillas P2X fuera del repositorio.
2. Ejecutar el alta administrativa solicitando el secreto sin eco.
3. Verificar estado SSL y grants antes de entregar el secreto al puesto.
4. Copiar la CA mediante un temporal, comprobar SHA-256 y moverla a su ruta.
5. Crear `.env` desde la plantilla de la RC, completar host, puerto, usuario y
   secreto en el editor administrativo y reaplicar ACL.
6. Confirmar antes del arranque que TLS es obligatorio, que la CA existe y que
   su hash coincide.
7. Ejecutar la matriz de aceptación y denegación.
8. Retirar temporales, variables de proceso y cualquier copia del secreto.

## Matriz de aceptación

| Prueba | Puesto autorizado | Puesto no autorizado / fallo esperado |
| --- | --- | --- |
| TLS con CA e identidad correctas | conecta | — |
| Origen MySQL exacto | conecta | origen distinto rechazado |
| Guard de esquema | compatible, ledger solo lectura | escritura ledger rechazada |
| Login funcional | correcto | credencial incorrecta rechazada |
| Gestión, Preventivos y Quirófanos | abren y operan dentro de P2U | — |
| Compras y analítica ampliada | ocultas y sin privilegios | acceso SQL rechazado |
| DDL y administración | rechazados | rechazados |
| CA o identidad incorrecta | — | conexión rechazada |
| Cuenta revocada | — | conexión rechazada |

## Reversión por puesto

Si falla una puerta, no se amplían privilegios. Se ejecuta la baja de la
identidad exacta, se comprueba su ausencia y se retiran `.env` y CA del puesto
si todavía no existe otra instalación aprobada que los necesite. Los cambios
de red, certificado o UFW se revierten conforme al plan transversal de fase B.
