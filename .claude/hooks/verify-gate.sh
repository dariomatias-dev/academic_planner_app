#!/usr/bin/env bash
# Stop hook: runs the local verify gate (scoped to pending changes) so the
# repository stays green after every turn. Blocks the stop (exit 2) on
# failure so the agent sees the error and can fix it before finishing.

set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

if scripts/verify.sh; then
  exit 0
fi

echo "scripts/verify.sh failed — fix the issues above before stopping." >&2
exit 2
