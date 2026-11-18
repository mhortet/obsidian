---
title: "Plan P2A: gobierno local de esquema y migraciones"
type: plan
status: completed
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/05_evidencias/auditorias/INVENTARIO-ESQUEMAS-Y-MIGRACIONES-P2-2026-11-11.md"
  - "docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md"
tags: [qontrolmed, p2, migraciones, esquema, mysql]
review_after: 2026-11-18
---

# Plan P2A: gobierno local de esquema y migraciones

## 1. Objetivo

Crear localmente el contrato mínimo de versionado de esquema y el catálogo de
migraciones, sin ejecutar SQL ni conectar a MySQL. El mecanismo debe permitir
detectar un esquema incompatible y fallar de forma segura, pero nunca migrar
automáticamente al abrir Qontrolmed.

## 2. Alcance

- modelo versionado y manifiesto canónico de migraciones;
- metadatos obligatorios: identificador, esquema, dependencia, hash, precheck,
  postcheck y reversión o restauración;
- primer registro piloto para `migracion_quirofanos_tecnico_cierre.sql`;
- lector y validador local sin capacidad de ejecutar DDL;
- pruebas de aceptación y rechazo para orden, duplicados, hashes, dependencias
  y metadatos incompletos;
- documentación operativa y actualización del relevo.

## 3. Límites

- sin MySQL, servidor, red, `.env`, credenciales, CA o datos reales;
- sin ejecución automática o manual de migraciones;
- sin modificación masiva de las once migraciones en el primer corte;
- sin diseño de backup 3-2-1, que pertenece a un subbloque posterior de P2;
- sin RC.

## 4. Secuencia

1. definir el contrato de versión y los estados admisibles;
2. fijar formato del manifiesto y regla de hashes;
3. implementar un validador de solo lectura;
4. registrar el caso piloto de Quirófanos;
5. probar aceptación y fallos cerrados;
6. documentar cómo una futura herramienta administrativa consultaría el
   ledger sin integrarla todavía;
7. actualizar diario, evidencia y relevo en commits separados por
   responsabilidad cuando aporte claridad de reversión.

## 5. Puerta de aceptación

- ningún código del arranque ejecuta DDL;
- el manifiesto rechaza duplicados, dependencias ausentes y hashes inválidos;
- una migración sin precheck, postcheck o reversión no puede declararse apta;
- el caso piloto queda cubierto por pruebas positivas y negativas;
- todas las pruebas existentes continúan correctas;
- no se accede a sistemas externos ni se construye una RC.

## 6. Reversión

El bloque será exclusivamente local y versionado. Sus commits podrán revertirse
sin afectar bases de datos, servidor ni instalaciones porque no ejecutará SQL.

## 7. Resultado de ejecución

- creado `bd/migraciones/manifest.json` con formato 1 y primer registro piloto
  para `quirofanos-0001-tecnico-cierre`;
- definido el contrato lógico del ledger, sus estados de compatibilidad y la
  futura consulta de solo lectura;
- creado un lector y validador sin conector de base de datos ni API de ejecución
  SQL;
- añadida una utilidad CLI local de solo lectura;
- incorporadas 11 pruebas nuevas de aceptación y denegación, incluida la
  estabilidad del hash entre CRLF y LF;
- 55 pruebas totales correctas;
- Bandit sin hallazgos medios o altos;
- `pip-audit` local no emitió resultado tras más de 90 segundos y se
  interrumpió; no se declara esa ejecución como correcta. No cambiaron las
  dependencias y el control remoto del commit base ya había finalizado
  correctamente;
- no se abrió MySQL, no se ejecutó SQL y no se construyó una RC.
- CI remoto `43081859463` y Security Checks `43081859180` correctos para
  `e62f23c`.

P2A queda completado dentro de su alcance local. El manifiesto no prueba el
estado de una base real ni autoriza ejecutar la migración registrada.
