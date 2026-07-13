---
tags:
  - app
  - aprendizaje
  - codigo
  - manuales
  - mapa
Creado:
Autor:
Relacionado:
---
## Resumen

## Descripción


# Mapa documental local - maxgesth_port
[[maxgesth_port]]
Fecha de revision: 2026-06-26

## Objetivo

Ordenar la documentacion local para que cada entrada al repo tenga una ruta
breve, actual y compatible con el repo principal `maxgesth`.

Este repo no debe tener un roadmap paralelo. Su documentacion viva explica el
estado de la tablet offline de Preventivos y apunta a `maxgesth` cuando la
decision afecta a producto, seguridad, roadmap o contrato global.

## Lectura minima local

1. `AGENTS.md`
2. `docs/security_delivery_playbook.md`
3. `docs/estado_continuidad_local.md`
4. `specifications/remote_tablet_preventivos.md`
5. `README.md`

## Lectura canonica en maxgesth

Cuando la tarea afecte a contrato, importacion/exportacion, prioridad de
septiembre, seguridad o campo, leer tambien:

1. `D:/trabajo/Proyectos/maxgesth/docs/security_delivery_playbook.md`
2. `D:/trabajo/Proyectos/maxgesth/docs/estado_continuidad.md`
3. `D:/trabajo/Proyectos/maxgesth/docs/plan_seguridad_consistencia.md`
4. `D:/trabajo/Proyectos/maxgesth/docs/cola_triaje_campo.md`
5. `D:/trabajo/Proyectos/maxgesth/specifications/remote_tablet_preventivos.md`

## Documentacion viva local

### Entrada y continuidad

- `AGENTS.md`: reglas de entrada para agentes y limites de trabajo.
- `docs/security_delivery_playbook.md`: playbook operativo local.
- `docs/estado_continuidad_local.md`: foto breve de reanudacion del repo.
- `docs/mapa_documental_local.md`: clasificacion documental y fuente de verdad.

### Producto y contrato local

- `specifications/remote_tablet_preventivos.md`: alcance funcional local de la
  tablet, contrato operativo y referencias a escritorio.
- `README.md`: arranque rapido, flujo operativo y enlaces principales.

### Build y entrega

- `docs/android_local_build.md`: build APK local en Windows; via recomendada
  para pruebas de campo.
- `docs/android_remote_build.md`: build APK en GitHub Actions; respaldo si
  falla local, se necesita artifact compartible o validacion en entorno limpio.
- `scripts/build_android_apk.ps1`: automatizacion local de validaciones y build.

### Evidencia y soporte

- `docs/session_2026-05-28_campana_tablet_preventivos.md`: evidencia historica
  de trazabilidad de campana.
- `docs/github_ssh_operativa.md`: soporte operativo GitHub/SSH en Windows.
- `.github/`: workflows y reglas de mantenimiento automatizado.

## Candidatos a historico o retirada

No borrar sin confirmacion explicita. Revisar cuando se haga limpieza fina:

- `SETUP.md`: parece guia inicial antigua, con mojibake y comandos posiblemente
  superados por `README.md`.
- `IMPORT_EXPORT_GUIDE.md`: guia antigua con mojibake y ejemplos previos al
  contrato actual; conservar hasta contrastar con `specifications/`.
- `docs/Entendiendo el proceso de bases de datos.docx`: documento binario sin
  papel claro dentro de la documentacion viva.

## Regla de mantenimiento

- Mantener una sola fuente viva para cada objetivo.
- Si cambia contrato JSON o estado de campo, actualizar este repo y revisar
  `maxgesth`.
- Si la informacion solo es evidencia de una sesion, moverla a `historico_doc/`
  o a una nota fechada.
- Antes de editar documentos vivos, crear snapshot en `historico_doc/`.
