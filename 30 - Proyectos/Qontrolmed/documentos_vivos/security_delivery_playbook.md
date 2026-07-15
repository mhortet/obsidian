---
tags:
  - app
  - documentacion
Creado: 2026-07-14
Relacionado:
---

# Playbook operativo de seguridad y entrega
[[masgesth]]
Fecha de revision: 2026-07-14

## Objetivo

Fijar la rutina de trabajo para el proyecto conjunto `maxgesth` +
`maxgesth_port` + `maxgestq_mov`, con foco en llegar a septiembre con una
version inicial de produccion controlada.

Este documento describe como entrar, decidir, validar y cerrar trabajo. El
roadmap vive en `docs/plan_seguridad_consistencia.md` y la foto breve de
reanudacion en `docs/estado_continuidad.md`.

## Lectura obligatoria al iniciar sesion

1. `D:/trabajo/Proyectos/maxgesth/docs/security_delivery_playbook.md`
2. `D:/trabajo/Proyectos/maxgesth/docs/estado_continuidad.md`
3. `D:/trabajo/Proyectos/maxgesth/docs/plan_seguridad_consistencia.md`

Lectura adicional solo si aplica:

- `docs/mapa_documental_proyecto.md`: si se toca documentacion o clasificacion
  de fuentes.
- `docs/cola_triaje_campo.md`: si se abre trabajo de Preventivos de campo.
- nota local del repo movil si se toca `maxgesth_port` o `maxgestq_mov`.

Despues revisar estado Git:

```powershell
git -C D:\trabajo\Proyectos\maxgesth status --short --branch
git -C D:\trabajo\Proyectos\maxgesth_port status --short --branch
git -C D:\trabajo\Proyectos\maxgestq_mov status --short --branch
```

Y crear o actualizar, si procede, el parte externo:

```text
D:\trabajo\Proyectos\diario_qontrolmed\sesion_YYYY-MM-DD_HH-mm.md
```

## Herramientas de consola

- Los comandos documentados para uso operativo del usuario se escriben por
  defecto en PowerShell.
- Git Bash queda como herramienta auxiliar del agente, no como requisito de
  trabajo del usuario.
- Usar Git Bash solo cuando facilite scripts largos, heredocs o problemas de
  comillas propios de PowerShell.
- Si se usa Git Bash, invocarlo por ruta explicita:
  `C:\Program Files\Git\bin\bash.exe`.
- No invocar `bash` a secas en Windows: puede resolver a WSL
  (`C:\Windows\System32\bash.exe`) y fallar si no hay distribucion Linux
  instalada.
- No convertir ejemplos ni recetas del proyecto a Bash salvo peticion expresa o
  necesidad tecnica concreta; mantener PowerShell como formato principal de
  documentacion operativa.

## Propuesta minima de sesion

La primera propuesta debe incluir:

- tarea principal;
- tarea alternativa;
- tests o comprobaciones de cierre;
- validacion manual esperada;
- dependencias con repos, contratos, migraciones, entorno o decisiones externas.

Linea por defecto hasta septiembre:

- hardening y readiness de produccion;
- configuracion local e instalacion;
- seguridad, roles, auditoria y migraciones;
- maestros minimos;
- campo Preventivos ya validado, empezando por severidad `alta`;
- Quirofanos movil solo por incidencia o contrato;
- Compras e Informes/Analitica ampliados en standby.

## Reglas de prioridad

- No abrir trabajo funcional nuevo si no ayuda a la version inicial de
  septiembre.
- Una incidencia `bloqueante` o `alta` de campo puede romper prioridad.
- Una mejora `media` se agrupa por paquete y se ejecuta si no desplaza
  seguridad, instalacion o consistencia.
- Compras operativas e Informes ampliados no se programan para el primer corte.
- Cualquier cambio de contrato JSON debe revisarse en ambos lados del flujo.

## Tratamiento de cambios ajenos

- Revisar `git status --short --branch` antes de tocar archivos.
- No revertir cambios ajenos.
- Si afectan al mismo flujo, leerlos antes de editar.
- Mantener separados cambios funcionales, documentales y temporales.
- No versionar exports, bases locales, builds, caches ni artefactos Android.

## Reglas de ramas

- No trabajar directamente sobre `main` para cambios relevantes.
- Si `maxgestq_mov` se reabre desde `main`, crear rama antes de tocar logica.
- Usar commits pequenos y con un solo objetivo.
- No mezclar cambios de varios repos salvo que formen una unica historia de
  contrato o entrega.
- No usar `git push --force` en ramas compartidas.

## Politica de tests

### maxgesth / Qontrolmed

Validacion base si hay codigo:

```powershell
python -m compileall main.py src
```

