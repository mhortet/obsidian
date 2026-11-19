---
title: "P2X — Provisión por puesto y diseño de conexión de sede"
type: plan
status: completed-phase-a
created: 2026-11-18
updated: 2026-11-19
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2U-CUENTA-RUNTIME-MINIMO-PRIVILEGIO-2026-11-18.md"
  - "docs/02_planes_y_arquitectura/PLAN-P2W-SMOKE-FUNCIONAL-RUNTIME-DESARROLLO-2026-11-18.md"
  - "docs/01_gobierno_y_decisiones/DECISION-ESPECIFICACIONES-OPERATIVAS-PILOTO-2026-11-16.md"
tags: [qontrolmed, puestos, mysql, red, sede, minimo-privilegio, p2x]
review_after: 2026-11-25
---

# P2X — Provisión por puesto y diseño de conexión de sede

## Estado

La fase A local fue autorizada por el propietario y completada el 19/11/2026.
La fase B permanece pendiente y no autorizada. Este cierre no permite abrir
MySQL a la LAN, modificar UFW, crear cuentas de puestos reales, emitir
certificados, instalar una RC ni utilizar datos reales.

## Punto de partida validado

- Rama `codex/produccion-readiness` publicada hasta `11faaa8`.
- CI y Security Checks correctos para ese commit.
- Administrador funcional creado y contraseña inicial asignada.
- `qontrolmed_runtime_dev@localhost` activa, con mínimo privilegio y TLS.
- Smoke test desde desarrollo correcto para Gestión mínima, Preventivos y
  Quirófanos.
- Compras y analítica ampliada ocultas incluso para superusuario.
- MySQL `active/enabled`, sin unidades fallidas y solo en
  `127.0.0.1:3306`.
- Ninguna RC nueva construida o instalada.

## Objetivo

Convertir la validación realizada con una cuenta de desarrollo y túnel SSH en
un diseño reproducible para cuatro o cinco puestos autorizados de la sede,
manteniendo identidades separadas, mínimo privilegio, TLS, revocación por
puesto y reversión.

## Fase A — trabajo local permitido tras autorización de P2X

1. Definir el contrato de identidad por puesto:
   - convención de nombres sin datos personales;
   - origen MySQL exacto por IP o nombre estable;
   - privilegios idénticos a la matriz P2U;
   - `REQUIRE SSL`, autenticación y rotación;
   - alta, baja, sustitución y revocación de un equipo.
2. Crear plantillas no ejecutables con marcadores obligatorios para:
   - crear una identidad;
   - verificar sus grants;
   - revocarla;
   - rotar su secreto sin exponerlo.
3. Diseñar la provisión segura del puesto:
   - ubicación canónica de `.env` y CA;
   - ACL de solo lectura para el usuario ordinario;
   - huella SHA-256 de la CA;
   - comprobación previa al arranque;
   - limpieza de temporales.
4. Preparar la matriz de aceptación y denegación para un puesto autorizado y
   otro no autorizado.
5. Preparar el inventario de datos que deben confirmarse en la sede.

La fase A no se conecta al servidor ni crea cuentas reales.

## Datos necesarios antes de la fase operativa

- nombre o código estable de cada puesto;
- sistema operativo y usuario ordinario responsable;
- MAC del adaptador que utilizará la aplicación;
- reserva DHCP e IP asignada dentro de `192.168.0.0/24`;
- IP definitiva del servidor, gateway y DNS de sede;
- decisión sobre conexión directa LAN o canal intermedio aprobado;
- nombre DNS que figurará en el certificado del servidor;
- responsable autorizado para altas, bajas y recuperación de credenciales;
- ventana de instalación y contacto funcional para aceptación.

No se inventarán estos valores usando la red doméstica actual.

Las IP de servidor y puestos pueden ser **propuestas por el propietario**
dentro de un plan provisional, pero no se considerarán asignadas hasta
comprobar en sede el rango DHCP, las reservas existentes, la puerta de enlace,
el DNS y la ausencia de conflictos. La falta de respuesta del cliente no
bloquea la preparación local ni obliga a cerrar ahora esos valores.

## Fase B — operación futura, no autorizada por este documento

Cuando exista inventario de sede y un plan transversal aprobado:

1. crear copia y foto previa de servicio/red;
2. emitir o instalar el certificado definitivo de sede;
3. configurar escucha y UFW solo para los orígenes exactos;
4. crear una cuenta MySQL distinta por puesto;
5. instalar la RC aprobada y provisionar `.env`/CA con ACL;
6. ejecutar pruebas positivas y negativas por origen;
7. retirar toda cuenta, regla o certificado temporal;
8. aceptar o revertir el puesto individualmente.

## Aceptación de la fase A

- matriz por puesto y ciclo de vida documentados;
- plantillas sin secretos y con marcadores que fallen si no se sustituyen;
- permisos equivalentes a P2U, sin DDL ni administración;
- pruebas de acceso autorizado, origen rechazado, TLS incorrecto y revocación;
- procedimiento de configuración y ACL del puesto;
- lista cerrada de datos pendientes de sede;
- ninguna modificación en servidor, red o cuentas reales.

## Reversión

La fase A solo produce documentación, plantillas y pruebas locales; se revierte
retirando esos cambios del commit antes de publicarlo. La fase B necesitará un
plan independiente con copias, reglas y cuentas exactas, y reversión por puesto.

## Primera acción de la próxima sesión

Preparar, cuando se aproxime la instalación, una propuesta concreta de
direccionamiento y completar el inventario de sede. Después se redactará un
plan transversal independiente para la fase B, separando las acciones que
pueden ejecutarse remotamente de las que requieren una ventana local.

## Resultado de la fase A — 19/11/2026

- contrato de identidad y ciclo de vida por puesto documentado;
- plantillas administrativas no ejecutables para alta, verificación, rotación
  y baja, con marcadores obligatorios y secreto solicitado sin eco;
- procedimiento de provisión de `.env`, CA, hash y ACL de Windows;
- matriz de aceptación y denegación por puesto;
- inventario de sede con responsables, estado y modalidad de ejecución;
- pruebas estáticas para impedir marcadores silenciosos, privilegios globales,
  DDL o reutilización de la cuenta de desarrollo;
- ninguna conexión al servidor ni modificación de red, cuentas o datos.

Artefactos principales:

- `docs/02_planes_y_arquitectura/CONTRATO-P2X-IDENTIDAD-RUNTIME-POR-PUESTO-2026-11-19.md`;
- `docs/03_operacion_y_runbooks/PROVISIONAR-PUESTO-QONTROLMED-P2X.md`;
- `docs/07_recursos/plantillas/INVENTARIO-SEDE-P2X.md`;
- `scripts/db/plantillas_p2x/`;
- `tests/test_p2x_workstation_templates.py`.
