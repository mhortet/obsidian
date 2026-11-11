# Decisión de arquitectura de conexión entre Qontrolmed y MySQL

Fecha de elaboración: 2026-10-05 (`Europe/Madrid`)  
Estado: propuesta para estudio; decisión y ejecución pendientes  
Ámbito: Qontrolmed en Windows y MySQL Community Server 8.4.11 en `srv-mm-01`

## 1. Objetivo del documento

Este documento compara las formas razonables de conectar Qontrolmed con el nuevo MySQL de `srv-mm-01`, explicando sus implicaciones técnicas y operativas antes de autorizar cambios.

No constituye una autorización para arrancar MySQL, abrir puertos, crear usuarios o esquemas, modificar Qontrolmed ni instalar componentes de VPN o Cloudflare.

La decisión debe equilibrar cinco objetivos:

1. reducir al mínimo la superficie de exposición de MySQL;
2. cifrar el tráfico y autenticar el servidor al que se conecta Qontrolmed;
3. mantener una disponibilidad suficiente para el trabajo diario;
4. conservar una operación comprensible, verificable y reversible;
5. permitir crecimiento futuro sin convertir una solución temporal en una dependencia difícil de mantener.

## 2. Estado seguro validado el 2026-10-05

La revalidación de solo lectura confirma:

- `srv-mm-01` ejecuta Ubuntu Server 24.04.5 LTS, kernel `6.8.0-146-generic`.
- La dirección actual `192.168.2.104/24` procede de DHCP y pertenece a la red temporal de preparación. No debe utilizarse en configuración permanente.
- SSH funciona con clave; el acceso de `root`, contraseña y teclado interactivo están deshabilitados.
- UFW está activo con entrada denegada por defecto y una única autorización TCP/22 desde la LAN temporal `192.168.2.0/24`.
- MySQL Community Server 8.4.11 está instalado y habilitado, pero permanece detenido.
- Los puertos TCP/3306 y TCP/33060 están cerrados.
- No existen reglas UFW para MySQL.
- No se han creado todavía los esquemas `gestion`, `quirofanos` y `preventivos` ni usuarios de Qontrolmed.
- El X Plugin de MySQL, asociado normalmente a 33060, no tiene una necesidad funcional identificada para Qontrolmed.

El almacenamiento ya está preparado dentro del LUKS2 de `/dev/sda`:

| Destino | Capacidad | Punto de montaje |
| --- | ---: | --- |
| MySQL | 64 GB | `/var/lib/mysql` |
| Archivos compartidos | 224 GB | `/srv/compartido` |
| Reserva libre aproximada | 85,87 GB | `ubuntu-vg` |

## 3. Lo que admite actualmente Qontrolmed

La revisión del código se realizó sin abrir ni mostrar ningún `.env` real.

Qontrolmed:

- se ejecuta en Windows;
- usa `mysql-connector-python==9.7.0`;
- abre tres conexiones independientes mediante `mysql.connector.connect()` para `gestion`, `quirofanos` y `preventivos`;
- usa el protocolo clásico MySQL y el puerto configurable `DB_PORT`, cuyo valor predeterminado es 3306;
- no usa `mysqlx` ni X DevAPI, por lo que no necesita 33060;
- permite cambiar `DB_HOST` y `DB_PORT` sin alterar la lógica funcional;
- fija `connection_timeout=5`, limitando a cinco segundos el establecimiento inicial;
- no define `read_timeout` ni `write_timeout`;
- no implementa reconexión automática ni supervisión de las tres conexiones;
- no pasa parámetros TLS como `ssl_ca`, `ssl_verify_cert` o `ssl_verify_identity`.

La biblioteca utilizada soporta TLS, validación del certificado, verificación de identidad y timeouts de lectura y escritura. Sin embargo, el código actual no los activa ni los exige. El comportamiento predeterminado puede intentar cifrado y retroceder a una conexión no cifrada; no debe considerarse suficiente para una conexión LAN de producción.

Consecuencia práctica:

- un túnel local puede funcionar con el modelo actual de `DB_HOST` y `DB_PORT`;
- una conexión LAN directa segura requiere ampliar primero la configuración de Qontrolmed para exigir y validar TLS;
- todas las alternativas se beneficiarían de timeouts completos y reconexión controlada.

