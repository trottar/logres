# Phase G — Cinematic Camera

Status: ACTIVE — P0160 R2 SOURCE-BACKED ZOOM DRIVER RETEST + G.6 CAPTURED RPG PROFILE PARITY
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

P0117 runtime result:
- Taxi automatic ownership/target semantics PASS;
- landing destination convergence FAIL;
- City `18 -> 5` overshot to zoom `0`.

Canonical:
`../evidence/G5_P0117_TAXI_LANDING_OVERSHOOT_2026-10-03.md`.

P0119 replaces the constant-rate transition driver with frame-shaped MoveView
velocity and crossed-target correction.

P0119 is installed/pushed at:
`c342bc176a9d5de80ec116d0c6b31fa595cd75b3`
on runtime `0.0.49-dev`.

The normal-Taxi landing retest has not been durably recorded as PASS. That Taxi proof remains separately pending.

### P0154 world-entry transition regression

After P0152 acceptance, P0153 preserved one `PLAYER_ENTERING_WORLD` transition timeout and required a normal `/reload` retest before any camera patch. The retest reproduced the failure: start about `8.524`, requested target `5`, final/current about `12.632`, elapsed about `3.258s`, and one timeout failure. Separate Run All repeated it.

This reopened camera runtime investigation narrowly. P0154 is durable at `40dec187` / `0.0.75-dev` and captured the required evidence: start about `23.148`, target `5`, final `50`, observed range `0 -> 50`, final/max easing error `45`, and `142` inward plus `1` outward MoveView command.

The outward correction proved the transition reversed direction during the world-entry displacement. P0155 R1 corrected that stop-before-reverse defect and is durable at `e9be312d` / `0.0.76-dev`.

Its runtime retest exposed an earlier timebase failure: camera start/current/final `50`, target `5`, elapsed about `23.523s`, one OnUpdate sample, zero MoveView commands, and zero direction switches. The transition timed out before motion could begin because its clock had started during `PLAYER_ENTERING_WORLD`.

P0156 is durable at `e1be731b` / `0.0.77-dev` and passes the observed normal-world-entry retest. Phase G Camera World/Combat Check reported start/current/final about `5.0795` against target `5`, targetReached=true, failures=0, secret=false, error=nil; separate Run All repeated the PASS.

The passing sample had `firstDelay=0` and `switches=0`, so the prior large-delay branch and P0155 direction-switch stop remain unexercised runtime branches. No further world-entry code is justified without new evidence.

The normal-Taxi landing retest from P0119 is now the exact G.5 next gate:
- one normal Taxi flight;
- during flight verify Taxi ownership/target via Phase G Camera World/Combat Check;
- after landing verify City/World settles near target `5`, not first-person `0`;
- failures=0, secret=false, error=nil;
- separate Run All clean.

Production Taxi is not considered closed until that runtime proof passes.

## Sequencing after P0157

The temporary visual-first freeze is superseded.

Current order:
1. fix and runtime-prove the shared zoom engine against the real Taxi landing case;
2. finish the remaining captured-profile Camera parity using audited DynamicCam/LibCamera behavior;
3. enter Phase H for safe stock-surface suppression/coexistence, authored positions, and final polish.

P0159 R1 is durable at `8ddcf098` / `0.0.78-dev`.

Its runtime result is now authoritative:
- ordinary profile/base PASS;
- separate Run All clean;
- Taxi target `50` PASS twice at about `49.75597`;
- post-Taxi City `~49.75597 -> 5` FAIL at final zoom `0`;
- 97 samples, 80 direction switches, range `0 -> 50`;
- max absolute easing-position error about `49.471`.

This finally exercises the P0155 stop-before-reverse path heavily and proves it is not sufficient by itself.

## G.6 — Captured RPG profile parity

The user confirmed Camera should be completed against the already-captured DynamicCam profile before Phase H.

P0159 completed the first source-backed context/priority layer.

The remaining zoom failure triggered a dependency audit rather than another bespoke algorithm tweak.

DynamicCam delegates camera motion to LibCamera. The audited source at
`c0b23135a0b24fbca24b41cb53dd7afc9114e352` already contains the coherent zoom mechanics Logres had been reconstructing incrementally.

## P0160 R2 — source-backed zoom engine

P0160 R2 ports the ordinary LibCamera SetZoom behavior:
- InOutQuad easing;
- finite-difference easing velocity;
- >0.5 actual-position/easing-time rebase;
- 0.005 precision / max 100 rebase iterations;
- final two-frame linear correction;
- final 0.1-second correction using temporary cameraZoomSpeed ownership;
- exact cameraZoomSpeed restoration.

Logres retains:
- secret-first reads;
- DynamicCam fail-open coexistence;
- stop-before-reverse;
- requested/effective target diagnostics;
- no cameraDistanceMaxZoomFactor mutation;
- no polling/tickers.

The initial P0160 artifact refused pre-write on an obsolete historical-checker output anchor. P0160 R1 then refused pre-write on a stale STATUS Phase H row. P0160 R2 corrects both delivery defects; neither refusal changed tracked files.

Exact runtime gate:
1. `/reload`;
2. Phase G -> Camera Profile Check;
3. Phase 0 -> Run All;
4. one normal Taxi;
5. Camera Profile Check in flight;
6. Camera Profile Check after landing/settle;
7. refreshed diagnostics.

Only after that landing path is clean does Phase G proceed to the consolidated rotation/camera-setting ownership layer.

UI fading remains a Phase H presentation-policy integration point.
