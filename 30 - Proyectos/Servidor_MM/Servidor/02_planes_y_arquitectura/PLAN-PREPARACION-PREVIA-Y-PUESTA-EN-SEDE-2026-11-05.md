---
title: "Preparación previa y puesta en sede de srv-mm-01"
type: plan
status: proposed
created: 2026-11-05
updated: 2026-11-05
sources:
  - "PLAN-ACCESO-ADMINISTRATIVO-REMOTO-2026-10-25.md"
  - "REVISION-DOCUMENTAL-Y-RUTA-MVP-2026-10-25.md"
  - "../01_gobierno_y_decisiones/DECISION-PREPARAR-TODO-ANTES-TRASLADO-2026-11-05.md"
tags: [arquitectura, seguridad, administracion]
review_after: 2026-11-12
---

# Plan propuesto: preparar en casa y dejar la sede administrable

## 1. Decisión recomendada

Preparar, ensayar y documentar en la red doméstica todo lo que no dependa de la topología real de la sede. El día del traslado debe limitarse a identificar la red, obtener una dirección estable, aplicar el perfil de sede ya preparado y ejecutar pruebas de aceptación desde dentro y desde fuera.

La primera puesta en servicio incluirá únicamente:

1. repositorio documental SFTPGo WebClient;
2. Cloudflare Tunnel + Access para usuarios documentales;
3. canal administrativo privado hacia SSH desde el ordenador del propietario;
4. copia independiente, monitorización y recuperación.

MySQL/Qontrolmed permanecerá `inactive/disabled` y sin 3306/33060 durante esta primera entrega. Su paso a la LAN del cliente será una fase posterior, después de resolver el empaquetado de CA, puestos autorizados y revisión visual.

Este documento es una propuesta y no autoriza todavía cambios técnicos o externos.

## 2. Arquitectura objetivo

### 2.1. Documentos

```text
Navegador autorizado
  -> Cloudflare Access: identidad, MFA y política
  -> túnel documental independiente
  -> 127.0.0.1:<puerto WebClient>
  -> cuenta nominal SFTPGo + TOTP
  -> /srv/compartido/repositorio/compartido/empresa
```

- Hostname dedicado, por ejemplo `documentos.<dominio>`.
- Política Access creada y probada antes de habilitar el hostname.
- Activar en Cloudflare la protección obligatoria para bloquear hostnames sin aplicación Access cuando sea compatible con el resto de la zona.
- WebClient en un binding exclusivo de loopback.
- WebAdmin y API administrativa en otro binding, sin hostname público.
- No publicar SFTP, WebDAV, SMB, SSH, MySQL ni otros puertos por el túnel documental.
- Cuenta piloto nominal, cuota pequeña, TOTP obligatorio y una carpeta general. En la primera etapa se deshabilitan enlaces públicos y se decide expresamente si los usuarios pueden borrar o solo subir, descargar y crear carpetas.
- Desactivar caché de contenido y configurar correctamente cabeceras/proxy y carga fragmentada si el límite HTTP lo exige.

SFTPGo ofrece WebClient, carga/descarga, gestión de carpetas y TOTP. Cloudflare Access es una primera barrera; SFTPGo conserva autenticación y permisos propios.

### 2.2. Administración

```text
Ordenador del propietario
  -> Cloudflare One Client, dispositivo enrolado
  -> política Access solo para identidad y dispositivo autorizados
  -> ruta privada /32 y puerto 22
  -> túnel administrativo independiente
  -> sshd: cuenta nominal + clave/certificado
  -> sudo interactivo para administración completa
```

- No abrir TCP/22 en el router.
- No enrutar toda la LAN; anunciar únicamente el host administrativo `/32` y permitir solo el puerto 22 en la aplicación/política.
- Enrolar solo el ordenador de mantenimiento y exigir identidad, MFA y postura del dispositivo cuando sea viable.
- Mantener root y contraseña SSH deshabilitados.
- Primera etapa rápida y reversible: ruta privada con Cloudflare One Client y la clave SSH actual, que sigue actuando como autenticación final.
- Objetivo antes o inmediatamente después de estabilizar la sede: Access for Infrastructure, certificados SSH de corta duración y registros de comandos cifrados. Actualmente admite `ssh`, `scp`, `sftp` y `rsync`, pero no port forwarding, `ProxyJump`, agent forwarding ni X11.
- Sesiones administrativas con duración limitada; diseñar una ventana máxima de ocho horas aunque la plataforma permita valores mayores.

Cloudflare controla quién y qué dispositivo alcanza SSH. Linux sigue controlando los privilegios. “Plenos poderes” se obtiene mediante `sudo` interactivo, no mediante login de root ni sudo global sin contraseña.

### 2.3. Separación

Preferir dos túneles/credenciales y dos unidades de servicio: documental y administrativa. Así se puede revocar o detener el acceso administrativo sin interrumpir documentos, y viceversa. Si se opta por un único conector por simplicidad, deberán mantenerse aplicaciones, rutas, políticas y rollback separados; esta alternativa requiere justificar la pérdida de aislamiento operativo.

