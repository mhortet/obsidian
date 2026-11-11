---
title: "Propuesta MySQL LAN para srv-mm-01"
type: plan
status: draft
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../00_seguimiento/estados/ESTADO-REVALIDACION-SRV-MM-01-2026-11-05.md"
  - "PLAN-ACTUALIZACIONES-QONTROLMED-LAN-2026-10-25.md"
tags: [documentacion, seguridad, mysql]
review_after: 2026-11-12
---
# srv-mm-01: propuesta de preparación de MySQL para Qontrolmed

Fecha: 5 de noviembre de 2026 · Europe/Madrid  
Estado: propuesta para revisión. No aplicada y no autoriza ejecución.  
Destino: piloto LAN de menos de diez equipos. Sin datos de pacientes.

## 1. Decisión propuesta

Preparar primero una prueba aislada con un único puesto y datos ficticios. La apertura a la LAN y el inicio automático de MySQL se aprobarán después de superar las pruebas. La dirección doméstica 192.168.1.31 no se trasladará a producción.

Este documento pertenece al proyecto de Obsidian y recoge una propuesta pendiente de ejecución. El propietario ha aceptado el piloto doméstico con un único puesto y datos ficticios. Los valores pendientes impiden convertirlo todavía en un plan exacto ejecutable.

## 2. Estado comprobado hoy por SSH

- Identidad: srv-mm-01; IP 192.168.1.31/24 en eno1; gateway 192.168.1.1.
- Ubuntu declarado por el equipo: 24.04.5 LTS; kernel 6.8.0-147-generic.
- Sistema running, sin unidades fallidas ni indicador de reinicio requerido.
- ssh.socket y ufw activos; MySQL inactive y disabled.
- Escuchas TCP observadas: SSH/22 y resolución DNS en loopback. Sin escuchas 3306/33060.
- Montajes correctos: /var/lib/mysql y /srv/compartido. Libres: aproximadamente 62 y 218 GiB respectivamente; raíz, 82 GiB.
- No se pudieron inspeccionar las reglas de UFW ni procesos privilegiados: sudo exige autenticación local.
- No se ha revalidado hoy la versión de MySQL, las cuentas, los esquemas, los certificados ni las actualizaciones disponibles. El registro del 1 de noviembre indica MySQL 8.4.11 y ausencia de cuentas Qontrolmed.
- No se ha modificado el servidor.

## 3. Diseño objetivo

| Área | Propuesta | Condición previa |
| --- | --- | --- |
| Red | Escucha en loopback y en la IP LAN aprobada; nunca en comodines | Confirmar dirección, interfaz y resolución de nombres |
| TLS | require_secure_transport=ON; CA, certificado y clave de servidor protegidos; TLS 1.2/1.3 | Elegir nombre estable y responsable de emisión/renovación |
| Cliente | Verificar CA e identidad del servidor; timeouts de conexión, lectura y escritura | Revisar y adaptar el código actual de Qontrolmed |
| Protocolo X | mysqlx=OFF, comprobado antes de arrancar | Validar sintaxis y compatibilidad con la versión instalada |
| Firewall | TCP/3306 solo desde IP concretas /32; mantener política de SSH | Inventario de puestos y reservas DHCP |
| Identidad MySQL | Cuenta distinta por puesto e IP; exigir TLS; sin host comodín % | Inventario y canal seguro de entrega de credenciales |
| Administración | root exclusivamente local; administración habitual por SSH; Workbench opcional con cuenta dedicada | Definir operaciones y permisos necesarios |
| Datos | gestion, quirofanos y preventivos según el plan existente | Verificar esquema y procedencia de datos antes de importar |

Cifrar el transporte y comprobar la identidad son controles complementarios: exigir TLS en el servidor no sustituye la validación del certificado por la aplicación. El socket Unix local puede seguir utilizándose para administración.

Workbench por SSH requiere comprobar también el tramo TCP local hacia MySQL con TLS y la identidad usada en el certificado. No se considerará resuelto solo por disponer del túnel.

## 4. Separación de permisos

- Operación: SELECT, INSERT, UPDATE y DELETE únicamente sobre objetos realmente utilizados. Son una base candidata, no concesiones definitivas: revisar consultas, vistas, rutinas y funciones de la aplicación antes de fijar GRANT.
- Mantenimiento: cuenta separada y uso puntual para migraciones aprobadas. No conceder DDL a los puestos por defecto.
- Provisión: preferir al principio administración local controlada, sin cuenta delegada permanente. Si se requiere posteriormente, revisar el alcance de CREATE USER y de la delegación de roles.
- No conceder a los puestos privilegios globales, GRANT OPTION, FILE, administración de cuentas ni acceso a otros esquemas.
- Si se usan roles, definir y verificar su activación por defecto al conectar. Una cuenta por puesto facilita revocación; no identifica por sí sola al empleado que hizo una operación.

## 5. Secuencia de ejecución que deberá aprobarse

