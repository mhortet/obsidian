---
title: "Inicio de preparación sin datos completos del cliente"
type: process
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../01_gobierno_y_decisiones/DECISION-PREPARAR-TODO-ANTES-TRASLADO-2026-11-05.md"
  - "../02_planes_y_arquitectura/PLAN-PREPARACION-PREVIA-Y-PUESTA-EN-SEDE-2026-11-05.md"
tags: [documentacion, seguridad, administracion]
review_after: 2026-11-06
---

# Objetivo de la sesión del 2026-11-06

Avanzar todo lo posible en la preparación doméstica de `srv-mm-01` aunque todavía no haya respuesta del cliente sobre dominio, DNS, red, copias o recuperación local. La falta de esos datos no bloquea la auditoría, el diseño detallado, la preparación de artefactos reversibles ni las pruebas locales con datos ficticios; sí bloquea la publicación, el cierre de la arquitectura de producción y el traslado definitivo.

El correo de solicitud de información quedó programado en Gmail para el 2026-11-06 a las 08:00, hora de Madrid. Si no hay respuesta, la llamada telefónica será una vía de recopilación posterior, no una condición para iniciar el trabajo técnico seguro.

## Estado de partida que debe revalidarse

- `srv-mm-01` sigue en la LAN doméstica y la última dirección observada fue `192.168.1.31`.
- MySQL 8.4.11 debe continuar `inactive/disabled`, sin proceso ni escucha en 3306/33060.
- La regla LAN temporal debe continuar retirada y las cuentas piloto, bloqueadas.
- La identidad SSH no está cargada en el agente. Su frase de protección solo la introduce el propietario localmente.
- No hay autorización para datos reales, cambios de DNS, recursos Cloudflare, red definitiva, LUKS, discos o exposición de puertos.
- El plan de preparación doméstica sigue `proposed`: antes de cambios técnicos se convertirá el bloque ejecutable en un plan con propósito, riesgo, aceptación y reversión y se solicitará una única aprobación.

## Secuencia de inicio

### 1. Apertura y revalidación de solo lectura

1. Leer `AGENTS.md`, `CONTINUAR-SIGUIENTE-SESION.md` y este runbook.
2. Comprobar la IP actual del ordenador y confirmar que no está conectado FortiClient si se inspecciona la LAN.
3. Cargar la identidad SSH protegida con intervención local del propietario, sin mostrar ni registrar la frase.
4. Conectar con comprobación estricta de host y revalidar:
   - hostname, fecha, kernel y reinicio pendiente;
   - unidades fallidas;
   - estado habilitado/activo de MySQL, SSH y UFW;
   - procesos y escuchas, especialmente 22, 3306 y 33060;
   - almacenamiento y espacio disponible;
   - hash y opciones no secretas de la configuración piloto.
5. Si el estado difiere, detener los pasos dependientes, documentar la diferencia y rediseñar antes de cambiar nada.

### 2. Trabajo que no depende del cliente

- Fijar la separación entre plano documental y plano administrativo.
- Definir cuentas de servicio, directorios, propietarios, permisos, cuotas y política de borrado mediante valores provisionales conservadores.
- Diseñar SFTPGo con WebClient enlazado solo a loopback y WebAdmin no publicado.
- Preparar configuración parametrizada de `cloudflared` sin credenciales, token, túnel ni hostname reales.
- Preparar los perfiles systemd, límites, logs y comprobaciones de salud.
- Preparar scripts idempotentes de instalación, auditoría, aceptación y reversión sin ejecutarlos a ciegas.
- Preparar una estructura de prueba con archivos ficticios y pruebas de subida, descarga, carpetas, cuota, MFA, revocación y denegaciones.
- Diseñar el trabajo de copia de forma independiente del proveedor: selección de datos, cifrado, retención, verificación y restauración. Una prueba local no contará como copia independiente ni 3-2-1.
- Preparar monitorización técnica con destinatario parametrizado; no activar avisos externos hasta conocer responsable y canal.
- Preparar la simulación `192.168.0.0/24` y su reversión sin asumir que sea la red final del cliente.
- Completar el plan de traslado y el checklist de aceptación/no abandono de sede.

### 3. Pruebas locales posibles después de aprobar el bloque ejecutable

- Instalar y validar las versiones soportadas necesarias.
- Ejecutar SFTPGo únicamente con datos ficticios y bindings locales o temporales expresamente acotados.
- Verificar que WebAdmin, SSH, MySQL y SMB no quedan publicados a Internet.
- Validar permisos, cuotas, TOTP, revocación, logs y recuperación de configuración.
- Validar sintaxis y endurecimiento de `cloudflared` sin crear recursos de producción si aún no existe cuenta/zona administrable.
- Probar scripts de copia y restauración con un destino de ensayo, marcando expresamente que no demuestra independencia externa.
- Probar parada, arranque y reversión de los nuevos servicios sin modificar LUKS ni la red definitiva.

