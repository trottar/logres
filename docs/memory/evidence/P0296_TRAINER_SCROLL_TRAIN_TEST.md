# P0296 — Live trainer scroll thumb and guarded one-skill training test

Date: 2026-10-22. Verified baseline GitHub `main` P0295 `7b1a459` (`0.0.196-dev`). **PREPARED; WSL full suite and WoW runtime UNVERIFIED.**

## User evidence / negative results

P0295 user screenshot and statement: clicking Logres skills works, with matching local details; local filtering and wheel scrolling also work. **New observed failure:** the visible gold scrollbar thumb is static and unclickable, despite wheel changing the seven-row viewport. This is source-confirmed: `TrainerLandscape.Render` paints a fixed gold rectangle, and only the separate arrow mouse regions and list wheel change browse offset. Native training through Logres has never been attempted; readiness to try is user intent, not source/runtime proof. Live `Visible services` remains inert and unsourced.

## Scope and hypothesis

The accepted synthetic P fixture remains unchanged. Only live rendering omits the static thumb, and a live owned vertical Slider supplies real thumb position, drag and track-click behavior. `refreshBrowse` adjusts range and value while suppressing callback feedback; scroll handlers still resolve bounded offset. No OnUpdate or generic hooks.

`TrainerPurchaseTrial` isolates actual one-service purchase authority from the read-only probe and list/fixture renderer. P0296 offers a narrow owned **Train selected (TEST)** click region ONLY after an explicit local row click. The controller requires current trainer state, visible nonprotected stock root, out of combat, same trainer NPC and total count, copied bounded native service ID, live six-field Forever source (name/rank/texture/type/level), available status, cost equality, ordinary money and affordability, and no profession-slot ambiguity. Then and only then, issue exactly one `BuyTrainerService(serviceIndex)` from the physical user click. Protected/API failure defers, rather than touching Blizzard controls. After a successful Lua call the Logres stale snapshot hides, leaving Blizzard's stock trainer visible; it does not assert that the server accepted/trained the spell. Native Train All remains untouched. A subsequent trial requires deliberate H ON refresh.

## Validation / deferred

Exact clean main and Git blobs, all anchors, candidate trailing whitespace, memory target, full PREWRITE/POSTWRITE `tools/check_*.py`, `git diff --check`, manifest; no Git writes by assistant. WoW H ON: wheel, thumb drag/track click, arrows, filters/clamp, skill clicks/details, OFF and trainer closure. For optional user-authorized single purchase choose a currently Available affordable skill; click Logres skill then its Train TEST ONCE. Verify Blizzard learned precisely that skill, deducted correct cost, and remains usable; verify no forbidden secret/protected errors. If not personally willing to purchase, mark training ENVIRONMENTALLY DEFERRED, not PASS/FAIL. No group/profession-slot training, Train All, changed source/filter recovery or released production ownership. Sidebar categories remain deferred. Existing P0294 click failure is preserved by P0295 records.
