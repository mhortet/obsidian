---
tags:
  - software
  - docker
Creado: 2026-06-10
Autor:
  - Notebooklm
Relacionado:
---
## Resumen

## Descripción



Guía Práctica de Docker: Domina la Línea de Comandos desde Cero

1. Fundamentos: El "Qué" y el "Por qué" de Docker

Docker es una **plataforma de virtualización a nivel de sistema operativo** que permite empaquetar una aplicación junto con sus dependencias y librerías en una unidad estandarizada llamada **contenedor**. A diferencia de las máquinas virtuales (VM), Docker no virtualiza el hardware, sino que abstrae el kernel del sistema operativo anfitrión para crear entornos aislados.

Esta magia es posible gracias a dos funcionalidades críticas del kernel de Linux:

- **Namespaces:** Proporcionan el aislamiento (que un proceso no vea a otros).
- **Control Groups (Cgroups):** Gestionan la asignación de recursos (CPU, memoria, red).

Comparativa: Máquina Virtual (VM) vs. Contenedor

|Característica|Máquina Virtual (VM)|Contenedor (Docker)|
|---|---|---|
|**Aislamiento**|A nivel de Hardware (Hypervisor)|A nivel de Kernel (Namespaces/Cgroups)|
|**Peso**|Gigabytes (Incluye un SO completo)|Megabytes (Solo app y dependencias)|
|**Tiempo de arranque**|Minutos|Milisegundos|
|**Kernel**|Propio por cada VM|Compartido con el Host|

**Insight del Mentor:** Como arquitectos, usamos Docker para estandarizar el **Runtime**. Esto elimina el "en mi máquina funciona", garantizando que el entorno de desarrollo sea idéntico al de producción. Es la base de los microservicios y la escalabilidad moderna.

_Ahora que conoces la arquitectura, es hora de gestionar tu biblioteca de software: las imágenes._

---

2. Gestión de Imágenes: Tu Biblioteca de Software

Una **imagen** es una plantilla de solo lectura que contiene las instrucciones para crear un contenedor. Piensa en ella como una "clase" en programación o una receta; el contenedor será la "instancia" o el plato cocinado.

El concepto de Capas (Layers)

Las imágenes de Docker no son bloques monolíticos. Son **capas tras capas de imágenes** (por ejemplo, una base de Linux Alpine, luego Node.js, luego tu código). Docker reutiliza estas capas para ahorrar espacio; si dos imágenes comparten la misma base de Linux, solo se descarga una vez.

Comandos de gestión

```
# Descarga una imagen desde Docker Hub
docker pull node:18          # Descarga la versión específica 18
docker pull mongo            # Descarga la etiqueta 'latest' por defecto

# Lista lo que tienes en el disco local
docker images                # Muestra repositorios, etiquetas y tamaños

# Borrado de imágenes para liberar espacio
docker image rm node:18      # También puedes usar el comando corto: docker rmi
```

_Una imagen en el disco es una receta estática; el siguiente paso es darle vida ejecutando procesos._

---

3. El Ciclo de Vida del Contenedor: De la Creación a la Ejecución

El contenedor es la instancia viva de una imagen. Es fundamental entender que un contenedor es un proceso aislado que corre directamente sobre el kernel del host.

Flujo lógico y comandos

1. **Instanciación (****create****):** Prepara el contenedor. Ocupa espacio en disco, pero **consume 0% de CPU y RAM**.
2. **Activación (****start****):** Inicia el proceso interno.
3. **Monitoreo (****ps****):** Supervisa el estado.
4. **Detención (****stop****):** Apaga el proceso de forma elegante (graceful shutdown).

```
# Crear un contenedor (Shorthand de 'docker container create')
docker create mongo          # Crea la instancia y devuelve un ID largo

# Iniciar o detener
docker start [ID_o_Nombre]   # Pone en marcha el proceso
docker stop [ID_o_Nombre]    # Detiene la ejecución

# Listar estados
docker ps                    # Muestra solo contenedores activos
docker ps -a                 # Muestra el historial (activos y detenidos)
```

**Insight del Mentor:** Saber que `docker create` es el paso previo al `start` es vital para flujos de automatización complejos donde configuramos el entorno antes de encender el interruptor.

---

4. Port Mapping: Abriendo Puertas al Mundo Exterior

Docker utiliza un aislamiento de red estricto. Un servicio corriendo en el puerto `27017` dentro de un contenedor es invisible para tu navegador o tus herramientas locales. El **Port Mapping** crea un puente entre tu máquina física (Host) y la red interna de Docker.

Sintaxis Crítica

Usamos la bandera `-p [Puerto Host]:[Puerto Contenedor]`.

**Diagrama de flujo de red:**

```
[Petición Externa/Local] -> [Host Port: 27017] -> [Docker Bridge] -> [Container Port: 27017]
```

**Ejemplo con MongoDB:** `docker create -p 27017:27017 mongo` Aquí, cualquier tráfico que llegue al puerto 27017 de tu PC será redirigido al puerto 27017 del contenedor de Mongo.

---

5. La Navaja Suiza: El comando `docker run`

El comando `docker run` es la síntesis de `pull`, `create` y `start`. Es el comando que más usarás, pero requiere una advertencia de arquitecto.

**⚠️ ADVERTENCIA:** Cada vez que ejecutas `docker run`, creas un **NUEVO** contenedor. No lo uses para reiniciar un contenedor ya existente; para eso usa `docker start`. Si usas `run` repetidamente, llenarás tu sistema de contenedores duplicados.

El Comando Maestro (Detached Mode)

El modo **Detached** (`-d`) permite que el contenedor corra en segundo plano, liberando tu terminal.

```
# Ejecución profesional de MongoDB
docker run -d --name mi-db -p 27017:27017 mongo
```

🍎 Pro-Tip para Apple Silicon (M1/M2/M3)

Si intentas correr imágenes como `mysql` o versiones antiguas de `mongo` en Mac con arquitectura ARM y recibes errores, debes forzar la plataforma: `docker run -d --platform linux/amd64 --name mi-db -p 27017:27017 mongo`

---

6. Visibilidad y Limpieza Final

Un entorno DevOps saludable es un entorno limpio. Debes auditar tus procesos y eliminar lo que ya no sirve.

Comandos de Visibilidad

```
# Ver los logs (salida de la aplicación)
docker logs mi-db            # Muestra el historial actual
docker logs -f mi-db         # --follow: Streaming en tiempo real (vital para debug)
```

Checklist de Limpieza Arquitectónica

Para dejar tu sistema impecable, sigue este orden:

1. **Detener:** `docker stop [Nombre]`
2. **Eliminar Contenedor:** `docker rm [Nombre]`
3. **Eliminar Imagen:** `docker rmi [Nombre_Imagen]`
4. **Limpieza Profunda (Opcional):** `docker system prune` (Elimina contenedores detenidos, redes no usadas y capas huérfanas).

**Insight Final:** Al dominar estos comandos, has dejado de "instalar software" para empezar a "orquestar servicios". Docker no es solo una herramienta, es la infraestructura que permite que tu código escale al infinito de forma eficiente. ¡Bienvenido al ecosistema Cloud Native!
