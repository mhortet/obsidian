---
title: "Publicación documental curada de Qontrolmed en Obsidian"
type: state
status: active
created: 2026-11-12
updated: 2026-11-12
sources:
  - "../../../scripts/documentacion/seleccion_obsidian.json"
  - "../../03_operacion_y_runbooks/PUBLICAR-DOCUMENTACION-CURADA-EN-OBSIDIAN.md"
tags: [qontrolmed, sesion, documentacion, obsidian]
review_after: 2027-02-12
---

# Sesión 2026-11-12: publicación documental curada en Obsidian

## Objetivo y motivo

Separar la documentación oficial de Qontrolmed de la biblioteca personal de
consulta. Las copias manuales antiguas generaban divergencias y dificultaban
identificar qué documento gobernaba el proyecto.

## Punto seguro y límites

- Rama: `codex/produccion-readiness`.
- Se preservaron los cambios previos de coordinación con Servidor_MM presentes
  en `AGENTS.md` y `CONTINUAR-SIGUIENTE-SESION.md`.
- No se modificó código funcional, servidor, base de datos, configuración ni
  datos reales.
- No se eliminó ni reorganizó material antiguo del vault de Obsidian.

## Pasos, comandos y aprendizaje

### Inventario de origen y destino

Se revisaron la estructura documental de Qontrolmed, las instrucciones de la
bóveda y el contenido existente en `30 - Proyectos/Qontrolmed`. Se observó que
el destino contiene copias históricas, duplicados y una réplica extensa de
`docs/`, por lo que una limpieza automática habría mezclado publicación y
archivo histórico.

### Selección y publicación reproducible

Se creó un manifiesto explícito para documentos de seguimiento reciente,
aprendizaje, arquitectura, gobierno y operación reutilizable. Se excluyeron
por defecto evidencias, inventarios, histórico sustituido, backlog y planes de
ejecución puntuales.

```powershell
python scripts/documentacion/publicar_obsidian.py --comprobar
python scripts/documentacion/publicar_obsidian.py
```

- **Tipo de acción**: la primera orden es de lectura; la segunda copia de forma
  reversible al destino de consulta.
- **Qué hace**: compara SHA-256, copia solo ficheros distintos y genera un
  índice con la procedencia.
- **Reversión**: el origen no cambia; una retirada del destino se hará mediante
  revisión explícita, nunca por borrado automático del publicador.

## Observado, inferido y decidido

### Observado

- Ya existía una carpeta Qontrolmed en la bóveda con material antiguo y
  duplicado.
- Abrir o editar el repositorio directamente desde Obsidian había causado
  problemas previos de coordinación.

### Inferido

- Una zona nueva y claramente derivada evita confundir copias antiguas con la
  fuente vigente sin destruir conocimiento acumulado.

### Decidido

- Qontrolmed es la única fuente oficial de su documentación.
- Obsidian recibe una copia unidireccional en `consulta_publicada`.
- Cada cierre de sesión revisa el manifiesto y ejecuta la comprobación; solo se
  publica cuando hay cambios seleccionados.

## Riesgos y pendientes

- La carpeta histórica de Obsidian continúa existiendo y puede contener
  versiones antiguas. Su limpieza requiere un plan separado con inventario y
  reversión.
- Un documento nuevo no se incorpora automáticamente: debe evaluarse y
  añadirse expresamente al manifiesto.

## Validaciones realizadas

- Publicación aislada en una carpeta temporal: 40 ficheros copiados.
- Segunda comprobación sobre el destino temporal: 0 copias pendientes.
- Publicación en Obsidian: 40 ficheros copiados a `consulta_publicada`.
- Segunda comprobación sobre Obsidian: 0 copias pendientes.
- Compilación del publicador con `python -m py_compile`: correcta.
- `git diff --check`: sin errores; solo avisos informativos de conversión de
  finales de línea de Git.
- Lint completo de la bóveda: 0 errores y 81 avisos. Los avisos corresponden a
  revisiones vencidas y taxonomía preexistente, incluidas etiquetas de los
  documentos copiados; no impidieron la publicación ni modificaron el origen.
