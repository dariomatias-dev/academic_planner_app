# Contributing

## Setup

After cloning, enable the repo's git hooks:

```bash
git config core.hooksPath .githooks
```

This activates a `commit-msg` hook that rejects commits not following the
convention below, and a `pre-push` hook that runs `scripts/verify.sh --all`
before every push.

## Commit convention

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

Body (optional) explains *why*, not *what* — the diff already shows what
changed.

## Branching

- `main` is protected: no direct pushes, merges only via pull request.
- Branch names: `<type>/<short-description>` (e.g. `feat/recurring-activities`,
  `fix/schedule-overlap`).

## Pull requests

- One logical change per PR; keep it small and reviewable.
- CI (`analyze-and-test`) must pass before merge.
- Squash or rebase merge only — no merge commits, to keep history linear
  and each entry a valid Conventional Commit.
- For this repo (single maintainer), self-merge after CI passes is allowed;
  branch protection still requires the PR flow and passing checks.

## Code style

- Follows `very_good_analysis` lints.
- Run `dart format .` before committing.

## Local verification

`scripts/verify.sh` mirrors what CI checks: formatting, analysis, tests and
a coverage floor (currently 93%, see `scripts/check_coverage.sh`).

```bash
scripts/verify.sh              # pending changes only, fast feedback
scripts/verify.sh --all        # entire repository, like CI
scripts/verify.sh --skip-tests # skip the test run and coverage check
```

By default, formatting and analysis are scoped to files with pending
changes (staged, unstaged and untracked); tests always run in full, since
coverage can only be judged against the whole suite. `--all` is skipped
automatically if the workspace hasn't changed since the last successful
`--all` run (tracked via `.dart_tool/verify_stamp`).

The `pre-push` hook (see [Setup](#setup)) runs `scripts/verify.sh --all`
automatically, so a push fails locally instead of in CI.
