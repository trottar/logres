---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Finish class-trainer default presentation and native-close Goodbye with safe Blizzard restoration; preserve the accepted Logres trainer visuals and shared NPC components. Profession-family integration remains source-gated. After trainer finalization: gossip, merchants, flight masters.

## Current Work Item
**P0308 — class-trainer native-close Goodbye / PREPARED; WSL and WoW UNVERIFIED.** Verified GitHub main P0307 `dad4c97` (`0.0.208-dev`). User confirms P0306 whole-frame parking and restoration: clicking Goodbye restores the Blizzard trainer, precisely the P0306 recovery trial behavior. P0307 one-shot profession result at Grimnur Stonebrand: normalized interaction type 7, `IsTradeskillTrainer=yes`, native `ClassTrainerFrame` shown/unprotected, `GetNumTrainerServices=0`; the shared Logres live trial deferred and stock remained visible. This is a source-empty profession session, not proof of universal profession support or a reason to disable stock. P0308 makes explicit Goodbye close the **class** native trainer after restoration, with one guarded CloseTrainer request. New enchanting/cooking screenshots confirm shared read-only presentation but expose a profession fallback gap: stock was parked despite Logres having no profession purchase action. P0308 gates parking on ordinary `IsTradeskillTrainer()==false` so profession stock stays visible. No profession transaction, catalogue, art or camera change.

## Verified State
- GitHub main P0307 `dad4c97` independently verified. The uploaded diagnostic reports WoW Forever client 1.60.1 and Logres `0.0.208-dev`, `lastCommand=trainerfamilycheck`; profession=yes, type=7, shown=yes, protected=no, serviceCount=0, session=open-deferred-trainer, lastReady=TRAINER_UPDATE. **READ-ONLY OBSERVATION PASS** for these fields; the Fishing Trainer's absent catalogue remains OPEN / SOURCE EMPTY.
- User confirms class trainer native parking visually works and Goodbye restores Blizzard to its normal placement: **P0306 restore visual PASS**. Default automatic opening, search, filter, selection, scroll, hover, selected and bulk purchases were separately confirmed in earlier class-trainer scopes. Purchases **while native root parked** and CloseTrainer API behavior are still UNVERIFIED.
- Enchanting and Cooking show source-backed Logres profession rows, but actions remain read-only. P0306 parking hid the native learning controls in these cases: **OPEN FALLBACK DEFECT**. P0308 retains stock presentation for profession or unclassified trainers. Fishing remains source-empty, distinct from readable Enchanting/Cooking.
- P0307 R0 checker-count failure was fixed by R1, preserved in historical evidence. D-046/D-047 preview/shared render/separate live actions and fail-open fallback remain in effect.

## Next Action
Apply guarded P0308 against clean verified P0307. Require every PREWRITE/POSTWRITE checker, memory/version/whitespace and manifest PASS. User commits/pushes; verify main. Deploy and `/reload`, then visit class trainer without H: confirm Logres-only, press Goodbye once; **both** Logres and Blizzard trainer should close on a supported client. If native CloseTrainer unavailable/fails, Logres closes and stock restores visibly; treat as DEFERRED or FAIL from actual evidence, not PASS. Reopen class trainer normally. Check an available enchanting/cooking trainer if convenient: Logres may show read-only rows, but Blizzard MUST remain visible for profession transactions. Fishing remains source-empty. No purchases needed.

## Success Criteria
Goodbye is a deliberate class-only explicit native close after successfully restoring saved native anchors, and profession trainers must retain usable stock controls, with separate API/interaction/combat/protection/profession checks, at most one native close request, no fake closure claims, no polling, and visible usable Blizzard fallback on close failure. Preserve all existing Logres trainer appearance, purchase controls, catalogue and automatic entry; native closing not generalized to gossip/merchant/flight without specific adapters.

## Do Not Reopen Without New Evidence
Do not claim a successful native close from a successful pcall alone; require WoW confirmation. Do not force profession trainers into class purchasing or manufacture missing service rows. Do not suppress Blizzard when its source is empty. Never inspect opaque native anchor tokens, add periodic hiding/retries, change camera, or discard P0304/P0307 failure evidence. Existing single/bulk successful purchases were with stock visible, not yet verified while parked.

## Relevant References
- `docs/memory/evidence/P0308_TRAINER_NATIVE_GOODBYE.md`, `docs/memory/patches/P0308_TRAINER_NATIVE_GOODBYE.md`
- `docs/memory/evidence/P0307_TRAINER_FAMILY_DIAGNOSTIC.md`, `docs/memory/evidence/P0306_TRAINER_NATIVE_PARKING.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
