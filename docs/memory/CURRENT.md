---
memory_schema: 1
as_of: 2026-10-03
project: logres
---

# Current State

## Active Objective

**Phase G — Cinematic Camera.**

## Current Work Item

**G.5 — Prove target-50 camera capability before production Taxi ownership.**

P0108 is verified pushed at:
`19efaad6523369020c6789d9e18e006538e3bf68`.

Runtime in the P0109 implementation checkpoint:
`0.0.44-dev`.

G.4 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.5 status:
**TARGET-50 CAPABILITY PROBE IMPLEMENTED — RUNTIME PROOF PENDING; PRODUCTION TAXI OWNERSHIP REMAINS GATED.**

## Verified State

- Phase F is complete.
- G.1 captured the current DynamicCam `RPG` profile durably.
- G.2 proved the primary MoveView camera capability out of combat and in genuine
  live combat.
- G.3 World/Combat production ownership is runtime + integration PASS.
- G.4 City/resting ownership is runtime + integration PASS on `0.0.43-dev`.
- P0108 at `19efaad6` is durable and resolves the G.5 Taxi source/profile contract.
- A.2 already runtime-proved `state.onTaxi` true during a real flight path and
  false again after Taxi ended.
- Taxi source precedence is resolved as priority `1000`, above captured
  interaction `110`, combat `50`, City `1`, and World `0`; the existing instance
  fail-open remains outside the Taxi slice.
- Taxi zoom intent is conditional-out absolute target `50`, with ordinary Taxi
  entry `5` seconds and restore `never`.
- Ordinary Taxi exit to World/City/Combat uses the destination situation's
  entering transition rather than restoring remembered pre-Taxi zoom.
- Taxi rotation and Taxi UI hide/fade remain separately gated.
- Production Taxi ownership still remains fail-open/out-of-slice until target
  `50` is proven reachable without camera-distance CVar mutation.
- P0109 extends the existing manual `CameraCapabilityProbe`; it does **not**
  change the production camera controller's Taxi branch.
- P0109 adds the Phase G developer-panel action `Taxi Target 50 Probe`.
- The target-50 probe:
  - refuses while the production camera controller is enabled;
  - refuses while DynamicCam is loaded or load status is unknown;
  - reads but never mutates `cameraDistanceMaxZoomFactor`;
  - records the source-derived effective ceiling (`factor * 15`);
  - attempts absolute target `50` over a 5-second MoveView leg;
  - returns to the captured starting zoom through the same MoveView path;
  - re-reads the CVar and requires it to remain unchanged;
  - records targetReached / moved / restored / secret / error state;
  - uses no `SetCVar`, `CameraZoomIn`, or `CameraZoomOut`.
- The production controller already blocks while `CameraCapabilityProbe.running`
  is true, so the new mode inherits the proven mutual-exclusion boundary.
- P0109 adds a dedicated static Taxi target-probe contract checker and updates the
  developer-panel phase contract.
- D-035 quest interaction ownership remains a valid future endpoint with Blizzard
  fail-open controls until each replacement capability is proven.

## Next Action

After P0109 is verified pushed, deploy runtime `0.0.44-dev` and collect one
developer-panel GUI target-50 capability result.

Validation sequence:
1. DynamicCam disabled for the isolated proof session.
2. Phase G -> `Camera World/Combat OFF`.
3. Manually place the camera clearly below target 50.
4. Phase G -> `Taxi Target 50 Probe`.
5. Wait for outbound + restore movement to finish.
6. Phase G -> `Taxi Target 50 Probe` again to record the result.
7. Phase G -> `Camera World/Combat ON`.
8. flush/export the saved developer-panel diagnostic.

A PASS authorizes the next zoom-only Taxi production implementation.

A FAIL because target 50 is not reachable is a valid capability result, not
something to hide or reinterpret. Preserve it durably and investigate
camera-distance ownership separately. Do not silently lower the Taxi target.

## Success Criteria

The target-50 capability checkpoint completes only after runtime evidence records:
- current `cameraDistanceMaxZoomFactor` without mutation;
- source-derived effective ceiling;
- actual target-50 reached/not-reached result;
- successful return to starting zoom;
- unchanged CVar state;
- no secret-value, Lua, taint, protected-action, or probe ownership failure.

Production Taxi ownership remains gated until that evidence is classified.

## Do Not Reopen Without New Evidence

- **Phase F:** complete.
- **G.1 DynamicCam profile capture:** complete.
- **G.2 primary zoom capability:** runtime + integration PASS.
- **G.3 World/Combat ownership:** runtime + integration PASS.
- **G.4 City ownership:** runtime + integration PASS on `0.0.43-dev`.
- **World/City zoom:** conditional-in target 5.
- **Combat zoom:** conditional-out target 15.
- **Zoom restoration:** `never`.
- **Taxi source precedence:** Taxi `1000` > Interaction `110` > Combat `50` >
  City `1` > World `0` inside the captured profile.
- **Taxi entry:** 5 seconds.
- **Taxi ordinary destination exit:** entering destination time, no remembered
  restore.
- **Taxi rotation/UI fade:** separately gated.
- **Camera-distance CVar mutation:** not accepted.
- **Production Taxi ownership:** not authorized before target-50 runtime proof.
- **D-032/D-033/D-034 visual direction:** accepted future Phase H+ direction.
- **D-035 quest interaction ownership:** accepted future endpoint.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G5_TAXI_CAMERA_SOURCE_AUDIT_2026-10-03.md`
- `docs/memory/investigations/G5_TAXI_CAMERA_OWNERSHIP.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/patches/P0108_G5_TAXI_CAMERA_SOURCE_AUDIT.md`
- `docs/memory/patches/P0109_G5_TAXI_TARGET50_CAPABILITY_PROBE.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
