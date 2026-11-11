# Plan inicial de trabajo: servidor seguro para una pyme sanitaria

Fecha de captura: 2026-09-05 (Europe/Madrid)

## Decisión de diseño que debe confirmarse

La auditoría administrativa muestra un Windows 11 Pro 26100 de uso interactivo. La red capturada (`192.168.2.0/24`, DHCP y puerta de enlace `192.168.2.1`) pertenece a la vivienda donde se está realizando la auditoría y no representa la red del cliente. El equipo tiene margen para cargas ligeras (i7-9700K, 32 GB y dos SSD), pero no tiene TPM, no hay redundancia de discos y el enlace activo observado es de 100 Mbps. Por tanto, puede servir como laboratorio o servidor de baja criticidad si el cliente acepta esos límites; no debe darse por válido para producción sensible hasta cerrar disponibilidad, copias, cifrado y soporte.

### Decisión provisional sobre el sistema operativo

La auditoría demuestra que ya está instalado Windows 11 Pro; la propuesta anterior de actualizar desde Windows 10 queda corregida. El equipo no tiene TPM (`TpmPresent=false`, `TpmReady=false`), así que la instalación de Windows 11 debe considerarse fuera de la línea base soportada hasta confirmar firmware y el método de instalación. Windows 11 sigue siendo apropiado para un puesto de trabajo, pero para producción se debe elegir una plataforma de servidor:

- **Windows Server 2025 Standard** (o Essentials si el tamaño y la licencia encajan) cuando haya aplicaciones Windows, Active Directory, SQL Server, requisitos de SMB o administración Microsoft.
- **Ubuntu Server LTS** cuando los servicios sean web, bases de datos, contenedores, automatización o almacenamiento y no haya dependencia de software Windows. Se escogerá la LTS soportada que acepte la aplicación; a fecha de este plan Ubuntu 26.04 LTS tiene mantenimiento de seguridad estándar hasta mayo de 2031.
- **Hipervisor** solo si el hardware tiene margen suficiente y se necesitan varias cargas aisladas; no se añadirá complejidad de virtualización sin una necesidad concreta.

La decisión final exige confirmar aplicaciones, usuarios, licencias, soporte del fabricante, tolerancia de parada y presupuesto. Dado que el hardware no va a cambiar, habrá que decidir si se acepta un único nodo sin RAID/alta disponibilidad o si el cliente debe contratar un servidor/NAS separado. En todos los casos se hará instalación limpia o migración controlada con copia verificada, no una actualización improvisada sobre el sistema en uso.

## Hallazgos preliminares

| Área | Evidencia | Riesgo preliminar | Acción pendiente |
|---|---|---:|---|
| Sistema operativo | Windows 11 Pro build 26100; TPM ausente/no preparado | Alto | No usarlo como línea base final sin confirmar soporte; elegir Windows Server o Linux Server según las aplicaciones. |
| Hardware | i7-9700K, 32 GB, dos SSD SATA sanos; sin RAID/ECC confirmado | Medio/alto | Adecuado para cargas ligeras; documentar que es un único nodo y que la continuidad depende de copias y sustitución. |
| Privilegios de auditoría | Auditoría administrativa completada; el script tenía dos campos mal serializados | Medio | Repetir el script corregido si se necesita red exacta o miembros del grupo de administradores. |
| Red de auditoría | `192.168.2.104/24`, DHCP, enlace activo de 100 Mbps, router `192.168.2.1` en vivienda particular | Informativo | No trasladar estos valores al cliente; obtener direccionamiento, VLAN, DNS, DHCP y firewall reales durante el descubrimiento. |
| Exposición local | SMB 445, NetBIOS 139, RPC 135 y puertos dinámicos; comparticiones administrativas activas | Alto | Identificar necesidad, limitar por subred, desactivar lo no requerido y nunca publicar SMB/RDP en Internet. |
| Cifrado | C: y D: sin protección BitLocker ni protectores registrados | Crítico | Diseñar cifrado de datos y recuperación de claves antes de almacenar información de cliente. |
| Copias | No auditadas | Alto | Definir RPO/RTO y desplegar 3-2-1 con copia offline/offsite cifrada y prueba de restauración. |
| Identidades | Equipo en WORKGROUP; `USUARIO` habilitado sin contraseña obligatoria; cuentas Codex presentes | Alto | Separar cuenta de administración y uso diario, exigir contraseñas robustas, retirar cuentas no necesarias y usar MFA en accesos remotos. |
| Protección | Defender activo y protegido contra manipulaciones, pero análisis rápido de hace 149 días y sin análisis completo válido | Alto | Actualizar firmas, ejecutar análisis completo y programar revisiones antes de producción. |
| Parches | Últimos hotfixes registrados del 8/04/2026 | Alto | Comprobar Windows Update y parchear antes de exponer servicios; la fecha no prueba que el sistema esté al día. |
| Continuidad | No auditada | Medio/alto | UPS, apagado seguro, repuesto, monitorización y procedimiento de recuperación. |

