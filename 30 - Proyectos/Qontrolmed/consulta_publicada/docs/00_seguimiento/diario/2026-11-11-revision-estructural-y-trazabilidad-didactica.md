---
title: "Revisión estructural y trazabilidad didáctica"
type: state
status: active
created: 2026-11-11
updated: 2026-11-11
sources:
  - "CONTINUAR-SIGUIENTE-SESION.md"
  - "docs/00_seguimiento/estados/ESTADO-REORGANIZACION-DOCUMENTAL-2026-11-10.md"
  - "docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md"
tags: [qontrolmed, sesion, formacion, git, validacion]
review_after: 2026-11-18
---

# Sesión 2026-11-11: revisión estructural y trazabilidad didáctica

## 1. Objetivo

Retomar el proyecto desde el relevo del 10 de noviembre, revisar de forma no
destructiva la reorganización ya preparada e implantar un registro didáctico
mantenible para las siguientes sesiones.

## 2. Límites aplicados

- No se utilizó ningún dato real ni se inspeccionó `compartido/.env`.
- No se conectó con MySQL, el servidor ni los puestos del cliente.
- No se construyó ni instaló una RC.
- No se modificó código funcional.
- Los cambios previos del árbol se preservaron.

## 3. Lectura de entrada

Se leyeron `AGENTS.md`, `README.md`, `CONTINUAR-SIGUIENTE-SESION.md`, el estado
de la reorganización, el plan de adaptación documental, la auditoría y plan de
producción, la decisión de ciclo de vida y las reglas del diario.

Comando base:

```powershell
Get-Content -Raw -LiteralPath '<ruta-del-documento>'
```

**Motivo**: conocer el punto seguro, los límites y el plan vigente antes de
actuar.

**Qué hace**: `Get-Content` lee el fichero; `-Raw` conserva el documento como un
bloque; `-LiteralPath` evita interpretar la ruta como un patrón.

**Resultado**: se confirmó que la rama activa debía revisar primero el diff y
los enlaces; P0 solo permite preparación técnica local y mantiene prohibidos
servidor, datos reales y construcción de RC.

## 4. Localización del bloque P0

Comando representativo:

```powershell
rg -n -C 8 "P0|inventario técnico|cuenta técnica" docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md
```

**Motivo**: localizar las acciones, aceptación y límites exactos de P0 sin
basarse en memoria o resúmenes.

**Qué hace**: `rg` busca texto; `-n` añade números de línea y `-C 8` muestra
ocho líneas de contexto alrededor de cada coincidencia.

**Resultado**: P0 exige preservar cambios, fijar línea base, reconciliar el
trabajo TLS, confirmar decisiones y crear riesgos/puertas, sin construir RC.

## 5. Revisión del estado Git

### 5.1. Estado general

```powershell
git status --short --branch
git status --porcelain=v1
```

**Motivo**: detectar cambios que deban preservarse y diferenciar índice y árbol
de trabajo.

**Resultado observado**:

- rama `codex/estructura-documental-20261110`;
- todos los cambios existentes estaban preparados en el índice;
- no había cambios adicionales sin preparar;
- tipos preparados: 11 altas, 3 modificaciones, 1.860 eliminaciones y 92
  renombres.

Las eliminaciones masivas corresponden principalmente a runtime y binarios
versionados retirados en la sesión anterior. Este recuento no autoriza por sí
solo el commit: debe interpretarse junto al resumen y la validación.

### 5.2. Base exacta

```powershell
git rev-parse HEAD
git branch --show-current
git log -1 --format='%H%n%ad%n%s' --date=iso-strict
```

**Motivo**: dejar una referencia reproducible de la base revisada.

**Resultado observado**:

- `HEAD`: `014bf7c7b3c80c514786c36d1135efe00202b7a0`;
- rama: `codex/estructura-documental-20261110`;
- último commit de la base: 18 de julio de 2026.

