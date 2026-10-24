#!/usr/bin/env python3
"""P0324: pure five-domain policy fixtures; no WoW execution or native writes."""
from pathlib import Path
import re
import sys
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
import p0324_domain_policy as model

def read(path): return (ROOT / path).read_text(encoding="utf-8")
def need(ok, why):
    if not ok: raise AssertionError(why)

need(model.DOMAINS == ("NAV", "ACT", "NPC", "STATUS", "CAM"), "domain order drift")
full = {d: "full" for d in model.DOMAINS}
none = {d: "none" for d in model.DOMAINS}
ready = {d: True for d in model.DOMAINS}
for mask in range(32):
    requested = model.from_mask(mask)
    need(len(requested) == 5, "incomplete requested model")
    evaluation = model.evaluate(requested, full)
    for i, domain in enumerate(model.DOMAINS):
        expected = "logres" if mask & (1 << i) else "blizzard"
        need(evaluation[domain]["requested"] == expected, "request bit mismatch")
        need(evaluation[domain]["effective"] == expected, "full capability effective mismatch")
        need(evaluation[domain]["pending"] is False, "unexpected transition pending")
        need(evaluation[domain]["fallback"] in ("native", "native-available"),
             "full capability fallback reporting mismatch")
        adjacent = model.evaluate(model.from_mask(mask ^ (1 << i)), full)
        need(all(evaluation[other] == adjacent[other] for other in model.DOMAINS
                 if other != domain), "cross-domain coupling introduced")
    fallback = model.evaluate(requested, none)
    need(all(fallback[d]["effective"] == "blizzard" for d in model.DOMAINS),
         "unavailable capabilities must retain native fallback")

for domain in model.DOMAINS:
    wanted = {d: "blizzard" for d in model.DOMAINS}
    wanted[domain] = "logres"
    coverage = {d: "full" for d in model.DOMAINS}
    coverage[domain] = "partial"
    state = model.evaluate(wanted, coverage)
    need(state[domain]["effective"] == "logres" and
         state[domain]["fallback"] == "native-required", "partial fallback lost")
    current = {d: "blizzard" for d in model.DOMAINS}
    current[domain] = "logres"
    restores = dict(ready)
    restores[domain] = False
    result = model.evaluate({d: "blizzard" for d in model.DOMAINS}, full,
                            current=current, restored=restores)
    need(result[domain]["effective"] == "logres" and
         result[domain]["pending"] is True and
         result[domain]["fallback"] == "pending-restore", "unsafe early relinquish")
    need(all(result[d]["effective"] == "blizzard" and not result[d]["pending"]
             for d in model.DOMAINS if d != domain), "restore deferral leaked across domains")
    restores[domain] = True
    need(model.evaluate({d: "blizzard" for d in model.DOMAINS}, full,
                        current=current, restored=restores)[domain]["effective"] == "blizzard",
         "restoration completion did not return stock")

for mask in (-1, 32, 1.0, "1", True):
    try: model.from_mask(mask)
    except ValueError: pass
    else: raise AssertionError("invalid selection mask accepted: " + str(mask))
for bad in ({}, {d: "logres" for d in model.DOMAINS if d != "CAM"},
            {d: "invalid" for d in model.DOMAINS}):
    try: model.evaluate(bad, full)
    except ValueError: pass
    else: raise AssertionError("invalid requested map accepted")
for invalid in (1, None, "yes"):
    try: model.legacy_passthrough({"immersionEnabled":invalid,
                                   "activeQuestEnabled":True})
    except ValueError: pass
    else: raise AssertionError("invalid legacy boolean accepted")
for immersion in (False, True):
    for active in (False, True):
        original = {"immersionEnabled":immersion, "activeQuestEnabled":active,
                    "custom": {"preserve": [1,2,3]}}
        result = model.legacy_passthrough(original)
        need(result["existing_settings"] == original and
             result["domain_preferences"] is None and
             result["requires_runtime_migration"] is True and
             result["state"] == "not-migrated", "legacy save changed or auto-migrated")
        result["existing_settings"]["custom"]["preserve"].append(4)
        need(original["custom"]["preserve"] == [1,2,3], "legacy alias mutated")

source = read("tools/p0324_domain_policy.py")
need("RegisterEvent(" not in source and "SetPreference(" not in source and
     "C_GossipInfo" not in source and "InCombatLockdown(" not in source,
     "pure fixture imports native execution behavior")
toc = read("Logres/Logres.toc")
need("p0324_domain_policy" not in toc, "fixture must never be loaded by WoW")
for item in ("Logres/Core/Preferences.lua", "Logres/Core/Database.lua",
             "Logres/Immersion/Controller.lua"):
    need((ROOT / item).is_file(), "missing original runtime baseline: " + item)
current = read("docs/memory/CURRENT.md")
for name in ("## Active Objective", "## Current Work Item", "## Verified State",
             "## Next Action", "## Success Criteria",
             "## Do Not Reopen Without New Evidence", "## Relevant References"):
    need(current.splitlines().count(name) == 1, "current headings changed: " + name)
for token in ("P0317", "P0318", "P0319", "P0320", "P0321", "P0322", "P0323", "P0324"):
    need(token in current, "historical milestone omitted from CURRENT: " + token)
need("CURRENT.md" in read("docs/memory/handoffs/CURRENT_HANDOFF.md"),
     "handoff missing authority pointer")
for p in ("docs/memory/architecture/P0324_POLICY_FIXTURE.md",
          "docs/memory/evidence/P0324_FIVE_DOMAIN_POLICY.md",
          "docs/memory/patches/P0324_FIVE_DOMAIN_POLICY.md"):
    s=read(p)
    need("P0324" in s and "UNVERIFIED" in s, "policy scope/evidence missing in " + p)
need("32" in read("docs/memory/roadmap/LAUNCH_READINESS.md"), "32-combination gate lost")
need("P0323" in read("docs/memory/architecture/P0323_MODULE_OWNERSHIP_AUDIT.md"),
     "source audit lost")
# Never pin a historical runtime version; instead verify metadata parity.
a = re.search(r'(?m)^## Version: (\S+)$', toc)
b = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', read("Logres/Core/Bootstrap.lua"))
need(bool(a and b and a.group(1) == b.group(1)), "TOC/Bootstrap version parity lost")
print("P0324 five-domain pure policy and migration-preservation fixtures")
print("PASS: 32 full capability configurations, 160 independence probes, capability fallback,")
print("      five partial fallback and deferred-restore cases, four legacy combinations")
