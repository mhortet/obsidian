# Revisión documental y ruta mínima a producción de `srv-mm-01`

Fecha: 2026-10-25 (`Europe/Madrid`)  
Estado: **decisión documental provisional; sin autorización de ejecución**  
Ámbito: servidor documental básico y conexión local de Qontrolmed  
Condición de la revisión: el servidor está apagado; no se ha realizado ninguna comprobación técnica en esta fecha

> **Actualización operativa 2026-10-31:** el cliente ha comunicado únicamente la subred `192.168.0.0/24`. Siguen pendientes IP reservada, puerta de enlace, DHCP, DNS, posible VLAN, comprobación de conflicto y origen de administración. El cambio temporal de acceso SSH/UFW realizado en la red de preparación está documentado en `ESTADO-ACCESO-SSH-Y-RED-2026-10-31.md`; no cambia las decisiones de arquitectura de este documento.

## 1. Resultado ejecutivo

La información del cliente permite reducir el alcance y separar dos entregas:

1. **Servicio documental mínimo viable:** carga y descarga manual de documentos y archivos, sin sincronización tipo OneDrive y sin funciones colaborativas avanzadas.
2. **Qontrolmed en red local:** acceso a MySQL exclusivamente desde menos de diez equipos situados en la misma sede.

La vía más corta y controlable para entrar en producción es:

- desplegar primero un **SFTPGo WebClient**, con cuentas nominales, una carpeta compartida y copias restaurables;
- publicar únicamente el WebClient mediante **Cloudflare Tunnel protegido por Cloudflare Access**, sin abrir puertos entrantes en el router;
- no incluir VPN, SMB, enlaces públicos, Nextcloud ni sincronización automática en el MVP;
- preparar en paralelo los cambios mínimos de Qontrolmed para una conexión LAN con TLS verificado;
- incorporar Qontrolmed después de probar un único puesto y ampliar de forma gradual hasta el número real de equipos.

El túnel será exclusivo para el servicio documental HTTP. No transportará MySQL, SSH administrativo ni la interfaz WebAdmin de SFTPGo. Qontrolmed seguirá siendo exclusivamente local.

El mantenimiento remoto tendrá un plano distinto, documentado en `PLAN-ACCESO-ADMINISTRATIVO-REMOTO-2026-10-25.md`: ruta privada de Cloudflare hacia SSH, identidad y dispositivo autorizados, sin publicar TCP/22. Esta separación permite que el propietario y Codex trabajen desde el ordenador de mantenimiento sin compartir credenciales ni mezclar administración con el acceso de usuarios.

El hecho de que la red del cliente probablemente se parezca a la red de preparación no permite reutilizar `192.168.2.104/24` ni la regla temporal `192.168.2.0/24`. La subred, el rango DHCP, la puerta de enlace, el DNS y la dirección reservada para el servidor siguen pendientes de confirmación.

## 2. Información nueva del cliente

### Hechos declarados

- El cliente quiere por ahora un servidor básico para subir y bajar documentos y archivos.
- No se requiere sincronización automática ni una experiencia equivalente a OneDrive.
- Se requiere acceso remoto al repositorio documental y se propone Cloudflare Tunnel.
- El alcance declarado excluye datos de pacientes y datos de personal.
- Qontrolmed accederá a la base de datos únicamente desde la red local del servidor.
- Habrá menos de diez equipos conectados simultáneamente.
- Se desea llegar a producción lo antes posible.
- Falta confirmar la red definitiva del cliente.

### Precisión sobre protección de datos

Aunque no haya datos clínicos ni de personal, las cuentas de acceso, direcciones IP, registros de actividad, nombres, correos o contactos que puedan aparecer siguen siendo datos personales. Se aplicarán minimización, cuentas individuales, retención definida y acceso por necesidad.

## 3. Estado documental consolidado

### Confirmado en la última evidencia técnica disponible

La última revalidación registrada es del 2026-10-05, no de hoy:

- Ubuntu Server 24.04.5 LTS en `srv-mm-01`.
- SSH endurecido para claves y UFW con entrada denegada por defecto.
- Dirección `192.168.2.104/24` obtenida por DHCP durante la preparación; no es dirección de producción.
- Volumen `ubuntu-vg/shared_data` de 224 GB montado en `/srv/compartido`, separado del volumen de MySQL.
- MySQL Community Server 8.4.11 instalado, habilitado pero detenido.
- Puertos 3306 y 33060 cerrados.
- Sin usuarios ni esquemas de Qontrolmed creados.
- SSD de 1 TB `/dev/sdb` sin autorización de reutilización.

Estos puntos son una línea base histórica. Cuando se encienda el servidor deberán revalidarse en modo de solo lectura antes de preparar cualquier cambio.

### Decisiones anteriores que se conservan

- SFTPGo WebClient sigue siendo la solución más ajustada a carga y descarga manual.
- Nextcloud queda descartado del MVP; solo se reconsiderará si aparecen sincronización automática, trabajo sin conexión, versionado, papelera avanzada, enlaces externos o aplicaciones móviles.
- No se publicarán SMB/445, MySQL 3306/33060 ni interfaces administrativas directamente en Internet.
- El repositorio documental y Qontrolmed son líneas separadas; una puede entrar en piloto sin esperar a la otra.
- `/dev/sdb`, firmware, Secure Boot y PAM continúan fuera de alcance.

### Decisiones del plan de 2026-10-08 que cambian

| Tema | Plan anterior | Decisión actual para el MVP |
| --- | --- | --- |
| Acceso documental remoto | VPN WireGuard prevista | Cloudflare Tunnel y Cloudflare Access |
| Alcance funcional | Repositorio remoto | WebClient básico, sin sincronización |
| Sincronización | No requerida | Se mantiene fuera de alcance |
| Qontrolmed local | Piloto inicial por túnel SSH | LAN restringida con TLS para menos de diez equipos |
| Qontrolmed remoto/desconectado | Paquetes de intercambio en estudio | Fuera del alcance actual |
| Administración remota | SSH temporal desde la LAN de preparación | Ruta privada Cloudflare + SSH endurecido |
| Prioridad | Varias líneas en paralelo | Primero servicio documental; Qontrolmed en vía separada |

Los documentos del 5, 6 y 8 de octubre se conservan como histórico y análisis de alternativas. Este documento prevalece para la definición del MVP.

## 4. Arquitectura objetivo mínima

### 4.1. Servicio documental

- SFTPGo WebClient en un binding dedicado, accesible únicamente desde `cloudflared` en el propio servidor.
- WebAdmin en otro binding local, sin ruta publicada por Cloudflare; administración solo mediante acceso técnico controlado.
- REST API deshabilitada en el binding de usuarios si el WebClient no la necesita.
- Una cuenta nominal por persona; no se usarán cuentas compartidas.
- Una carpeta virtual compartida sobre `/srv/compartido/repositorio/`.
- Permisos separados para listar, descargar, subir, crear carpetas, renombrar y borrar.
- Interfaz administrativa limitada al origen de administración autorizado y separada del acceso ordinario.
- Protocolos no utilizados deshabilitados. SMB, FTP sin TLS y enlaces públicos quedan fuera del MVP.
- Cuota, tamaño máximo de archivo y alertas definidos antes de cargar datos reales.
- Registros suficientes para soporte y seguridad, con retención limitada.

### 4.2. Acceso remoto con Cloudflare

Cloudflare Tunnel encaja en este caso porque el acceso es web, no requiere abrir puertos entrantes y puede funcionar aunque la sede esté bajo CGNAT. La arquitectura propuesta es:

```text
Navegador remoto
       |
       v
Cloudflare Access: identidad y política de acceso
       |
       v
Cloudflare Tunnel: conexión iniciada desde el servidor
       |
       v
SFTPGo WebClient: segundo control de cuenta y permisos
       |
       v
/srv/compartido/repositorio/
```

Controles obligatorios:

- nombre público dedicado, por ejemplo `documentos.dominio-cliente.tld`, en una zona DNS administrada por Cloudflare;
- aplicación self-hosted de Cloudflare Access creada **antes** de habilitar el hostname para usuarios;
- política `Allow` limitada a direcciones de correo individuales o al grupo corporativo exacto; no usar `Include Everyone` ni permitir cualquier correo válido;
- autenticación mediante proveedor de identidad existente o, para el piloto, OTP por correo a una lista cerrada;
- sesión de Access de duración acotada y posibilidad de revocar cada usuario;
- segunda autenticación en SFTPGo con cuenta nominal y MFA cuando sea viable;
- `cloudflared` como servicio de mínimo privilegio y credencial del túnel fuera del repositorio;
- ruta del túnel únicamente al binding WebClient; no publicar WebAdmin, REST administrativa, SSH, SFTP, SMB, 3306 ni 33060;
- preservar correctamente la IP de origen usando cabeceras de proxy confiadas solo desde el proxy local;
- evitar caché de contenido documental en el hostname y revisar los registros/retención de Cloudflare;
- comprobar el tamaño máximo de archivo. Cloudflare documenta 100 MB por carga en planes Free/Pro y 200 MB en Business; si el límite funcional fuera mayor habrá que validar carga fragmentada de SFTPGo o cambiar de diseño;
- confirmar contrato, titularidad de la cuenta, dominio, recuperación del administrador y dependencia de Internet/Cloudflare.

Cloudflare Tunnel no es una copia de seguridad ni sustituye permisos, MFA, análisis de archivos o registros en SFTPGo. Tampoco debe crearse un hostname público sin Access: un túnel por sí solo publica la aplicación a Internet.

Para el MVP, los usuarios de la oficina pueden utilizar el mismo hostname público y el mismo control Access. Es la ruta más simple, pero implica que tampoco podrán entrar si falla Internet o Cloudflare. Si el cliente exige continuidad local durante esas caídas, se diseñará un segundo binding HTTPS exclusivo de LAN, con certificado y reglas propias; no se añadirá por defecto.

**Aceptación**

1. Un correo autorizado supera Access y después accede solo a la carpeta permitida en SFTPGo.
2. Un correo no autorizado no recibe acceso aunque conozca la URL.
3. WebAdmin, SSH, SFTP, SMB, 3306 y 33060 no son alcanzables por el túnel.
4. El router no tiene nuevos puertos entrantes para el servicio.
5. La revocación en Access y SFTPGo bloquea el acceso en el tiempo acordado.
6. Una carga y descarga del tamaño máximo aprobado funciona desde una conexión externa.
7. La caída de Internet o Cloudflare se comunica como dependencia conocida y no daña los documentos ya almacenados.

**Reversión**

- deshabilitar la aplicación y el hostname en Cloudflare;
- revocar la credencial del túnel;
- detener `cloudflared`;
- mantener SFTPGo y los documentos sin borrarlos;
- verificar desde el exterior que el hostname ya no alcanza el origen.

### 4.3. Qontrolmed y MySQL

- Nombre estable del servidor y dirección fija mediante reserva DHCP o configuración acordada con el responsable de red.
- MySQL escuchando solo en la interfaz LAN necesaria; nunca en Internet.
- TCP/3306 permitido únicamente desde los equipos Qontrolmed autorizados o, si no es viable inventariarlos de forma estable, desde el segmento mínimo aprobado.
- TCP/33060 cerrado y X Plugin sin uso.
- TLS 1.2/1.3 obligatorio en MySQL y validado por Qontrolmed mediante CA e identidad del servidor.
- Cuenta MySQL diferenciada por equipo cuando sea operativamente viable, con los mismos privilegios mínimos sobre `gestion`, `quirofanos` y `preventivos`.
- Copias de la base y restauración probada antes de incorporar datos de producción.

Una LAN plana con router convencional puede soportar este MVP, pero no se considerará confiable por sí sola. UFW, TLS, cuentas mínimas y copias siguen siendo necesarios aunque todos los equipos estén en la misma subred.

### 4.4. Administración remota