### 5.3. Tamaño y formato del diff

```powershell
git diff --shortstat
git diff --cached --shortstat
git diff --check
git diff --cached --check
git diff --cached --summary
git diff --cached --name-status
```

**Motivo**: distinguir cambios no preparados de cambios preparados, medir el
alcance y detectar errores básicos de formato.

**Resultado observado**:

- árbol de trabajo frente al índice: sin diferencias;
- índice frente a `HEAD`: 1.966 ficheros, 1.565 inserciones y 774.416
  eliminaciones;
- ambos `diff --check` terminaron sin errores;
- el resumen confirmó la reorganización documental, la retirada de runtime y
  binarios y los movimientos de fixtures y scripts ya documentados.

`git diff --check` no verifica lógica, enlaces ni tests; solo determinados
problemas de formato del diff.

### 5.4. Ficheros todavía versionados

```powershell
git ls-files
git ls-files '_internal/**' 'build/**' 'dist/**' 'build_rc/**' 'dist_rc/**' 'output/**'
```

**Motivo**: confirmar que el índice ya no conserva artefactos de runtime o
build prohibidos por las reglas del repositorio.

**Resultado observado**:

- 288 rutas versionadas en el índice;
- 0 rutas versionadas bajo los patrones de runtime y build revisados.

La comprobación cubre esos patrones concretos; no reemplaza una auditoría
completa de supply chain.

## 6. Validación de enlaces Markdown activos

Se ejecutó un bloque PowerShell de solo lectura que:

1. reunió `AGENTS.md`, `README.md`, `CONTINUAR-SIGUIENTE-SESION.md` y los
   documentos Markdown activos fuera de `docs/90_archivo/`;
2. extrajo enlaces Markdown relativos;
3. excluyó URL web, correo y anclas internas;
4. resolvió cada destino desde la carpeta del documento de origen;
5. comprobó la existencia con `Test-Path -LiteralPath`.

**Motivo**: detectar referencias rotas causadas por la reorganización sin tratar
el histórico como fuente vigente.

**Resultado observado en la primera pasada**: 50 documentos activos examinados,
5 enlaces relativos comprobados y 0 destinos ausentes.

Después de crear la guía y esta bitácora se repitió la comprobación: 52
documentos activos, 7 enlaces relativos y 0 destinos ausentes.

**Límite**: esta comprobación no valida enlaces externos, enlaces dinámicos,
anclas dentro de un documento ni referencias escritas solo como texto o código.

## 7. Pruebas automatizadas

```powershell
python -m unittest discover -s tests -v
```

**Motivo**: ejecutar la revalidación indicada en el relevo y comprobar que la
reorganización no ha roto la batería local disponible.

**Qué hace**: ejecuta el módulo estándar `unittest`, descubre pruebas desde
`tests/` y muestra cada caso en modo detallado.

**Resultado observado**: 24 pruebas ejecutadas en 0,178 segundos; todas
terminaron correctamente con `OK`.

**Límite**: estas 24 pruebas no cubren suficientemente autenticación,
autorización, auditoría, TLS, migraciones, concurrencia, recuperación ni la
integración real con MySQL. Qontrolmed continúa en estado `NO-GO`.

## 8. Cambios documentales de esta sesión

- creación de la guía didáctica viva de sesiones, comandos y términos;
- creación de esta nota de sesión;
- ampliación de la plantilla y reglas del diario;
- incorporación de la guía a la lectura obligatoria de `AGENTS.md`;
- actualización del `README.md`, el estado de reorganización y el relevo.

Todos estos cambios son reversibles mediante Git antes de cualquier despliegue.
No introducen datos reales ni secretos.

Los ocho documentos creados o actualizados se prepararon con:

```powershell
git add -- <lista-explícita-de-ocho-rutas>
```

**Motivo**: volver a dejar la rama en un estado único y revisable, sin añadir
por accidente otras rutas.

