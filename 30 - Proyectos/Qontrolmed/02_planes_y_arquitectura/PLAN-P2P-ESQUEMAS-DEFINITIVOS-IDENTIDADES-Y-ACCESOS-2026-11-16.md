---
title: "P2P — Esquemas definitivos, identidades y accesos"
type: plan
status: active
created: 2026-11-16
updated: 2026-11-17
sources:
  - "Comunicación del propietario de 2026-11-16"
  - "docs/01_gobierno_y_decisiones/DECISION-ESPECIFICACIONES-OPERATIVAS-PILOTO-2026-11-16.md"
  - "docs/02_planes_y_arquitectura/PLAN-P2O-CARGA-MAESTROS-SRV-MM-01-2026-11-15.md"
  - "H:/02.Trabajo/obsidian/30 - Proyectos/Servidor_MM/Servidor/CONTINUAR-SIGUIENTE-SESION.md"
tags: [qontrolmed, mysql, esquemas, identidades, sftpgo, accesos]
review_after: 2026-11-23
---

# P2P — Esquemas definitivos, identidades y accesos

## 1. Autorización y objetivo

El propietario autorizó el 16/11/2026 iniciar las fases 0 y 1 del plan de
conectividad. Se crearán como destinos definitivos los esquemas MySQL
`gestion`, `preventivos` y `quirofanos`, preservando los esquemas
`piloto_mm_*` como fuente y reversión hasta la aceptación final.

El bloque también consolida la separación entre:

1. usuarios funcionales de Qontrolmed;
2. cuenta técnica MySQL de la aplicación;
3. administrador técnico de MySQL y del servidor;
4. usuarios nominales del repositorio documental SFTPGo.

## 2. Límites

- No borrar, vaciar ni renombrar destructivamente `piloto_mm_*`.
- No introducir datos clínicos, pacientes, secretos ni credenciales en la
  documentación o evidencias.
- No abrir todavía MySQL, SSH, SMB, SFTPGo ni otros servicios a Internet.
- No habilitar todavía 3306 en la LAN ni conectar una RC de Qontrolmed.
- No activar el acceso documental real ni crear usuarios nominales reales de
  SFTPGo dentro de este bloque.
- No ejecutar migraciones automáticamente desde Qontrolmed.

## 3. Modelo de identidades

| Identidad | Gestión | Finalidad | No permite |
| --- | --- | --- | --- |
| Usuario funcional | Qontrolmed | Login, roles, permisos y trazabilidad funcional | Administrar MySQL, Ubuntu o SFTPGo |
| Cuenta técnica de aplicación | MySQL | Conexión de Qontrolmed a sus tres esquemas | DDL, usuarios MySQL, privilegios globales |
| Administrador técnico | SSH y `qontrolmed_admin@localhost` | Servidor, copias, migraciones y recuperación | Uso funcional cotidiano |
| Usuario documental | SFTPGo WebClient | Acceso nominal a las carpetas documentales autorizadas | SSH, MySQL, administración del servidor |

SFTPGo mantendrá una cuenta nominal por persona, con TOTP y permisos propios.
La identidad puede corresponder a la misma persona que usa Qontrolmed, pero no
compartirá contraseña, sesión ni privilegios. SMB no forma parte del acceso
documental inicial. La matriz definitiva de carpetas y permisos se aprobará
antes de activar usuarios reales, sin bloquear la creación de los esquemas.

## 4. Fase 0 — Esquemas definitivos

### 4.1. Precheck

1. Verificar host, MySQL 8.4, montajes, espacio y unidades fallidas.
2. Confirmar `active/disabled`, escucha exclusiva en loopback y ausencia de
   3306/33060 en LAN.
3. Inventariar `piloto_mm_*`: tablas, filas, claves foráneas, ledger y grants.
4. Confirmar que `gestion`, `preventivos` y `quirofanos` no existen o detener
   la ejecución si contienen cualquier objeto.
5. Crear una copia lógica fechada de los tres esquemas fuente y verificar que
   el fichero es legible, no vacío y tiene SHA-256.

### 4.2. Ejecución

1. Crear `gestion`, `preventivos` y `quirofanos` con el mismo juego de
   caracteres y cotejamiento validado.
2. Restaurar estructura y datos desde la copia mediante una cuenta temporal
   de migración, sin conceder DDL a la cuenta runtime.
