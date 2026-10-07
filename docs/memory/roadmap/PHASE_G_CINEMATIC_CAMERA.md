# Phase G — Cinematic Camera

Status: ACTIVE — G.5 TAXI PROOF + G.6 CAPTURED RPG PROFILE PARITY
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

The earlier temporary choice to finish all approved visual translation before
returning to Camera is superseded.

Current order:
1. finish the already-open G.5 normal-Taxi landing proof;
2. close Phase G if that proof is clean;
3. enter Phase H with stock-surface suppression/coexistence and authored layout
   positioning before final polish.

This does not reopen broader Camera feature work.

P0120 through P0124 translated and accepted the shared percentage bar, player
cast cue, Context message treatment, heading/manual-waypoint Compass, and organic
player-health tunnel. P0126 adds the accepted Active Quest one-focus presentation
at `89b0c563` / `0.0.58-dev`.

P0128 resolved the D-035 source/API layer. P0129 is durable at `e50676b9` /
`0.0.59-dev` and passes the naturally observed read-only offer/gossip scope with
mutation invariant `invoked=0`.

P0130 is durable at `ab6473b2` / `0.0.61-dev` and runtime + visual PASS for the
bounded/paged quest-offer narrative, including Immersion restore.

P0131 is runtime-proven: Decline passes on `0.0.62-dev`; Accept passes on
`0.0.63-dev` with matched `QUEST_ACCEPTED` after intermediate `QUEST_FINISHED`.

P0131 is durable at `68233e64` / `0.0.63-dev`.

P0132 production offer controls are durable at `671f9836` / `0.0.64-dev`.
P0133 is durable at `f2feead6` / `0.0.65-dev` and runtime + visual PASS for the
Accept-left / Decline-right alignment while Blizzard fallback remains visible.

P0135/P0136 resolve and runtime-prove the narrow aura source layer. P0137 is
durable at `2b578759` / `0.0.67-dev` and runtime + visual PASS for the passive
player-helpful production lane.

The approved visual sequence now moves to P0139 world-attached target source +
anchoring/fallback audit. Deferred harmful/target aura categories are not forced
solely to advance sequencing.

Broader Camera feature work remains frozen; only the existing G.5 Taxi landing gate is active.

D-037 unproven navigation/minimap roles remain separately capability-gated.
D-030 remains current minimap runtime authority until replacement capabilities
are proven.

## Later Phase G Work

Taxi rotation, Hearth/Teleport, NPC Interaction, Fishing, AFK, Gathering,
shoulder offsets, UI-hide integration, startup parity, and broader camera-CVar
ownership remain separately gated.


## P0158 execution handoff

P0158 records the post-G.5 handoff explicitly.

If the normal-Taxi landing retest passes, Phase G closes and the next work is not
another component-art round. Phase H begins by reconciling the actual screen:
safe suppression/coexistence for capability-proven replacements, then authored
positions/anchors, then final polish and residual visuals.

If the Taxi retest fails, preserve that narrow evidence and repair only the
reproduced Taxi/shared-transition defect before the Phase H handoff.


## G.6 — Captured RPG profile parity

The user confirmed Camera should be completed against the already-captured
DynamicCam profile before Phase H rather than stopping after one Taxi retest.

P0159 is the first consolidated parity layer:
- source-backed Teleport, AFK, Gathering, NPC Interaction, Fishing context reads;
- profile priority selection;
- context zoom targets/durations;
- Teleport cast-duration override;
- AFK no-zoom ownership;
- Fishing one-second exit hold;
- no CVar mutation, rotation, shoulder mutation, UI fade, or polling.

The G.5 Taxi landing test is retained inside P0159 runtime validation.

After P0159 acceptance, continue directly with a consolidated rotation /
shoulder / camera-setting ownership-restoration layer. DynamicCam UI fades cross
into Phase H presentation policy and are not copied blindly into camera code.
