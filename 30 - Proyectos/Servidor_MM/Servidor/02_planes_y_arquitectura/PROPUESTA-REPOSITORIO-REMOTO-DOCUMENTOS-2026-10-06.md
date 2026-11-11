# Propuesta de repositorio remoto de documentos y archivos

Fecha de elaboración: 2026-10-06 (`Europe/Madrid`)  
Estado: propuesta para estudio; directorios, servicios y accesos aun no creados  
Ámbito: `srv-mm-01`, almacenamiento `/srv/compartido` y equipos autorizados

## 1. Objetivo

Preparar en `srv-mm-01` un repositorio privado para cargar, descargar y compartir documentos de trabajo, con una experiencia sencilla desde Windows y, si se aprueba, desde navegador o dispositivos remotos.

Este bloque es independiente de la conexión Qontrolmed-MySQL. No exige arrancar MySQL, abrir 3306/33060 ni modificar el código de Qontrolmed. Si Qontrolmed incorpora documentos en el futuro, la integración se diseñará mediante una interfaz y permisos propios; la aplicación no deberá recibir acceso general al repositorio.

El alcance permitido sigue excluyendo datos de pacientes, historias clínicas, diagnósticos, imágenes médicas e identificadores clínicos. Los datos de trabajadores, proveedores, contactos y registros de acceso son datos personales protegidos.

## 2. Estado de partida

- Existe un LV cifrado dentro del LUKS2 de `/dev/sda`, montado en `/srv/compartido`.
- Tiene 224 GB asignados y aproximadamente 218 GB disponibles en la ultima validacion.
- El montaje usa `rw,nosuid,nodev,noexec` y el directorio raíz conserva `root:root 0750`.
- La separación respecto a `/var/lib/mysql` evita que los documentos consuman el volumen de la base de datos.
- No hay todavía servicio de archivos aprobado. Samba sigue expresamente fuera del alcance ejecutado.
- El SSD de 1 TB, `/dev/sdb`, no se utilizará para este servicio sin una autorización posterior y específica.
- El cifrado LUKS protege el disco apagado, pero no sustituye autenticación, autorización, registro, copias ni protección del servidor mientras está encendido.

## 3. Tres niveles de servicio posibles

| Nivel | Función principal | Opción técnica orientativa | Complejidad | Observación |
| --- | --- | --- | --- | --- |
| A | Carga y descarga por navegador o cliente seguro | SFTPGo WebClient/SFTP sobre red privada | Baja-media | Recomendado para el primer piloto |
| B | Carpeta remota como unidad de red | SMB o WebDAV solo sobre VPN | Media | No ofrece una copia local completa ni trabajo desconectado |
| C | Sincronización tipo OneDrive, versiones y clientes de escritorio/móvil | Nextcloud | Alta | Exige más componentes, mantenimiento y disciplina sobre su almacén |

Syncthing puede sincronizar carpetas entre dispositivos, pero no es la primera opción para un repositorio empresarial multiusuario: replica cambios y conflictos entre equipos y no proporciona por sí solo el mismo modelo de portal, usuarios y gobierno documental.

## 4. Recomendación provisional

Empezar por el **nivel A: SFTPGo con WebClient**, limitado a una red privada o VPN y sin publicacion directa en Internet.

Motivos:

- responde exactamente a la necesidad inicial de cargar y descargar archivos;
- puede usar el sistema de archivos local ya preparado;
- ofrece cuentas individuales, permisos por directorio, cuotas, segundo factor TOTP, interfaz web y registros;
- permite mantener separados los usuarios normales, el administrador del servicio y la cuenta técnica;
- no obliga a convertir ahora el servidor en una plataforma completa de colaboración;
- deja abierta una migración futura a Nextcloud si se necesitan sincronización automática, versionado avanzado, enlaces compartidos o aplicaciones móviles integradas.

SFTPGo admite SFTP, SCP, WebDAV y un WebClient HTTPS. En el piloto solo se habilitarán los protocolos realmente necesarios. FTP y FTP sin TLS no forman parte de la propuesta.

La recomendación de SFTPGo no decide todavía la tecnología de acceso remoto. Debe elegirse por separado entre una VPN autogestionada, una red privada gestionada o, si el primer piloto se hace en la sede, acceso exclusivo desde la LAN autorizada. No se abrirá el servicio directamente a Internet ni se publicará SMB/445.

## 5. Estructura de almacenamiento propuesta

La raíz técnica propuesta es:

```text
/srv/compartido/repositorio/
|-- usuarios/
|   `-- <cuenta>/
`-- compartido/
    `-- empresa/
