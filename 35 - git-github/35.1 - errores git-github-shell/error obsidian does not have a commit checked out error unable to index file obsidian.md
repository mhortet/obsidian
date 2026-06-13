---
tags:
  - Error
  - git
  - software
Creado: 2026-06-06
Autor:
Relacionado:
---
## Alcance
Conversación con IA sobre error en título
## Descripción



Ese error suele aparecer cuando **la carpeta `obsidian/` está siendo tratada como un submódulo Git**, pero dentro no hay ningún commit válido asociado.

Comprueba qué tienes exactamente:

```
git status
```

y también:

```
git submodule status
```

Además, mira si existe una carpeta `.git` dentro de `obsidian`:

```
dir obsidian /adir obsidian\.git /a
```

Las causas más habituales son:

### Caso 1: Has inicializado Git dentro de una carpeta de Obsidian y luego Git dentro de otra

Ejemplo:

```
Vault/├── .git└── obsidian/    └── .git
```

En ese caso Git interpreta `obsidian` como repositorio independiente y da ese error.

Solución:

```
rmdir /s obsidian\.gitgit add obsidian
```

---

### Caso 2: `obsidian` fue añadido como submódulo accidentalmente

Si existe un archivo `.gitmodules` en la raíz:

```
type .gitmodules
```

y aparece algo parecido a:

```
[submodule "obsidian"]    path = obsidian
```

entonces es un submódulo.

---

### Caso 3: El plugin de Obsidian ha intentado versionar la carpeta `.obsidian`

A veces se confunden:

- `.obsidian` → configuración del vault
- `obsidian` → carpeta normal

Revisa cuál de las dos te está dando el error.

---

Pásame la salida de:

```
git statusgit submodule statusdir /adir obsidian /a
```

y te digo exactamente qué está pasando. Tiene toda la pinta de ser un `.git` anidado o un submódulo creado sin querer.

On branch main Your branch is up to date with 'origin/main'. Untracked files: (use "git add <file>..." to include in what will be committed) .obsidian/ 15 - Notas diarias/ 20 - Notas enlazadas/ 30 - Proyectos/ 40 - Hospital/ 50 - Recursos/ Diagram.svg.xml obsidian/ nothing added to commit but untracked files present (use "git add" to track) dir : No se encuentra la ruta de acceso 'D:\a' porque no existe. En línea: 3 Carácter: 1 + dir /a + ~~~~~~ + CategoryInfo : ObjectNotFound: (D:\a:String) [Get-ChildItem], ItemNotFoundException + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.GetChildItemCommand dir : El segundo fragmento de la ruta de acceso no debe ser un nombre de unidad o UNC. Nombre del parámetro: path2 En línea: 4 Carácter: 1 + dir obsidian /a + ~~~~~~~~~~~~~~~ + CategoryInfo : InvalidArgument: (D:\soft\python\...sgesth\obsidian:String) [Get-ChildItem], ArgumentExc eption + FullyQualifiedErrorId : DirArgumentError,Microsoft.PowerShell.Commands.GetChildItemCommand

Vale, ahí hay dos cosas:

1. En **PowerShell** `dir /a` no vale como en CMD. Usa:

```
Get-ChildItem -ForceGet-ChildItem .\obsidian -Force
```

2. El problema casi seguro está dentro de la carpeta `obsidian/`.

Ejecuta esto:

```
Get-ChildItem .\obsidian -ForceGet-ChildItem .\obsidian\.git -Force
```

Si aparece `.git` dentro de `obsidian`, bórralo:

```
Remove-Item .\obsidian\.git -Recurse -Force
```

Luego:

```
git add .git commit -m "Añadir vault de Obsidian"git push
```

Ojo: **no borres `.obsidian`**, esa es la configuración del vault. La sospechosa es `obsidian/.git`.

Sí, eso ya es otro problema distinto: **GitHub tiene cambios que tu carpeta local no tiene**.

Hazlo así, sin forzar de momento:

```
git statusgit pull --rebase origin main
```

Si termina bien:

```
git push origin main
```

Si en el `pull --rebase` te dice conflicto, no sigas a ciegas. Mira:

```
git status
```

y pásame lo que salga.

No uses todavía:

```
git push --force
```

porque podrías pisar lo que hay en GitHub.

en github en ese repo, solo hay una copia de esto, lo subí drectamente cuando cree el repo

Entonces normal: GitHub tiene **un commit inicial** y tu local tiene **otro historial distinto**.