## 4. Límites comunes no negociables

Independientemente de la alternativa elegida:

- no se abrirán 3306 ni 33060 directamente a Internet;
- no se crearán reglas permanentes con `192.168.2.104` ni con la red temporal actual;
- 33060 debe permanecer cerrado o el X Plugin debe quedar deshabilitado;
- no se arrancará MySQL hasta disponer de configuración validada, copia previa y ventana de prueba controlada;
- no se crearán usuarios ni esquemas hasta definir privilegios, origen, TLS y restauración;
- las credenciales, claves privadas, tokens y certificados privados no se guardarán en este repositorio;
- se mantendrá una sesión SSH de recuperación durante cambios de red, UFW o SSH;
- cada cambio deberá tener propósito, riesgo, prueba de aceptación y reversión;
- no se tocarán PAM, Secure Boot, firmware, el SSD de 1 TB ni Samba como parte de esta decisión;
- el calendario, las copias y la monitorización de MySQL se diseñarán como bloques separados.

## 5. Resumen comparativo

Escala cualitativa: `baja`, `media` o `alta`. Una complejidad alta no significa que la alternativa sea insegura; indica que exige más componentes, conocimiento y mantenimiento.

| Criterio | LAN directa con TLS | Túnel SSH persistente | VPN privada | Cloudflare Tunnel / Zero Trust |
| --- | --- | --- | --- | --- |
| Exposición de MySQL | Solo a orígenes LAN autorizados | Solo loopback; no se expone en LAN | Solo a la red privada VPN | Puede mantenerse sin puerto entrante; depende del modo elegido |
| Cifrado | TLS de MySQL obligatorio | SSH; TLS de MySQL opcional como defensa adicional | Cifrado VPN y TLS de MySQL recomendado | Cifrado del túnel; TLS o SSH interior recomendado |
| Cambios en Qontrolmed | Necesarios para validar TLS | Mínimos; host local y puerto local | Los mismos que LAN TLS | Dependen del cliente Cloudflare y del transporte interior |
| Componentes por puesto | Certificado de CA y configuración | Túnel, clave SSH y supervisor | Cliente VPN, identidad y políticas | WARP o `cloudflared`, identidad y políticas |
| Facilidad con un solo puesto | Alta tras preparar TLS | Alta en uso, media en implantación | Media | Media-baja |
| Facilidad con muchos puestos | Alta | Baja-media | Alta | Media-alta si ya existe plataforma Zero Trust |
| Dependencia de Internet | No, dentro de la LAN | No, dentro de la LAN | Depende del diseño de la VPN | Sí para el plano y transporte de Cloudflare |
| Dependencia de terceros | No necesariamente | No | Depende del producto | Alta |
| Trazabilidad por origen | Buena: IP LAN y usuario MySQL | Menor: MySQL ve conexiones desde loopback | Buena: IP o identidad VPN y usuario MySQL | Buena si se integran identidad y registros externos |
| Complejidad operativa | Media | Media-alta | Alta | Alta |
| Mejor encaje | Varios puestos en la LAN definitiva | Un puesto o piloto controlado | Sedes o usuarios remotos | Organización que adopta Zero Trust gestionado |

## 6. Alternativa A: conexión LAN directa restringida y cifrada

### Filosofía

Qontrolmed se conecta directamente al nombre estable de `srv-mm-01` en la red interna. MySQL solo acepta conexiones desde los equipos o segmento autorizados y exige TLS con verificación de identidad.

La LAN proporciona alcance; TLS proporciona confidencialidad, integridad y autenticación del servidor. No se confía únicamente en que la red interna sea segura.

### Diseño mínimo

- Dirección estable y nombre DNS interno definitivo para el servidor.
- Segmento o VLAN conocido para los puestos Qontrolmed.
- MySQL escuchando únicamente en la interfaz LAN necesaria.
- UFW permitiendo TCP/3306 solo desde equipos concretos o el segmento autorizado.
- Puerto 33060 cerrado y X Plugin sin uso.
- Certificado de servidor con un `Subject Alternative Name` que coincida con el nombre de `DB_HOST`.
- `require_secure_transport=ON` en MySQL.
- Qontrolmed configurado con `ssl_ca`, `ssl_verify_cert=True` y `ssl_verify_identity=True`.
- TLS 1.2 o 1.3; no permitir retroceso a conexión sin cifrar.
- Cuenta MySQL limitada por origen, esquemas y privilegios.
- Certificado de cliente opcional si posteriormente se decide autenticación mutua.

