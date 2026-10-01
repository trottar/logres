#!/usr/bin/env python3
"""Static structure checks for the Project Logres addon."""

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
TOC = ADDON / "Logres.toc"

errors = []

if not TOC.is_file():
    errors.append("missing Logres/Logres.toc")
else:
    text = TOC.read_text(encoding="utf-8")

    if "## Interface: 16001" not in text:
        errors.append("Logres.toc must declare Forever interface 16001")

    if "## SavedVariables: LogresDB" not in text:
        errors.append("Logres.toc must declare SavedVariables: LogresDB")

    file_entries = []
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if not line or line.startswith("##"):
            continue
        file_entries.append(line)

    if not file_entries:
        errors.append("Logres.toc contains no source-file entries")

    for entry in file_entries:
        relative = entry.replace("\\", "/")
        path = ADDON / relative
        if not path.is_file():
            errors.append(f"TOC entry does not exist: {entry}")

for lua_path in sorted(ADDON.rglob("*.lua")):
    source = lua_path.read_text(encoding="utf-8")
    if "table.pack(" in source:
        errors.append(
            f"{lua_path.relative_to(ROOT)} uses table.pack, which failed on Forever"
        )

print("Logres addon structure")
print("======================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
