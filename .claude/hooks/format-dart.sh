#!/usr/bin/env bash
# PostToolUse hook: formats the .dart file Claude just wrote or edited.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

file_path=$(jq -r '.tool_input.file_path // empty')

if [[ -z "$file_path" || "$file_path" != *.dart || ! -f "$file_path" ]]; then
  exit 0
fi

fvm dart format "$file_path" > /dev/null
