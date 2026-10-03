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

Taxi source/profile contract:
**RESOLVED.**

Target 50 without max-distance mutation:
**CLOSED — CLEAN NEGATIVE on `0.0.44-dev`.**

Camera-distance source contract:
**RESOLVED — P0112 READ-ONLY PASS; DEFAULT CANNOT SUPPORT TARGET 50.**

### Source finding

Pinned DynamicCam:
- presents non-mainline camera max up to 50;
- maps display distance as factor × 15;
- initializes standard `cameraDistanceMaxZoomFactor` from `GetCVarDefault`;
- has no captured Taxi max-distance override;
- does not automatically raise max-distance from Taxi target 50.

Pinned LibCamera does not own this max-distance CVar.

Therefore target 50 requires factor >= `50 / 15`, but the missing runtime fact is
the inherited client default rather than permission to mutate the CVar.

Canonical:
`../evidence/G5_CAMERA_DISTANCE_SOURCE_AUDIT_2026-10-03.md`.

### P0112 read-only runtime evidence

Runtime:
`0.0.45-dev`.

Canonical:
`../evidence/G5_P0112_CAMERA_DISTANCE_INFO_2026-10-03.md`.

Observed:
- source `C_CVar.GetCVarInfo`;
- current factor `1.2`, ceiling `18`;
- default factor `1`, ceiling `15`;
- required factor `3.3333333333333`;
- current/default support false/false;
- account-stored=true;
- character-stored=false;
- locked=false;
- secure=false;
- readOnly=false;
- DynamicCam not loaded;
- secret=false;
- error=nil.

Classification:
**CLEAN READ-ONLY RUNTIME PASS; DEFAULT TARGET-50 SUPPORT NEGATIVE.**

The prior decision gate therefore resolves on `default < 50 / 15`.

### DynamicCam parity correction

Canonical:
`../evidence/G5_DYNAMICCAM_TAXI_PARITY_CORRECTION_2026-10-03.md`.

Pinned DynamicCam/LibCamera treats `50` as the requested Taxi target and accepts
the engine max-distance clamp. Physical zoom 50 is not a prerequisite for
reproducing the user's situation action.

P0109/P0112 measurements remain valid but no longer block Taxi zoom.

### P0117 production Taxi zoom

Runtime:
`0.0.47-dev`.

Contract:
- existing `state.onTaxi`;
- requested target `50`;
- diagnostic effective target = `min(50, live factor * 15)`;
- transition `5` seconds;
- instance and DynamicCam fail-open preserved;
- no SetCVar;
- no Taxi rotation;
- no Taxi UI fade.

Next:
runtime-prove automatic Taxi ownership and destination convergence.

Production Taxi is not considered closed until that runtime proof passes.

## Parallel future integration direction

D-032/D-033/D-034 visual direction, D-035 quest-interaction ownership, D-036
health-tunnel contract, and D-037 navigation/minimap direction remain valid
parallel Phase H+ work. D-030 remains current minimap runtime authority until
replacement capabilities are proven.

## Later Phase G Work

Taxi rotation, Hearth/Teleport, NPC Interaction, Fishing, AFK, Gathering,
shoulder offsets, UI-hide integration, startup parity, and broader camera-CVar
ownership remain separately gated.
