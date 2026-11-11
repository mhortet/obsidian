---
title: "Plan de ejecución P0 de preparación para producción"
type: plan
status: active
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md"
  - "docs/01_gobierno_y_decisiones/DECISION-CICLO-VIDA-SOPORTE-RELEASE-PILOTO-2026-11-10.md"
  - "docs/05_evidencias/auditorias/LINEA-BASE-TECNICA-P0-2026-11-11.md"
tags: [qontrolmed, p0, produccion, inventario, seguridad]
review_after: 2026-11-18
---

# Plan de ejecución P0 de preparación para producción

## 1. Autorización y alcance

El propietario autorizó el 11 de noviembre de 2026 iniciar P0 después de cerrar
la reorganización documental. Esta autorización cubre preparación técnica local,
documentación y comprobaciones de solo lectura.

No autoriza:

- conexión o cambios en `srv-mm-01`;
- uso de datos reales o inspección de `.env`;
- cambios de red, firewall, MySQL o puestos del cliente;
- creación de cuentas, credenciales o certificados reales;
- construcción, instalación o publicación de una RC.

## 2. Punto de partida

- Commit estructural: `907648df368312f985e7797eed5a43f78cdf8234`.
- Rama P0: `codex/produccion-readiness`.
- Base histórica de `main`: `014bf7c7b3c80c514786c36d1135efe00202b7a0`.
- Estado de producto: `NO-GO`.
- Pruebas de entrada: 24 casos, todos correctos.

## 3. Entregables P0

| Entregable | Documento | Estado |
| --- | --- | --- |
| Línea base técnica | `docs/05_evidencias/auditorias/LINEA-BASE-TECNICA-P0-2026-11-11.md` | Completado localmente |
| Inventario de puestos | `docs/07_recursos/plantillas/PLANTILLA-INVENTARIO-PUESTOS-P0.md` | Plantilla creada; datos del cliente pendientes |
| Cuenta técnica MySQL | `docs/02_planes_y_arquitectura/PROPUESTA-CUENTA-TECNICA-MYSQL-P0-2026-11-11.md` | Propuesta técnica; no ejecutada |
| Reconciliación TLS/CA | `docs/03_operacion_y_runbooks/RUNBOOK-RECONCILIACION-TLS-CA-P0-2026-11-11.md` | Análisis completado; integración pendiente de P1 |
| Riesgos, puertas y responsables | `docs/01_gobierno_y_decisiones/MATRIZ-P0-RIESGOS-PUERTAS-Y-RESPONSABLES-2026-11-11.md` | Activo; decisiones externas abiertas |
| Matriz de pruebas | Incluida en la matriz P0 y ampliable en P1-P3 | Base definida |

## 4. Trabajo realizado

### P0.1. Preservación y rama

1. Se ejecutaron las 24 pruebas locales.
2. Se comprobó el diff y la ausencia de patrones básicos de secretos.
3. Se creó el commit estructural `907648d`.
4. Se creó `codex/produccion-readiness` desde ese commit.

### P0.2. Integridad e inventario del repositorio

- `git fsck --full` terminó con código 0.
- Persisten objetos colgantes históricos; no se borrarán en este bloque.
- El índice contiene 290 rutas y ninguna bajo los patrones de runtime/build
  prohibidos revisados.
- Se identificaron ramas, tags, worktrees, dependencias, workflows, scripts,
  migraciones y pruebas.

### P0.3. CI y dependencias

- El workflow remoto más reciente de seguridad terminó globalmente como
  `success`, pero el trabajo `Dependency audit` terminó en `failure`.
- `Bandit SAST` y `Gitleaks secrets scan` terminaron correctamente.
- Los tres trabajos siguen declarados con `continue-on-error: true`, por lo que
  el resultado global no es una puerta de release fiable.
- Localmente Bandit no encontró problemas medios o altos.
- `pip-audit` y Gitleaks no están instalados localmente; no se simula su
  resultado. P1 debe fijar un entorno reproducible para ambas herramientas.

### P0.4. Reconciliación del trabajo TLS

La worktree `pilot/mysql-tls-20261105` parte de la base antigua y contiene
cambios sin commit. Se han separado tres bloques:

1. política TLS y timeouts, con ocho pruebas específicas;
2. recuperación acotada de conexión, con cuatro pruebas;
3. preservación manual de ID de marcas, con tres pruebas, ajena a TLS.

No se copiará el bloque completo. La integración se hará por responsabilidades
separadas, con tests y sin mezclar el cambio de marcas.

### P0.5. Cuenta técnica y migraciones

El runtime necesita lectura y DML sobre tablas autorizadas. Se ha encontrado un
`ALTER TABLE` automático en `src/Quirofanos/services/informe_service.py`.
Conceder `ALTER` a la cuenta runtime ocultaría un defecto de arquitectura y
rompería el mínimo privilegio. La decisión P0 es:

- cuenta runtime sin DDL ni administración;
- migraciones mediante cuenta administrativa temporal y procedimiento aparte;
- retirada del `ALTER TABLE` automático antes de la puerta productiva.

## 5. Información que no puede inventarse

Queda pendiente obtener por canal protegido:

- identificadores de puestos autorizados, versión de Windows, IP o reserva DHCP
  y responsable;
- DNS estable y huella pública de la CA de sede;
- destino independiente de copia y responsable de custodia;
- contacto funcional, ventana y canal de soporte;
- autorizadores de restauración, migración y rollback;
- custodia y aprobador de releases;
- decisión de Authenticode y plazos de auditoría/documentos.

Estos datos no se publicarán en el repositorio si contienen nombres, IP,
credenciales o información sensible. Aquí se conservarán identificadores
pseudonimizados y el estado de validación.

## 6. Criterios de cierre P0

| Criterio | Estado |
| --- | --- |
| Cambios previos preservados en commit identificable | Cumplido |
| Rama P0 separada | Cumplido |
| Línea base local y remota fechada | Cumplido |
| Worktree TLS analizada sin copia ciega | Cumplido |
| Propuesta de cuenta técnica y separación runtime/migración | Cumplido documentalmente |
| Plantilla segura de inventario | Cumplido |
| Puertas, riesgos y responsables definidos | Cumplido documentalmente |
| Inventario real de puestos | Pendiente de información externa |
| Destino de copia, soporte y custodia de release | Pendiente de decisión externa |
| Nueva RC no construida | Cumplido |

P0 queda **parcialmente completado**: la preparación técnica local está
documentada; las decisiones e inventarios externos permanecen abiertos y no se
supondrán resueltos.

## 7. Reversión

- La rama estructural permanece identificada por `907648d`.
- Esta rama puede descartarse sin afectar a `main` ni al servidor.
- No se ha copiado código desde la worktree TLS.
- No se ha creado ninguna cuenta ni modificado ninguna base de datos.
