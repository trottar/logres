# P0300 — Trainer Goodbye navigation and P0299 search runtime result

Date: 2026-10-22. Verified GitHub main P0299 `b33bba205b65721c2213e3e19f1373e437e493b3` (0.0.200-dev). **P0300 R1 PREPARED; R0 PREWRITE FAILED, WSL full suite and WoW runtime UNVERIFIED.**

## Observed user result

User submitted three P0299 WoW Forever screenshots: live local search `curse` returns eight matching names across available and unavailable services; combined Available only reduces to a single `Curse of Recklessness (Rank 1)` entry; uppercase `CURSE` reproduces eight results. User: "Everything works as expected. Also, need goodbye button like quests." This establishes **P0299 SEARCH RUNTIME PASS** for case-insensitive matching and search/filter combination. Screenshots do not prove all focus/empty-state/teardown permutations, slider drag, or native Train All. Existing P0294 row-click failure, P0295 static scrollbar, P0296 gold icon squares and P0297 black-icon regression remain preserved in their original evidence. P0298 fixed icon visibility in later screenshot. One prior single-skill training attempt succeeded; no bulk purchase was tested.

## Narrow design/source finding

`Logres/Quest/Dialogue.lua` P0266 creates a quest Goodbye button at TOPRIGHT (-45,-12), size 78×24, small highlighted gold text, 1-pixel underside rule and hover color. `Dialogue:Goodbye()` dismisses the presentation while preserving native fallbacks. Current `TrainerLiveTrial.lua` lacks any Goodbye control. The trial already has `Trial.Disable(reason)`, which clears the search EditBox focus, nils local browse state, hides the owned trial root and leaves native stock trainer untouched. This is an adequate, narrowly owned Goodbye semantic consistent with quest presentation dismissal.

## P0300 proposed change

Add one 78×24 input region only to the addon-owned live root at the same header anchor and visual colors as quest Goodbye. Use an ordinary-gated LeftButton `OnMouseUp`, addon-owned `Frame` (not a protected action button) to call `Trial.Disable("goodbye")` only when its owning trial is active. No direct `CloseTrainer`, native hide, native filter mutation, native training request, C_Timer, OnUpdate, hooks, or broad stock UI suppression. Source selection/search/slider/purchase adapters remain unchanged, and synthetic P fixture remains inert.

## Validation and limits

Guard clean pinned main/source hashes, candidate anchor agreement, full checker suite PREWRITE and POSTWRITE, memory/version/whitespace gates, manifest and rollback. In-client: `/reload`; `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST), hover then click top-right Goodbye. Expected: **Logres panel hides and its click regions disappear; Blizzard's native trainer stays open and usable**. Reenable trial and check local search, filters, skill details and OFF/close. Any Lua, taint or secret errors are FAIL and require a corrective patch. Do not infer train-all support from one single-service purchase. No new purchase needed.

## P0300 R0 PREWRITE negative evidence / R1 repair
User WSL output from P0300 R0 on clean P0299 `b33bba2` showed baseline pins, source hashes, candidate anchors, EOF and whitespace gates PASS, then **170/171 PREWRITE checkers PASS** with one failure: `check_memory_health.py` reported missing mandatory `## Do Not Reopen Without New Evidence` section from generated CURRENT.md. Applier stopped before tracked writes (no POSTWRITE or runtime). This was an assistant-authored memory-template omission, not a Lua or client failure. **R0 FAILED / CLOSED by R1 content repair, but R1 not yet validated.** R1 restores the required heading, adds preflight checks for all seven required headings, and preserves prior feature/controller code. Do not count R0 as a code or WoW PASS. All 171 PREWRITE/POSTWRITE checks must pass in WSL before commit; no WoW redeploy for the failed R0, runtime deployment required after successful R1.
