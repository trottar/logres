# P0272 — Opt-in, event-driven native service placement handoff

Date: 2026-10-19. Baseline: verified pushed P0271 `993d9fbabfa79a0012b8320c957f3492bfaaaf1c`.

## Runtime evidence received for P0271

The user explicitly reported all in-client P0271 steps worked. Screenshots show a real Blizzard merchant (Grenil Steelfury) and herbalism trainer (Reyna Stonebranch) moved without replacing their merchant/trainer controls; the developer-panel transcript records `trial-centered-merchant` and `trial-centered-trainer`. Latest 0.0.169-dev diagnostics show `starts=3`, `restores=3`, `autoRestores=2`, `failures=0`, `nativeTransactions=0`, `active=none`, `pending=false`, and Run All completed with no reported FAIL within the observed scope. This establishes **manual** placement and restoration only. It does not establish automatic placement, actual purchases, repaired equipment or trainer transactions.

P0271 also added TaxiFrame to the read-only audit. User screenshot reports `flight-taxi: frame=TaxiFrame loaded=present protected=no GetPoint=method-present SetPoint=method-present` while FlightMapFrame remains absent. Flight presentation identity/action and safe positioning are *not* established; flight is still stock/DEFERRED.

The H button label `Native Service Center / Restore (TEST)` visibly crowds the adjacent action on the user's screenshot. P0272 reuses the same registry slot with a shorter label; no extra H button is registered.

## Narrow question and implementation

Can we automatically center **only** the already-proven Blizzard-owned merchant/trainer windows, without creating a new transaction interface, altering the camera or losing stock restoration?

P0272 uses the *existing* `NativeServicePlacementTrial.Toggle()` and exact native anchor capture/restore. Automatic mode defaults OFF, and must be explicitly armed from `H — Native Auto Position (TEST)` or `nativeserviceplacement auto on`. A state subscription only reacts while armed to addon-owned normalized interaction transitions (merchant type 5, trainer type 7); an optional `OnShow` hook attaches **only to each verified ordinary unprotected native frame** while mode is armed, at most once per frame. These two event-driven callbacks cover common interaction/event order differences; they never poll, reassert layout on a timer, register broad Blizzard action hooks or mutate stock children.

Automatic reconcile on service change/closure restores the prior native anchors before any other center attempt. Existing native `OnHide` restoration and combat/regen deferral are retained. Turning OFF disables further automatic changes and attempts immediate stock restore; if in combat, restoration is deferred by the existing event-only regen path. The old manual `nativeserviceplacement toggle`/`off` remains a developer-only fallback. A missing, restricted, protected, not-yet-shown or unavailable frame defers the placement without suppressing Blizzard UI; a close/restore failure is real FAIL.

No textures, buttons, quantity selection, repair/buyback, trainer filters/learning, input, scripts unrelated to the two frame lifecycle hooks, camera or DynamicCam are replaced. Flight/TaxiFrame, bank, auction and other service frames remain untouched. P0268's rejected synthetic service catalogue must not return.

## Testing and evidence boundaries

The ZIP applier pins exact P0271 pushed main and clean tracked/index status, validates all source/frozen baselines, builds a shadow candidate, runs all 139+ repository static checkers with whitespace checks before writes, then repeats the full suite postwrite. Separate local Python syntax and checker smoke tests do not prove WoW behavior.

In WoW, first arm with no NPC open, visit an ordinary merchant and then reopen to verify automatic centering. Use native Merchant/Buyback/quantity/repair controls without needing to spend gold. Close with Blizzard X and verify stock restoration. Repeat at a nearby trainer if conveniently available; if not, record DEFERRED. Disable the H button while merchant is open; stock anchors must return, and the next visit must stay stock. Check `/logres nativeserviceplacement auto check`; `failures=0`, `pending=false`, `active=none` after closure, `autoStarts>0` after an eligible interaction. Run All and export diagnostics. Native purchase/repair/trainer *transaction* success remains unverified and is not required for the trial.

Stop and preserve evidence if the automatic handoff does not trigger, an input click region becomes unusable, taint/Lua/protected/secret errors occur, or stock restore fails. These are OPEN runtime failures, never accepted based solely on static results. Do not ask user to travel to a contrived NPC for coverage.

## Negative history retained

P0270 R0 failed its static shadow inventory because the H action bumped totals without synchronized historical checker updates; P0270 R1 corrected it. P0268 custom synthetic vendor/trainer/flight catalogues violated D-047 and were retired by P0269. Neither is reopened by P0272. No new in-client failure is claimed before P0272 deployment.

## P0272 subsequent scoped WoW evidence and incomplete Git checkpoint (2026-10-19)

User 0.0.170-dev diagnostics after installing P0272 showed auto toggle ON, two native placements, OFF restored to stock with `starts=2 restores=2 autoStarts=2 autoDeferred=0 pending=false failures=0 nativeTransactions=0 autoEnabled=false`. User confirmed interactions worked and supplied screenshots contrasting left-stock GossipFrame and centered ClassTrainerFrame following **Train me**. Run All was completed without reported FAIL within tested scope. No actual merchant purchase or trainer transaction was performed as test. This is **scoped automatic placement/restore acceptance**, not full service ownership or style acceptance. The visible gossip-to-trainer position jump remains OPEN for P0273.

Remote `main` HEAD `c5ef384530fc452e37102cc11e395c63c37bb3e9` contains the P0272 runtime code (0.0.170-dev) and P0272 memory pointers, but its commit message says P0271 and it lacks original `tools/check_p0272_native_auto_handoff_contract.py`, the P0272 evidence/patch records and `P0272_MANIFEST.txt`. The original WSL applier/full-suite output was not provided, so **do not claim that its 139-checker gate passed**. P0273 restores missing checker and history records in a later checkpoint; the original P0272 manifest is **not fabricated**. These historical omissions do not invalidate the supplied functional client observations, but they are a distinct repository integrity defect that must be retained in memory.
