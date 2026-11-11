# Plan de acceso administrativo remoto a `srv-mm-01`

Fecha: 2026-10-25 (`Europe/Madrid`)  
Estado: **planificación; no autoriza cambios de SSH, Cloudflare, UFW ni cuentas**  
Objetivo: permitir mantenimiento remoto seguro desde el ordenador del propietario y trabajo supervisado con Codex

## 1. Decisión recomendada

Crear un plano administrativo separado del acceso documental:

- **Documentos:** hostname público de Cloudflare Tunnel protegido por Access y dirigido únicamente al WebClient de SFTPGo.
- **Administración:** ruta privada de Cloudflare hacia SSH, accesible solo desde el ordenador de mantenimiento enrolado en Cloudflare One Client.
- **Qontrolmed:** conexión directa por la LAN local con TLS; no circulará por ninguno de los accesos remotos anteriores.

No se abrirá TCP/22 en el router ni se publicará SSH directamente en Internet. El acceso SSH seguirá siendo por clave o certificado; root y contraseña permanecerán deshabilitados.

## 2. Arquitectura

```text
Ordenador del propietario
  - Cloudflare One Client
  - cliente OpenSSH
  - ssh-agent local
  - Codex Desktop y terminal local
              |
              v
Cloudflare Zero Trust
  - identidad del propietario
  - dispositivo enrolado
  - política limitada a srv-mm-01:22
              |
              v
Cloudflare Tunnel, conexión saliente
              |
              v
sshd de srv-mm-01
  - usuario nominal
  - clave/certificado
  - sudo controlado
```

El canal permite administrar el servidor desde el mismo terminal que ya se utiliza en Windows. Codex puede solicitar y ejecutar comandos a través del entorno local autorizado, pero las credenciales permanecen bajo control del propietario.

## 3. Dos etapas posibles

### Etapa A. Piloto simple con claves SSH existentes

- Instalar y enrolar Cloudflare One Client únicamente en el ordenador de mantenimiento.
- Crear una ruta privada hacia la dirección final de `srv-mm-01`.
- Enrutar exclusivamente el host o prefijo mínimo necesario, no toda la LAN.
- Aplicar una política que exija la identidad del propietario y el dispositivo enrolado.
- Conservar la clave SSH existente en el equipo Windows y cargarla en `ssh-agent` solo durante el mantenimiento.
- Mantener `sshd` con autenticación por clave, root y contraseña deshabilitados.

Es la vía más rápida porque conserva el modelo SSH ya validado. Cloudflare controla el alcance de red y SSH mantiene la autenticación final.

### Etapa B. Objetivo con Access for Infrastructure

Evolucionar, si el piloto es estable, a Cloudflare Access for Infrastructure:

- certificados SSH de corta duración ligados a la identidad;
- políticas por servidor, puerto y nombre de usuario;
- registro de autenticaciones y comandos;
- revocación central sin depender de una clave SSH de larga duración.

Es la opción preferente a medio plazo para trazabilidad, pero modifica la confianza de `sshd` y requiere una implantación más cuidadosa. No debe introducirse a la vez que el primer despliegue documental si retrasa innecesariamente la entrada en producción.

## 4. Cómo podría trabajar Codex

### Modalidad recomendada: sesión supervisada desde tu ordenador

1. El propietario activa Cloudflare One Client.
2. Autentica su identidad cuando corresponda.
3. Inicia `ssh-agent` y carga su clave en PowerShell visible, sin copiar la frase secreta al chat.
4. Se prueba una conexión SSH nueva.
5. Codex utiliza la terminal local autorizada para comprobaciones o cambios previamente aprobados.
6. El propietario introduce cualquier contraseña de `sudo` únicamente en su consola visible.
7. Al terminar, se retira la identidad del agente SSH y se cierra la sesión.

Codex no necesita ni debe recibir:

- una clave privada propia permanente;
- la frase secreta de la clave;
- un usuario root;
- una contraseña almacenada en el proyecto;
- un token Cloudflare en el chat;
- una regla de `sudo` global sin contraseña.

La documentación oficial de OpenAI describe que las órdenes de shell local se ejecutan en un entorno proporcionado y controlado por el usuario. Este modelo permite aplicar sandbox, aprobaciones y registro; no equivale a conceder a OpenAI una sesión SSH autónoma permanente.

### Modalidad futura: automatización no supervisada

Solo si aparece una necesidad real de tareas programadas o atención desatendida se valorará un entorno autoalojado y aislado. Debería ejecutarse en un equipo o VM de gestión, con:

- cuenta técnica distinta;
- credencial SSH propia, revocable y limitada;
- `sudoers` reducido a comandos concretos;
- registro de órdenes y resultados;
- clave del entorno separada de otras credenciales;
- ventana temporal y procedimiento de parada.