## Información ausente y punto de incorporación

| Dato o decisión | Trabajo que puede adelantarse | Acción cuando llegue | Bloqueado hasta entonces |
| --- | --- | --- | --- |
| Control de `maintmedical.es` y zona DNS | Hostnames parametrizados, inventario y rollback DNS | Exportar zona, identificar web/correo, validar titular y planificar cambio de nameservers | Alta nominal de hostnames y cambio DNS |
| Cuenta Cloudflare, propietario, MFA y recuperación | Arquitectura, políticas y nombres provisionales | Crear o invitar cuentas nominales, habilitar MFA y registrar recuperación fuera de la bóveda | Túneles persistentes y políticas Access reales |
| Usuarios documentales y permisos | Matriz de roles conservadora y usuarios ficticios | Sustituir por identidades nominales y validar cuotas/permisos | Alta de usuarios reales |
| Red, DHCP, router y responsable | Perfil de descubrimiento por DHCP y simulación `192.168.0.0/24` | Crear perfil de sede y reserva para `74:fe:48:67:be:cc` después de verificar la red | Configuración IP definitiva |
| Destino externo de copias y custodio | Trabajo, cifrado, retención y restauración con destino de ensayo | Configurar destino real, credenciales fuera del repositorio y alerta de fallos | Declarar 3-2-1 o admitir datos reales |
| Persona local, SAI o KVM | Runbook y prueba de recuperación en laboratorio | Asignar responsable y ejecutar arranque en frío aceptado | Prometer recuperación remota tras corte eléctrico |
| RPO/RTO y disponibilidad | Valores provisionales RPO 24 h/RTO 1 día | Sustituir por decisión del cliente y ajustar copias/monitorización | Aceptación de producción |

Cada dato nuevo debe quedar marcado como `confirmado`, `inferido` o `pendiente`, con fecha y fuente. No se ejecutará una acción externa basándose solo en una conversación telefónica ambigua: se documentará la decisión y se verificará el acceso o dato técnico correspondiente.

## Ramas de trabajo

### Sin respuesta del cliente

Completar auditoría, diseño, artefactos, pruebas locales permitidas y matriz de pendientes. El resultado de la sesión debe ser un bloque doméstico reproducible y una lista corta de decisiones de producción; no se crearán atajos inseguros para simular información ausente.

### Respuesta parcial

Incorporar únicamente los bloques completos y verificables. El resto permanece parametrizado. No rehacer pruebas independientes que sigan siendo válidas; ejecutar solo las pruebas afectadas por el dato nuevo.

### Respuesta completa

Actualizar la arquitectura y el plan ejecutable, revisar riesgos nuevos y solicitar una única aprobación para los cambios técnicos y externos incluidos. Después, crear recursos Cloudflare, configurar copia real y preparar el perfil de sede conforme al plan aprobado.

## Condiciones de parada

Detener la ejecución dependiente si aparece cualquiera de estas situaciones:

- estado del servidor distinto del cierre documentado;
- necesidad de publicar puertos o usar credenciales compartidas;
- solicitud de almacenar secretos en la bóveda o el chat;
- necesidad de tocar LUKS, discos, red definitiva o DNS sin plan aprobado;
- imposibilidad de demostrar reversión o de mantener MySQL detenido;
- dependencia de datos reales o personales no necesarios.

## Cierre obligatorio de la sesión

- MySQL `inactive/disabled`, sin proceso ni 3306/33060.
- Nuevos servicios detenidos o limitados a los bindings aprobados; ningún puerto inesperado.
- UFW y SSH revalidados; ninguna exposición pública directa.
- Identidad SSH retirada del agente y conexiones cerradas.
- Sin credenciales, tokens, claves privadas ni datos reales en documentación o evidencias.
- Estado, diario, plan y `CONTINUAR-SIGUIENTE-SESION.md` actualizados con hechos, no con expectativas.

## Prompt de arranque

> Continúa desde `CONTINUAR-SIGUIENTE-SESION.md` y sigue `03_operacion_y_runbooks/INICIAR-PREPARACION-SIN-DATOS-CLIENTE-2026-11-06.md`. Asume que todavía no hay respuesta del cliente. Empieza con revalidación de solo lectura y presenta el bloque ejecutable doméstico con propósito, riesgos, aceptación y reversión para una única aprobación. No publiques servicios, no cambies DNS, LUKS, discos o red definitiva y mantén MySQL detenido.
