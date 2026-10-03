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
**RESOLVED — READ-ONLY DEFAULT/METADATA PROBE NEXT.**

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

### P0112 read-only checkpoint

Runtime:
`0.0.45-dev`.

Phase G action:
`Camera Distance Info`.

It reads:
- current/default factor;
- current/default effective ceiling;
- required target-50 factor;
- support booleans;
- storage scope;
- locked/secure/read-only flags;
- DynamicCam state;
- secret/error state.

No movement. No SetCVar. No polling.

### Decision after P0112 runtime evidence

If default >= `50 / 15`, investigate the smallest safe temporary ownership
capability.

If default < `50 / 15`, record that inherited DynamicCam standard settings also
cannot satisfy target 50 and resolve product policy before adding a higher
max-distance setting.

Production Taxi remains fail-open until explicitly authorized.

## Parallel future integration direction

D-032/D-033/D-034 visual direction, D-035 quest-interaction ownership, D-036
health-tunnel contract, and D-037 navigation/minimap direction remain valid
parallel Phase H+ work. D-030 remains current minimap runtime authority until
replacement capabilities are proven.

## Later Phase G Work

Taxi rotation, Hearth/Teleport, NPC Interaction, Fishing, AFK, Gathering,
shoulder offsets, UI-hide integration, startup parity, and broader camera-CVar
ownership remain separately gated.
