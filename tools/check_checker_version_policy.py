#!/usr/bin/env python3
"""Reject historical runtime-version freezes in durable feature checkers."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
TOOLS = ROOT / "tools"
SELF = Path(__file__).resolve()
VERSION_LITERAL = re.compile(r"\b0\.0\.\d+-dev\b")
errors = []
for path in sorted(TOOLS.glob("check_*.py")):
    if path.resolve() == SELF:
        continue
    matches = sorted(set(VERSION_LITERAL.findall(path.read_text(encoding="utf-8"))))
    if matches:
        errors.append(f"{path.relative_to(ROOT)} freezes historical runtime version(s): " + ", ".join(matches))
print("Logres checker runtime-version policy")
print("====================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} checker(s) contain exact runtime-version pins")
    raise SystemExit(1)
print("PASS: 0 historical runtime-version pins")
