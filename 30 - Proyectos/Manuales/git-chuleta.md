---
tags:
  - codigo
  - desarrollo
  - manuales
Creado: 2026-06-01
Autor: Codex
Relacionado:
---
## Alcance

## Descripción


# Chuleta Git para no liarla

## Regla de oro

Si has tocado algo en GitHub web, antes de seguir trabajando en local haz:

```bash
git pull --rebase origin main
```

Asi traes los cambios remotos sin abrir un merge innecesario.

## Flujo normal

Cuando trabajas solo en local:

```bash
git status
git add .
git commit -m "mensaje claro"
git push
```

## Si has cambiado algo en GitHub web

Antes de editar mas en local:

```bash
git pull --rebase origin main
```

Despues sigues normal:

```bash
git add .
git commit -m "mensaje claro"
git push
```

## Si ya habias hecho commit en local y el push falla

Si `git push` te dice que el remoto va por delante:

```bash
git pull --rebase origin main
```

Si sale conflicto:

1. Abres el archivo en conflicto.
2. Buscas los bloques `<<<<<<<`, `=======`, `>>>>>>>`.
3. Dejas el contenido bueno a mano.
4. Guardas el archivo.
5. Marcas la resolucion:

```bash
git add archivo
git rebase --continue
```

Cuando termine:

```bash
git push
```

## Lo que conviene evitar

- Editar el mismo archivo en GitHub y en local sin hacer `pull --rebase` antes.
- Usar `git pull` a secas cuando ya hay cambios en local.
- Hacer commits grandes con muchas cosas mezcladas.

## Comandos utiles

Ver estado:

```bash
git status
```

Ver ramas:

```bash
git branch
```

Ver historial corto:

```bash
git log --oneline --graph --decorate -n 10
```

## Resumen de pared

Si cambias en GitHub:

```bash
git pull --rebase origin main
```

Si trabajas en local:

```bash
git add .
git commit -m "mensaje"
git push
```

Si `push` falla:

```bash
git pull --rebase origin main
```
