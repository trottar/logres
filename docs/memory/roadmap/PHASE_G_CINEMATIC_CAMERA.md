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

Source/profile contract:
**RESOLVED.**

Target 50 without camera-distance CVar mutation:
**CLOSED — CLEAN NEGATIVE on `0.0.44-dev`.**

Canonical runtime evidence:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`.

Two P0109 runs independently recorded:
- `cameraDistanceMaxZoomFactor = 1.2`;
- effective ceiling `18`;
- intended target `50`;
- actual turn zoom `18`;
- target not reached;
- movement succeeded;
- starting zoom restored;
- CVar remained unchanged;
- secret=false;
- DynamicCam not loaded.

Therefore the current accepted no-CVar-mutation architecture cannot reproduce the
captured Taxi zoom target.

Production Taxi remains fail-open.

### Active G.5 work — camera-distance ownership

Investigation:
`../investigations/G5_CAMERA_DISTANCE_CVAR_OWNERSHIP.md`.

Before another runtime patch, resolve:
- current Forever CVar range/clamping;
- persistence and reset behavior;
- combat/protected-state behavior;
- source behavior of DynamicCam/LibCamera;
- exact old-value capture and restoration semantics;
- failure/disable/logout/reload behavior;
- smallest safe capability test, if any.

No CVar mutation is authorized yet.

Do not substitute target 18 or another guessed target.

### Taxi contract retained

- activation uses existing runtime-proven `state.onTaxi`;
- Taxi priority `1000` outranks Interaction `110`, Combat `50`, City `1`, World `0`;
- current Logres instance fail-open remains outside this slice;
- intended Taxi target remains conditional-out absolute `50`;
- Taxi entry remains `5` seconds;
- restore remains `never`;
- ordinary Taxi exit uses destination entering time;
- Taxi rotation remains separately gated;
- Taxi UI hide/fade remains separate presentation policy.

## Parallel future integration direction

D-032 world-first layout/action-role planning, D-033 World Ghost visual planning,
D-034 Selective Hybrid E / component-system direction, and D-035 future NPC
quest-interaction ownership remain valid parallel Phase H+ work.

## Later Phase G Work

After Taxi zoom ownership: Taxi rotation, Hearth/Teleport, NPC Interaction,
Fishing, AFK, Gathering, shoulder offsets, UI-hide integration, startup
instant-transition parity, and broader camera-CVar ownership remain separately
gated unless evidence changes the order.
