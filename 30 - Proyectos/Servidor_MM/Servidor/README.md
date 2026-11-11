---
title: "Mapa del proyecto Servidor_MM"
type: project
status: active
created: 2026-11-01
updated: 2026-11-06
sources: []
tags: [documentacion, arquitectura, gobierno]
review_after: 2027-02-01
---

# Servidor_MM

## Documento maestro para el cliente

[Documentación del servidor Ubuntu y guía de mantenimiento](DOCUMENTACION-SERVIDOR-UBUNTU.md) — documento único de referencia para entrega, estado confirmado, configuración, actuaciones, pruebas, mantenimiento y pendientes. Actualizar siempre ese mismo archivo y añadir cada modificación a su historial. Los documentos fechados se conservan como fuentes y antecedentes; sus pendientes históricos pueden haberse resuelto después.

Proyecto para convertir `srv-mm-01` en un servidor seguro para una pyme sanitaria, limitado a información sobre instalaciones, equipos, mantenimiento y documentación técnica. Quedan fuera los datos de pacientes y la información clínica.

## Próxima sesión — auditoría no intrusiva propuesta

Cierre seguro confirmado el 06/11: SFTPGo `inactive/disabled`, `cloudflared inactive/masked`, MySQL `inactive/disabled`, sin listeners del bloque ni unidades fallidas. El túnel local quedó cerrado, la identidad SSH retirada y el agente vacío.

- [Estado final de aceptación](00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md).
- [Pruebas funcionales WebClient](05_evidencias/ACEPTACION-FUNCIONAL-WEBCLIENT-2026-11-06.txt).
- [Aceptación restic y cierre](05_evidencias/ACEPTACION-BLOQUE-DOMESTICO-2026-11-06.txt).
- [Diario completo del 06/11](00_seguimiento/diario/2026-11-06-preparacion-sin-datos-cliente.md).
- [Relevo vigente](CONTINUAR-SIGUIENTE-SESION.md).
- [Plan posterior a la aceptación](02_planes_y_arquitectura/PLAN-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md).
- [Inicio de la próxima sesión](03_operacion_y_runbooks/INICIAR-FASE-POST-ACEPTACION-SIN-DATOS-CLIENTE-2026-11-06.md).

El bloque doméstico ficticio está completado: descarga/sobrescritura, límites, autenticación, revocación/reversión y restauración local `restic` superadas. La copia sigue siendo local, no independiente ni 3-2-1. Aunque siguen faltando decisiones del cliente, se ha preparado una fase no intrusiva de auditoría remota de solo lectura y trabajo local parametrizado. El plan está propuesto y no autoriza cambios en el servidor; producción, datos reales y recursos Cloudflare continúan excluidos.

## Entradas principales

- [Revalidación del 2026-11-05](00_seguimiento/estados/ESTADO-REVALIDACION-SRV-MM-01-2026-11-05.md): comprobaciones actuales y límites de la auditoría.
- [Propuesta MySQL del 2026-11-05](02_planes_y_arquitectura/PROPUESTA-MYSQL-SRV-MM-01-2026-11-05.md): piloto doméstico aceptado; cambios técnicos pendientes de aprobación.
- [Diario del 2026-11-05](00_seguimiento/diario/2026-11-05-revalidacion-y-plan-piloto-mysql.md).

- [Continuar la próxima sesión](CONTINUAR-SIGUIENTE-SESION.md): relevo corto y autosuficiente.
- [Estado operativo del 2026-11-01](00_seguimiento/estados/ESTADO-OPERATIVO-SRV-MM-01-2026-11-01.md): fuente vigente del estado técnico.
- [Diario del 2026-11-01](00_seguimiento/diario/2026-11-01-cierre-red-mysql-actualizaciones.md): cronología y decisiones de la sesión.
- [Guía didáctica del cierre seguro](04_guias_didacticas/GUIA-DIDACTICA-RESERVA-DHCP-MYSQL-Y-REINICIO-SEGURO-2026-11-01.md): explicación paso a paso.
- [Plantilla de estructura y rutina](07_recursos/plantillas/PLANTILLA-ESTRUCTURA-Y-RUTINA-DE-PROYECTO.md): patrón para futuros proyectos.

## Estructura

