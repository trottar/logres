# P0175 R2 — Runtime negative results and category split

User after P0175 R1: "Quest UI popped up quick when I looted but only for that. The buffs are visible on player and enemy but debuffs are not." This is a real negative visual report. Preserve separately from earlier R2 success: Objective Tracker normal persistence was accepted, but one brief loot-associated reappearance is now OPEN / INTERMITTENT / UNREPRODUCED. Do not treat existing native UI PASS after the event as proof no flash occurred.

User-uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`, client build 70291, Logres `0.0.91-dev` loadCount 220:
- Status Preview ON and Check: PASS, player=2/true/preview, target=3/true/preview, targetEvidence=preview-only.
- Preview OFF: PASS structural, player=0/false/empty, target=0/false/unit-absent, targetEvidence=deferred-no-populated-target-aura.
- Run All: statusauracheck PASS structural, again player=0/empty, target=0/unit-absent; `nativeuicheck PASS` with folded=5/open=0, `nativeShows=9/5`, `combatDeferred=1`, `castGate=true/true`, `gateEscapes=0`, and no recorded native failures.
- None of these lines proves a live populated player or target debuff. User's visual report is not overwritten by the structural PASS.

P0175 target slot selection previously combined priority harmful and helpful filters into one five-icon budget. Independent per-category bounded slots are a meaningful production correction, but may not resolve absent/deferred aura sources. The separate source and visible-count diagnostics identify which part is still unproven. No harmful-source runtime PASS, target world attachment, combat secure ownership, or stock aura suppression is claimed before observed proof.

Pre-write checker run is performed by the applier in a shadow checkout. Runtime test required; if target/player harmful remains absent while Blizzard shows a harmful aura, retain failure and obtain the panel's new per-category result. Do not commit as a runtime fix until classified.

## R3 observed negative result — supersedes R2 runtime-pending claim

R2 later FAILED its Phase 0 Run All preference transition: status renderer at line 273 dereferenced nil `rows`, saved Immersion was left OFF, and Logres mana/resource disappeared. See `P0175_R3_PREFS_RESOURCE_RESTORE_2026-10-08.md`. Preview evidence remains a preview-only result; no live harmful aura proof.
