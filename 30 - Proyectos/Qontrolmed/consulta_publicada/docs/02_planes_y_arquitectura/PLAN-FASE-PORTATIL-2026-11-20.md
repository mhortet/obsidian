---
title: "Fase portátil — preparación previa a sede"
type: plan
status: completed
created: 2026-11-20
updated: 2026-11-21
sources:
  - "docs/01_gobierno_y_decisiones/DECISION-SECUENCIA-EQUIPO-PORTATIL-SEDE-2026-11-19.md"
  - "docs/02_planes_y_arquitectura/PLAN-CIERRE-FASE-EQUIPO-ACTUAL-2026-11-19.md"
  - "docs/03_operacion_y_runbooks/guia_instalacion_rc_qontrolmed.md"
tags: [qontrolmed, portatil, rc, preparacion]
review_after: 2026-11-27
---

# Fase portátil — preparación previa a sede

## Estado y supuesto de trabajo

Plan preparado para iniciar la sesión desde el portátil. La ejecución comenzará
después de observar su estado real y confirmar si actuará solo como herramienta
de administración/transporte o también como puesto Qontrolmed de prueba. No se
presupone que sea una máquina de desarrollo.

La fase `equipo actual` está cerrada. Este plan no inicia la fase `sede` ni
autoriza cambios en servidor, MySQL, SFTPGo, red, router, UFW, certificados o
cuentas reales.

El propietario confirma que Codex ya está instalado en el portátil. No será
necesario instalarlo ni copiar un repositorio solo para recuperar el contexto;
la sesión partirá de este relevo y del kit verificado.

## Material que debe llegar al portátil

No se copiarán completos los directorios `maxgesth` ni `Servidor_MM`.

El mínimo necesario es el kit local ignorado por Git:

`dist_rc\KIT-PORTATIL-QONTROLMED-0.1.0-rc.1\`

Contendrá:

- `Qontrolmed-RC-0.1.0-rc.1.zip`;
- `Qontrolmed-RC-0.1.0-rc.1.zip.sha256`;
- `LEEME-PORTATIL.txt`;
- `MANIFEST-KIT-SHA256.csv`;
- una carpeta `contexto\` con copias de consulta de las instrucciones, relevo,
  plan portátil y lecturas obligatorias de Qontrolmed, más las instrucciones y
  el relevo coordinado de Servidor_MM.

Estas copias permiten que Codex recupere el contexto desde una única carpeta,
pero no sustituyen a los repositorios como fuente de verdad ni deben editarse
como si fueran originales.

El ZIP ya incluye aplicación, instalador, configurador, verificadores,
desinstalador, guía, manifiesto interno, SBOM, notas y evidencia depurada.

### Cuándo sería necesario un repositorio

- Si el portátil se usa solo para preparar/ensayar la RC o llevarla a sede:
  no necesita ningún repositorio.
- Si se decide desarrollar o usar Codex desde el portátil: se realizará un
  clon limpio de Qontrolmed desde el remoto después de decidir la publicación
  de la rama y del tag. No se copiará el directorio de trabajo actual.
- El directorio completo de Servidor_MM no se necesita en esta fase. Solo sería
  necesario al iniciar trabajo de infraestructura, que pertenece a una fase y
  autorización distintas. Sus instrucciones y relevo se consultarán desde su
  fuente vigente cuando corresponda.

## Preparación manual antes de la sesión

1. Tener el portátil encendido y conectado a corriente.
2. Disponer de una cuenta Windows ordinaria y conocer qué cuenta puede aceptar
   UAC como administradora. No enviar ni anotar contraseñas en el chat.
3. Tener disponibles al menos 2 GiB libres para extracción y ensayo; se
   comprobará el espacio real antes de copiar.
4. Permitir que Windows Update termine si ya tiene una actualización pendiente,
   pero no iniciar actualizaciones nuevas justo antes de la sesión.
5. No instalar previamente Python, Git, MySQL, Workbench ni Qontrolmed: primero
   se inventariará el estado real y se decidirá qué resulta necesario.
   Codex ya está instalado y no debe reinstalarse.
6. No copiar `.env`, CA, secretos, certificados privados, bases de datos,
   salidas ni datos reales.
7. Preparar un USB solo si se usará para transferir el kit. Debe contener el kit
   mínimo, no los dos árboles de proyecto. La copia se verificará por SHA-256
   antes de abrir el ZIP.

## Bloque de ejecución en el portátil

### 1. Inventario de solo lectura

- edición, versión, build y arquitectura de Windows;
- nombre del equipo y función prevista;
- usuario ordinario y disponibilidad de elevación UAC;
- espacio libre, estado general de Defender/Firewall y actualizaciones;
- adaptadores de red presentes, dejando MAC/IP de sede sin confirmar hasta la
  visita;
- presencia previa de Qontrolmed, Python, Git, MySQL o herramientas relacionadas;
- estado de cifrado del disco, sin modificarlo.

No se registrarán contraseñas, identificadores personales innecesarios ni datos
sensibles.

### 2. Verificación del kit

1. Copiar el kit a una carpeta local controlada.
2. comparar el SHA-256 del ZIP con el fichero lateral;
3. extraerlo y ejecutar `scripts\verificar_paquete_qontrolmed_rc.ps1` con el
   commit esperado `c79bcec8099724cadfc37fae6aa14f50a28c4d11`;
4. confirmar ausencia de `.env`, datos reales y residuos de otra instalación.

### 3. Decisión de rol

Con el inventario observado se decidirá una de estas rutas:

- **herramienta de transporte/administración**: conservar el kit verificado y
  preparar únicamente utilidades necesarias para la futura ventana;
- **puesto Qontrolmed de prueba**: realizar un ensayo local aislado de
  instalación, ACL, configuración sintética, smoke test y desinstalación;
- **máquina de desarrollo**: detenerse y preparar un bloque separado de clon,
  dependencias y seguridad. Esta ruta no se presume autorizada por el presente
  plan.

No se configurará conectividad real con `srv-mm-01`, identidad MySQL por puesto,
CA de sede ni `.env` productivo durante esta fase.

### 4. Cierre

- retirar configuración y CA sintéticas, temporales y extracciones que no sean
  necesarias;
- conservar el ZIP original y su hash en una ubicación controlada;
- registrar resultados y límites sin secretos;
- actualizar el relevo indicando únicamente si corresponde pasar a `sede`.

## Validación

- inventario real del portátil documentado;
- SHA-256 externo e interno del paquete correctos;
- función del portátil decidida explícitamente;
- si se ensaya como puesto: instalación, ACL, arranque, verificación y
  desinstalación correctos y sin residuos;
- ningún acceso al servidor, sede o datos reales;
- ninguna copia completa innecesaria de los repositorios.

## Reversión

La inspección es de solo lectura. Las copias del kit pueden retirarse por ruta
exacta. Cualquier instalación de ensayo se revierte con el desinstalador de la
RC y la retirada controlada de su configuración sintética, conservando
evidencia depurada. Si aparece una instalación previa o un riesgo no previsto,
se detendrá antes de modificarla.

## Criterio de cierre

La fase portátil termina cuando el equipo está inventariado, el kit está
verificado, su función está decidida y todo ensayo autorizado queda aceptado o
revertido. Solo entonces el relevo podrá indicar el paso a `sede`, sin redactar
ni ejecutar por adelantado su plan.

## Cierre observado el 21 de noviembre de 2026

### Inventario depurado

- Windows Core (Home) 26H2, compilación 26300.9974, arquitectura ARM64.
- Unidad `C:` con 371,6 GiB libres; sesión sin elevar y UAC habilitado.
- OpenSSH disponible (`ssh`, `scp`, `sftp` y `ssh-keygen`).
- Git disponible en el entorno de Codex; Python solo apareció como alias de
  WindowsApps. No se observaron instalaciones registradas de Qontrolmed,
  Python, MySQL o MariaDB antes del ensayo.
- No aparecieron las dos marcas de reinicio pendiente consultadas. Defender,
  Firewall y cifrado de `C:` no se cerraron en este inventario y deberán
  revalidarse antes de usar el portátil como puesto real.

No se conservaron en la evidencia nombres de usuario, MAC, direcciones locales
domésticas ni otros identificadores innecesarios.

### Kit y compatibilidad

- El SHA-256 del ZIP coincidió con el fichero lateral y con la huella esperada:
  `4618C7258347106E0E62F920E9214E6940B11FA4057B10EDD3F9AB2B64D542DB`.
- El verificador oficial cotejó 7.875 archivos, el SBOM y la ausencia de un
  `.env` real para el commit
  `c79bcec8099724cadfc37fae6aa14f50a28c4d11`.
- El ejecutable declara PE `8664` (x64). Windows ARM64 pudo iniciar el proceso
  x64 y este respondió; no se validó inicio de sesión ni conexión con MySQL.
- El kit completo local y su copia en USB contenían los 11 archivos declarados;
  sus manifiestos, tamaños y SHA-256 coincidieron y no había archivos
  adicionales dentro de las carpetas del kit.

### Ensayo local y reversión

- El portátil quedó decidido como herramienta de administración/transporte y
  puesto de prueba local.
- La instalación aislada en las rutas estándar de `Program Files` y
  `ProgramData` finalizó correctamente partiendo de rutas ausentes.
- El verificador sin elevar confirmó ACL de `.env` y CA sintéticos, lectura y
  ejecución de la aplicación y escritura en salidas.
- La configuración sintética apuntó a `127.0.0.1`; el puerto local 3306
  rechazaba conexiones antes del arranque. No se contactó con el servidor.
- El desinstalador ejecutó simulación y retirada real. Las dos rutas de ensayo
  desaparecieron y se retiró la CA temporal.

### Resultado y límites

La fase `portátil` queda **completada**. El equipo está preparado para
transportar el kit y para administración por OpenSSH durante una ventana
aprobada. No se ha iniciado la fase `sede`, no se ha creado una identidad SSH,
no se ha conectado con `srv-mm-01` y no se han configurado red, MySQL, CA de
sede, SFTPGo ni Cloudflared.
