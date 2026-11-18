---
title: "Inventario inicial de esquemas y migraciones P2"
type: evidence
status: active
created: 2026-11-11
updated: 2026-11-11
sources:
  - "bd/README.md"
  - "bd/base/"
  - "bd/bootstrap/"
  - "bd/migraciones/"
  - "scripts/db/"
tags: [qontrolmed, p2, mysql, esquema, migraciones]
review_after: 2026-11-18
---

# Inventario inicial de esquemas y migraciones P2

## 1. Alcance y método

Inventario estático del contenido versionado. Se leyeron los scripts SQL y se
buscaron operaciones DDL, comprobaciones, dependencias y reversión. No se abrió
`.env`, no se conectó a MySQL y no se ejecutó SQL.

## 2. Contenido observado

- 20 scripts de estructura base: 12 de `gestion` y 8 de `quirofanos`;
- 2 scripts de bootstrap de `gestion`;
- 11 migraciones incrementales;
- 4 utilidades bajo `scripts/db/` para validación de bootstrap y preparación o
  registro de backup/restore;
- no existe una estructura base completa de `preventivos` en `bd/base/`;
- no existe ledger de versión, manifiesto de orden ni ejecutor controlado de
  migraciones.

Los scripts base son referencia destructiva en varios casos: 17 contienen
`DROP TABLE IF EXISTS`. No deben tratarse como migraciones ni ejecutarse sobre
una instalación existente.

## 3. Matriz de migraciones

| Migración | Esquema | Operación principal | Dependencia u orden inferido | Reejecución | Ciclo pre/post/reversión |
| --- | --- | --- | --- | --- | --- |
| `migracion_login_usuarios_cecos.sql` | gestion | modifica `cecos` y añade autenticación a `usuarios` | base de `cecos` y `usuarios` | No segura | No declarado |
| `migracion_gestion_roles.sql` | gestion | añade `usuarios.rol` y hace backfill | login previo por `es_tecnico` | No segura | No declarado |
| `migracion_gestion_roles_permisos_base.sql` | gestion | crea RBAC, añade `usuarios.id_rol` y semillas | `usuarios` existente | Parcial: tablas/semillas sí; `ALTER` no | No declarado |
| `migracion_gestion_roles_permisos_backfill_usuarios.sql` | gestion | asigna roles existentes | RBAC base y semillas | Sí, con límites | Revisión funcional no formalizada |
| `migracion_gestion_auditoria.sql` | gestion o esquema activo | crea auditoría | esquema seleccionado correctamente | Sí por `IF NOT EXISTS` | No declarado |
| `migracion_centros_gestion.sql` | gestion | añade 12 campos a `cecos` | tabla `gestion.cecos` | Sí mediante `INFORMATION_SCHEMA` | Precheck integrado por columna; sin reversión |
| `migracion_certificados_equipos_medida.sql` | quirofanos | añade ruta de certificado | `quirofanos.equipos_medida` | Depende de versión MySQL | No declarado |
| `migracion_puntos_automaticos.sql` | quirofanos o esquema activo | remodela relaciones y migra datos | tablas y nombres de claves exactos | No segura | Backup recomendado; sin postcheck ni reversión formal |
| `migracion_quirofanos_tecnico_cierre.sql` | quirofanos o esquema activo | añade `informes.tecnico_cierre` | tabla `informes`; selección de esquema correcta | No segura; exige resultado cero | Es la única con precheck, postcheck y restauración declarados |
| `migracion_campanas_preventivo.sql` | preventivos o esquema activo | crea relación campaña-equipo | maestros históricos existentes | Parcial | Comprobaciones solo descritas en comentarios |
| `migracion_tablet_tracking_preventivos.sql` | preventivos | añade trazabilidad tablet | migración de campañas previa | Depende de versión MySQL | Postcheck recomendado; sin reversión |

## 4. Hallazgos y riesgos

### Observado

1. Los nombres no codifican versión ni orden total.
2. Varias migraciones dependen del esquema activo mientras otras califican el
   esquema explícitamente; esto permite aplicar SQL en un destino incorrecto.
3. Varias operaciones `ALTER TABLE` fallan al repetirse.
4. `migracion_puntos_automaticos.sql` agrupa DDL y DML entre
   `START TRANSACTION` y `COMMIT`, pero MySQL realiza commits implícitos para
   gran parte del DDL; no ofrece atomicidad completa.
5. El backfill de roles transforma datos y requiere validación funcional antes
   de considerar correcto el resultado.
6. Las migraciones que usan `ADD COLUMN IF NOT EXISTS` dependen de la versión
   real del servidor, todavía no revalidada.
7. No existe prueba automatizada que valide el orden completo desde esquema
   anterior a esquema objetivo.
8. Los scripts base destructivos y las migraciones comparten el árbol `bd/`,
   pero su finalidad está diferenciada solo por carpeta y documentación.

### Inferido

- No puede reconstruirse con certeza el estado de una instalación únicamente a
  partir del nombre de los ficheros.
- Ejecutar todas las migraciones por orden alfabético no es un procedimiento
  seguro ni representa necesariamente su orden histórico.
- Antes de diseñar un ejecutor debe definirse un catálogo canónico con versión,
  hash, esquema, dependencias y estado aplicado.

## 5. Priorización para P2

1. definir contrato y ledger de versión sin conectarlo todavía al arranque;
2. crear un manifiesto explícito que distinga migraciones vigentes, históricas
   y no promovibles;
3. añadir validación estática que impida registrar una migración sin metadatos,
   precheck, postcheck y estrategia de reversión/restauración;
4. adaptar primero `migracion_quirofanos_tecnico_cierre.sql` como caso piloto,
   porque ya contiene el ciclo más completo y la aplicación falla de forma
   segura si falta la columna;
5. tratar `migracion_puntos_automaticos.sql` como riesgo alto y no utilizarla
   como primer ensayo del mecanismo;
6. probar más adelante contra MySQL aislado y datos sintéticos mediante un plan
   independiente, antes de cualquier servidor o dato real.

## 6. Límites de la evidencia

El inventario no demuestra qué migraciones están aplicadas en una base real ni
la compatibilidad con la versión real de MySQL. Tampoco valida copias o
restauraciones. Es una base documental para diseñar P2 local sin ejecutar DDL.

## 7. Actualización tras P2A

El primer corte de gobierno local se implementó con un manifiesto de formato 1
y un único caso piloto: `quirofanos-0001-tecnico-cierre`. Las otras diez
migraciones continúan fuera del manifiesto hasta completar individualmente sus
metadatos, comprobaciones y recuperación. Esta exclusión es intencionada y no
equivale a descartarlas.

## 8. Actualización tras P2E

El 13/11/2026 se clasificaron individualmente las diez migraciones restantes
sin ejecutar SQL ni modificar el manifiesto. La matriz vigente y el orden por
dependencias están en `CLASIFICACION-MIGRACIONES-P2E-2026-11-13.md`. La
siguiente candidata es `migracion_certificados_equipos_medida.sql`; su
promoción requiere un bloque posterior con endurecimiento y pruebas propias.

## 9. Actualización tras P2F

`migracion_certificados_equipos_medida.sql` se promovió localmente como
`quirofanos-0002-certificados-equipos-medida`. El catálogo contiene ahora dos
migraciones y quedan nueve scripts por clasificar/promover según la matriz
P2E. La promoción local aún no equivale a ejecución validada contra MySQL.
