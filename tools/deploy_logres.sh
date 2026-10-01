#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$ROOT/Logres"

ADDONS_DIR="${1:-${LOGRES_ADDONS_DIR:-}}"

if [[ -z "$ADDONS_DIR" ]]; then
  echo "Usage: $0 '/mnt/c/.../Interface/AddOns'" >&2
  echo "Or set LOGRES_ADDONS_DIR." >&2
  exit 2
fi

if [[ ! -d "$ADDONS_DIR" ]]; then
  echo "AddOns directory does not exist: $ADDONS_DIR" >&2
  exit 1
fi

if [[ "$(basename "$ADDONS_DIR")" != "AddOns" ]]; then
  echo "Refusing to deploy: destination basename must be AddOns." >&2
  exit 1
fi

if [[ ! -f "$SOURCE/Logres.toc" ]]; then
  echo "Source addon is incomplete: $SOURCE/Logres.toc not found." >&2
  exit 1
fi

DESTINATION="$ADDONS_DIR/Logres"

rm -rf "$DESTINATION"
cp -a "$SOURCE" "$DESTINATION"

echo "Deployed Logres -> $DESTINATION"
