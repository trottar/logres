#!/usr/bin/env python3
"""Reject historical runtime-version freezes in durable feature checkers."""
from pathlib import Path, PurePosixPath
import re
ROOT = Path(__file__).resolve().parents[1]
TOOLS = ROOT / "tools"
SELF = Path(__file__).resolve()
VERSION_LITERAL = re.compile(r"\b0\.0\.\d+-dev\b")
def checker_version_pins(name, text):
    path = PurePosixPath(name)
    if path.parent != PurePosixPath("tools") or not path.match("check_*.py") or path.name == SELF.name:
        return []
    return sorted(set(VERSION_LITERAL.findall(text)))


def main():
    errors = []
    for path in sorted(TOOLS.glob("check_*.py")):
        name = path.relative_to(ROOT).as_posix()
        matches = checker_version_pins(name, path.read_text(encoding="utf-8"))
        if matches:
            errors.append(f"{name} freezes historical runtime version(s): " + ", ".join(matches))
    print("Logres checker runtime-version policy")
    print("====================================")
    if errors:
        for error in errors:
            print(f"ERROR: {error}")
        print(f"\nFAILED: {len(errors)} checker(s) contain exact runtime-version pins")
        return 1
    print("PASS: 0 historical runtime-version pins")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
