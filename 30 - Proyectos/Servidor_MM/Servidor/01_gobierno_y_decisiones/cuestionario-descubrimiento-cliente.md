# Ficha de descubrimiento antes de convertir el equipo en servidor

## Regla de conservación

El equipo se recibió tal como estaba. Hasta que el cliente autorice por escrito una migración, no se debe formatear, actualizar de versión, cambiar direccionamiento, crear usuarios, desactivar servicios ni modificar reglas de firewall.

## 1. Propósito del equipo

- ¿Qué función cumple hoy este ordenador?
- ¿Es un equipo de usuario, un servidor, un controlador de dominio, un NAS, un host de virtualización o una combinación?
- ¿Qué servicios deben seguir funcionando sin interrupción?
- ¿Qué horario y nivel de disponibilidad se espera?

## 2. Arquitectura existente

- ¿Hay otros servidores, NAS, routers, switches, puntos de acceso, firewalls o servicios cloud?
- ¿Existe un dominio de Windows, Microsoft 365, Google Workspace u otro directorio?
- ¿Qué rangos IP, VLAN, VPN, DNS y DHCP utiliza la organización?
- ¿Qué equipos acceden a este ordenador y desde dónde?
- ¿Hay accesos de proveedores o mantenimiento remoto?

## 3. Aplicaciones y datos

- ¿Qué aplicaciones están instaladas y quién las mantiene?
- ¿Dónde están las bases de datos, documentos, configuraciones y licencias?
- ¿Qué datos son críticos para el negocio?
- ¿Qué datos personales aparecen, aunque no sean datos clínicos?
- Confirmación expresa: no se almacenarán pacientes, historias clínicas, imágenes médicas ni identificadores sanitarios.

## 4. Continuidad y copias

- ¿Qué pérdida máxima de datos se acepta (RPO)?
- ¿Cuánto tiempo puede estar parado el servicio (RTO)?
- ¿Dónde están las copias actuales y cuándo se restauraron por última vez?
- ¿Existe una copia desconectada o fuera de la ubicación?
- ¿Hay UPS, discos redundantes y un equipo de sustitución?

## 5. Seguridad y cumplimiento

- ¿Qué contratos o requisitos de seguridad imponen los hospitales o clínicas?
- ¿En qué países pueden alojarse los datos?
- ¿Quién es responsable de aprobar cambios y responder ante incidentes?
- ¿Hay política de contraseñas, MFA, gestor de secretos, antivirus/EDR y registro de accesos?
- ¿Existe una obligación de conservar o borrar datos después de finalizar un contrato?

## 6. Decisión de plataforma

- ¿Hay alguna aplicación que requiera Windows Server?
- ¿Se acepta Linux para servicios web, bases de datos, contenedores o almacenamiento?
- ¿Se necesita Active Directory o basta con identidades cloud/VPN?
- ¿Cuál es el presupuesto para licencias, discos, UPS, firewall, copias y soporte?
- ¿Se acepta separar el puesto de trabajo del servidor?

## Evidencias a pedir

- Diagrama de red actual, aunque sea informal.
- Lista de equipos y servicios.
- Exportación de copias o informe de restauración.
- Contratos o requisitos técnicos de clientes.
- Inventario de aplicaciones y licencias.
- Persona responsable, ventana de mantenimiento y procedimiento de aprobación.

