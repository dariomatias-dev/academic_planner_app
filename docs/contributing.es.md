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

| Job                | Qué hace                                                                                                              | ¿Bloquea el merge? |
| -------------------- | -------------------------------------------------------------------------------------------------------------------- | --------------------- |
| `analyze-and-test` | `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test --coverage`, y luego verifica el piso de cobertura del 93% (`scripts/check_coverage.sh`) | Sí                  |
| `osv-scan`         | Escanea `pubspec.lock` con [OSV-Scanner](https://github.com/google/osv-scanner) en busca de dependencias con vulnerabilidades conocidas | No (`continue-on-error: true`) |
| `build_apk`        | Compila el APK de release (`flutter build apk --release`) y lo sube como artefacto del workflow, retenido 14 días. Corre después de que `analyze-and-test` pasa | No (depende de `analyze-and-test`, que sí bloquea) |

Se ejecuta en cada push y pull request a `main`, y también puede dispararse manualmente (`workflow_dispatch`). La versión de Flutter se lee de `.fvmrc`, así que siempre coincide con lo fijado localmente. Las ejecuciones superadas en la misma branch se cancelan automáticamente.

## Reproduciendo el CI localmente

`scripts/verify.sh --all` ejecuta las mismas verificaciones, en el mismo orden, que el job `analyze-and-test`. Una ejecución local en verde es una señal fuerte, no una garantía - el CI instala su propio toolchain desde cero y puede revelar problemas que un entorno local "caliente" oculta.

## Trabajar con un agente de IA

Este repositorio incluye configuración de agente para usar con Claude Code:
- [CLAUDE.md](../CLAUDE.md) — comandos, dónde va el código, convenciones de tests, alcance de los commits y el protocolo de trabajo paso a paso.
- `.claude/settings.json` y `.claude/hooks/` — hooks que formatean al escribir y ejecutan el gate local antes de finalizar un turno.

Cambiar el acuerdo de trabajo o los hooks es un cambio normal en este repositorio, revisado como cualquier otro — abre un PR.

## Actualizaciones de dependencias

[Renovate](https://docs.renovatebot.com/) abre PRs para dependencias desactualizadas, configurado en `renovate.json`. Las GitHub Actions y los paquetes de Firebase (`firebase_*`, `cloud_firestore`) se agrupan cada uno en un solo PR; el resto tiene su propio PR. `intl` está excluido — debe coincidir exactamente con la versión que `flutter_localizations` fija para el Flutter SDK actual, así que se actualiza [junto con Flutter](#configuración), nunca por su cuenta.

Un PR de Renovate se triaje como cualquier otro: solo se mergea una vez que [el gate local](#el-gate-local) y el CI estén en verde.

## Flujo de versión

Los releases son automatizados por [release-please](https://github.com/googleapis/release-please), guiado enteramente por los Conventional Commits en `main`:

1. Cada push a `main` ejecuta el workflow `release-please`, que mantiene un "release PR" actualizado — título, bump de versión y entradas del `CHANGELOG.md` se derivan de los commits mergeados desde el último release (`feat` → minor, `fix` → patch, un footer `!`/`BREAKING CHANGE` → major).
2. Al mergear ese PR se sube la versión en `pubspec.yaml`, se actualiza el `CHANGELOG.md`, y se crea un GitHub Release con su tag correspondiente.
3. Publicar el release dispara el workflow `release`, que compila el APK de release y lo adjunta a ese release como `academic_planner-<tag>.apk`.

Nada de la versión se edita a mano — `pubspec.yaml` y `CHANGELOG.md` son archivos gestionados por release-please.

## Firma de release

Las builds de release usan la clave de debug a menos que exista `android/key.properties` (ver `android/app/build.gradle.kts`). Para firmar una build de release localmente:

1. Genera un keystore:
   ```bash
   keytool -genkey -v -keystore ~/academic-planner-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias academic-planner
   ```
2. Crea `android/key.properties` (ignorado por git — nunca lo commitees, ni el `.jks`):
   ```properties
   storePassword=<contraseña>
   keyPassword=<contraseña>
   keyAlias=academic-planner
   storeFile=/ruta/absoluta/a/academic-planner-release.jks
   ```
3. `fvm flutter build apk --release` ahora firma con ese keystore.

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