El acceso administrativo se diseñará como ruta privada de Cloudflare y aplicación/política independiente. No compartirá el hostname documental ni publicará SSH directamente. El piloto conservará las claves SSH existentes; la evolución recomendada es Access for Infrastructure con certificados de corta duración y registro de comandos.

Codex trabajará desde la terminal del ordenador del propietario, usando una sesión autorizada y supervisada. No se creará una clave privada permanente para el agente ni se almacenarán credenciales en la bóveda. Véase `PLAN-ACCESO-ADMINISTRATIVO-REMOTO-2026-10-25.md`.

## 5. Lo necesario para producir pronto

### Bloque A. Cerrar cinco datos sin encender el servidor

1. Confirmar la subred, máscara, puerta de enlace, rango DHCP y quién administra el router.
2. Reservar una dirección estable para `srv-mm-01` sin reutilizar por defecto `192.168.2.104`.
3. Confirmar el dominio, la cuenta Cloudflare y quién recuperará/administra ambos.
4. Entregar la lista cerrada de correos autorizados en Access y de usuarios SFTPGo.
5. Definir quién puede borrar o renombrar, el tamaño máximo de archivo y el destino independiente de copia.

**Aceptación:** los cinco puntos quedan registrados sin secretos y con responsable.  
**Reversión:** no aplica; es trabajo documental.

### Bloque B. Revalidación de solo lectura al encender

Comprobar acceso SSH, huella, red real, actualizaciones, reinicio pendiente, unidades fallidas, UFW, escuchas, montajes, espacio, permisos, SMART y estado de MySQL. MySQL debe continuar detenido y 3306/33060 cerrados durante esta fase.

**Aceptación:** informe fechado de diferencias frente a la línea base.  
**Reversión:** no aplica; no se realizan cambios.

### Bloque C. Plan de cambio exacto y aprobación

Preparar comandos, archivos afectados, copias previas y reversión para:

- red estable;
- binding local de SFTPGo, separación WebClient/WebAdmin y cabeceras de proxy;
- Cloudflare Tunnel, hostname y política Access;
- ruta administrativa privada, política de dispositivo y recuperación presencial;
- estructura y permisos del repositorio;
- usuarios piloto;
- copia independiente y restauración;
- monitorización básica.

**Aceptación:** aprobación explícita del propietario antes de ejecutar.  
**Reversión:** definida por cambio, sin borrar documentos.

### Bloque D. Piloto documental local y remoto

Empezar con una cuenta administrativa y dos cuentas nominales. Probar desde la LAN y desde una conexión externa la carga, descarga, creación de carpeta, renombrado, borrado, denegación, cuota, bloqueo y registro con ficheros ficticios. Probar también un correo no autorizado y la revocación de una cuenta.

**Aceptación:** cada cuenta ve y modifica únicamente lo autorizado; la administración no queda accesible desde Internet y el túnel no publica servicios distintos del WebClient.  
**Reversión:** deshabilitar hostname y Access, revocar la credencial del túnel y usuarios piloto, y detener los servicios sin borrar documentos.

### Bloque E. Copia, restauración y producción

No declarar el repositorio como ubicación única hasta completar una copia cifrada a destino independiente y una restauración de prueba. Dar de alta a los usuarios restantes de forma escalonada y revisar a los 7 y 30 días.

**Aceptación:** copia verificada, restauración satisfactoria, responsable localizable y registro de incidencias.  
**Reversión:** suspender el acceso, conservar los documentos y recuperar desde la última copia válida si fuera necesario.

## 6. Dependencias y camino crítico

```text
Confirmar red + usuarios + copia
              |
              v
   Revalidación de solo lectura
              |
              v
     Plan de cambio aprobado
              |
              v
     Piloto SFTPGo + Cloudflare Access
              |
              v
   Copia y restauración probadas
              |
              v
     Producción documental

Qontrolmed: planificación y cambios de cliente en paralelo
              |
              v
     Piloto con un único equipo
              |
              v
   Ampliación gradual a menos de 10
```

El servicio documental no debe retrasarse por Qontrolmed. La fecha de producción no puede fijarse de forma responsable hasta disponer de los datos de red y del destino de copia.