Prueba primero esto:

```
git pull --rebase origin maingit push origin main
```

Si te da error de _unrelated histories_, usa:

```
git pull origin main --allow-unrelated-histories
```

Luego:

```
git push origin main
```

Si te pregunta por merge/commit, acepta el mensaje que salga.

Como es el mismo contenido, probablemente Git lo mezclará sin mucho drama. Si sale conflicto, me pegas el `git status`.

remote: Enumerating objects: 73, done. remote: Counting objects: 100% (73/73), done. remote: Compressing objects: 100% (69/69), done. remote: Total 72 (delta 1), reused 0 (delta 0), pack-reused 0 (from 0) Unpacking objects: 100% (72/72), 9.62 MiB | 828.00 KiB/s, done. From https://github.com/mhortet/obsidian * branch main -> FETCH_HEAD cca08ed..9174e37 main -> origin/main error: The following untracked working tree files would be overwritten by merge: .obsidian/workspace.json Please move or remove them before you merge. Aborting hint: Could not execute the todo command hint: hint: pick bbb593078df554eba3deabdb91633111e5d55733 # Añadir vault de Obsidian hint: hint: It has been rescheduled; To edit the command before continuing, please hint: edit the todo list first: hint: hint: git rebase --edit-todo hint: git rebase --continue To https://github.com/mhortet/obsidian.git ! [rejected] main -> main (non-fast-forward) error: failed to push some refs to 'https://github.com/mhortet/obsidian.git' hint: Updates were rejected because a pushed branch tip is behind its remote hint: counterpart. If you want to integrate the remote changes, use 'git pull' hint: before pushing again. hint: See the 'Note about fast-forwards' in 'git push --help' for details.

Vale, Git se ha quedado **a mitad de rebase**. Primero salimos de ahí:

```
git rebase --abort
```

Luego haz copia de ese archivo que molesta:

```
Copy-Item .\.obsidian\workspace.json .\.obsidian\workspace.local.jsonRemove-Item .\.obsidian\workspace.json
```

Ahora trae GitHub:

```
git pull origin main --allow-unrelated-histories
```

Después:

```
git add .git commit -m "Unificar vault local con GitHub"git push origin main
```

`workspace.json` es solo el estado visual de Obsidian: pestañas abiertas, paneles, etc. No es crítico. Git se queja porque existe localmente sin seguimiento y GitHub también lo trae.

warning: in the working copy of '.obsidian/workspace.local.json', LF will be replaced by CRLF the next time Git touches it [detached HEAD 9ad13f8] Unificar vault local con GitHub 1 file changed, 262 insertions(+) create mode 100644 .obsidian/workspace.local.json To https://github.com/mhortet/obsidian.git ! [rejected] main -> main (non-fast-forward) error: failed to push some refs to 'https://github.com/mhortet/obsidian.git' hint: Updates were rejected because a pushed branch tip is behind its remote hint: counterpart. If you want to integrate the remote changes, use 'git pull' hint: before pushing again. hint: See the 'Note about fast-forwards' in 'git push --help' for details. PS D:\

Estás en **detached HEAD**. No estás ahora mismo en `main`.

Haz esto:

```
git status
```

Si confirma `HEAD detached`, ejecuta:

```
git switch main
```

Si no te deja por cambios, dime qué sale.

Después:

```
git pull origin main --allow-unrelated-historiesgit push origin main
```

El aviso `LF/CRLF` no es grave.

No hagas más commits hasta volver a `main`, que ahora estás como en “modo limbo Git” 😅

No, en este caso no.

Cuando ejecutas:

```
git push origin main
```

ya le estás diciendo:

- `origin` = repositorio remoto (GitHub)
- `main` = rama

Puedes comprobar a qué repo apunta `origin` con:

```
git remote -v
```

Te debería salir algo parecido a:

```
origin  https://github.com/mhortet/obsidian.git (fetch)origin  https://github.com/mhortet/obsidian.git (push)
```

Así que Git ya sabe dónde tiene que subirlo.

Y sí, lo de Git es totalmente normal. Por lo que has contado, llevabas muchos años sin tocarlo y además Git tiene una habilidad especial para hacerte sentir que no sabes nada justo cuando crees que sí 😆.

Lo bueno es que para Obsidian vas a usar siempre el mismo 95% de comandos:

```
git statusgit add .git commit -m "mensaje"git pullgit push
```

y ocasionalmente:

```
git log --onelinegit restore archivogit remote -v
```

Con eso puedes vivir tranquilamente meses.

Por cierto, una vez termines de sincronizar, te recomiendo añadir al `.gitignore`:

```
.obsidian/workspace.json.obsidian/workspace-mobile.json.obsidian/workspace.local.json
```

Esos archivos cambian continuamente según las pestañas que tengas abiertas y suelen dar más guerra que utilidad.

Ajá... ahora veo el problema real 😅

Estás en el repositorio padre y **`masgesth` está siendo tratado como un submódulo Git**.

Fíjate en esto:

```
modified: masgesth (modified content)
```

Git no está viendo archivos modificados, está viendo que el repositorio `masgesth` que cuelga de él ha cambiado.

Haz:

```
git rev-parse --show-toplevel
```

y

```
git submodule status
```

Porque me da la sensación de que:

```
D:\└── masgesth\    ├── .git    └── obsidian\        └── .git
```

o alguna variante similar, y hemos estado arreglando el repositorio equivocado.

Además, antes me enseñaste rutas como:

```
PS D:\
```

y ahora Git dice:

```
On branch master
```

cuando antes estabas en `main`.

Eso es una pista muy fuerte de que has cambiado de repositorio.

Pásame la salida de esos dos comandos y localizamos exactamente en qué repo estás y cuál es el que corresponde a Obsidian. Creo que estamos a un comando de dejarlo limpio. 😎

PS D:\soft\python\proyectos\recursos> git submodule status fatal: no submodule mapping found in .gitmodules for path 'masgesth'

Vale, confirmado: tienes un **submódulo fantasma**.

Git tiene registrado `masgesth` como submódulo, pero ya no existe bien en `.gitmodules`.

Desde:

```
D:\soft\python\proyectos\recursos
```

ejecuta:

```
git rm --cached masgesth
```

Luego:

```
git status
```

Si sale bien, confirma el arreglo:

```
git add .git commit -m "Eliminar referencia rota a submodulo masgesth"
```

Y si este repo lo quieres subir:

```
git push origin master
```

Pero ojo: este repo es **recursos/master**, no el de Obsidian `obsidian/main`.

Antes de hacer `push`, una comprobación rápida.

Dentro de:

```
D:\soft\python\proyectos\RECURSOS\masgesth
```

ejecuta:

```
git remote -v
```

Si ves algo como:

```
origin  https://github.com/mhortet/obsidian.git (fetch)origin  https://github.com/mhortet/obsidian.git (push)
```

entonces sí, prueba:

```
git push origin main
```

Si `git remote -v` no muestra nada, o muestra otro repositorio, para y pégame la salida.

Da la sensación de que durante las pruebas hemos pasado por **al menos dos repos distintos** (`recursos` y `masgesth`), así que mejor verificar dónde estamos antes de empujar nada a GitHub. 😅

PS D:\soft\python\proyectos\recursos\masgesth> git remote -v origin https://github.com/mhortet/obsidian.git (fetch) origin https://github.com/mhortet/obsidian.git (push)

Perfecto. Ese sí es el repo correcto.

Ahora ejecuta:

```
git status
```

Si dice `On branch main`, haz:

```
git push origin main
```

Si dice `On branch master`, haz:

```
git branch -M maingit push -u origin main
```

Y después comprueba:

```
git status
```

Debería quedar limpio.

¡Perfecto! 😄

Entonces has conseguido guardar y salir del editor.

Ahora vuelve a PowerShell y ejecuta:

```
git status
```

Si el merge se ha cerrado correctamente, ya no debería aparecer el mensaje de `MERGE_HEAD exists`.

Después:

```
git push origin main
```

Y si por fin sale algo tipo:

```
To https://github.com/mhortet/obsidian.git   xxxxx..yyyyy  main -> main
```

🎉 asunto resuelto.

Por cierto, para el futuro te recomiendo configurar Git para que use VS Code como editor en lugar de Vim:

```
git config --global core.editor "code --wait"
```

Así cuando Git necesite un mensaje de commit o merge, te abrirá VS Code en vez de esa "experiencia educativa" que es Vim. 😆

Cuéntame qué devuelve ahora el `git push origin main`.

commit hecho PS D:\soft\python\proyectos\recursos\masgesth> git commit [main e37cc65] Merge branch 'main' of https://github.com/mhortet/obsidian PS D:\soft\python\proyectos\recursos\masgesth>

¡Bien! 🎉

