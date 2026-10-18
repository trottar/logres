# P0257 — preview-first modular UI pipeline and quest reward parity

Date: 2026-10-18. Baseline GitHub main `23307aa` (P0256 pushed).

## Observations

- User's `0.0.156-dev` screenshots show the P — Previews gallery on page 2/2, a reward-only sample with one guaranteed item, and a multiple-card sample. Both preview footers still display native Blizzard instructions. The single-item preview has no in-panel Complete Quest action, although an ordinary live completion already has a shared Logres action and accurate item/XP/money presentation.
- A later screenshot of the **The Lost Standard** sample shows the Accept and Decline controls positioned within the narrative border; user explicitly says **"This looks correct here"**. This is a scoped *preview* visual PASS, not proof of live quest-offer ownership or claim behavior.
- The provided diagnostics contain commands `questrewardpreview single`, `questrewardpreview multi`, and `questdialoguepreview` with `PASS (state=shown)` on preview runs. These command-success results do NOT demonstrate model/layout parity by themselves; the screenshot reports are authoritative for the visual defect.
- `Logres/Quest/Dialogue.lua:ShowRewardPreview` currently bypasses completion-action visual setup. The preview directly calls `RewardVisual:Present(cards, footer)` with authored data and Blizzard-fallback instructions, while the production completion initializes the exact shared Accept/Complete control separately.

## Accepted project-wide design rule — D-046

**For EVERY new Logres-owned UI element**, deliver and validate a deterministic, nonmutating preview model through the same visual renderer used for live data **before** attaching a live source or gameplay interaction. The standard architecture is:

1. **Fixture:** authored/controlled preview data with real edge cases; no gameplay or protected state reads.
2. **Live adapter:** capability gated, secret-aware, source-specific collection that produces the *same* presentation model. On incomplete data, fail open to stock.
3. **Model contract:** plain render fields independent of UI source and gameplay authority.
4. **View:** one reusable renderer / texture / typography / frame-geometry path for both preview and production.
5. **Interaction controller:** separate guarded, explicit authority for real actions; preview-only actions have no gameplay routing.
6. **Contract and runtime validation:** preview parity, data edge cases, Blizzard fallback/ownership, and true in-client rendering before claiming acceptance.

Preview controls remain centralized in P tab; diagnostics and potentially mutating commands stay in phase tabs. Do not add fake UI preview duplicates and later bolt on unrelated production visuals. Every missing preview documented in P0256 is still OPEN.

## P0257 implementation

Adds `Quest/RewardModel.lua` with `FromLive(cards, footer)` (wraps already validated data only) and `Preview(mode)` (authored Single/Multiple fixture). The production quest path uses the model envelope while retaining the exact `QuestRewardVisual:Present` renderer. The preview fixture runs the same `completionRewardCard` icon normalization; item ID 858 is a sample-only icon hint and never a hard-coded quest reward lookup. Single preview shows the **existing shared Accept button** labeled Complete Quest, positioned by the same in-panel geometry as supported live completion. Its click is routed to the existing `offerActionPreview` branch and can never call the native completion handler. Choice preview renders choice cards but **no fake interactive choice picker**; Blizzard remains the safe fallback.

This patch does **not** change protected/native completion calls, quest data acquisition, multiple-choice selection/claim authority, or the known brief native-frame flash on real claim. Runtime visual acceptance and true claim interaction remain UNVERIFIED until observed; quest 237 remains reserved.

## P0257 R0 negative result / R1 correction

User's WSL applier ran against the exact pushed P0256 baseline and clean tracked source, then refused during shadow static validation: `check_p0254_completion_panel_placement_contract.py` reported `completion positioning must be a single, gated site`. R0 introduced a second copy of the P0254 `offerStyleValue("y") + 64` layout formula inside the synthetic preview. **R0 is FAILED STATIC / NO TRACKED SOURCE WRITTEN**, not a runtime failure or a successful UI change. Root cause is duplicated presentation geometry rather than missing data.

R1 defines a single `Dialogue:PositionCompletionActionVisual()` method with the original P0254 in-panel anchor. Guarded live completion calls the method only after successful stock ownership, and a synthetic `offerActionPreview` path calls the same method with preview-only click routing. The historical P0254 checker is updated to require the unique geometry method and verify the guarded call. The P0257 checker additionally rejects duplicate geometry and any third completion button. Stock restoration-before-claim and multi-choice fallback are unchanged. **R1 runtime unverified.**

## P0257 R1 negative result / R2 correction

The user's R1 WSL applier passed the exact P0256 baseline and prepared all 17 files, then **failed in shadow validation** at `check_p0257_preview_pipeline_contract.py` with two errors: `missing shared view/preview routing local model = Logres.QuestRewardModel.Preview(mode)` and `preview parity missing local model = Logres.QuestRewardModel.Preview(mode)`. The actual intended preview adapter has `local model, errorReason = Logres.QuestRewardModel.Preview(mode)` and an explicit `if not model then return false, errorReason end`. The checker, not the guarded source logic, had two stale single-result string assertions. **R1 FAILED STATIC / NO TRACKED WRITES**, distinct from R0's P0254 geometry failure.

R2 corrects both checker expectations, requires the explicit preview error branch, and runs the new checker **against the actual prepared source before the full shadow suite**. It also performs a negative check by deleting the binding in a temporary copy and requiring the checker to fail. This catches checker/implementation mismatches at the generation boundary. The R1 shared layout geometry, live quest reads, stock restoration-before-claim, and preview-only input routing remain unchanged. R2 is runtime UNVERIFIED until applied and observed in WoW; quest 237 remains unclaimed.