| Carpeta | Finalidad | Ejemplos |
| --- | --- | --- |
| `00_seguimiento/` | Estado actual, diario y continuidad | estados fechados, sesiones y pendientes |
| `01_gobierno_y_decisiones/` | Requisitos, alcance y decisiones | cuestionarios y decisiones de arquitectura |
| `02_planes_y_arquitectura/` | Diseños y planes aún no ejecutados | SFTPGo, Cloudflare, Qontrolmed y acceso remoto |
| `03_operacion_y_runbooks/` | Procedimientos operativos | instalación, recuperación y runbooks |
| `04_guias_didacticas/` | Explicaciones formativas reutilizables | red, SSH, UFW, DHCP, MySQL y reinicios |
| `05_evidencias/` | Evidencia sin reinterpretar | auditorías, registros e imágenes |
| `06_herramientas/` | Scripts y configuraciones técnicas | auditorías, actualizaciones y SSH |
| `07_recursos/` | Plantillas y material de apoyo | rutina documental para nuevos proyectos |
| `90_archivo/` | Material histórico o sustituido | auditoría Windows inicial y relevos anteriores |

## Reglas documentales

1. La raíz contiene `AGENTS.md`, este mapa, el relevo vigente y `DOCUMENTACION-SERVIDOR-UBUNTU.md`, documento maestro de entrega y mantenimiento.
2. Cada sesión relevante produce una entrada de diario y, si cambia el estado, un registro fechado.
3. `CONTINUAR-SIGUIENTE-SESION.md` siempre refleja el punto seguro más reciente.
4. Una propuesta no equivale a autorización de ejecución.
5. Evidencia, interpretación y decisión se mantienen separadas.
6. No se guardan credenciales, claves, frases secretas, tokens, `.env` ni datos de pacientes.
7. Los nombres conservan fecha ISO `AAAA-MM-DD` cuando el contenido puede caducar.
8. Los documentos sustituidos se archivan; no se borran sin revisión.

## Rutina de sesión

```text
Leer relevo
  -> revalidar en solo lectura
  -> comparar con el estado documentado
  -> presentar propósito, riesgo, aceptación y reversión
  -> obtener aprobación del plan (una vez por alcance)
  -> ejecutar los pasos incluidos y documentar resultados
  -> verificar desde dentro y desde fuera
  -> actualizar estado, diario y relevo
```

## Estado resumido

A 2026-11-06, `srv-mm-01` usa temporalmente la LAN doméstica `192.168.1.0/24` y tiene reserva DHCP `192.168.1.31` para la MAC `74:fe:48:67:be:cc`. El kernel activo documentado es `6.8.0-147-generic`. SSH funciona por clave y UFW está activo. MySQL 8.4.11 y SFTPGo están `disabled/inactive`; `cloudflared` está `masked/inactive`; no hay puertos del bloque en escucha. La red del cliente `192.168.0.0/24` continúa sin validarse en sede.

Revalidación del 2026-11-05: SSH disponible, MySQL detenido/deshabilitado y sin escucha 3306/33060; sistema sin fallos ni reinicio pendiente. Aceptado piloto doméstico de un puesto con datos ficticios. No se han aplicado cambios de configuración; las reglas UFW requieren revalidación con sudo.


Último estado del piloto: [cambio 01 aplicado y verificado](00_seguimiento/estados/ESTADO-CAMBIO-01-PILOTO-2026-11-05.md). [Cambio 02: arranque local breve](02_planes_y_arquitectura/CAMBIO-02-PILOTO-ARRANQUE-LOCAL-2026-11-05.md), pendiente de aprobación.


Última comprobación: [cambio 02 ejecutado, prueba sin TLS inconclusa y parada confirmada](00_seguimiento/estados/ESTADO-CAMBIO-02-PILOTO-2026-11-05.md). [Cambio 03: certificado del piloto](02_planes_y_arquitectura/CAMBIO-03-PILOTO-CERTIFICADO-2026-11-05.md), pendiente de autorización.


Autorización vigente: una aprobación del plan cubre sus pasos, pruebas y reversión; no se solicita permiso individual para acciones ya incluidas. Véase AGENTS.md, sección Autorización por plan.


Último estado: [certificado del piloto instalado y configuración validada](00_seguimiento/estados/ESTADO-CAMBIO-03-PILOTO-2026-11-05.md). MySQL sigue detenido; pendientes conexión TLS autenticada, aplicación y pruebas LAN/recuperación.


