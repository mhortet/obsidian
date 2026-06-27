---
tags:
  - desarrollo
  - software
Creado: 2026-06-27
Relacionado:
---

En programación, un fixture es un ==estado o conjunto de datos iniciales y predecibles diseñado para preparar un entorno antes de ejecutar una prueba de software== (test unitario). Garantiza la coherencia, ya que prepara las condiciones necesarias y limpia los recursos una vez finalizada la ejecución. [1, 2]

## Propósitos principales

- Preparación (Setup): Define los datos concretos o el estado del sistema necesarios para que la prueba funcione correctamente.
- Limpieza (Teardown): Restablece el entorno a su estado original para evitar que los resultados de una prueba afecten a las siguientes. [1, 2]

## Uso práctico (Ejemplo en Python)

En marcos de trabajo populares como [Pytest](https://docs.pytest.org/en/stable/explanation/fixtures.html), los fixtures son componentes reutilizables.

Por ejemplo, si necesitas simular una base de datos con usuarios ficticios para realizar distintas pruebas, puedes definir un fixture de la siguiente manera:

1. Creación: El fixture conecta a una base de datos temporal y carga los usuarios.
2. Inyección: Se pasa automáticamente como argumento a las funciones de prueba que lo requieren.
3. Restauración: Una vez que la prueba termina, el fixture borra los datos temporales para dejar el entorno limpio. [1, 2, 3, 4]

## Términos relacionados 

- **Mock / Stub:** No los confundas con los fixtures. Los _fixtures_ son los datos o el entorno real listos para usarse. Los _mocks_ son "imitaciones" o piezas falsas que simulan ser componentes reales (como simular que un banco nos da el visto bueno a un pago sin hacer el cobro de verdad).
- **Setup y Teardown:** Son las dos fases del fixture. _Setup_ es cuando pones la mesa (creas los datos). _Teardown_ es cuando recoges la mesa (borras los datos).
- **Estado determinista:** Es la meta de un fixture. Significa que la prueba siempre empezará exactamente igual, garantizando que si algo falla, sea por un error en tu código y no porque los datos cambiaron.