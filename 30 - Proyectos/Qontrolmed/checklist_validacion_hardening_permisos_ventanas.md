# Checklist de validacion del hardening de permisos y ventanas
[[masgesth]]
Fecha de revision: 2026-06-14

## Objetivo

Ejecutar un smoke test manual corto pero dirigido sobre el primer corte ya
implantado de:

- visibilidad y acceso funcional por permisos;
- regla transversal de ventana unica;
- recuperacion de foco al reabrir pantallas ya abiertas;
- no regresion de la operativa legacy apoyada en `es_tecnico`.

Este documento no sustituye a `docs/estado_continuidad.md`. Sirve como hoja
de ejecucion para la siguiente sesion de validacion manual.

## Preparacion minima

Antes de abrir la app:

1. Confirmar que la base sigue accesible en `MySQL 8.4.9`.
2. Tener disponibles al menos estos perfiles:
   - un usuario restringido o de consulta;
   - un usuario tecnico o administrativo con permisos parciales;
   - un usuario amplio o `superusuario`.
3. Confirmar que las migraciones de roles/permisos ya estan aplicadas.
4. Arrancar la app contra la base real de trabajo.

## Tabla de arranque

| Campo | Valor |
| --- | --- |
| Tarea principal | Validacion manual dirigida de permisos y ventana unica |
| Tarea alternativa | Preparar lista de huecos reales para remate fino de permisos |
| Tests exigibles | `python -m compileall main.py src` |
| Validacion manual esperada | Smoke test de portada, Preventivos, Quirofanos y foco |
| Dependencias | `gestion_roles_permisos`, usuarios de prueba, app en entorno real |

## Secuencia recomendada

### 1. Portada principal

Con cada perfil:

- iniciar sesion;
- comprobar que solo se ven modulos permitidos;   CORRECTO
- intentar entrar en un modulo permitido; CORRECTO, pero:
- si el usuario no tiene modulos visibles, comprobar que aparece mensaje claro. NO APARECEN
    - Los módulos no visible, simplemente NO salen, no hay ningún mensaje indicándolo, en principio, creo qeu no sería necesario.

Resultado esperado:

- no aparecen modulos fuera de permiso; OK
- no se abre ningun modulo bloqueado por enlace visible residual; OK
- el usuario sin modulos no queda en un estado ambiguo. OK

### 2. Preventivos

Con perfil parcial y perfil amplio:

- abrir el modulo;
- comprobar visibilidad de botones de:
  - informes;
  - historico;
  - informes multiples;
  - importacion GMAO;
  - exportacion tablet;
  - importacion tablet;
  - plantillas;
  - puntos de control;
  - plantillas en blanco;
- abrir informe preventivo en modo consulta si aplica;
- intentar editar, cerrar e imprimir cuando el rol no deba poder hacerlo.

Resultado esperado:

- la UI solo expone acciones permitidas;  OK
- las acciones bloqueadas no se ejecutan aunque se alcance la pantalla; OK
- no se rompe la operativa actual para perfiles tecnicos validos. OK

### 3. Quirofanos

Con perfil parcial y perfil amplio:

- abrir el modulo;
- comprobar visibilidad de botones de:
  - informes;
  - historico;
  - libro;
  - exportacion Android;
  - importacion Android;
  - quirofanos;
  - puntos de control;
  - puntos por quirofano;
  - equipos de medida;
  - plantillas en blanco;
- abrir informe de quirofano en modo consulta si aplica;
- intentar editar, cerrar e imprimir cuando el rol no deba poder hacerlo;
- repetir una prueba corta de import/export para observar foco al volver del
  selector de ruta.

Resultado esperado:

- la UI respeta la matriz de permisos visible y funcional; OK
- las acciones internas del informe no permiten saltarse el permiso; OK
- al cerrar un selector de archivo o carpeta el foco vuelve a la ventana que lo
  lanzo. OK

### 4. Ventana unica

Repetir dos veces la apertura de cada pantalla principal cubierta:

- `Gestion`;
- `Preventivos`;
- `Quirofanos`;
- `Usuarios`;
- `Roles`;
- `Centros`;
- `Historico`;
- `Libro`;
- `Plantillas`;
- `Puntos de control`;
- `Equipos de medida`.

Resultado esperado:

- no se crea una segunda instancia; OK
- la ventana ya abierta se levanta y recupera foco; OK
- no queda el foco saltando al menu principal salvo en cierres deliberados. OK

## Registro minimo de evidencia

Anotar al terminar:

- perfiles usados:
    - Con roles completos
    - Roles reducidos a quirófanos y solo visualización de informes 
    - Roles reducidos a PReventivos y solo acceso a ver informes
    - Roles reducidos a ver e imprimir informes
- pantallas probadas;
    - Gestión
    - Preventivos 
        - informes
        - impresión
        - modificación
- permisos que funcionaron como esperado;
    Todos los probados
- huecos detectados;
- si el fallo es:
  - visual;
      - En las ventanas que admiten edición, pero el usuario logueado no tiene acceso a modificar, indicar en las cabeceras correspondiente que es un 'Modo Léctura' resaltado para fácil localización
  - funcional;
  - de foco;
  - de duplicidad de ventana;
  - de regresion legacy.

## Criterio de salida

Si sale limpio:

- marcar en `docs/estado_continuidad.md` que la validacion manual base queda
  superada;
- abrir siguiente bloque en `auditoria`.

Si aparecen huecos pequenos:

- documentarlos en `docs/estado_continuidad.md`;
- abrir una tanda corta de remate fino de permisos o foco;
- no mezclar aun con auditoria.

Si aparece bloqueo real:

- tratarlo como correctivo prioritario;
- dejar evidencia concreta del rol, pantalla, accion y resultado observado.
