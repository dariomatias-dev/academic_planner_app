#!/usr/bin/env bash
# Prints a hash fingerprinting the current state of the workspace: the
# last commit plus every uncommitted change (staged, unstaged and
# untracked). Two runs print the same hash only if nothing was added,
# removed or edited in between.
#
# Used by verify.sh to skip a full --all run when nothing changed
# since the last one that passed.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

{
  git rev-parse HEAD
  git diff HEAD
  git ls-files --others --exclude-standard -z | sort -z |
    xargs -0 -I{} sh -c 'echo {}; cat {}'
} | sha256sum | cut -d' ' -f1
