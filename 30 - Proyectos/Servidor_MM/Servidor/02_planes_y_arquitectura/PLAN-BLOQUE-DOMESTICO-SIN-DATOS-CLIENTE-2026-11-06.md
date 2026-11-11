---
title: "Bloque doméstico SFTPGo, cloudflared y copia sin datos del cliente"
type: plan
status: active
created: 2026-11-06
updated: 2026-11-06
sources:
  - "../03_operacion_y_runbooks/INICIAR-PREPARACION-SIN-DATOS-CLIENTE-2026-11-06.md"
  - "PLAN-PREPARACION-PREVIA-Y-PUESTA-EN-SEDE-2026-11-05.md"
tags: [arquitectura, seguridad, administracion, testing]
review_after: 2026-11-13
---

# Plan propuesto: bloque doméstico sin datos del cliente

## 1. Decisión solicitada

Autorizar como un único bloque la preparación y el ensayo doméstico descritos en este documento. La aprobación cubrirá la preparación de scripts, la instalación acotada, las pruebas, la documentación y la reversión previstas. No cubrirá recursos Cloudflare reales, DNS, red de sede, datos o usuarios reales, LUKS, discos, cambios de SSH/UFW ni producción.

La ejecución privilegiada se hará con `sudo` interactivo introducido por el propietario en su consola. No se compartirán contraseñas, TOTP, tokens, claves ni archivos de credenciales por el chat o el repositorio.

Plan aprobado expresamente por el propietario el 2026-11-06 como un único bloque. La aprobación cubre preparación de artefactos, instalación acotada, pruebas, documentación y reversión dentro de los límites descritos. No cubre ninguna de las exclusiones del apartado 8.

Durante la prueba autenticada se detectó que `/srv/compartido` mantenía correctamente `root:root 0750`, pero ese modo también impedía a `sftpgo` atravesar el punto de montaje. El propietario aprobó expresamente el 2026-11-06 un bloque correctivo adicional: instalar únicamente `acl` desde Ubuntu oficial, aplicar `u:sftpgo:--x` al punto de montaje, conservar propietario y modo, verificar que la cuenta puede atravesarlo pero no listarlo, incorporar el control a aceptación y retirar la ACL en la reversión. La simulación previa mostró `0` actualizados, `1` nuevo, `0` eliminados y `29` no actualizados.

## 2. Propósito y resultado esperado

Dejar demostrado, con datos exclusivamente ficticios, que `srv-mm-01` puede alojar un portal documental SFTPGo aislado, que la futura configuración de `cloudflared` puede prepararse sin crear túneles y que los datos/configuración del ensayo pueden copiarse y restaurarse con una herramienta independiente del proveedor final.

Al cerrar el bloque:

- SFTPGo estará instalado y probado, pero detenido y deshabilitado;
- `cloudflared` estará instalado y validado solo contra una configuración `.invalid`, sin token, túnel, hostname, ruta privada ni servicio activo;
- `restic` habrá realizado una copia/restauración local de datos ficticios; se declarará expresamente que no es 3-2-1 ni copia externa;
- MySQL seguirá `inactive/disabled`, sin proceso ni 3306/33060;
- no habrá nuevos puertos no loopback ni reglas UFW nuevas;
- los artefactos, versiones, pruebas y reversión quedarán documentados sin secretos.

## 3. Línea base revalidada el 2026-11-06

Auditoría remota de solo lectura desde `192.168.1.107` hacia la dirección doméstica `192.168.1.31`, con identidad de host estricta:

| Elemento | Resultado |
| --- | --- |
| Host y sistema | `srv-mm-01`, Ubuntu 24.04.5 LTS documentado, kernel `6.8.0-147-generic` |
| Reinicio / salud | Sin reinicio pendiente y sin unidades fallidas |
| MySQL | `inactive/disabled`, sin proceso ni 3306/33060 |
| SSH | Servicio activo; `ssh.socket` activo/habilitado; escucha 22 en IPv4/IPv6 |
| UFW | Servicio activo/habilitado; reglas detalladas requieren lectura privilegiada al inicio del bloque |
| Otras escuchas | Solo resolved/DHCP esperados; ningún servicio documental instalado |
| Almacenamiento | `/` 98 GiB, 82 GiB disponibles; `/srv/compartido` 220 GiB, 218 GiB disponibles |
| Montaje compartido | `/srv/compartido` en ext4 con `rw,nosuid,nodev,noexec`; propietario `root:root`, modo `0750` |
| Configuración piloto MySQL | SHA-256 `4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927` |
| Paquetes nuevos | SFTPGo, `cloudflared` y `restic` no instalados; ruta `/srv/compartido/repositorio` ausente |
| Errores del día | Sin entradas de prioridad `err` visibles para la cuenta administrativa |

