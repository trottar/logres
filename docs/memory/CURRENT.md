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

P0107 is verified pushed at:
`ab83882f28f98b3d90cc6bee65e5d7c45928c536`.

Current pushed runtime:
`0.0.43-dev`.

G.4 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.5 status:
**SOURCE/PROFILE CONTRACT RESOLVED — TARGET-50 CAPABILITY PROBE NEXT; PRODUCTION TAXI OWNERSHIP NOT YET AUTHORIZED.**

## Verified State

- Phase F is complete.
- G.1 captured the current DynamicCam `RPG` profile durably.
- G.2 proved the primary MoveView camera capability out of combat and in genuine
  live combat.
- G.3 World/Combat production ownership is runtime + integration PASS.
- G.4 City/resting ownership is runtime + integration PASS on `0.0.43-dev`.
- P0107 at `ab83882f` durably records the G.4 PASS and opens G.5.
- A.2 already runtime-proved `state.onTaxi` true during a real flight path and
  false again after Taxi ended. `UnitOnTaxi("player")` is the authoritative fact.
- Pinned DynamicCam source defines Taxi `160` as `UnitOnTaxi("player")`,
  priority `1000`, with `PLAYER_CONTROL_LOST` / `PLAYER_CONTROL_GAINED` as
  refresh events.
- DynamicCam selects the highest numeric priority. Taxi therefore outranks the
  captured NPC Interaction `110`, World (Combat) `50`, City `1`, and World `0`.
- Logres retains its existing instance fail-open boundary. Inside the non-instance
  camera slice, eventual Taxi ownership precedes interaction, combat, City, and
  World.
- Captured Taxi zoom is conditional-out absolute target `50`.
- Taxi entry uses `5` seconds. Under zoom restore `never`, ordinary Taxi exit to
  World/City/Combat uses the destination situation's entering transition rather
  than Taxi's stored `timeToExit = 5`.
- DynamicCam permits target `50` on non-mainline clients, but its source also
  ties effective camera distance to `cameraDistanceMaxZoomFactor`.
- The captured profile contains no explicit standard runtime value proving that
  the current Forever session can physically reach zoom `50`.
- Existing Logres production camera ownership does not mutate camera-distance
  CVar state and must not silently clamp the intended Taxi target.
- Taxi rotation is source-separable from zoom and remains capability-gated.
- Taxi UI hide/fade remains presentation policy and is outside the first Taxi
  camera slice.
- D-035 quest interaction ownership remains a valid future endpoint with Blizzard
  fail-open controls until each replacement capability is proven.

## Next Action

Prepare a **developer-panel GUI target-50 capability probe** before production
Taxi code.

The probe must:
- refuse while DynamicCam is loaded;
- read but never mutate `cameraDistanceMaxZoomFactor`;
- report the source-derived effective ceiling (`factor * 15`);
- attempt absolute target `50` through the proven `MoveView*Start/Stop` path;
- restore the captured starting zoom;
- record targetReached / secret / error state;
- avoid `SetCVar`, `CameraZoomIn`, and `CameraZoomOut`.

This probe does not require a real flight path.

If target `50` passes, the next patch may implement zoom-only Taxi ownership.

If target `50` fails, preserve the negative result and investigate
camera-distance ownership separately. Do not substitute a guessed lower Taxi
target.

## Success Criteria

The target-50 capability checkpoint completes only after:
- the current camera-distance CVar is observed without mutation;
- target `50` is either proven reachable or explicitly proven unavailable;
- the starting zoom is restored;
- no secret-value, Lua, taint, or protected-action error is observed;
- the result is recorded durably.

Production Taxi ownership remains gated until that evidence exists.

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
- **D-032/D-033/D-034 visual direction:** accepted future Phase H+ direction.
- **D-035 quest interaction ownership:** accepted future endpoint.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `docs/memory/evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`
- `docs/memory/evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`
- `docs/memory/evidence/A2_CONTEXT_SENSOR_SOURCE_AUDIT_2026-09-30.md`
- `docs/memory/evidence/A2_CONTEXT_SENSOR_RUNTIME_PROOF_2026-09-30.md`
- `docs/memory/evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`
- `docs/memory/evidence/G5_TAXI_CAMERA_SOURCE_AUDIT_2026-10-03.md`
- `docs/memory/investigations/G5_TAXI_CAMERA_OWNERSHIP.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/patches/P0107_CLOSE_G4_OPEN_G5_TAXI.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
