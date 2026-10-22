---
memory_schema: 1
as_of: 2026-10-21
project: logres
---

# Current State

## Active Objective
Advance the P0290 user-accepted **read-only native trainer landscape** toward complete source fidelity, without taking training, filtering, selection or protected Blizzard controls. Keep P0284's portrait-free shared renderer, D-046 and D-047 fail-open behavior.

## Current Work Item
**P0291 — FOREVER TRAINER SIX-TUPLE DATA / PREPARED, WSL AND WOW UNVERIFIED.** Verified pushed P0290 R2 `61838ba`. User screenshot shows five correct live trainer skill names in the approved Logres layout; **LIVE DISPLAY PARTIAL PASS**. Textures, ranks, level requirements and costs are missing or unclassified. Source audit of Blizzard Forever Mainline trainer code establishes `GetTrainerServiceInfo(index)` returns name, serviceType, texture, requiredLevel, subText, category, NOT the legacy Classic name/rank/category/expanded interpretation. P0286's numeric "category" was actually a texture ID; its numeric "expansion" was level requirement. P0291 adds a secret-gated, bounded six-field source branch with optional skill requirement, cost and description, and carries safe texture IDs into the same model/renderer. No trainer interaction ownership or authorization.

## Verified State
- **P0290 R2 pushed `61838ba`, user screenshot LIVE PRESENTATION PARTIAL PASS:** five real druid skills appear in mouse-inert Logres landscape; stock trainer remains visible. Real icon, costs, ranks and requirements NOT populated. No evidence for train/close/selected action safety.
- **P0290 R0/R1 static failures:** R0 1/161 PREWRITE failure for >20 KB CURRENT.md; R1 161/161 checker PASS but `git diff --check` EOF blank-line FAIL. R2 repaired with candidate prewrite whitespace checks. All failures preserved in P0290 evidence.
- **P0285–P0289:** source-shape/classification errors and slash-only H workflow failure remain historical; H Live Trainer ON/OFF exists and was accepted as usable. Generic audits are not a necessary next step.
- **P0291 source finding:** Forever six-return tuple documented by verified Blizzard source `Ketho/wow-ui-source-forever`, `Interface/AddOns/Blizzard_TrainerUI/Mainline/Blizzard_TrainerUI.lua`; previous Classic four-tuple assumption was WRONG for this client. Actual 6-value WoW read is not yet tested through Logres. Cost/skill/description sources are optional and remain withheld if unsafe.

## Next Action
Apply guarded P0291 on verified P0290 R2 main, run PREWRITE/POSTWRITE suite and `git diff --check`, user commit/push then verify remote. Deploy to Forever beta; open an ordinary trainer and use `/logres panel` → H → Live Trainer ON (TEST). Verify icon textures, rank/level/skill requirements and any safely available costs; compare with Blizzard stock. Use Live Trainer OFF, no generic audit or training purchase.

## Success Criteria
Real returned texture/requirements/rank/cost show when independently ordinary and bounded; safe absent fields display placeholders. Accepted P and live art remain common. No Blizzard geometry, action, selection or filter writes; no taint/secret errors. WoW results remain UNVERIFIED until actual screenshot and panel output.

## Do Not Reopen Without New Evidence
Do not infer native transaction ownership from a source field. Keep source indices distinct from filtered display order; no hidden Blizzard click regions, category coercion, polling, speculative enum mappings or live purchase. Preserve stock controls and safe fallback. Do not reopen unrelated camera, pet, compass, QuestieDB or native quest actions without relevant evidence.

## Relevant References
- `docs/memory/handoffs/CURRENT_HANDOFF.md`
- `docs/memory/evidence/P0291_FOREVER_TRAINER_DATA.md` and `docs/memory/patches/P0291_FOREVER_TRAINER_DATA.md`
- `docs/memory/evidence/P0290_TRAINER_PARTIAL_SOURCE_RECOVERY.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/memory/patches/PATCH_INDEX.md`, `docs/ROADMAP.md`