**Resultado observado**: el primer intento no pudo crear `.git/index.lock`
porque el entorno restringía la escritura en `.git`. Se repitió exactamente el
mismo comando con autorización explícita y terminó correctamente. Git avisó de
que varios ficheros LF se convertirán a CRLF la próxima vez que los toque; no se
detectó un diff formado únicamente por finales de línea.

**Estado final del índice**:

- 1.970 ficheros cambiados frente a `HEAD`;
- 15 altas, 3 modificaciones, 1.862 eliminaciones y 90 renombres según la
  detección actual de Git;
- 290 rutas versionadas resultantes;
- 0 rutas versionadas bajo los patrones de runtime/build revisados;
- ningún cambio adicional fuera del índice.

La detección de renombres es heurística: al ampliar dos documentos movidos, Git
pasó de mostrarlos como renombres a mostrarlos como baja y alta. No se perdieron
por ese cambio de clasificación.

## 9. Observado, inferido y decidido

### Observado

- La base es el commit `014bf7c7b3c80c514786c36d1135efe00202b7a0`.
- El diff preparado no presenta errores en `git diff --cached --check`.
- No quedan rutas versionadas bajo los patrones de build/runtime revisados.
- Los enlaces Markdown relativos activos revisados existen.
- Las 24 pruebas disponibles pasan.
- El estado final queda completamente preparado en el índice, sin cambios
  adicionales en el árbol de trabajo.

### Inferido

- La reorganización está técnicamente preparada para una revisión final y un
  cierre controlado de rama, pero el tamaño del diff aconseja no mezclar más
  cambios funcionales.
- La ausencia de enlaces rotos en el alcance comprobado no garantiza que no
  existan referencias históricas, externas o escritas fuera de sintaxis
  Markdown.

### Decidido

- La guía didáctica será lectura obligatoria al inicio de cada sesión.
- Cada sesión técnica relevante mantendrá una nota formativa con comandos,
  motivos, resultados y límites.
- Se mantiene `NO-GO`; no se construye ni instala una RC en este bloque.

## 10. Siguiente paso seguro registrado antes de continuar

Revisar el diff documental final de esta sesión y cerrar la rama estructural de
forma controlada. Solo después debe abrirse una rama o worktree limpio para P0,
sin servidor ni datos reales.

Este paso quedó ejecutado en la continuación documentada a continuación.

## 11. Continuación: cierre estructural e inicio de P0

### Commit estructural

```powershell
git commit -m "chore: consolida estructura documental y elimina artefactos generados"
```

**Motivo**: convertir el diff validado en un punto recuperable antes de iniciar
trabajo técnico distinto.

**Resultado**: commit `907648df368312f985e7797eed5a43f78cdf8234`.

### Rama P0

```powershell
git switch -c codex/produccion-readiness
```

`switch` cambia de rama y `-c` crea la nueva rama desde el commit actual.
Resultado: rama P0 activa, sin mezclar cambios con la reorganización.

### Integridad y topología Git

```powershell
git fsck --full
git worktree list --porcelain
git branch --all --verbose --no-abbrev
```

- `fsck` comprueba objetos y referencias Git;
- `--full` incluye todos los objetos disponibles;
- `worktree list` enumera árboles de trabajo asociados;
- `--porcelain` produce formato estable para herramientas;
- `--all` incluye ramas locales y remotas;
- `--no-abbrev` muestra hashes completos.

Resultado: integridad con código 0 y numerosos objetos colgantes históricos;
dos worktrees, incluida la rama TLS aislada. No se ejecutó limpieza.

### Consulta de CI

Se usó `gh api` para consultar runs, trabajos y pull requests sin modificarlos.
El run de seguridad más reciente figura globalmente correcto, pero su trabajo
de dependencias falló; Bandit y Gitleaks pasaron. La protección de `main` no
pudo verificarse porque el endpoint devolvió HTTP 401.

