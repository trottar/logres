# P0315 — guarded live gossip source/model candidate

Date 2026-10-22. Baseline GitHub `main` P0314 `f40a8e0`. **PREPARED / full WSL static and WoW runtime UNVERIFIED**.

## User-observed previous checkpoint

User reports latest pushed P0314 successful, with no noticed issues. This is scoped user runtime feedback for tested profession trainer presentation, not a recorded independent test of every Cooking/Enchanting/Fishing path, profession purchase after parking, safe Blizzard UI restoration under lockdown, or class regression. P0314 prior evidence and P0311 failures are retained. No invented runtime diagnostics.

## New narrow hypothesis

A one-shot H-panel read of the active NPC can copy ordinary `C_GossipInfo` text and rows into the **existing** `NPCOptionModel.FromValidated` envelope without native selection or stock suppression. Prior `QuestInteractionProbe` only captured a small scalar diagnostic, not a complete option-model adapter. The approved P branching/services/overflow/locked previews and quest narrative/option renderer are unchanged.

The P0315 adapter accepts only an ordinary addon-owned interacting state and verified `npc` unit/name. `GetOptions`, `GetAvailableQuests`, `GetActiveQuests` and `GetText` are individually optional/capability-gated. Every returned table/row/field is screened before inspection; options are bounded at 24, title/body at 2048 bytes. It deliberately refuses truncated, secret, invalid, mixed quest/gossip or missing text data. An accepted model contains only source-copy labels and an inert option list (`enabled=false`) so the preview-only option session can never select live gossip. The model is **not presented live** in P0315; the H diagnostic reports a model-ready or explicit deferral status. Blizzard gossip stays fully usable. No camera, quest, trainer, native window, event, timer or transaction mutation.

## Validation

Apply on clean exact pushed P0314. Complete **186/186** prewrite checker suite in a shadow tree, postwrite suite, `git diff --check`, and manifest. Static checks are **UNVERIFIED until executed in WSL**. Deploy and `/reload`, speak with an ordinary nonquest NPC, open `/logres panel` > H — Integration and Polish > **Gossip Source Check (READ-ONLY)**, inspect result and export diagnostics as usual. Repeat at an NPC with quest entries for deliberate `mixed-quest-gossip-stock-retained` deferral where supported; do not accept/claim quest 237 or force any special interaction. Inspect in-game for Lua/secret/taint failures. No visible Logres gossip change is expected; Blizzard gossip remains in control. A missing API or unknown context is **DEFERRED**, not PASS/FAIL. Lua/protected errors are FAIL.

## Subsequent gate

After source samples identify the client-specific capabilities, use the existing P option renderer to present **read-only** NPC gossip while preserving an explicit native fallback. Live selection, quest linkage, native hiding and session transition remain separate, unapproved action gates. Preserve all negative observations and runtime deferrals. This patch is not an assertion that the Forever gossip API is fully supported.
