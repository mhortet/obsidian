---
tags:
  - desarrollo
  - codigo
  - IA
Creado: 2026-06-25
Autor:
Relacionado:
---
## Descripción

## Recomendación IA

**Yo no haría una copia del repo principal** para experimentar con IA.
Haría dos tipos de laboratorio distintos:
### Laboratorio 1 (el más frecuente)

Un repositorio totalmente independiente.

```
AI-LAB    pruebas_context7    pruebas_agentes    pruebas_mcp    pruebas_codex
```

Aquí rompes absolutamente todo.

---

### Laboratorio 2 (ocasional)

Cuando quieras probar algo sobre tu aplicación:

```
git checkout -b experimento/context7
```

o

```
git switch -c experimento/context7
```

Trabajas en esa rama.

Si sale mal:

```
git switch maingit branch -D experimento/context7
```

No queda rastro.

Es una práctica muy habitual y además te obliga a coger soltura con Git, que nunca viene mal.