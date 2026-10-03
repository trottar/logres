# Phase G — Cinematic Camera

Status: ACTIVE — G.5
Opened: 2026-10-02

## Product Objective

Translate the user's established contextual DynamicCam behavior into Logres.

## G.1 — Current DynamicCam profile capture

**COMPLETE — PASS.**

## G.2 — World/Combat camera zoom capability

**COMPLETE — RUNTIME + INTEGRATION PASS.**

## G.3 — Production World/Combat camera ownership

**COMPLETE — RUNTIME + INTEGRATION PASS.**

## G.4 — City camera ownership

**COMPLETE — RUNTIME + INTEGRATION PASS on `0.0.43-dev`.**

## G.5 — Taxi camera ownership

**TARGET-50 CAPABILITY PROBE IMPLEMENTED — RUNTIME PROOF PENDING.**

Canonical source/profile audit:
`../evidence/G5_TAXI_CAMERA_SOURCE_AUDIT_2026-10-03.md`.

Resolved Taxi contract:
- activation uses existing runtime-proven `state.onTaxi`;
- Taxi priority `1000` outranks Interaction `110`, Combat `50`, City `1`, World `0`;
- current Logres instance fail-open remains outside this slice;
- Taxi uses conditional-out absolute target `50`;
- Taxi entry uses `5` seconds;
- restore `never`;
- ordinary Taxi exit uses destination entering time;
- Taxi rotation remains a separate continuous-yaw capability;
- Taxi UI hide/fade remains separate presentation policy.

P0109 prepares runtime `0.0.44-dev` with the targeted capability gate.

### P0109 target-50 capability probe

Developer-panel action:
`Taxi Target 50 Probe`.

The probe:
- reuses the existing manual `CameraCapabilityProbe`;
- requires production camera ownership OFF;
- refuses with DynamicCam loaded/status unknown;
- reads but never mutates `cameraDistanceMaxZoomFactor`;
- records effective ceiling `factor * 15`;
- attempts target `50` over 5 seconds through the proven MoveView path;
- restores the captured start zoom through MoveView;
- re-reads and verifies the distance factor is unchanged;
- records targetReached / moved / restored / secret / error state;
- remains excluded from Run All because it moves the camera.

The production Taxi exclusion is intentionally unchanged.

### Decision after runtime proof

If target 50 passes:
prepare zoom-only production Taxi ownership.

If target 50 cannot be reached while restoration/CVar/error state remains clean:
record the negative capability result and investigate camera-distance ownership
separately. Do not lower the Taxi target by guesswork.

### Later production Taxi proof

After capability PASS and production implementation:
- real flight-path automatic Taxi selection;
- Taxi `<50 -> 50` over 5 seconds;
- no unnecessary correction at target;
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
