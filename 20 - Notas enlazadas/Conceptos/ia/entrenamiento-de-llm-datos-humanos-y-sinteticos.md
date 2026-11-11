---
title: "Entrenamiento de LLM con datos humanos y sintéticos"
type: concept
status: active
created: 2026-07-18
updated: 2026-07-18
sources:
  - "20 - Notas enlazadas/Fuentes/2026-07-18-video-ramon-lopez-de-mantaras-gran-mentira-ia.md"
tags: [ia, llm, entrenamiento, datos-sinteticos, calidad]
review_after: 2026-10-18
---

# Entrenamiento de LLM con datos humanos y sintéticos

## Definición

Entrenar un modelo de lenguaje no es una operación única. Incluye preentrenamiento autosupervisado sobre corpus, ajuste con instrucciones, optimización mediante preferencias, evaluación y posibles actualizaciones posteriores con datos de uso. Cada etapa puede combinar datos humanos y sintéticos con funciones diferentes.

## Distinciones esenciales

- **Dato humano original:** texto, imagen, código, conversación o demostración producida por personas.
- **Dato anotado:** ejemplo al que una persona o sistema añade una etiqueta, comparación, puntuación o corrección.
- **Dato sintético:** ejemplo generado o transformado por otro modelo.
- **Feedback de uso:** valoración o interacción recogida durante el despliegue y potencialmente seleccionada para una actualización futura.
- **Inferencia:** generación con un modelo ya entrenado; normalmente no cambia sus parámetros.
- **Supervisión operativa:** intervención humana ante excepciones; no debe confundirse con entrenamiento.

## Regla sobre calidad

La dicotomía «humano bueno / sintético malo» es incorrecta. Importan:

- procedencia y licencia;
- exactitud y señal útil;
- diversidad y cobertura de casos raros;
- deduplicación y contaminación de pruebas;
- proporción entre datos originales y generados;
- modelo generador y método de verificación;
- adecuación al objetivo;
- trazabilidad de transformaciones.

Los datos sintéticos recursivos y no filtrados pueden estrechar la distribución y acumular errores. Si se conservan datos reales, se seleccionan muestras de calidad y se verifican resultados, los datos sintéticos pueden mejorar razonamiento, cobertura de tareas y eficiencia.

## Colapso de modelo

El colapso de modelo es una degradación generacional en la que un modelo entrenado sobre salidas de modelos anteriores pierde información sobre la distribución real, empezando por eventos poco frecuentes. No es sinónimo de usar cualquier dato sintético y no es inevitable en todas las mezclas.

Condiciones de riesgo:

- sustitución de datos reales por generaciones sintéticas;
- ausencia de procedencia;
- filtrado por popularidad que elimina las colas;
- errores sistemáticos del modelo generador;
- evaluación sobre benchmarks contaminados o demasiado estrechos.

Mitigaciones:

- preservar corpus humanos y datos de alta calidad;
- acumular en lugar de reemplazar indiscriminadamente;
- etiquetar procedencia y versión del generador;
- verificar con reglas, herramientas o expertos;
- medir diversidad, calibración y rendimiento fuera de distribución;
- mantener conjuntos de evaluación independientes y posteriores al corte de entrenamiento.

## Trabajo humano y responsabilidad

Aunque el cálculo sea automático, el sistema es sociotécnico. Personas deciden qué datos entran, qué salidas son preferibles, qué daños se toleran y cuándo se despliega. Esto crea obligaciones sobre trabajo digno, privacidad, sesgo, propiedad intelectual, documentación y rendición de cuentas.

La existencia de intervención humana no convierte al modelo en fraude. Sí invalida presentarlo como completamente autónomo y exige distinguir entre capacidad aprendida, asistencia operativa y trabajo oculto.

## Fuentes base

- [InstructGPT: ajuste con demostraciones y preferencias humanas](https://cdn.openai.com/papers/Training_language_models_to_follow_instructions_with_human_feedback.pdf).
- [The Llama 3 Herd of Models](https://arxiv.org/abs/2407.21783).
- [Phi-4: datos sintéticos estratégicos y calidad](https://arxiv.org/abs/2412.08905).
- [Colapso por entrenamiento recursivo, *Nature* 2024](https://www.nature.com/articles/s41586-024-07566-y).
- [Cómo evitar el colapso acumulando datos reales y sintéticos](https://arxiv.org/abs/2404.01413).
- [Leyes de escala para modelos de lenguaje](https://arxiv.org/abs/2001.08361).
- [Chinchilla y equilibrio entre parámetros, datos y cómputo](https://arxiv.org/abs/2203.15556).

## Relaciones

- [[2026-07-18-video-ramon-lopez-de-mantaras-gran-mentira-ia]].
- [[2026-07-18-afirmaciones-entrenamiento-y-vision-ia-lopez-de-mantaras]].

