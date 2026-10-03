---
memory_schema: 1
as_of: 2026-10-03
project: logres
---

# Current State

## Active Objective

**Phase G — Cinematic Camera.**

## Current Work Item

**G.5 — Resolve camera-distance ownership after target-50 capability NEGATIVE.**

P0109 is verified pushed at:
`affb1ace6b7561ce9c2046b74273948dfbb5c4b5`.

Current pushed runtime:
`0.0.44-dev`.

G.4 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.5 status:
**TARGET-50 CAPABILITY CLOSED — CLEAN NEGATIVE UNDER NO-CVAR-MUTATION BOUNDARY; CAMERA-DISTANCE OWNERSHIP REVIEW ACTIVE.**

## Verified State

- Phase F is complete.
- G.1 captured the current DynamicCam `RPG` profile durably.
- G.2 proved the primary MoveView camera capability out of combat and in genuine
  live combat.
- G.3 World/Combat production ownership is runtime + integration PASS.
- G.4 City/resting ownership is runtime + integration PASS on `0.0.43-dev`.
- P0108 resolved the G.5 Taxi source/profile contract.
- P0109 at `affb1ace` is durable on runtime `0.0.44-dev`.
- A.2 already runtime-proved `state.onTaxi` true during a real flight path and
  false again after Taxi ended.
- Taxi source precedence remains priority `1000`, above captured interaction
  `110`, combat `50`, City `1`, and World `0`, with the existing instance
  fail-open outside the Taxi slice.
- Taxi zoom intent remains conditional-out absolute target `50`, with ordinary
  Taxi entry `5` seconds and restore `never`.
- Taxi rotation and Taxi UI hide/fade remain separately gated.
- P0109 runtime capability evidence is a repeated clean NEGATIVE:
  - runtime `0.0.44-dev`;
  - `cameraDistanceMaxZoomFactor = 1.2`;
  - source-derived effective ceiling `18`;
  - both independent target-50 attempts stopped at zoom `18`;
  - both recorded `targetReached=false`;
  - both recorded `moved=true`;
  - both restored the captured starting zoom successfully;
  - both recorded `cvarUnchanged=true`;
  - both recorded `secret=false`;
  - DynamicCam was not loaded during the probe.
- Therefore target `50` is **not reachable** under the current accepted
  no-camera-distance-CVar-mutation boundary.
- This is a capability result, not a production-controller defect.
- The generic probe error text `movement/target/restoration tolerance failed`
  is broader than the actual failing criterion; the explicit diagnostic fields
  show movement and restoration succeeded and only target reach failed.
- Production Taxi ownership remains fail-open/out-of-slice.
- No lower Taxi target may be substituted merely because the current ceiling is
  `18`.
- D-035 quest interaction ownership remains a valid future endpoint with Blizzard
  fail-open controls until each replacement capability is proven.

## Next Action

Perform a **source/contract audit of camera-distance CVar ownership** before any
new runtime mutation.

The audit must resolve:
- current Forever semantics and allowed range for
  `cameraDistanceMaxZoomFactor`;
- whether target `50` implies a required factor of at least `50 / 15`;
- whether changing that CVar is session-only, persistent, restricted, or otherwise
  coupled to Blizzard settings;
- DynamicCam/LibCamera behavior around temporary or restored camera-distance
  changes;
- exact ownership/restore semantics if Logres ever changes the CVar;
- combat/protected-state implications;
- startup/logout/reload behavior;
- fail-open behavior if the requested distance cannot be established or restored.

No runtime CVar mutation is authorized by this checkpoint.

Do not implement production Taxi zoom, rotation, UI fade, or a clamped fallback
until that review is explicit.

## Success Criteria

The next G.5 contract checkpoint completes only when:
- camera-distance CVar semantics are source-resolved for the current client;
- the minimum required factor for target 50 is explicit;
- persistence/restoration and combat boundaries are explicit;
- a smallest safe capability test, or a reason not to test, is defined;
- production Taxi remains fail-open until that capability is proven.

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
- **Target 50 without camera-distance mutation:** runtime NEGATIVE on
  `0.0.44-dev`; current factor `1.2`, observed ceiling `18`.
- **Camera-distance CVar mutation:** not yet accepted.
- **Production Taxi ownership:** still fail-open.
- **D-032/D-033/D-034 visual direction:** accepted future Phase H+ direction.
- **D-035 quest interaction ownership:** accepted future endpoint.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G5_TAXI_CAMERA_SOURCE_AUDIT_2026-10-03.md`
- `docs/memory/evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`
- `docs/memory/investigations/G5_TAXI_CAMERA_OWNERSHIP.md`
- `docs/memory/investigations/G5_CAMERA_DISTANCE_CVAR_OWNERSHIP.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/patches/P0109_G5_TAXI_TARGET50_CAPABILITY_PROBE.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
