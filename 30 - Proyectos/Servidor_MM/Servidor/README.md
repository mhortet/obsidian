---
title: "Mapa del proyecto Servidor_MM"
type: project
status: active
created: 2026-11-01
updated: 2026-11-21
sources:
  - "CONTINUAR-SIGUIENTE-SESION.md"
  - "00_seguimiento/ESTADO-ACTUAL-CONSOLIDADO.md"
tags: [documentacion, arquitectura, gobierno]
review_after:
---

# Servidor_MM

Proyecto para implantar y mantener `srv-mm-01` como servidor seguro para una pyme sanitaria, limitado a información sobre instalaciones, equipos, mantenimiento y documentación técnica. Se excluyen datos de pacientes e información clínica.

## Dónde empezar

### Para continuar el trabajo técnico

1. [AGENTS.md](AGENTS.md): reglas, alcance y autorizaciones.
2. [CONTINUAR-SIGUIENTE-SESION.md](CONTINUAR-SIGUIENTE-SESION.md): punto seguro de continuación.
3. [Estado actual consolidado](00_seguimiento/ESTADO-ACTUAL-CONSOLIDADO.md): resumen vigente.
4. [Cronología maestra](00_seguimiento/CRONOLOGIA-MAESTRA.md): evolución del proyecto.

### Para el cliente

La futura entrega se encuentra en [08_entrega_cliente](08_entrega_cliente/README.md). Su estructura ya incluye uso, administración de usuarios, mantenimiento, copias, incidencias, inventario y acta. Los valores de red, túnel, puestos y responsables se completarán con evidencia de sede.

### Para consulta interna

- [Memoria técnica del servidor Ubuntu](DOCUMENTACION-SERVIDOR-UBUNTU.md).
- [Registro maestro de decisiones](01_gobierno_y_decisiones/REGISTRO-MAESTRO-DE-DECISIONES.md).
- [Registro maestro de planes](02_planes_y_arquitectura/REGISTRO-MAESTRO-DE-PLANES.md).
- [Runbook SFTPGo](03_operacion_y_runbooks/OPERAR-SFTPGO-DOCUMENTAL-2026-11-19.md).

## Estado resumido

A 21 de noviembre de 2026 están cerradas las fases `equipo actual` y `portátil`. La siguiente fase es `sede` y requiere un plan específico aprobado basado en inventario real.

- MySQL: último estado coordinado `active/enabled`, solo en `127.0.0.1:3306`.
- SFTPGo: `inactive/disabled`.
- Cloudflared: `inactive/masked`, sin túnel, DNS, token o recurso real.
- Consola: aceptada con Intel integrada y `nomodeset`; NVIDIA retirada.
- Copia restic: ensayo local correcto, pero no independiente ni 3-2-1.
- Qontrolmed: RC y kit preparados; conexión e instalación en sede todavía no autorizadas.

No deben trasladarse a producción la IP doméstica, cuentas ficticias, certificados de ensayo o identidades temporales.

## Estructura

| Ruta | Finalidad |
| --- | --- |
| `00_seguimiento/` | Estado vigente, cronología, diarios y estados fechados |
| `01_gobierno_y_decisiones/` | Decisiones originales y registro maestro |
| `02_planes_y_arquitectura/` | Planes, cambios y registro maestro |
| `03_operacion_y_runbooks/` | Procedimientos técnicos operativos |
| `04_guias_didacticas/` | Explicaciones formativas y aprendizaje |
| `05_evidencias/` | Evidencia original sin reinterpretar |
| `06_herramientas/` | Scripts, configuraciones y datos de prueba |
| `07_recursos/` | Plantillas y material de apoyo |
| `08_entrega_cliente/` | Manuales y acta destinados al cliente |
| `90_archivo/` | Material histórico o sustituido |

## Reglas documentales

1. Actualizar primero el estado vigente y después los registros maestros afectados.
2. Conservar separadas fuente, interpretación, decisión y procedimiento.
3. Marcar los documentos como vigentes, ejecutados, sustituidos o históricos; no confiar solo en la fecha.
4. No borrar originales por haberlos consolidado.
5. No guardar credenciales, claves, frases secretas, tokens, `.env` reales ni datos de pacientes.
6. Toda configuración de sede debe proceder de observación o confirmación, nunca de una IP o valor doméstico anterior.
7. La versión exacta entregada al cliente se conserva de forma inmutable y se identifica en el acta.

## Rutina de trabajo

```text
Leer reglas y relevo
  -> revalidar sin cambios
  -> preparar plan con riesgo, aceptación y reversión
  -> obtener aprobación del alcance
  -> ejecutar y validar
  -> actualizar evidencia, estado, decisiones y entrega
```

Una aprobación cubre los pasos incluidos en el plan. Se solicita una nueva aprobación solo ante ampliación material, riesgo no contemplado o decisión que no pueda deducirse con seguridad.