Último resultado: [fase local con TLS correcto y prueba negativa pendiente](00_seguimiento/estados/ESTADO-PILOTO-LOCAL-INTENTO-01-2026-11-05.md). Continuación --resume preparada; MySQL detenido, cuenta piloto bloqueada.


Último estado: [fase local completada y ventana LAN preparada](00_seguimiento/estados/ESTADO-PILOTO-LOCAL-COMPLETADO-2026-11-05.md). MySQL detenido; siguiente fase del plan ya autorizado: prueba desde este PC.


Último estado: [conexiones Qontrolmed LAN probadas y cerradas; preparación funcional pendiente](00_seguimiento/estados/ESTADO-PILOTO-LAN-Y-PREPARACION-FUNCIONAL-2026-11-05.md).


Último estado: [33 tablas funcionales y aplicación aislada listas; interfaz pendiente](00_seguimiento/estados/ESTADO-ESTRUCTURA-FUNCIONAL-Y-GUI-2026-11-05.md). El relevo vigente está resumido y sustituye las notas históricas de pasos pendientes ya completados.


Último estado: [servicios parcialmente probados y corrección aislada de marcas preparada](00_seguimiento/estados/ESTADO-SERVICIOS-Y-AJUSTE-MARCAS-2026-11-05.md). Revisión visual pendiente por fallo de captura; servidor cerrado y detenido.


Decisión vigente: [conservar ID manuales históricos y corregir el alta de marcas](01_gobierno_y_decisiones/DECISION-IDS-MARCAS-MANUALES-2026-11-05.md). Propuesta de autoincremento retirada; MySQL detenido y prueba de integración pendiente.


Estado vigente: [cierre técnico del piloto, ID manual comprobado y pendientes de aceptación](00_seguimiento/estados/CIERRE-TECNICO-PILOTO-DOMESTICO-2026-11-05.md). Servidor detenido y acceso temporal cerrado; el relevo anterior ha sido sustituido por un resumen actual.


Último resultado: [restauración funcional completa del piloto](00_seguimiento/estados/ESTADO-RESTAURACION-FUNCIONAL-COMPLETA-2026-11-05.md). Las 33 tablas funcionales ficticias fueron copiadas y restauradas en destinos nuevos con comparación de tablas, filas, columnas, índices y relaciones. MySQL quedó detenido/deshabilitado y sin puertos; siguen pendientes revisión visual, segundo origen LAN y aceptación del código/empaquetado.


Revisión posterior: [código funcional correcto y empaquetado bloqueado por provisión de CA](00_seguimiento/estados/REVISION-CODIGO-Y-EMPAQUETADO-QONTROLMED-2026-11-05.md). Suite 39/39 y ZIP sin secretos coincidente; no instalar una RC hasta alinear plantilla, instalador, configurador, verificador y tests con la CA pública de sede.


Prioridad de despliegue: [preparar accesos y recuperación antes del traslado](01_gobierno_y_decisiones/DECISION-PREPARAR-TODO-ANTES-TRASLADO-2026-11-05.md). [Plan propuesto de preparación doméstica y puesta en sede](02_planes_y_arquitectura/PLAN-PREPARACION-PREVIA-Y-PUESTA-EN-SEDE-2026-11-05.md): SFTPGo WebClient + Access, plano SSH privado separado, copia independiente, recuperación de energía/LUKS y simulación de la red del cliente. Pendiente de completar datos y aprobar el plan ejecutable.


Arranque preparado: [sesión del 2026-11-06 sin datos completos del cliente](03_operacion_y_runbooks/INICIAR-PREPARACION-SIN-DATOS-CLIENTE-2026-11-06.md). El correo de solicitud quedó programado para las 08:00; su respuesta no condiciona la auditoría, el diseño ni la preparación local segura. Dominio/DNS, cuenta Cloudflare, red de sede, copia externa y recuperación LUKS se incorporarán por bloques cuando estén confirmados.


Estado final del 06/11: [bloque doméstico SFTPGo/restic aceptado y cerrado](00_seguimiento/estados/ESTADO-ACEPTACION-BLOQUE-DOMESTICO-SIN-DATOS-CLIENTE-2026-11-06.md). MySQL/Qontrolmed siguen detenidos; no existen recursos Cloudflare reales y la producción permanece pendiente.


