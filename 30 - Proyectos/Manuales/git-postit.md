---
tags:
  - desarrollo
  - codigo
  - manuales
Creado: 2026-06-01
Autor: Codex
Relacionado:
---
## Alcance

## Descripción


# Git post-it

## Flujo normal

```bash
git add .
git commit -m "mensaje"
git push
```

## Si has tocado algo en GitHub

```bash
git pull --rebase origin main
```

## Si `push` falla

```bash
git pull --rebase origin main
git push
```

## Si hay conflicto

```text
resolver archivo
git add archivo
git rebase --continue
```

## Regla de oro

Si cambias en GitHub web, antes de seguir en local:

```bash
git pull --rebase origin main
```
