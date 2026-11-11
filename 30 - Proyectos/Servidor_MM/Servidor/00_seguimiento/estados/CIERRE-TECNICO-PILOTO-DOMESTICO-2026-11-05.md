---
title: "Piloto doméstico: cierre técnico y pendientes de aceptación"
type: register
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../05_evidencias/SERVICIOS-FUNCIONALES-ID-MANUAL-OK-2026-11-05.txt"
  - "../../05_evidencias/PILOTO-ID-MANUAL-CIERRE-2026-11-05.txt"
  - "../../01_gobierno_y_decisiones/DECISION-IDS-MARCAS-MANUALES-2026-11-05.md"
tags: [mysql, seguridad, documentacion]
review_after: 2026-11-12
---

# Cierre técnico de la sesión de piloto — 2026-11-05

## Resultado comprobado

Prueba real desde este ordenador Windows (192.168.1.107) contra srv-mm-01 (192.168.1.31). Solo esquemas piloto y datos ficticios.

- Conexiones TLS con CA e identidad comprobadas; rechazo sin TLS, con CA incorrecta y con nombre incorrecto.
- Cuenta por IP con permisos limitados; denegación fuera del alcance y protocolo X desactivado.
- DML ficticio en tres esquemas, reconexión antes de una operación nueva y timeout real de lectura.
- Escritura sintética interrumpida cancelando exclusivamente la conexión propia: error explícito, sin repetición ni duplicación observada, recuperación para una nueva operación.
- Copia y restauración de las tres bases ficticias en destinos separados verificadas antes de añadir el esquema funcional. No afirmar que se restauró ya el conjunto funcional de 33 tablas.
- Preparadas 33 tablas funcionales a partir exclusivamente de metadatos de la instancia local; sin copiar registros reales. Roles/permisos y administrador sintéticos inicializados.
- Autenticación correcta e incorrecta del servicio real y permisos de sesión ficticia comprobados.
- Gestión: alta de marca con ID manual explícito 1207, consulta y modificación correctas. No renumeración ni cambio a AUTO_INCREMENT. Corregidos formulario/servicio de la copia aislada.
- Quirófanos: alta, consulta, modificación y desactivación de instrumento ficticio verificadas en una ventana anterior; en la última se verificó el resultado persistido sin recrearlo.
- Preventivos: creación/consulta idempotente de punto ficticio sin duplicación; consulta de campaña activa vacía correcta.
- Suite automatizada de la copia aislada: 39 pruebas correctas; diferencias sin errores de formato.

## Rectificación de ID de marcas

El propietario aclaró que son identificadores importados, manuales por diseño. La propuesta de autoincremento se retiró. El ALTER exclusivo del piloto fue rechazado con 1833 por dependencia foránea; no se forzó ni se eliminaron relaciones. El problema real era que Guardar no transmitía el ID del formulario al servicio. La nueva alta conserva ese diseño y rechaza ID inválido o duplicado. La instancia original no se modificó.

## Estado final seguro

Salida del script: CUENTA_LAN_BLOQUEADA, REGLA_LAN_PROPIA_RETIRADA, ESCUCHA_LOCAL_RESTAURADA, MYSQL_FINAL_INACTIVE_DISABLED_SIN_ESCUCHAS y VENTANA_LAN_CERRADA.

Revalidación independiente por SSH: mysql inactive/disabled, sin proceso mysqld, sin escuchas 3306/33060 y sin unidades fallidas. Archivo seguro .cnf SHA256 4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927. SSH conserva acceso por clave. Las cuentas del piloto quedan bloqueadas; se conservan bases ficticias y copias protegidas. La retirada de regla fue realizada y confirmada por el script privilegiado; no se repitió una lectura sudo independiente de UFW.

Certificado de servidor de piloto hasta 2027-02-03; CA hasta 2027-11-05. No son identidad/certificados de producción. Credenciales privadas en ubicaciones restringidas fuera de repositorios; ninguna clave privada o contraseña en esta documentación.

## Cambios de aplicación

Worktree independiente C:\Users\Maxi\Documents\Codex\2026-11-05\u\work\qontrolmed-piloto, rama pilot/mysql-tls-20261105, base 014bf7c. TLS por defecto con CA/identidad, timeouts, LOCAL INFILE desactivado, recuperación acotada antes de nueva operación, cierre de sesiones y alta de marcas con ID manual. Cambios sin commit, sin merge y sin instalación sobre la aplicación habitual. Repositorio original y sus cambios documentales previos preservados. Entorno Python independiente en work/venv-piloto.

Copia seleccionada de los ocho archivos cambiados, sin secretos, en 06_herramientas/configuracion/QONTROLMED-CAMBIOS-PILOTO-2026-11-05.zip. Es una instantánea para revisión, no un instalador ni un parche que deba sobrescribir ciegamente versiones posteriores.

## Pendientes de aceptación

1. Revisar visualmente pantallas y flujos completos. El propietario confirmó que se abrió la portada; @oai/sky detectó su ventana, pero falló dos capturas y no se realizaron clics. No declarar la interfaz completa validada.
2. Comprobar desde otro equipo de la LAN el rechazo de TCP/3306 mientras el puesto autorizado conecta correctamente. No hace falta otro equipo para las pruebas ya superadas; sí para verificar activamente este caso de origen no autorizado.
3. Ampliar copia/restauración al esquema funcional completo y definir después el destino externo y política de copias de producción. El ensayo anterior solo tenía tablas ficticias sencillas.
4. Timeout real de escritura y más escenarios de pérdida de red, si se exige aceptación de esos casos; la cancelación de conexión propia y los tests de no repetición no cubren todas las fallas físicas.
5. Revisar/aceptar los cambios de código y el empaquetado antes de sustituir la aplicación habitual.
6. Confirmar red y requisitos de sede. Este piloto no autoriza producción, importación de datos reales ni cambio de router/red.

Estado global: infraestructura y servicios representativos del piloto comprobados; aceptación completa todavía pendiente de estos puntos. No reiniciar ni dejar MySQL activo de forma permanente por este resultado.