### Facilidades y ventajas

- Modelo fácil de entender para usuarios y soporte: aplicación, red y servidor.
- Menos procesos auxiliares en Windows.
- Buena escalabilidad para varios puestos Qontrolmed.
- Menor dependencia del orden de arranque de servicios locales.
- Mejor trazabilidad de los orígenes por dirección de red.
- No depende de Internet ni de un proveedor externo dentro de la sede.

### Implicaciones

- Requiere modificar y probar Qontrolmed antes de producción.
- Es necesario custodiar y distribuir correctamente el certificado de la CA.
- Debe existir un nombre DNS estable; usar una IP complica la verificación de identidad del certificado.
- Cada puesto nuevo obliga a revisar origen permitido, credenciales y distribución de confianza.
- Debe existir un proceso de renovación de certificados y alerta previa a su caducidad.

### Riesgos

- Un equipo comprometido dentro de la LAN autorizada puede alcanzar el puerto MySQL.
- Una regla UFW demasiado amplia aumentaría la superficie de ataque lateral.
- Un certificado caducado o un DNS incorrecto interrumpiría el servicio.
- El código actual podría retroceder a conexión no cifrada si se usara sin la ampliación TLS propuesta.
- Restringir solo por IP no sustituye cuentas independientes, privilegios mínimos ni contraseñas robustas.

### Disponibilidad

Depende de MySQL, la red LAN, DNS y la validez del certificado. Tiene menos piezas que un túnel por cliente y normalmente es la opción más estable cuando existen varios puestos fijos.

### Prueba de aceptación

1. `ss` muestra 3306 solo en la interfaz prevista y ninguna escucha en 33060.
2. UFW contiene únicamente los orígenes definitivos aprobados.
3. Un puesto autorizado conecta usando el nombre DNS previsto.
4. La sesión MySQL muestra cifrado TLS 1.2 o 1.3 y un cifrado no vacío.
5. Una CA incorrecta o un nombre que no coincida provocan fallo de conexión.
6. Un equipo no autorizado no puede alcanzar 3306.
7. Qontrolmed inicia y realiza una operación controlada de lectura y escritura en los tres esquemas.
8. Los timeouts y el comportamiento ante pérdida de red son finitos y comprensibles para el usuario.

### Reversión

1. Detener MySQL.
2. Restaurar la copia previa de la configuración MySQL.
3. Eliminar únicamente las reglas UFW añadidas para 3306.
4. Restaurar la configuración o versión anterior de Qontrolmed.
5. Validar la configuración antes de cualquier nuevo arranque.

### Cuándo elegirla

- Qontrolmed se utilizará principalmente dentro de una LAN controlada.
- Habrá varios ordenadores cliente.
- Se dispone de red definitiva, DNS interno y capacidad para gestionar certificados.
- Se busca reducir componentes auxiliares por puesto.

## 7. Alternativa B: túnel SSH persistente desde Windows

### Filosofía

MySQL permanece accesible únicamente en loopback. Windows crea un puerto local y todo el tráfico viaja dentro de una conexión SSH hasta `127.0.0.1:3306` en el servidor.

Desde el punto de vista de Qontrolmed, la base de datos sigue pareciendo local. La frontera de seguridad principal es SSH, su clave de host y una identidad dedicada al túnel.

### Diseño mínimo

- MySQL escuchando solo en loopback.
- Ninguna regla UFW para 3306.
- Puerto 33060 cerrado y X Plugin sin uso.
- Puerto local explícito en Windows; por ejemplo, 13306 para evitar colisiones con el MySQL antiguo.
- Cuenta SSH dedicada al túnel, diferente de la cuenta administrativa.
- Clave exclusiva, sin reutilizar la clave administrativa.
- Sin shell interactivo y con reenvío limitado exclusivamente a `127.0.0.1:3306`.
- Verificación estricta y fijación de la clave de host SSH.
- Servicio o tarea supervisada en Windows, con reinicio automático, registro y prueba de salud.
- Qontrolmed apuntando a `127.0.0.1` y al puerto local elegido.

