---
tags:
  - app
  - desarrollo
  - codigo
Creado: 2026-07-13
Relacionado:
---
Sí: conviene aumentar el ritmo estas dos semanas, pero con foco quirúrgico, no abriendo más funcionalidad.

Con el cierre de Preventivos, el cuello de botella ya no es la app de campo. Ahora el camino crítico hacia producción es: decisiones de instalación, backup/restauración real, permisos/roles finales, maestros mínimos, migraciones controladas, empaquetado y smoke test final.

**Estimación Realista**  
Desde hoy, lunes 13 de julio, hasta tus vacaciones del viernes 24 de julio quedan 8 días laborables completos: del martes 14 al jueves 23.

Para llegar a una **versión candidata seria antes de vacaciones**, veo unas 6-8 jornadas de trabajo enfocado.

Para llegar a **producción controlada completa**, con evidencias, backup/restauración ensayados y paquete final validado, veo más bien 10-14 jornadas efectivas, dependiendo de decisiones externas.

**Mi lectura**  
Si la puesta en producción es septiembre: vamos bien, pero estas dos semanas deberían usarse para cerrar incertidumbres. No hace falta correr a ciegas, pero sí subir cadencia.

Si la puesta en producción fuese antes de vacaciones: el margen es justo. Solo sería razonable si se congela alcance ya, se aplaza exportación por bloques y se hace una salida controlada muy acotada.

**Prioridad Hasta El 24**

1. Decidir exportación por bloques: mi recomendación inicial sería aplazarla salvo necesidad operativa clara. Si entra, consume 2-3 días entre contrato, escritorio, tablet y pruebas.
2. Cerrar mecanismo de instalación/distribución: ejecutable, carpeta de despliegue, `.env`, rutas runtime, qué se entrega y qué no.
3. Ensayar backup/restauración con datos reales o copia controlada.
4. Validar migraciones y maestros mínimos: Centros, usuarios, roles/permisos, auditoría.
5. Hacer smoke test completo con perfil real: login normal, Gestión, Preventivos, Quirófanos, export/import y PDF básico.
6. Dejar un runbook de producción simple: instalación, arranque, backup, restauración, validación y criterios de no salida.

**Plan Recomendado**  
Semana del 14 al 17:

- Día 1: decidir exportación por bloques y congelar alcance.
- Día 2: revisar instalación/distribución y rutas runtime.
- Día 3: backup/restauración real o copia controlada.
- Día 4: permisos/roles/maestros mínimos y checklist de migraciones.

Semana del 20 al 23:

- Día 5: smoke test completo escritorio.
- Día 6: paquete/build de entrega y prueba limpia.
- Día 7: corrección de incidencias críticas.
- Día 8: documentación final, tag/commit de release candidate y lista de pendientes post-vacaciones.

**Conclusión**  
Sí aumentaría el ritmo estas dos semanas, pero orientado a cerrar producción, no a desarrollar más. El objetivo antes del 24 debería ser dejar una **RC preproducción congelada**, con decisiones tomadas y pruebas principales pasadas. Eso haría que, aunque entres poco durante vacaciones, el proyecto no quede en el aire.