---
title: "Documentación de pytest"
source: "https://docs.pytest.org/en/stable/index.html"
author:
published:
created: 2026-07-17
description:
tags:
  - "clippings"
---
## pytest: te ayuda a escribir mejores programas

Este `pytest` marco de trabajo facilita la escritura de pruebas pequeñas y legibles, y puede ampliarse para admitir pruebas funcionales complejas para aplicaciones y bibliotecas.

**Nombre del paquete PyPI**: [pytest](https://pypi.org/project/pytest)

## Un ejemplo rápido

```python
# content of test_sample.py
def inc(x):
    return x + 1

def test_answer():
    assert inc(3) == 5
```

Para ejecutarlo:

```
$ pytest
=========================== test session starts ============================
platform linux -- Python 3.x.y, pytest-9.x.y, pluggy-1.x.y
rootdir: /home/sweet/project
collected 1 item

test_sample.py F                                                     [100%]

================================= FAILURES =================================
_______________________________ test_answer ________________________________

    def test_answer():
>       assert inc(3) == 5
E       assert 4 == 5
E        +  where 4 = inc(3)

test_sample.py:6: AssertionError
========================= short test summary info ==========================
FAILED test_sample.py::test_answer - assert 4 == 5
============================ 1 failed in 0.12s =============================
```

Debido a `pytest` la introspección detallada de aserciones, solo `assert` se utilizan sentencias simples. Consulte [la sección Primeros pasos](https://docs.pytest.org/en/stable/getting-started.html#getstarted) para obtener una introducción básica al uso de pytest.

## Características

- Información detallada sobre [sentencias assert](https://docs.pytest.org/en/stable/how-to/assert.html#assert) que fallan (no es necesario recordar `self.assert*` los nombres).
- [Detección automática](https://docs.pytest.org/en/stable/explanation/goodpractices.html#test-discovery) de módulos y funciones de prueba
- [Dispositivos modulares](https://docs.pytest.org/en/stable/reference/fixtures.html#fixture) para la gestión de recursos de prueba pequeños o parametrizados de larga duración.
- Puede ejecutar conjuntos de pruebas [unittest](https://docs.pytest.org/en/stable/how-to/unittest.html#unittest) (incluidas las de prueba) directamente.
- Python 3.10+ o PyPy 3
- Arquitectura de plugins robusta, con más de 1300 [plugins externos](https://docs.pytest.org/en/stable/reference/plugin_list.html#plugin-list) y una comunidad próspera.

## Documentación

- [Empieza ya](https://docs.pytest.org/en/stable/getting-started.html#get-started): instala pytest y aprende sus conceptos básicos en solo veinte minutos.
- [Guías prácticas](https://docs.pytest.org/en/stable/how-to/index.html#how-to): guías paso a paso que abarcan una amplia gama de casos de uso y necesidades.
- [Guías de referencia](https://docs.pytest.org/en/stable/reference/index.html#reference): incluye la referencia completa de la API de pytest, listas de complementos y más.
- [Explicación](https://docs.pytest.org/en/stable/explanation/index.html#explanation): antecedentes, análisis de temas clave, respuestas a preguntas de nivel superior.

## Errores/Solicitudes

Utilice el [sistema de seguimiento de incidencias de GitHub](https://github.com/pytest-dev/pytest/issues) para informar de errores o solicitar nuevas funcionalidades.

## Soporte para pytest

[Open Collective](https://opencollective.com/) es una plataforma de financiación en línea para comunidades abiertas y transparentes. Proporciona herramientas para recaudar fondos y compartir tus finanzas con total transparencia.

Es la plataforma preferida por particulares y empresas que desean realizar donaciones puntuales o mensuales directamente al proyecto.

Para obtener más detalles, consulte el [colectivo pytest](https://opencollective.com/pytest).

## pytest para empresas

Disponible como parte de la suscripción a Tidelift.

Los responsables del mantenimiento de pytest y miles de otros paquetes colaboran con Tidelift para ofrecer soporte y mantenimiento comercial para las dependencias de código abierto que utilizas en tus aplicaciones. Ahorra tiempo, reduce riesgos y mejora la calidad de tu código, mientras apoyas directamente a los responsables del mantenimiento de las dependencias que utilizas.

[Más información.](https://tidelift.com/subscription/pkg/pypi-pytest?utm_source=pypi-pytest&utm_medium=referral&utm_campaign=enterprise&utm_term=repo)

### Seguridad

Si ha encontrado un problema que cree que es una vulnerabilidad de seguridad, no cree un nuevo problema; en su lugar, infórmelo mediante un [nuevo aviso de seguridad](https://github.com/pytest-dev/pytest/security/advisories/new).