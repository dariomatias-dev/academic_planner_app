<p align="center">
<a href="contributing.md">English</a> · <a href="contributing.pt-BR.md">Português (BR)</a> · <strong>Español</strong>
</p>

# Contribuir

## Configuración

La versión del Flutter SDK está fijada vía [fvm](https://fvm.app/) (`.fvmrc`). Después de clonar:

```bash
fvm flutter pub get
git config core.hooksPath .githooks
```

El segundo comando activa dos hooks de git:
- `commit-msg` rechaza commits que no siguen [Conventional Commits](#convenciones-de-commit-y-branch).
- `pre-push` ejecuta [el gate local](#el-gate-local) antes de cada push.

## Antes de abrir un pull request

- [ ] El código sigue la estructura y las reglas de capas del proyecto — ver [Arquitectura](architecture.es.md) y [CLAUDE.md](../CLAUDE.md#where-code-goes).
- [ ] Se ejecutó `fvm dart format .`.
- [ ] `fvm flutter analyze` no reporta problemas (lints de `very_good_analysis`).
- [ ] El comportamiento nuevo o modificado tiene cobertura de tests; `test/` refleja `lib/` — ver [CLAUDE.md](../CLAUDE.md#tests).
- [ ] El README, este documento u otra doc se actualizaron si el cambio los afecta — ver [CLAUDE.md](../CLAUDE.md#side-effects).
- [ ] El mensaje de commit sigue [Conventional Commits](#convenciones-de-commit-y-branch).
- [ ] Un cambio lógico por PR; mantenlo pequeño y revisable.

## El gate local

```bash
scripts/verify.sh --all
```

Refleja lo que verifica el CI: formato, análisis, tests y el piso de cobertura. Ver la [tabla de Scripts](../README.es.md#scripts) para los otros modos disponibles.

## Qué verifica el CI

| Job                | Qué hace                                               | ¿Bloquea el merge? |
| -------------------- | ----------------------------------------------------------- | --------------------- |
| `analyze-and-test` | `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test` | Sí                  |

## Reproduciendo el CI localmente

`scripts/verify.sh --all` se aproxima al job `analyze-and-test` (más un piso de cobertura que el CI todavía no verifica). Una ejecución local en verde es una señal fuerte, no una garantía - el CI instala su propio toolchain desde cero y puede revelar problemas que un entorno local "caliente" oculta.

## Trabajar con un agente de IA

Este repositorio incluye configuración de agente para usar con Claude Code:
- [CLAUDE.md](../CLAUDE.md) — comandos, dónde va el código, convenciones de tests, alcance de los commits y el protocolo de trabajo paso a paso.
- `.claude/settings.json` y `.claude/hooks/` — hooks que formatean al escribir y ejecutan el gate local antes de finalizar un turno.

Cambiar el acuerdo de trabajo o los hooks es un cambio normal en este repositorio, revisado como cualquier otro — abre un PR.

## Convenciones de commit y branch

Este proyecto sigue [Conventional Commits](https://www.conventionalcommits.org):

```
<type>(<scope>): <subject>
```

- **type**: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`, `perf`, `build`, `ci`, `revert`
- **scope**: opcional, en minúsculas, ej: `activities`, `schedule`, `seeds`
- **subject**: modo imperativo, sin punto final, ≤72 caracteres

Ejemplos:

```
feat(activities): add recurring activity support
fix(schedule): prevent overlapping class entries
refactor(seeds): encapsulate repository creation in ActivitySeed
```

El cuerpo (opcional) explica *por qué*, no *qué* — el diff ya muestra qué cambió.

Nombres de branch: `<type>/<descripción-corta>` (ej: `feat/recurring-activities`, `fix/schedule-overlap`).

`main` está protegida: sin push directo, merges solo vía pull request. Solo squash o rebase merge - sin merge commits, para mantener el historial lineal y que cada entrada sea un Conventional Commit válido. Para este repositorio (mantenedor único), el self-merge después de que el CI pase está permitido; la protección de branch igual exige el flujo de PR y los checks en verde.

