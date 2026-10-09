# P0175 R3 — Run All failure and preference restoration evidence (2026-10-08)

## Observation — FAIL, not PASS

User: "My mana bar is gone after run all". Follow-up upload `LOGRES_DIAGNOSTICS_LATEST.lua` at version `0.0.91-dev`, `loadCount=221`, reports `immersionEnabled=false` in saved settings. Latest Phase 0 Run All starts and prints State Check PASS and Sensor Check PASS, then aborts with `Interface/AddOns/Logres/HUD/StatusAuras.lua:273: attempt to index local 'rows' (a nil value)`; there are NO Preference, Lifecycle, HUD or Run All completion results for that run.

## Targeted source diagnosis

R2 `StatusAuras:Refresh` supplies `snapshot = { rows = {}, reason = "disabled", ... }` when Immersion is OFF. Immediately afterward, for target, it calls `renderLane(self.lanes.target, snapshot.harmfulRows, active)` and `renderLane(self.lanes.targetHelpful, snapshot.helpfulRows, active)`. `renderLane()` does `rows[i]` unconditionally. `runPreferenceCheck()` sets `immersionEnabled` to the opposite value before restoring; the module's preference callback raises at this transition, so the test aborts and setting remains false. `HUD:ApplyImmersionPreference` correctly hides the HUD root while false; the missing mana display is a consequence of the aborted preference restore, not evidence of resource reading failure.

## R3 test classification

A source-locked candidate will add the two missing empty arrays and a static regression checker. It has NOT been tested in WoW. Do not mark R2 Run All PASS or harmful source coverage PASS. Existing R2 preview showed player=2, targetHarmful=2, targetHelpful=2; live check remained deferred for unpopulated harmful effects and absent target. Quest loot flash remains intermittent and not causally classified. Validate against the developer panel, then upload diagnostics if any error recurs.
