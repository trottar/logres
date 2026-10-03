# G.5 — Taxi Camera Ownership

Status: **ACTIVE — CONTRACT REVIEW; NO RUNTIME CODE YET**
Opened: 2026-10-03

## Objective

Resolve the smallest deliberate Taxi camera contract before replacing the
current fail-open Taxi exclusion in the production camera controller.

## Existing durable evidence

The captured DynamicCam `RPG` profile maps Taxi to situation `160`:
- activation meaning: on taxi;
- priority `1000`;
- enabled;
- enter transition `5` seconds;
- exit transition `5` seconds;
- `zoomType = out`;
- absolute target `50` only when currently closer than 50;
- rotation speed `-20`;
- UI hide/fade stored.

Profile-wide zoom restoration remains `never`.

Logres already exposes the proven `state.onTaxi` sensor, so a Taxi slice should
not require a polling loop or duplicate sensor.

## Current production behavior

Through G.4, `state.onTaxi` is an explicit fail-open exclusion:
Taxi relinquishes Logres camera ownership rather than applying a Logres camera
situation.

That exclusion remains authoritative until G.5 contract review is complete.

## Questions to resolve before runtime code

1. Verify DynamicCam source activation and priority semantics for Taxi, including
   precedence relative to live combat, City, World, and interaction contexts.
2. Verify ordinary Taxi entry and destination-transition semantics for the stored
   5-second values under profile-wide restore `never`.
3. Confirm conditional-out target-50 behavior against current client camera
   capability and any relevant maximum-distance constraints without silently
   taking global camera-CVar ownership.
4. Decide whether the first Taxi runtime slice is zoom-only or whether rotation
   is inseparable from the intended Taxi experience. Rotation requires its own
   capability proof and must not be imported implicitly.
5. Keep Taxi UI hide/fade as presentation policy unless separately accepted.
6. Preserve DynamicCam/probe coexistence, interruption, and fail-open behavior.

## Explicit non-authorization

No G.5 runtime implementation is authorized yet.

Do not:
- remove the Taxi fail-open exclusion;
- add rotation;
- add UI fade;
- add camera-distance CVar mutation;
- add polling/tickers;
- broaden into Hearth/Teleport, NPC Interaction, Fishing, AFK, Gathering, or
  shoulder-offset work

until source/profile evidence resolves the Taxi contract.

## Next action

Audit the captured Taxi profile against the pinned DynamicCam source and current
Logres controller/sensor behavior. Record the exact Taxi precedence,
zoom/transition semantics, capability boundary, and smallest runtime proof before
preparing implementation.
