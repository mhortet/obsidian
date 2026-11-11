---
title: "Cierre y pausa del piloto doméstico"
type: register
status: paused
created: 2026-11-05
updated: 2026-11-05
sources:
  - "../../05_evidencias/COMPROBACION-FINAL-PAUSA-2026-11-05.txt"
  - "CIERRE-TECNICO-PILOTO-DOMESTICO-2026-11-05.md"
tags: [documentacion, seguridad, administracion]
review_after: 2026-11-12
---

# Sesión cerrada y continuación preparada

El propietario pidió parar, cerrar la sesión y dejar documentado el arranque siguiente. No continuar pruebas ni abrir otra ventana LAN hasta que el propietario retome el trabajo. El plan conjunto mantiene su autorización para los pasos pendientes, sin pedir aprobación por cada uno.

## Estado de cierre comprobado

Última auditoría remota guardada en 05_evidencias/COMPROBACION-FINAL-PAUSA-2026-11-05.txt: srv-mm-01, MySQL inactive/disabled, sin proceso mysqld ni escucha 3306/33060, sin unidades fallidas y configuración segura con hash 4d8677b4e7510c62970125b5b8a58c388b06b4e11bca87afc440f4f5627d8927. Marca FINALIZAR presente. No había scripts de ventana/pruebas del piloto ejecutándose.

El cierre de la última ventana había confirmado cuenta LAN bloqueada, retirada de regla temporal y restauración de escucha local. Las cuentas y bases ficticias, restauraciones y copias se conservan. No se apagó ni reinició Ubuntu; cerrar SSH no detiene su servicio SSH ni impide conectarse en otra sesión autorizada.

## Sesión y puesto Windows

Windows negó terminar directamente el proceso SSH 6580. Se identificó de forma remota la única consola interactiva del usuario vicente (bash, pts/0, PID 4285), se comprobaron nombre/terminal y se cerró con HUP desde la misma cuenta. El acceso de auditoría finalizó normalmente. No se cambiaron privilegios ni servicios para conseguirlo.

Retirada únicamente la identidad id_ed25519_srv_mm del agente mediante su archivo público; no se eliminaron archivos de claves ni se descargaron otras identidades. Comprobación posterior: cero conexiones TCP SSH establecidas hacia 192.168.1.31:22 y cero procesos del harness GUI. El servicio del agente no se deshabilitó.

## Documentación y código preservados

Informe técnico, evidencias, decisión de ID manuales, scripts y relevo se conservan en las carpetas existentes. Instantánea de ocho archivos de aplicación más README en 06_herramientas/configuracion/QONTROLMED-CAMBIOS-PILOTO-2026-11-05.zip, verificada. Worktree independiente y entorno Python conservados; no commit, merge ni despliegue sobre la aplicación habitual.

39 pruebas automatizadas y servicios representativos superados. El propietario vio abrirse la portada. No afirmar revisión visual completa ni restauración de las 33 tablas: esos casos siguen pendientes.

## Arranque de la siguiente sesión

Leer CONTINUAR-SIGUIENTE-SESION.md y 03_operacion_y_runbooks/REANUDAR-PILOTO-DOMESTICO-2026-11-05.md desde la raíz del proyecto. Revalidar sin cambios y cargar la clave localmente cuando sea necesario. La tarea prioritaria propuesta es copia/restauración del esquema funcional completo a destinos nuevos sin sobrescribir nada. Otro equipo solo hará falta para comprobar activamente el rechazo desde un origen no autorizado; no es requisito para esa tarea inicial.
