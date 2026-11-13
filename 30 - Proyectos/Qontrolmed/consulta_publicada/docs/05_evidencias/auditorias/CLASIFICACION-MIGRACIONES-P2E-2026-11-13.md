---
title: "Clasificación de migraciones P2E"
type: evidence
status: active
created: 2026-11-13
updated: 2026-11-13
sources: ["bd/migraciones/", "bd/base/", "src/"]
tags: [qontrolmed, p2, migraciones, evidencia]
review_after: 2026-11-20
---

# Clasificación de migraciones P2E

Las diez migraciones fuera del manifiesto no forman una cadena homogénea. Se
conservan todas, pero solo se promoverán de una en una tras completar precheck,
postcheck, recuperación y prueba sintética.

| Migración | Necesidad/dependencia | Riesgo | Clasificación |
| --- | --- | --- | --- |
| `migracion_certificados_equipos_medida.sql` | Quirófanos consume `ruta_certificado`; depende de `quirofanos-0001` | Bajo-medio: DDL aditivo | **Promovida en P2F como `quirofanos-0002`** |
| `migracion_gestion_auditoria.sql` | trazabilidad; requiere guard de `gestion` | Medio: destino implícito | Promover después |
| `migracion_gestion_roles_permisos_base.sql` | permisos mínimos; depende del estado de `usuarios` | Alto: DDL, semillas y permisos | Promover después de descomponer/endurecer |
| `migracion_gestion_roles_permisos_backfill_usuarios.sql` | depende del RBAC base y revisión de usuarios | Alto: transforma identidades | Promover después del RBAC base |
| `migracion_campanas_preventivo.sql` | flujo de campañas y maestros previos | Medio: tabla y claves foráneas | Promover después |
| `migracion_tablet_tracking_preventivos.sql` | depende de campaña-equipo | Medio: cuatro columnas | Promover después de campañas |
| `migracion_puntos_automaticos.sql` | modelo actual de puntos | Muy alto: DDL+DML no atómico | Promover al final de la cadena necesaria |
| `migracion_centros_gestion.sql` | ampliación usada principalmente por UI diferida | Medio: doce ALTER | Diferir; reevaluar necesidad mínima |
| `migracion_login_usuarios_cecos.sql` | puente para orígenes antiguos no identificados | Alto: no reejecutable | Legada; no promover por defecto |
| `migracion_gestion_roles.sql` | puente anterior al RBAC vigente | Alto: modelo sustituido | Legada; no promover por defecto |

## Orden por cadenas

- `quirofanos-0001-tecnico-cierre` → certificados → puntos automáticos;
- RBAC base → backfill de usuarios;
- campañas de Preventivos → trazabilidad tablet.

Auditoría es funcionalmente independiente, pero su promoción debe coordinarse
con la extensión del guard al esquema `gestion`.

## Siguiente candidata

Certificados es la opción más segura: el código vigente usa la columna, la
estructura base ya la contiene, el cambio es aditivo y permanece en el esquema
protegido por P2D. Antes de registrarla se sustituirá `ADD COLUMN IF NOT EXISTS`
por prechecks explícitos, se verificará tipo, nulabilidad y longitud, y se
declarará restauración desde copia en vez de `DROP COLUMN` automático.

## Observado, inferido y decidido

### Observado

- El manifiesto contiene solo `quirofanos-0001-tecnico-cierre`.
- Quirófanos lee y escribe `equipos_medida.ruta_certificado`.
- Roles y tablet tienen dependencias funcionales comprobables.

### Inferido

- Los puentes históricos pueden ser necesarios para un origen concreto, pero
  no se demuestra que pertenezcan a todas las actualizaciones.
- Los doce campos ampliados de centros no son todos imprescindibles para el
  corte inicial.

### Decidido

- P2E no añade migraciones al manifiesto.
- La próxima promoción empezará por certificados.
- Ningún script se borra; excluirlo del orden canónico no lo descarta.

## Actualización tras P2F

El 13/11/2026 certificados se promovió como
`quirofanos-0002-certificados-equipos-medida`. Quedan nueve migraciones fuera
del manifiesto. Esta actualización no acredita ejecución contra MySQL.