La aparente combinación `ssh.service disabled` y SSH activo es coherente con la activación por `ssh.socket`; no se cambiará en este bloque.

## 4. Alcance autorizado si se aprueba

### 4.1. Preflight y salvaguardas

1. Repetir estado de MySQL, SSH, UFW, unidades fallidas, puertos, montajes y espacio.
2. Obtener con `sudo` el estado numerado de UFW y hashes de los archivos que puedan afectarse.
3. Inventariar paquetes, repositorios APT, unidades y rutas antes de crear nada.
4. Preparar scripts idempotentes separados de preflight, aplicación, aceptación y reversión; comprobar sintaxis y revisar su contenido antes de ejecutarlos.
5. Simular con APT las instalaciones. Abortar si se proponen retiradas, downgrades o cambios no necesarios en kernel, OpenSSH, MySQL, red o firewall.
6. Enmascarar temporalmente las nuevas unidades durante la instalación para impedir que un valor por defecto abra escuchas antes de aplicar la configuración segura.

### 4.2. Paquetes y procedencia

- SFTPGo Community desde el repositorio APT oficial `https://oss.sftpgo.com/apt`, con keyring dedicado y `signed-by`. Versión mínima aceptable para este ensayo: `2.7.6`, que incorpora correcciones de seguridad relevantes.
- `cloudflared` estable desde `https://pkg.cloudflare.com/cloudflared`, con keyring dedicado y `signed-by`. Se registrará la versión candidata y deberá estar dentro de la ventana de soporte de un año indicada por Cloudflare.
- `restic` desde Ubuntu 24.04 `noble-updates/security`; candidato observado antes de añadir repositorios: `0.16.4-2ubuntu0.24.04.3`.
- `acl` desde Ubuntu 24.04 `noble-updates/main`; se añade solo tras el fallo de tránsito observado y la aprobación correctiva, sin dependencias o cambios adicionales en la simulación.
- No se usará `curl | sh`, binarios nocturnos, contenedores `latest`, paquetes Enterprise ni descargas sin verificación del gestor APT.

Se conservarán en evidencia las fuentes APT, hashes de keyrings, versiones candidatas, simulación y resultado de instalación. No se registrarán tokens o secretos.

### 4.3. SFTPGo local y aislado

Arquitectura del ensayo:

```text
Navegador del propietario
  -> túnel local SSH desde este PC
  -> 127.0.0.1:18080  WebClient ficticio
  -> 127.0.0.1:18081  WebAdmin ficticio
  -> /srv/compartido/repositorio/piloto-20261106
```

Parámetros obligatorios:

- edición Community; proveedor de configuración SQLite propio de SFTPGo, sin usar MySQL;
- proceso bajo la cuenta no privilegiada `sftpgo` creada por el paquete;
- SFTP, SCP, FTP, FTPS y WebDAV deshabilitados; no se escuchará en 2022, 21, 990 ni puertos WebDAV;
- dos bindings HTTP separados y exclusivamente `127.0.0.1`:
  - `18080`: WebClient sí, WebAdmin no, REST API no, enlace a administración oculto;
  - `18081`: WebAdmin sí, WebClient no, REST administrativa solo en loopback, enlace a cliente oculto;
- OpenAPI no renderizado en el binding de usuarios;
- ningún certificado de piloto MySQL reutilizado;
- ninguna interfaz directamente accesible desde la LAN o Internet;
- `/srv/compartido/repositorio` bajo control de `root`; solo la hoja `piloto-20261106` será escribible por `sftpgo`;
- `/srv/compartido` conservará `root:root 0750` y añadirá exclusivamente la ACL nominal `u:sftpgo:--x`; esta ACL permite llegar a la ruta conocida pero no listar, leer ni escribir la raíz del montaje;
- datos ficticios, cuota piloto de 250 MiB, archivos de prueba de hasta 50 MiB y nombres inequívocamente sintéticos;
- una cuenta administradora y una cuenta documental ficticias; contraseñas y TOTP se introducirán localmente y no se exportarán;
- la cuenta documental usará únicamente HTTP, TOTP obligatorio y permisos `list`, `download`, `upload`, `overwrite` y `create_dirs`; no tendrá `delete`, `rename`, `copy`, `chmod`, `chown`, enlaces simbólicos ni comparticiones públicas;
- el ensayo de denegaciones comprobará borrado, renombrado, cuota, credencial incorrecta, ausencia de TOTP y cuenta revocada;
- el montaje `noexec,nosuid,nodev` se conservará sin cambios.

