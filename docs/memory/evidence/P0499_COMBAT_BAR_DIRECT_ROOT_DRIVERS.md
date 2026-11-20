# P0499 — L-055 independently secured combat action-bar roots (2026-11-20)

## Verified baseline and repeated failure

GitHub main P0498 `40b020100373d4782ed312b0eff2c12075b46dbb`, tree
`bf4938b4674b91dd341aec93982a88d61c1dc88f` verified before
changes. Forever P0498 `0.0.364-dev`, session184 user reports action bars
vanishing during combat again. Report Bug #19127 (2026-11-20 11:41:23
EST) screenshot shows absent action bars while action policy requested
primary/Bar4=1, secondary/pet=.85 and utility/Bar5=.75; shared state
reported combat=false. The action driver's registration=registered does
not establish that its restricted snippet completed. #19139/#19143/
#19149 follow combat-entry journal events but still record ordinary
`policyName=world`, all requested alpha0, with shared state lagging.
After exit #19130 shows owned alphas0, consistent with resting policy.
This is a recurrent client failure, not a one-off; L-055 OPEN.
The exact cause of the missing alpha remains UNPROVEN without in-client
restricted execution evidence. P0498 diagnostic success was not a fix.

## Narrow P0499 hypothesis and candidate

The previous `ActionContext` secure driver uses one frame to update six
protected-root alphas and 70 activation-feedback references. Its
registration boolean does not prove those writes occurred; if a
restricted operation fails or the shared state callback lags, action
bar icon visibility can remain zero through combat. P0499 retains the
existing shared driver and keybind/feedback separation, and adds six
independent `SecureHandlerStateTemplate` state drivers **one per
existing addon-created action/pet cluster root**. Each driver's sole
frame reference points to its matching cluster; `ActionButton.CreateCluster`
retains its original constructor signature. Their `logresbar` restricted
scripts call the referenced cluster's `SetAlpha` only in combat: primary 1,
secondary .85, utility .75, Bar4 1, Bar5 .75, pet .85. `rest` is inert;
ordinary OOC hover and exit reconciliation stay authoritative. This
is not repeated polling and does not inspect Blizzard protected state.
One out-of-band `PLAYER_REGEN_DISABLED` event also synchronizes the
addon-owned **requested** combat policy immediately, even if the shared
state publisher has not caught up; it does not change protected roots
from ordinary Lua while locked. Protected mutations remain restricted
secure execution. On partial root setup failure the module unregisters
partial drivers and fails open to visible OOC actions. Disable/regen
restores stock safety ordering and unregisters all drivers OOC.

`logresCombatAck` resets outside combat on every registration
(including re-enable) and is set on a one-root driver only AFTER the
referenced cluster's combat SetAlpha. Named driver frames are cached
across module disable/re-enable to prevent duplicate global names. Report Bug publishes registration count and,
**only outside lockdown**, the count of ordinary, nonsecret addon-owned
acknowledgement tokens. Acknowledgement proves script progression, not
pixels rendered; in-combat snapshots cannot sample this token. No
secret-capable return from Blizzard presentation is used.

## Tests / runtime gate

Historic P0489–P0493 actual-source alpha, hover, regen and feedback
fixtures must remain PASS. P0499 extends the P0491 actual-source fixture
to simulate direct per-root combat transitions with the shared driver
silent, an out-of-order shared state publisher and no insecure protected
SetAlpha. P0499 new checker asserts six secure root owners, OOC-only
registration/teardown, existing shared driver, unchanged rest/hover,
additive diagnostics, unchanged binding and no timers/polling. Complete
historical checker suite and final ZIP test are hard pre-handoff gates.

**WoW runtime UNVERIFIED** until tested: active combat must show each
bar at its expected opacity without hover and no protected-action/taint
errors; OOC all bars0 except hovered; pet and keybinds intact; report
combat and postcombat incidents to inspect registration and ack counts.
If any root remains invisible despite ack, do not claim this fixes L-055;
retain failure and isolate actual rendered/parent ownership in game.
L-002 P0498 quest-stage handoff is unchanged and remains independently OPEN.

## P0499 R1 — WSL full-suite fixture correction (2026-11-20)

The P0499 R0 one-time applier correctly REFUSED with **zero tracked
writes**: first 359/360 when `check_p0499_direct_cluster_combat_contract.py`
required the missing Lua engine, then 358/360 after Lua 5.4 was installed.
The two subsequently failing checkers (`check_p0463_regression_repair_contract.py`
and `check_p0470_target_policy_contract.py`) both execute the historical
P0460 selected-removal Lua fixture. It extracts `RefreshLiveWorldEnemy()`
from actual `HUD.lua`, which now calls the P0496 `hideCastCue` helper as
part of the selected-world screen-to-world handoff. The historical
fixture omitted that helper and the owned screen cue object, causing
`HUD-selected:166: attempt to call a nil value (global 'hideCastCue')`.
The earlier assistant-side complete static count did not run this Lua
5.4 branch; it must not be represented as full actual-source PASS.

**R1 correction:** Add an addon-owned `targetCastCue` fixture and a
strict `hideCastCue` stub that checks the expected frame and forced
withdrawal, then assert the first selected-world attachment actually
hides the cue. This updates only the test harness and audit evidence;
`HUD.lua`, action-bar runtime code, secured input, quest logic and
P0499 intended opacity behavior are unchanged from R0. Historic checkers
are not weakened. L-055 remains OPEN; visual combat validation is still
required in Forever after the user applies/commits/deploys R1.

R1 Lua-5.4-enabled corrected candidate audit: **360/360 historical
Python checkers PASS**, including both user-failed historic contracts,
the P0460 actual-source selected-world fixture, and P0499 root action
fixtures. Complete exact-ZIP rerun and transactional guards remain
required before delivery; no WoW runtime PASS is claimed.
