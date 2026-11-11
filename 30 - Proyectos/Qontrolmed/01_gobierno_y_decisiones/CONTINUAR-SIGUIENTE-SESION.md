---
title: "Continuar siguiente sesión de Qontrolmed"
type: state
status: active
created: 2026-11-10
updated: 2026-11-11
tags: [qontrolmed, continuidad, produccion]
review_after: 2026-11-17
---

# Continuar siguiente sesión

## Punto seguro

- Rama de trabajo: `codex/produccion-readiness`.
- Base P0: `907648df368312f985e7797eed5a43f78cdf8234`.
- La reorganización quedó cerrada en la rama
  `codex/estructura-documental-20261110` con ese mismo commit.
- P1 local ha modificado código de conexión, guarda de esquema, dependencias y
  scripts de instalación; no se ha modificado servidor, MySQL real ni `.env`.
- No se ha construido ni instalado una RC.
- `compartido/.env` permanece local, ignorado y sin inspeccionar.
- La revisión de 11 de noviembre no tocó código funcional, servidor ni datos.

## Bloque realizado

- Reorganización documental por función.
- Consolidación de los dos árboles históricos en `docs/90_archivo/`.
- Creación de `AGENTS.md`, `README.md` y este relevo.
- Actualización del plan de producción con las decisiones comunicadas el 10 de
  noviembre de 2026.
- Conservación del backlog evolutivo y de sus cambios locales previos.
- Limpieza física completa de aproximadamente 3,26 GiB de builds,
  distribuciones, runtime versionado, exports, certificados locales, binarios
  legados y caches.
- Aprobación del modelo solo-dev/B2B de retención, soporte y release, registrado
  en `docs/01_gobierno_y_decisiones/DECISION-CICLO-VIDA-SOPORTE-RELEASE-PILOTO-2026-11-10.md`.
- Revisión inicial del diff estructural: 1.966 cambios preparados, sin
  diferencias adicionales en el árbol y sin errores de `git diff --check`.
- Estado final tras añadir la trazabilidad didáctica: 1.970 ficheros cambiados,
  290 rutas resultantes y 0 rutas bajo los patrones de runtime/build revisados.
- Validación final de enlaces Markdown activos: 52 documentos examinados, 7 enlaces
  relativos comprobados y 0 destinos ausentes.
- Revalidación local: 24 pruebas superadas.
- Creación de una guía didáctica viva y una bitácora formativa de sesión.
- Commit estructural creado: `907648d`.
- Rama P0 creada desde el commit estructural.
- Línea base técnica local/remota, worktrees, CI, dependencias y seguridad
  registradas sin conectar al servidor.
- Reconciliación estática de la worktree TLS: separados TLS, recuperación de
  conexión e ID manual de marcas; no se ha copiado código.
- Propuestas P0 creadas para cuenta técnica MySQL, CA/TLS, inventario de puestos,
  riesgos, responsables y puertas.
- Hallazgo P0: existe un `ALTER TABLE` automático en runtime que debe retirarse;
  no se concederá DDL a la cuenta productiva.
- Inventario de objetos Git colgantes creado: 11 blobs documentales, 2 commits
  WIP y 334 árboles internos; no se ha podado ningún objeto.
- P1 local autorizado íntegramente por el propietario; no requiere permisos
  paso a paso dentro del plan registrado.
- Regla general aprobada: los planes de trabajo se ejecutan completos una vez
  definidos, manteniendo alcance, límites, validaciones y reversión.
- Decisión de alcance: piloto privado de evaluación en una única empresa, sin
  venta, difusión pública ni preparación comercial obligatoria.
- P1 local implementado en commits separados: TLS verificado, recuperación de
  conexión, retirada de DDL runtime, CI bloqueante y provisión de CA.
- Validación local P1: 44 pruebas correctas, Bandit sin hallazgos medios/altos y
  auditoría directa de dependencias sin avisos conocidos.
- Rama `codex/produccion-readiness` publicada; la lectura de CI remoto quedó
  pendiente porque la autenticación de `gh` está caducada.

## Pendiente inmediato

1. Reautenticar la herramienta de GitHub y comprobar CI/Gitleaks remoto.
2. Mantener como pendientes de sede el inventario real de puestos, DNS/CA y
   destino de copia independiente; no bloquean el desarrollo local.
3. Preparar el siguiente bloque local proporcional al piloto privado.
4. Resolver la revisión de objetos Git como `conservar`, `recuperar` o
   `descartar`; cualquier poda requerirá un bloque posterior independiente.
5. Portar TLS y recuperación por commits separados; no integrar el cambio de
   marcas ni construir una RC hasta superar la puerta.

## Límites actuales

- Qontrolmed sigue en estado **NO-GO para producción o distribución
  comercial**; el objetivo es un piloto privado controlado.
- No usar datos reales ni abrir MySQL del servidor hasta revalidar estado,
  TLS/CA, cuentas, firewall, puestos y copias.
- No construir una nueva RC antes de cerrar P0 y P1.

## Lectura mínima

1. `AGENTS.md`.
2. `README.md`.
3. `docs/04_guias_didacticas/GUIA-DIDACTICA-DE-SESIONES-Y-COMANDOS.md`.
4. `docs/00_seguimiento/estados/ESTADO-REORGANIZACION-DOCUMENTAL-2026-11-10.md`.
5. `docs/00_seguimiento/diario/2026-11-11-revision-estructural-y-trazabilidad-didactica.md`.
6. `docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md`.
7. `docs/02_planes_y_arquitectura/PLAN-EJECUCION-P0-PRODUCCION-READINESS-2026-11-11.md`.
8. `docs/05_evidencias/auditorias/LINEA-BASE-TECNICA-P0-2026-11-11.md`.
9. `docs/05_evidencias/auditorias/INVENTARIO-REVISION-OBJETOS-GIT-COLGANTES-2026-11-11.md`.
10. `docs/01_gobierno_y_decisiones/DECISION-AUTORIZACION-INTEGRAL-PLANES-Y-P1-LOCAL-2026-11-11.md`.
11. `docs/02_planes_y_arquitectura/PLAN-EJECUCION-P1-LOCAL-2026-11-11.md`.
12. `docs/01_gobierno_y_decisiones/DECISION-PILOTO-PRIVADO-EVALUACION-2026-11-11.md`.

## Revalidación no destructiva

```powershell
git status --short
git diff --stat
python -m unittest discover -s tests -v
```
