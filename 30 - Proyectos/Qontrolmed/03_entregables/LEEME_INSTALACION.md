---
tags:
  - app
  - desarrollo
  - documentacion
Creado:
Relacionado:
---

# Guia de instalacion de la RC de Qontrolmed

## Alcance

Esta receta corresponde a una unica organizacion con varios usuarios Windows.
La configuracion y las salidas son compartidas en el equipo, mientras que los
binarios quedan protegidos frente a modificacion por usuarios normales.

## Rutas

| Uso | Ruta |
| --- | --- |
| Aplicacion | `C:\Program Files\Qontrolmed\` |
| Configuracion | `C:\ProgramData\Qontrolmed\config\.env` |
| Salidas | `C:\ProgramData\Qontrolmed\output\` |
| Intercambio tablet | `C:\ProgramData\Qontrolmed\output\export_tablet\` |
| Certificados | `C:\ProgramData\Qontrolmed\docs\certificados\` |

## Modelo de permisos

- Administradores y `SYSTEM`: control total.
- Usuarios normales: lectura y ejecucion de la aplicacion.
- Usuarios normales: lectura de la configuracion.
- Usuarios normales: modificacion en salidas y certificados.

La aplicacion necesita leer las credenciales de conexion. Por ello debe usarse
una cuenta MySQL tecnica de privilegios minimos, limitada a los esquemas y al
origen de red necesarios. La proteccion del fichero evita modificaciones por
usuarios normales, pero no pretende ocultar a un usuario que ejecuta la
aplicacion una credencial que el propio proceso necesita consumir.

## Instalacion inicial

1. Verificar el ZIP y el `MANIFEST-SHA256.csv` recibido.
2. Extraer el paquete en una carpeta temporal controlada.
3. Abrir PowerShell como administrador.
4. Ejecutar desde el paquete:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\instalar_qontrolmed_rc.ps1
```

El instalador inicial se detiene si detecta contenido previo en
`C:\Program Files\Qontrolmed`. No realiza actualizaciones ni elimina versiones.
Tampoco migra certificados, salidas historicas ni ningun otro dato operativo.

## Configuracion

1. Copiar:

```text
C:\ProgramData\Qontrolmed\config\.env.example
```

como:

```text
C:\ProgramData\Qontrolmed\config\.env
```

2. Completar los valores directamente en el equipo de destino.
3. Usar `QONTROLMED_ALLOW_PASSWORDLESS_LOGIN=0`.
4. No enviar el `.env` por correo ni incorporarlo a ZIP, documentación o
   copias del programa.
5. Ejecutar como usuario normal:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verificar_qontrolmed_rc.ps1
```

La verificacion comprueba presencia y nombres de variables sin mostrar sus
valores, confirma que no existe un `.env` junto al ejecutable y prueba escritura
en la carpeta de salida compartida.

## Inicio limpio de datos operativos

Las salidas y certificados existentes en el entorno de desarrollo son ejemplos
de trabajo y no son validos para produccion. No deben copiarse ni incorporarse
al ZIP.

La primera instalacion debe comenzar con estas carpetas vacias:

- `C:\ProgramData\Qontrolmed\output`;
- `C:\ProgramData\Qontrolmed\docs\certificados`.

Solo se conservaran los subdirectorios vacios creados por el instalador. Los
informes, intercambios y certificados validos se generaran o incorporaran ya
dentro del circuito productivo, con su trazabilidad correspondiente.

## Validacion funcional minima

- iniciar sesion con contraseña y usuario normal;
- confirmar que el usuario solo ve los modulos permitidos;
- abrir `Gestion`, Preventivos y Quirofanos segun permisos;
- generar un PDF basico y comprobar que aparece bajo `ProgramData`;
- exportar e importar un fichero de prueba controlado con tablet;
- comprobar consulta y exportacion CSV de auditoria;
- cerrar y volver a abrir la aplicacion con otro usuario Windows autorizado.

## No salida

No continuar si:

- el paquete contiene un `.env` real;
- falta el manifiesto de hashes;
- la aplicacion escribe dentro de `Program Files`;
- aparecen salidas o certificados de ejemplo en `ProgramData`;
- un usuario normal puede modificar los binarios o la configuracion;
- no se ha ensayado backup/restauracion;
- falla el login normal o algun modulo necesario para el primer corte.


### Subsanar error de permisos
No reinstales otra vez esta RC. Para reparar provisionalmente la instalación, abre PowerShell explícitamente como administrador y ejecuta:

```
icacls "C:\Program Files\Qontrolmed" /inheritance:e /T /C
```

Después prueba:

```
Start-Process "C:\Program Files\Qontrolmed\Qontrolmed.exe"
```

He comprobado también que Defender no ha registrado ninguna detección relacionada con Qontrolmed, por lo que todo apunta a las ACL del instalador.

El paquete necesita una nueva RC que:

- corrija la aplicación de permisos;
- compruebe que el ejecutable puede leerse y arrancarse;
- facilite la edición administrativa inicial del `.env`.
