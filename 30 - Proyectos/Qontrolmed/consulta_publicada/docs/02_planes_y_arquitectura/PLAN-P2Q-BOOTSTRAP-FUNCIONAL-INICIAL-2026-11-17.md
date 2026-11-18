---
title: "P2Q — Bootstrap funcional inicial de Gestión"
type: plan
status: completed
created: 2026-11-17
updated: 2026-11-17
sources:
  - "docs/02_planes_y_arquitectura/PLAN-P2P-ESQUEMAS-DEFINITIVOS-IDENTIDADES-Y-ACCESOS-2026-11-16.md"
  - "bd/bootstrap/gestion_roles_permisos_iniciales.sql"
  - "bd/bootstrap/gestion_administrador_inicial.sql"
tags: [qontrolmed, mysql, bootstrap, identidades]
review_after: 2026-11-24
---

# P2Q — Bootstrap funcional inicial de Gestión

## 1. Estado y objetivo

Plan ejecutado y completado mediante P2Q/P2R. El inventario de solo lectura del
17/11/2026 confirmó que `gestion.roles`, `gestion.permisos`,
`gestion.roles_permisos` y `gestion.usuarios` están vacías y no presentan
referencias huérfanas.

El objetivo es cargar las semillas funcionales canónicas y crear un único
administrador inicial sin contraseña, para que Qontrolmed establezca después
el primer `password_hash` mediante su flujo controlado.

## 2. Límites

- No abrir 3306 en LAN ni conectar puestos adicionales.
- No crear todavía la cuenta técnica runtime.
- No activar SFTPGo ni crear usuarios documentales.
- No mostrar ni registrar contraseñas, hashes o datos personales.
- No crear más de un usuario funcional.
- No dejar activo el login sin contraseña al cerrar el bloque.
- No modificar maestros ni tablas operativas de Preventivos o Quirófanos.

## 3. Precheck

1. Confirmar `srv-mm-01`, MySQL `active/enabled`, escucha exclusiva en
   `127.0.0.1:3306` y ausencia de unidades fallidas.
2. Confirmar por recuentos que las cuatro tablas siguen vacías.
3. Validar que los SQL versionados no han cambiado y que las pruebas de
   bootstrap pasan.
4. Crear una copia lógica protegida del esquema `gestion` y verificar que es
   legible y no vacía, aunque las tablas funcionales estén vacías.
5. Confirmar que la configuración de Qontrolmed parte de
   `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0`.

## 4. Ejecución

1. Ejecutar `bd/bootstrap/gestion_roles_permisos_iniciales.sql` mediante una
   cuenta administrativa local y una transacción explícita.
2. Verificar exactamente 4 roles activos y reservados, 40 permisos activos y
   75 relaciones, sin huérfanos.
3. Ejecutar `bd/bootstrap/gestion_administrador_inicial.sql` una sola vez.
4. Confirmar exactamente un usuario activo, asociado al rol `superusuario` y
   sin `password_hash`, sin imprimir sus campos sensibles.
5. Habilitar temporalmente `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=1` solo en el
   puesto controlado de bootstrap.
6. Iniciar Qontrolmed, establecer la primera contraseña directamente en la
   aplicación y confirmar que se guarda un hash no vacío.
7. Cerrar Qontrolmed y restaurar inmediatamente
   `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0`.

## 5. Aceptación

- 4 roles, 40 permisos y 75 relaciones canónicas.
- Cero relaciones huérfanas.
- Exactamente un usuario administrador activo con rol `superusuario`.
- El usuario termina con `password_hash` presente, sin revelar su contenido.
- El login normal acepta la contraseña correcta y rechaza una incorrecta.
- El login sin contraseña queda deshabilitado y su verificador devuelve el
  valor seguro `0`.
- MySQL permanece `active/enabled` y limitado a loopback.

## 6. Reversión

Antes de asignar la contraseña, cualquier resultado distinto del esperado
detiene el bloque. Al partir de tablas vacías, la restauración prevista es
recuperar `gestion` desde la copia P2Q verificada, no borrar filas de forma
selectiva.

Después de establecer la contraseña, una incidencia obliga a desactivar el
modo excepcional, detener el uso de Qontrolmed y restaurar la copia P2Q si la
consistencia funcional no puede demostrarse. `piloto_mm_gestion` y la copia
P2P permanecen como referencias adicionales, pero no sustituyen la copia
inmediata de este bloque.

## 7. Evidencia y cierre

Registrar únicamente recuentos, estados y resultados depurados. Actualizar el
diario y los relevos de Qontrolmed y Servidor_MM. No conservar SQL temporal,
contraseñas, hashes, capturas sensibles ni configuración excepcional activa.

## 8. Ejecución parcial segura del 17/11/2026

El propietario autorizó P2Q y ejecutó el arnés validado introduciendo `sudo`
directamente. La copia previa se creó bajo `/var/backups/qontrolmed/p2q-*` y el
arnés verificó su SHA-256 antes de aplicar cambios.

La verificación independiente posterior observó:

- 4 roles;
- 40 permisos;
- 75 asignaciones rol-permiso;
- 0 asignaciones huérfanas;
- 1 usuario activo;
- 1 usuario activo con rol `superusuario`;
- 1 usuario todavía sin `password_hash`;
- 0 usuarios con referencia de rol inválida.

MySQL permaneció `active/enabled`, sin unidades fallidas y limitado a
`127.0.0.1:3306`. La carpeta temporal `/tmp/qontrolmed-p2q-20261117` fue
retirada después de verificar los resultados; la copia P2Q se conserva.

El bloque se detuvo antes de abrir Qontrolmed porque no existe todavía una
cuenta técnica runtime. Usar `qontrolmed_admin` en la aplicación contradiría la
separación de identidades y crear la cuenta runtime ampliaría materialmente el
alcance explícito de este plan. No se activó el modo sin contraseña y no se
estableció ningún hash. La continuación exige aprobar primero un plan de cuenta
runtime mínima y conexión controlada.

El propietario autorizó preparar ese bloque, pero su precheck detectó que el
ejecutable instalado en `C:\Program Files\Qontrolmed\Qontrolmed.exe` data del
15/07/2026. El flujo de bootstrap seguro, TLS endurecido y guard de esquema
pertenecen al código de noviembre. Además, la instalación no contiene todavía
la CA pública prevista. No se conectará esa RC histórica a las bases
definitivas y no se creó ninguna cuenta runtime. La continuación requiere una
decisión separada sobre una build actual controlada o un arnés temporal
específico; construir o instalar una RC no queda implícitamente autorizado.
