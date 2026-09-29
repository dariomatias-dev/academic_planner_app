#!/usr/bin/env bash
# Runs every integration_test/*_test.dart suite (except screenshot_test.dart,
# which needs `flutter drive` and real Firebase; see scripts/screenshot.sh) on the connected device or
# emulator, one at a time, force-stopping the app between suites so each
# one starts from a cold process.
#
# Usage:
#   scripts/integration.sh [device-id]
#
# Run `fvm flutter devices` to list available device ids. Defaults to the
# only connected device if there's just one.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

APP_ID="br.com.dariomatias.academic_planner"
FLUTTER="flutter"
command -v fvm >/dev/null 2>&1 && FLUTTER="fvm flutter"

DEVICE_ARGS=()
ADB_ARGS=()
if [[ "${1:-}" != "" ]]; then
  DEVICE_ARGS=(-d "$1")
  ADB_ARGS=(-s "$1")
fi

status=0
for suite in integration_test/*_test.dart; do
  [[ "$suite" == *screenshot_test.dart ]] && continue
  echo "==> $suite"
  $FLUTTER test "$suite" "${DEVICE_ARGS[@]}" || status=1
  adb "${ADB_ARGS[@]}" shell am force-stop "$APP_ID" || true
done

exit "$status"
