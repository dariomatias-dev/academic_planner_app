#!/usr/bin/env bash
# Fails if line coverage in an lcov report is below a minimum percentage.
# Lines from generated files (*.g.dart) are excluded from the totals,
# since they are never meant to be hand-tested.
#
# Usage:
#   scripts/check_coverage.sh <lcov-file> <minimum-percent>
#
# Example:
#   scripts/check_coverage.sh coverage/lcov.info 90

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <lcov-file> <minimum-percent>" >&2
  exit 1
fi

LCOV_FILE="$1"
MIN_PERCENT="$2"

if [[ ! -f "$LCOV_FILE" ]]; then
  echo "Coverage file not found: $LCOV_FILE" >&2
  exit 1
fi

LC_ALL=C awk -v min="$MIN_PERCENT" '
  /^SF:/ {
    file = substr($0, 4)
    skip = (file ~ /\.g\.dart$/)
  }
  /^DA:/ && !skip {
    split(substr($0, 4), parts, ",")
    found++
    if (parts[2] + 0 > 0) hit++
  }
  END {
    if (found == 0) {
      print "No coverable lines found in " ARGV[1] > "/dev/stderr"
      exit 1
    }
    percent = (hit / found) * 100
    printf "Coverage: %.2f%% (%d/%d lines), minimum: %s%%\n", percent, hit, found, min
    if (percent + 0 < min + 0) {
      print "Coverage is below the minimum." > "/dev/stderr"
      exit 1
    }
  }
' "$LCOV_FILE"