Se aplicará un drop-in de `systemd` solo después de inspeccionar la unidad real del paquete. Como mínimo limitará privilegios y escritura a las rutas necesarias sin impedir SQLite, logs o el repositorio. `systemd-analyze verify`, arranque controlado y registros decidirán si cada directiva es compatible; no se copiará un perfil genérico a ciegas.

### 4.4. Plantilla `cloudflared` sin recursos externos

- Instalar el paquete, pero mantener `cloudflared.service` enmascarado o detenido/deshabilitado.
- Generar únicamente una plantilla sin secretos con:
  - UUID reservado `00000000-0000-0000-0000-000000000000`;
  - hostname reservado `documentos.invalid`;
  - origen `http://127.0.0.1:18080`;
  - regla final obligatoria `http_status:404`;
  - ruta de credencial ficticia que no se creará.
- Ejecutar solo la validación de ingress y las pruebas de coincidencia de reglas que no contacten con una cuenta.
- No ejecutar `tunnel login`, `tunnel create`, `route dns`, `service install`, Quick Tunnel ni comandos con token.
- No habilitar todavía confianza en `CF-Connecting-IP`. Cuando exista un túnel real se limitará al peer loopback de `cloudflared`, se probará la cabecera y se evitará confiar en cabeceras de conexiones directas.

La futura publicación requerirá una aplicación Access válida antes del hostname, titularidad y recuperación de cuenta, MFA, dominio verificado y aprobación del bloque externo.

### 4.5. Copia y restauración local con `restic`

El ensayo usará como origen la hoja ficticia y una copia consistente del proveedor/configuración de SFTPGo obtenida con el servicio detenido. Esta copia contiene hashes de contraseña y secretos cifrados de TOTP y debe tratarse como sensible: solo residirá en un staging `0700` de root y dentro del repositorio cifrado, nunca en la bóveda o la evidencia. Antes de fijar el procedimiento se comprobarán los comandos soportados por la versión Community instalada; no se copiará una SQLite activa sin incluir su WAL o sin detener el servicio.

El repositorio de prueba residirá bajo `/root/srv-mm-preparacion-20261106/restic-ensayo`, en el LV raíz, y la restauración se hará en un destino nuevo y aislado. Aunque origen y destino sean volúmenes lógicos distintos, comparten el mismo servidor y disco físico: no será una copia independiente.

La contraseña del repositorio se generará localmente con entropía criptográfica y se guardará en un archivo `0600` bajo `/root/srv-mm-preparacion-20261106/secrets/`; nunca se imprimirá, copiará al repositorio ni enviará por chat. Las pruebas incluirán:

1. inicialización;
2. copia de archivos ficticios y configuración exportable;
3. `restic check`;
4. restauración de documentos a ruta inédita y de la configuración a un proveedor SQLite nuevo, sin sobrescribir el activo;
5. comparación de inventario, tamaños, SHA-256 y recuento de objetos ficticios restaurados;
6. simulación de retención con `forget --dry-run`, sin `prune` destructivo.

No se crearán todavía temporizadores de copia activos. Se prepararán unidades parametrizadas y deshabilitadas para el futuro destino externo.

### 4.6. Monitorización local y evidencia

Se preparará una comprobación manual y una unidad deshabilitada que revise:

- estado de SFTPGo y `cloudflared`;
- escuchas no autorizadas;
- estado obligatorio de MySQL;
- espacio en `/`, `/srv/compartido` y `/var/lib/mysql`;
- antigüedad del último snapshot cuando exista destino real;
- unidades fallidas.

No se enviarán correos, mensajes o telemetría externa sin responsable y canal confirmados. La evidencia depurada incluirá versiones, hashes, puertos, resultados funcionales y reversión, nunca contraseñas, TOTP, tokens, IP pública o contenido documental real.

