# P0254 — Complete Quest still outside the narrative panel (P0253 visual FAIL)

Date: 2026-10-18. Verified pushed GitHub main `3c0a017` (P0253). The user reports that the Complete Quest appearance is **unchanged** after multiple attempts, despite P0253 physically reusing `acceptButton` and `offerActionRoot`. This is a **user-observed visual FAIL**. No claim was attempted; quest 237 remains reserved.

## Narrow cause

The existing `Quest/Dialogue.lua` anchors `offerActionRoot` using `SetPoint("TOP",root,"BOTTOM",0,offerStyleValue("y"))` with y=-4, and the 62px action root positions button center at +9. Consequently the shared action label is approximately 26px **below the panel**. The 34px reward row plus 42px per-row pitch extends the panel to 391px for one reward, but the button remains anchored to its bottom edge. The screenshot visibly shows gold text over terrain, below the gold narrative bottom border. The button factory is already the correct Accept factory; copying it or adjusting draw layer cannot repair the spatial relationship. Approved design reference `Pasted image 20261003025305.png` shows Complete Quest as a gold-underlined action **within** the dark narrative region, like Accept.

## Proposed correction and bounds

P0254 keeps P0253's shared physical Accept button and `QuestCompletionControl.lua` unchanged. **Only after** the guarded control has captured and suppressed native inputs does it reposition that original action root 64 UI units upward, inside the narrative, with the same normal gold text and rule. `UpdateOfferControls()` restores the original root anchor whenever normal Accept/Decline own the interaction. For a multi-page completion, the page count/chevrons shift to the lower right instead of overlapping centered Complete Quest; ordinary offer paging stays centered. Zero-card completions reserve the same minimum panel height as a single-card completion. No new art assets, fonts, click routing, native frame mutation, secret reads, or polling are introduced. The fallback leaves native Blizzard controls available. The approximate centered action position is 38px above panel bottom, with page navigation entirely to its right.

## Test status

Source geometry and checker invariants assessed statically; **full WoW visual acceptance UNVERIFIED**. Inspect quest 237 without clicking Complete Quest; verify same reward, panel-contained label/underline, pagination lower right, Immersion OFF/ON, and `clicks=0 claimCalls=0`. The original P0253 visual FAIL and P0251 R2 OFF/ON failure remain durable. Actual quest claim, selectable choices, and intermittent item-name cache branch remain DEFERRED/OPEN.
