#!/usr/bin/env python3
"""P0374: canonical issue-first triage contract (documentation only)."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def read(path):
    return (ROOT / path).read_text(encoding="utf-8")

def require(condition, reason):
    if not condition:
        raise AssertionError("P0374 issue ledger: " + reason)

ledger_path = "docs/memory/investigations/ISSUE_LEDGER.md"
ledger = read(ledger_path)
agent = read("docs/memory/AGENTS.md")
current = read("docs/memory/CURRENT.md")
handoff = read("docs/memory/handoffs/CURRENT_HANDOFF.md")
old = read("docs/memory/investigations/ISSUE_REGISTER.md")

require("first reference for every Logres bug" in ledger,
        "first-reference rule missing")
require("root cause, actual change, patch and verified pushed commit" in ledger,
        "runtime closure evidence requirement missing")
require("never" in ledger.lower() and "static checker" in ledger.lower(),
        "static pass must not close runtime bugs")
require("without an intentional quest interaction" in ledger,
        "new random quest GUI report must remain distinct")
require("mandatory first lookup" in agent.lower() and ledger_path in agent,
        "AGENTS lacks first issue lookup")
require(ledger_path in current and ledger_path in handoff,
        "CURRENT or handoff lacks first issue lookup")
require(old.startswith("# ISSUE LEDGER FIRST:" + " `" + ledger_path + "`"),
        "historical register does not route to new ledger")
require("## P0373" in old and "## P0329" in old,
        "original issue history was replaced")

row_pat = re.compile(
    r"^\| (L-\d{3}) \| ([^|]+) \| "
    r"(OPEN|PARTIAL|DEFERRED|BLOCKED|RESOLVED-SCOPE|RESOLVED-DOCS|RESOLVED-TOOLING) "
    r"\| ([^|]+) \| ([^|]+) \| ([^|]+) \|$"
)
rows = [m.groups() for line in ledger.splitlines()
        if (m := row_pat.fullmatch(line))]
expected = [f"L-{i:03d}" for i in range(1, 39)]
require([row[0] for row in rows] == expected,
        "must contain precisely one ordered issue row for L-001..L-038")
for identifier, title, status, attempted, verified, evidence in rows:
    require(all(x.strip() for x in (title, attempted, verified, evidence)),
            identifier + " lacks status/resolution/verification/evidence")
    if status.startswith("RESOLVED"):
        require("PASS" in verified or "R3" in attempted or "P0322" in attempted,
                identifier + " marked resolved without scoped evidence")
statuses = {r[0]: r[2] for r in rows}
for identifier in ("L-001", "L-002", "L-033", "L-034"):
    require(statuses[identifier] == "OPEN", identifier + " silently closed")
require(statuses["L-005"] == "PARTIAL" and statuses["L-019"] == "BLOCKED",
        "quest variants or public release gate silently closed")
require(statuses["L-021"] == "RESOLVED-SCOPE",
        "observed no-pet PASS lost its limited scope")
for marker in ("incident **764**", "P0373", "user report", "screenshot"):
    require(marker.lower() in ledger.lower(), "missing new incident context: " + marker)
require(len(current.encode("utf-8")) < 9800,
        "CURRENT.md exceeded historical size bound")
require(len(handoff.encode("utf-8")) < 8000,
        "CURRENT_HANDOFF.md exceeded historical size bound")
for path in ("docs/memory/evidence/P0374_ISSUE_LEDGER_FIRST.md",
             "docs/memory/patches/P0374_ISSUE_LEDGER_FIRST.md"):
    evidence_text = read(path)
    require("P0374" in evidence_text and "L-034" in evidence_text
            and "L-033" in evidence_text and "P0373" in evidence_text,
            path + " missing continuity")
print("P0374 issue ledger: PASS (DOCS ONLY; WoW UNCHANGED)")
