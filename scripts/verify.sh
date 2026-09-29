#!/usr/bin/env bash
# Local verification gate mirroring CI: code generation, format, analyze,
# test and a coverage floor, for the app and for packages/app_ui.
#
# By default, format and analyze are scoped to pending Dart changes
# (staged, unstaged and untracked) for fast feedback (packages/app_ui is
# checked only when it has pending changes, or with --all); tests always run
# in full, since coverage can only be judged against the whole suite.
#
# Usage:
#   scripts/verify.sh [--all] [--skip-tests]
#
#   --all         Check the entire repository instead of just pending
#                 changes, and fail if regenerating code changes any
#                 *.g.dart file. Skipped entirely if the workspace hasn't
#                 changed since the last successful --all run.
#   --skip-tests  Skip running tests and the coverage check.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

COVERAGE_FLOOR=80
APP_UI_DIR="packages/app_ui"
APP_UI_COVERAGE_FLOOR=80
STAMP_FILE=".dart_tool/verify_stamp"

ALL=false
SKIP_TESTS=false
for arg in "$@"; do
  case "$arg" in
    --all) ALL=true ;;
    --skip-tests) SKIP_TESTS=true ;;
    *)
      echo "Unknown option: $arg" >&2
      echo "Usage: $0 [--all] [--skip-tests]" >&2
      exit 1
      ;;
  esac
done

if $ALL && [[ -f "$STAMP_FILE" ]] &&
  [[ "$(scripts/workspace_hash.sh)" == "$(cat "$STAMP_FILE")" ]]; then
  echo "Workspace unchanged since the last full verify. Skipping."
  exit 0
fi

DART_FILES=()
if ! $ALL; then
  mapfile -t DART_FILES < <(
    {
      git diff --name-only HEAD -- '*.dart'
      git diff --cached --name-only -- '*.dart'
      git ls-files --others --exclude-standard -- '*.dart'
    } | sort -u | while read -r f; do
      [[ -f "$f" && "$f" != "$APP_UI_DIR"/* ]] && echo "$f"
    done
  )
fi

generated_hash() {
  find lib -name '*.g.dart' -print0 | sort -z | xargs -0 sha256sum | sha256sum
}

echo "==> Generating code"
GENERATED_BEFORE="$(generated_hash)"
fvm dart run build_runner build
if [[ "$(generated_hash)" != "$GENERATED_BEFORE" ]]; then
  if $ALL; then
    echo "Generated code is out of date; commit the regenerated *.g.dart files." >&2
    exit 1
  fi
  echo "Generated code was out of date and has been regenerated."
fi

echo "==> Formatting"
if $ALL; then
  fvm dart format --output=none --set-exit-if-changed lib test integration_test
elif [[ ${#DART_FILES[@]} -gt 0 ]]; then
  fvm dart format --output=none --set-exit-if-changed "${DART_FILES[@]}"
else
  echo "No pending Dart changes, nothing to format."
fi

echo "==> Analyzing"
if $ALL; then
  fvm flutter analyze
elif [[ ${#DART_FILES[@]} -gt 0 ]]; then
  fvm flutter analyze "${DART_FILES[@]}"
else
  echo "No pending Dart changes, nothing to analyze."
fi

if $SKIP_TESTS; then
  echo "==> Skipping tests (--skip-tests)"
else
  echo "==> Testing"
  fvm flutter test --coverage

  echo "==> Checking coverage floor ($COVERAGE_FLOOR%)"
  scripts/check_coverage.sh coverage/lcov.info "$COVERAGE_FLOOR"
fi

if $ALL || [[ -n "$(git status --porcelain -- "$APP_UI_DIR")" ]]; then
  echo "==> app_ui: dependencies"
  (cd "$APP_UI_DIR" && fvm flutter pub get)

  echo "==> app_ui: formatting"
  (cd "$APP_UI_DIR" && fvm dart format --output=none --set-exit-if-changed lib test)

  echo "==> app_ui: analyzing"
  (cd "$APP_UI_DIR" && fvm flutter analyze)

  if ! $SKIP_TESTS; then
    echo "==> app_ui: testing"
    (cd "$APP_UI_DIR" && fvm flutter test --coverage)

    # A package with no library code yet has no lines to measure.
    if grep -q '^DA:' "$APP_UI_DIR/coverage/lcov.info"; then
      echo "==> app_ui: checking coverage floor ($APP_UI_COVERAGE_FLOOR%)"
      scripts/check_coverage.sh "$APP_UI_DIR/coverage/lcov.info" "$APP_UI_COVERAGE_FLOOR"
    fi
  fi
fi

if $ALL && ! $SKIP_TESTS; then
  mkdir -p "$(dirname "$STAMP_FILE")"
  scripts/workspace_hash.sh > "$STAMP_FILE"
fi

echo "Verify passed."