## 5. Pruebas de aceptación

El bloque solo se considerará superado si se cumplen todas:

1. APT no modifica componentes fuera del alcance y las tres herramientas proceden de las fuentes aprobadas.
2. MySQL permanece `inactive/disabled`, sin proceso ni 3306/33060 antes, durante y después.
3. Con SFTPGo activo solo aparecen `127.0.0.1:18080` y `127.0.0.1:18081`; no hay escucha nueva en la LAN, IPv6 global o `0.0.0.0`.
4. WebClient no ofrece WebAdmin ni REST; WebAdmin solo se alcanza por el reenvío SSH local.
5. La cuenta ficticia supera login con TOTP, carga, descarga, sobrescritura y creación de carpeta dentro de su cuota.
6. Borrado, renombrado, copia, enlaces, protocolos no autorizados, acceso sin TOTP y cuenta revocada son rechazados.
7. Archivos descargados/restaurados coinciden por SHA-256 y la configuración sensible se restaura en un proveedor nuevo sin sobrescribir el activo.
8. `cloudflared` valida la plantilla y sus reglas, pero no existe túnel, token, DNS, ruta privada o servicio activo.
9. `restic check` y restauración terminan correctamente; la evidencia la clasifica como ensayo local, no 3-2-1.
10. UFW y SSH conservan su estado y reglas; no se abre ningún puerto ni se modifica `sshd`.
11. Tras detener SFTPGo y `cloudflared`, las escuchas vuelven exactamente a la línea base esperada.
12. Al cierre, SFTPGo y `cloudflared` quedan `inactive/disabled`, no hay unidades fallidas y la identidad SSH se retira del agente.

## 6. Riesgos y mitigaciones

| Riesgo | Mitigación / condición de parada |
| --- | --- |
| El paquete arranca con binding por defecto en todas las interfaces | Enmascarar antes de instalar; configurar primero; arrancar con observación inmediata de `ss`; detener si aparece cualquier binding no loopback |
| Pantalla inicial de WebAdmin accesible sin administrador | Binding de administración solo loopback y acceso por reenvío SSH; no exponerlo por túnel o LAN |
| Dependencia de funciones Enterprise | Usar documentación Community; no asumir TUS, edición en navegador, antivirus/DLP o soporte comercial |
| Archivos superiores al límite HTTP futuro | Ensayo limitado a 50 MiB; tamaño real y edición/licencia se decidirán con requisitos del cliente |
| SFTPGo puede alcanzar más rutas de las previstas | Cuenta de servicio no privilegiada, permisos de sistema mínimos, `ProtectSystem`/`ReadWritePaths` compatibles y prueba negativa fuera de la hoja piloto |
| Cuota de SFTPGo es contabilidad de aplicación | Margen amplio, comprobación de espacio del sistema y futura alerta; no tratar la cuota como límite de kernel |
| La copia local crea falsa sensación de continuidad | Etiquetar en cada evidencia como no independiente; prohibido admitir datos reales hasta probar destino externo y restauración |
| Instalación altera paquetes no previstos | Simulación APT y aborto ante retiradas, downgrades o cambios en componentes críticos |
| Configuración contiene secretos | Plantillas `.example`; secretos solo en rutas `0600` fuera de la bóveda; redacción de evidencias |
| Pérdida de acceso administrativo | No tocar SSH, UFW, red, LUKS o claves; mantener una sesión de control y prueba nueva antes de cerrarla |

## 7. Reversión

Ante fallo de aceptación:

1. detener SFTPGo y `cloudflared`;
2. deshabilitar sus unidades y confirmar ausencia de nuevas escuchas;
3. retirar únicamente los drop-ins, enlaces y archivos de configuración creados por este bloque, restaurando las copias fechadas cuando exista un archivo previo;
4. retirar la ACL nominal con `setfacl -x u:sftpgo /srv/compartido` y restaurar los demás permisos previos de rutas existentes; no borrar documentos ni esquemas;
5. mantener los paquetes instalados pero inactivos salvo que un fallo de seguridad exija su retirada y se documente esa decisión;
6. conservar aislados los datos, base SQLite, repositorio `restic` y secretos ficticios para diagnóstico; no eliminarlos automáticamente;
7. revalidar MySQL, SSH, UFW, puertos, unidades fallidas y hash de configuración MySQL;
8. registrar causa, alcance y estado recuperado antes de continuar.

