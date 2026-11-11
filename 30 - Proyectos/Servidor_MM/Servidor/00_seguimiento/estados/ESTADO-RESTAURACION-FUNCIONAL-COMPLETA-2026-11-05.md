---
title: "Restauración funcional completa del piloto doméstico"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../05_evidencias/RESTAURACION-FUNCIONAL-COMPLETA-2026-11-05.txt"
  - "../../06_herramientas/scripts/copiar-restaurar-esquema-funcional-20261105.py"
tags: [mysql, seguridad, documentacion]
review_after: 2026-11-12
---

# Copia y restauración de las 33 tablas funcionales

## Resultado

Completada el 2026-11-05 dentro del plan conjunto ya aprobado, exclusivamente sobre los tres esquemas y datos ficticios del piloto. MySQL permaneció limitado a `127.0.0.1`; no se abrió UFW ni se desbloquearon cuentas.

Se crearon destinos nuevos, sin sobrescribir restauraciones anteriores:

| Módulo | Destino | Tablas funcionales | Tablas totales | Relaciones verificadas |
| --- | --- | ---: | ---: | ---: |
| Gestión | `piloto_mm_restore_func3_gestion` | 13 | 14 | 10 |
| Quirófanos | `piloto_mm_restore_func3_quirofanos` | 7 | 8 | 7 |
| Preventivos | `piloto_mm_restore_func3_preventivos` | 13 | 14 | 13 |

Las tablas totales incluyen `prueba_conexion` en cada esquema. La comparación comprobó inventario de tablas, recuento de filas por tabla, columnas, índices y relaciones con sus reglas referenciales. Las copias lógicas privadas y sus hashes permanecen bajo `/root/srv-mm-piloto-20261105/restauracion-funcional-r3`.

## Incidencia controlada R2

El primer script de esta sesión se detuvo antes de crear un destino porque el cliente MySQL escapó el tabulador interno usado para separar `charset` y `collation`. Cerró MySQL correctamente y conservó la evidencia R2. La revisión R3 consultó ambos valores como columnas independientes y usó rutas y destinos nuevos; no se borró ni sobrescribió R2.

## Cierre seguro

Revalidación independiente posterior: `srv-mm-01`, MySQL `inactive/disabled`, sin proceso `mysqld`, sin escuchas 3306/33060, cero unidades fallidas y configuración piloto con SHA256 `4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927`.

Esta prueba cubre la restauración lógica del esquema funcional ficticio. No valida una política 3-2-1, un destino externo, datos reales ni producción.

## Pendientes que permanecen

1. Revisión visual manual de las pantallas y flujos completos.
2. Rechazo activo de TCP/3306 desde un segundo origen LAN no autorizado.
3. Revisión y aceptación del código y del empaquetado antes de cualquier instalación habitual.
4. Red, identidad, copias externas y requisitos reales de la sede.
