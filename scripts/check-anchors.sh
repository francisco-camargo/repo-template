#!/usr/bin/env bash
# The hook config in template/ runs scripts/check-anchors.sh, which is where a
# project keeps it. This repo keeps it under template/, so pass the call on.
set -euo pipefail

exec "$(git rev-parse --show-toplevel)/template/scripts/check-anchors.sh" "$@"