### Facilidades y ventajas

- MySQL no queda expuesto ni siquiera a la LAN.
- El código actual de Qontrolmed es compatible con un destino local y un puerto configurable.
- No exige inicialmente una infraestructura de certificados MySQL.
- Es adecuado para un único ordenador o una fase piloto.
- La reversión deja MySQL cerrado en loopback y no obliga a retirar reglas UFW de base de datos.
- No depende de Internet cuando cliente y servidor están en la misma LAN.

### Implicaciones

- Windows necesita un proceso persistente adicional.
- Deben gestionarse arranque, reconexión, registros y alertas del túnel.
- Qontrolmed podría iniciarse antes de que el túnel esté disponible.
- Cada puesto requiere su propia clave, servicio y supervisión.
- MySQL ve la conexión reenviada como procedente del propio servidor. Para conservar trazabilidad con varios puestos convendría usar identidades MySQL diferenciadas por instalación.
- Aunque SSH protege el transporte, siguen siendo recomendables timeouts completos y reconexión controlada en Qontrolmed.

### Riesgos

- Una caída silenciosa del túnel puede presentarse como un fallo de base de datos.
- La clave privada del túnel debe protegerse en Windows.
- Un reenvío SSH sin restricciones podría permitir alcanzar otros servicios locales del servidor.
- La reutilización de una cuenta administrativa ampliaría innecesariamente el impacto de una clave comprometida.
- El modelo se vuelve costoso de mantener si crece el número de puestos.
- La aplicación actual no reconstruye automáticamente sus tres conexiones tras una interrupción.

### Disponibilidad

Depende de MySQL, SSH, la red, la tarea o servicio supervisor y el orden de arranque de Windows. Puede ser fiable, pero solo si se prueba el reinicio automático y se monitoriza el estado del puerto local.

### Prueba de aceptación

1. MySQL escucha únicamente en loopback y 33060 permanece cerrado.
2. Ningún equipo de la LAN puede alcanzar 3306 del servidor.
3. Solo el puerto local elegido acepta conexiones en Windows.
4. La cuenta SSH dedicada no obtiene shell ni permite otros destinos.
5. Qontrolmed trabaja con los tres esquemas a través del túnel.
6. Al interrumpir el túnel, la aplicación falla dentro de un tiempo limitado y no queda bloqueada indefinidamente.
7. El supervisor reconstruye el túnel y deja evidencia en sus registros.
8. La solución sobrevive a un reinicio de Windows y a una recarga controlada de SSH.

### Reversión

1. Detener y deshabilitar la tarea o servicio del túnel.
2. Restaurar `DB_HOST` y `DB_PORT` anteriores.
3. Retirar después la clave pública y la cuenta SSH dedicadas.
4. MySQL permanece en loopback y UFW continúa sin reglas para 3306.

### Cuándo elegirla

- Existe un único puesto Qontrolmed o una fase piloto.
- Se prioriza no exponer MySQL en la LAN.
- Se acepta administrar un servicio local y una clave por puesto.
- La indisponibilidad temporal del túnel tiene una recuperación operativa clara.

## 8. Alternativa C: red privada VPN

### Filosofía

Los equipos autorizados se incorporan a una red privada autenticada. MySQL escucha únicamente en la interfaz o dirección privada prevista y no en la red pública ni en interfaces innecesarias.

La VPN resuelve alcance remoto y segmentación. TLS de MySQL sigue siendo recomendable para autenticar el servidor y mantener una segunda capa independiente.

### Variantes conceptuales

- VPN autogestionada, por ejemplo mediante una pasarela WireGuard.
- VPN gestionada o red superpuesta con identidad de dispositivo.
- Acceso de sede a sede si existen ubicaciones separadas.

La selección de producto requiere un análisis posterior de licencias, soporte, MFA, registros, dependencia externa y recuperación.

### Facilidades y ventajas

