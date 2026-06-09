# Playbook operativo de seguridad y entrega
[[masgesth]]
Fecha de revision: 2026-06-01

## Objetivo

Este documento fija la rutina obligatoria para entrar en el proyecto conjunto
`maxgesth` + `maxgesth_port` + `maxgestq_mov` sin depender del historial de
chat ni improvisar el flujo de trabajo.

La idea no es solo proteger `Qontrolmed`. La idea es trabajar los tres repos
con un criterio unico de continuidad, validacion, cierre y priorizacion hacia
produccion.

## Fuente de verdad del roadmap

- `docs/plan_seguridad_consistencia.md` es la unica guia viva del roadmap.
- `docs/estado_continuidad.md` es la foto viva de reanudacion.
- `docs/mapa_documental_proyecto.md` decide que documento sigue vivo y cual debe
  ir a historico.
- `docs/Tareas Pendientes.md` deja de ser backlog operativo autonomo.

## Orden obligatorio al iniciar una sesion

Antes de tocar codigo o documentacion, leer en este orden:

1. `D:/trabajo/Proyectos/maxgesth/docs/security_delivery_playbook.md`
2. `D:/trabajo/Proyectos/maxgesth/docs/estado_continuidad.md`
3. `D:/trabajo/Proyectos/maxgesth/docs/plan_seguridad_consistencia.md`
4. `D:/trabajo/Proyectos/maxgesth/docs/mapa_documental_proyecto.md`

Despues de esa lectura, revisar el estado Git de los tres repos:

```powershell
git -C D:\trabajo\Proyectos\maxgesth status --short --branch
git -C D:\trabajo\Proyectos\maxgesth_port status --short --branch
git -C D:\trabajo\Proyectos\maxgestq_mov status --short --branch
```

Y crear o actualizar el parte externo de sesion en:

```text
D:\trabajo\Proyectos\diario_qontrolmed\sesion_YYYY-MM-DD_HH-mm.md
```

Antes de elegir tarea hay que detectar:

- cambios locales ajenos;
- ramas de riesgo como `main` con trabajo sin aislar;
- artefactos efimeros o temporales;
- si la tarea toca un flujo compartido entre escritorio y movil;
- si falta informacion bloqueante para la linea activa del roadmap.

## Propuesta minima al arrancar cada sesion

La primera salida de cada sesion debe incluir siempre:

- una tarea principal recomendada;
- una tarea secundaria alternativa;
- los tests que habra que pasar para cerrar la tarea principal;
- la validacion manual pendiente, si aplica;
- las dependencias con otros repos, migraciones o contratos si existen.

La linea por defecto mientras no cambie la prioridad global es:

- `Hardening transversal y readiness de produccion`

Eso implica priorizar:

- acceso, usuarios, roles y auditoria;
- migraciones documentadas en lugar de autoajustes silenciosos;
- saneamiento de maestros y nomenclatura funcional;
- consistencia real de persistencia y artefactos de runtime;
- correcciones de Preventivos y Quirofanos solo si vienen del campo con
  severidad alta o bloqueante.

## Regla cuando falte informacion

- Si la informacion no es bloqueante, se solicita de forma concreta y la sesion
  continua con otra tarea ya preparada del roadmap.
- Si la informacion es bloqueante para la linea activa, se solicita y esa linea
  se pausa hasta tener respuesta.
- Las dudas abiertas deben reflejarse tambien en `docs/estado_continuidad.md` y
  en el parte externo de sesion.

## Reglas de ramas y cambios

- No trabajar directamente sobre `main` para cambios relevantes.
- Si `maxgesth` esta en `main`, abrir o reutilizar rama antes de tocar logica
  funcional o deuda importante.
- Usar commits pequenos y con un solo objetivo.
- No mezclar cambios funcionales con limpiezas masivas.
- No mezclar cambios de varios repos si no forman una unica historia tecnica.
- No usar `git push --force` en ramas compartidas.
- Antes de cada bloque de trabajo, revisar `git diff --stat` si ya habia cambios
  locales.
- Si una tarea toca esquema o migraciones, separar explicitamente cambio de
  datos, cambio de codigo y validacion asociada.

## Tratamiento de cambios ajenos

- Si aparecen cambios que no pertenecen a la tarea actual, no revertirlos.
- Si los cambios ajenos afectan al mismo flujo, leerlos antes de seguir.
- Si hay conflicto de criterio o de alcance, parar y decidir el orden antes de
  editar.
- Los ficheros temporales como `tmp/` o exports de pruebas no deben entrar en
  commits salvo prueba controlada.
- Los directorios locales de edicion documental como `docs/.obsidian/` se
  consideran efimeros salvo decision expresa de versionado.

## Politica de tests minimos por repositorio

### maxgesth / Qontrolmed

Validacion base:

```powershell
python -m compileall main.py src
```

Si la sesion toca autenticacion, permisos, usuarios o maestros:

