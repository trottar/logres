---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Complete the verified Logres trainer as the default NPC service with recoverable native presentation. After trainer finalization: gossip, merchants, flight masters, preserving the approved portrait-free parchment visuals.

## Current Work Item
**P0306 — guarded whole-root trainer parking, PREPARED; WSL and WoW runtime UNVERIFIED.** Verified GitHub P0305 `c6ee091` pushed; user screenshot and report confirm P0305 automatic trainer opening, search/filter and working Logres controls, with duplicate Blizzard ClassTrainerFrame still visible. P0306 adds an authorized trainer-only use of a service-neutral native presentation parking module: after fully rendering Logres, capture stock frame anchors only as opaque restoration tokens, move the whole nonprotected shown root outside the screen, keep Blizzard APIs/IsShown available, and restore BEFORE Logres dismissal. This is an experimental client capability, not runtime PASS.

## Verified State
- P0305 default-on Logres at class trainer, search, filters and browse USER RUNTIME PASS. Blizzard window remains visible alongside it. P0304 first auto-opening failure is retained in evidence; P0305 fixed it.
- Earlier one selected purchase, full Train All purchase, icons, selection, slider/wheel, search, filter, hover, Goodbye and shared P0303 catalogue were user-confirmed within tested scopes. Do not infer all session variants or purchase eligibility from those tests.
- P0306 makes NO changes to Blizzard data/transaction APIs, class trainer purchase guards, camera, trainer visual geometry or synthetic P preview. Stock fallback remains mandatory.

## Next Action
Apply guarded P0306 on exact clean P0305 `c6ee091`; full PREWRITE and POSTWRITE static checker suites, whitespace, memory/version gates and manifest PASS. User commits/pushes; verify GitHub `main`. Deploy, `/reload`, open class trainer without H panel: confirm ONLY Logres is onscreen but native ClassTrainerFrame remains shown offscreen; search/filter/scroll work. Click Goodbye: stock Blizzard trainer should be restored before Logres disappears (intentional recovery test). Close stock trainer and reopen: Logres should auto-open and native park again. Use H OFF/ON; check natural combat or native close if practical. No purchase required. Any taint/secret/Lua failure or inaccessible stock is FAIL; preserve exact evidence and repair before production finalization.

## Success Criteria
Whole nonprotected native root (not alpha-zero children) moves offscreen after successful Logres rendering; its native IsShown and purchase eligibility guard remain intact. Restore exact captured anchors without inspecting individual tokens BEFORE hiding Logres; postpone teardown if combat blocks restoration, retry only on PLAYER_REGEN_ENABLED. If capability is absent or frame conflicts, leave stock usable and Logres visible. No polling, repeated suppression hooks, native parenting or new camera code.

## Do Not Reopen Without New Evidence
Never declare P0306 parking working from source alone. Never claim native purchase success while parked until actually observed (prior purchases were with stock visible). Do not hide a protected frame, inspect secret anchor tokens, use alpha-zero invisible click regions, or drop Logres if native restore fails. Avoid unrelated UI redesign or general NPC service activation. Record failures and environmental deferrals.

## Relevant References
- `docs/memory/evidence/P0306_TRAINER_NATIVE_PARKING.md`, `docs/memory/patches/P0306_TRAINER_NATIVE_PARKING.md`
- `docs/memory/evidence/P0305_TRAINER_READY_EVENT_REPAIR.md`, `docs/memory/evidence/P0303_NPC_SERVICE_CATALOGUE.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