1. Completar datos pendientes y revalidar con privilegios, sin iniciar MySQL: configuración, versión, reglas UFW, almacenamiento y política de actualizaciones.
2. Revisar el código actual de Qontrolmed y elaborar la matriz de operaciones y permisos. Preparar una versión de prueba con TLS e interrupciones controladas.
3. Acordar copia, retención, cifrado, custodia y restauración. Guardar configuración original y metadatos de permisos antes del cambio; no copiar archivos de una base activa como sustituto de una copia consistente.
4. Preparar certificados y un archivo de configuración separado. Validar sintaxis y acceso a certificados con la versión instalada antes del arranque.
5. Arrancar MySQL manualmente, manteniendo el arranque automático deshabilitado y sin abrir 3306 a la LAN. Comprobar escucha, TLS y ausencia de 33060.
6. Crear en el piloto esquemas ficticios, roles y una cuenta del puesto autorizado. No importar volcados reales ni modificar datos existentes en esta fase.
7. Añadir una única regla /32 para el puesto piloto, una vez confirmada su IP y aprobado el cambio exacto. Registrar la regla para poder retirarla sin afectar a SSH.
8. Ejecutar pruebas de aceptación y restauración. Ampliar a otros puestos o habilitar inicio automático solo mediante una decisión posterior.

Cada bloque requiere registrar la autorización, los valores concretos, la evidencia y su resultado. Un fallo bloquea el paso siguiente.

## 6. Aceptación

| Prueba | Resultado esperado |
| --- | --- |
| Puesto autorizado y certificado correcto | Conecta con cifrado y trabaja con los objetos permitidos |
| TCP sin TLS | Rechazado |
| CA errónea, certificado caducado o nombre incorrecto | Cliente rechaza la conexión |
| Puesto no autorizado | Sin acceso a 3306 |
| Puerto 33060 | Sin escucha |
| Acceso fuera del alcance o administración desde cuenta de operación | Denegado |
| Pérdida de red en reposo | Recuperación acotada antes de una nueva operación |
| Pérdida de red durante escritura | Error explícito; sin repetición silenciosa |
| Copia restaurada en destino aislado | Estructura, datos ficticios y operaciones verificadas |
| Revocación de un puesto | Pierde acceso sin afectar al resto; cerrar también sesiones existentes |
| Reinicio del servidor | Solo en ventana aprobada; SSH, discos, UFW y política de MySQL siguen correctos |

## 7. Riesgos y reversión

Riesgos principales: fallo de arranque por certificado/configuración, bloqueo de conexiones por TLS, permisos insuficientes y pérdida de acceso por reglas de red incorrectas.

Ante fallo, detener el piloto y mantener SSH disponible. Retirar exclusivamente la regla 3306 introducida; detener y deshabilitar MySQL; conservar diagnósticos sin secretos. Restaurar el archivo de configuración previo y sus permisos con MySQL parado. No volver a arrancar una configuración antigua que escuche ampliamente o permita transporte inseguro. Las cuentas o roles nuevos se bloquearán/revocarán según inventario; no se borrarán esquemas ni datos como medida de reversión automática.

Si llegaran a existir escrituras reales, la reversión exige decidir primero cómo conservarlas y reconciliarlas; restaurar una copia sobre producción no es una reversión automática aceptable.

## 8. Datos pendientes antes de ejecutar

1. Resuelto el 2026-11-05: piloto doméstico con un único puesto y datos ficticios. Esta decisión no autoriza aún cambios en servicios, cuentas, esquemas o firewall.
2. IP reservada del primer puesto y nombre estable verificable del servidor. La red de sede necesita además IP, gateway, DNS, DHCP, VLAN y origen administrativo confirmados.
3. Destino de copia separado del servidor, responsable, retención y tolerancia de pérdida/tiempo de recuperación.
4. Acceso a la versión actual del repositorio Qontrolmed y confirmación de operaciones que necesita cada perfil. El plan anterior referencia D:\trabajo\Proyectos\maxgesth; no se ha revisado ese código en esta sesión.
5. Responsable y custodia de la CA, procedimiento de renovación y distribución segura de credenciales.
6. Ventana para cambios y disponibilidad de consola física. La autenticación sudo se hará localmente, sin contraseñas en el chat.

## 9. Fuentes

- Proyecto local: AGENTS.md, README.md, CONTINUAR-SIGUIENTE-SESION.md, estado operativo del 1 de noviembre y PLAN-ACTUALIZACIONES-QONTROLMED-LAN-2026-10-25.md.
- Observación SSH de solo lectura del 5 de noviembre de 2026.
- MySQL 8.4, transporte seguro y variables: https://dev.mysql.com/doc/refman/8.4/en/server-system-variables.html
- MySQL 8.4, conexiones cifradas: https://dev.mysql.com/doc/refman/8.4/en/using-encrypted-connections.html
- MySQL 8.4, opciones de X Plugin: https://docs.oracle.com/cd/E17952_01/mysql-8.4-en/x-plugin-options-system-variables.html

Las propuestas derivan del diseño existente y de estas referencias; no constituyen pruebas de que la configuración esté aplicada.