```powershell
python -m py_compile <modulos_tocados>
```

Y ademas:

- prueba feliz;
- prueba de denegacion o conflicto;
- verificacion de persistencia real.

Si la sesion toca auditoria:

- verificar alta de log en exito;
- verificar no dejar inconsistencia en error;
- verificar usuario, entidad y accion correctos.

Si la sesion toca schema:

- validar migracion en entorno de prueba;
- documentar rollback o reversion manual razonable.

Si el cambio afecta a otro modulo concreto, sustituir la compilacion especifica
por los archivos realmente tocados.

### maxgesth_port / tablet Preventivos

Solo tocar cuando una decision transversal o una incidencia real de contrato lo
requiera.

Base recomendada si se toca:

```powershell
python test_import.py
python test_report_service.py
python -m py_compile src\data\schema.py src\services\import_service.py src\services\report_service.py src\services\export_service.py
```

### maxgestq_mov

Solo tocar cuando contrato, import/export o una incidencia de campo real lo
requiera.

Suite recomendada si se toca:

```powershell
python -m unittest test_import_export_contract.py test_catalog_service.py test_point_validation.py test_informe_service.py
python -m compileall -q main.py src test_catalog_service.py test_import_export_contract.py test_informe_service.py test_point_validation.py
```

Si el cambio es de UI o Android, anadir validacion manual en dispositivo o APK
si el cierre depende de comportamiento visual.

Si la sesion toca solo documentacion viva:

- verificar rutas, nombres de modulo y referencias cruzadas;
- revisar que prioridad, continuidad y criterios de cierre sigan siendo
  coherentes entre playbook, roadmap y mapa documental.

## Politica de commit y cierre

No se hace commit automatico al terminar de programar.

Definicion operativa fija:

- `cerrar tarea` no significa solo terminar de programar;
- una tarea solo se considera realmente cerrada cuando ya constan tests
  proporcionados al cambio, commit realizado, push realizado y nota de
  continuidad actualizada;
- si falta cualquiera de esos pasos, la tarea puede estar implementada o
  validada, pero no cerrada.

Secuencia obligatoria:

1. Resumir el cambio realizado.
2. Indicar tests ejecutados y resultado.
3. Indicar validacion funcional o manual pendiente.
4. Esperar confirmacion positiva de cierre por parte del usuario.
5. Solo entonces hacer un commit pequeno, logico y con un solo objetivo.
6. Hacer `push` de la rama correspondiente.
7. Actualizar la nota de continuidad y, si aplica, el diario externo de sesion.

Regla fija:

- un commit por cambio importante;
- nunca commitear si la validacion proporcional al cambio no esta hecha;
- nunca commitear mezclando funcionalidad con basura temporal, pruebas sueltas o
  limpieza no relacionada.
- no dar una tarea por cerrada si falta `push` o falta reflejar el cierre en la
  documentacion viva de continuidad.

## Secretos, artefactos y ficheros efimeros

- `.env` real nunca debe versionarse.
- `.env.example` solo puede contener nombres de variables y valores falsos.
- `dist/`, `build/`, `_internal/`, caches, bases locales, exports y carpetas
  temporales no deben colarse en commits funcionales.
- Los assets de cliente u hospital, como logos externos, se tratan como
  material de despliegue, no como fuente estable del repo.
- El intercambio con tablet debe vivir en carpetas de runtime, no junto al
  codigo fuente.
- Certificados PDF reales, datos de cliente y capturas operativas deben
  revisarse antes de mantenerse en el repo como material documental estable.

## Cuidados de consistencia

- Las operaciones cabecera-detalle deben ser atomicas.
- La logica critica debe vivir en servicios reutilizables, no repartida entre
  varias UI.
- Los cambios de contrato JSON entre escritorio y movil deben leerse en ambos
  repos antes de implementarse.
- Si una tarea toca `Qontrolmed` y una app movil, la propuesta inicial de
  sesion debe nombrar los dos lados del flujo y sus tests.
- No introducir `ALTER TABLE`, autocreacion de columnas o autoajustes de schema
  en flujos normales de usuario sin migracion documentada y decision explicita.
- Corregir mojibake o problemas de codificacion antes de considerarlos
  aceptables para produccion.

## Cuando actualizar la documentacion viva

Actualizar los documentos activos cuando cambie cualquiera de estas cosas:

- la prioridad principal de trabajo;
- el flujo de cierre o de commit;
- los tests minimos recomendados;
- las ramas activas o el estado local que condiciona la siguiente sesion;
- una decision de producto o arquitectura que cambie la forma de atacar tareas;
- la clasificacion entre documentacion viva e historica;
- la politica de diario externo o de registro de sesion.

Documentos satelite relacionados:

- `D:/trabajo/Proyectos/maxgesth_port/docs/security_delivery_playbook.md`
- `D:/trabajo/Proyectos/maxgestq_mov/docs/continuidad_local.md`