- Adecuada para usuarios remotos, varias sedes o equipos móviles autorizados.
- MySQL puede restringir conexiones a las direcciones de la VPN.
- Permite aplicar identidad de dispositivo, revocación y políticas centralizadas.
- Escala mejor que un túnel SSH independiente por aplicación cuando hay muchos servicios o usuarios.
- Puede evitar puertos entrantes en el servidor si la arquitectura usa conexiones salientes o una pasarela dedicada.

### Implicaciones

- Añade infraestructura de red, claves de dispositivo, políticas, monitorización y soporte.
- Debe decidirse si la pasarela vive en el router, en un equipo dedicado o en `srv-mm-01`. Separarla del servidor de base de datos reduce acoplamiento y privilegios.
- Cada dispositivo debe enrolarse, actualizarse y poder revocarse.
- Hay que definir rutas para impedir que la VPN otorgue acceso innecesario a toda la LAN.
- Qontrolmed debería seguir verificando TLS; cifrar solo la VPN no autentica por sí mismo el servicio MySQL esperado.

### Riesgos

- Una política o ruta demasiado amplia puede convertir la VPN en una puerta hacia toda la red.
- Una clave de dispositivo comprometida permite acceso hasta que sea revocada.
- La caída de la pasarela afecta a todos los usuarios remotos.
- Una solución gestionada introduce dependencia de proveedor y posibles implicaciones de datos y registros.
- Ejecutar la VPN y la base de datos en el mismo servidor concentra funciones críticas.

### Disponibilidad

Puede ser alta si existe una pasarela estable y monitorizada. Para acceso dentro de la misma sede debe decidirse si el tráfico puede seguir por LAN durante una caída de Internet o del proveedor.

### Prueba de aceptación

1. Solo dispositivos enrolados obtienen dirección y ruta hacia MySQL.
2. La VPN no proporciona acceso a redes o servicios fuera del alcance aprobado.
3. 3306 no es accesible desde la LAN general ni desde Internet.
4. La revocación de un dispositivo elimina su acceso en el tiempo objetivo.
5. Qontrolmed valida TLS y opera con los tres esquemas.
6. Se comprueba el comportamiento ante caída de la pasarela y pérdida de Internet.

### Reversión

1. Revocar o deshabilitar los dispositivos y rutas añadidos.
2. Retirar las reglas limitadas a la interfaz VPN.
3. Restaurar la configuración MySQL previa y la configuración de Qontrolmed.
4. Desinstalar componentes solo después de preservar registros y confirmar que no sirven a otros sistemas.

### Cuándo elegirla

- Existen usuarios o sedes remotas.
- Se prevé acceder a más servicios internos además de MySQL.
- Hay capacidad para administrar identidad de dispositivos y segmentación.
- Se desea una arquitectura común de acceso privado, no una solución exclusiva para Qontrolmed.

## 9. Alternativa D: Cloudflare Tunnel / Zero Trust

### Filosofía

Un conector `cloudflared` establece conexiones salientes hacia Cloudflare, evitando publicar directamente la dirección del servidor. Los clientes se autentican mediante Cloudflare Access, WARP o un cliente `cloudflared`, según el modo elegido.

Para Qontrolmed existen dos enfoques conceptuales:

1. red privada Client-to-Tunnel mediante el cliente de dispositivo;
2. transportar SSH a través de Cloudflare y crear después el reenvío local de MySQL.

No se recomienda publicar MySQL como un servicio TCP de acceso general. Cloudflare indica además que los servicios TCP no HTTP requieren un componente cliente y recomienda Client-to-Tunnel para conexiones de larga duración.

### Facilidades y ventajas

- No requiere abrir puertos entrantes de MySQL o SSH en el router de Internet.
- Puede integrar identidad corporativa, MFA, políticas por dispositivo y registros centralizados.
- Simplifica el acceso a través de NAT o sedes sin IP pública estable.
- Permite revocar accesos centralmente.
- Puede reutilizar una plataforma Zero Trust si la empresa ya la utiliza y administra.

### Implicaciones

