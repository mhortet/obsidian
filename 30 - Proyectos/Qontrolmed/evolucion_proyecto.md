---
title: "Evolucion del proyecto Qontrolmed"
type: project
status: active
created: 2026-06-28
updated: 2026-06-28
sources:
  - "30 - Proyectos/Qontrolmed/estado_continuidad.md"
  - "30 - Proyectos/Qontrolmed/plan_seguridad_consistencia.md"
  - "30 - Proyectos/Qontrolmed/02_historico/Roadmap.md"
  - "30 - Proyectos/Qontrolmed/cola_triaje_campo.md"
tags: [qontrolmed, evolucion, diario, proyecto]
review_after: 2026-09-28
---

# Evolucion del proyecto Qontrolmed

Diario sintetico deducido de los documentos de la raiz del proyecto. No sustituye a los diarios de sesion ni al estado de continuidad; sirve para entender como ha cambiado el foco del proyecto.

## 1. Nacimiento como aplicacion modular tecnica

El proyecto arranca como una aplicacion de escritorio en Python/Tkinter con base de datos MySQL y tres dominios funcionales:

- Compras, luego orientado funcionalmente a `Gestion`.
- Quirofanos.
- Preventivos.

El primer roadmap describe una plataforma modular para electromedicina, mantenimiento tecnico legal, preventivos, revisiones de quirofanos, gestion documental y trazabilidad. En esta etapa el foco era ampliar funcionalidad, estabilizar PDFs, ordenar historicos e imaginar una salida futura a produccion.

Documentos representativos:

- `02_historico/Roadmap.md`
- `03_entregables/documentacion_integral_proyecto_entregable.md`
- `02_historico/Módulo compras.md`
- `02_historico/Módulo informe.md`

## 2. Consolidacion de Preventivos y Quirofanos

Preventivos y Quirofanos pasan de ser ideas modulares a flujos operativos avanzados:

- informes;
- historicos;
- PDFs;
- plantillas;
- puntos de control;
- equipos de medida;
- libro de quirofano;
- exportacion/importacion con tablet o Android.

Preventivos se convierte en el modulo mas cercano a cierre operativo. Quirofanos queda muy avanzado, pero con necesidad de refresco tecnico-funcional y control de movilidad/documentacion.

Documentos representativos:

- `03_entregables/Informe sobre módulo preventivos.md`
- `03_entregables/Informe módulo Quirófano.md`
- `02_historico/puntos_automaticos_quirofanos.md`
- `02_historico/Pos revisión flujo de preventivos.md`

## 3. Trabajo real de campo y aparicion de la cola de triaje

Con las pruebas reales de campo aparece una necesidad nueva: no convertir cada observacion en cambio de codigo inmediato.

La cola de triaje documenta incidencias y mejoras detectadas en campo con severidad:

- bloqueante;
- alta;
- media;
- mejora.

Esto cambia la forma de decidir: Preventivos y Quirofanos dejan de absorber el roadmap salvo que aparezcan incidencias reales de severidad alta o bloqueante.

Documento vivo:

- [[cola_triaje_campo]]

## 4. Giro hacia seguridad, consistencia y readiness de produccion

El proyecto deja de ser solo funcionalidad de modulos y entra en una fase de madurez:

- hardening transversal;
- roles y permisos;
- login seguro;
- auditoria;
- ventana unica;
- migraciones SQL documentadas;
- consistencia entre repos de escritorio y moviles;
- preparacion de piloto o produccion controlada.

Esta etapa convierte `plan_seguridad_consistencia.md` en la guia viva del roadmap. `estado_continuidad.md` queda como foto de reanudacion, y `security_delivery_playbook.md` como ritual de trabajo.

Documentos vivos:

- [[plan_seguridad_consistencia]]
- [[estado_continuidad]]
- [[security_delivery_playbook]]

## 5. Gestion como modulo maestro y Centros como evolucion de CECOS

El modulo `Compras` empieza a evolucionar funcionalmente hacia `Gestion`, sin cambiar necesariamente los nombres tecnicos internos.

La tabla tecnica `cecos` se mantiene por compatibilidad, pero funcionalmente evoluciona hacia `Centros`, con campos de contacto, direccion, documentacion asociada y observaciones.

Documentos representativos:

- `01_gobierno_y_decisiones/migracion_centros_gestion.sql`
- [[plan_seguridad_consistencia]]
- [[estado_continuidad]]

## 6. Roles, permisos y acceso productivo

El proyecto adopta el modelo objetivo:

```text
usuario -> rol -> permisos
```

La compatibilidad con `es_tecnico` se mantiene como puente mientras sigan existiendo flujos legacy. Se define `superusuario` como rol reservado y se bloquea que operadores no superusuario puedan asignarlo, retirarlo, modificar cuentas que lo tengan o desactivarlas.

El login deja de depender de acceso implicito sin contrasena. Se introduce bootstrap guiado y acotado, password hash, bloqueo temporal tras intentos fallidos y eventos de auditoria.

Documentos representativos:

- `01_gobierno_y_decisiones/propuesta_modelo_roles_permisos.md`
- `01_gobierno_y_decisiones/roles_operativos_acceso.md`
- [[estado_continuidad]]

## 7. Auditoria y trazabilidad operativa

La auditoria deja de ser una idea futura y pasa a primer corte funcional:

- import/export de Preventivos;
- import/export de Quirofanos;
- login y bootstrap;
- eventos de bloqueo;
- consulta minima de auditoria desde UI;
- exportacion CSV inicial.

Esta linea reduce el riesgo de operar sin evidencia, especialmente en un contexto tecnico-sanitario donde importa quien hizo que, cuando, sobre que modulo y con que resultado.

Documento representativo:

- [[plan_seguridad_consistencia]]
- [[estado_continuidad]]
- `01_gobierno_y_decisiones/migraciones_operativas_hardening.md`

## 8. Infraestructura: MySQL 8.4 LTS

Antes de seguir ampliando roles, permisos y migraciones, se decide revisar la version del servidor. El plan de upgrade de MySQL 8.0.44 a 8.4 LTS se ejecuta y deja una leccion importante: el problema real no fue la perdida de datos, sino compatibilidad de autenticacion del usuario de aplicacion.

Resultado confirmado:

- upgrade a `MySQL 8.4.9`;
- servicio reapuntado manualmente al binario de MySQL 8.4;
- usuario `administrador@%` migrado a `caching_sha2_password`;
- app operativa de nuevo.

Documento historico:

- `02_historico/plan_upgrade_mysql_8_0_44_a_8_4_lts.md`

## 9. Estado actual deducido

El proyecto ya no esta en fase de "crear modulos". Esta en fase de convertir una aplicacion funcional en un sistema mantenible, trazable y preparado para piloto controlado.

Prioridad vigente:

1. Hardening transversal y readiness de produccion.
2. Gestion y maestros.
3. Trazabilidad y consolidacion de datos.
4. Correcciones reales de campo en Preventivos y Quirofanos.
5. Informes y analitica futura.

Lectura de cierre:

- `Roadmap.md` fue el mapa inicial.
- `plan_seguridad_consistencia.md` es el mapa vivo.
- `estado_continuidad.md` es la foto de reentrada.
- `cola_triaje_campo.md` protege el proyecto de reaccionar de mas a observaciones aisladas.
- Los informes ejecutivos de modulos sirven como material entregable o explicativo, no como fuente operativa diaria.
