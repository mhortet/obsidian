---
title: "Decisión de ciclo de vida, soporte y release del piloto"
type: decision
status: approved
created: 2026-11-10
updated: 2026-11-10
sources:
  - "docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md"
tags: [qontrolmed, piloto, retencion, soporte, release]
review_after: 2027-02-10
---

# Decisión de ciclo de vida, soporte y release del piloto

## Contexto

Qontrolmed es desarrollado y mantenido por un único programador para un piloto
B2B en una única PYME cliente. Se priorizan simplicidad operativa,
automatización ligera y bajo mantenimiento, sin rebajar las garantías de copia,
trazabilidad, validación y reversión necesarias en un entorno sanitario.

## Retención

- Versionado SemVer estricto mediante tags anotados `vX.Y.Z`; las candidatas
  pueden usar `vX.Y.Z-rc.N`.
- El historial Git se conserva completo en el repositorio y en un remoto
  verificado. Git no sustituye a la copia de seguridad de datos.
- Copia diaria automatizada de los tres esquemas MySQL y de la configuración y
  ficheros declarados fuente de verdad.
- Retención mínima del piloto: 7 copias diarias y 3 mensuales. Si el tamaño lo
  permite, objetivo recomendado: 7 diarias, 4 semanales y 6 mensuales.
- Al menos una copia será independiente del servidor, cifrada y monitorizada.
- La poda solo se ejecutará después de validar la nueva copia. Se realizarán
  restauraciones periódicas en entorno aislado.
- Logs técnicos locales: rotación, compresión y máximo de 15 días, sin secretos
  ni datos sensibles.
- La auditoría funcional de Qontrolmed tendrá una retención separada, acordada
  con el cliente; no se elimina con la rotación de logs técnicos.
- PDF y certificados se conservarán según su condición de fuente documental y
  quedarán cubiertos por copia y restauración.
- Exportaciones móviles y temporales se eliminarán tras confirmar su importación
  y vencer el plazo operativo que se fije en el runbook.
- Se conservan localmente la build productiva y N-1. Para todas las versiones se
  mantienen tag, notas, hashes, manifiesto y resultado de validación.

## Soporte y mantenimiento

- Solo se soporta la última versión desplegada. No habrá ramas LTS ni parches
  retroactivos para versiones anteriores.
- Soporte asíncrono, sin cobertura 24/7.
- Las incidencias críticas tienen prioridad inmediata dentro de la ventana de
  soporte acordada. Mejoras y defectos menores se agrupan en ciclos mensuales.
- Antes del piloto deben fijarse horario y días, canal de aviso, contacto
  funcional del cliente, niveles de severidad y quién autoriza restauraciones,
  migraciones y rollbacks.
- El administrador del servidor es responsable técnico primario. Los defectos
  de aplicación escalan al desarrollador con evidencia depurada.
- Observabilidad ligera: errores claros, trazas locales, versión de aplicación y
  esquema, antigüedad del backup, espacio libre y fallos de conexión, auditoría
  o migración.
- Se preparará una exportación diagnóstica depurada, sin credenciales, secretos
  ni datos sensibles.

## Release y despliegue

- Solo existen dos entornos permanentes: `dev` y `prod`.
- Entre ambos habrá una validación RC efímera con datos ficticios:
  `dev → tag → build limpio → validación RC → prod`.
- Releases mensuales o bajo demanda para hotfixes críticos.
- No se ejecutará `git pull + build` en producción.
- El paquete se construye fuera del equipo productivo desde un tag, es inmutable
  e incluye versión, SHA-256, manifiesto, SBOM, notas y evidencia de pruebas.
- El despliegue utiliza los scripts PowerShell controlados del repositorio en
  una ventana de mantenimiento.
- El rollback del ejecutable debe poder restaurar N-1. Si existen migraciones de
  base de datos, N-1 solo será válido si el esquema es compatible; en caso
  contrario se aplicará la restauración documentada de la copia previa.
- La firma Authenticode puede aplazarse durante el piloto, pero hash, tag,
  custodia controlada y rollback probado son obligatorios.

## Pendientes de concreción en P0/P2

1. Ubicación y credenciales del destino de copia independiente.
2. Aceptación del cliente de la matriz de retención, especialmente auditoría,
   PDF y certificados.
3. Ventana, canal, contacto y severidades de soporte.
4. Plazo operativo de exports y temporales.
5. Decisión definitiva sobre Authenticode.

Estos pendientes concretan la operación; no reabren el modelo aprobado.
