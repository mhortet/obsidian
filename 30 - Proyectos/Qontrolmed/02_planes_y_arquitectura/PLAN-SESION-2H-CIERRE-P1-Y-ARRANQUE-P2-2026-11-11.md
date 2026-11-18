---
title: "Plan de sesión de 2 horas: cierre P1 y arranque controlado de P2"
type: plan
status: completed
created: 2026-11-11
updated: 2026-11-11
sources:
  - "CONTINUAR-SIGUIENTE-SESION.md"
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P1-LOCAL-2026-11-11.md"
  - "docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md"
tags: [qontrolmed, sesion, p1, p2, ci, migraciones]
review_after: 2026-11-18
---

# Plan de sesión de 2 horas: cierre P1 y arranque controlado de P2

## 1. Objetivo

Utilizar una sesión efectiva de aproximadamente dos horas para:

1. revalidar el punto seguro local;
2. comprobar la ejecución remota de CI y Gitleaks que mantiene P1 en estado
   `validation-pending`;
3. cerrar documentalmente P1 solo si la evidencia remota es satisfactoria;
4. emplear el tiempo restante en preparar el primer bloque local de P2 mediante
   un inventario estático de esquemas y migraciones.

El resultado buscado no es una RC ni una autorización productiva. Qontrolmed
permanece en estado **NO-GO**.

## 2. Alcance y límites

### Incluido

- consultas no destructivas de Git y GitHub;
- pruebas locales existentes;
- lectura de SQL, scripts, tests y documentación versionada;
- inventario de scripts base, bootstrap y migraciones;
- clasificación inicial de riesgos de migración;
- actualización de evidencia, diario, plan P1 y relevo;
- commits documentales o de cierre comprendidos en este plan.

### Excluido

- servidor, SSH, MySQL real, red, firewall y puestos del cliente;
- inspección de `.env`, credenciales, datos reales o certificados reales;
- ejecución de migraciones o conexión a una base de datos;
- construcción, instalación o publicación de una RC;
- integración del cambio histórico de marcas;
- recuperación o poda de objetos Git colgantes;
- implementación del ledger de esquema o cambios funcionales de P2.

## 3. Secuencia y presupuesto temporal

| Tiempo | Bloque | Acción | Salida esperada |
| --- | --- | --- | --- |
| 00:00-00:15 | Entrada segura | Comprobar rama, árbol de trabajo, commits publicados y ejecutar la batería local | Línea base fechada, sin sobrescribir cambios previos |
| 00:15-00:35 | Puerta remota P1 | Reautenticar `gh` de forma interactiva y consultar workflow, jobs y logs depurados del commit publicado | Estado verificable de tests, `pip-audit`, Bandit y Gitleaks |
| 00:35-00:50 | Decisión P1 | Comparar resultados con la puerta del plan P1 y corregir únicamente documentación de estado | P1 cerrado o bloqueo exacto registrado, sin falso verde |
| 00:50-01:30 | Preparación P2 | Inventariar SQL base, bootstrap, migraciones, orden, esquema afectado, DDL, prechecks, postchecks y reversión declarada | Matriz inicial de migraciones y huecos comprobables |
| 01:30-01:45 | Diseño del siguiente bloque | Proponer el primer corte implementable de P2, priorizando versionado de esquema y fallo seguro | Plan P2 acotado, todavía sin ejecutarlo |
| 01:45-02:00 | Validación y relevo | Repetir comprobaciones proporcionales, revisar el diff, actualizar diario y `CONTINUAR-SIGUIENTE-SESION.md` | Punto seguro reproducible y siguiente acción inequívoca |

Los tiempos son cajas máximas. Si un bloque termina antes, el margen pasa al
inventario P2. No se amplía el alcance para llenar tiempo.

## 4. Tratamiento del bloqueo de GitHub

La autenticación local de `gh` está caducada. La reautenticación requiere
interacción del propietario y no debe resolverse copiando tokens en comandos,
documentos o logs.

Si no puede completarse en diez minutos:

1. registrar que la validación remota continúa pendiente;
2. no declarar P1 superado;
3. dedicar el resto de la franja remota al inventario estático P2;
4. conservar como siguiente acción exacta la lectura del CI del commit
   publicado.

Un fallo real de CI se analiza dentro del tiempo disponible. Si requiere cambio
de código, se documentará y se preparará un bloque correctivo separado; no se
improvisará una corrección que desplace el inventario P2 sin revisar alcance y
riesgo.

## 5. Validaciones

### Entrada

```powershell
git status --short --branch
git log -8 --oneline --decorate
python -m unittest discover -s tests -v
```

### Puerta P1

- el workflow corresponde al `HEAD` publicado;
- tests y controles de seguridad terminan sin tolerancia silenciosa al error;
- `pip-audit`, Bandit y Gitleaks tienen conclusión verificable;
- cualquier fallo o ausencia de evidencia mantiene P1 pendiente;
- no se ha generado ni instalado una RC.

### Salida

```powershell
git status --short --branch
git diff --check
python -m unittest discover -s tests -v
```

Si durante la sesión solo cambian documentos, la batería final confirma que el
punto seguro técnico no se ha degradado; no convierte la aplicación en apta
para producción.

## 6. Entregables

1. evidencia depurada del CI remoto o bloqueo explícito de autenticación;
2. estado P1 actualizado sin declarar éxito por inferencia;
3. inventario inicial de esquemas y migraciones con riesgos y carencias;
4. propuesta acotada del primer bloque P2;
5. nota didáctica de sesión;
6. relevo actualizado con pruebas, límites y siguiente acción.

## 7. Criterio de terminado

La sesión se considera cerrada cuando:

- el estado local y remoto disponible está registrado;
- P1 queda cerrado con evidencia o continúa pendiente por una causa concreta;
- existe una matriz inicial de migraciones suficiente para planificar P2 sin
  ejecutar DDL;
- las pruebas proporcionales pasan o el fallo queda documentado;
- no se han usado datos reales, secretos ni sistemas externos del cliente;
- el árbol de trabajo y la reversión de cualquier cambio quedan identificados.

## 8. Reversión

Las consultas y pruebas no requieren reversión. Los cambios documentales se
mantendrán separados y podrán revertirse mediante su commit sin afectar a
servidor, base de datos ni instalaciones. No se autoriza ninguna operación
destructiva ni migración durante esta sesión.
