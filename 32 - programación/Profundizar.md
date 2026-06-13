---
tags:
  - desarrollo
  - pendiente
  - estructura
  - hard
Relacionado:
Creado: 2026-06-07
---
Estudiar la creación de un servidor en casa con varios HD que recojan, música, videos etc

Profundizar en el tema de docker


🤣🤣 No me sorprende nada. Has pasado de Git a Obsidian, de Python a ecógrafos, de una web corporativa a automatización de compras, y ahora te estás asomando al cuarto oscuro de los servidores domésticos.

Y, sinceramente, creo que es un proyecto muy adecuado para ti porque mezcla:

- Hardware.
- Linux.
- Redes.
- Automatización.
- Programación.
- Documentación.
- Aprendizaje continuo.

Además tiene una ventaja enorme: **no depende del trabajo**. Lo haces cuando te apetezca.

---

# Lo primero: no montaría un servidor "a la vieja escuela"

Hace 15-20 años la solución típica era:

```
Internet    |Router    |Servidor Linux    |Red local
```

haciendo NAT, proxy, firewall, DNS, DHCP, etc.

Hoy día eso sigue existiendo, pero para casa suele ser más interesante:

```
Internet    |Router    |MiniPC Linux    |Servicios
```

Es decir:

- El router sigue haciendo de router.
- El servidor se dedica a prestar servicios.

Mucho más sencillo.

---

# Mi planteamiento para ti

## Fase 1: NAS + servicios

Un mini PC.

Ejemplos:

- Intel N100
- Intel N95
- Lenovo Tiny usado
- HP EliteDesk Mini usado

Con:

- 16 GB RAM
- SSD sistema
- 1 o varios discos de datos

Instalas:

- Debian
- Ubuntu Server

Y ya tienes:

### Almacenamiento

- Samba

Para acceder desde:

- Windows
- Android
- Tablet
- Portátil

como si fuese un disco de red.

---

### Copias de seguridad

Tú generas muchísima documentación:

- Obsidian
- Código
- PDFs
- Manuales

Yo montaría:

```
/datos   /obsidian   /proyectos   /manuales   /fotos
```

y copia automática.

---

# Fase 2: Docker

Aquí empieza la diversión.

Instalas:

Docker

y cada servicio va en un contenedor.

Ejemplos:

- Git privado
- Wiki
- Home Assistant
- Nextcloud
- Jellyfin
- Bases de datos

---

# Fase 3: Git privado

Esto creo que te va a gustar.

Montar:

Gitea

Tendrías:

- Tus repositorios.
- Control de versiones.
- Wiki.
- Issues.
- Todo en casa.

Sin depender de terceros.

---

# Fase 4: Integrar tus proyectos

Tus aplicaciones:

- Compras.
- Quirófanos.
- Preventivos.

Podrían guardar:

- PDFs.
- Backups MySQL.
- Manuales.

directamente en el servidor.

---

# Fase 5: VPN

Cuando ya tengas confianza.

Instalar:

WireGuard

y acceder desde:

- Hospital.
- Portátil.
- Móvil.

como si estuvieras en casa.

---

# Lo que NO haría al principio

No empezaría con:

- NAT propio.
- pfSense.
- OPNsense.
- VLANs.
- Proxy transparente.
- IDS/IPS.

No porque no sean interesantes.

Porque te conozco un poco ya:

😂 Si empiezas por ahí te veo en dos semanas con:

- 4 VLAN.
- 3 switches.
- 2 AP.
- DNS local.
- Certificados.
- Reverse proxy.
- Kubernetes.

Y sin haber compartido todavía una carpeta.

---

# El orden que seguiría

1. Mini PC Linux.
2. Compartir discos por Samba.
3. Docker.
4. Gitea.
5. Backups automáticos.
6. VPN.
7. Reverse Proxy.
8. Redes avanzadas.

Ese recorrido te puede dar perfectamente **un año de entretenimiento técnico** sin volverte loco y además te deja algo útil en casa desde el primer día.

Y siendo como eres, sospecho que terminarías documentándolo todo en una bóveda de Obsidian llamada algo parecido a:

```
Infraestructura├── Linux├── Docker├── Redes├── Gitea├── Servidor└── Lecciones aprendidas
```

...que es donde realmente empieza a ponerse interesante 😎.


Si quieres aprender Docker de verdad, yo haría este recorrido:

### 1. Documentación oficial (imprescindible)

**Docker Get Started**

