# Camera Architecture

## Product intent

Camera behavior is being integrated into Logres rather than requiring a separate
DynamicCam profile.

## Durable profile evidence

G.1 captured the current DynamicCam profile on 2026-10-02.

Canonical evidence:
- `../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `../evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

Request another export only if the profile changes or later evidence conflicts.

## Current production ownership

Runtime-proven production Logres camera ownership covers:
- World;
- World (Combat);
- City/resting.

Taxi remains fail-open.

## Taxi precedence and zoom intent

Inside the existing non-instance boundary, the source-resolved intended order is:
1. Taxi;
2. interaction remains fail-open until separately replaced;
3. live combat;
4. City/resting;
5. World.

Taxi intended zoom:
- conditional-out absolute target `50`;
- entry `5` seconds;
- restore `never`;
- ordinary exit uses destination entering time.

## Target-50 no-CVar result

Canonical:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`.

Runtime `0.0.44-dev` repeatedly observed:
- current factor `1.2`;
- effective ceiling `18`;
- target `50`;
- actual turn zoom `18`;
- target not reached;
- movement/restoration successful;
- CVar unchanged;
- secret=false.

This closes target 50 under the current no-CVar-mutation boundary as a clean
negative.

## Camera-distance source model

Canonical:
`../evidence/G5_CAMERA_DISTANCE_SOURCE_AUDIT_2026-10-03.md`.

Pinned DynamicCam maps displayed camera distance as:

`cameraDistanceMaxZoomFactor * 15`

and allows displayed 50 for non-mainline projects.

Therefore target 50 requires factor >= `50 / 15`.

DynamicCam standard max-distance initializes from the client
`GetCVarDefault("cameraDistanceMaxZoomFactor")`.

The captured G.1 profile has no explicit standard max-distance field, and Taxi
has no situation-specific max-distance override.

DynamicCam applies CVar settings independently from situation zoom; Taxi zoom
does not automatically raise max-distance merely because its target is 50.

Pinned LibCamera does not mutate `cameraDistanceMaxZoomFactor`.

## P0112 read-only metadata gate

Before any SetCVar experiment, runtime `0.0.45-dev` adds Phase G action:
`Camera Distance Info`.

It records:
- current/default factor;
- current/default ceiling;
- required target-50 factor;
- current/default support booleans;
- storage scope;
- locked/secure/read-only metadata;
- DynamicCam load status;
- secret/error state.

It prefers `C_CVar.GetCVarInfo` and falls back to read-only current/default APIs.

It does not move the camera or mutate a CVar.

## Ownership boundary

Camera-distance mutation remains **not authorized**.

If a later mutation capability is justified, it must separately define:
- old-value capture;
- restore ownership;
- concurrent user/other-addon change handling;
- combat/protected behavior;
- disable/logout/reload behavior;
- fail-open state.

No periodic reassertion is permitted without evidence.

## Taxi rotation / UI boundaries

Taxi rotation speed `-20` remains a separate continuous-yaw capability.

Taxi UI hide/fade remains presentation policy.

Neither is part of the camera-distance checkpoint.

## Diagnostic ownership

Phase G includes:
- Camera World/Combat controls;
- Camera Zoom Probe;
- Taxi Target 50 Probe;
- Camera Distance Info.

Camera Distance Info is read-only and does not require production camera
ownership to be disabled.

## Implementation sequence

G.1: **COMPLETE — profile captured.**

G.2: **COMPLETE — primary camera capability PASS.**

G.3: **COMPLETE — World/Combat production ownership PASS.**

G.4: **COMPLETE — City ownership PASS on `0.0.43-dev`.**

G.5 target 50 without max-distance mutation:
**COMPLETE — CLEAN NEGATIVE on `0.0.44-dev`.**

G.5 camera-distance source contract:
**RESOLVED — READ-ONLY DEFAULT/METADATA PROBE NEXT on `0.0.45-dev`.**
