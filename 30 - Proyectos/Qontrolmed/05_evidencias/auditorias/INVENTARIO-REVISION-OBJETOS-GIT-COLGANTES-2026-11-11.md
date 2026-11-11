---
title: "Inventario para revisión de objetos Git colgantes"
type: evidence
status: review
created: 2026-11-11
updated: 2026-11-11
sources:
  - "docs/05_evidencias/auditorias/LINEA-BASE-TECNICA-P0-2026-11-11.md"
  - "docs/02_planes_y_arquitectura/PLAN-EJECUCION-P0-PRODUCCION-READINESS-2026-11-11.md"
tags: [qontrolmed, git, objetos, historico, revision]
review_after: 2026-11-18
---

# Inventario para revisión de objetos Git colgantes

## 1. Finalidad y límite

Este documento identifica el contenido histórico que `git fsck` encuentra sin
una referencia activa y lo relaciona, cuando es posible, con un fichero actual.
Su finalidad es permitir una revisión humana antes de cualquier limpieza.

**No se ha eliminado, recuperado, podado ni modificado ningún objeto Git.** No
debe ejecutarse `git prune`, `git gc --prune=now` ni una operación equivalente
hasta que se cierre esta revisión y exista un clon limpio verificado.

## 2. Qué significan los términos

- **objeto Git**: unidad interna con la que Git almacena contenido e historia;
- **blob**: contenido de un fichero, sin nombre ni ruta propios;
- **tree**: fotografía interna de un directorio y de sus entradas;
- **commit**: fotografía identificada que enlaza árboles, autor, fecha y padres;
- **colgante** (`dangling`): objeto que existe en la base local de Git, pero al
  que no llega ninguna rama o etiqueta activa;
- **hash**: identificador SHA-1 del objeto en este repositorio.

Por tanto, no existen 346 «ficheros sueltos» con nombre. El inventario detectó
11 blobs, 2 commits y 334 árboles. Los árboles son estructuras internas y no se
presentan como 334 documentos independientes.

## 3. Resumen ejecutivo

| Clase | Cantidad | Resultado de la identificación | Recomendación provisional |
| --- | ---: | --- | --- |
| Blobs | 11 | Diez son versiones anteriores de 7 documentos vigentes; uno es una versión intermedia de este inventario | Revisar la tabla; no se observa contenido único que recuperar |
| Commits | 2 | Un `stash` antiguo de iconos y un WIP de un runbook | Ambos parecen integrados o superados |
| Trees | 334 | Fotografías internas intermedias, principalmente asociadas a trabajo histórico | No revisar como ficheros individuales |

La conclusión es **provisional**: el propietario debe marcar cada grupo como
`conservar`, `recuperar` o `descartar` antes de autorizar una limpieza.

## 4. Commits colgantes para revisar

### 4.1. `8e1c0309a97964454b51ffef1a32964417107b8f`

- Asunto: `On pdf_quirofano: pre-feature-plantillas-blanco`.
- Fecha: 27 de mayo de 2026.
- Naturaleza: commit de tres padres generado como `stash` o WIP.
- Cambios frente a su primer padre:
  - modificación de `icono.ico`;
  - eliminación de `pdf_assets/qontrolmed/icons/OK.svg`;
  - eliminación de `pdf_assets/qontrolmed/icons/conIncidencias.svg`;
  - eliminación de `pdf_assets/qontrolmed/icons/noUtilizar.svg`.
- Comprobación: el contenido histórico de `icono.ico`, blob
  `b9a05072fd536436cd5be5d0a8ced6fa81f82738`, coincide exactamente con el
  fichero vigente `icono1.ico`.
- Interpretación: el commit no aporta un icono binario único; las otras tres
  entradas representan eliminaciones, no tres ficheros nuevos recuperables.
- Recomendación provisional: **descartable tras revisión visual de
  `icono1.ico`**, si el propietario quiere confirmar el aspecto del recurso.

### 4.2. `bce19238cce94ff806336fde00738723ea64d515`

- Asunto: `On fix-trabajo-campo: wip-previo-antes-merge-main-preventivos`.
- Fecha: 13 de julio de 2026.
- Naturaleza: commit de tres padres generado como `stash` o WIP.
- Fichero afectado:
  `docs/runbook_validacion_paquete_a_preventivos_datos_reales.md`.
- Ruta vigente:
  `docs/03_operacion_y_runbooks/runbook_validacion_paquete_a_preventivos_datos_reales.md`.
- Comprobación: la versión actual conserva el contenido y solo corrige la ruta
  prevista para la evidencia, de `docs/diario_sesiones/YYYY-MM-DD.md` a
  `docs/00_seguimiento/diario/YYYY-MM-DD.md`.
- Recomendación provisional: **descartable**; la versión vigente es la adaptada
  a la estructura documental actual.

## 5. Blobs colgantes para revisar

