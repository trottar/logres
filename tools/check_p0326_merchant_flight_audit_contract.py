#!/usr/bin/env python3
"""P0326: source-bound merchant/flight audit; no new runtime service integration."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def read(path):
    return (ROOT / path).read_text(encoding="utf-8")

def require(ok, message):
    if not ok:
        raise AssertionError(message)

sources = {
    "policy": read("Logres/Quest/NativeServicePolicy.lua"),
    "cap": read("Logres/Quest/NativeServiceCapabilities.lua"),
    "index": read("Logres/Quest/ServiceElementIndex.lua"),
    "session": read("Logres/UI/NPCServiceSession.lua"),
    "placement": read("Logres/Quest/NativeServicePlacementTrial.lua"),
    "parking": read("Logres/UI/NPCServiceNativeParking.lua"),
    "gossip": read("Logres/Quest/NPCGossipStockParking.lua"),
    "commands": read("Logres/Core/Commands.lua"),
}
# Source guards only: if any source boundary changes, this audit requires revision.
for path, tokens in {
    "policy": ('key = "merchant"', 'native = "MerchantFrame"',
               'key = "flight"', 'native = "FlightMapFrame"',
               'nativeTransactions = "Blizzard-owned"'),
    "cap": ('name = "MerchantFrame"', 'name = "FlightMapFrame"',
            'name = "TaxiFrame"'),
    "index": ('"merchant.frame"', '"flight.frame"',
              '"TaxiFrame"', '"MerchantFrame"', 'SOURCE_CANDIDATE'),
    "session": ('Session.Register("trainer", {',
                'nativeFrame="ClassTrainerFrame"', 'TRAINER_SHOW',
                'TRAINER_UPDATE'),
    "placement": ('[5] = { key = "merchant", name = "MerchantFrame" }',),
    "parking": ('local permitted = {trainer={native="ClassTrainerFrame", interactionType=7}}',),
    "gossip": ('_G.GossipFrame',),
    "commands": ('"Native Service Frame Audit"', '"Native NPC Services Check"',
                 '"Native Auto Position (TEST)"'),
}.items():
    for token in tokens:
        require(token in sources[path], f"P0326 source boundary drift {path}: {token}")
require(len(re.findall(r'Session\.Register\("[^"\n]+",\s*\{', sources['session'])) == 1,
        "service session registry expanded beyond audited trainer-only scope")
require(not re.search(r'\b(?:merchant|flight)\s*=\s*\{', sources['parking']),
        "native service parking authorization expanded without new proof")

audit = read("docs/memory/architecture/P0326_MERCHANT_FLIGHT_AUDIT.md")
current = read("docs/memory/CURRENT.md")
launch = read("docs/memory/roadmap/LAUNCH_READINESS.md")
evidence = read("docs/memory/evidence/P0326_MERCHANT_FLIGHT_AUDIT.md")
record = read("docs/memory/patches/P0326_MERCHANT_FLIGHT_AUDIT.md")
handoff = read("docs/memory/handoffs/CURRENT_HANDOFF.md")
issues = read("docs/memory/investigations/ISSUE_REGISTER.md")
for term in ("MerchantFrame", "FlightMapFrame", "TaxiFrame", "NPCServiceSession",
             "SOURCE_CANDIDATE", "November 4", "H — Native Service Frame Audit",
             "H — Native NPC Services Check", "Native Auto Position (TEST)",
             "D-046", "D-047", "D-048", "UNVERIFIED", "P0321", "only registered live service is trainer"):
    require(term.lower() in audit.lower(), "audit missing bounded finding: " + term)
for term in ("P0326", "P0325", "c596fe2", "UNVERIFIED", "D-047", "L-003", "L-004"):
    require(term in current + audit + evidence, "required history/deferral absent: " + term)
for term in ("## Active Objective", "## Current Work Item", "## Verified State",
             "## Next Action", "## Success Criteria",
             "## Do Not Reopen Without New Evidence", "## Relevant References"):
    require(current.splitlines().count(term) == 1, "CURRENT headings drift: " + term)
for patch in ("P0317", "P0318", "P0319", "P0320", "P0321", "P0322",
              "P0323", "P0324", "P0325", "P0326"):
    require(patch in current, "historical patch missing CURRENT: " + patch)
require("CURRENT.md" in handoff and "P0326" in handoff, "handoff authority or version missing")
for term in ("P0326", "FlightMapFrame", "TaxiFrame", "L-003/L-004"):
    require(term in launch, "launch readiness audit pointer missing: " + term)
for key in ("L-001", "L-003", "L-004", "L-018"):
    require(key in issues, "issue register disappeared: " + key)
for path, content in (("audit", audit), ("current", current),
                      ("evidence", evidence), ("record", record), ("handoff", handoff)):
    require(content.endswith("\n") and not content.endswith("\n\n") and "\r" not in content,
            "terminal whitespace contract failed: " + path)
for term in ("no Lua", "UNVERIFIED"):
    require(term.lower() in record.lower() and term.lower() in evidence.lower(),
            "docs-only/runtime boundary missing: " + term)
print("P0326 merchant/flight source ownership and deferred native fallback contract")
print("PASS: source candidates, trainer-only registry, distinct parking, diagnostics, memory continuity")
