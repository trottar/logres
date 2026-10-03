# Phase G — Cinematic Camera

Status: ACTIVE — G.5
Opened: 2026-10-02

## Product Objective

Translate the user's established contextual DynamicCam behavior into Logres.

## G.1 — Current DynamicCam profile capture

**COMPLETE — PASS.**

Canonical evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`.

## G.2 — World/Combat camera zoom capability

**COMPLETE — RUNTIME + INTEGRATION PASS.**

## G.3 — Production World/Combat camera ownership

**COMPLETE — RUNTIME + INTEGRATION PASS.**

## G.4 — City camera ownership

**COMPLETE — RUNTIME + INTEGRATION PASS on `0.0.43-dev`.**

Canonical runtime evidence:
`../evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`.

## G.5 — Taxi camera ownership

**SOURCE/PROFILE CONTRACT RESOLVED — TARGET-50 CAPABILITY PROBE NEXT.**

Canonical audit:
`../evidence/G5_TAXI_CAMERA_SOURCE_AUDIT_2026-10-03.md`.

Resolved Taxi contract:
- activation uses existing runtime-proven `state.onTaxi`;
- DynamicCam Taxi priority `1000` outranks Interaction `110`, Combat `50`,
  City `1`, and World `0`;
- current Logres instance fail-open remains outside this slice;
- Taxi uses conditional-out absolute target `50`;
- Taxi entry uses `5` seconds;
- with restore `never`, ordinary Taxi exit uses the destination situation's
  entering transition instead of restoring pre-Taxi zoom;
- Taxi rotation is a separate continuous-yaw capability and is not part of the
  first zoom slice;
- Taxi UI hide/fade remains separate presentation policy;
- DynamicCam/probe coexistence and fail-open behavior remain unchanged.

Target `50` is source-valid on non-mainline DynamicCam, but current Forever
runtime reachability is not proven. DynamicCam source also exposes the camera
distance ceiling through `cameraDistanceMaxZoomFactor`.

Therefore production Taxi ownership is **not yet authorized**.

### G.5 next capability checkpoint

Add one developer-panel capability probe that:
- reads but never mutates `cameraDistanceMaxZoomFactor`;
- reports its source-derived `*15` distance ceiling;
- attempts target `50` through the proven MoveView path;
- restores starting zoom;
- refuses while DynamicCam is loaded;
- records targetReached / secret / error state;
- does not use `SetCVar` or `CameraZoomIn/Out`.

If target `50` passes:
prepare zoom-only production Taxi ownership.

If it fails:
record the negative result and investigate camera-distance ownership separately;
do not silently clamp the intended Taxi target.

### Production Taxi proof after capability PASS

Later production acceptance should cover:
- real flight-path automatic Taxi selection;
- Taxi `<50 -> 50` over 5 seconds;
- no unnecessary correction once at target;
- exit fresh destination evaluation with no remembered restore;
- DynamicCam coexistence;
- Run All;
- clean addon-owned diagnostics.

Do not manufacture Taxi + combat overlap solely for proof.

## Parallel future integration direction

D-032 world-first layout/action-role planning, D-033 World Ghost visual planning,
D-034 Selective Hybrid E / component-system direction, and D-035 future NPC
quest-interaction ownership remain valid parallel Phase H+ work.

## Later Phase G Work

After Taxi zoom ownership: Taxi rotation, Hearth/Teleport, NPC Interaction,
Fishing, AFK, Gathering, shoulder offsets, UI-hide integration, startup
instant-transition parity, and broader camera-CVar ownership remain separately
gated unless evidence changes the order.
