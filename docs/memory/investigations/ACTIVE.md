# Active Investigations

## G.5 — Taxi camera ownership

Status:
**OPEN / PAUSED — P0119 IMPLEMENTATION DURABLE; NORMAL-TAXI LANDING RETEST PENDING.**

Canonical Taxi investigation:
`G5_TAXI_CAMERA_OWNERSHIP.md`

P0117 runtime `0.0.47-dev` proved automatic Taxi entry but exposed the shared
landing transition failure: City `18 -> 5` reached final zoom `0`.

P0119 is durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`
on `0.0.49-dev`. It replaces constant-rate transition motion with frame-shaped
MoveView velocity plus bounded target correction.

The user has frozen Camera work while the approved visual translation sequence is
finished. Therefore the P0119 runtime retest is **deferred by sequencing**, not
PASS, FAIL, or abandoned.

When Camera resumes, use one normal Taxi flight and record:
- Taxi entry ownership/target semantics;
- post-landing City/World target convergence;
- failures/secret/error state.

No max-distance mutation, Taxi rotation, or Taxi UI fade is part of that proof.

## Active Quest

Status:
**CLOSED — P0126 RUNTIME + VISUAL PASS.**

P0126 is durable at `89b0c563d1ff5e12c61baa3e407725a90d9cefd4`
on `0.0.58-dev`.

The initial hover tooltip failure is preserved in evidence; R1 corrected it and
the final R3 composition passed. Whole-screen polish remains later calibration,
not an open Active Quest capability issue.

## NPC quest interaction ownership

Status:
**OPEN — P0129 READ-ONLY PROBE PREPARED; RUNTIME EVIDENCE PENDING.**

Canonical investigation:
`NPC_QUEST_INTERACTION_CAPABILITY.md`

P0128 establishes source/API availability but does not authorize mutation.
P0129 `0.0.59-dev` is prepared to collect read-only narrative/reward/gossip
runtime evidence while leaving Blizzard interaction fully available.

## Closed Phase G investigations

G.1 DynamicCam profile capture:
**CLOSED — PASS.**

G.2 World/Combat camera zoom capability:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.3 production World/Combat camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.4 City camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS on `0.0.43-dev`.**

G.5 target-50 without CVar mutation:
**CLOSED — CLEAN NEGATIVE on `0.0.44-dev`.**

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`
- `FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