## 3. Riesgo de red solapada

La única información de sede es `192.168.0.0/24`. Es un rango muy habitual en viviendas y hoteles. Cloudflare permite redes virtuales para aislar rutas solapadas dentro de la organización, pero su documentación advierte que una red local del usuario con el mismo rango puede impedir alcanzar la aplicación.

Antes del traslado:

1. simular la sede en una red `192.168.0.0/24`;
2. anunciar solo la IP final `/32`, no el `/24` completo;
3. probar desde el ordenador de mantenimiento conectado a una segunda red que también use `192.168.0.0/24`;
4. si hay conflicto, elegir una solución auditada: cambiar la red de uno de los extremos, usar un nombre/IP administrativo no solapado probado o diseñar una red virtual/overlay específica. No improvisar el día del traslado.

## 4. Condición crítica: arranque y energía

`cloudflared`, SFTPGo y SSH no existen hasta que Ubuntu y el volumen cifrado han arrancado. Deben probarse un apagado completo y una pérdida simulada de alimentación.

Antes de dejar el servidor:

- confirmar cómo se desbloquea LUKS2 tras un arranque en frío;
- comprobar BIOS `Restore on AC Power Loss` y documentar su valor;
- disponer de SAI/UPS con autonomía, señal USB y apagado controlado;
- decidir quién puede efectuar recuperación local o instalar una consola remota/KVM segura;
- conservar la recuperación LUKS fuera del servidor y nunca en el repositorio;
- no habilitar desbloqueo automático TPM, clave en claro o SSH de initramfs sin auditoría y plan específico.

Sin persona local, consola remota o desbloqueo remoto probado, no puede garantizarse que no sea necesaria una visita tras un corte prolongado.

## 5. Copias y continuidad

No admitir documentos reales como copia única. Antes de producción:

1. copia diaria cifrada a un destino independiente;
2. copia externa/off-site con retención definida;
3. restauración de una selección y restauración completa del repositorio/configuración;
4. copia de configuración de SFTPGo, usuarios, claves públicas y metadatos, sin registrar secretos en la bóveda;
5. alertas de fallo, espacio y antigüedad de la última copia.

El SSD de 1 TB actual no se reutilizará sin inventario y autorización destructiva específica. Una copia en el mismo servidor no satisface el requisito independiente. Si se quiere evitar manipulación mensual en sede, se debe elegir un destino remoto cifrado y automatizable; el proveedor, coste, custodia de claves y residencia de datos quedan por decidir.

RPO inicial recomendado: 24 horas. RTO aceptado provisionalmente: un día. Deben confirmarse con el cliente.

## 6. Fases

### Fase 0. Preparación desacoplada mientras faltan datos del cliente

Esta fase puede comenzar sin respuesta del cliente y no altera los criterios de producción:

- revalidación de solo lectura del servidor y del puesto administrador;
- cierre del diseño de directorios, cuentas de servicio, bindings, permisos, cuotas, logs y salud;
- configuraciones y scripts parametrizados, idempotentes y con reversión, todavía sin secretos ni recursos externos;
- SFTPGo local con usuarios y documentos ficticios, si el bloque técnico recibe aprobación;
- validación de instalación y configuración de `cloudflared` sin túnel persistente, token, hostname o política real;
- pruebas de copia/restauración con destino de ensayo, sin declararlas copia independiente ni 3-2-1;
- preparación de la simulación de red y del checklist de traslado, sin aplicar un perfil definitivo.

Los valores desconocidos se mantienen como parámetros explícitos; no se inventan. El runbook operativo es `../03_operacion_y_runbooks/INICIAR-PREPARACION-SIN-DATOS-CLIENTE-2026-11-06.md`.

### Fase A. Decisiones y cuentas, sin servidor

- Titular, MFA y recuperación de la cuenta Cloudflare.
- Dominio/hostname y control DNS.
- Identidad administrativa y lista cerrada de usuarios documentales.
- Destino de copias y custodia de cifrado.
- Permisos de borrar/renombrar, cuota y tamaño máximo.
- Responsable de recuperación en sede.
- Protección del ordenador administrador: actualizaciones, cifrado, bloqueo, cuenta separada y recuperación.

### Fase B. Ensayo doméstico completo

- Auditoría previa y plan de cambio aprobado.
- Instalar/configurar SFTPGo y dos bindings separados.
- Crear estructura y permisos con datos ficticios.
- Instalar/configurar `cloudflared` con credenciales fuera del repositorio.
- Crear primero las aplicaciones/políticas Access y después las rutas/hostnames.
- Enrolar el ordenador del propietario y validar el canal SSH.
- Configurar copia independiente y monitorización.
- Probar subida, descarga, creación de carpetas, permisos, cuota, MFA, revocación y registros.
- Probar denegación de identidad/dispositivo no autorizado.
- Reinicio y apagado completo con recuperación.
- Probar desde hotspot o red externa y desde una red con rango solapado.

