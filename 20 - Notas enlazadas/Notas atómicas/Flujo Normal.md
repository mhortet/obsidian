---
tags:
  - git
  - software
---
Working Tree              -> zona de trabajo
   ↓ git add
Staging                       -> zona preparado para commitear
   ↓ git commit
Repositorio                 -> foto real de la situación en ese momento
  ↓ git push    
Github                         -> repositorio en la nube 


git add                       -> mete cambios en staging
git restore --staged   -> saca cambios del staging
git diff                        -> cambios no staged
git diff --staged         -> cambios staged
git add -p                  -> añadir solo partes
git commit -m "texto descriptivo"
git branch                  -> Te dice la rama en la q estas, la marca con un * a la izda.
git push                     -> sube a github