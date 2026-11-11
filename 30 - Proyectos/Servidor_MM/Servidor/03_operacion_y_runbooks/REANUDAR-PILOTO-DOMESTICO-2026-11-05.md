---
title: "Reanudar piloto doméstico de srv-mm-01"
type: runbook
status: active
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../00_seguimiento/estados/CIERRE-Y-PAUSA-PILOTO-2026-11-05.md"
tags: [documentacion, seguridad, administracion]
review_after: 2026-11-12
---

# Arranque de la próxima sesión

## 1. Lectura y alcance

Leer [AGENTS.md](../AGENTS.md), [relevo](../CONTINUAR-SIGUIENTE-SESION.md), [cierre y pausa](../00_seguimiento/estados/CIERRE-Y-PAUSA-PILOTO-2026-11-05.md), [informe técnico](../00_seguimiento/estados/CIERRE-TECNICO-PILOTO-DOMESTICO-2026-11-05.md) y [decisión sobre marcas](../01_gobierno_y_decisiones/DECISION-IDS-MARCAS-MANUALES-2026-11-05.md).

El [plan conjunto](../02_planes_y_arquitectura/PLAN-CONJUNTO-CIERRE-PILOTO-DOMESTICO-2026-11-05.md) sigue aprobado para su alcance. No exigir autorización por cada paso. Pedir nueva decisión solo ante ampliación material o riesgo nuevo no contemplado. No crear eventos de calendario ni implantar producción por la existencia de una fecha o de este relevo.

## 2. Recuperar acceso, sin secretos en chat

Servidor encendido y en la red doméstica. Última IP reservada: 192.168.1.31; comprobar antes de asumirla. Última IP del puesto piloto: 192.168.1.107; comprobar de nuevo antes de cualquier regla /32.

La clave del servidor se descargó del agente al cerrar. Comprobar el agente; si necesita iniciarse, el propietario ejecutará Start-Service ssh-agent desde PowerShell con los permisos necesarios. Cargar después la identidad localmente:

```powershell
ssh-add "$env:USERPROFILE\.ssh\id_ed25519_srv_mm"
```

Si pide frase de protección, introducirla exclusivamente en PowerShell. No leer claves privadas, modificar permisos del agente ni desactivar sudo para facilitar la automatización.

Comprobación remota de solo lectura:

```powershell
ssh -i "$env:USERPROFILE\.ssh\id_ed25519_srv_mm" -o IdentitiesOnly=yes -o BatchMode=yes -o StrictHostKeyChecking=yes -o HostKeyAlias=192.168.1.30 -o UpdateHostKeys=no vicente@192.168.1.31 "hostname; systemctl is-active mysql; systemctl is-enabled mysql; ss -ltn; systemctl --failed --no-legend --plain"
```

Esperado: srv-mm-01, mysql inactive/disabled, sin 3306/33060 ni unidades fallidas. Verificar además hash .cnf 4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927. Si difiere, investigar sin arrancar servicios. La normalización de known_hosts sigue pendiente; conservar comprobación estricta y no aceptar claves nuevas sin validar identidad.

## 3. Primera tarea recomendada

Preparar y comprobar copia lógica y restauración de las 33 tablas funcionales y datos ficticios actuales en esquemas nuevos. Las restauraciones ya existentes solo cubrieron la prueba sencilla inicial y deben conservarse, no sobrescribirse. Usar nombres de destino nuevos, precondición de no existencia, copia consistente, validación de tablas/filas/relaciones y evidencia sin secretos. No borrar esquemas para repetir ni importar datos reales. Mantener MySQL en escucha local para esta tarea y detenerlo/deshabilitado al finalizar. Elaborar el script concreto antes de pedir al propietario que lo ejecute con sudo; esto no requiere nueva aprobación del plan.

No ejecutar automáticamente scripts previos de preparación, que abortan ante destinos existentes. No ejecutar el script de autoincremento retirado ni el histórico archivado. Las marcas conservan su ID manual y sus relaciones.

## 4. Pruebas posteriores pendientes

- Revisión visual manual o recuperación del control de ventanas. La portada fue vista por el propietario; @oai/sky agotó captura y reintento. No afirmar pantallas completas revisadas. No automatizar diálogos de autenticación; las pruebas de servicio de autenticación ya se hicieron con cuenta ficticia.
- Segundo ordenador en la LAN para comprobar TCP/3306 rechazado desde un origen no autorizado mientras conecta este PC. Hace falta ese segundo origen para validar activamente el caso; no para la primera tarea de restauración.
- Ampliar escenarios de fallos de red y timeout real de escritura si forman parte de la aceptación requerida.
- Revisar/aceptar código y paquete antes de cambiar instalación habitual. La red de sede, copias externas y producción siguen pendientes.

Si hace falta otra ventana LAN, revalidar IP, cuenta bloqueada, UFW y hash; usar modo --resume de piloto-lan-20261105.py con sudo local y origen SSH_CONNECTION confirmado. Tiene límite de 15 minutos y marca FINALIZAR. No iniciarla hasta tener preparados los tests de esa ventana. La marca de cierre previa se conserva al reanudar.

## 5. Código, entornos y límites

Worktree: C:\Users\Maxi\Documents\Codex\2026-11-05\u\work\qontrolmed-piloto; rama pilot/mysql-tls-20261105; base 014bf7c. Python: work\venv-piloto\Scripts\python.exe. No hay commit/merge/despliegue. Respetar los cambios documentales previos en D:\trabajo\Proyectos\maxgesth.

Runtime privado: AppData\Local\Qontrolmed-Piloto-20261105. No imprimir, capturar ni copiar al repositorio .env o usuario-aplicacion-piloto.json. Credenciales y claves privadas solo en sus ubicaciones protegidas. La instantánea ZIP contiene exclusivamente ocho archivos de código/pruebas/.env.example y README, sin configuración privada.

Fixtures conservadas: marca ID 1207 con descripción ficticia verificada, instrumento sintético desactivado y punto PILOTO-001. No repetir un alta con el mismo ID como si fuese un entorno vacío. Consultar o diseñar una fixture nueva explícita.

## 6. Cierre de cada próxima ventana

Cerrar app de prueba, solicitar FINALIZAR, recoger salida de cierre y comprobar bloqueo de cuenta, retirada de regla propia, configuración local y MySQL inactive/disabled sin puertos. Actualizar evidencia/estado/diario/relevo. Al acabar la sesión, cerrar solo las conexiones del servidor y descargar solo su identidad del agente. No apagar Ubuntu ni detener SSH salvo instrucción específica.

## Texto para retomar

```text
Retomamos srv-mm-01 desde el cierre del 2026-11-05. Lee AGENTS.md, CONTINUAR-SIGUIENTE-SESION.md y 03_operacion_y_runbooks/REANUDAR-PILOTO-DOMESTICO-2026-11-05.md. Empieza revalidando sin cambios; la clave se retiró del agente. El plan conjunto del piloto ya está autorizado sin permisos por cada paso. MySQL debe estar detenido/deshabilitado y sin 3306/33060. Conserva los ID manuales de marcas. Prioriza preparar y probar copia/restauración de las 33 tablas funcionales con datos ficticios en nuevos destinos, manteniendo escucha local y cierre seguro. No repitas altas existentes, no importes datos reales ni despliegues la copia de Qontrolmed sobre la instalación habitual. Documenta en las carpetas del proyecto.
```
