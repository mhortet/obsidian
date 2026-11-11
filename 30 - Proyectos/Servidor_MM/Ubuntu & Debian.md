---
tags:
  - aprendizaje
  - conocimiento
  - sistema
Creado: 2026-10-01
Autor:
Relacionado:
---
## Resumen

## Descripción


# Bitácora de Configuración: Ubuntu Server + Docker + Almacenamiento Cloud

## 📑 1. Contexto Inicial: Ubuntu vs. Kubuntu
La diferencia principal radica en el **entorno de escritorio** (interfaz gráfica) que utilizan por defecto. Ambos comparten la misma base de sistema y los mismos repositorios de software.

*   **Ubuntu (GNOME):** Diseño moderno, minimalista y limpio con un dock vertical a la izquierda. Ideal para quienes buscan simplicidad "out-of-the-box".
*   **Kubuntu (KDE Plasma):** Diseño clásico similar a Windows (barra de tareas inferior y menú de inicio). Ofrece una personalización extremadamente avanzada y profunda.

---

## 🖥️ 2. Elección del Sistema Operativo para Servidor
Para un entorno de servidor, la recomendación técnica es evitar las versiones de escritorio (Ubuntu/Kubuntu) e instalar **Ubuntu Server** directamente.

### ¿Por qué Ubuntu Server y no las versiones de escritorio?
*   **Sin interfaz gráfica (GUI):** No consume recursos (RAM/CPU) en renderizar escritorios. Toda la potencia queda libre para los servicios.
*   **Eficiencia:** Arranca consumiendo entre **300 MB y 500 MB de RAM**, frente a los 1 GB o 2 GB que requieren los entornos gráficos.
*   **Seguridad:** Menos paquetes instalados se traducen en menos vulnerabilidades potenciales y mayor estabilidad a largo plazo.

### 📊 Ubuntu Server vs. Debian (Enfoque Servidor)
Aunque Ubuntu está basado en Debian, para este escenario **Ubuntu Server** ofrece ventajas prácticas sobre Debian:

| Característica | Ubuntu Server 🐧 | Debian 🌀 |
| :--- | :--- | :--- |
| **Facilidad de uso** | **Muy alta**. Automatiza gran parte de la configuración. | **Media**. Requiere más configuración manual post-instalación. |
| **Actualización** | Paquetes más modernos y actualizados. | Paquetes más antiguos pero extremadamente probados. |
| **Soporte/Comunidad** | Documentación masiva. La mayoría de tutoriales usan Ubuntu. | Comunidad orientada a usuarios más experimentados. |
| **Drivers** | Incluye drivers privativos por defecto. | Filosofía 100% software libre (complicado para ciertos drivers). |
| **Soporte LTS** | **5 años garantizados** (ampliables a 10 con Ubuntu Pro gratis). | Aprox. 3 años (más 2 de soporte extendido comunitario). |

> 💡 **Conclusión:** Ubuntu Server es ideal por la "regla del copiar y pegar" (el 90% de guías de Docker y Nginx están escritas para él) y por el acceso gratuito a **Ubuntu Pro** (hasta 5 máquinas) para soporte de seguridad extendido.

---

## 🛠️ 3. Arquitectura del Proyecto (Servicios a Montar)
La infraestructura se desplegará utilizando **Docker y Docker Compose** para mantener el sistema limpio, aislado y fácil de respaldar.

1.  **Servidor Web y Base de Datos:** Nginx + MySQL corriendo en contenedores independientes.
2.  **Alternativa a OneDrive (Servidor de archivos):** **Nextcloud** como opción principal, ya que replica la experiencia de almacenamiento en la nube (calendario, contactos, edición en línea y aplicaciones móviles integradas con MySQL).

---

## 🌐 4. Acceso Remoto: Toma de Decisión (Para el Cliente)
Al tratarse de una infraestructura aislada desde cero (en una red distinta a proyectos previos como Home Assistant), se definieron dos caminos para el acceso remoto. 

### 📊 Comparativa: VPN vs. Cloudflare Tunnel

| Característica | VPN (WireGuard / Tailscale) 🔒 | Cloudflare Tunnel 🌐 |
| :--- | :--- | :--- |
| **Público vs. Privado** | **Privado**. Solo acceden dispositivos con la app/llave instalada. | **Público (Protegido)**. Cualquier navegador web entra si sabe la URL. |
| **Facilidad para compartir** | **Mala**. Un tercero o cliente externo no podrá abrir un enlace de descarga directo. | **Excelente**. Permite generar un enlace de Nextcloud y enviarlo a cualquiera. |
| **Seguridad Base** | **Máxima**. El servidor es 100% invisible en internet. | **Alta**. Escondido tras la IP de Cloudflare, pero la URL es indexable. |
| **Complejidad de Red** | Muy baja usando **Tailscale** (Zero-Config). | Requiere comprar y configurar un **dominio propio**. |
| **Uso de Apps Móviles** | Exige encender la VPN en el móvil para que Nextcloud sincronice en segundo plano. | Las apps conectan directo a la URL de forma transparente (`://empresa.com`). |

### 📌 Criterio de recomendación para el cliente:
*   **Elegir Cloudflare Tunnel:** Si busca un comportamiento idéntico a OneDrive/Google Drive, donde se necesite compartir archivos con clientes externos mediante enlaces web y sincronizar móviles sin fricción.
*   **Elegir VPN (Tailscale):** Si el servidor es estrictamente para uso interno, desarrollo personal o administración privada de bases de datos, priorizando la invisibilidad en la red.

---

## ⏳ 5. Siguientes Pasos (Pendiente de Validación)
Una vez el cliente decida el método de acceso (Túnel vs. VPN), los pasos técnicos a seguir serán:
1.  Preparar el medio de instalación e instalar **Ubuntu Server** base.
2.  Instalar **Docker y Docker Compose**.
3.  Escribir el archivo `docker-compose.yml` para desplegar la pila **Nextcloud + MySQL**.
4.  Configurar la capa de red elegida (Tailscale o el daemon de Cloudflare).