- Introduce una dependencia explícita de Cloudflare, de Internet y del proveedor de identidad.
- Requiere instalar y actualizar `cloudflared` en el lado servidor o en una pasarela.
- El cliente necesita WARP o `cloudflared`, según el diseño.
- Hay que custodiar y rotar tokens del túnel sin incorporarlos al repositorio.
- Deben revisarse contrato, ubicación de registros, conservación, soporte, protección de datos y continuidad del proveedor.
- Si Windows y Ubuntu están en la misma LAN, enviar la dependencia por un plano externo puede reducir disponibilidad sin aportar valor proporcional.

### Riesgos

- Una interrupción de Internet, Cloudflare o el proveedor de identidad puede bloquear el trabajo incluso dentro de la sede.
- Una política Zero Trust incorrecta puede conceder más acceso del previsto.
- Los tokens del conector son activos sensibles.
- El encapsulado de TCP de larga duración puede añadir latencia y modos de fallo distintos a una LAN o VPN clásica.
- La organización puede quedar vinculada a herramientas y procedimientos de un tercero.
- El tráfico y los metadatos operativos requieren una evaluación contractual y de privacidad, aunque el alcance excluya datos clínicos de pacientes.

### Disponibilidad

Depende de MySQL, `cloudflared`, Internet, Cloudflare, el proveedor de identidad y el cliente. Puede ofrecer redundancia del lado del proveedor, pero añade más puntos externos de fallo.

### Prueba de aceptación

1. No hay puertos entrantes de MySQL ni SSH publicados en Internet.
2. Solo las identidades y dispositivos aprobados establecen conexión.
3. La revocación bloquea el acceso en el tiempo objetivo.
4. Se verifica el comportamiento ante pérdida de Internet y caída del agente.
5. Los registros no contienen secretos y cumplen la política de conservación.
6. Qontrolmed opera con los tres esquemas durante una prueba prolongada.
7. El mecanismo de reconexión no genera bucles, sesiones huérfanas o bloqueos de la aplicación.

### Reversión

1. Deshabilitar la política y el túnel desde el plano de control.
2. Revocar tokens y dispositivos asociados.
3. Detener y retirar `cloudflared` tras conservar la evidencia necesaria.
4. Restaurar la configuración local anterior de Qontrolmed y MySQL.
5. Confirmar que no queda ninguna ruta o aplicación publicada.

### Cuándo elegirla

- La organización adopta conscientemente una plataforma Zero Trust gestionada.
- Se necesita acceso remoto sin puertos entrantes y existe conectividad a Internet fiable.
- Se acepta la dependencia externa y se han revisado privacidad, contrato y continuidad.
- Existe personal capaz de administrar identidades, políticas, agentes y registros.

## 10. Combinaciones razonables

Las alternativas no siempre son excluyentes:

### LAN TLS como base y VPN para acceso remoto

Es la combinación más natural cuando existen puestos locales y algún acceso remoto. MySQL mantiene TLS verificado y la VPN extiende la red privada únicamente a dispositivos autorizados.

### MySQL en loopback y SSH a través de Cloudflare

Evita publicar SSH en Internet, pero conserva la complejidad del túnel SSH y añade Cloudflare. Solo tiene sentido si hay una necesidad real de acceso remoto y se acepta la dependencia externa.

### VPN o Cloudflare sin TLS de MySQL

Puede cifrar el trayecto de red, pero deja la identidad del servicio ligada únicamente a la capa exterior. Para una implantación duradera es preferible mantener TLS de MySQL como segunda capa, especialmente si la solución crecerá o cambiará de red.

### Lo que no debe combinarse

- No abrir 3306 en Internet detrás de una simple contraseña.
- No mantener simultáneamente varias rutas de acceso sin inventario y justificación.
- No reutilizar claves administrativas para servicios automáticos.
- No depender a la vez de una IP temporal, una regla amplia y cifrado oportunista.

## 11. Decisiones filosóficas que debe tomar el propietario

Antes de elegir tecnología conviene responder:

1. ¿Qontrolmed funcionará únicamente en la sede o también desde otras ubicaciones?
2. ¿Cuántos ordenadores utilizarán Qontrolmed ahora y en los próximos doce meses?
3. ¿Debe funcionar la aplicación si la conexión a Internet de la sede falla?
4. ¿Qué indisponibilidad es aceptable y quién recuperará la conexión?
5. ¿Se prefiere gestionar certificados, claves SSH por equipo o identidades de una plataforma VPN/Zero Trust?
6. ¿Es aceptable depender de un proveedor externo para el acceso cotidiano?
7. ¿Existe o existirá una VLAN específica para servidores y puestos autorizados?
8. ¿Es necesaria trazabilidad diferenciada por puesto, usuario o dispositivo?
9. ¿Quién renovará certificados, rotará claves y revisará alertas?
10. ¿Qué solución puede mantenerse de forma realista durante vacaciones, bajas o cambios de proveedor?

