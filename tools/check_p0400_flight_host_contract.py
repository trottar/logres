#!/usr/bin/env python3
"""Preserve P0400 failure evidence and guard against reviving its native host."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
source = (root / "Logres/Quest/FlightWindow.lua").read_text(encoding="utf-8")
evidence = (root / "docs/memory/evidence/P0401_FLIGHT_RECOVERY.md").read_text(encoding="utf-8")
assert "6551" in evidence and "stock-layout-unsupported" in evidence
assert "opens=0" in evidence and "restores=0" in evidence
assert 'hooksecurefunc' not in source and 'setParent(' not in source
assert 'or not normalizeScale(changes, root)' in source
assert 'hostGate = probed and gate or "probe-error"' in source
assert "P0400_FLIGHT_HOST.md" in (root / "docs/memory/investigations/ISSUE_LEDGER.md").read_text(encoding="utf-8")
print("P0400 failure evidence and retired hosting mutations: PASS (STATIC)")