Esta modalidad no forma parte del MVP y no debe instalarse directamente en el servidor de producción sin una decisión específica.

## 5. Privilegios

- Usar una cuenta administrativa nominal; no permitir login de root.
- Conservar autenticación SSH por clave o certificado.
- Mantener `sudo` interactivo para acciones generales.
- Si se automatizan comprobaciones repetitivas, valorar reglas `sudoers` explícitas y de solo lectura para comandos concretos, nunca `NOPASSWD: ALL`.
- Separar las cuentas de administración de las cuentas SFTPGo y MySQL.
- No reutilizar tokens o identidades del túnel documental como credenciales de usuario del sistema.

## 6. Límites de seguridad

- La ruta administrativa no debe conceder acceso a toda la LAN.
- Solo se enrolará el ordenador autorizado; la pérdida del equipo debe permitir revocación inmediata.
- El servicio documental y el acceso SSH tendrán aplicaciones y políticas diferentes.
- La interfaz WebAdmin de SFTPGo no se publicará dentro del hostname de usuarios.
- MySQL 3306/33060 no se anunciará por Cloudflare.
- La clave privada permanecerá en el ordenador del propietario y fuera del repositorio.
- Los tokens de túnel se custodiarán como secretos de servicio y se podrán rotar.
- No se confiará únicamente en Cloudflare: SSH conservará su propia autenticación y endurecimiento.

## 7. Disponibilidad y recuperación

El acceso remoto dejará de funcionar si falla cualquiera de estos componentes:

- el servidor o su red;
- la conexión a Internet de la sede;
- `cloudflared`;
- Cloudflare o la identidad configurada;
- Cloudflare One Client en el ordenador de mantenimiento;
- la cuenta o certificado SSH.

Por tanto, este mecanismo no sustituye una consola física. Antes de cualquier cambio de SSH, red o Cloudflare debe existir acceso presencial o una persona capaz de recuperar el servidor localmente.

Durante cambios de acceso:

1. conservar la sesión SSH actual;
2. validar `sshd -t` antes de recargar;
3. probar una conexión nueva por la ruta prevista;
4. comprobar una denegación desde un dispositivo no autorizado;
5. cerrar la sesión de recuperación solo después de aceptar la nueva conexión;
6. conservar un rollback fechado.

## 8. Pruebas de aceptación

1. No hay TCP/22 abierto en el router ni accesible desde Internet.
2. El ordenador autorizado y enrolado alcanza únicamente `srv-mm-01:22`.
3. Un ordenador o identidad no autorizados no alcanzan SSH.
4. SSH rechaza root, contraseña y teclado interactivo; acepta únicamente la identidad prevista.
5. La revocación del dispositivo o usuario corta nuevas conexiones.
6. Codex puede ejecutar una comprobación de solo lectura desde la terminal local sin recibir secretos.
7. `sudo` solicita interacción humana para acciones privilegiadas no preautorizadas.
8. Los accesos y comandos quedan registrados con fecha e identidad según la solución elegida.
9. La caída del túnel no expone automáticamente SSH por otra ruta.
10. Existe recuperación presencial documentada.

## 9. Reversión

- Revocar el dispositivo y la política administrativa de Cloudflare.
- Retirar únicamente la ruta privada creada para SSH.
- Detener la función administrativa de `cloudflared` sin afectar al túnel documental, si se han separado correctamente.
- Restaurar la configuración previa de `sshd` desde la copia fechada.
- Conservar la clave pública anterior hasta verificar la recuperación.
- Confirmar que SSH sigue disponible desde la LAN autorizada o la consola física.

No se borrarán claves, cuentas o registros hasta comprobar que no pertenecen a otro flujo y que existe recuperación.

## 10. Información pendiente

- Cuenta Cloudflare y propietario responsable.
- Identidad o correo que administrará el servidor.
- Ordenador concreto que se enrolará y su nivel de protección.
- Red final y dirección estable de `srv-mm-01`.
- Elección entre piloto con clave actual o Access for Infrastructure desde el inicio.
- Necesidad real de transferencia `scp`/`sftp` administrativa.
- Retención de registros y responsable de revisarlos.
- Persona con capacidad de recuperación presencial.

## 11. Fuentes

- Cloudflare, alternativas para SSH: <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/>
- Cloudflare, claves SSH autogestionadas: <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/ssh-device-client/>
- Cloudflare, Access for Infrastructure: <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/ssh-infrastructure-access/>
- OpenAI, ejecución mediante shell local controlado por el usuario: <https://developers.openai.com/api/docs/guides/tools-shell>

