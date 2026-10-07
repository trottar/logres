#!/usr/bin/env python3
"""Project Logres repository-memory health checker."""

from __future__ import annotations

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
MEM = ROOT / "docs" / "memory"

REQUIRED_FILES = [
    MEM / "AGENTS.md",
    MEM / "CURRENT.md",
    MEM / "MEMORY.md",
    MEM / "LEARNINGS.md",
    MEM / "MAINTENANCE.md",
    MEM / "DESIGN_PRINCIPLES.md",
    MEM / "handoffs" / "CURRENT_HANDOFF.md",
    MEM / "roadmap" / "STATUS.md",
    ROOT / "docs" / "ROADMAP.md",
]

CURRENT_HEADINGS = [
    "## Active Objective",
    "## Current Work Item",
    "## Verified State",
    "## Next Action",
    "## Success Criteria",
    "## Do Not Reopen Without New Evidence",
    "## Relevant References",
]

def fail(msg: str, errors: list[str]) -> None:
    errors.append(msg)

def main() -> int:
    errors: list[str] = []
    warnings: list[str] = []

    for path in REQUIRED_FILES:
        if not path.is_file():
            fail(f"missing required file: {path.relative_to(ROOT)}", errors)

    current = MEM / "CURRENT.md"
    if current.is_file():
        text = current.read_text(encoding="utf-8")
        for heading in CURRENT_HEADINGS:
            count = len(
                re.findall(rf"(?m)^{re.escape(heading)}[ 	]*$", text)
            )
            if count != 1:
                fail(
                    f"CURRENT heading {heading!r} occurs {count} times; expected exactly 1",
                    errors,
                )

        if len(text.encode("utf-8")) > 20_000:
            fail("CURRENT.md exceeds 20 KB hard maintenance threshold", errors)
        elif len(text.encode("utf-8")) > 10_000:
            warnings.append("CURRENT.md exceeds 10 KB soft maintenance threshold")

        objective = re.search(
            r"## Active Objective\s+(.*?)(?=\n## |\Z)", text, flags=re.S
        )
        next_action = re.search(
            r"## Next Action\s+(.*?)(?=\n## |\Z)", text, flags=re.S
        )
        if not objective or not objective.group(1).strip():
            fail("CURRENT.md has no substantive Active Objective", errors)
        if not next_action or not next_action.group(1).strip():
            fail("CURRENT.md has no substantive Next Action", errors)

    memory = MEM / "MEMORY.md"
    if memory.is_file():
        size = len(memory.read_bytes())
        if size > 60_000:
            fail("MEMORY.md exceeds 60 KB hard maintenance threshold", errors)
        elif size > 35_000:
            warnings.append("MEMORY.md exceeds 35 KB soft maintenance threshold")

    handoff = MEM / "handoffs" / "CURRENT_HANDOFF.md"
    if handoff.is_file():
        text = handoff.read_text(encoding="utf-8")
        if "CURRENT.md" not in text:
            fail("CURRENT_HANDOFF.md must point readers to CURRENT.md", errors)
        size = len(text.encode("utf-8"))
        if size > 15_000:
            fail("CURRENT_HANDOFF.md exceeds 15 KB hard maintenance threshold", errors)
        elif size > 8_000:
            warnings.append("CURRENT_HANDOFF.md exceeds 8 KB soft maintenance threshold")

    decisions = MEM / "decisions"
    if decisions.is_dir():
        ids = {}
        for path in sorted(decisions.glob("D-*.md")):
            match = re.match(r"(D-\d+)_", path.name)
            if not match:
                warnings.append(f"decision file has nonstandard name: {path.name}")
                continue
            did = match.group(1)
            if did in ids:
                fail(f"duplicate decision ID {did}: {ids[did].name}, {path.name}", errors)
            ids[did] = path

    # Important policy phrases should remain explicit.
    agents = MEM / "AGENTS.md"
    if agents.is_file():
        atext = agents.read_text(encoding="utf-8").lower()
        for phrase in ("user owns all commits and pushes", "failures are project knowledge"):
            if phrase not in atext:
                fail(f"AGENTS.md missing required policy phrase: {phrase!r}", errors)

    print("Logres memory health")
    print("====================")
    if warnings:
        for w in warnings:
            print(f"WARNING: {w}")
    if errors:
        for e in errors:
            print(f"ERROR: {e}")
        print(f"\nFAILED: {len(errors)} error(s), {len(warnings)} warning(s)")
        return 1

    print(f"PASS: 0 errors, {len(warnings)} warning(s)")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
