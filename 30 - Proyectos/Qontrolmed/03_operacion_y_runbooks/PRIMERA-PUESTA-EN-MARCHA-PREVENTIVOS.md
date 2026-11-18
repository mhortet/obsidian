---
title: "Primera puesta en marcha de Preventivos"
type: runbook
status: prepared
created: 2026-11-15
updated: 2026-11-15
sources:
  - "../02_planes_y_arquitectura/PLAN-EJECUCION-P2K-BOOTSTRAP-MINIMO-PREVENTIVOS-2026-11-15.md"
  - "../../bd/base/preventivos_schema_greenfield.sql"
tags: [qontrolmed, preventivos, bootstrap, mysql, operacion]
review_after: 2026-11-22
---

# Primera puesta en marcha de Preventivos

## Resultado esperado

Una base nueva contiene exactamente las diez tablas canónicas de Preventivos.
Los cuatro maestros revisados se importan desde la base local; las seis tablas
operativas permanecen vacías. La aplicación no debe iniciar campañas ni emitir
informes hasta validar la carga de maestros.

## Qué significa «bootstrap mínimo»

En Preventivos no existe una semilla clínica universal. El mínimo seguro es:

1. estructura P2I aplicada desde
   `bd/base/preventivos_schema_greenfield.sql`;
2. inventario y carga controlada de `tipos_equipo`, `puntos_control`,
   `plantillas_preventivo` y `plantilla_puntos`;
3. cero filas en las seis tablas operativas restantes;
4. maestros tratados como configuración funcional conservada, no como
   histórico operativo.

No ejecutar `src/preventivos/services/semillas_service.py` como parte de la
instalación. Su contenido histórico no equivale a una plantilla aprobada para
el piloto.

## Precondiciones de una futura ventana

- plan transversal aprobado si se utiliza `srv-mm-01`;
- destino exacto, host e identidad verificados;
- MySQL 8.4 con TLS e identidad verificada y cuenta administrativa temporal;
- confirmación documentada de que el esquema de destino es nuevo y no contiene
  datos que deban conservarse;
- copia o punto de retorno anterior a cualquier DDL;
- hash SHA-256 del SQL coincidente con el commit autorizado;
- operador distinto de la cuenta técnica de runtime;
- ventana de mantenimiento y ruta de aborto acordadas.

Si cualquiera de estas condiciones falla, no se ejecuta el DDL.

## Precheck de solo lectura

Sustituir `<ESQUEMA_DESTINO>` únicamente después de verificar el destino. Las
consultas siguientes no crean ni modifican objetos:

```sql
SELECT VERSION() AS mysql_version;
SELECT DATABASE() AS esquema_seleccionado;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = '<ESQUEMA_DESTINO>'
ORDER BY table_name;
```

Para una implantación nueva se espera que el esquema no exista o esté vacío.
Si aparece cualquier tabla, se detiene la ventana: no se usa
`CREATE TABLE IF NOT EXISTS` para reconciliar silenciosamente una base previa.

## Ejecución administrativa

1. Crear el esquema exacto con `utf8mb4` y
   `utf8mb4_0900_ai_ci`, siguiendo el plan de infraestructura aprobado.
2. Seleccionarlo explícitamente y comprobar `SELECT DATABASE()`.
3. Ejecutar una sola vez
   `bd/base/preventivos_schema_greenfield.sql` desde el commit autorizado.
4. Conservar la salida depurada del postcheck, sin credenciales ni datos.

La aplicación Qontrolmed no ejecuta este DDL al arrancar. El archivo no debe
copiarse a una carpeta de autoejecución ni concederse DDL a la cuenta técnica.

## Postcheck estructural y de vacío

```sql
SELECT table_name, engine, table_collation
FROM information_schema.tables
WHERE table_schema = '<ESQUEMA_DESTINO>'
ORDER BY table_name;

SELECT 'tipos_equipo' AS tabla, COUNT(*) AS filas FROM <ESQUEMA_DESTINO>.tipos_equipo
UNION ALL SELECT 'plantillas_preventivo', COUNT(*) FROM <ESQUEMA_DESTINO>.plantillas_preventivo
UNION ALL SELECT 'puntos_control', COUNT(*) FROM <ESQUEMA_DESTINO>.puntos_control
UNION ALL SELECT 'plantilla_puntos', COUNT(*) FROM <ESQUEMA_DESTINO>.plantilla_puntos
UNION ALL SELECT 'equipos_gmao', COUNT(*) FROM <ESQUEMA_DESTINO>.equipos_gmao
UNION ALL SELECT 'campanas_preventivo', COUNT(*) FROM <ESQUEMA_DESTINO>.campanas_preventivo
UNION ALL SELECT 'campana_equipos_preventivo', COUNT(*) FROM <ESQUEMA_DESTINO>.campana_equipos_preventivo
UNION ALL SELECT 'informes_preventivo', COUNT(*) FROM <ESQUEMA_DESTINO>.informes_preventivo
UNION ALL SELECT 'resultados_preventivo', COUNT(*) FROM <ESQUEMA_DESTINO>.resultados_preventivo
UNION ALL SELECT 'informe_equipos_medida', COUNT(*) FROM <ESQUEMA_DESTINO>.informe_equipos_medida;
```

Aceptación estructural: diez tablas InnoDB con la collation esperada. Antes de
la carga, los diez recuentos son cero; después, solo los cuatro maestros pueden
tener filas. Una tabla operativa con filas invalida la puesta en marcha.

## Carga funcional posterior

La carga de maestros se prepara desde la base local después de inventariarla y
revisarla. Debe incluir en una misma unidad revisable:

- tipología de equipo;
- plantilla y versión;
- puntos de control, unidades, comparadores y límites;
- orden y relaciones de cada punto con su plantilla;
- procedencia, responsable de validación y fecha;
- precheck, transacción, postcheck y recuperación.

No se habilita una campaña hasta comprobar que cada plantilla activa tiene al
menos un punto activo y que no hay códigos duplicados ni límites sin validar.

## Aborto y reversión

- Antes del DDL: abortar sin cambios.
- Durante el DDL: cerrar la sesión administrativa y registrar el último paso;
  no reejecutar ni completar manualmente sin diagnosticar el estado.
- Si el esquema era nuevo y la ventana autorizó expresamente su retirada,
  restaurar el punto de retorno o eliminar únicamente ese esquema exacto tras
  una segunda verificación de identidad y destino.
- Si existe cualquier duda sobre datos previos, no eliminar nada: aislar el
  esquema y escalar la decisión.

La orden concreta de retirada no se incluye aquí para evitar que un nombre de
ejemplo pueda convertirse en un destino destructivo.

## Evidencia mínima de cierre

- commit y SHA-256 del DDL;
- host, esquema y versión de MySQL, sin secretos;
- resultado de los prechecks y postchecks;
- referencia del punto de retorno;
- operador y fecha de la ventana;
- confirmación de que no se cargaron datos reales ni semillas históricas;
- estado final del servicio y de la cuenta administrativa temporal.
