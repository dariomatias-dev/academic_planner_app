#!/usr/bin/env bash
# Local verification gate mirroring CI: format, analyze, test and a
# coverage floor.
#
# By default, format and analyze are scoped to pending Dart changes
# (staged, unstaged and untracked) for fast feedback; tests always run
# in full, since coverage can only be judged against the whole suite.
#
# Usage:
#   scripts/verify.sh [--all] [--skip-tests]
#
#   --all         Check the entire repository instead of just pending
#                 changes. Skipped entirely if the workspace hasn't
#                 changed since the last successful --all run.
#   --skip-tests  Skip running tests and the coverage check.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

COVERAGE_FLOOR=93
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
    } | sort -u | while read -r f; do [[ -f "$f" ]] && echo "$f"; done
  )
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

if $ALL && ! $SKIP_TESTS; then
  mkdir -p "$(dirname "$STAMP_FILE")"
  scripts/workspace_hash.sh > "$STAMP_FILE"
fi

echo "Verify passed."
