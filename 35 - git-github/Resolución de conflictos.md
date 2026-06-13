---
tags:
  - codigo
  - software
  - git
Creado: 2026-06-08
Autor:
  - M.Hortet
Relacionado:
---
## Alcance

## Descripción

### Para resolver un conflicto de fusión manualmente, debes seguir estos tres pasos clave:

1. **Identifica y edita el archivo:** Abre el archivo afectado donde Git habrá insertado marcadores de conflicto (como `<<<<<<<`, `=======` y `>>>>>>>`). Debes decidir con qué código quedarte y borrar manualmente esos marcadores.
2. **Prepara el archivo (Staging):** Una vez que el archivo esté corregido y guardado, ejecuta `git add <archivo>` para indicarle a Git que el conflicto ha sido resuelto.
3. **Finaliza con un commit:** Termina el proceso ejecutando `git commit`. Git suele generar un mensaje automático indicando que se ha resuelto un conflicto de fusión.
Estos símbolos son **marcadores de conflicto** que Git inserta automáticamente cuando dos personas modifican la misma línea en un archivo. Su función es delimitar las versiones enfrentadas para que puedas decidir con cuál quedarte:

- **<<<<<<<**: Indica el inicio del conflicto y muestra el código que tienes actualmente en tu rama local (donde estás parado, usualmente marcado como `HEAD`).
- **=======**: Es la línea divisoria que separa tu versión local de la versión que intentas integrar.
- **>>>>>>>**: Marca el final del conflicto y muestra el código que proviene de la otra rama o del servidor.

Para resolverlo, debes borrar manualmente estos marcadores y dejar solo el código final deseado