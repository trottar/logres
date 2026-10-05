# P0140 — Read-Only World-Target Anchor/Reaction Runtime Probe

Date: 2026-10-05
Baseline: `b012213662a93b455b1ed3af2325a2bacdb2a59d`
Runtime target: `0.0.68-dev`
Result: **PREPARED — IN-CLIENT RUNTIME PROOF PENDING**

## Purpose

Implement the narrow runtime proof required by P0139 / D-042 without moving the
production target presentation or mutating Blizzard target/nameplate surfaces.

## Runtime design

New module:
`Logres/HUD/WorldTargetProbe.lua`.

The probe is diagnostic-only and event-driven. It observes:
- `PLAYER_TARGET_CHANGED`;
- `NAME_PLATE_UNIT_ADDED`;
- `NAME_PLATE_UNIT_REMOVED`;
- `NAME_PLATE_UNIT_BEHIND_CAMERA_CHANGED`;
- `PLAYER_ENTERING_WORLD`.

Event payloads are discarded. Each event re-queries the current `"target"`
directly.

The anchor query is strictly:

`C_NamePlate.GetNamePlateForUnit("target", false)`

behind `pcall` and a secret-first returned-value guard. `includeForbidden=true` is
never requested.

When an ordinary accessible nameplate is present, the probe reads
`C_NamePlateManager.IsNamePlateUnitBehindCamera("target")` through the same
secret-first boundary. A behind-camera target is a fallback observation.

Outside combat only, the probe uses one hidden addon-owned `UIParent` proxy to
test `SetPoint` relative to the accessible nameplate, then immediately calls
`ClearAllPoints`. The Blizzard frame is never reparented, hidden, resized, faded,
or otherwise mutated.

## Reaction / danger proof

The probe reads only:
- `UnitReaction("player", "target")`;
- `UnitCanAttack("player", "target")`;
- `UnitIsFriend("player", "target")`;
- `UnitIsTrivial("target")`.

Every returned value passes through a secret-first wrapper before nil/type/value
inspection. The diagnostic stores only sanitized booleans, the approved
hostile/neutral/friendly reaction category, fallback state, counts, and bounded
error strings.

The probe does not inspect exact level, classification, selection type/color,
boss state, or threat.

## Production boundary

P0140 does not:
- relocate the current Logres target name/percentage surface;
- hide or alter Blizzard target/nameplate UI;
- change nameplate CVars/settings;
- enumerate nameplates;
- poll;
- add target aura/status ownership.

The existing screen-space Logres target remains the canonical production
fallback throughout P0140.

## Developer integration

Phase H adds:
- panel action `World Target Probe`;
- slash command `/logres worldtargetprobe`.

The contextual probe is intentionally excluded from `Run All`.

Static contract:
`tools/check_world_target_probe_contract.py`.

## Runtime gate

After deployment and `/reload`:

1. out of combat with no target, run Phase H -> `World Target Probe`;
2. target an ordinary nearby unit whose Blizzard nameplate is naturally visible
   and run `World Target Probe` again;
3. if convenient, turn/move so the target loses the accessible plate or enters a
   behind-camera/no-nameplate state, then run again;
4. verify diagnostic lines show ordinary reaction/triviality state where
   available and a safe fallback/deferred state otherwise;
5. verify an accessible ordinary plate can produce
   `attachment=passed candidate=true` out of combat;
6. confirm the production Logres target remains in its current screen-space
   position and Blizzard target/nameplate UI remains untouched;
7. Phase 0 -> `Run All` must remain PASS.

Environmental absence of an accessible nameplate is **DEFERRED / fallback
observed**, not FAIL.

Combat defers the hidden attachment test and is not FAIL.

Any Lua error, secret-value violation, protected/forbidden-frame error, failed
addon-owned detach, or Blizzard-presentation mutation is FAIL and must be recorded
before advancing.

## Next after proof

If the runtime gate passes, record exact evidence before authorizing production
world-target placement. Target aura/status remains separately gated.