Si se toca autenticacion, permisos, usuarios, auditoria o maestros:

- compilar modulos tocados;
- probar caso feliz;
- probar denegacion o conflicto;
- verificar persistencia real.

Si se valida Paquete A de Preventivos en escritorio:

```powershell
python scripts\validate_preventivos_tablet_fixture.py
python scripts\check_preventivos_paquete_a_schema.py
```

La importacion real de resultados tablet debe ejecutarse solo sobre BD de
preproduccion o copia controlada, no contra produccion sin confirmacion
explicita.

Receta completa:

- `docs/runbook_validacion_paquete_a_preventivos_datos_reales.md`

Si se toca schema:

- usar migracion SQL documentada;
- validar en entorno de prueba;
- anotar rollback o reversion manual razonable.

### maxgesth_port / Preventivos tablet

Solo tocar por contrato, import/export, cierre de observaciones de campo o
incidencia real.

```powershell
python test_import.py
python test_report_service.py
python -m py_compile src\data\schema.py src\services\import_service.py src\services\report_service.py src\services\export_service.py
```

Si cambia UI o flujo Android, anadir prueba manual en Windows y APK/tablet.
Si GitHub Actions queda bloqueado por cuota mensual, usar
`scripts/build_android_apk.ps1 -ChecksOnly` en `maxgesth_port` como evidencia
tecnica temporal y dejar la prueba APK/tablet explicitamente pendiente.

### maxgestq_mov / Quirofanos tablet

Solo tocar por contrato, import/export, build Android o incidencia real.

```powershell
python -m unittest test_import_export_contract.py test_catalog_service.py test_point_validation.py test_informe_service.py
python -m compileall -q main.py src test_catalog_service.py test_import_export_contract.py test_informe_service.py test_point_validation.py
```

### Sesiones solo documentales

- Verificar rutas, fechas y nombres de modulo.
- Comprobar coherencia entre playbook, continuidad, roadmap y mapa documental.
- No duplicar backlog ni cronologia.
- Mantener copias previas en `historico_doc` antes de editar documentos vivos.

## Cierre de tarea

Una tarea no se considera cerrada solo porque compile o porque el texto quede
actualizado. Cierre completo implica:

1. resumen claro del cambio;
2. tests o comprobaciones realizadas;
3. validacion manual realizada o pendiente;
4. documentacion viva actualizada;
5. commit pequeno y coherente;
6. push de la rama correspondiente.

No se hace commit automatico: se espera confirmacion positiva del usuario para
cerrar y publicar.

## Secretos, runtime y artefactos

- `.env` real nunca debe versionarse.
- `.env.example` solo contiene variables y valores falsos.
- La ruta canonica del `.env` es `compartido/.env` en desarrollo y
  `C:\ProgramData\Qontrolmed\config\.env` en el ejecutable congelado.
- `src/compartido/.env` queda como ruta antigua de desarrollo y no debe usarse
  en nuevas instalaciones ni soporte.
- Ningun `.env` real se incorpora al artefacto PyInstaller ni al ZIP de entrega.
- En una instalacion multiusuario, los binarios viven en `Program Files` y los
  datos operativos compartidos en `ProgramData`.
- La receta operativa vive en `docs/checklist_configuracion_preproduccion.md`.
- `dist/`, `build/`, `_internal/`, caches, bases locales, exports y temporales
  no deben entrar en commits funcionales.
- Assets de cliente, logos externos, certificados PDF reales y datos
  operativos se tratan como material de despliegue, no como fuente estable.
- El intercambio con tablet debe vivir en carpetas runtime, no dentro de codigo
  fuente.

## Criterios tecnicos obligatorios

- Las operaciones cabecera-detalle deben ser atomicas.
- La logica critica vive en servicios reutilizables, no repartida en UI.
- No introducir `ALTER TABLE` ni autoajustes de schema en flujos normales sin
  migracion documentada.
- Los contratos JSON deben validar version, estructura y sentido del flujo.
- Los textos visibles al usuario deben estar sin mojibake antes de dar una
  version por valida.

## Cuando actualizar documentacion viva

Actualizar documentos activos si cambia:

- prioridad principal;
- flujo de cierre;
- tests minimos;
- ramas o estado local relevante;
- criterio de produccion, seguridad, rutas o contrato;
- clasificacion entre documento vivo e historico;
- decisiones sobre campo Preventivos, standby de Quirofanos o version posterior
  de Compras/Informes.

Documentos satelite:

- `D:/trabajo/Proyectos/maxgesth_port/docs/security_delivery_playbook.md`
- `D:/trabajo/Proyectos/maxgestq_mov/docs/continuidad_local.md`
