# Qontrolmed

Qontrolmed es una aplicación de escritorio Python/Tkinter para la gestión
técnica hospitalaria. El primer alcance del piloto comprende Gestión mínima,
Preventivos y Quirófanos. Compras y analítica ampliada están diferidas y no
deben mostrarse en la navegación del piloto.

## Estado

**Piloto privado de evaluación; NO-GO para producción o distribución
comercial.** El objetivo actual es una implantación limitada en una empresa
conocida, sin venta ni difusión pública. Los requisitos comerciales quedan
diferidos; se mantienen los controles técnicos necesarios para no comprometer
datos, seguridad o recuperación.

La fuente vigente del análisis y la hoja de ruta es:

- [Auditoría y plan de producción](docs/02_planes_y_arquitectura/AUDITORIA-Y-PLAN-PRODUCCION-MAXGESTH-2026-11-10.md)
- [Plan de adaptación documental](docs/02_planes_y_arquitectura/PLAN-ADAPTACION-DOCUMENTAL-MAXGESTH-AL-MODELO-SERVIDOR-2026-11-10.md)
- [Relevo de la siguiente sesión](CONTINUAR-SIGUIENTE-SESION.md)
- [Guía didáctica de sesiones y comandos](docs/04_guias_didacticas/GUIA-DIDACTICA-DE-SESIONES-Y-COMANDOS.md)
- [Plan activo de ejecución P0](docs/02_planes_y_arquitectura/PLAN-EJECUCION-P0-PRODUCCION-READINESS-2026-11-11.md)
- [Decisión de piloto privado](docs/01_gobierno_y_decisiones/DECISION-PILOTO-PRIVADO-EVALUACION-2026-11-11.md)

## Arquitectura resumida

- aplicación de escritorio en `src/`;
- tres esquemas MySQL: `gestion`, `preventivos` y `quirofanos`;
- SQL base, bootstrap y migraciones en `bd/`;
- build, instalación y verificaciones en `scripts/`;
- pruebas automatizadas en `tests/`;
- recursos PDF aprobados en `pdf_assets/`.

La configuración local de desarrollo puede existir en `compartido/.env`, pero
está ignorada por Git y no debe copiarse a documentación, builds ni evidencias.
En una instalación RC la configuración pertenece a
`C:\ProgramData\Qontrolmed\config\`.

## Estructura documental

```text
docs/
├── 00_seguimiento/              # estados, diario, backlog y releases
├── 01_gobierno_y_decisiones/    # alcance, roles y políticas
├── 02_planes_y_arquitectura/    # planes y especificaciones vigentes
├── 03_operacion_y_runbooks/     # instalación, migración y validación
├── 04_guias_didacticas/         # manuales de usuario
├── 05_evidencias/               # evidencias depuradas y contexto de campo
├── 07_recursos/                 # plantillas reutilizables
└── 90_archivo/                  # material sustituido e histórico formativo
```

El histórico conserva decisiones y aprendizaje, pero no define el estado
actual. Su procedencia está documentada en `docs/90_archivo/README.md`.

Cada sesión técnica relevante deja una nota formativa en
`docs/00_seguimiento/diario/`. La guía didáctica anterior explica el método,
los comandos y el vocabulario común y debe leerse al iniciar una sesión.

## Preparación local

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python -m unittest discover -s tests -v
```

Estos comandos no configuran MySQL ni autorizan el uso de datos reales. Para
builds o instalación deben seguirse los runbooks de
`docs/03_operacion_y_runbooks/`.

## Repositorios y sistema relacionados

- Preventivos móvil: `D:\trabajo\Proyectos\maxgesth_port`.
- Quirófanos móvil: `D:\trabajo\Proyectos\maxgestq_mov`.
- Infraestructura prevista: `H:\02.Trabajo\obsidian\30 - Proyectos\Servidor_MM`.

Las rutas externas son dependencias de contexto y deben revalidarse antes de
usarlas; este repositorio continúa siendo la fuente de verdad del código de
Qontrolmed.