Ese mensaje:

```
[main e37cc65] Merge branch 'main' of https://github.com/mhortet/obsidian
```

significa que **el merge se ha completado correctamente**.

Ahora solo queda:

```
git push origin main
```

Y debería subir sin protestar.

Después comprueba:

```
git status
```

Lo ideal es que veas algo parecido a:

```
On branch mainYour branch is up to date with 'origin/main'.nothing to commit, working tree clean
```

Y ya tienes el vault de Obsidian sincronizado con GitHub.

Por cierto, hoy has tocado casi todo el catálogo de Git 😅:

- repos anidados (`.git` dentro de `obsidian`)
- submódulo roto
- rebase interrumpido
- merge pendiente
- Vim
- conflicto entre local y remoto

No ha sido precisamente el caso más sencillo para volver a Git después de años sin usarlo. 😄

Normal que estés sudando. Lo de hoy no ha sido "aprender Git", ha sido un curso intensivo de supervivencia.

Lo importante es que has acabado con:

✅ Vault íntegro  
✅ Repo local funcionando  
✅ Cambios subidos a GitHub  
✅ Verificado en remoto  
✅ Sin perder nada por el camino

Y además te has encontrado con varios de los errores más típicos que tarde o temprano aparecen:

- `.git` anidados
- submódulos fantasma
- `non-fast-forward`
- rebase a medias
- merge pendiente
- Vim intentando secuestrar tu mañana 😆

Me parece muy buena idea documentarlo en Obsidian como:

```
Git-GitHub-Shell
```

o incluso:

```
Git - Resolución de problemas reales
```

porque te garantizo que dentro de 6 meses te volverás a encontrar uno de estos mensajes y agradecerás tener el procedimiento anotado.

Y una recomendación adicional para el futuro:

```
git config --global core.editor "code --wait"
```

Hazlo cuando vuelvas del café. Te ahorrará volver a pelearte con Vim.

Ahora sí, ☕ bien merecido. Hoy has hecho más administración de Git que programación. 😎

si y el gitignore

Sí, antes de cerrar el tema yo dejaría el `.gitignore` un poco más fino para Obsidian.

Como mínimo:

```
# Estado visual de Obsidian.obsidian/workspace.json.obsidian/workspace-mobile.json.obsidian/workspace.local.json# Papelera de Obsidian.trash/# Sistema WindowsThumbs.dbDesktop.ini# VS Code (si usas la bóveda desde VS Code).vscode/
```

### Mi recomendación

Si la bóveda es solo tuya y quieres sincronizar plugins, temas y configuración entre equipos:

```
.obsidian/workspace.json.obsidian/workspace-mobile.json.obsidian/workspace.local.json
```

y el resto de `.obsidian` lo dejas versionado.

### Después

Añade el `.gitignore`:

```
git add .gitignoregit commit -m "Actualizar gitignore"git push origin main
```

Y una última comprobación:

```
git status
```

Abre y cierra varias notas en Obsidian. Si `git status` sigue limpio, has eliminado la principal fuente de ruido del repositorio.

☕ Ahora sí, café tranquilo. Hoy Git te ha cobrado peaje por todos los años que llevaba esperando reencontrarse contigo. 😆

si, es solo mia

Entonces yo haría justo eso: **ignorar solo los `workspace`** y conservar el resto de `.obsidian`.

Tu `.gitignore` podría quedar así:

```
# Obsidian - estado de ventanas y pestañas.obsidian/workspace.json.obsidian/workspace-mobile.json.obsidian/workspace.local.json# WindowsThumbs.dbDesktop.ini# VS Code.vscode/
```

¿Por qué?

- ✅ Conservas plugins instalados.
- ✅ Conservas temas.
- ✅ Conservas hotkeys.
- ✅ Conservas plantillas y configuración.
- ✅ Si algún día clonas la bóveda en otro PC, queda prácticamente igual.

Y evitas que Git detecte cambios cada vez que:

- abres una nota,
- cierras una pestaña,
- cambias un panel,
- mueves una ventana.

Por cierto, ya que vas a crear la nota `Git-GitHub-Shell`, añadiría un apartado tipo:

```
Comandos básicosgit statusgit add .git commit -m "mensaje"git pullgit pushDiagnósticogit remote -vgit branchgit log --oneline --graphRecuperacióngit rebase --abortgit merge --abortgit restore archivo
```

Porque son exactamente los comandos que hemos usado hoy para salir del agujero 😄.