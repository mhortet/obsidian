# Roles operativos de acceso
[[masgesth]]
Fecha de revision: 2026-06-14

## Objetivo

Dejar por escrito la regla operativa vigente de acceso y roles para no
depender del chat ni mezclar decisiones futuras con la necesidad actual de
trabajo de campo real.

## Decision vigente

El modelo activo ya no se limita solo a `Administrador` y `Tecnico`.

La aplicacion trabaja ahora en un estado hibrido y controlado:

- si la base ya dispone de `roles`, `permisos`, `roles_permisos` e
  `usuarios.id_rol`, la autorizacion real usa el esquema `usuario -> rol ->
  permisos`;
- si la base aun no tiene ese modelo completo, la app mantiene compatibilidad
  con el `rol` textual y, en ultimo termino, con `es_tecnico`;
- `superusuario` queda ya tratado como rol reservado del sistema;
- la primera matriz funcional de permisos ya esta implantada en:
  - `Gestion`;
  - `Preventivos`;
  - `Quirofanos`.

## Regla operativa actual de compatibilidad

Mientras siga habiendo entornos legacy o transicion de datos:

- `usuarios.id_rol` es el contrato objetivo cuando existe;
- `usuarios.rol` puede seguir actuando como puente textual;
- `es_tecnico` se mantiene como puente operativo para selectores y flujos que
  aun lo consumen.

Interpretacion operativa residual:

- `es_tecnico = 1` sigue implicando perfil tecnico de campo efectivo;
- `es_tecnico = 0` deja de equivaler necesariamente a un unico rol funcional,
  porque ya pueden existir `administrativo`, `consulta` o `superusuario`.

## Efecto funcional esperado

- Los usuarios tecnicos deben seguir apareciendo en selectores de tecnico de
  Preventivos y Quirofanos.
- Un usuario sin condicion tecnica efectiva no debe aparecer en esos
  selectores.
- La condicion tecnica efectiva puede venir de:
  - `es_tecnico = 1`;
  - rol con `tecnico_campo = 1`;
  - o rol funcional `Tecnico` mientras siga la compatibilidad.
- Un operador que no sea `superusuario` no puede:
  - asignar el rol `superusuario`;
  - retirarlo;
  - modificar una cuenta que ya lo tenga;
  - desactivar una cuenta que ya lo tenga.

## Login sin contrasena

El acceso implicito sin contrasena queda bloqueado por defecto.

Solo se permite bootstrap temporal si se activa expresamente:

- `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=1`

Y solo si, ademas, no existe ningun usuario activo con `password_hash`.

Fuera de un bootstrap controlado de soporte o desarrollo:

- lo correcto es exigir al menos un usuario activo con contrasena;
- ese camino excepcional no debe formar parte del flujo normal de piloto o
  produccion;
- el siguiente frente de hardening debe revisar este bypass y sustituirlo por
  un bootstrap seguro de `superusuario`.

## Cuando tocar la BD

No es obligatorio tocar la BD para seguir operando en modo compatible.

Pero si se abre una ventana controlada para consolidar el modelo final, el
camino preferente ya no es solo la columna `rol`.

Referencias preparadas:

- `bd/migraciones/migracion_gestion_roles.sql`
- `bd/migraciones/migracion_gestion_roles_permisos_base.sql`
- `bd/migraciones/migracion_gestion_roles_permisos_backfill_usuarios.sql`

## Regla de prudencia

Si hay trabajo de campo real en curso, priorizar estabilidad:

- no tocar esquema si no es necesario;
- mantener `es_tecnico` como puente operativo mientras siga siendo necesario;
- no mezclar una correccion de login o autenticacion con una tanda grande de
  migraciones;
- reservar la consolidacion final del bootstrap de `superusuario` para una
  ventana controlada y documentada.
