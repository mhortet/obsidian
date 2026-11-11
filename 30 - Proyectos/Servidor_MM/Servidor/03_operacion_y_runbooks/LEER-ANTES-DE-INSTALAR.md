# Continuidad del montaje del servidor Linux

Actualizado: 2026-10-01. Fuente: decisiones del usuario en esta conversación; no constituye una nueva auditoría del equipo.

Este documento actualiza las decisiones del plan histórico de septiembre. Leerlo junto con `AGENTS.md` al continuar desde Linux.

## Decisiones y necesidades confirmadas

- Equipo dedicado exclusivamente a servidor. El usuario permite sustituir Windows y declara que es una instalación limpia, sin datos de trabajo que conservar. Conservar fuera del equipo esta carpeta de proyecto antes de borrar discos.
- Plataforma elegida: Ubuntu Server LTS sin escritorio. Versión concreta y particionado pendientes de cerrar antes de instalar.
- Qontrolmed es una aplicación desarrollada por el usuario, ejecutada fuera de este servidor y conectada a sus bases MySQL. MySQL 8.4.9 está instalado y probado en el entorno actual de la aplicación; no se ha auditado aquí esa instalación. No se exige esa revisión exacta. Propuesta: rama MySQL 8.4 LTS, validando la revisión elegida con Qontrolmed. No sustituir por MariaDB sin validación.
- Carpeta compartida para intercambio local y remoto. Propuesta: Samba y acceso remoto por VPN con MFA; producto VPN pendiente de elegir. No publicar SMB ni MySQL directamente en Internet.
- Página web de empresa: posibilidad futura, con entorno aislado de los servicios internos. No se ha autorizado publicarla ni abrir puertos.
- Concurrencia estimada: normalmente 1–2 usuarios, máximo previsto de 5. Empresa con un par de ordenadores y accesos remotos desde varias zonas.
- Volumen de bases de datos aún desconocido; crecimiento previsto moderado. Medir ocupación inicial y crecimiento antes de fijar retención de copias.
- Disco externo: no disponible actualmente; incluir su adquisición en la propuesta al cliente.
- SAI: el usuario indicará al cliente que debe instalarlo; adquisición y puesta en servicio no confirmadas.

## Reparto provisional de almacenamiento

| Unidad | Referencia de la auditoría | Uso propuesto |
|---|---|---|
| SSD menor, aproximadamente 500 GB | 476,9 GB reportados | Ubuntu Server, MySQL y archivos compartidos |
| SSD mayor, aproximadamente 1 TB | 953,9 GB reportados | Copias locales periódicas con historial |
| Disco externo por adquirir | Capacidad por dimensionar | Copia cifrada adicional, con rotación desconectada y custodia fuera de la ubicación |

Este reparto no es una orden de formateo ni fija tamaños de particiones. Identificar cada disco por modelo, número de serie y capacidad antes de instalar; no inferir correspondencias entre C:/D: y los dispositivos Linux. No se propone RAID ni alta disponibilidad.

El segundo SSD facilita restauraciones, pero comparte equipo, alimentación y ubicación con los originales. No cubre por sí solo robo, daños generales o compromiso de todo el servidor. Completar el esquema 3-2-1 antes de producción y comprobar restauraciones. Dimensionar retención para no llenar el disco; el tamaño de 1 TB no garantiza ninguna duración de historial.

Las copias de MySQL deben obtenerse por un procedimiento consistente con la base de datos; no basta copiar los archivos de una instancia en ejecución. Frecuencia, herramienta y retención pendientes de definir. Diseñar cifrado y custodia de claves fuera del repositorio, incluido el procedimiento de arranque tras corte eléctrico.

## Recuperación y disponibilidad

El usuario indica flexibilidad en el tiempo de recuperación, sin fijar un plazo. No interpretar esta respuesta como aprobación de una parada ilimitada ni de pérdida de datos.

- RTO: tiempo máximo aceptable sin servicio; pendiente de cuantificar, sin exigencia inmediata de recuperación rápida declarada.
- RPO: cantidad máxima de trabajo que se puede perder, expresada en tiempo; pendiente de confirmar por separado.
- La recuperación aplica a corrupción, borrado accidental, fallo de SSD/equipo, incidentes de seguridad y otros fallos, no solo a corrupción.
- Antes de producción: acordar ambos objetivos, restaurar una base y archivos de muestra en un entorno separado y registrar el tiempo y el resultado.

## Red de preparación y red definitiva

El equipo está ahora en la red del usuario, no en la del cliente. Los parámetros de producción se configurarán cuando se instale en su ubicación definitiva.

- No trasladar la IP, subred, puerta de enlace o DNS domésticos a la configuración final.
- Durante la preparación, documentar cualquier configuración como temporal; no cambiar ahora el direccionamiento por este documento.
- En destino: inventariar router, switch, subredes, DHCP, DNS, conexión a Internet y capacidad de segmentación; después elegir IP o reserva DHCP sin conflictos y restricciones de acceso.
- Comprobar la velocidad del enlace en destino: la auditoría anterior observó 100 Mbps.
- Probar Qontrolmed y archivos desde la LAN y desde una conexión remota autorizada; verificar que un usuario sin permisos no accede.

## Secuencia para continuar

1. Copiar toda `D:\Servidor` a un soporte externo al equipo y verificar que se pueden leer los documentos y evidencias. Esta copia todavía no se ha realizado en esta tarea.
2. Revisar evidencia de auditoría, identificar discos y cerrar ISO, particionado, cifrado y recuperación antes del borrado.
3. Documentar el cambio de sistema: propósito (servidor dedicado), riesgo (borrado y pérdida del entorno Windows), aceptación (arranque, discos y red verificados), reversión (reinstalar Windows si fuera necesario y recuperar la documentación externa; no existe una imagen de Windows verificada).
4. Instalar Ubuntu dentro del alcance aprobado. No iniciar borrados automáticos desde esta documentación.
5. Copiar esta carpeta al entorno Linux y continuar con `AGENTS.md` y este documento; no depender de que se transfiera el historial de conversación. Configurar Codex bajo usuario normal, sin guardar credenciales en el proyecto.
6. Preparar MySQL y permisos, Samba, acceso remoto y copias, documentando propósito, riesgo, prueba de aceptación y reversión de cada cambio.
7. Adquirir y configurar disco externo y SAI, comprobar copias y apagado seguro, y cerrar RPO/RTO.
8. En la sede del cliente, configurar y validar la red definitiva y completar las pruebas de aceptación antes de introducir datos reales.

## Alcance de esta actualización

Solo se ha actualizado documentación. No se han formateado discos ni cambiado sistema operativo, red, servicios, usuarios, firewall, cifrado o copias. La conservación de la documentación fuera del equipo está pendiente.
