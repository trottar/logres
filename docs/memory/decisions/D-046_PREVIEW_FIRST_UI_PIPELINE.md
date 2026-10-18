# D-046 — Preview-first modular UI pipeline

**Status:** ACCEPTED design requirement (2026-10-18). Scope: **every Logres-owned UI element**, across HUD, actions, compass, quests, auras, menus, cast/status indicators, pet and target UI, not only NPC dialogue.

## Required pipeline

**Fixture → plain presentation model → shared renderer → visual acceptance → guarded live adapter → separately controlled interaction.**

- Every element receives at least one **P — Previews** entry before live source attachment; enumerate additional states needed to prove pagination, overflow, empty/missing data, disabled controls, priority, hostile/friendly, and failures.
- A fixture contains synthetic, deterministic data; it must not accept, complete, decline or select a quest, mutate Blizzard secure/protected state, or depend on a particular gameplay opportunity.
- A source-specific adapter collects live data only through guarded, evidence-backed APIs; it produces the **same view-model shape** as the fixture. Never inspect secret-capable values until proved ordinary, and never add polling simply to obtain a sample.
- The **same view construction and rendering methods** must consume both preview and live models. Never create a look-alike preview with different frame hierarchy, typography, textures or positioning.
- Gameplay interactions remain **outside** the renderer and use deliberate, capability-gated controllers with fail-open Blizzard fallback. Preview interactions must be inert with respect to gameplay.
- The preview must be inspected in WoW before the live adapter/integration is accepted. Existing tests, scoped runtime PASS, environmental deferrals, visual failures, and uncovered variants must remain recorded.

## First migration — P0257 quest rewards

`Quest/RewardModel.lua` supplies `FromLive` and `Preview` models. Both flow into `Quest/RewardVisual.lua`'s existing `Present(cards, footer)` view. The preview uses the production's `completionRewardCard` icon normalizer and shared Accept/Complete action appearance. Its input route remains preview-only; native reward claiming is not invoked. Choice cards remain visual-only with explicit Blizzard selection fallback. This is the first exemplar, **not** a declaration that all other UI elements are preview-complete.

## Nonnegotiable safety boundaries

Keep native quest/action controls until a supported replacement exists. Never interpret a preview visual PASS as production capability, and never conceal native restoration transitions by speculative hide/show timers. Preserve quest 237 until the user intentionally claims it.