```

Criterios:

- `/srv/compartido/repositorio` permanecerá bajo control administrativo y no será escribible por cuentas interactivas ordinarias.
- Cada usuario tendrá un directorio privado y una cuenta identificable; no se usarán credenciales compartidas.
- `compartido/empresa` se mapeará como carpeta virtual común solo para los grupos autorizados.
- Los permisos visibles se aplicarán tanto en SFTPGo como en el sistema de archivos; no se confiará únicamente en la interfaz web.
- Se definirán cuotas antes de admitir datos reales para impedir que el repositorio llene el LV.
- La base de configuración del servicio y sus registros no se mezclarán con los documentos de usuario.
- No se depositarán en el repositorio claves privadas, archivos `.env`, contraseñas, tokens ni copias sin cifrar de secretos.

Los nombres definitivos de usuarios, grupos y carpetas se decidirán antes de ejecutar. No conviene crear propietarios provisionales que después haya que reinterpretar.

## 6. Acceso de red propuesto

### Piloto local controlado

1. El servicio escucha únicamente en loopback o en la interfaz privada expresamente elegida.
2. UFW permite acceso solo desde el origen o interfaz aprobados.
3. El WebClient usa HTTPS con un nombre estable y certificado validable.
4. Se prueba primero con una cuenta sin privilegios y archivos no sensibles.

### Acceso desde fuera de la sede

Debe realizarse mediante una red privada/VPN con identidad de dispositivo y reglas de mínimo privilegio. La VPN solo dará ruta al servicio de archivos aprobado, no a toda la LAN ni automáticamente a MySQL o SSH.

Una solución gestionada como Tailscale puede evitar puertos entrantes y aplicar políticas por usuario/dispositivo, pero introduce dependencia del proveedor, identidad externa y metadatos operativos. WireGuard autogestionado reduce esa dependencia, pero traslada a la empresa la distribución de claves, revocación, DNS, monitorización y recuperación. La elección requiere aprobación específica.

## 7. Controles mínimos antes de producción

- Cuentas nominales; una cuenta administrativa separada y sin uso cotidiano.
- Segundo factor para el acceso web remoto.
- TLS válido y desactivación de protocolos no utilizados.
- Límites de intentos, protección ante fuerza bruta y bloqueo controlado.
- Cuota por usuario o grupo y umbrales de alerta del sistema de archivos.
- Registro de autenticaciones y operaciones, con retención limitada y sin secretos.
- Política de formatos y tamaños; tratamiento específico de ejecutables, macros y archivos comprimidos.
- Análisis antimalware o circuito de cuarentena si se reciben archivos de terceros.
- Actualizaciones de seguridad y procedimiento de mantenimiento.
- Inventario de usuarios y revisión periódica de accesos.
- Copia 3-2-1 y prueba de restauración antes de considerar el repositorio como ubicación única.

El propio LV, una instantánea LVM o una segunda carpeta en el mismo servidor no constituyen por sí solos una copia independiente. El SSD de 1 TB no se asignará como copia sin comprobar su custodia, contenido, vida útil y autorización de borrado o reutilización.

## 8. Fases de implantación

### Fase 0. Decisión funcional y de acceso

Confirmar:

1. si basta navegador/carga-descarga o se necesita sincronización automática;
	1. Solo carga y descarga de documentos
2. número de usuarios y dispositivos previstos;
	1. No más de 10 de momento
3. acceso solo en sede o también desde Internet mediante VPN;
	1. Acceso desde internet
4. carpetas privadas y grupos compartidos necesarios;
	1. de momento no, solo una carpeta general con opciones de crear nuevas carpetas
5. volumen inicial, crecimiento, tamaño máximo de archivo y cuotas;
	1. De momento la inmensa mayoría van a ser pdf de una hoja o dos a lo sumo
6. necesidad de enlaces externos, versionado, papelera y trabajo sin conexión;
	1. De momento NO
7. RPO, RTO, retención y destino de copias;
	1. RPO, como de momento solo vamos a subir ficheros pdf, no es excesivamente importante una frecuencia corta, se podría hacer diaria de madrugada
		 Propuesta con aviso de necesidad de hacer una copia externa 1 vez al mes.
	2. RTO, no es problemático tampoco, puede estar 1 día 
8. aceptación o rechazo de un proveedor de VPN/identidad externo.
	1. Me decantaría por rechazo, 
9. (Punto incorporado manualmente)Referente a Qontrolmed, como va a ser una instalación piloto para evaluación en empresa real y con trabajo real, he pensado que lo más práctico de momento es mantener Qontrolmed tal y como está, montar en la red loca cada ordenador que lo necesite conectado al SQL del servidor y en los remotos instalar la aplicación con la bd en cada equipo y exportar los datos de la bd, subirlos al servidor en la carpeta determinada y el administrador desde esa carpeta incorporarlos al MYSQL central.
		Se que es más 'rollo' da pie a errores y no está automatizado, pero si el resultado de la aplicación es buena, el cliente la quiere instalar al 100 %, desarrollaría una versión actualizada de Qontrolmed para poder integrarla en el servidor, por lo que el servidor habría que prepararlo también, o bien dejarlo ya preparado para si en un futuro se integra Qontrolmed.

### Fase 1. Preparación local sin exposición de red

- Revalidar en solo lectura el montaje, espacio, permisos, estado de UFW y servicios existentes.
- Crear la raíz y subdirectorios definitivos con propietario, grupo, `setgid` o ACL según el modelo aprobado.
- Verificar escritura y denegación con cuentas de prueba sin datos reales.
- Registrar permisos, UUID, espacio y huellas de los archivos de configuración afectados.

### Fase 2. Servicio limitado a entorno de prueba

- Instalar desde una fuente oficial verificada y fijar el método de actualización.
- Crear cuenta de servicio sin shell y almacenamiento de configuración separado.
- Mantener la escucha en loopback o interfaz privada de prueba.
- Crear un unico usuario piloto, cuota pequena y datos no sensibles.
- Validar registro, bloqueo, MFA, subida, descarga, renombrado y borrado.

### Fase 3. Acceso remoto privado

- Implantar la VPN o red privada aprobada.
- Aplicar reglas por usuario/dispositivo y por puerto, sin ruta general a la LAN.
- Activar HTTPS y probar desde una segunda conexión externa autorizada.
- Verificar que ni el WebClient, ni SFTP, ni SMB, ni MySQL quedan publicados directamente a Internet.

### Fase 4. Copias, restauración y entrada en servicio

- Ejecutar una copia cifrada hacia un destino independiente.
- Restaurar una muestra y validar contenido, permisos y trazabilidad.
- Documentar altas, bajas, recuperación de MFA, bloqueo, actualización y emergencia.
- Autorizar por escrito la entrada en producción.

## 9. Prueba de aceptación

1. Un usuario autorizado puede cargar, descargar y listar solo sus rutas permitidas.
2. Un usuario no puede acceder a la carpeta privada de otro ni escalar a administración.
3. Un dispositivo no enrolado o un origen no autorizado no alcanza el servicio.
4. El servicio no escucha en interfaces ni puertos no aprobados.
5. Los puertos MySQL 3306/33060 siguen cerrados y MySQL permanece en su estado seguro actual.
6. La cuota impide llenar el volumen y genera una alerta verificable.
7. Las operaciones relevantes quedan registradas sin exponer secretos.
8. La pérdida o revocación de una cuenta/dispositivo elimina el acceso en el tiempo objetivo.
9. Una copia de prueba se restaura en una ubicación aislada y se verifica.
10. La desinstalación o parada del servicio no altera los documentos ni el montaje del LV.

## 10. Reversión

1. Revocar el usuario o dispositivo piloto.
2. Retirar exclusivamente las reglas UFW y rutas VPN incorporadas para el servicio.
3. Detener y deshabilitar el servicio de transferencia.
4. Restaurar las copias fechadas de su configuración.
5. Conservar los documentos y registros necesarios; no borrar datos durante la reversión técnica.
6. Desinstalar componentes solo tras comprobar que no sirven a otros sistemas.
7. Si se decide retirar también los documentos, hacerlo como una operación destructiva separada, con inventario, copia verificada y autorización expresa.

## 11. Cuándo elegir Nextcloud en lugar del piloto recomendado

Nextcloud pasa a ser la opción preferente si se confirma que se necesita:

- sincronización automática con carpeta local en Windows;
- trabajo desconectado;
- versiones y papelera orientadas al usuario;
- aplicaciones móviles integradas;
- enlaces compartidos con caducidad y gobierno centralizado;
- colaboración documental más allá de carga y descarga.

En ese caso el directorio de datos debe quedar bajo control exclusivo de Nextcloud. Modificarlo a la vez mediante Samba, SFTP o herramientas externas puede dejar desactualizado su índice y producir comportamientos incoherentes en los clientes. La base de datos, Redis, servidor web, tareas programadas, TLS, actualizaciones y copias se diseñan como un servicio completo y separado de los esquemas de Qontrolmed.

## 12. Decisión pendiente del propietario

| Campo | Valor |
| --- | --- |
| Servicio inicial | Propuesta: SFTPGo WebClient |
| Experiencia requerida | Pendiente: carga/descarga o sincronización completa |
| Usuarios y dispositivos | Pendiente |
| Acceso fuera de la sede | Pendiente |
| VPN/red privada elegida | Pendiente |
| Carpetas y grupos | Pendiente |
| Cuotas y volumen inicial | Pendiente |
| Destino de copias | Pendiente |
| RPO/RTO | Pendiente |
| Responsable de validacion | Pendiente |
| Fecha de aprobacion | Pendiente |

Hasta completar esta decisión no se crearán cuentas, directorios finales, servicios, reglas de red ni dependencias externas.

## 13. Fuentes tecnicas

Consultadas el 2026-10-06:

- SFTPGo, funciones y protocolos: <https://docs.sftpgo.com/latest/>
- SFTPGo, carpetas virtuales y cuotas: <https://docs.sftpgo.com/latest/virtual-folders/>
- Nextcloud, requisitos del servidor y clientes: <https://docs.nextcloud.com/server/stable/admin_manual/installation/system_requirements.html>
- Nextcloud, cambios externos y coherencia del índice: <https://docs.nextcloud.com/server/stable/admin_manual/configuration_files/external_storage_configuration_gui.html>
- Syncthing, modelo de sincronizacion y conflictos: <https://docs.syncthing.net/users/syncing.html>
- Tailscale, acceso remoto a servidores de archivos: <https://tailscale.com/docs/use-cases/personal-or-at-home-use/access-nas-media-file-servers>
- Tailscale, responsabilidad compartida: <https://tailscale.com/kb/1212/shared-responsibility>
