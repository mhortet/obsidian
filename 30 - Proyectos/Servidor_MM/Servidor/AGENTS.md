# Misión persistente: servidor seguro para pyme del sector sanitario

## Objetivo

Convertir, solo después de una auditoría y de la aprobación explícita del propietario, el ordenador de este espacio de trabajo en un servidor de una pequeña empresa que gestiona información sobre instalaciones y equipos de hospitales y clínicas.

## Alcance de los datos

- El alcance permitido es inventario, mantenimiento, documentación técnica, ubicaciones, contratos, incidencias y configuración de instalaciones y equipos.
- No se deben introducir, almacenar, procesar ni inferir datos de pacientes, historias clínicas, diagnósticos, imágenes médicas ni identificadores clínicos.
- Los nombres, correos, teléfonos, credenciales, registros de acceso y otros datos que identifiquen a personas sí son datos personales y deben tratarse como información protegida.

## Reglas de trabajo

- Empezar por auditoría de solo lectura y conservar evidencia fechada.
- Los cambios de firewall, direccionamiento, usuarios, cifrado, discos, BIOS/UEFI, servicios, políticas, actualizaciones y copias requieren un plan aprobado explícitamente por la persona responsable. Una vez aprobado el plan, ejecutar sus pasos incluidos sin solicitar autorización individual para cada uno.
- No borrar, formatear, reinicializar ni desinstalar nada sin una orden explícita y un plan de reversión.
- No abrir puertos a Internet ni publicar RDP/SMB directamente.
- No pedir ni guardar contraseñas, claves privadas, tokens, claves API ni secretos en el repositorio.
- Si se requiere elevar privilegios o conectar un servicio externo, describir primero qué se necesita, por qué y cómo se revierte.
- Mantener el principio de mínimo privilegio y separar cuentas de administración y uso diario.
- Todo cambio debe tener propósito, riesgo, prueba de aceptación y reversión.

## Autorización por plan

- Por instrucción expresa del propietario del 2026-11-05, una autorización del plan cubre sus pasos técnicos, comprobaciones, documentación y medidas de reversión descritas. No volver a pedir aprobación por cada paso o por continuar una fase ya incluida en ese alcance.
- Documentar el plan, sus límites, riesgos, aceptación y reversión antes de ejecutar. Resolver autónomamente los detalles rutinarios compatibles con el plan.
- Pedir una nueva aprobación solo si hay ampliación material de alcance, una acción expresamente excluida, un riesgo relevante no contemplado o una decisión necesaria que no pueda deducirse con seguridad. Explicar la diferencia concreta respecto al plan aprobado.
- La necesidad de que el propietario introduzca una contraseña local o ejecute un comando con privilegios es un requisito técnico, no una nueva solicitud de autorización. No pedir secretos por el chat ni debilitar sudo para evitar esa intervención.
- Ante fallo, aplicar la reversión prevista y conservar evidencia; detener las acciones dependientes si las condiciones de aceptación no se cumplen.
- Esta regla sustituye las instrucciones documentales anteriores que exijan aprobación de cada paso dentro de un plan ya autorizado. No convierte propuestas no aprobadas o decisiones pendientes en autorizaciones implícitas.
## Resultado esperado

Mantener estos entregables vivos:

1. Inventario técnico y mapa de red.
2. Registro de riesgos y decisiones.
3. Arquitectura objetivo, segmentación y flujo de datos.
4. Plan de endurecimiento del sistema y de las aplicaciones.
5. Política de identidades, acceso remoto y proveedores.
6. Política de copias 3-2-1, cifrado y pruebas de restauración.
7. Plan de monitorización, respuesta a incidentes y continuidad.
8. Runbooks operativos y checklist de revisión mensual.

## Secuencia por defecto

1. Confirmar el negocio, los datos, los usuarios y el nivel de disponibilidad necesario.
2. Auditar hardware, sistema, almacenamiento, red, servicios, cuentas, actualizaciones, Defender, firewall, cifrado y virtualización.
3. Diseñar antes de aplicar cambios: preferir un servidor dedicado o una VM aislada si el equipo también se usa como puesto de trabajo.
4. Instalar una base soportada y parcheada; Windows 10 no se considera base aceptable para un servidor nuevo salvo una excepción temporal documentada. Windows 11 se reserva para un puesto de trabajo o laboratorio, no como sustituto de un sistema operativo de servidor.
5. Aplicar segmentación, mínimo privilegio, MFA para accesos remotos, copias cifradas y restauraciones verificadas.
6. Validar con pruebas de seguridad, recuperación y aceptación del negocio.

## Contexto de la auditoría administrativa (2026-09-05)

- Hostname: `DESKTOP-AIALHST`; grupo de trabajo `WORKGROUP`, no unido a dominio.
- Sistema observado: Windows 11 Pro, build `26100` (la hipótesis anterior de Windows 10 queda corregida).
- Hardware: Intel Core i7-9700K, 8 núcleos, 31.9 GB de RAM, dos SSD SATA sanos de 476.9 GB y 953.9 GB.
- TPM: no presente/no preparado; `HypervisorPresent` aparece activo. El tipo de firmware reportado es `2` y debe confirmarse como UEFI/Secure Boot.
- Red observada durante la auditoría: adaptador Intel I219-LM a 100 Mbps; IPv4 `192.168.2.104/24`, DHCP y puerta de enlace `192.168.2.1`. El equipo estaba en una vivienda particular, por lo que esta IP, DHCP, puerta de enlace y topología no son datos de producción ni deben trasladarse al cliente. Hay dos Intel I210 y un Intel I211 desconectados.
- Cifrado: C: y D: aparecen sin estado de protección BitLocker ni protectores de clave.
- Protección: Firewall habilitado en los tres perfiles; Defender y protección en tiempo real activos y con protección contra manipulaciones; el último análisis rápido tiene 149 días y no consta un análisis completo válido.
- Identidades: `USUARIO` está habilitado y no exige contraseña; el equipo sigue siendo local, sin dominio. La pertenencia al grupo de administradores debe conservarse tras repetir el script corregido para Windows en español.
- Puertos/SMB: RPC 135, NetBIOS 139, SMB 445, 5040, 7680 y RPC dinámico. SMB1 está desactivado, SMB2 activo, las comparticiones administrativas están presentes, el cifrado SMB está desactivado y la firma requerida aparece configurada de forma incoherente; no exponer estos servicios fuera de la LAN.
- Actualizaciones: los últimos hotfixes registrados son del 8 de abril de 2026; hay que comprobar el estado real de Windows Update antes de producción.
- El informe inicial serializó mal las direcciones IP y no resolvió el grupo local de administradores por el idioma del sistema; el arnés se ha corregido y debe repetirse si se necesita ese detalle.

Estos datos son una línea base de solo lectura. No autorizan cambios en el equipo ni sustituyen la decisión del cliente sobre arquitectura y criticidad.

