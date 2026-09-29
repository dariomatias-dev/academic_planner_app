<p align="center">
<strong>English</strong> · <a href="contributing.pt-BR.md">Português (BR)</a> · <a href="contributing.es.md">Español</a>
</p>

# Contributing

## Setup

The Flutter SDK version is pinned via [fvm](https://fvm.app/) (`.fvmrc`). After cloning:

```bash
fvm flutter pub get
git config core.hooksPath .githooks
```

The second command activates two git hooks:
- `commit-msg` rejects commits that don't follow [Conventional Commits](#commit-and-branch-conventions).
- `pre-push` runs [the local gate](#the-local-gate) before every push.

## Before opening a pull request

- [ ] Code follows the project's structure and layering rules — see [Architecture](architecture.md) and [CLAUDE.md](../CLAUDE.md#where-code-goes).
- [ ] `fvm dart format .` was run.
- [ ] `fvm flutter analyze` reports no issues (`very_good_analysis` lint set).
- [ ] New or changed behavior has test coverage; `test/` mirrors `lib/` — see [CLAUDE.md](../CLAUDE.md#tests).
- [ ] README, this document, or other docs are updated if the change affects them — see [CLAUDE.md](../CLAUDE.md#side-effects).
- [ ] The commit message follows [Conventional Commits](#commit-and-branch-conventions).
- [ ] One logical change per PR; keep it small and reviewable.

## The local gate

```bash
scripts/verify.sh --all
```

Mirrors what CI checks: formatting, analysis, tests and the coverage floor. See the [Scripts table](../README.md#scripts) for the other available modes.

## What CI checks

| Job                | What it does                                                                                                          | Gates merge? |
| -------------------- | -------------------------------------------------------------------------------------------------------------------- | --------------- |
| `analyze-and-test` | `build_runner build` (fails if generated `*.g.dart` files differ from the committed ones), `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test --coverage`, then an 80% coverage floor check (`scripts/check_coverage.sh`) | Yes           |
| `osv-scan`         | Scans `pubspec.lock` with [OSV-Scanner](https://github.com/google/osv-scanner) for dependencies with known vulnerabilities | No (`continue-on-error: true`) |
| `integration`      | Runs every `integration_test/*_test.dart` suite on an Android API 35 emulator (KVM), one suite at a time with the app force-stopped in between (`scripts/integration.sh`). Runs after `analyze-and-test` succeeds | No (new; will gate once it is stable) |
| `build_apk`        | Builds the release APK (`flutter build apk --release`) and uploads it as a workflow artifact, kept for 14 days. Runs after `analyze-and-test` succeeds | No (depends on `analyze-and-test`, which does) |

It runs on every push and pull request to `main`, and can also be triggered manually (`workflow_dispatch`). The Flutter version is read from `.fvmrc`, so it always matches what's pinned locally. Superseded runs on the same branch are cancelled automatically.

## Reproducing CI locally

`scripts/verify.sh --all` runs the same checks, in the same order, as the `analyze-and-test` job. A green local run is a strong signal, not a guarantee — CI installs its own toolchain from scratch and can surface issues a warm local environment hides.

## Working with an AI agent

This repository carries agent configuration for use with Claude Code:
- [CLAUDE.md](../CLAUDE.md) — commands, where code goes, testing conventions, commit scope, and the step-by-step working protocol.
- `.claude/settings.json` and `.claude/hooks/` — hooks that format on write and run the local gate before finishing a turn.

Changing the working agreement or hooks is a normal change to this repository, reviewed like any other — open a PR.

## Dependency updates

[Renovate](https://docs.renovatebot.com/) opens PRs for outdated dependencies, configured in `renovate.json`. GitHub Actions and Firebase packages (`firebase_*`, `cloud_firestore`) are each grouped into a single PR; everything else gets its own. `intl` is excluded — it must match the exact version `flutter_localizations` pins for the current Flutter SDK, so it's bumped by [upgrading Flutter](#setup), never on its own.

A Renovate PR is triaged like any other: it only merges once [the local gate](#the-local-gate) and CI are green.

## Version flow

Releases are automated by [release-please](https://github.com/googleapis/release-please), driven entirely by Conventional Commits on `main`:

1. Every push to `main` runs the `release-please` workflow, which keeps a "release PR" up to date — its title, version bump and `CHANGELOG.md` entries are derived from the commits merged since the last release (`feat` → minor, `fix` → patch, a `!`/`BREAKING CHANGE` footer → major).
2. Merging that PR bumps the version in `pubspec.yaml`, updates `CHANGELOG.md`, and creates a GitHub Release with a matching tag.
3. Publishing the release triggers the `release` workflow, which builds the release APK and attaches it to that release as `academic_planner-<tag>.apk`.

Nothing about the version is edited by hand — `pubspec.yaml`'s version and `CHANGELOG.md` are release-please-managed files.

## Release signing

Release builds fall back to the debug key unless `android/key.properties` exists (see `android/app/build.gradle.kts`). To sign a release build locally:

1. Generate a keystore:
   ```bash
   keytool -genkey -v -keystore ~/academic-planner-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias academic-planner
   ```
2. Create `android/key.properties` (gitignored — never commit it or the `.jks` file):
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=academic-planner
   storeFile=/absolute/path/to/academic-planner-release.jks
   ```
3. `fvm flutter build apk --release` now signs with that keystore.

## Commit and branch conventions

This project follows [Conventional Commits](https://www.conventionalcommits.org):

```
<type>(<scope>): <subject>
```

- **type**: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`, `perf`, `build`, `ci`, `revert`
- **scope**: optional, lowercase, e.g. `activities`, `schedule`, `seeds`
- **subject**: imperative mood, no trailing period, ≤72 chars

Examples:

```
feat(activities): add recurring activity support
fix(schedule): prevent overlapping class entries
refactor(seeds): encapsulate repository creation in ActivitySeed
```

Body (optional) explains *why*, not *what* — the diff already shows what changed.

Branch names: `<type>/<short-description>` (e.g. `feat/recurring-activities`, `fix/schedule-overlap`).

`main` is protected: no direct pushes, merges only via pull request. Squash or rebase merge only — no merge commits, to keep history linear and each entry a valid Conventional Commit. For this repo (single maintainer), self-merge after CI passes is allowed; branch protection still requires the PR flow and passing checks.

