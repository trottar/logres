#!/usr/bin/env python3
"""P0327 offline native-first merchant/flight presentation fixture contract."""
from pathlib import Path
import sys
import re
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from p0327_service_model import SERVICES, SCENARIOS, STOCK, fixture


def read(path):
    return (ROOT / path).read_text(encoding="utf-8")


def need(ok, reason):
    if not ok:
        raise AssertionError(reason)

need(SERVICES == ("merchant", "flight"), "service families changed")
need(SCENARIOS == ("sample-list", "sample-empty", "source-unavailable", "native-handoff"),
     "synthetic scenarios changed")
for service in SERVICES:
    for scenario in SCENARIOS:
        a = fixture(service, scenario)
        need(a["service"] == service and a["scenario"] == scenario, "scenario mismatch")
        need(a["source"] == "authored-fixture" and a["sourceVerified"] is False
             and a["previewOnly"] is True, "fictional data promoted to live source")
        need(a["renderingStatus"] == "model-only-not-in-game", "render evidence overstated")
        need(a["nativeOwner"] == "Blizzard" and a["nativeFrame"] == "unresolved",
             "native frame ownership or identity invented")
        need(a["nativeControlsPreserved"] is True and a["nativeRequired"] == list(STOCK[service]),
             "native control/fallback coverage lost")
        need(a["interactions"] == [] and all(a[k] is False for k in
             ("canPurchase", "canSell", "canRepair", "canSelectRoute", "canTravel")),
             "synthetic service action unexpectedly enabled")
        need(len(a["rows"]) == (2 if scenario == "sample-list" else 0),
             "synthetic row coverage drift")
        for row in a["rows"]:
            need(set(row) == {"label", "description", "actionable"}
                 and row["actionable"] is False, "row contains executable identity/action")
            need("Sample" not in row["label"] or scenario == "sample-list", "row scope drift")
        b = fixture(service, scenario)
        a["nativeRequired"].append("mutation")
        a["rows"].append({"unexpected": "mutation"})
        need("mutation" not in b["nativeRequired"] and len(b["rows"]) ==
             (2 if scenario == "sample-list" else 0), "fixture object aliasing")
for invalid in ("bank", "trainer", "", None, 4, True):
    try: fixture(invalid, SCENARIOS[0])
    except ValueError: pass
    else: raise AssertionError("invalid service accepted")
for invalid in ("unknown", "", None, True, 3):
    try: fixture(SERVICES[0], invalid)
    except ValueError: pass
    else: raise AssertionError("invalid scenario accepted")

source = read("tools/p0327_service_model.py")
need(all(token not in source for token in (
    "C_MerchantFrame", "C_TaxiMap", "C_GossipInfo", "TakeTaxiNode(",
    "BuyMerchantItem(", "RepairAllItems(", "SetPreference(",
    "RegisterEvent(", "InCombatLockdown(", "SetPoint(", "SetScript(")),
    "native or game API leaked into offline model")
need("p0327_service_model" not in read("Logres/Logres.toc"), "offline model loaded by WoW")
need('Session.Register("trainer", {' in read("Logres/UI/NPCServiceSession.lua"),
     "trainer session baseline lost")
need(len(re.findall(r'Session\.Register\("[^"\n]+",\s*\{',
                    read("Logres/UI/NPCServiceSession.lua"))) == 1,
     "new merchant/flight live session introduced without runtime proof")
need('native = "FlightMapFrame"' in read("Logres/Quest/NativeServicePolicy.lua"),
     "flight candidate conflict no longer current")
need('"TaxiFrame"' in read("Logres/Quest/ServiceElementIndex.lua"),
     "flight element candidate conflict no longer current")
for path in ("docs/memory/architecture/P0327_MERCHANT_FLIGHT_FIXTURE.md",
             "docs/memory/evidence/P0327_MERCHANT_FLIGHT_FIXTURE.md",
             "docs/memory/patches/P0327_MERCHANT_FLIGHT_FIXTURE.md"):
    s = read(path)
    for token in ("P0327", "UNVERIFIED", "D-046", "Blizzard"):
        need(token in s, "missing release/safety scope in " + path + ": " + token)
current = read("docs/memory/CURRENT.md")
for heading in ("## Active Objective", "## Current Work Item", "## Verified State",
                "## Next Action", "## Success Criteria", "## Do Not Reopen Without New Evidence",
                "## Relevant References"):
    need(current.splitlines().count(heading) == 1, "CURRENT heading drift: " + heading)
for n in range(317, 328):
    need(f"P{n:04d}" in current, "CURRENT historical continuity missing")
need("P0327" in read("docs/memory/handoffs/CURRENT_HANDOFF.md"), "handoff not advanced")
launch = read("docs/memory/roadmap/LAUNCH_READINESS.md")
need("P0327" in launch and "November 4" in launch and "UNVERIFIED" in launch,
     "launch plan cannot imply live acceptance")
need(all(f"L-{i:03d}" in read("docs/memory/investigations/ISSUE_REGISTER.md")
         for i in (1, 3, 4, 18)), "issue classifications lost")
print("P0327 native-first merchant and flight synthetic service model contract")
print("PASS: 8 inert fixtures, no native actions, native fallback, model isolation and memory")