### Worktree TLS

Git rechazó inicialmente la lectura por `dubious ownership`: la worktree
pertenece al usuario real y el proceso aislado usa otra identidad de Windows.
Se añadió exclusivamente esa ruta a `safe.directory` y se repitió la lectura.

La comparación encontró cinco ficheros modificados y tres tests sin seguimiento,
separados en TLS, recuperación de conexión e ID manual de marcas. No se copió
ningún cambio.

### Seguridad local

- 24 pruebas: `OK`.
- Bandit: 0 hallazgos medios/altos.
- `pip-audit`: no instalado localmente.
- Gitleaks: no instalado localmente.

La ausencia de herramientas se registra como pendiente, no como éxito.

### Hallazgo de mínimo privilegio

La búsqueda de operaciones SQL localizó un `ALTER TABLE` automático en
`src/Quirofanos/services/informe_service.py`. Se decide no otorgar `ALTER` a la
cuenta runtime y convertir el cambio de esquema en migración controlada.

### Documentos P0 creados

- plan de ejecución P0;
- línea base técnica;
- propuesta de cuenta MySQL;
- runbook de reconciliación TLS/CA;
- matriz de riesgos, puertas y responsables;
- plantilla segura de inventario de puestos.

## 12. Inventario didáctico de objetos Git colgantes

Se repitió la comprobación de objetos excluyendo los reflogs como raíces:

```powershell
git fsck --full --no-reflogs
```

**Motivo**: convertir el hallazgo genérico de «objetos colgantes» en una lista
comprensible antes de decidir si se conserva, recupera o descarta algo.

**Resultado inicial**: 10 blobs, 2 commits y 334 árboles. Los diez blobs se
asociaron a versiones anteriores de siete documentos vigentes. Un commit conserva un icono
que coincide con `icono1.ico`; el otro conserva un runbook cuya versión vigente
solo corrige la ruta del diario. No se ejecutó ninguna limpieza.

Tras preparar y corregir el inventario, la revalidación mostró un undécimo blob:
la versión intermedia del propio documento con una línea vacía final. Se añadió
al inventario; no contiene información distinta.

La evidencia detallada, los hashes, comparaciones y criterios de decisión están
en
`docs/05_evidencias/auditorias/INVENTARIO-REVISION-OBJETOS-GIT-COLGANTES-2026-11-11.md`.

## 13. Autorización integral de P1 y de planes completos

El propietario autorizó todo el P1 local y aclaró que los planes de trabajo se
autorizan completos, no paso a paso. La decisión se registró en `AGENTS.md`, en
un documento formal de gobierno y en el plan P1 local.

**Interpretación aplicada**: no se interrumpirá P1 para pedir permisos sobre
acciones ya incluidas —edición, pruebas, documentación y commits—. Si apareciera
una ampliación material, un dato funcional imposible de inferir o un riesgo que
impidiera una reversión segura, se documentaría antes de salir del plan.

**Límite actual**: P1 sigue siendo local. No incluye servidor, MySQL real, datos
reales, CA real ni construcción de RC.

## 14. Simplificación a piloto privado de evaluación

El propietario aclaró que Qontrolmed es un proyecto personal, destinado por
ahora a una única empresa conocida y sin respaldo ni decisión para venta o
distribución comercial. Se aprobó simplificar el gobierno del proyecto para
evitar que requisitos propios de un producto comercial bloqueen el aprendizaje
y la prueba real.

Se difieren Authenticode productivo, SLA, distribución pública, licencia y
estructura comercial. Se mantienen TLS, mínimo privilegio, copias,
restauración, migraciones controladas, pruebas y rollback porque protegen la
operativa incluso en un piloto amistoso.

La matriz P0 se normalizó: el propietario asume mantenimiento y releases; los
datos de puestos, DNS/CA y copia externa quedan pendientes de sede y no bloquean
el desarrollo local.