3. Adaptar únicamente las referencias explícitas a nombres de esquema que el
   precheck haya identificado; no hacer sustituciones ciegas sobre SQL.
4. Aplicar el ledger canónico compatible con el código vigente.
5. Retirar o bloquear la cuenta temporal y eliminar SQL temporal no necesario.

### 4.3. Aceptación

- Existen exactamente los tres destinos definitivos.
- Estructura, columnas, índices, claves, recuentos y maestros coinciden con la
  fuente aprobada.
- Las seis tablas operativas de Preventivos y las tablas operativas iniciales
  de Quirófanos/Gestión conservan el estado de arranque aprobado.
- No hay huérfanos ni duplicados nuevos.
- El ledger devuelve `compatible`.
- `piloto_mm_*` permanece intacto y utilizable para reversión.
- MySQL continúa sin exposición LAN.

### 4.4. Reversión

Ante cualquier fallo, detener el bloque, retirar los destinos incompletos solo
después de verificar sus nombres exactos y conservar `piloto_mm_*`. Si el fallo
aparece después de una restauración parcial, recrear los destinos desde la
copia P2P verificada. No modificar la fuente durante la reversión.

## 5. Fase 1 — Administración e identidades

1. Validar Workbench por túnel SSH con `qontrolmed_admin@localhost`, limitado a
   los seis esquemas durante la transición y, tras aceptación, a los tres
   definitivos más el acceso de solo lectura necesario para la reversión.
2. Definir la matriz de permisos funcionales de Qontrolmed para alta, baja,
   bloqueo, roles y permisos de usuarios.
3. Confirmar que el administrador funcional no puede administrar cuentas
   MySQL, SFTPGo ni Ubuntu.
4. Preparar la plantilla de cuenta técnica runtime sin DDL ni privilegios
   globales; su creación y apertura LAN quedan para la fase de conexión.
5. Documentar el ciclo de alta, baja, bloqueo y recuperación de usuarios
   SFTPGo nominales con TOTP, separado del ciclo de usuarios Qontrolmed.

## 6. Evidencia y cierre

Registrar comandos depurados, resultados, hashes y diferencias observadas sin
secretos. Actualizar el diario y los relevos de Qontrolmed y Servidor_MM. La
eliminación futura de `piloto_mm_*` requerirá un bloque independiente después
de la aceptación y de vencer el periodo de reversión.

## 7. Resultado de ejecución del 16/11/2026

### Fase 0 — completada

- Se crearon los esquemas definitivos `gestion`, `preventivos` y `quirofanos`.
- Se conservaron sin modificación los tres esquemas `piloto_mm_*`.
- La copia previa quedó en
  `/var/backups/qontrolmed/p2p-20261116T105450Z/fuentes-antes-p2p.sql` y su
  comprobación SHA-256 terminó correctamente.
- Se validaron origen y destino por tabla y recuento: Gestión 13 tablas,
  Preventivos 10 y Quirófanos 7.
- Los seis esquemas usan `utf8mb4` y `utf8mb4_0900_ai_ci`.
- MySQL quedó `active/disabled`, ligado únicamente a `127.0.0.1:3306`.
- El verificador terminó con `P2P_VERIFICACION=OK`.

### Fase 1 — iniciada

- `qontrolmed_admin@localhost` conserva permisos limitados a los tres esquemas
  `piloto_mm_*` y recibió `ALL PRIVILEGES` a nivel de esquema sobre `gestion`,
  `preventivos` y `quirofanos`.
- No se concedieron privilegios globales ni `GRANT OPTION`.
- El propietario validó visualmente en Workbench, mediante el túnel SSH, la
  presencia de los seis esquemas: tres definitivos y tres de reversión.
- Queda pendiente cerrar los procedimientos diferenciados de usuarios
  funcionales y documentales.

## 7. Política documental acordada

### 7.1. Administración y recuperación

- Vicente será el administrador documental de SFTPGo y dará de alta, bloqueará,
  reactivará y dará de baja a los usuarios documentales.
- La recuperación inicial será asistida: el usuario solicita el restablecimiento
  al administrador, que asigna una credencial temporal o restablece el acceso y,
  cuando corresponda, reinicia el enrolamiento TOTP.
- No se habilitará por ahora recuperación automática mediante correo o teléfono.
  Podrá estudiarse si la organización la solicita más adelante.
