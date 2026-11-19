---
title: "P2X — Provisión por puesto, fase A local"
type: state
status: completed
created: 2026-11-19
updated: 2026-11-19
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2X-PROVISION-PUESTOS-Y-CONEXION-SEDE-2026-11-18.md"
tags: [qontrolmed, sesion, p2x, puestos, mysql]
review_after: 2026-12-19
---

# Sesión 2026-11-19: P2X fase A local
[[masgesth]]

## Objetivo y motivo

Preparar la provisión segura de cuatro o cinco puestos sin esperar a que el
cliente entregue todos los datos de sede. El propietario decidió que puede
proponer parte del direccionamiento y que algunos detalles podrán cerrarse al
aproximarse la instalación o remotamente cuando exista un canal aprobado.

## Punto seguro y límites

- Rama: `codex/produccion-readiness`; base de sesión `90e40ad`.
- Se preservó el cambio local previo de
  `docs/01_gobierno_y_decisiones/roles_operativos_acceso.md`.
- No se conectó al servidor, no se inspeccionaron secretos y no se modificaron
  MySQL, red, UFW, certificados, cuentas reales ni RC.
- La fase B continúa no autorizada.

## Pasos, comandos y aprendizaje

### 1. Revalidación documental y de estado

```powershell
Get-Content README.md, CONTINUAR-SIGUIENTE-SESION.md
git status --short --branch
```

- **Motivo**: confirmar el punto de partida y no mezclar cambios previos.
- **Tipo de acción**: lectura.
- **Resultado observado**: P2X estaba propuesto para una fase A local; existía
  un cambio previo ajeno a P2X que se preservó.

### 2. Contrato, plantillas y provisión

Se documentó una identidad técnica distinta por puesto, limitada a su origen
exacto, con `REQUIRE SSL` y la matriz por tabla de P2U. Se prepararon plantillas
no ejecutables para alta, verificación, rotación y baja. Los marcadores
obligatorios detienen la ejecución y los secretos se solicitan sin eco.

`REQUIRE SSL` obliga a cifrar el transporte desde MySQL, mientras que la
verificación de CA e identidad en Qontrolmed evita conectar con un servidor
suplantado. Son controles complementarios.

### 3. Inventario y aplazamiento controlado

Se separaron los valores propuestos de los confirmados. Una IP propuesta solo
pasa a definitiva tras revisar rango DHCP, reservas, gateway, DNS y ausencia
de conflictos. Se clasificaron tareas potencialmente remotas y tareas que
requieren sede o un procedimiento remoto expresamente validado.

### 4. Pruebas

```powershell
python -m unittest tests.test_p2x_workstation_templates -v
python -m unittest discover -s tests -v
python -m bandit -c bandit.yaml -r src -x "*/__pycache__/*" -ll
python scripts/documentacion/publicar_obsidian.py --comprobar
```

- **Resultado observado**: 5/5 pruebas específicas y 100/100 pruebas totales
  correctas; Bandit sin hallazgos medios o altos; sintaxis de las cuatro
  plantillas correcta con Git Bash; JSON del manifiesto válido y
  `git diff --check` sin errores.
- **Interpretación y límites**: validación local y estática; no demuestra aún
  conectividad desde un puesto real ni el direccionamiento de sede.

La vista previa de publicación mostró siete documentos pendientes, incluido
el cambio local previo de `roles_operativos_acceso.md`. No se publicó para no
propagar ese cambio ajeno a P2X junto con el cierre de esta sesión.

## Cambios cerrados

- fase A de P2X completada;
- contrato de identidad y ciclo de vida por puesto;
- runbook futuro de provisión y reversión;
- inventario de datos de sede;
- plantillas administrativas y pruebas de regresión;
- plan y relevo actualizados.

## Observado, inferido y decidido

### Observado

- La matriz P2U contiene 24 concesiones exactas por tabla.
- El repositorio superó 100 pruebas tras incorporar P2X.

### Inferido

- Esperar todos los datos del cliente bloquearía innecesariamente el trabajo
  local, pero asignar IP definitivas sin revisar el router introduciría riesgo
  de conflicto o de quedar dentro del pool dinámico.

### Decidido

- El propietario puede preparar la propuesta de IP y códigos de puesto.
- Los valores de red se confirmarán en sede antes de activar la fase B.
- Las tareas remotas solo se harán con autorización, canal y reversión
  definidos; no se presupone acceso al router o a los puestos.

## Riesgos y pendientes

- inventario real del primer puesto, MAC y usuario ordinario;
- rango DHCP, reservas, gateway y DNS;
- IP/nombre definitivo del servidor y certificado compatible;
- responsable y ventana de aceptación;
- plan transversal autorizado de fase B.

## Siguiente paso recomendado

Completar una propuesta de direccionamiento cuando se conozca el router o se
aproxime la instalación. Con ese mínimo, preparar el plan operativo P2X-B por
puesto y separar su ejecución remota de la ventana de sede.
