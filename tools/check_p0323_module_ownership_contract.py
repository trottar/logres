#!/usr/bin/env python3
"""P0323: 94 loaded Lua ownership entries + five-domain audit without runtime edits."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
read = lambda p: (ROOT / p).read_text(encoding="utf-8")
toc = read("Logres/Logres.toc")
audit = read("docs/memory/architecture/P0323_MODULE_OWNERSHIP_AUDIT.md")
current = read("docs/memory/CURRENT.md")
launch = read("docs/memory/roadmap/LAUNCH_READINESS.md")
issues = read("docs/memory/investigations/ISSUE_REGISTER.md")
evidence = read("docs/memory/evidence/P0323_MODULE_OWNERSHIP_AUDIT.md")
lines = [x.strip() for x in toc.splitlines() if x.strip().endswith(".lua")]
errors=[]
def need(ok, why):
    if not ok: errors.append(why)
need(len(lines)==94 and len(set(lines))==94,"TOC expected 94 unique loaded Lua files")
for relative in lines:
    path="Logres/"+relative.replace("\\","/")
    need((ROOT/path).is_file(),"missing TOC source: "+path)
    need(audit.count("| `"+path+"` |") == 1,"audit missing/duplicate TOC source: "+path)
need(audit.count("| `Logres/")==94,"audit does not contain exactly 94 source rows")
for term in ("NAV","ACT","NPC","STATUS","CAM","SHARED","Quest/Dialogue.lua", "Immersion/Controller.lua", "D-048", "D-047", "D-046", "UNVERIFIED", "November 4", "32", "frozen", "native", "Merchant", "flight"):
    need(term.lower() in audit.lower(), "audit missing "+term)
for term in ("## Active Objective","## Current Work Item","## Verified State","## Next Action","## Success Criteria","## Do Not Reopen Without New Evidence","## Relevant References"):
    need(current.splitlines().count(term)==1,"CURRENT heading absent/duplicated: "+term)
for patch in ("P0317","P0318","P0319","P0320","P0321","P0322","P0323"):
    need(patch in current,"CURRENT omitted historical contract "+patch)
need("CURRENT.md" in read("docs/memory/handoffs/CURRENT_HANDOFF.md"),"handoff lacks authority")
need("P0323" in launch and "P0324" in launch,"launch plan not advanced")
need(all("L-"+str(i).zfill(3) in issues for i in range(1,19)),"issue-register continuity absent")
need("P0321" in evidence and "UNVERIFIED" in evidence,"runtime deferral missing")
preferences = read("Logres/Core/Preferences.lua")
for key in ("immersionEnabled","activeQuestEnabled"):
    need(key in preferences,"current preference inventory out of sync: "+key)
policy = read("Logres/Immersion/Controller.lua")
for key in ("actionReplacementDesired", "quietModeDesired", "playerFrameSuppressionDesired", "targetFrameSuppressionDesired"):
    need(key in policy,"coupled-policy inventory out of sync: "+key)
need("## Version:" in toc,"TOC version metadata missing")
print("P0323 complete TOC modularity and native-ownership source inventory")
for e in errors: print("ERROR:",e)
if errors: raise SystemExit(1)
print("PASS: 94 exact TOC mappings, five domains, policy coupling, history and deferral")
