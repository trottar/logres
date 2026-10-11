# P0190 — Accept P0189 automatic normal Main runtime; open H.2 calibration

Date: 2026-10-11. Verified GitHub `main` baseline `bd0c36a2a98439b2332f78fb9c0cc58e67a5b3ef` (`feat: auto-arm secure Main replacement in immersion`, Logres `0.0.101-dev`). **DOCS/EVIDENCE ONLY.** No Lua, native UI mutation, checker, or runtime version change.

## Accepted bounded result

User: **“pushed, all worked as expected.”** Latest `LOGRES_DIAGNOSTICS_LATEST.lua`, client `1.60.1` build `70338`, loadCount `239`:

- Fresh login `status` reports `0.0.101-dev`, then `mainreplacecheck` reports `CANDIDATE armed=true auto=true optOut=false applied=true pending=false driver=true route=true activations=1 restores=0 error=nil`. No manual ON precedes the startup check.
- Manual OFF reports `STOCK armed=false auto=true optOut=true applied=false route=false activations=1 restores=1 error=nil`; Immersion OFF/ON commands follow before manual ON, with no reported conflict. The export does not include an intervening `mainreplacecheck` for the held opt-out, so the specific opt-out persistence is user-confirmed but not independently measured by a diagnostic line.
- Manual ON reports `CANDIDATE armed=true optOut=false applied=true activations=2 restores=1 error=nil`; Immersion OFF/ON commands follow.
- Phase 0 Run All reports `mainreplacecheck CANDIDATE armed=true auto=true optOut=false applied=true pending=false route=true activations=7 restores=6 nativeReparents=0 error=nil`, `actioncheck PASS` with Primary `keys=true/12` and feedback `12/12`, and `checkall: complete`.
- UI Ownership Check reports `total=35 pass=17 stock=18 deferred=0 fail=0`. `main_action` remains `STOCK` as a **read-only policy classification**, not an empirical Main-frame visibility measurement.
- User confirms normal-screen interaction and intended behavior worked. Diagnostics report no Main gate, routing, or integrated check failure in the latest run. They do not directly inspect pixel-level mouse hit areas, Edit Mode state, or native presentation secret values.

## Classification / remaining constraints

**H.1 accepted for user-observed ordinary Immersion ON coexistence/automatic Main replacement and recovery.** This permits H.2 authored whole-screen placement and collision calibration to begin without reopening H.1 for inaccessible gameplay. It is **not** a blanket replacement of the 18 deliberately STOCK domains, and does not upgrade `main_action` policy row to PASS. Native vehicle, possess, override, bonus/form, petbattle and in-combat special transitions remain **ENVIRONMENTALLY DEFERRED**, not verified or closed. Edit Mode was included in the requested test sequence and user reports all worked, but there is no dedicated edit-mode diagnostic trace. Preserve failsafe native access and separate targeted investigation if a real special-mode defect appears.

Preserve P0187 R0 repeat-ON secure state FAIL, P0187 R1 checker-hash delivery FAIL, P0188 R0 whitespace prewrite FAIL, P0182 filter-only miss, P0178 Lua upvalue FAIL, P0175 nil rows and intermittent ObjectiveTracker flash. Do not erase history because P0189 works.

## Next

**P0191 Phase H.2 density/spacing and collision audit** using P0166 integration-owned semantic anchors and the approved D-032/D-034 world-first layout. Gather a bounded ordinary in-game screen/anchor placement baseline, then make the smallest meaningful positioning patch. Do not move secure action frame anchors during combat, add generic drag-anything editing, or suppress deliberate Blizzard fallback. H.3 final visual polish follows accepted H.2 geometry.

Canonical evidence: `docs/memory/evidence/P0190_P0189_AUTO_MAIN_RUNTIME_2026-10-11.md`.
