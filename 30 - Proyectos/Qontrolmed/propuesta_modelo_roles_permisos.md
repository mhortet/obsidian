# Propuesta de modelo de roles y permisos
[[masgesth]]
Fecha de revision: 2026-06-13

## Objetivo

Definir el modelo objetivo de autorizacion para `Qontrolmed` sin romper la
operativa actual basada en `es_tecnico`, dejando preparado:

- el esquema funcional `usuario -> rol -> permisos`;
- la futura creacion de roles dinamicos por usuario administrador de seguridad;
- la implantacion progresiva por modulos;
- el bootstrap obligatorio del `superusuario` durante la futura instalacion.

## Decisiones de diseno adoptadas

- No asignar permisos directamente a cada usuario como contrato principal.
- Cada usuario tendra un unico rol en la primera implantacion.
- Los roles seran editables por el usuario autorizado, salvo los roles
  reservados del sistema.
- Existira un rol reservado `superusuario` con control total y capacidad para:
  - crear roles;
  - editar roles;
  - asignar permisos;
  - asignar roles a usuarios;
  - consultar auditoria de seguridad.
- Los permisos destructivos no iran implicitos dentro de roles intermedios.
- La autorizacion real no debe depender solo de ocultar botones en UI; tambien
  debe validarse en servicios o en el punto de accion sensible.
- `es_tecnico` seguira existiendo como puente operativo hasta retirar sus
  dependencias actuales en Preventivos y Quirofanos.

## Modelo de datos objetivo

### Tablas nuevas

#### `roles`

Campos minimos propuestos:

- `id`
- `codigo`
- `nombre`
- `descripcion`
- `activo`
- `reservado`
- `acceso_total`
- `tecnico_campo`
- `fecha_alta`
- `fecha_baja`

Criterio:

- `codigo` sirve como identificador tecnico estable;
- `nombre` es el texto visible en UI;
- `reservado = 1` bloquea borrado o renombrado estructural de roles del
  sistema, como `superusuario`;
- `acceso_total = 1` evita tener que materializar manualmente todos los
  permisos del `superusuario`;
- `tecnico_campo = 1` permite mantener compatibilidad con selectores y flujos
  que hoy dependen de `es_tecnico`.

#### `permisos`

Campos minimos propuestos:

- `id`
- `codigo`
- `nombre`
- `modulo`
- `accion`
- `descripcion`
- `activo`
- `es_destructivo`

Criterio:

- `codigo` debe ser unico y estable;
- `modulo` agrupa permisos en UI;
- `es_destructivo` ayuda a remarcar permisos delicados en pantalla y auditoria.

#### `roles_permisos`

Campos minimos propuestos:

- `id_rol`
- `id_permiso`

Criterio:

- clave unica por pareja `id_rol + id_permiso`;
- no hace falta una tabla `usuarios_permisos` en la primera implantacion.

### Evolucion de `usuarios`

Campos objetivo en `gestion.usuarios`:

- mantener temporalmente `rol` y `es_tecnico` por compatibilidad;
- anadir `id_rol` como referencia real al nuevo modelo.

Criterio:

- `usuarios.id_rol` sera el contrato final;
- `usuarios.rol` quedara solo como puente transitorio o se retirara en una
  migracion posterior;
- `es_tecnico` se seguira rellenando mientras haya consultas legacy que lo
  necesiten.

## Catalogo inicial de permisos

El catalogo debe nacer pequeno, estable y ampliable.

### Seguridad

- `seguridad.roles_gestionar`
- `seguridad.usuarios_gestionar`
- `seguridad.auditoria_ver`
- `seguridad.auditoria_exportar`

### Gestion

- `gestion.centros_ver`
- `gestion.centros_editar`
- `gestion.equipos_ver`
- `gestion.equipos_editar`
- `gestion.compras_ver`
- `gestion.compras_editar`
- `gestion.proveedores_editar`
- `gestion.repuestos_editar`
- `gestion.marcas_editar`
- `gestion.tipos_trabajo_editar`
- `gestion.estadisticas_ver`

### Preventivos

- `preventivos.informes_ver`
- `preventivos.informes_editar`
- `preventivos.informes_cerrar`
- `preventivos.informes_imprimir`
- `preventivos.informes_borrar`
- `preventivos.campanas_importar`
- `preventivos.tablet_exportar`
- `preventivos.tablet_importar`
- `preventivos.plantillas_editar`
- `preventivos.puntos_control_editar`
- `preventivos.plantillas_blanco_generar`

### Quirofanos

- `quirofanos.informes_ver`
- `quirofanos.informes_editar`
- `quirofanos.informes_cerrar`
- `quirofanos.informes_imprimir`
- `quirofanos.informes_borrar`
- `quirofanos.libro_ver`
- `quirofanos.libro_imprimir`
- `quirofanos.android_exportar`
- `quirofanos.android_importar`
- `quirofanos.quirofanos_editar`
- `quirofanos.puntos_control_editar`
- `quirofanos.qpc_editar`
- `quirofanos.equipos_medida_editar`
- `quirofanos.plantillas_blanco_generar`

## Roles base recomendados

### `superusuario`

- rol reservado del sistema;
- `acceso_total = 1`;
- puede gestionar usuarios, roles, auditoria y permisos;
- no debe poder borrarse desde UI.

### `tecnico`

- pensado para operativa de campo;
- `tecnico_campo = 1`;
- acceso a consulta, edicion y cierre segun permisos concedidos;
- sin permisos de administracion de seguridad;
- `borrar_informes` no debe venir concedido por defecto.

### `administrativo`