### Fase C. Simulación de sede

- Montar una LAN temporal `192.168.0.0/24`.
- Probar perfil DHCP inicial, reserva, DNS/gateway y perfil definitivo sin usar datos reales.
- Comprobar que el cambio de red no rompe el túnel saliente.
- Preparar scripts idempotentes de aplicación y reversión, inventario de archivos afectados y hashes.
- Imprimir/guardar localmente el checklist de traslado y recuperación sin secretos.

### Fase D. Traslado

1. inventario fotográfico y conexión física;
2. arrancar inicialmente por DHCP y descubrir la red real sin asumir datos;
3. comprobar conflicto y obtener una reserva estable para la MAC `74:fe:48:67:be:cc`;
4. aplicar el perfil de sede solo después de validar gateway, DNS y reserva;
5. mantener MySQL detenido;
6. validar túneles y servicios desde la LAN;
7. validar desde el ordenador del propietario usando una red externa;
8. reiniciar y repetir las pruebas de administración y documentos;
9. probar denegaciones y comprobar que el router no publica 22, 8080, 3306, 33060 ni 445;
10. abandonar la sede solo cuando administración, documentos, copia, alertas y recuperación cumplan aceptación.

### Fase E. Entrada gradual

- Primer usuario y documentos no sensibles.
- Revisión a las 24 horas, 7 días y 30 días.
- Alta escalonada hasta el máximo inicial de diez usuarios.
- Qontrolmed se planifica después como línea separada.

## 7. Criterios de no traslado/no abandono de sede

No considerar el servidor listo si falta cualquiera de estos puntos:

- red final/reserva DHCP y acceso al router no confirmados;
- cuenta Cloudflare/dominio sin titular, MFA o recuperación;
- acceso SSH remoto no probado desde una red externa y dispositivo autorizado;
- identidad/dispositivo no autorizado no rechazados;
- arranque en frío LUKS no recuperable por una persona o consola disponible;
- copia independiente o restauración no probadas;
- SFTPGo WebAdmin o puertos administrativos expuestos;
- monitorización sin destinatario o alertas no probadas;
- ausencia de rollback de red, Cloudflare, SFTPGo o SSH.

## 8. Reversión

- Deshabilitar aplicaciones/rutas Access y revocar el dispositivo.
- Detener únicamente el túnel afectado.
- Mantener datos y configuración; no borrar documentos durante la reversión.
- Restaurar bindings y archivos desde copias fechadas.
- Restaurar perfil de red previo desde consola local.
- Conservar clave SSH LAN validada hasta aceptar Access for Infrastructure.
- Si falla una prueba de arranque o copia, no trasladar o no introducir datos reales.

## 9. Información necesaria para completar producción

Estos datos no impiden comenzar la Fase 0 ni preparar un bloque doméstico aprobable. Sí son necesarios antes de crear la configuración final, declarar recuperación/copia operativas o trasladar el servidor:

1. Dominio que se usará y quién controla su cuenta Cloudflare.
2. Correo/identidad administrativa y método MFA/recuperación.
3. Destino independiente de copia y responsable de sus claves.
4. Persona local o solución de consola remota para LUKS y energía.
5. Permiso de borrado/renombrado para usuarios y cuota inicial.
6. Datos reales de red de sede o disponibilidad de acceso al router el día del traslado.
7. Decisión sobre dos túneles separados, recomendada, o uno único.

El correo de solicitud de información quedó programado para el 2026-11-06 a las 08:00. Si la respuesta llega de forma parcial, se incorporará por bloques y se mantendrán parametrizados los datos restantes. Una llamada puede servir para recopilar decisiones, pero las que afecten a acceso, DNS, red, copias o recuperación deben registrarse y verificarse antes de ejecutar cambios dependientes.

## 10. Fuentes oficiales verificadas el 2026-11-05

- Cloudflare Tunnel y redes privadas: <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/private-net/>
- Cloudflare Access for Infrastructure: <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/ssh-infrastructure-access/>
- Aplicaciones de infraestructura: <https://developers.cloudflare.com/cloudflare-one/access-controls/applications/non-http/infrastructure-apps/>
- Aplicaciones privadas por IP/puerto: <https://developers.cloudflare.com/cloudflare-one/access-controls/applications/non-http/self-hosted-private-app/>
- Redes virtuales y solapamiento: <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/private-net/cloudflared/tunnel-virtual-networks/>
- Protección Access obligatoria: <https://developers.cloudflare.com/cloudflare-one/access-controls/access-settings/require-access-protection/>
- Enrolamiento de dispositivos: <https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/cloudflare-one-client/deployment/device-enrollment/>
- SFTPGo WebClient y proxy/carga fragmentada: <https://docs.sftpgo.com/Enterprise/web-interfaces/>
- SFTPGo 2FA: <https://docs.sftpgo.com/enterprise/tutorials/two-factor-authentication/>
