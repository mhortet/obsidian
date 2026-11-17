---
title: "Especificaciones operativas del piloto"
type: state
status: active
created: 2026-11-16
updated: 2026-11-16
sources:
  - "docs/01_gobierno_y_decisiones/DECISION-ESPECIFICACIONES-OPERATIVAS-PILOTO-2026-11-16.md"
tags: [qontrolmed, sesion, decisiones, red, identidades]
review_after: 2026-12-16
---

# Sesión 2026-11-16: especificaciones operativas del piloto
[[masgesth]]

## Objetivo y motivo

- Contrastar las especificaciones comunicadas por el propietario con las
  fuentes vigentes de Qontrolmed y Servidor_MM y consolidar una formulación
  inequívoca.

## Punto seguro y límites

- Rama de trabajo: `codex/produccion-readiness`.
- El árbol estaba limpio antes de esta actualización documental.
- No se modificaron código, servidor, MySQL, cuentas, red, firewall ni datos.

## Pasos, comandos y aprendizaje

### Paso 1. Contraste documental

```powershell
rg -n -i "192\.168\.0\.0/24|Puestos autorizados|Cuenta técnica|datos personales|túnel SSH" docs "H:\02.Trabajo\obsidian\30 - Proyectos\Servidor_MM\Servidor"
```

- **Motivo**: separar hechos vigentes, decisiones pendientes y terminología
  ambigua antes de redactar.
- **Tipo de acción**: lectura.
- **Resultado observado**: la red de sede ya constaba como dato comunicado;
  faltaba consolidar el máximo de puestos y la separación completa de
  identidades. La documentación ya excluía datos clínicos, pero protegía los
  datos personales identificativos.

### Paso 2. Consolidación de la decisión

- **Motivo**: evitar que «usuario de gestión» y «superusuario» se interpreten
  como cuentas globales de MySQL.
- **Tipo de acción**: cambio documental reversible mediante Git.
- **Resultado observado**: se creó una decisión con tres identidades
  separadas, capacidad prevista, red de sede y alcance de datos; se enlazó
  desde el plan y el relevo.
- **Reversión**: revertir exclusivamente los cambios documentales de esta
  sesión.

## Cambios cerrados

- Máximo previsto de cuatro o cinco puestos concurrentes.
- Direcciones estables mediante reservas DHCP del router.
- LAN de sede `192.168.0.0/24`, pendiente de validación in situ.
- Separación entre administrador funcional, cuenta técnica de aplicación y
  administrador técnico.
- Exclusión de datos de pacientes y clínicos, conservando la protección de los
  datos personales mínimos de usuarios y técnicos.

## Validaciones realizadas

- Revisión de las fuentes vigentes de ambos proyectos.
- Validación posterior de JSON, enlaces, diff y publicación curada.

## Observado, inferido y decidido

### Observado

- La red de sede constaba como comunicada, no validada.
- El acceso administrativo validado hasta ahora usa SSH por clave y túnel.

### Inferido

- «Superusuario» podía confundirse con una cuenta global de MySQL y requería
  una denominación más precisa.

### Decidido

- La formulación consolidada queda en la decisión del 16/11.

## Riesgos y pendientes

- Falta comprobar en sede direccionamiento, reservas, DNS, gateway y
  solapamientos.
- Falta una prueba de concurrencia proporcional a cuatro o cinco puestos.
- La decisión documental no autoriza cambios operativos.

## Siguiente paso recomendado

- Incorporar estos parámetros al futuro plan transversal de instalación y
  aceptación en sede.