## 7. Pendientes que bloquean ejecución

| Pendiente | Por qué bloquea | Responsable propuesto |
| --- | --- | --- |
| Red real y rango DHCP | Evita conflicto de IP y reglas UFW incorrectas | Cliente/proveedor de red |
| Dominio y cuenta Cloudflare bajo control | Sin titular y recuperación no hay continuidad | Propietario |
| Correos permitidos y método de identidad | Define quién supera el primer control | Propietario |
| Tamaño máximo de archivo | Debe ser compatible con los límites del proxy | Propietario |
| Usuarios y permisos de borrado/renombrado | Define mínimo privilegio y recuperación | Propietario |
| Destino y custodia de copias | Sin restauración no hay producción segura | Propietario/administrador |
| Equipos Qontrolmed concretos | Permite limitar 3306 y revocar accesos | Cliente |
| Nombre estable del servidor | Es necesario para verificar la identidad TLS | Administrador de red |
| Responsable de aceptación | Evita una entrada en servicio sin validación | Propietario |
| Equipo e identidad de mantenimiento | Permiten limitar y revocar SSH remoto | Propietario |
| Recuperación presencial | El túnel no funciona si servidor o red están caídos | Propietario |

## 8. Fuera de alcance del MVP

- VPN de red completa o acceso remoto a servicios distintos del WebClient.
- Publicación directa del WebClient sin Cloudflare Access.
- Nextcloud, sincronización de escritorio, WebDAV y enlaces públicos.
- SMB expuesto fuera de la LAN.
- Qontrolmed remoto, bases desconectadas o fusión de volcados.
- API o reescritura web de Qontrolmed.
- Uso de `/dev/sdb`, firmware, Secure Boot o cambios de PAM.
- Almacenamiento de datos de pacientes, historias clínicas, diagnósticos, imágenes médicas o identificadores clínicos.

## 9. Registro de decisión provisional

| Campo | Valor |
| --- | --- |
| Servicio documental | SFTPGo WebClient |
| Uso | Carga y descarga manual |
| Acceso documental remoto | Sí, Cloudflare Tunnel + Cloudflare Access |
| Sincronización tipo OneDrive | No |
| Qontrolmed | Menos de 10 equipos, todos en la LAN |
| Arquitectura Qontrolmed propuesta | MySQL LAN restringido con TLS verificado |
| Datos clínicos o de personal | Fuera de alcance declarado |
| Red definitiva | Pendiente |
| Copias y retención | Pendientes de confirmación |
| Ejecución técnica | No autorizada por este documento |

## 10. Referencias vigentes

- `PROPUESTA-REPOSITORIO-REMOTO-DOCUMENTOS-2026-10-06.md`
- `PLAN-ACCION-REPOSITORIO-REMOTO-Y-QONTROLMED-2026-10-08.md`
- `DECISION-ARQUITECTURA-CONEXION-QONTROLMED-MYSQL-2026-10-05.md`
- `PLAN-ACTUALIZACIONES-QONTROLMED-LAN-2026-10-25.md`
- `PLAN-ACCESO-ADMINISTRATIVO-REMOTO-2026-10-25.md`
- Documentación oficial de SFTPGo, WebClient: <https://docs.sftpgo.com/Enterprise/web-interfaces/>
- Documentación oficial de SFTPGo, carpetas virtuales: <https://docs.sftpgo.com/enterprise/virtual-folders/>
- MySQL 8.4, conexiones cifradas: <https://dev.mysql.com/doc/refman/8.4/en/using-encrypted-connections.html>
- Cloudflare Tunnel, aplicaciones publicadas: <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/routing-to-tunnel/>
- Cloudflare Access, aplicaciones self-hosted: <https://developers.cloudflare.com/cloudflare-one/access-controls/applications/choose-application-type/>
- Cloudflare Access, políticas: <https://developers.cloudflare.com/cloudflare-one/access-controls/policies/>
- Cloudflare, límites de carga HTTP: <https://developers.cloudflare.com/support/troubleshooting/http-status-codes/4xx-client-error/error-413/>

