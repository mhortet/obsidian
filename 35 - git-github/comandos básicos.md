---
tags:
  - git
Creado: 2026-06-06
Autor:
Relacionado:
---
## Alcance

## Descripción


Comandos básicos

git status
git add .
git commit -m "mensaje"
git pull
git push

Diagnóstico

git remote -v
git branch
git log --oneline --graph

Recuperación

git rebase --abort
git merge --abort
git restore archivo


Si se copia **todo el directorio incluyendo la carpeta oculta `.git`**, al restaurarlo tendremos:
- los archivos de la bóveda,
- el historial Git local,
- la rama en la que estaba,
- los commits existentes hasta ese día,
- el remoto `origin` configurado.

O sea: Git queda “instalado” dentro de esa carpeta.

La precaución importante:


### Copia completa de la carpeta raíz del repoincluyendo .git


**No copiar solo las notas `.md`.**

### Al restaurar:

cd ruta\restaurada
git status
git remote -vgit pull origin main


Si GitHub va por delante, con eso actualiza.

### Recomendación práctica

Antes de hacer copia de seguridad:


git status


Idealmente que esté limpio:



Luego hacer la copia.

Y para no liarla **no abrir ni trabajar Git desde la copia de seguridad**. La copia, quietecita como archivo de emergencia.