---
tags:
  - app
  - documentacion
Creado: 2026-07-15
Relacionado:
---

# Bootstrap del administrador inicial

## Objetivo

Preparar una instalacion nueva sin trasladar usuarios ni datos operativos del
entorno de origen. La cuenta inicial se llama `administrador`; no se utiliza
`root` para evitar confundirla con la cuenta administrativa de MySQL.

## Requisitos

- restaurar la estructura de `gestion`, `quirofanos` y `preventivos`;
- confirmar que la estructura contiene `roles`, `permisos`, `roles_permisos` y
  `usuarios.id_rol`;
- confirmar que no existe ningun usuario activo;
- realizar el proceso en una ventana controlada y sin exponer todavia la
  aplicacion a usuarios finales.

## Datos minimos de sistema

Un dump de solo estructura no contiene las filas de roles y permisos. Ejecutar
primero en MySQL Workbench:

```text
bd/bootstrap/gestion_roles_permisos_iniciales.sql
```

Este script siembra o actualiza de forma idempotente los roles reservados, los
permisos conocidos y sus asignaciones. No contiene usuarios ni datos
operativos.

## Creacion de la cuenta inicial

Ejecutar en MySQL Workbench:

```text
bd/bootstrap/gestion_administrador_inicial.sql
```

Ejecutarlo despues del script de roles y permisos. El resultado esperado
comienza por `CREADO`. El script:

- crea el usuario `administrador` vinculado al rol `superusuario`;
- deja `password_hash` a `NULL`;
- no contiene ninguna contrasena inicial;
- no hace nada si ya existe un usuario activo;
- informa si falta el rol `superusuario` o existe una cuenta incompatible.

## Asignacion de la primera contrasena

1. Editar temporalmente `C:\ProgramData\Qontrolmed\config\.env`:

```dotenv
QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=1
```

2. Iniciar Qontrolmed.
3. Seleccionar `Administrador inicial (administrador)`.
4. Introducir y confirmar una contrasena robusta y exclusiva.
5. Cerrar la aplicacion.
6. Restaurar inmediatamente:

```dotenv
QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0
```

7. Ejecutar `verificar_qontrolmed_rc.ps1` y confirmar resultado correcto.
8. Abrir Qontrolmed e iniciar sesion normalmente como `administrador`.

## Cierre del bootstrap

Desde `Gestion -> Usuarios`, el administrador inicial puede crear las cuentas
nominales necesarias y asignarles sus roles. No deben usarse contrasenas de
prueba ni compartirse la cuenta inicial entre operadores.

No se considera cerrada la primera puesta en marcha mientras la variable siga
a `1`, el usuario inicial no tenga `password_hash` o no se haya comprobado un
login normal despues de devolver la variable a `0`.
