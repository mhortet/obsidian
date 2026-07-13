---
tags:
  - Error
  - hospital
  - equipos
  - mantenimiento
Creado:
Relacionado:
---

# Incidencia técnica -- Philips IntelliVue MX800

**Fecha:** 30/06/2026\
**Equipo:** Philips IntelliVue MX800\
**Ubicación:** UCI (paciente ventilado)

## Descripción de la incidencia

Paciente monitorizado mediante cable ECG de **5 derivaciones** con
colocación de electrodos **en tronco (Mason-Likar)**.

Se observa el siguiente comportamiento:

-   El monitor únicamente permite visualizar la **derivación I**.
-   El resto de derivaciones (II, III, aVR, aVL, aVF y V) aparecen
    **deshabilitadas/sombreadas** y no pueden seleccionarse.
-   La configuración revisada es:
    -   Lead Placement: **Standard**
    -   Limb Leads: **On Trunk**
    -   Paciente sin marcapasos.
    -   La opción de marcapasos (Activado / Desactivado / Indeterminado)
        no modifica el comportamiento.

Debido a que el paciente estaba siendo atendido en UCI, no se realizaron
pruebas que implicaran sustituir el cable o manipular los electrodos.

------------------------------------------------------------------------

# Hipótesis de diagnóstico

## 1. Cable ECG defectuoso (hipótesis principal)

Es la causa más probable.

Aunque el cable sea de 5 derivaciones, un fallo interno o un problema en
la identificación del cable puede provocar que el monitor únicamente
habilite la derivación I.

**Prioridad: Muy alta.**

------------------------------------------------------------------------

## 2. Conector cable--MMS/X2

Comprobar:

-   suciedad
-   humedad
-   pines doblados
-   holguras

------------------------------------------------------------------------

## 3. Módulo MMS/X2

Si con otro cable persiste exactamente el mismo comportamiento,
considerar avería del módulo de medidas.

------------------------------------------------------------------------

## 4. Configuración

Revisado:

-   Standard ✔
-   On Trunk ✔

No se localizaron parámetros de usuario que permitan forzar manualmente
la detección del tipo de cable.

------------------------------------------------------------------------

# Pruebas propuestas

1.  Desconectar y volver a conectar el cable ECG al módulo MMS/X2 para
    forzar una nueva identificación.
2.  Sustituir el cable ECG por otro conocido en buen estado.
3.  Si continúa igual:
    -   probar el cable en otro monitor, o
    -   probar otro MMS/X2 en este monitor.
4.  Verificar el estado de detección de electrodos (RA, LA, LL, RL y V).

------------------------------------------------------------------------

# Valoración

Con la información disponible:

-   Cable ECG: **70--80 %**
-   Módulo MMS/X2: **15--20 %**
-   Configuración/software: **\<5 %**

------------------------------------------------------------------------

# Resultado final

**Pendiente de completar tras las pruebas realizadas en UCI.**

## Resolución

*(Completar mañana)*

## Causa definitiva

*(Completar mañana)*

## Acción correctiva

*(Completar mañana)*

## Observaciones

*(Completar mañana)*
