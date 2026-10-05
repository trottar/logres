---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Correct the manual-waypoint distance/depth acceptance before advancing the approved visual sequence. P0147 replaces arbitrary absolute depth thresholds with live local-awareness-relative bands and requires real cross-band visual proof.**

Formal Phase G / G.5 remains open and paused while the approved visual sequence is finished.

## Current Work Item

**P0147 — manual-waypoint depth calibration + evidence correction.**

Latest verified durable checkpoint:
P0146 `9606379c1c8f600d26a5fe9659e448c14df76e7b`.

Current pushed/tested runtime:
`0.0.70-dev`.

Corrected P0145/P0146 classification:
- same-map manual-waypoint yard distance is runtime-proven;
- clear-state fallback is runtime-proven;
- P0123 remains the actual off-tape runtime authority;
- all P0145 populated samples (`45.5`, `51.7`, `115.8`, `116.0` yards) were inside the old `120` yard near threshold and therefore all reported `depth=1.050`;
- those samples prove only the old near endpoint, not distance-dependent variation;
- the user reported the marker appeared the same size throughout that inadequate test;
- distance-dependent visible scale change is therefore **UNPROVEN**, and P0146's stronger acceptance wording is superseded by P0147.

P0147 candidate runtime:
`0.0.71-dev`.

P0147 depth reference:
`R = C_Minimap.GetViewRadius()`.

Semantic bands:
- close: `<=0.5R`;
- near: `0.5R–1R`;
- medium: `1R–4R`;
- far: `4R–8R`, with minimum retained beyond `8R`.

Scale anchors:
- close `1.05`;
- near endpoint `1.00`;
- medium endpoint `0.95`;
- far endpoint `0.90`;
- final angular-focus-combined render scale remains capped at `0.90–1.12`.

Navigation boundaries otherwise remain unchanged:
- quest/current-navigation destination remains environmental DEFERRED;
- current-map AreaPOI/service usefulness remains environmental DEFERRED;
- individual tracking-result/service-instance positions remain source-blocked;
- Blizzard minimap remains stock and available.

## Verified State

Accepted production baselines remain:
- P0120 shared percentage/resource bar;
- P0121 player cast cue, target cast/channel deferred;
- P0122 Context-message primitive;
- P0123 heading/manual-waypoint Compass bearing + visual baseline;
- P0124 organic player-health tunnel;
- P0126 one-focus Active Quest;
- P0130 bounded/paged quest-offer narrative;
- P0133 Accept-left / Decline-right offer controls for the proven offer state;
- P0137 passive player `HELPFUL|PLAYER` aura lane.

P0145 remains accepted only for manual-waypoint same-map distance arithmetic and clean clear-state fallback. Its distance-dependent visual depth behavior is reopened by P0147.

World target:
- P0140 fallback/reaction runtime paths pass for the observed scope;
- positive accessible-nameplate anchoring, behind-camera behavior, and hidden addon-owned attachment remain environmentally deferred;
- production target placement remains screen-space.

Class / pet / special-control territory:
- Blizzard-owned direct player class-resource children, RuneFrame, TotemFrame, PetFrame, alternate-power, and unsupported possess/override/vehicle surfaces remain preserved;
- the source/capability audit is postponed to P0148 until P0147 is genuinely accepted.

Camera:
- P0119 remains durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`;
- normal-Taxi landing retest remains pending/frozen, not PASS.

## Next Action

Apply P0147, deploy `0.0.71-dev`, then deliberately sample multiple manual-waypoint depth bands.

Required in-client proof:
1. close waypoint `<=0.5R`;
2. near waypoint `0.5R–1R`;
3. medium waypoint `>1R`, preferably `2R–4R`;
4. far waypoint, preferably `>=8R` to exercise the minimum endpoint;
5. cleared waypoint fallback;
6. integrated `Run All` after successful band testing.

For each populated sample, record `yards`, live `radius`, `ratio`, semantic `band`, `depth`, and `renderScale` from Compass Check.

Acceptance also requires explicit user visual confirmation that marker size changes perceptibly across bands while remaining restrained. Diagnostics alone are insufficient.

After P0147 is accepted and recorded, perform **P0148 source/capability audit only** for class/pet/special-control territory.

## Success Criteria

P0147 succeeds only when:
- live minimap radius is ordinary and usable for the observed samples;
- reported semantic bands match `distance / radius`;
- depth changes coherently across sampled bands;
- marker size visibly changes across bands according to user observation;
- existing bearing/off-tape/fail-open behavior remains intact;
- clear state resets depth/render state;
- integrated checks remain clean;
- no new quest/POI/tracking ownership or minimap suppression is introduced.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- harmful/urgent player and populated target aura production remain deferred;
- target aura/status remains separately gated from world-target anchoring;
- positive world-target nameplate anchoring/attachment remains deferred;
- individual tracking-result positions are source-blocked by P0142/D-043;
- town/service tracking filters do not imply enumerable service-instance positions;
- P0143 empty AreaPOI/current-navigation/quest-waypoint results remain environmental deferrals;
- stock minimap remains until D-037/D-043 replacement completeness is proven;
- party/CompactPartyFrame remain stock until secure interaction and required group/aura information are safely replaced;
- direct player class-resource children, RuneFrame, TotemFrame, PetFrame, alternate-power, and unsupported special-control surfaces remain Blizzard-owned until separately capability-proven;
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- P0119 Taxi landing retest remains pending/frozen;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/evidence/P0147_P0145_DEPTH_VALIDATION_CORRECTION_2026-10-05.md`
- `docs/memory/patches/P0147_CORRECT_MANUAL_WAYPOINT_DEPTH_CALIBRATION.md`
- `docs/memory/patches/P0146_RECORD_P0145_RUNTIME_RESULT.md`
- `docs/memory/patches/P0145_MANUAL_WAYPOINT_DISTANCE_DEPTH.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/memory/investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `docs/memory/investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/ROADMAP.md`
