---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Add an explicitly owned Goodbye exit to the P0299 live trainer landscape, matching the accepted Quest header navigation while preserving Blizzard's stock trainer and the proven local browsing/single-service interaction. Bulk Train All remains a separate gated feature.

## Current Work Item
**P0300 — TRAINER GOODBYE / PREPARED; WSL AND WOW UNVERIFIED.** Verified GitHub main P0299 `b33bba2`. User screenshots show case-insensitive `curse`/`CURSE` local search across eight matching services and combined Available-only filtering to one; user reports all P0299 functions working. **SEARCH RUNTIME PASS within tested scope.** User requests a Goodbye control matching Quest. P0300 adds a 78×24 upper-right Logres-owned mouse region matching Quest's typography, gold underline and hover emphasis. The one-click action calls only `Trial.Disable("goodbye")`; it clears search focus, hides the entire Logres trial and removes child hit regions. It does not close, hide, reparent or click native Blizzard trainer frames. The root stays mouse-inert outside deliberate owned controls.

## Verified State
- **P0299 pushed `b33bba2` / USER SEARCH PASS:** screenshots corroborate plain substring search and filter composition; no-match/focus teardown not independently pictured. User says all otherwise works. Existing P0298 icon recovery, P0295 selection and filter, P0296 one verified user-reported single purchase remain bounded earlier evidence.
- **GOODBYE OPEN:** Quest `Dialogue.lua` already provides a matching upper-right header button; live trainer lacks that affordance. Quest Goodbye dismisses the Logres presentation and restores usable native ownership; it is not authorization to invoke a native trainer-close API.
- **Train All DEFERRED:** only a single-service transaction has runtime evidence. Blizzard owns its functional Train All button; do not loop `BuyTrainerService` or infer bulk safety.
- Remaining validation limits: slider drag, every teardown path, all transaction variants, and long-session behavior are not conclusively evidenced.

## Next Action
Apply P0300 ZIP to exact clean P0299 `b33bba2` and require guarded complete prewrite/postwrite static suites, candidate whitespace check and manifest. User commits/pushes; verify remote main independently. Deploy and `/reload`; at Briarthorn open `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST). Observe top-right Goodbye: hover highlight, single left-click hides Logres, leaves Blizzard trainer usable, and removes Logres search/skill/train hit regions. Reopen H live trial and verify search/filter/icons/details; OFF/trainer close unaffected. No purchases needed.

## Success Criteria
Matching Quest header Goodbye art, click only within owned upper-right bounds, clean local panel/focus teardown; native trainer remains functional. Synthetic P fixture remains noninteractive. No native close, filter, selection, purchase, protected frame or camera changes. A successful static contract is not an in-game PASS.

## Do Not Reopen Without New Evidence
Do not replace Blizzard's Train All with a loop of single-service purchases, infer bulk-transaction safety from one successful purchase, or hide Blizzard's usable stock trainer. Do not reinterpret secret-capable values, add polling/protected mutations, or claim Goodbye runtime PASS before the in-game test. Preserve the recorded P0294/P0295/P0296/P0297 failures and any unverified teardown or slider behavior.

## Relevant References
- `docs/memory/evidence/P0300_TRAINER_GOODBYE.md`, `docs/memory/patches/P0300_TRAINER_GOODBYE.md`
- `docs/memory/evidence/P0299_TRAINER_LOCAL_SEARCH.md`, `docs/memory/evidence/P0298_TRAINER_ICON_DRAW_LAYERS.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
