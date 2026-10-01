#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 '/mnt/c/.../Interface/AddOns'" >&2
  exit 2
fi

ADDONS="$1"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/LogresAPIAudit"

if [[ ! -d "$ADDONS" ]]; then
  echo "AddOns directory does not exist: $ADDONS" >&2
  exit 1
fi

rm -rf "$ADDONS/LogresAPIAudit"
cp -a "$SRC" "$ADDONS/LogresAPIAudit"

echo "Installed LogresAPIAudit -> $ADDONS/LogresAPIAudit"