- pensado para gestion y mantenimiento de maestros;
- sin `tecnico_campo`;
- sin permisos destructivos por defecto;
- sin export/import de campo salvo necesidad real.

### `consulta`

- rol opcional;
- solo se recomienda sembrarlo si aparece un caso real de lectura sin edicion.

## UI recomendada

### Mantenimiento de roles

Propuesta:

- listado de roles;
- formulario de alta/edicion;
- permisos en bloques por modulo;
- asignacion por `checkbox` y no por lista dual en la primera version.

Motivo:

- es mas claro visualmente;
- facilita auditoria funcional;
- reduce errores de asignacion en una aplicacion de escritorio sanitaria.

### Mantenimiento de usuarios

Propuesta:

- sustituir el rol fijo textual por selector de `rol` real;
- mostrar si el rol marcado implica `tecnico_campo`;
- impedir asignar un rol inexistente o inactivo.
- impedir ademas que un operador no `superusuario` pueda:
  - asignar el rol `superusuario`;
  - retirarlo;
  - modificar o desactivar una cuenta que ya lo tenga.

## Bootstrap futuro en instalacion

Cuando exista instalador o asistente de primer arranque, el proceso debe
obligar a crear el `superusuario`.

Regla minima:

- no dar una instalacion productiva por terminada sin `superusuario` activo;
- pedir identificador de usuario;
- pedir nombre visible;
- pedir contrasena y repeticion de contrasena;
- guardar solo `password_hash`;
- registrar evento de auditoria de alta inicial;
- bloquear el acceso normal hasta completar ese alta inicial.

Criterio de seguridad:

- el modo `passwordless` no debe formar parte del flujo normal de instalacion;
- si se mantiene el bootstrap temporal por variable de entorno, debe quedar
  solo para soporte controlado o desarrollo.

## Compatibilidad transitoria con el modelo actual

La transicion debe respetar lo ya implantado:

- `src/Compras/services/usuarios_service.py` ya entiende `rol` textual y
  `es_tecnico`;
- `src/preventivos/main_preventivos.py` sigue consultando tecnicos por
  `es_tecnico = 1`;
- otros flujos de cierre y seleccion tambien dependen de ese criterio.

Por tanto:

- no conviene tomar `bd/migraciones/migracion_gestion_roles.sql` como modelo final de
  roles dinamicos;
- esa migracion actual sirve para el paso intermedio de `rol` explicito, no
  para el modelo completo basado en tablas de roles y permisos;
- la compatibilidad debe mantenerse hasta que toda la autorizacion use
  `usuarios.id_rol` y la bandera operativa `tecnico_campo`.

## Orden recomendado de implantacion

### Fase 1. Esquema y semillas

- crear tablas `roles`, `permisos` y `roles_permisos`;
- anadir `usuarios.id_rol`;
- sembrar permisos base;
- sembrar roles reservados y roles iniciales.

### Fase 2. Migracion de usuarios

- mapear usuarios actuales a un rol inicial;
- rellenar `usuarios.id_rol`;
- mantener `usuarios.rol` y `es_tecnico` mientras existan dependencias.

Entregables preparados:

- `bd/migraciones/migracion_gestion_roles_permisos_backfill_usuarios.sql`
- `src/compartido/autorizacion.py`

Criterio aplicado:

- el backfill inicial no promociona automaticamente ningun usuario a
  `superusuario`;
- por seguridad, asigna `tecnico` a quien hoy tenga `es_tecnico = 1` y
  `administrativo` al resto;
- la promocion de al menos un usuario a `superusuario` debe hacerse de forma
  manual y consciente tras revisar usuarios reales.

### Fase 3. Servicios comunes de autorizacion

- helper central `tiene_permiso`;
- helper `es_superusuario`;
- helper de rol tecnico o `tecnico_campo`.

### Fase 4. UI de seguridad

- mantenimiento de roles;
- adaptacion de mantenimiento de usuarios para asignar rol real;
- primera visibilidad de auditoria si entra en la misma ventana.

### Fase 5. Enforcement por modulos

- `Gestion`
- `Preventivos`
- `Quirofanos`

Regla:

- primero ocultar accesos no permitidos;
- despues validar tambien la accion al ejecutar.

### Fase 6. Instalacion y primer arranque

- asistente de bootstrap de `superusuario`;
- cierre del camino excepcional de acceso sin contrasena para entornos
  productivos.

## Migraciones y ficheros preparados

No se propone reutilizar como solucion final el actual:

- `bd/migraciones/migracion_gestion_roles.sql`

Para la Fase 1 ya quedan preparados:

- `bd/base/gestion_roles.sql`
- `bd/base/gestion_permisos.sql`
- `bd/base/gestion_roles_permisos.sql`
- `bd/migraciones/migracion_gestion_roles_permisos_base.sql`

Criterio aplicado:

- la migracion nueva crea tablas, siembra roles y permisos base y anade
  `usuarios.id_rol`;
- la migracion nueva no depende de haber ejecutado antes el puente textual
  `bd/migraciones/migracion_gestion_roles.sql`;
- no hace aun el backfill de usuarios existentes hacia un rol definitivo;
- ese paso se deja para una fase separada, para validar mejor el mapeo y el
  rollback manual.

## Validacion funcional minima cuando se implemente

- login correcto con `superusuario`;
- alta de un rol nuevo con permisos limitados;
- alta o edicion de un usuario asignandole ese rol;
- acceso correcto a una pantalla permitida;
- denegacion correcta en una pantalla o accion no permitida;
- persistencia correcta de `id_rol`;
- compatibilidad mantenida de selectores tecnicos mientras siga existiendo
  dependencia de `es_tecnico`;
- trazabilidad en auditoria de cambios de usuarios, roles y permisos.

