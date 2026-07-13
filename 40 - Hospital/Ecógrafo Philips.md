---
tags:
  - Error
  - hospital
Creado: 2026-07-13
Relacionado:
---
![[Pasted image 20260713134835.png|300]]
Es un **fallo de comunicación o reconocimiento del transductor**. El **DiagCode 007** aparece documentado en equipos Philips EPIQ con exactamente el mismo mensaje: _reconectar y volver a seleccionar el transductor_. El código largo parece ser el identificador detallado del evento para el SAT, no la avería concreta. ([Datos de Acceso de la FDA](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfmaude/detail.cfm?mdrfoi__id=16902067&pc=IYN&utm_source=chatgpt.com "PHILIPS ULTRASOUND, INC EPIQ 7C ULTRASOUND SYSTEM"))

### Pruebas rápidas

1. Finaliza el estudio, desconecta y conecta nuevamente la sonda y vuelve a seleccionarla.
    
2. Apaga completamente el ecógrafo —no solo modo espera— y reinícialo.
    
3. Revisa el conector de la sonda: pines doblados, suciedad, humedad, corrosión o bloqueo incompleto. El conector debe estar totalmente seco. ([Documentos Philips](https://www.documents.philips.com/assets/20220523/1e713f012b404ea29928ae9e0138b041.pdf?utm_source=chatgpt.com "Care and cleaning of ultrasound transducers"))
    
4. Prueba:
    
    - La misma sonda en otro puerto.
        
    - Otra sonda conocida como correcta en ese mismo puerto.
        

### Interpretación

- **El fallo sigue a la sonda:** cable, conector o electrónica interna de la sonda.
    
- **Falla únicamente un puerto:** módulo/conector de transductores.
    
- **Fallan varias sondas en distintos puertos:** posible problema de software o de la cadena de adquisición/interfaz de sondas.
    

Pulsa **«Servicio»** para que termine de recopilar los diagnósticos y guarda el código completo para Philips. Yo no desmontaría nada todavía. Dime el **modelo exacto del ecógrafo y de la sonda**, y afinamos bastante más.