- La cuenta administrativa no se utilizará para el trabajo documental cotidiano;
  Vicente tendrá, si lo necesita, una cuenta documental ordinaria separada.

### 7.2. Acceso a carpetas y propiedad operativa

Todos los usuarios documentales podrán listar y descargar toda la documentación
compartida. También podrán crear carpetas y subir documentos en su espacio de
aportación. La regla «solo puede borrar lo que ha subido» no se implementará
con permiso de borrado sobre una única carpeta común, porque SFTPGo concede los
permisos por ruta y no por autor histórico del archivo.

El diseño será:

1. `/Compartido`: vista de lectura para todos (`list`, `download`).
2. `/Mis documentos`: carpeta nominal del usuario con `list`, `download`,
   `upload`, `create_dirs`, `delete_files` y `delete_dirs`.
3. Cada carpeta nominal se mostrará dentro de la vista compartida al resto de
   usuarios únicamente con lectura y descarga.
4. No se concederán por defecto `overwrite`, `rename`, `copy`, `chmod`, `chown`
   ni creación de enlaces; se añadirán solo si una necesidad validada lo exige.
5. La asignación de carpetas adicionales se realizará mediante carpetas
   virtuales, grupos y permisos por ruta administrados desde SFTPGo.

Este modelo permite leer toda la documentación y, a la vez, impide que un
usuario elimine archivos alojados en la carpeta nominal de otra persona. La
estructura exacta y las pruebas de aceptación se prepararán antes de activar
cuentas reales.

## 8. Pausa y continuación acordada

La sesión se pausó a petición del propietario el 16/11/2026 después de validar
los esquemas en Workbench. No queda ninguna acción operativa en curso.

Se corrigió la descripción del bootstrap funcional: el instalador no crea por
sí solo toda la cuenta desde un asistente. Primero se insertan las semillas de
roles/permisos y el usuario inicial en `gestion.usuarios`; después Qontrolmed
solicita y guarda la primera contraseña mediante el flujo controlado de
bootstrap. El modo excepcional debe volver a
`QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0` al terminar.

### Punto seguro

- Fase 0 completada y verificada.
- Fase 1 iniciada, sin usuarios funcionales o documentales reales creados.
- MySQL observado `active/disabled`, solo en `127.0.0.1:3306`.
- Los esquemas definitivos y `piloto_mm_*` permanecen disponibles.
- Workbench fue validado mediante túnel SSH.
- No se ha abierto MySQL en LAN ni conectado Qontrolmed a los destinos.

### Primer bloque de la próxima sesión

1. Releer ambos relevos y este plan.
2. Revalidar en solo lectura MySQL, túnel y seis esquemas.
3. Inventariar en `gestion` las tablas y filas de `roles`, `permisos`,
   `roles_permisos` y `usuarios`, sin mostrar hashes ni datos personales.
4. Confirmar si las semillas están completas y que no existe un usuario activo
   incompatible.
5. Preparar un plan de bootstrap seguro antes de insertar o modificar usuarios.

No abrir 3306 en LAN, no crear la cuenta runtime y no activar SFTPGo hasta
cerrar ese inventario y el plan siguiente.

## 9. Reanudación del 17/11/2026

La revalidación por SSH confirmó `srv-mm-01`, MySQL `active/disabled`, ninguna
unidad fallida y escucha exclusiva en `127.0.0.1:3306`. A petición expresa del
propietario, este habilitó el arranque automático mediante `systemctl enable
mysql`, introduciendo su credencial `sudo` directamente y sin compartirla.

La comprobación posterior observó MySQL `active/enabled`, ninguna unidad
fallida y la misma escucha exclusiva en loopback. Este cambio no abre MySQL a
la LAN ni altera esquemas, cuentas o datos. La reversión es `sudo systemctl
disable mysql`; detener el servicio sería una decisión separada.

El inventario funcional se repitió y cerró mediante una única consulta de solo
lectura. `gestion.roles`, `gestion.permisos`, `gestion.roles_permisos` y
`gestion.usuarios` contienen 0 filas; los controles de huérfanos y referencias
inválidas también devolvieron 0. No se consultaron valores personales, hashes o
contraseñas y no hubo escrituras. El siguiente bloque es P2Q: sembrar 4 roles,
40 permisos y 75 asignaciones, y crear de forma controlada el administrador
inicial.
