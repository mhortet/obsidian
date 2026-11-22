---
title: "Cronología maestra de Servidor_MM"
type: register
status: active
created: 2026-11-21
updated: 2026-11-21
sources:
  - "../DOCUMENTACION-SERVIDOR-UBUNTU.md"
  - "../CONTINUAR-SIGUIENTE-SESION.md"
tags: [documentacion, administracion]
review_after:
---

# Cronología maestra

Esta cronología permite comprender la evolución sin convertir los estados antiguos en instrucciones vigentes. Para operar debe consultarse primero el [estado actual consolidado](ESTADO-ACTUAL-CONSOLIDADO.md) y el [relevo](../CONTINUAR-SIGUIENTE-SESION.md).

| Fecha | Hito | Resultado vigente o aprendizaje |
| --- | --- | --- |
| 2026-11-21 | Cierre de fase portátil y preparación documental | Próxima fase: sede; creada estructura de entrega al cliente y registros maestros |
| 2026-11-19 | Revalidación SFTPGo y cierre de equipo actual | SFTPGo inactivo/deshabilitado; Cloudflared inactivo/enmascarado; ensayo restic protegido pero local |
| 2026-11-18 | P2U–P2W | Identidad runtime mínima validada; TLS/guard/login y módulos permitidos probados; MySQL solo loopback |
| 2026-11-17 | P2R/P2T | Bootstrap funcional y ledger corregidos; administrador funcional inicial con contraseña; temporales retirados |
| 2026-11-16 | Esquemas e identidades | Esquemas definitivos y separación de identidades; red real todavía pendiente |
| 2026-11-15 | Maestros y esquemas de ensayo | Selección de maestros, libro de revisión y reconstrucción controlada de esquemas |
| 2026-11-13 | Validaciones P2C/P2G/P2J | Ledger, certificado de equipos y Preventivos validados con datos sintéticos y reversión segura |
| 2026-11-12–13 | Incidente de consola | NVIDIA retirada; `nomodeset` validado en VGA/DisplayPort; red y servicios revalidados |
| 2026-11-06 | Bloque documental doméstico | SFTPGo, TOTP, cuotas y restic local aceptados con datos ficticios; sin exposición externa |
| 2026-11-05 | Piloto doméstico MySQL/Qontrolmed | TLS, mínimo privilegio, operaciones ficticias y restauración funcional; sin producción |
| 2026-11-01 | Red doméstica y actualización | Reserva `.31`, reinicio controlado, montajes y acceso validados |
| 2026-10-31 | Cambio de red y UFW | Acceso SSH recuperado mediante sustitución controlada de origen |
| 2026-10-04 | Almacenamiento y MySQL | Volúmenes separados, SMART corto correcto y MySQL 8.4 LTS instalado |
| 2026-10-02 | Baseline | Zona horaria, actualizaciones, SSH/UFW y smartmontools |
| 2026-10-01 | Instalación | Ubuntu Server, UEFI, LUKS2/LVM y SSH por clave sobre SSD de 512 GB |
| 2026-09-05 | Auditoría Windows previa | Línea base del equipo anterior a Ubuntu; conservada como archivo histórico |

## Regla de actualización

Añadir únicamente hitos que cambien estado, decisión, riesgo, aceptación o continuidad. Los comandos y resultados detallados permanecen en diarios, estados y evidencias.
