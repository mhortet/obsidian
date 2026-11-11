---
title: Fixture
aliases:
  - Test fixture
tags:
  - testing
  - programacion
---

# Fixture

## Definición

Un **fixture** es un conjunto conocido y controlado de datos, objetos, configuraciones, recursos o dependencias que se prepara para ejecutar una o varias pruebas de software.

Su finalidad es proporcionar a cada prueba un **estado inicial predecible**, de modo que el resultado dependa únicamente del comportamiento que se está verificando y no de condiciones externas o de ejecuciones anteriores.

Un fixture puede incluir, por ejemplo:

- Objetos ya inicializados.
- Registros de prueba en una base de datos.
- Archivos temporales.
- Configuraciones específicas.
- Usuarios, permisos o credenciales simuladas.
- Conexiones o servicios de prueba.
- Mocks, stubs o dependencias sustitutas.
- Recursos que deben liberarse al terminar la prueba.

## Ciclo de vida

Un fixture suele dividirse en tres fases:

1. **Setup**: creación y preparación del entorno necesario.
2. **Ejecución**: la prueba utiliza el fixture.
3. **Teardown**: limpieza o restauración del estado inicial.

```text
Preparar → Ejecutar prueba → Limpiar
```

## Características principales

- **Repetibilidad**: la prueba parte siempre de un estado conocido.
- **Aislamiento**: evita que una prueba afecte a otra.
- **Reutilización**: permite compartir configuraciones comunes.
- **Legibilidad**: separa la preparación del entorno de la lógica de la prueba.
- **Mantenibilidad**: centraliza cambios en datos y configuraciones de prueba.
- **Determinismo**: reduce resultados variables o dependientes del entorno.

## Ejemplo conceptual

Una prueba que verifica el cálculo del total de una compra puede necesitar:

- Una compra vacía.
- Dos productos con precios conocidos.
- Una base de datos temporal.
- Un usuario con permisos de compra.

Ese conjunto constituye el fixture de la prueba.

## Ejemplo con `pytest`

```python
import pytest

@pytest.fixture
def compra():
    return {
        "productos": [
            {"nombre": "Producto A", "precio": 10},
            {"nombre": "Producto B", "precio": 15},
        ]
    }

def test_total_compra(compra):
    total = sum(producto["precio"] for producto in compra["productos"])
    assert total == 25
```

En este ejemplo, `compra` es un fixture que proporciona datos preparados antes de ejecutar la prueba.

## Alcance de un fixture

Según el framework, un fixture puede crearse:

- Para cada prueba.
- Para una clase de pruebas.
- Para un módulo.
- Para una sesión completa de pruebas.

Un alcance más amplio mejora el rendimiento, pero puede reducir el aislamiento si el recurso es mutable.

## Fixture, mock y dato de prueba

| Concepto | Función |
|---|---|
| **Fixture** | Prepara el entorno completo de la prueba. |
| **Mock** | Sustituye una dependencia y permite verificar interacciones. |
| **Stub** | Devuelve respuestas predefinidas. |
| **Dato de prueba** | Valor concreto utilizado durante la prueba. |

Un mock o un dato de prueba pueden formar parte de un fixture, pero no son necesariamente un fixture por sí solos.

## Buenas prácticas

- Mantener los fixtures pequeños y con una responsabilidad clara.
- Evitar que compartan estado mutable entre pruebas.
- Limpiar siempre los recursos creados.
- No ocultar demasiada lógica dentro del fixture.
- Utilizar nombres que describan el estado que proporcionan.
- Preferir datos mínimos que permitan verificar el comportamiento.

## Resumen

Un fixture no es únicamente un conjunto de objetos fijos. Es el **entorno controlado de preparación y limpieza** que permite ejecutar pruebas de forma aislada, repetible y predecible.
