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
**OPEN — OFFER SLICE ACCEPTED THROUGH P0133; LATER D-035 STATES REMAIN GATED.**

Canonical investigation:
`NPC_QUEST_INTERACTION_CAPABILITY.md`

P0129 runtime proves the naturally observed offer/detail path, one available
gossip quest row, and one two-choice reward metadata sample without secret/call
failures. Mutation function presence remained `invoked=0`.

`QUEST_PROGRESS` / `QUEST_COMPLETE` and other unobserved categories remain
environmentally deferred.

P0130 R1 closes the narrative lifecycle defect: OFF -> ON restores the same active
quest offer with `presentationReason=immersion-on-restore`, and integrated checks
remain clean.

P0131 final runtime evidence proves both tested offer mutations:
- Decline: `QUEST_FINISHED`, event-confirmed;
- Accept: matched `QUEST_ACCEPTED` after intermediate `QUEST_FINISHED`, with
  `finishedObserved=true` and no polling/timer.

P0131 is durable at `68233e64` / `0.0.63-dev`.

P0132 is durable at `671f9836` / `0.0.64-dev`.

Runtime/control behavior passes, including production Decline, production Accept,
non-mutating preview, Blizzard-visible fallback, and integrated checks.

P0133 is durable at `f2feead6` / `0.0.65-dev` and runtime + visual PASS:
Accept-left / Decline-right matches Blizzard while the fallback remains visible,
and integrated checks remain clean.

Continue / Complete, rewards, gossip selection, and Blizzard suppression remain
separate gates.

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

## Aura / status ownership

Status:
**OPEN — P0137 PLAYER HELPFUL PRODUCTION BASELINE ACCEPTED; HARMFUL/TARGET AURA CATEGORIES REMAIN DEFERRED.**

Canonical investigation:
`FUTURE_AURA_STATUS_PRESENTATION.md`.

No stock aura/status suppression is authorized.

P0135 resolves the source/policy layer and accepts D-041:
- `C_UnitAuras` is the source family;
- per-index aura secrecy preflight is mandatory;
- `UNIT_AURA` is invalidation only;
- urgent player harmful status outranks passive helpful status;
- target actionable status remains gated by world-target placement;
- private/group aura surfaces remain Blizzard-owned;
- no stock suppression is authorized.

P0136 is now implemented as a bounded secret-first diagnostic on
`0.0.66-dev`. It discards `UNIT_AURA` payload arguments, never queries a
secret/indeterminate aura index, and does not mutate or suppress Blizzard UI.

Runtime evidence now establishes ordinary populated player helpful data and safe
empty-state target scans with zero failures.

Populated player harmful and populated target categories remain environmental
DEFERRED, and no secret-skip branch was encountered.

Production implementation may therefore advance only for player helpful status,
with Blizzard completeness fallback preserved.

P0136 is durable at `ef769f6` / `0.0.66-dev`.

P0137 `0.0.67-dev` prepares only `HELPFUL|PLAYER` presentation:
- maximum four passive icons from a six-index bounded scan;
- native icon unchanged;
- minimal sheet-04 frame;
- ordinary lower-right stack count when >1;
- no duration/timer sweep/polling;
- event-driven `UNIT_AURA` invalidation;
- Blizzard player aura presentation untouched.

P0137 is durable at `2b578759` / `0.0.67-dev` and runtime + visual PASS.

The passive player-helpful lane is accepted. Populated player harmful/urgent,
populated target aura/status, private, and group ownership remain separately
gated/deferred. Do not manufacture those states solely to advance sequencing.

## World-attached target presentation

Status:
**OPEN — SOURCE + ANCHORING/FALLBACK AUDIT NEXT (P0139).**

Canonical investigation:
`FUTURE_WORLD_TARGET_PRESENTATION.md`.

The visual endpoint is approved by D-039, but the world/nameplate anchor source,
availability states, reaction/relative-danger source, protected-frame boundary,
and fail-open screen-space fallback are not yet proven.

P0139 is audit-only. No target/nameplate suppression or production anchor change
is authorized.
