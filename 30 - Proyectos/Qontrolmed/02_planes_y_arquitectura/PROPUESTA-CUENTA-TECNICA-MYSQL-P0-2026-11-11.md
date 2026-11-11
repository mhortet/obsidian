---
title: "Propuesta de cuenta técnica MySQL de mínimo privilegio"
type: plan
status: proposed
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/05_evidencias/auditorias/LINEA-BASE-TECNICA-P0-2026-11-11.md"
  - "docs/01_gobierno_y_decisiones/propuesta_modelo_roles_permisos.md"
tags: [qontrolmed, mysql, minimo-privilegio, p0]
review_after: 2026-11-18
---

# Propuesta de cuenta técnica MySQL de mínimo privilegio

## 1. Objetivo

Separar tres controles que no son equivalentes:

1. usuario funcional de Qontrolmed;
2. cuenta técnica runtime utilizada por el programa;
3. cuenta administrativa temporal para instalación y migraciones.

La contraseña y los identificadores reales no se incorporan al repositorio.

## 2. Modelo recomendado

### Cuenta runtime por puesto autorizado

Preferencia: una identidad MySQL distinta por puesto, limitada por origen. Esto
permite revocar un equipo sin cambiar todos los puestos y mejora la trazabilidad
de conexión.

Si operativamente se aprueba una cuenta compartida, seguirá existiendo una
entrada `usuario@origen` por IP autorizada y una rotación documentada.

### Cuenta de migración

Cuenta administrativa separada, deshabilitada o sin acceso cotidiano. Solo se
usa en una ventana aprobada, después de precheck y copia, y se retira o revoca
al finalizar.

## 3. Privilegios runtime

Privilegios permitidos, solo sobre tablas necesarias:

- `SELECT`;
- `INSERT`;
- `UPDATE`;
- `DELETE` cuando la función validada lo requiere.

Privilegios expresamente excluidos:

- `ALTER`, `CREATE`, `DROP`, `TRUNCATE`;
- `GRANT OPTION`, `CREATE USER`, `ALTER USER`, `DROP USER`;
- `FILE`, `PROCESS`, `SUPER`, `SYSTEM_USER`, `SHUTDOWN`;
- privilegios globales `*.*`;
- `LOCAL INFILE` desde el cliente.

## 4. Matriz inicial por esquema

### `gestion`

Necesarias para autenticación, permisos, auditoría y referencias usadas por
Preventivos/Quirófanos:

- `usuarios`: lectura y actualización acotada de autenticación/administración;
- `roles`, `permisos`, `roles_permisos`: lectura y, solo para administración
  autorizada, DML;
- `auditoria_eventos`: `INSERT`; lectura solo para perfil administrativo;
- `cecos`: lectura y DML de maestros autorizados.

Las tablas `compras`, `detalle_compra`, `proveedor` y `repuestos` quedan fuera
del primer corte y no deben recibir permisos runtime productivos. `marcas`,
`equipos` y `tipo_trabajo` requieren confirmación funcional antes de conceder
DML, porque Gestión solo se incluye en lo imprescindible para los dos módulos
productivos.

### `quirofanos`

- `hospitales`, `quirofanos`, `puntos_control`,
  `quirofano_puntos_control`, `equipos_medida`, `informes` y
  `resultado_puntos`;
- lectura y DML según la matriz de casos de uso;
- ningún DDL en runtime.

### `preventivos`

- `tipos_equipo`, `plantillas_preventivo`, `puntos_control`,
  `plantilla_puntos`, `equipos_gmao`, `campanas_preventivo`,
  `campana_equipos_preventivo`, `informes_preventivo`,
  `resultados_preventivo` e `informe_equipos_medida`;
- lectura y DML según la matriz de casos de uso;
- ningún DDL en runtime.

## 5. Plantilla SQL no ejecutable sin sustitución controlada

```sql
-- Ejecutar únicamente desde el runbook aprobado y con valores protegidos.
CREATE USER '<cuenta_runtime>'@'<origen_autorizado>'
  IDENTIFIED BY '<secreto_generado_fuera_del_repositorio>'
  REQUIRE SSL;

-- Ejemplo de concesión por tabla, no por esquema completo.
GRANT SELECT, INSERT, UPDATE, DELETE
  ON `quirofanos`.`informes`
  TO '<cuenta_runtime>'@'<origen_autorizado>';

-- Verificación obligatoria posterior.
SHOW GRANTS FOR '<cuenta_runtime>'@'<origen_autorizado>';
```

Esta plantilla no es un script de producción. La lista final se generará desde
la matriz de operaciones probadas y se revisará antes de ejecutar.

## 6. Pruebas obligatorias

### Aceptación

- conexión TLS desde un puesto autorizado;
- lectura y DML permitidos sobre cada tabla de alcance;
- escritura de auditoría;
- transacciones compuestas completas y rollback ante fallo.

### Denegación

- conexión desde origen no autorizado;
- acceso sin TLS o con CA/nombre incorrectos;
- acceso a tablas de Compras diferidas;
- `ALTER TABLE`, `CREATE USER`, `DROP`, lectura de otros esquemas y `FILE`;
- acceso después de revocar un puesto.

## 7. Bloqueo detectado

El runtime actual intenta `ALTER TABLE informes` para crear
`tecnico_cierre`. No se concederá `ALTER` para hacerlo funcionar. Se retirará el
autoajuste y la columna se gestionará mediante migración con precheck, copia,
postcheck y restauración prevista.
