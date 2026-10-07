# Phase G — Cinematic Camera

Status: COMPLETE — P0162 RUNTIME PASS; ENVIRONMENTAL DEFERRALS PRESERVED
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

## Sequencing after P0160

The source-backed zoom engine is now runtime-accepted for the observed normal-Taxi path.

P0162 is runtime-accepted at `4628f49e` / `0.0.81-dev`; the final non-presentation Camera slice is complete. Phase G closes for claimed observed scope with naturally unavailable contexts preserved as environmental deferrals.

Next order:
1. Phase H H.1 stock-surface ownership/suppression audit;
2. bounded suppression/coexistence slices only where replacement/restoration is proven;
3. authored positions;
4. final whole-screen polish.

P0160 R2 is durable at `ae75989b` / `0.0.79-dev`.

Accepted Taxi evidence:
- outbound `~4.0096 -> 50`, final `50`;
- landing `50 -> ~4.9806`;
- zero direction switches both ways;
- source rebases exercised both ways;
- zero camera failures;
- user visually confirmed zoom-out and return.

G.5 Taxi zoom convergence is closed for observed scope.

## G.6 — Captured RPG profile parity

The already-captured RPG profile remains authoritative. No new export is required unless it changes.

P0159 supplies context/priority/conditional-zoom ownership.

P0160 supplies the audited LibCamera zoom engine.

P0161 supplies the captured profile-motion/settings layer:
- Taxi continuous yaw `-20`, rotate back;
- Teleport continuous yaw `+15`, rotate back;
- NPC yaw `-45`, rotate back;
- Fishing yaw/pitch `+10/+10`, rotate back;
- Gathering yaw/pitch `-15/+15`, rotate back;
- captured standard cameraZoomSpeed/dynamic-pitch/target-focus settings;
- standard +1 and NPC -2 zoom-based shoulder curves;
- explicit City max-distance factor `1`;
- exact CVar restoration on relinquish/disable/coexistence.

The absent standard max-distance SavedVariables field is not reconstructed. Outside City, Logres preserves the pre-ownership baseline.

UI fades remain Phase H presentation policy.

## P0161 — rotation/settings parity

P0161 is durable at `2a959094` / `0.0.80-dev` and **RUNTIME PASS for the observed Taxi/settings/shoulder-offset scope**.

Accepted evidence includes Taxi target `50`, continuous yaw `-20`, City landing return about `4.97-5.01`, rotate-back completion, City max-distance factor `1` with captured original factor `4`, and zero camera/profile secret/runtime/settings/rotation failures.

Teleport/NPC/Fishing/Gathering and unobserved AFK behavior remain environmental deferrals.

## P0162 — reactive mouse-wheel zoom

Durable: `4628f49e` / `0.0.81-dev`.

**RUNTIME PASS.** The final planned non-presentation Camera parity slice adapts pinned DynamicCam `MouseZoom.lua` semantics, uses effective captured settings `true / 0.1 / 2.5 / 1.2 / 2.5 / OutQuad`, and reuses the P0160 source-backed transition engine.

The bounded gate passed with active/hooked ownership, final `wheel=36`, `quick=9`, `resets=2`, `native=4`, `corrections=15`, same-context manual-zoom persistence, OFF/ON release/reacquire, user-confirmed native wheel while OFF, and zero conflicts/secrets/failures.

DynamicCam UI fading remains Phase H presentation policy.

## P0163 — Phase G closure

Phase G is **COMPLETE FOR CLAIMED OBSERVED SCOPE**.

Environmental deferrals remain:
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- Gathering;
- AFK priority behavior not naturally observed.

These are not failures and are not fabricated PASSes. No contrived travel is required solely to manufacture proof. Phase H is now primary.