## 12. Orientación de decisión

### Si hay un único puesto y se busca un piloto conservador

Elegir provisionalmente **túnel SSH persistente**, una vez exista direccionamiento estable y se haya diseñado su supervisión. Mantiene MySQL fuera de la LAN y requiere pocos cambios en Qontrolmed.

### Si habrá varios puestos dentro de una sede estable

Elegir **LAN directa con TLS verificado**, preferiblemente dentro de un segmento restringido. Es más sencilla de operar a escala que un túnel por puesto.

### Si existen sedes o usuarios remotos

Adoptar **VPN privada más TLS de MySQL** como arquitectura general, preferiblemente con la función VPN en una pasarela o componente separado del servidor de base de datos.

### Si la empresa ya usa o decide adoptar Zero Trust gestionado

Evaluar **Cloudflare Client-to-Tunnel** o SSH transportado por Cloudflare. No elegirlo únicamente para evitar decidir la red local y no publicar MySQL directamente.

## 13. Recomendación provisional para el estado actual

En el estado actual no debe implantarse todavía ninguna alternativa porque la dirección y la red son temporales.

La recomendación por fases es:

1. mantener MySQL detenido y los puertos cerrados;
2. definir la red definitiva, número de puestos, necesidad de acceso remoto y disponibilidad esperada;
3. si comienza con un único Windows, usar un túnel SSH persistente como piloto controlado;
4. incorporar en Qontrolmed timeouts completos y reconexión controlada;
5. si crece a varios puestos locales, migrar a LAN segmentada con TLS verificado;
6. si aparece acceso remoto real, añadir una VPN o plataforma Zero Trust como decisión separada y documentada.

Esta recomendación favorece la menor exposición durante la fase de aprendizaje sin imponer para siempre una arquitectura de túneles por puesto.

## 14. Controles previos a cualquier implantación

Antes de solicitar autorización de ejecución deberán estar definidos:

- red y dirección definitivas;
- nombre DNS estable;
- número de puestos y ubicaciones;
- responsable operativo y procedimiento de recuperación;
- objetivo de disponibilidad;
- alternativa elegida y motivo;
- cambios exactos en Qontrolmed;
- diseño de usuarios y privilegios MySQL;
- ubicación y custodia de certificados, claves o tokens;
- copia de la configuración previa;
- prueba de aceptación completa;
- procedimiento de reversión;
- registro de evidencias y fecha de revisión.

## 15. Fuentes técnicas

Consultadas el 2026-10-05:

- MySQL Connector/Python, argumentos de conexión: <https://dev.mysql.com/doc/connector-python/en/connector-python-connectargs.html>
- MySQL 8.4, configuración de conexiones cifradas: <https://dev.mysql.com/doc/refman/8.4/en/using-encrypted-connections.html>
- MySQL 8.4, protocolos de transporte: <https://dev.mysql.com/doc/refman/8.4/en/transport-protocols.html>
- Cloudflare Tunnel, enrutamiento de protocolos TCP y SSH: <https://developers.cloudflare.com/tunnel/concepts/routing/>
- Cloudflare Tunnel para redes privadas: <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/>

## 16. Registro de decisión

| Campo | Valor |
| --- | --- |
| Alternativa elegida | Pendiente |
| Motivo principal | Pendiente |
| Dependencia externa aceptada | Pendiente |
| Número de puestos previsto | Pendiente |
| Acceso remoto necesario | Pendiente |
| Disponibilidad objetivo | Pendiente |
| Responsable de validación | Pendiente |
| Fecha de aprobación | Pendiente |
| Fecha de próxima revisión | Pendiente |

Hasta completar este registro y aprobar un plan de cambio concreto, MySQL debe permanecer detenido y sin puertos de red abiertos.
