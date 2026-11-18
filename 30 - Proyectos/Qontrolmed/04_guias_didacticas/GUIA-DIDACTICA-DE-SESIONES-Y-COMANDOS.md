---
title: "Guía didáctica de sesiones, comandos y trazabilidad"
type: guide
status: active
created: 2026-11-11
updated: 2026-11-11
sources:
  - "AGENTS.md"
  - "CONTINUAR-SIGUIENTE-SESION.md"
  - "docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md"
tags: [qontrolmed, formacion, sesiones, comandos, trazabilidad]
review_after: 2026-12-11
---

# Guía didáctica de sesiones, comandos y trazabilidad

## 1. Finalidad

Esta guía convierte el trabajo técnico de Qontrolmed en material formativo y
reproducible. Debe permitir que una persona que todavía no domina Git,
PowerShell, Python o la preparación de una aplicación sanitaria para producción
comprenda:

- por qué se realiza cada paso;
- qué modifica y qué no modifica;
- qué significa cada comando y término relevante;
- qué resultado se obtuvo;
- qué riesgos, límites y siguientes pasos quedan abiertos.

Es un documento vivo. Se amplía cuando aparece una herramienta, un concepto o
un procedimiento nuevo, pero no se utiliza como diario cronológico. Los hechos
de cada jornada se registran en `docs/00_seguimiento/diario/`.

## 2. Lectura y mantenimiento obligatorios

Al comenzar una sesión de trabajo se debe:

1. leer `AGENTS.md`, `README.md` y `CONTINUAR-SIGUIENTE-SESION.md`;
2. leer esta guía para aplicar el método de registro;
3. leer el plan o runbook del bloque que se vaya a ejecutar;
4. identificar el punto seguro, los límites y las acciones no autorizadas;
5. abrir o crear la nota didáctica de la sesión cuando se realice una acción
   técnica relevante.

Al terminar una sesión relevante se debe:

1. registrar los comandos ejecutados y su resultado real;
2. separar claramente observaciones, inferencias y decisiones;
3. actualizar el relevo con el nuevo punto seguro;
4. enlazar los documentos vivos modificados;
5. indicar pruebas realizadas, pruebas pendientes y reversión aplicable.

No es necesario copiar salidas completas que ya estén conservadas en una fuente
estable, como GitHub Actions. Se registra el resumen verificable y la referencia.
Nunca se copian contraseñas, tokens, contenido de `.env`, datos reales, datos de
pacientes, certificados privados ni información sensible.

## 3. Estructura de la documentación formativa

### 3.1. Esta guía

Contiene el método común, el vocabulario y la explicación de comandos
reutilizables. Se actualiza cuando cambia el modo de trabajo o aparece un
concepto nuevo.

### 3.2. Diario de sesión

Cada sesión técnica relevante utiliza una nota con nombre
`AAAA-MM-DD-<resumen>.md` dentro de `docs/00_seguimiento/diario/`. La nota
documenta hechos fechados y no sustituye a planes, decisiones o runbooks.

### 3.3. Relevo

`CONTINUAR-SIGUIENTE-SESION.md` resume solo el estado necesario para continuar:
punto seguro, trabajo terminado, límites, validaciones y siguiente acción. No
debe convertirse en una bitácora acumulativa.

## 4. Cómo documentar un paso técnico

Cada paso relevante debe responder a estas preguntas:

| Campo | Pregunta que responde |
| --- | --- |
| Objetivo | ¿Qué se intenta averiguar o conseguir? |
| Motivo | ¿Por qué hace falta ahora? |
| Comando o acción | ¿Qué se ejecutó exactamente? |
| Explicación | ¿Qué significa cada parte no evidente? |
| Tipo de acción | ¿Es lectura, validación, cambio reversible o cambio de alto impacto? |
| Resultado | ¿Qué ocurrió realmente? |
| Interpretación | ¿Qué se deduce y con qué límites? |
| Reversión | ¿Cómo se deshace, si hubo cambios? |

Cuando un comando pueda mostrar secretos o datos sensibles, se documentará una
versión depurada o una descripción, nunca la salida sensible.

## 5. Estados que no deben confundirse

### Observado

Dato comprobado directamente mediante un fichero, un comando o una prueba. Por
ejemplo: «las 24 pruebas terminaron con `OK`».

