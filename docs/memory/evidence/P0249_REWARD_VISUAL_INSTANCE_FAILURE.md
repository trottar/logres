# P0249 — P0248 reward visual instance runtime failure and repair

Date: 2026-10-18. Confirmed pushed P0248 `cfd67be` on GitHub `main`; runtime addon version `0.0.148-dev`, diagnostics `LogresDB.meta.loadCount=326`. Source: user-uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`, records near lines 2658–2682.

## Observed runtime failure

- `/logres questrewardpreview single`: `Logres command error: Interface/AddOns/Logres/Quest/Dialogue.lua:1258: attempt to call a nil value`.
- `/logres questrewardpreview multi`: same error and line.
- After previews, `Quest Dialogue Check: PASS` only for its pre-existing checks; the `rewardvisual` diagnostic had `cards=0 overflow=false stock=retained`. This **does not** validate the reward UI.
- No evidence that the native Blizzard selection or claim controls were affected; visual correctness remains unverified.

## Narrow cause

P0248's `RewardVisual.New(root, objectiveText)` returned a new plain table containing only `root`, `objectiveText`, and `slots`. `Visual:Reset()` and `Visual:Present()` are methods of the module table `Visual` and were not present in or inherited by the returned object. `Dialogue:PresentText()` calls `self.rewardVisual:Reset()` when the view is prepared, so attempting either preview hit a nil method. The source location matches the reported `Dialogue.lua:1258`. Existing static tests asserted that the methods existed separately, but omitted a check that an instance could dispatch to them. This is a code regression introduced in P0248, not an API availability, secret-value, or item-data cache failure.

## P0249 corrective policy

Change only the constructor to use `setmetatable(instance, { __index = Visual })`, retaining all existing fields. Add a P0249 checker guarding instance lookup and a standalone Lua-stub method-dispatch test in patch preparation. Do not modify quest sources, protected Blizzard UI, selection/claim behavior, or add polling. The next natural quest completion may test the real portrait path, but no forced travel is required. Runtime acceptance remains pending until both synthetic previews succeed in client. Previously unresolved missing-name branch and untested live multi-choice stay OPEN.
