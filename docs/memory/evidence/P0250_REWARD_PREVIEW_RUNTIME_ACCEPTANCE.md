# P0250 — P0249 reward preview scoped runtime acceptance

Date: 2026-10-18. Remote authority: GitHub `main` at verified P0249 commit `aaee288` (`0.0.149-dev`). Sources: two user-provided WoW screenshots and uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` (`LogresDB.meta.loadCount=328`, final runs).

## Observed and accepted

- `/logres questrewardpreview single` -> `Logres questrewardpreview: PASS (mode=single state=shown)`; screenshot shows the portrait card, readable item name, `x3`, and `1050 XP | 7s` sample footer.
- `/logres questrewardpreview multi` -> `Logres questrewardpreview: PASS (mode=multi state=shown)`; screenshot shows four cards in two columns, three `CHOICE` badges, an `x2` stack, and the sample XP/money footer.
- `/logres questdialoguecheck` -> `Logres questdialoguecheck: PASS` with `shown=true`, `presentationReason=reward-preview`, `error=nil`. Scoped module diagnostic only, not a claim that all runtime behaviors passed.
- Both previews visibly rendered without the prior `Dialogue.lua:1258` nil-call error. The P0249 constructor-method regression is **RUNTIME PASS, preview scope only**. The P0248 R2 runtime failure and earlier R0/R1 prewrite errors remain historical failures.
- The diagnostics line `questdialogue rewardvisual: CANDIDATE (cards=0 overflow=false stock=retained)` is not evidence of live cards because no real `QUEST_COMPLETE` occurred in this P0249 capture. Preview PASS is established by preview-specific lines and screenshots; do not reinterpret candidate state as live reward acceptance.

## Presentation and validation boundaries

- The diagnostics panel covers the rightmost region of the two-column preview in the screenshot. This is an overlay obstruction from the open developer panel, **not evidence that Logres cards clip one another**. Full unobstructed geometry remains not independently validated. User has not reported an intrinsic clipping defect.
- The previews use synthetic sample reward values. Natural guaranteed-item portrait parity (name/icon/quantity/XP/money) at 0.0.149-dev is **DEFERRED** until a naturally available quest completion; live multi-choice reward source parity and Blizzard choice/claim interactions remain **DEFERRED**. Do not require travel or artificially manufacture a quest.
- Historical reward-name availability inconsistency (P0245/P0246) remains **OPEN / INTERMITTENT**. P0247 succeeded in an ordinary-name branch, which does not prove event-cache recovery.
- A fresh Phase 0 Run All was **not observed** in these materials. No blanket suite PASS is recorded. No Lua/taint/protected/secret failures were observed in these particular preview runs, not a general absence claim.

## Next

Document this scoped runtime acceptance without altering runtime Lua. At the next natural quest turn-in inspect the real reward presentation and stock claim/choice fallback; if the user requests visual refinement, separately assess unobstructed sizing/legibility against Logres visual policy. Keep the live multi-choice path deferred until actual evidence becomes available.