### Inferido

Conclusión razonable basada en evidencias, pero no demostrada por completo. Por
ejemplo: «la reorganización parece conservar los enlaces activos revisados» no
demuestra que todos los consumidores externos conozcan las rutas nuevas.

### Decidido

Elección aprobada por quien tiene autoridad. Un plan con estado `proposed` no
convierte sus acciones en decisiones aprobadas.

## 6. Conceptos básicos de Git

### Repositorio

Carpeta de trabajo que contiene los ficheros del proyecto y el historial Git.
Git permite comparar estados y recuperar versiones, pero no sustituye las
copias de seguridad de bases de datos ni de ficheros operativos.

### Árbol de trabajo o `working tree`

Estado actual de los ficheros visibles en disco.

### Índice, área de preparación o `staging area`

Conjunto de cambios seleccionados para el siguiente commit. Un cambio preparado
todavía no forma parte del historial.

### `HEAD`

Referencia al commit actualmente situado en la punta de la rama local.

### Rama

Línea de trabajo independiente. En este proyecto las ramas creadas para trabajo
asistido utilizan el prefijo `codex/`.

### Commit

Registro inmutable de un conjunto de cambios con autor, fecha, mensaje e
identificador hash. Un commit no implica por sí mismo despliegue ni producción.

### Diff

Comparación entre dos estados. Puede mostrar cambios del árbol de trabajo, del
índice o de commits distintos.

## 7. Comandos Git utilizados para revalidar una sesión

### `git status --short --branch`

- `git`: ejecuta el sistema de control de versiones.
- `status`: consulta el estado del árbol de trabajo y del índice.
- `--short`: usa una salida compacta.
- `--branch`: añade el nombre y situación de la rama.

Es una lectura no destructiva. Sirve para detectar cambios que deben preservarse
antes de editar.

### `git status --porcelain=v1`

Muestra el estado en un formato estable pensado para scripts. Las dos primeras
columnas indican el estado en el índice y en el árbol de trabajo. Letras
habituales:

- `A`: añadido;
- `M`: modificado;
- `D`: eliminado;
- `R`: renombrado.

### `git diff --stat` y `git diff --shortstat`

`diff` compara cambios. Sin `--cached`, compara el árbol de trabajo con el
índice. `--stat` muestra un resumen por fichero; `--shortstat`, solo el total.

### `git diff --cached --stat`

`--cached` —también llamado `--staged`— compara el índice con `HEAD`. Permite
revisar qué entraría en el siguiente commit.

### `git diff --check`

Busca problemas de formato en el diff, como espacios finales o marcadores de
conflicto. No valida el comportamiento del programa ni los enlaces.

### `git diff --cached --summary`

Resume operaciones estructurales preparadas: altas, bajas, renombres y cambios
de modo. Es útil cuando existen muchos movimientos de ficheros.

### `git diff --cached --name-status`

Lista cada ruta preparada junto a su tipo de cambio. Puede agruparse para contar
altas, modificaciones, eliminaciones y renombres.

### `git rev-parse HEAD`

Devuelve el hash completo del commit actual. Ese identificador fija de forma
inequívoca la base utilizada.

### `git branch --show-current`

Muestra la rama activa. Es una consulta y no crea ni cambia de rama.

### `git log -1 --format=...`

Consulta el último commit. `-1` limita la salida a uno y `--format` selecciona
los campos, por ejemplo hash, fecha y mensaje.

### `git ls-files`

Lista los ficheros que Git sigue en el estado actual del índice. Combinado con
patrones permite comprobar si todavía quedan artefactos prohibidos versionados.

### `git add -- <rutas>`

Prepara en el índice solo las rutas indicadas. El separador `--` marca el final
de las opciones y evita que una ruta que empiece por guion se interprete como
una opción. `git add` no crea un commit ni publica nada, pero sí modifica el
índice y por eso requiere permiso de escritura dentro de `.git`.

Git crea temporalmente `.git/index.lock` para impedir que dos procesos escriban
el índice al mismo tiempo. Un error al crear ese fichero puede significar que
otra operación está activa o que el proceso no tiene permiso. No se debe borrar
un `index.lock` sin comprobar antes la causa.

### LF y CRLF