| Hash del blob | Tamaño | Documento al que corresponde | Diferencia frente a la versión vigente | Evaluación provisional |
| --- | ---: | --- | --- | --- |
| `82805d45e99cc257c316bd350c97cec2940764c8` | 11.752 B | `docs/04_guias_didacticas/GUIA-DIDACTICA-DE-SESIONES-Y-COMANDOS.md` | La versión vigente añade 55 líneas | Versión anterior superada |
| `278b47692bb5b9e609092090d8699a1acfe8d150` | 2.257 B | `CONTINUAR-SIGUIENTE-SESION.md` | La vigente añade 41 y sustituye 16 líneas | Relevo anterior superado |
| `4b4d96790812cdc579c6eb011719f5d18157d78c` | 3.015 B | `CONTINUAR-SIGUIENTE-SESION.md` | La vigente añade 26 y sustituye 13 líneas | Relevo intermedio superado |
| `398fac8c1122cd1971c5d0d76af72b29f74713fd` | 18.107 B | `docs/02_planes_y_arquitectura/PLAN-ADAPTACION-DOCUMENTAL-MAXGESTH-AL-MODELO-SERVIDOR-2026-11-10.md` | Conserva el estado intermedio de 3,08 GiB eliminados y residuos pendientes | No restaurar: el cierre vigente está verificado |
| `f150616544cbb04b89575dfc8469aac4bb6c685f` | 18.076 B | Mismo plan de adaptación documental | Conserva un estado todavía anterior, con la limpieza bloqueada | No restaurar: contradice el cierre vigente |
| `ddadc84e05eee4e47028d699622d807befb09794` | 8.231 B | `docs/00_seguimiento/diario/2026-11-11-revision-estructural-y-trazabilidad-didactica.md` | La vigente añade 114 líneas de continuidad P0 | Bitácora anterior superada |
| `a3d86dc95dc7b6cec3984a76c9efa873fd3dcbc8` | 6.612 B | `docs/00_seguimiento/backlog/BACKLOG-EVOLUTIVO.md` | Solo cambia formato de dos líneas de cabecera | Contenido conservado |
| `32dd005ac5f624ea482cbc140079a229fec48683` | 2.406 B | `docs/00_seguimiento/estados/ESTADO-REORGANIZACION-DOCUMENTAL-2026-11-10.md` | La vigente añade 5 líneas de validación final | Estado anterior superado |
| `da77a59fbf0295c075e9d7418bdb2c1daed905d1` | 31.745 B | `docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md` | La vigente incorpora decisiones aprobadas de retención, soporte y release | Propuesta anterior superada |
| `ac7fb191d112a5d3d913c50635f637ad784b42a3` | 1.470 B | Mismo estado de reorganización documental | La vigente documenta la limpieza completa y la revalidación | Estado preliminar superado |
| `96481bcafc4b94f8d901a0719a9b7ce1c62ad226` | 8.961 B | Este inventario | Versión intermedia creada al preparar el primer commit; solo añade una línea vacía final respecto de la versión del commit `ed6e698` | Descartable; no aporta contenido |

El undécimo blob apareció durante la propia documentación: se preparó una
primera versión, `git diff --cached --check` señaló una línea vacía al final y
se corrigió antes del commit. La revalidación posterior lo hizo visible como
objeto colgante y por eso se incorpora expresamente al inventario.

## 6. Árboles colgantes

Los 334 objetos `tree` no se listan uno a uno porque un árbol no equivale a un
fichero: representa nombres, modos y hashes de una fotografía de directorio.
Su elevado número es compatible con estados intermedios de índice, stashes y
reestructuraciones. Los commits y blobs con contenido revisable ya quedan
enumerados en las secciones anteriores.

Si durante la revisión aparece una ruta histórica concreta que se quiera
reconstruir, se puede consultar el árbol correspondiente sin restaurarlo sobre
el directorio de trabajo.

## 7. Comandos usados y significado

### Comprobar la base de objetos

```powershell
git fsck --full --no-reflogs
```

- `git fsck`: comprueba conectividad e integridad de los objetos;
- `--full`: examina todos los almacenes de objetos disponibles;
- `--no-reflogs`: no considera los reflogs como referencias, para descubrir
  objetos que no están sostenidos por ramas o etiquetas.

### Leer metadatos y contenido sin restaurar

```powershell
git show --no-patch --pretty=fuller <hash-del-commit>
git cat-file -s <hash-del-blob>
git cat-file blob <hash-del-blob>
```

- `git show --no-patch` muestra los metadatos del commit sin aplicar cambios;
- `git cat-file -s` devuelve el tamaño del objeto;
- `git cat-file blob` lee su contenido por salida estándar, sin crear ficheros.

### Comparar con el documento vigente

```powershell
git diff --numstat <hash-del-blob> HEAD:<ruta-vigente>
```

- `git diff` compara dos contenidos;
- `--numstat` resume líneas añadidas y eliminadas;
- `HEAD:<ruta>` identifica el contenido versionado actualmente para esa ruta.

## 8. Decisión solicitada

Para cerrar esta revisión, marcar:

| Grupo | Decisión | Observaciones del revisor |
| --- | --- | --- |
| Commit del icono `8e1c030...` | Pendiente | |
| Commit del runbook `bce1923...` | Pendiente | |
| Once blobs documentales | Pendiente | |
| 334 árboles internos | Pendiente | |

Opciones válidas: `conservar`, `recuperar` o `descartar`. **Descartar** significa
autorizar una fase posterior de saneamiento; este documento por sí mismo no
autoriza ni ejecuta la poda.

## 9. Condiciones previas a una futura limpieza

1. revisión y decisión registrada sobre los cuatro grupos;
2. clon limpio desde las referencias que se decida conservar;
3. comparación del clon con el commit y los documentos vigentes;
4. copia recuperable del repositorio antes del saneamiento;
5. ejecución mediante un plan separado, con precheck y postcheck;
6. confirmación de que ninguna rama, etiqueta o worktree necesaria depende de
   los objetos candidatos.
