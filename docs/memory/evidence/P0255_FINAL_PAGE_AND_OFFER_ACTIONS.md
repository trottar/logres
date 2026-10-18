# P0255 — P0254 acceptance and final-page quest-action layout

Date: 2026-10-18. Remote `main` verified `2a7bc5d` P0254. User screenshot in version `0.0.154-dev` and explicit **“Much better!”** confirm the original Complete Quest action is now visibly inside the dark Logres quest narrative panel. **P0254 visual placement PASS (scoped)**. Do not infer that final claiming, selected-choice behavior or all paging paths passed. Preserve historical P0252/P0253 visual failures and P0251 R2 OFF/ON regression.

## New user-observed problems

1. Rewards and Complete Quest are already visible on page **1/2**, before the player reaches page **2/2**. The correct presentation policy is to show completion rewards and the claim action only on the final narrative page. `Dialogue:PresentText` began on page one, while `HandleQuestComplete` immediately presented reward cards and activated the completion action irrespective of `currentPage`. **OBSERVED PRESENTATION FAIL**.
2. The quest offer Accept/Decline actions remain below the narrative border. In source, `UpdateOfferControls()` still restores the below-panel anchor, unlike the now-correct P0254 completion anchor. **OBSERVED PRESENTATION FAIL**.
3. On pressing Complete Quest, the Blizzard reward window reportedly becomes visible briefly (less than a second). **OPEN / USER-OBSERVED / MECHANISM SOURCE-SUPPORTED; NOT REPRODUCED IN A CONTROLLED DIAGNOSTIC.** `QuestCompletionControl:Click()` intentionally calls `Restore("claim-invoked")` to re-enable native click controls **before** calling the Blizzard `QuestRewardCompleteButton_OnClick()` handler. The exposure is consistent with this ordering, but no temporal event/claim trace establishes that this alone accounts for the flash. Do NOT remove restoration, hide a protected native frame, add a timer/polling re-hide or call `GetQuestReward` directly without narrower evidence. Preserve accessible Blizzard fallback. This checkpoint makes NO native claim path changes.

## P0255 candidate changes

- `Dialogue:UpdateCompletionPagePresentation()` guards only addon-owned cards, reward footer and action-root visibility. Nonfinal pages hide them, collapse to the ordinary narrative height, and leave page navigation usable. Final page restores dynamic card data and guarded action visibility. This runs after the initial reward render/stock gate and on every `SetPage`, and after an item-data resolution; the already-proven `CompletionControl` safety gate and native snapshot remain unchanged.
- `UpdateOfferControls()` expands the offer panel to 391 units only while its proven action buttons are present and moves the **actual Accept/Decline** pair inside it. On offer nonfinal pages it restores idle geometry and lets page navigation work. The final-offer page indicator moves to the lower-right rail above the two buttons; completion navigation remains in its own lower-right rail.
- Complete Quest still shares the existing Accept object; no new widget or texture is added. Stock offer and reward claim operations remain guarded and fail open. Natural quest 237 is reserved and must not be clicked for testing.

## Acceptance boundary

Static checks remain unverified until the applier passes all repository checkers. In-client validation is required for page 1/2 suppression, 2/2 final reward/action visibility, back navigation, real Accept/Decline inside the panel, no overlap, and Immersion OFF/ON fail-open restoration. **Do not claim claim-handler execution, removal of Blizzard flash, or multi-reward interaction PASS.**

## P0255 push and subsequent preview-first scope change

GitHub `main` `fc74e14` verifies P0255 pushed. User reports Accept/Decline not visually aligned with the panel, but the most recent screenshot carries runtime `0.0.154-dev` whereas P0255 source is `0.0.155-dev`; exact P0255 layout behavior in WoW remains **UNVERIFIED**, not a proven new regression from that screenshot. User prioritizes preview-first NPC dialogue and universal developer previews for every UI element. P0256 is infrastructure for that workflow, not an implicit acceptance of the P0255 style. The post-claim Blizzard frame flash remains OPEN with native restore-before-handler intentionally preserved. Additional 20-minute gameplay bugs are acknowledged but unspecified (OPEN / DETAILS PENDING).