Son dos formas de representar el final de una línea de texto:

- LF es habitual en Linux y en muchos repositorios;
- CRLF es habitual en Windows.

El aviso «LF will be replaced by CRLF» informa de una conversión prevista por
la configuración de Git. No equivale por sí solo a un fallo, pero conviene
vigilar que no genere diffs formados únicamente por finales de línea.

### `git commit -m "mensaje"`

Crea un commit con los cambios preparados. `-m` proporciona el mensaje. No
publica el commit en el remoto; para ello haría falta un `push` separado.

### `git switch -c <rama>`

Crea y activa una rama desde el commit actual. Permite separar bloques de
trabajo y volver al punto anterior mediante la rama original.

### `git fsck --full`

Comprueba conectividad e integridad de objetos Git. Los objetos `dangling` están
sin referencia; no son automáticamente corrupción ni deben borrarse sin plan.

### `git worktree list --porcelain`

Enumera árboles de trabajo asociados al repositorio. El formato `porcelain` es
estable para scripts.

### `git config --global --add safe.directory <ruta>`

Autoriza a Git a leer un repositorio cuya propiedad de Windows no coincide con
el usuario del proceso. Debe aplicarse solo a una ruta concreta y conocida,
nunca como comodín general.

### `gh api`

Consulta la API de GitHub con la sesión autenticada. En esta fase se utilizó
solo para leer runs, trabajos y pull requests. Un workflow global `success`
puede ocultar un job fallido si está permitido continuar tras el error.

## 8. Comandos de lectura y búsqueda en PowerShell

### `Get-Content -Raw -LiteralPath <ruta>`

- `Get-Content`: lee un fichero.
- `-Raw`: devuelve todo el contenido como un único bloque de texto.
- `-LiteralPath`: interpreta la ruta exactamente, sin tratar corchetes u otros
  caracteres como patrones.

Es adecuado para leer documentos completos sin modificarlos.

### `Get-ChildItem -Recurse -File -Filter '*.md'`

Enumera ficheros Markdown en una carpeta y sus subcarpetas. `-Recurse` recorre
el árbol, `-File` excluye carpetas y `-Filter` limita el nombre.

### `Test-Path -LiteralPath <ruta>`

Comprueba si una ruta existe. En la validación de enlaces se utiliza para
detectar destinos Markdown ausentes.

### `Measure-Object`

Cuenta elementos o calcula medidas. No cambia los elementos recibidos.

### `Group-Object`

Agrupa elementos por un valor común. Se utilizó para resumir los tipos de
cambio del estado Git.

### `rg`

`rg` es la abreviatura del programa Ripgrep, una herramienta rápida de búsqueda:

- `rg --files`: lista ficheros respetando normalmente `.gitignore`;
- `rg -n <texto> <ruta>`: busca texto y muestra números de línea;
- `-C 8`: incluye ocho líneas de contexto antes y después de cada coincidencia;
- `-g '*.md'`: limita la búsqueda a un patrón de ficheros.

## 9. Pruebas Python

### `python -m unittest discover -s tests -v`

- `python`: inicia el intérprete configurado en la sesión.
- `-m unittest`: ejecuta el módulo estándar de pruebas `unittest`.
- `discover`: busca automáticamente módulos de prueba.
- `-s tests`: fija `tests/` como carpeta inicial.
- `-v`: activa salida detallada con el nombre y resultado de cada prueba.

Un resultado `OK` acredita únicamente los casos ejecutados. No demuestra que la
aplicación completa sea apta para producción, que MySQL funcione en sede ni que
las rutas sin pruebas estén libres de defectos.

## 10. Términos de preparación para producción

### `NO-GO`

Decisión de no autorizar todavía el paso a producción porque existen bloqueos o
evidencias insuficientes. No significa que todo el producto sea inservible.

### P0, P1 y puerta de aceptación

Las fases P0, P1, etc. ordenan el trabajo del plan de producción. Una puerta de
aceptación es un conjunto de condiciones que deben cumplirse antes de avanzar.

### RC o `release candidate`

Paquete candidato a convertirse en versión productiva si supera todas las
validaciones. No es producción y debe probarse con datos ficticios en un entorno
controlado.

### TLS y CA