La eliminación posterior de artefactos ficticios será un bloque de limpieza explícito con inventario exacto. La reversión no toca DNS, Cloudflare, red, discos o LUKS porque esas acciones están excluidas.

## 8. Exclusiones expresas

- datos, usuarios, correos o documentos reales del cliente;
- creación o modificación de cuenta, zona, DNS, Access, túneles o dispositivos Cloudflare;
- Quick Tunnels o publicación temporal en Internet;
- cambios de router, DHCP, Netplan, UFW, `sshd`, claves, LUKS, BIOS, SAI o discos;
- uso del SSD de 1 TB;
- inicio o modificación de MySQL/Qontrolmed;
- copia externa, declaración 3-2-1, RPO/RTO aceptados o producción;
- simulación física de `192.168.0.0/24`, que requiere un entorno de red separado y otro plan si afecta interfaces reales;
- reinicio o apagado del servidor.

## 9. Artefactos previstos tras la aprobación

| Artefacto | Finalidad |
| --- | --- |
| `06_herramientas/scripts/preflight-bloque-domestico-20261106.sh` | Auditoría y condiciones de aborto |
| `06_herramientas/scripts/aplicar-bloque-domestico-20261106.sh` | Repositorios, paquetes, rutas y configuración idempotente |
| `06_herramientas/scripts/aceptar-bloque-domestico-20261106.sh` | Pruebas técnicas y evidencia depurada |
| `06_herramientas/scripts/revertir-bloque-domestico-20261106.sh` | Parada y restauración sin borrar datos |
| `06_herramientas/scripts/corregir-acceso-sftpgo-20261106.sh` | Corrección aprobada de tránsito mínimo por ACL y evidencia |
| `06_herramientas/configuracion/sftpgo-loopback-piloto.env.example` | Overrides no secretos de bindings y protocolos |
| `06_herramientas/configuracion/cloudflared-documentos.invalid.yml` | Plantilla inerte y validable de ingress |
| `06_herramientas/configuracion/srv-mm-sftpgo-hardening.conf.example` | Drop-in systemd sujeto a verificación de la unidad real |
| `05_evidencias/PREFLIGHT-BLOQUE-DOMESTICO-2026-11-06.txt` | Línea base privilegiada depurada |
| `05_evidencias/ACEPTACION-BLOQUE-DOMESTICO-2026-11-06.txt` | Resultado final sin secretos |

Los scripts se revisarán localmente y se transferirán por SSH con hash antes de ejecutarlos. No se reutilizarán scripts históricos ni se ejecutará nada desde una descarga de Internet.

## 10. Pendientes de producción que este bloque no resuelve

1. dominio, control DNS y titularidad/recuperación Cloudflare;
2. identidades nominales, MFA y matriz final de permisos;
3. necesidad real de archivos mayores de 100 MB y elección Community/Enterprise u otra solución;
4. destino externo, residencia, coste, custodia de claves, retención y restauración 3-2-1;
5. responsable local, SAI/KVM y recuperación LUKS tras corte prolongado;
6. red de sede, reserva DHCP y prueba de rango solapado;
7. RPO/RTO y destinatario de alertas;
8. prueba externa de Access, denegación de identidad/dispositivo y administración SSH privada.

## 11. Fuentes oficiales verificadas el 2026-11-06

- SFTPGo Community, licencia y alcance: <https://docs.sftpgo.com/latest/>
- SFTPGo Community, instalación APT y cuenta de servicio: <https://docs.sftpgo.com/latest/installation/>
- SFTPGo Community, configuración y bindings: <https://docs.sftpgo.com/latest/config-file/>
- SFTPGo, versión y correcciones de seguridad: <https://github.com/drakkan/sftpgo/releases>
- Cloudflare, repositorio APT: <https://pkg.cloudflare.com/>
- Cloudflare, configuración y validación de ingress: <https://developers.cloudflare.com/tunnel/features/locally-managed-tunnels/configuration-file/>
- Cloudflare, instalación como servicio: <https://developers.cloudflare.com/tunnel/features/locally-managed-tunnels/as-a-service/linux/>
- Cloudflare, conectividad saliente 7844: <https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/configure-tunnels/tunnel-with-firewall/>
- Cloudflare, ventana de soporte de `cloudflared`: <https://developers.cloudflare.com/tunnel/downloads/>