## Plan por fases

### Fase 0 — alcance y decisiones (antes de tocar el equipo)

- Confirmar si el equipo será exclusivamente servidor o también puesto de trabajo.
- Inventariar usuarios, aplicaciones, fuentes de datos, clientes, integraciones y accesos remotos.
- Definir clasificación de la información: pública, interna, confidencial de cliente y restringida.
- Definir RPO/RTO, horario de servicio, crecimiento anual y presupuesto.
- Confirmar requisitos contractuales de hospitales, localización de datos, retención y notificación de incidentes.

### Fase 1 — auditoría administrativa y línea base

- Hardware, firmware/UEFI, TPM, discos, RAID, SMART, memoria, virtualización y garantía.
- Edición/build/soporte del sistema, parches, roles y características.
- Usuarios, grupos, sesiones, tareas, servicios y software instalado.
- Firewall por perfil, Defender/EDR, BitLocker, Secure Boot, LAPS/Windows Hello si aplica.
- Interfaces, VLAN, DHCP/DNS, rutas, puertos escuchando, comparticiones y reglas NAT.
- Prueba de restauración de una muestra de datos existente antes de migrar.

### Fase 2 — arquitectura objetivo

- Servidor dedicado o hipervisor con una VM de servicios; evitar mezclar navegación/ofimática con datos de producción.
- Segmento de servidores separado de puestos, invitados, Wi-Fi e IoT.
- Administración solo desde una red de gestión o VPN con MFA.
- Servicios mínimos: archivos/documentación, inventario, copias y monitorización; cada servicio con cuenta y permisos propios.
- Acceso externo mediante VPN/ZTNA o servicio gestionado; nunca RDP/SMB expuestos.

### Fase 3 — endurecimiento

- Sistema operativo soportado, parches automáticos controlados y software mínimo.
- Cifrado de datos en reposo y tránsito; BitLocker/TPM o equivalente y TLS.
- Mínimo privilegio, cuentas nominativas, MFA, bloqueo por inactividad y auditoría de accesos.
- Firewall de denegación por defecto y reglas por subred/servicio.
- Desactivar SMBv1, NetBIOS y servicios no requeridos; conservar SMB solo si el caso de uso lo exige y con firma/cifrado.
- EDR/antivirus, control de aplicaciones, filtrado DNS, registro central y alertas.

### Fase 4 — datos, copias y continuidad

- Inventario de datos y propietario por conjunto.
- Regla 3-2-1: original + dos copias, dos soportes, una fuera de la ubicación; cifrar y probar restauración.
- Retención basada en negocio/contrato; no conservar más de lo necesario.
- UPS, apagado limpio, repuesto de disco, procedimiento de recuperación y prueba trimestral.

### Fase 5 — operación

- Checklist mensual: parches, alertas, espacio, SMART, copias, cuentas, reglas de firewall y logs.
- Revisión trimestral: restauración, vulnerabilidades, accesos de proveedores y capacidad.
- Revisión anual: riesgos, contratos, plan de continuidad y arquitectura.

## Preguntas necesarias para cerrar el diseño

1. La auditoría identifica i7-9700K, 31.9 GB RAM y SSD de 512 GB + 1 TB sin RAID confirmado. ¿Acepta el cliente esta limitación o exige redundancia/servidor auxiliar?
2. ¿Será servidor exclusivo 24x7 o seguirá usándose para escritorio, navegador y correo?
3. ¿Qué servicios concretos debe ofrecer: archivos, base de datos, inventario, aplicación web, copias, VPN, acceso remoto u otros?
4. ¿Cuántas personas y dispositivos accederán, desde qué sedes y con qué frecuencia?
5. ¿Habrá acceso desde hospitales/clientes o solo desde la oficina? ¿Necesitas acceso remoto de proveedores?
6. ¿Qué tipo y volumen de datos hay hoy, cuánto crecerá al año y qué datos personales de empleados/contactos contiene?
7. Confirma explícitamente que no se almacenarán datos de pacientes ni imágenes, y cómo se impedirá que entren por error.
8. ¿Qué pérdida máxima de datos toleras (RPO) y cuánto tiempo puede estar parado el servicio (RTO)?
9. ¿Qué presupuesto aproximado hay para servidor/NAS, discos, UPS, firewall, copias cloud y soporte?
10. ¿Qué router, switch, Wi-Fi y proveedor de Internet hay? ¿Admiten VLAN, VPN, reglas salientes y actualizaciones?
11. ¿Tienes dominio o identidad cloud (Microsoft 365/Google Workspace) y MFA para todas las cuentas?
12. ¿Qué país o países deben alojar los datos y qué requisitos contractuales de los hospitales aplican?
13. ¿Existe ya una solución de copias, antivirus/EDR, monitorización, gestión de contraseñas y plan de incidentes?
14. La auditoría administrativa ya se ejecutó. ¿Autorizas repetir el script corregido para confirmar Secure Boot, IP aplanada y miembros del grupo de administradores, sin credenciales ni secretos?
