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

| Job                | What it does                                          | Gates merge? |
| -------------------- | -------------------------------------------------------- | --------------- |
| `analyze-and-test` | `dart format --set-exit-if-changed`, `flutter analyze`, `flutter test` | Yes           |

## Reproducing CI locally

`scripts/verify.sh --all` approximates the `analyze-and-test` job (plus a coverage floor CI doesn't check yet). A green local run is a strong signal, not a guarantee — CI installs its own toolchain from scratch and can surface issues a warm local environment hides.

## Working with an AI agent

This repository carries agent configuration for use with Claude Code:
- [CLAUDE.md](../CLAUDE.md) — commands, where code goes, testing conventions, commit scope, and the step-by-step working protocol.
- `.claude/settings.json` and `.claude/hooks/` — hooks that format on write and run the local gate before finishing a turn.

Changing the working agreement or hooks is a normal change to this repository, reviewed like any other — open a PR.

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

