# Current Handoff — P0255 final-page quest action presentation

Authority: `docs/memory/CURRENT.md`, `docs/memory/evidence/P0255_FINAL_PAGE_AND_OFFER_ACTIONS.md`, and `docs/memory/decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`.

Verified GitHub `main` `2a7bc5d` P0254. User screenshot `0.0.154-dev` and “Much better!” establish only a **scoped visual PASS** for Complete Quest inside the narrative panel. New user-observed defects: rewards and Complete Quest visible before final page 2/2; Accept/Decline below panel; brief Blizzard reward-frame flash after completion. P0255 moves existing Accept/Decline inside the same panel and only reveals completion rewards/action at the final page, preserving the same shared button and fail-open Blizzard ownership. **The flash is OPEN and not fixed**: `QuestCompletionControl:Click()` intentionally restores stock before calling the native handler, and there is no validated temporal diagnosis. Do not alter protected/native claim handling merely to hide the flash. Claim and reward-choice functionality are untested; keep real quest 237 uncompleted.

Next: run P0255 applier (exact main baseline), require all static checkers and git diff --check PASS, user commit/push, deploy, `/reload`, test 1/2→2/2→1/2, offer actions and OFF/ON, export diagnostics only if needed. Do not assert that the native flash disappeared or that final claim succeeded.
