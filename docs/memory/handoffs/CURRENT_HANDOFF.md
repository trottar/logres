# Current Handoff — P0257 preview-first reward model

Authority: `docs/memory/CURRENT.md`, `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, and `docs/memory/evidence/P0257_PREVIEW_LIVE_REWARD_MODEL.md`.

GitHub `main` `23307aa` verifies P0256 pushed. Uploaded `0.0.156-dev` screenshots confirm the P tab and its 2/2 page, but show both reward previews using Blizzard guidance. The user's newer **The Lost Standard** screenshot explicitly accepts the in-panel Accept/Decline preview (scope: visual preview only). P0257 adds pure `QuestRewardModel` Preview/FromLive adapters, same RewardVisual card renderer and genuine shared Complete Quest button geometry for synthetic single-item preview; preview click is always inert. Choice sample remains read-only; native claim restoration, Blizzard fallback, secret/protected gates and the known native flash are unchanged.

The D-046 requirement applies to **every Logres UI element**: authored fixture -> one plain model -> same production view -> visual acceptance -> guarded live data source -> separate action controller. R0 failed P0254 geometry shadow validation and R1 failed new P0257 checker/adapter string parity, both before tracked writes; R2 fixes the checker and tests it on generated source. This patch is just the first implementation; other element previews remain OPEN. Runtime in-client validation pending. Preserve quest 237 unclaimed. Further 20-minute play bugs are OPEN / DETAILS PENDING after NPC dialogue.

Next: applier full suite; user commit/push; verify remote; deploy and inspect P — Previews Single/Multiple/Quest Dialogue. Confirm no native quest mutation. Then complete NPC preview fixture matrix before other gameplay bugs.
