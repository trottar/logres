#!/usr/bin/env python3
"""Copy the newest Logres SavedVariables file to a stable local artifact."""

from pathlib import Path
import shutil
import sys

WOW_ROOT = Path("/mnt/c/Program Files (x86)/World of Warcraft")
PATTERN = "_classic_beta_/WTF/Account/*/SavedVariables/Logres.lua"

matches = list(WOW_ROOT.glob(PATTERN))
if not matches:
    raise SystemExit("No Forever Logres SavedVariables file found.")

source = max(matches, key=lambda path: path.stat().st_mtime)
target = Path.cwd() / "LOGRES_DIAGNOSTICS_LATEST.lua"

shutil.copy2(source, target)

print(target)
print(f"source={source}")
