---
title: "Preparación de sesión tras incidente de consola"
type: register
status: active
created: 2026-11-12
updated: 2026-11-12
sources:
  - "../estados/ESTADO-INCIDENTE-ARRANQUE-GRAFICA-RED-2026-11-12.md"
  - "../../CONTINUAR-SIGUIENTE-SESION.md"
  - "../../03_operacion_y_runbooks/REANUDAR-TRAS-INCIDENTE-CONSOLA-2026-11-13.md"
tags: [documentacion, seguridad, administracion]
review_after: 2026-11-14
---

# Preparación documental — 12/11/2026

Con el servidor apagado, se revisó el cierre documental del incidente de consola, gráfica y red. No se intentó acceso remoto, encendido ni cambio técnico.

Se detectó que `CONTINUAR-SIGUIENTE-SESION.md` todavía apuntaba directamente al cierre del bloque doméstico del 6/11 y no incorporaba el incidente del 12/11. Se actualizó el relevo para que la próxima sesión comience desde el estado físico real: servidor apagado, NVIDIA retirada, `nomodeset` persistente aceptado y servicios de aplicación detenidos.

El propietario corrigió después una omisión importante: existía un relevo del trabajo del 10/11. Se localizó en el proyecto hermano `Qontrolmed/01_gobierno_y_decisiones/CONTINUAR-SIGUIENTE-SESION.md`; fue creado el 10/11 y actualizado el 11/11. Recoge P0/P1 local sobre `codex/produccion-readiness`, 44 pruebas correctas y pendientes de CI remoto, sin cambios en el servidor ni construcción de RC. La preparación de mañana se corrigió para usar ese relevo como fuente funcional vigente y conservar el documento del 6/11 solo como estado de la plataforma del servidor.

Por decisión del propietario, `Servidor_MM` y el repositorio `D:\trabajo\Proyectos\maxgesth` pasan a tratarse como dos puntos de entrada del mismo trabajo coordinado. Se añadió una regla simétrica a ambos `AGENTS.md` y una advertencia breve a ambos relevos: leer instrucciones y continuidad de los dos proyectos, respetar sus fuentes de verdad y autorizaciones separadas, y actualizar ambos lados cuando una sesión sea transversal.

Se creó `03_operacion_y_runbooks/REANUDAR-TRAS-INCIDENTE-CONSOLA-2026-11-13.md`, con:

- preparación física previa sin reinstalar hardware ni cambiar BIOS/UEFI;
- arranque controlado y comprobación local de POST, LUKS, consola y login;
- revalidación remota de solo lectura;
- criterios explícitos de éxito, parada y cierre;
- continuidad condicionada hacia la auditoría posterior a la aceptación;
- prompt autosuficiente para iniciar la sesión del 13/11.

El plan posterior a la aceptación continúa propuesto y no se ha convertido en autorización para cambios remotos. El diagnóstico físico de la NVIDIA y la revisión de `sdb1` permanecen fuera del alcance preparado.