- TLS cifra la comunicación y puede autenticar al servidor.
- Una CA o autoridad certificadora permite verificar que el certificado del
  servidor pertenece a la identidad esperada.

Cifrar sin verificar identidad no elimina el riesgo de conectarse al servidor
equivocado.

### Mínimo privilegio

Cada cuenta recibe solo los permisos imprescindibles. Los permisos funcionales
de Qontrolmed y los privilegios de la cuenta técnica MySQL son capas distintas.

### RPO y RTO

- RPO: pérdida máxima de datos asumible medida hacia atrás desde un incidente.
- RTO: tiempo objetivo para recuperar el servicio.

Ambos deben demostrarse mediante restauraciones y pruebas, no solo declararse.

### Rollback y restauración

- Rollback: retorno controlado a un estado anterior compatible.
- Restauración: recuperación desde una copia cuando no basta con volver a una
  versión anterior de la aplicación.

Una migración de esquema puede hacer incompatible el ejecutable anterior; por
eso la reversión debe diseñarse antes de ejecutar.

### Fuente de verdad

Ubicación o sistema reconocido como referencia oficial para un tipo de dato o
documento. Evita que varias copias compitan sin saber cuál prevalece.

## 11. Criterio de calidad de una nota didáctica

Una nota es suficiente cuando otra persona puede:

- reproducir las comprobaciones seguras;
- entender los límites de la evidencia;
- distinguir acciones de lectura y acciones con cambios;
- saber qué no debe ejecutar sin autorización;
- retomar el proyecto desde un punto seguro;
- localizar el plan, decisión, runbook o evidencia que gobierna el siguiente
  paso.

La explicación formativa no sustituye las validaciones técnicas. Debe acompañar
el trabajo real y reflejar tanto los éxitos como los fallos.

## 12. Gobierno local de migraciones

### Manifiesto de migraciones

`bd/migraciones/manifest.json` registra únicamente migraciones que han
completado el contrato P2. Cada registro fija identificador, esquema, versión,
estado, dependencias, ruta, hash SHA-256, precheck, postcheck y recuperación.

El hash permite detectar que el SQL cambió después de su revisión. No demuestra
que el contenido sea correcto ni sustituye una revisión técnica. Se calcula
sobre texto UTF-8 con finales de línea LF para que el mismo SQL produzca el
mismo valor en Windows y Linux.

### Validador de solo lectura

```powershell
python scripts/db/validar_manifest_migraciones.py
```

El comando lee JSON y ficheros SQL, comprueba metadatos, orden, rutas y hashes y
termina sin conectarse a MySQL. Un manifiesto válido no aplica migraciones ni
certifica el estado de una base real.

Una migración presente en `bd/migraciones/` pero ausente del manifiesto sigue
siendo material inventariado, no una migración aprobada para ejecución.

### Comprobación de compatibilidad

El comprobador P2B recibe filas ya leídas y las compara en memoria con un
manifiesto validado. Devuelve uno de cuatro estados:

- `compatible`: coincidencia exacta y aplicada;
- `migration-required`: ledger coherente, pero faltan migraciones conocidas;
- `inconsistent`: ausencia, error de lectura, duplicado, salto, hash distinto o
  resultado no aplicado;
- `unsupported-newer`: la base declara una versión posterior.

El comprobador no abre conexiones ni ejecuta SQL. Integrarlo en una herramienta
real requerirá otra capa que solo lea el ledger mediante TLS y mínimo privilegio.

## 13. Publicación documental en Obsidian

La documentación oficial de Qontrolmed permanece en el repositorio. Para
consultarla en Obsidian sin volver a introducir ediciones manuales o fuentes
paralelas se publica una selección explícita y unidireccional.

Antes de escribir se puede revisar la diferencia:

```powershell
python scripts/documentacion/publicar_obsidian.py --comprobar
```

Si existen cambios seleccionados, la publicación se realiza con:

```powershell
python scripts/documentacion/publicar_obsidian.py
```

El primer comando no escribe; el segundo compara el hash SHA-256 y copia solo
los ficheros distintos. El manifiesto
`scripts/documentacion/seleccion_obsidian.json` decide qué contenido tiene
valor de seguimiento, aprendizaje o consulta futura. El proceso no importa
ediciones desde Obsidian ni borra material previo.
