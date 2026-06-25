---
tags:
  - git
  - codigo
  - desarrollo
Creado:
Autor:
Relacionado:
---
## Resumen

## Descripción


Por CLI, estos son los artifacts actuales que ocupan espacio:

```
gh api repos/mhortet/maxgesth_movil/actions/artifacts --paginate `
  --jq '.artifacts[] | [.id, .name, .size_in_bytes, .created_at] | @tsv'
```

Salida:
7293707066      maxgesth-field-work-apk 95170112        2026-05-29T14:53:19Z

Para borrar uno:

```
gh api -X DELETE repos/mhortet/maxgesth_movil/actions/artifacts/7293707066
```

Mi recomendación: conserva solo el último APK útil y borra los 10 anteriores. Eso liberaría unos **900 MiB**.