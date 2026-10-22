# P0304 — event-driven NPC session and automatic class trainer presentation

Date: 2026-10-22. Baseline verified GitHub `main` P0303 `4f7f9b59a5a12fd485094054a9fad748e7762cca` (`0.0.204-dev`). **P0304 PREPARED; complete WSL static and WoW runtime UNVERIFIED.**

## User-observed status

The user applied P0303 R1 and reports "everything still works as expected." Verified current `main` contains P0303. Treat this as scoped regression PASS for previous trainer search, filter, selection, browse, hover, Goodbye and tested transaction paths, not an exhaustive lifecycle/audit proof. Previously the user reports every offered spell learned after a deliberate Logres Train All click; no new purchase is required.

## Narrow source finding

`TrainerLiveTrial.Toggle("on")` already constructs the accepted Logres panel from a guarded `NativeTrainerServiceProbe.Read()`, while `TrainerPurchaseTrial` requires native `ClassTrainerFrame` be **shown and not protected** for each purchase. `Core/State.lua` normalizes `PLAYER_INTERACTION_MANAGER_FRAME_SHOW/HIDE`, and the native root can be hooked once through `HookScript("OnShow")` if ordinary and not protected. A state callback alone can precede lazy-loaded native frame display; an OnShow hook resolves that race without timer/polling. D-047 requires service-neutral session lifecycle while keeping source/transaction service-specific.

## Candidate P0304

Add reusable `UI/NPCServiceSession.lua`, loaded after existing trainer and lifecycle modules to preserve P0288/P0303 historic `.toc` adjacency contracts. Register one trainer consumer with interactionType 7, native frame `ClassTrainerFrame`, lazy-loaded addon `Blizzard_TrainerUI`, and existing trial open/close/visible callbacks. The session checks addon-owned interaction context, ordinary nonprotected native root, native IsShown and out-of-combat before automatically invoking existing live toggle. A duplicate already-visible Logres view is not recreated. If combat interrupts the NPC visit, the session becomes dismissed until a fresh native visit instead of immediately re-opening after regeneration. `Trial.Disable("goodbye"/"trial-hidden"/purchase-requests)` marks that visit dismissed; the next observed session resets it. Event-driven hooks/state only, no native setters, camera hooks, or protected mutations. Any deferred entry leaves Blizzard fully usable.

## Limits and test procedure

P0304 does **not** suppress, alpha-zero, move, reparent, hide or disable native Blizzard controls. Automatic Logres presentation means both UIs may be seen simultaneously in this intermediate gate. Native suppression/restoration is still OPEN because a hidden native root could violate existing purchase guards or close the session. Native frame invisibility with active click regions is explicitly disallowed; stock controls remain usable. WSL checker PASS is not WoW PASS.

After deployment and `/reload`, speak with a class trainer without opening the developer panel; Logres should open automatically. Test search, scroll, selection, Goodbye dismissal for that visit, and close/reopen a fresh trainer session. Test H manual OFF/ON through `/logres panel` -> H Integration and Polish. The old Blizzard trainer must remain functional. If any Lua/taint/secret failure occurs, mark FAIL and retain evidence; if native auto hook cannot attach, record DEFERRED with scope, not PASS. No purchase required.

Next, after real default-on behavior succeeds, isolate the precise capability to suppress native presentation while preserving shown-source purchase API and guaranteeing restoration before Logres interaction teardown. Then native gossip, merchants and flight masters in that order with the exact approved trainer visual language.