[Docker Get Started](https://docs.docker.com/get-started/?utm_source=chatgpt.com)

Empieza por aquí. Tiene ejemplos guiados y es la referencia oficial.

**Qué es Docker**

[What is Docker?](https://docs.docker.com/get-started/docker-overview/?utm_source=chatgpt.com)

Explica muy bien la filosofía detrás de los contenedores.

---

### 2. Curso en español para entender conceptos

**Jarroba - Docker Básico**

[Docker Básico - Jarroba](https://jarroba.com/docker-basico-docker-desktop-y-objetos-docker/?utm_source=chatgpt.com)

Muy bien explicado para entender:

- Imagen
- Contenedor
- Volumen
- Red
- Dockerfile

---

### 3. Curso de YouTube (el que te recomendaría)

**Docker de Novato a Pro**

[Docker de Novato a Pro](https://www.youtube.com/watch?v=CV_Uf3Dq-EU&utm_source=chatgpt.com)

Tiene un recorrido bastante completo:

- Instalación
- Imágenes
- Contenedores
- Puertos
- Volúmenes
- Dockerfile
- Docker Compose

---

### 4. Cuando ya entiendas lo básico

**Docker 101**

[Docker 101 Tutorial](https://www.docker.com/101-tutorial/?utm_source=chatgpt.com)

Muy práctico y orientado a "hacer cosas".

---

### Lo que creo que más te va a enganchar

No estudies Docker pensando en aplicaciones web.

Estúdialo pensando en:

```
Servidor Linux│├── Gitea├── Home Assistant├── Nextcloud├── MariaDB├── Jellyfin├── MQTT├── Nginx└── Tus propias aplicaciones
```

Y cada servicio dentro de su contenedor.

Ahí es donde de repente se entiende todo.

---

### Ejercicio mental para empezar

Imagina tu futuro servidor:

```
MiniPC Linux│├── Docker│   ├── Gitea│   ├── Home Assistant│   ├── MySQL│   └── Nextcloud│└── Carpeta /datos
```

Si Home Assistant explota:

```
docker rm homeassistantdocker compose up -d
```

y en dos minutos vuelve a estar funcionando porque los datos están fuera del contenedor.

Cuando entiendas **imagen → contenedor → volumen → compose**, ya tienes el 80% de Docker dominado.

Y una cosa que te va a gustar: Docker encaja perfectamente con tu forma de trabajar de "documentar todo". Cada servicio suele quedar descrito en un único fichero `docker-compose.yml`. Acabas teniendo la infraestructura casi como si fuera código. 😎

Ok, en un rato me vuelvo pal norte, me esperan al menos 5 h de viaje, cuando llegue (si tengo ganas) reviso todo lo pensado este finde y me pongo a estudiar algo, meterme con el código no creo este centrado...

Me parece una buena idea.

Después de 5 horas de coche, meterse a depurar un bug suele acabar en:

```
Bug inicial: 1Bugs al terminar: 4Nivel de confianza: injustificadamente alto
```

😅

Yo aprovecharía la tarde/noche para cosas de baja carga mental:

- Revisar apuntes de Git y ramas.
- Leer sobre Docker.
- Organizar la bóveda de Obsidian.
- Repasar tareas pendientes del proyecto.
- Dar una vuelta a la arquitectura futura (web, servidor, móvil, etc.).
- Documentar alguna decisión que tengas clara.

El código seguirá ahí mañana.

Además, por lo que hemos ido hablando estos meses, estás entrando en una fase interesante: los proyectos principales ya tienen bastante estructura y ahora empiezan a aparecer temas de "infraestructura", organización, despliegue, documentación y mantenimiento. Son menos vistosos que programar una ventana nueva, pero suelen marcar la diferencia entre una aplicación que funciona y un ecosistema que puedes mantener durante años.

Y sobre todo, llega a casa sin prisa. Cinco horas son muchas horas. Que el objetivo principal sea llegar, y luego ya habrá tiempo para Linux, Docker, Git, Obsidian, Home Assistant, servidores, redes y todos los juguetes técnicos que tienes acumulados en la lista. 😁

Buen viaje, Maxi. 🚗💨

🤙👌👋

🤙😎

Buen viaje y cuidado con la carretera.

Y recuerda: hoy toca modo lectura, vídeos y cafés. El código no se va a escapar esta noche. 😁

Nos vemos a la vuelta. 👋🚗💨📚🐧🐳 (Linux y Docker ya te están esperando...)