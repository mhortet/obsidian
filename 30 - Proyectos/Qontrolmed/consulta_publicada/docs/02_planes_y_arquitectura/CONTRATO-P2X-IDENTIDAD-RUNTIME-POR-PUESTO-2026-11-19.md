---
title: "P2X — Contrato de identidad runtime por puesto"
type: specification
status: active
created: 2026-11-19
updated: 2026-11-19
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2X-PROVISION-PUESTOS-Y-CONEXION-SEDE-2026-11-18.md"
  - "docs/02_planes_y_arquitectura/PLAN-P2U-CUENTA-RUNTIME-MINIMO-PRIVILEGIO-2026-11-18.md"
tags: [qontrolmed, p2x, mysql, puestos, minimo-privilegio]
review_after: 2026-12-19
---

# P2X — Contrato de identidad runtime por puesto

## Regla principal

Cada instalación autorizada de Qontrolmed usa una identidad MySQL técnica y
revocable distinta. La identidad pertenece al puesto, no a una persona, y no
se comparte entre equipos. El usuario funcional de Qontrolmed continúa siendo
nominal y separado de esta cuenta técnica.

## Identificador

- Formato MySQL: `qontrolmed_rt_<codigo>@<origen>`.
- `<codigo>`: entre 3 y 12 caracteres ASCII en minúsculas, números o guion
  bajo; ejemplo ficticio `p01`.
- `<origen>`: IP estable exacta observada por MySQL. No se usará `%`, una
  subred completa ni el nombre de una persona.
- La cuenta `qontrolmed_runtime_dev@localhost` permanece reservada a la
  validación por túnel y no se copia a un puesto de sede.

La IP puede proponerse antes de la visita, pero solo se confirma tras revisar
el router, las reservas DHCP existentes y la ausencia de conflicto.

## Privilegios

La matriz canónica es la concesión exacta ya validada en P2U y materializada
en `scripts/db/plantillas_p2x/alta_identidad_runtime.sh.template`. Se prohíben:

- concesiones sobre `*.*` o esquemas completos;
- `CREATE`, `ALTER`, `DROP`, `GRANT OPTION`, `FILE`, `PROCESS`,
  `SYSTEM_USER`, `SHUTDOWN` y administración de usuarios;
- escritura en `quirofanos.qontrolmed_schema_migrations`;
- acceso a Compras, proveedores, repuestos o analítica ampliada.

La cuenta exige `REQUIRE SSL`; Qontrolmed debe verificar además la CA y la
identidad del servidor.

## Ciclo de vida

1. **Alta**: inventario validado, copia previa, nombre/origen exactos, secreto
   único introducido sin eco y grants revisados.
2. **Provisión**: CA verificada por SHA-256 y `.env` bajo ACL administrativa,
   legible pero no modificable por el usuario ordinario.
3. **Aceptación**: TLS, guard, login y módulos permitidos; denegaciones de
   origen, DDL, Compras, ledger y TLS incorrecto.
4. **Rotación**: cambio del secreto del único puesto y actualización
   coordinada de su `.env`; no se registra el secreto.
5. **Sustitución**: alta de una identidad nueva, aceptación y baja inmediata
   de la anterior. No se renombra una cuenta para ocultar el historial.
6. **Baja o incidente**: revocación de grants, eliminación de la identidad,
   comprobación de ausencia y retirada local de `.env`/CA cuando corresponda.

## Qué puede aplazarse y ejecutarse remotamente

Con un canal SSH administrativo previamente aprobado, autorización vigente y
una persona local disponible cuando afecte al puesto, pueden hacerse
remotamente el alta/baja MySQL, la rotación, la revisión de grants y la
provisión del fichero de configuración. No se presupone acceso remoto al
router ni al escritorio del cliente.

La comprobación física del adaptador/MAC, el cableado, la reserva DHCP inicial,
la prevención de conflictos, el cambio de escucha/UFW y la aceptación tras un
corte de red deben incluirse en una ventana de sede o en un procedimiento
remoto explícitamente validado. La fase B decidirá cada caso.

## Evidencia mínima sin secretos

- código de puesto, IP/origen confirmado y MAC;
- fecha, responsable y hash SHA-256 de la CA;
- estado depurado de autenticación/SSL y grants;
- resultados de aceptación y denegación;
- fecha de alta, última rotación, baja y motivo, si aplica.
