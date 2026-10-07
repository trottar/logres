# Active Investigations

## G.5 — Taxi camera ownership

Status:
**CLOSED FOR OBSERVED TAXI ZOOM SCOPE — P0160 R2 RUNTIME PASS.**

Canonical Taxi investigation:
`G5_TAXI_CAMERA_OWNERSHIP.md`

P0160 R2 is durable at `ae75989b` / `0.0.79-dev`.

Observed normal Taxi:
- start about `4.0096`;
- requested/effective target `50`;
- final `50`;
- 347 samples;
- 346 toward / 0 away;
- 0 direction switches;
- 2 source rebases;
- failures=0.

After landing:
- World start `50`;
- target `5`;
- final about `4.9806`;
- 158 samples;
- 156 toward / 1 away;
- 0 direction switches;
- 2 source rebases;
- failures=0.

The user visually confirmed outbound zoom and return after landing.

The P0159 `0 <-> 50` / 80-switch failure does not recur. G.5 Taxi zoom convergence is therefore closed for observed scope.

## G.6 — Captured DynamicCam profile parity

Status:
**CLOSED FOR CLAIMED OBSERVED SCOPE — P0162 RUNTIME PASS.**

Canonical:
`G6_DYNAMICCAM_PROFILE_PARITY.md`

P0161 is durable at `2a959094` / `0.0.80-dev` and runtime-accepted for the observed Taxi/settings/shoulder-offset scope: Taxi target `50`, continuous yaw `-20`, City landing return about `4.97-5.01`, rotate-back completion, City max-distance factor `1` with original factor `4` retained, and zero profile settings/rotation/secret/runtime failures.

Teleport/NPC/Fishing/Gathering and unobserved AFK behavior remain environmental deferrals.

P0162 R3 is durable at `4628f49e` / `0.0.81-dev` and runtime-accepted. The bounded wheel gate exercised quick accumulation and direction reset, preserved same-context manual zoom, restored/reacquired CameraZoom ownership across OFF/ON, and ended with zero hook conflicts, secret skips, or reactive failures.

Phase G is closed for claimed observed scope. Teleport/NPC/Fishing/Gathering and unobserved AFK behavior remain explicit environmental deferrals. DynamicCam UI fades remain a Phase H presentation boundary.

### Current world-entry timeout regression

Status:
**CLOSED FOR OBSERVED NORMAL WORLD ENTRY — P0156 RUNTIME PASS.**

P0156 is durable at `e1be731b` / `0.0.77-dev`. LoadCount `187` passed Phase G Camera World/Combat Check at world zoom about `5.0795` toward target `5`, with `targetReached=true`, `failures=0`, `secret=false`, and `error=nil`. Separate Run All repeated the PASS and completed cleanly.

The accepted P0156 sample reported `firstDelay=0` and `switches=0`.

P0159 subsequently exercised the direction-switch branch heavily during the real Taxi landing failure (`80` switches). That newer evidence supersedes the earlier “unexercised” branch status while preserving the older P0154/P0155 failures.

No additional world-entry-specific patch is justified. P0160 R2 addresses the reproduced shared zoom-engine defect instead.

Canonical investigation:
`CAMERA_WORLD_ENTRY_TRANSITION_TIMEOUT_2026-10-06.md`.

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

G.6 captured DynamicCam profile parity:
**CLOSED FOR CLAIMED OBSERVED SCOPE — P0162 RUNTIME PASS on `0.0.81-dev`.**

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
**OPEN / ENVIRONMENTALLY DEFERRED POSITIVE ANCHOR — P0140 FALLBACK/REACTION RUNTIME PASS.**

Canonical investigation:
`FUTURE_WORLD_TARGET_PRESENTATION.md`.

P0139 / D-042 source policy remains authoritative. P0140 is durable at
`f7e2c31d` / `0.0.68-dev`.

Runtime evidence proves:
- safe no-target/no-nameplate fallback;
- ordinary friendly reaction;
- ordinary `UnitIsTrivial=false`;
- zero probe failures / secret skips in the recorded samples;
- integrated `Run All` PASS.

No accessible target nameplate was observed, so behind-camera and hidden
addon-owned attachment paths remain environmental DEFERRED. Production relocation
remains blocked and the screen-space target remains canonical fallback.

## Navigation / minimap capability

Status:
**OPEN WITH ACCEPTED MANUAL-WAYPOINT BASELINE — P0148 RUNTIME + VISUAL PASS; QUEST/AREA-POI DEFERRED; TRACKING RESULTS BLOCKED.**

Canonical investigation:
`FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`.

P0142 / D-043 source policy remains authoritative.

P0143 proves current-map/player geometry, map world size, minimap view radius, and
multi-select tracking selector metadata/state. AreaPOI/current/quest destination
paths remain environmental DEFERRED; tracking-result/service-instance positions
remain source-blocked.

P0145 proves same-map manual-waypoint distance and clear fallback.

P0147 proves the live minimap-radius band mechanics but fails visual calibration.

P0148 is durable at `6f381a77` / `0.0.72-dev` and is runtime + visual PASS:
the stronger `1.20 / 1.05 / 0.85 / 0.70` scale anchors make close/medium/far depth
perceptible. Further amplitude tuning is deferred to later whole-interface polish.

P0123 remains off-tape runtime authority. Stock minimap ownership and unproven
quest/POI/tracking roles remain unchanged.

## Class / pet / special-control ownership

Status:
**P0152 R12 PET-ACTION RUNTIME + CONTROL + STATE-PRESENTATION PASS; FINAL VISUAL POLISH DEFERRED.**

Canonical investigation:
`FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`.

P0149 / D-044 source policy remains authoritative. P0150 R3 remains the accepted read-only source baseline.

P0152 is durable at `00aef4a90e5999140dc9082e68e934cfc854cb05` / `0.0.74-dev` and is accepted for the bounded pet-action slice. The final pet-state diagnostic recognized ten click-specific pet bindings, seven naturally readable/occupied slots, two active-state indicators, and one autocast indicator. Default-on arming succeeded, and the user confirmed both the visible state treatment and working pet button presses.

Stock PetActionBar remains available. Pet edit/reorder, binding replacement, PetActionBar suppression/restoration, PetFrame ownership, stance/form, totem, rune, alternate-power, discrete class-resource, and unsupported special-control ownership remain separately gated.

Exact pet-button ornament/contrast refinement is deferred to later whole-interface polish rather than treated as an open control defect.
