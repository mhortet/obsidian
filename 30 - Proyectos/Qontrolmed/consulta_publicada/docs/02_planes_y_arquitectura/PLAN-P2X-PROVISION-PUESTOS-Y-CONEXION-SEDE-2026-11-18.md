---
title: "P2X — Provisión por puesto y diseño de conexión de sede"
type: plan
status: proposed
created: 2026-11-18
updated: 2026-11-18
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2U-CUENTA-RUNTIME-MINIMO-PRIVILEGIO-2026-11-18.md"
  - "docs/02_planes_y_arquitectura/PLAN-P2W-SMOKE-FUNCIONAL-RUNTIME-DESARROLLO-2026-11-18.md"
  - "docs/01_gobierno_y_decisiones/DECISION-ESPECIFICACIONES-OPERATIVAS-PILOTO-2026-11-16.md"
tags: [qontrolmed, puestos, mysql, red, sede, minimo-privilegio, p2x]
review_after: 2026-11-25
---

# P2X — Provisión por puesto y diseño de conexión de sede

## Estado

Plan preparado para revisión en la próxima sesión. Está **propuesto y no
autorizado**. No permite abrir MySQL a la LAN, modificar UFW, crear cuentas de
puestos reales, emitir certificados, instalar una RC ni utilizar datos reales.

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

Revisar este plan con el propietario y decidir si se autoriza únicamente la
fase A local. Si se autoriza, comenzar por extraer la matriz P2U vigente y
convertirla en un contrato de identidad por puesto sin conectar al servidor.
