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

## Entrada coordinada

Esta sesión puede iniciarse desde esta carpeta o desde `H:\02.Trabajo\obsidian\30 - Proyectos\Servidor_MM\Servidor`. En ambos casos se deben leer los `AGENTS.md` y relevos de `Qontrolmed` y `Servidor_MM` antes de ejecutar trabajo transversal. La aplicación y la infraestructura conservan fuentes de verdad y autorizaciones separadas; véase `AGENTS.md`.

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
- Validación remota P1 cerrada mediante GitHub web: CI #69 y Security Checks
  #58 correctos para `7c4a331`; `pip-audit`, Bandit y Gitleaks finalizaron
  correctamente como controles bloqueantes.
- Inventario estático P2 creado: 20 scripts base, 2 bootstrap y 11 migraciones;
  no existe ledger ni orden canónico y solo la migración de técnico de cierre
  declara precheck, postcheck y restauración de forma completa.
- Plan P2A propuesto para gobierno local de esquema, sin conexión ni DDL.
- Diagnóstico de `gh` cerrado: la credencial del llavero es válida y permite
  consultar el repositorio y Actions desde el contexto con acceso al llavero;
  el `401` solo aparece en el sandbox ordinario de Codex, que no puede leerla.
- CI y Security Checks del commit documental `19e5fdc` finalizaron
  correctamente en los runs `43079524608` y `43079524648`.
- P2A implementado localmente: manifiesto de migraciones de formato 1,
  validador sin ejecución SQL, utilidad CLI y primer caso piloto para
  `quirofanos_tecnico_cierre`.
- Validación P2A: 55 pruebas correctas y Bandit sin hallazgos medios/altos;
  `pip-audit` local quedó no concluyente por espera superior a 90 segundos sin
  salida. No se cambiaron dependencias.
- P2A publicado en `1a6966b` y `e62f23c`; CI `43081859463` y Security Checks
  `43081859180` correctos.
- Contrato lógico de ledger definido sin SQL ejecutable: runtime de solo
  lectura, fallo cerrado y estados `compatible`, `migration-required`,
  `inconsistent` y `unsupported-newer`.
- P2B implementado localmente sin servidor: SQL administrativo no ejecutado,
  comprobador puro de compatibilidad y 13 pruebas nuevas.
- Validación P2B: 68 pruebas correctas, compilación y manifiesto correctos y
  Bandit sin hallazgos medios/altos.
- Publicación documental unidireccional a Obsidian definida mediante una
  selección explícita, comparación SHA-256 e índice de procedencia. Qontrolmed
  permanece como única fuente oficial; el destino de consulta no se importa ni
  se limpia automáticamente.

## Pendiente inmediato

1. Revisar, versionar y publicar P2B; comprobar CI y Security Checks remotos.
2. Preparar un plan independiente para la prueba integrada del ledger contra
   MySQL sintético; no arrancar ni usar el servidor hasta que ese plan defina
   versión, cuenta, destino, precheck, postcheck y reversión.
3. Mantener como pendientes de sede el inventario real de puestos, DNS/CA y
   destino de copia independiente; no bloquean el desarrollo local.
4. Ejecutar futuras consultas autenticadas de `gh` desde el contexto autorizado
   con acceso al llavero; no repetir el login mientras la comprobación elevada
   siga siendo correcta.
5. Resolver la revisión de objetos Git como `conservar`, `recuperar` o
   `descartar`; cualquier poda requerirá un bloque posterior independiente.
6. No integrar el cambio histórico de marcas ni construir una RC hasta superar
   las puertas P2 y posteriores.

## Límites actuales

- Qontrolmed sigue en estado **NO-GO para producción o distribución
  comercial**; el objetivo es un piloto privado controlado.
- No usar datos reales ni abrir MySQL del servidor hasta revalidar estado,
  TLS/CA, cuentas, firewall, puestos y copias.
- No construir una nueva RC antes de cerrar P0 y P1.
- No editar `consulta_publicada` como fuente ni recuperar cambios desde
  Obsidian. Al final de cada sesión relevante, revisar el manifiesto y ejecutar
  `python scripts/documentacion/publicar_obsidian.py --comprobar`; publicar
  solo si aparecen cambios seleccionados.

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
