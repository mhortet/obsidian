---
tags:
  - app
  - codigo
  - desarrollo
  - diario
Relacionado:
Creado: 2026-05-15
---

# Sesion 2026-05-17: Acceso a la app aplazado hasta pruebas de campo
[[masgesth_port]]
## Contexto

Se revisa la necesidad de incorporar acceso a la aplicacion mediante contrasena en esta fase del proyecto.

La valoracion actual es que la app no manejara datos sensibles de usuarios o clientes. El contenido principal seran valores de medida introducidos por el tecnico durante el trabajo de campo y, una vez completada la operativa, el acceso posterior a esos datos no se considera un requisito fuerte en esta etapa.

## Decision

- No implementar por ahora acceso obligatorio mediante contrasena.
- Mantener el tema en observacion hasta realizar pruebas intensivas de campo.
- Extraer conclusiones despues de validar el uso real de la app en operativa diaria.

## Criterio provisional

- Priorizar simplicidad de uso y baja friccion para el tecnico.
- Evitar introducir un login que no aporte valor claro en esta fase.
- Reevaluar la necesidad de autenticacion si las pruebas muestran problemas de uso compartido, trazabilidad, edicion no deseada o requisitos adicionales.

## Estado

Queda anotado como decision provisional de producto. No se realizan cambios funcionales en la aplicacion hasta revisar los resultados de campo.
