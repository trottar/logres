---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Finalize the approved trainer UI with a source-backed current-trainer context and complete character-owned profession list, safe native transactions and Blizzard fallback. Then gossip, merchants, flight masters.

## Current Work Item
**P0313 R1 — current trainer / full character professions in separate left sidebar sections; PREPARED / WSL STATIC and WoW UNVERIFIED.** Verified GitHub main P0312 `8776eb6`. User confirms P0312 Enchanting and Cooking lists restored, all owned professions appear in sidebar and class trainer stable. User reports synthetic empty preview icon turned yellow. P0313 keeps the complete "Your professions" list and places a separate "Current trainer" section above it. The current trainer discipline is detected from native copied skill requirements, or guarded native TooltipInfo/greeting for an empty source. No guessed profession from ownership or NPC identity. The empty fixture alone adopts the proven dark-bordered live icon treatment.

P0313 R0 PREWRITE failed **3/184** (one pinned-version policy and two historic live-icon call-site contracts); no tracked writes. P0313 R1 fixes the generated checker and preserves the exact live icon invocations. **R1 STATIC and WoW UNVERIFIED.**

## Verified State
- P0312 user screenshots: P-panel empty fixture and full profession context visible; Enchanting and Cooking source rows restored; Fishing empty Logres and native stock both shown. Class trainer user-reported unchanged working. **PASS within displayed scopes**, no new transaction re-test.
- P0312 synthetic empty fixture gold icon background is a **visual regression** requiring a targeted isolated repair. The regular P trainer preview and all live icon treatments remain accepted.
- P0311 Enchanting zero-service regression and profession Goodbye policy were corrected in P0312; preserve failures in evidence. Class purchase and Train All previously user-confirmed; full profession native replacement remains UNVERIFIED/DEFERRED.

## Next Action
Apply guarded P0313 on clean exact main P0312. Require entire PREWRITE and POSTWRITE candidate checkers PASS plus manifest and diff. User commits/pushes, verify main. Deploy and `/reload`; P — Previews → Trainer Empty Preview: verify icon dark with thin gold border and both left sections. Open Fishing: current trainer should show Fishing and Journeyman 61/150 only if guarded service, native tooltip or greeting source actually identifies Fishing; otherwise explicit unverified status, with full Your professions retained. At Cooking, verify current trainer offers Journeyman at Cooking 50 as its unavailable native source row reports. At Enchanting verify all skills and class unchanged. No training purchase needed.

## Success Criteria
Shared landscape preview/live renderer, same geometry and typography, one current-trainer focus (discipline, character rank, next native requirement where present), second complete list of independently copied owned professions. No native mutations, no profession-specific source invention, no purchase authorization, no polling, no shadow-click regions. The P fixture is inert and retains its reviewed panel action; native Blizzard remains for profession transactions.

## Do Not Reopen Without New Evidence
Do not infer that an NPC teaches a discipline solely because the character owns it; do not derive actual acquisition from cap/tooltip text; do not hide profession stock until its information and actions are replaced. Preserve negative history including P0310 R0/R1, P0311 regression and P0312 repair.

## Relevant References
- `docs/memory/evidence/P0313_TRAINER_FOCUS_ICON_PREVIEW.md`, `docs/memory/patches/P0313_TRAINER_FOCUS_ICON_PREVIEW.md`
- `docs/memory/evidence/P0312_PROFESSION_CONTEXT_RECOVERY.md`, `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
