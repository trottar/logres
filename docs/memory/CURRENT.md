---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Correct the manual-waypoint distance/depth visual amplitude before advancing the approved visual sequence. P0147 proved the local-awareness-relative curve mechanically but failed visual validation because the `1.05 -> 0.90` size range was not perceptible enough on the 12x20 waypoint glyph.**

Formal Phase G / G.5 remains open and paused while the approved visual sequence is finished.

## Current Work Item

**P0148 — increase manual-waypoint depth visual amplitude and revalidate near/medium/far appearance.**

Latest verified durable checkpoint:
P0147 `c274a9d13c677082cf4ce90b9fbbd0152e9989ec`.

Current pushed/tested runtime:
`0.0.71-dev`.

P0147 result:
- live `C_Minimap.GetViewRadius()` reference works;
- cross-band distance/radius classification works;
- sampled bands included close, near, medium, and far;
- depth values changed coherently from `1.050` down to `0.900`;
- integrated `Run All` passed;
- the user reported the waypoint remained effectively the same size, with any shrink barely noticeable;
- therefore P0147 is **RUNTIME/MECHANICAL PASS, VISUAL FAIL**.

The failure is explained by glyph geometry: the base manual waypoint is only `12x20` px, so `1.05 -> 0.90` changes nominal size only from about `12.6x21` px to `10.8x18` px.

P0148 candidate runtime:
`0.0.72-dev`.

P0148 keeps the P0147 semantic bands:
- close: `<=0.5R`;
- near: `0.5R–1R`;
- medium: `1R–4R`;
- far: `4R–8R`, minimum beyond `8R`.

P0148 scale anchors:
- close `1.20`;
- near endpoint `1.05`;
- medium endpoint `0.85`;
- far endpoint `0.70`;
- final angular-focus-combined render clamp `0.70–1.28`.

At the existing 12x20 glyph, the un-focused endpoints are approximately `14.4x24` px close and `8.4x14` px far, making the intended depth cue materially visible without adding numeric distance text or a new marker role.

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

P0145 remains accepted for manual-waypoint same-map distance arithmetic and clear-state fallback. P0147 additionally proves the live-radius band/reference mechanics, but its visual amplitude is rejected.

World target:
- P0140 fallback/reaction runtime paths pass for the observed scope;
- positive accessible-nameplate anchoring, behind-camera behavior, and hidden addon-owned attachment remain environmentally deferred;
- production target placement remains screen-space.

Class / pet / special-control territory:
- Blizzard-owned direct player class-resource children, RuneFrame, TotemFrame, PetFrame, alternate-power, and unsupported possess/override/vehicle surfaces remain preserved;
- the source/capability audit moves to P0149 and does not begin until P0148 is visually accepted.

Camera:
- P0119 remains durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`;
- normal-Taxi landing retest remains pending/frozen, not PASS.

## Next Action

Apply P0148, deploy `0.0.72-dev`, and re-sample the already-proven close/near/medium/far waypoint bands.

Required in-client proof:
1. one close/near sample at or inside local awareness;
2. one medium sample beyond `1R`;
3. one far sample beyond `4R`, preferably `>=8R`;
4. keep marker bearing reasonably similar when visually comparing size so angular focus does not dominate the comparison;
5. clear waypoint fallback;
6. integrated `Run All` after successful visual testing.

Acceptance requires explicit user confirmation that the size difference is clearly perceptible and still aesthetically acceptable. Diagnostics alone cannot close P0148.

After P0148 is accepted and recorded, perform **P0149 source/capability audit only** for class/pet/special-control territory.

## Success Criteria

P0148 succeeds only when:
- close/near, medium, and far diagnostics remain coherent with the P0147 live-radius bands;
- close/near marker size is visibly stronger than medium;
- far marker size is visibly smaller than close/near;
- the larger amplitude is not judged excessive or distracting;
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

- `docs/memory/evidence/P0148_P0147_WAYPOINT_DEPTH_VISUAL_FAIL_2026-10-05.md`
- `docs/memory/patches/P0148_INCREASE_MANUAL_WAYPOINT_DEPTH_AMPLITUDE.md`
- `docs/memory/patches/P0147_CORRECT_MANUAL_WAYPOINT_DEPTH_CALIBRATION.md`
- `docs/memory/evidence/P0147_P0145_DEPTH_VALIDATION_CORRECTION_2026-10-05.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/memory/decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`
- `docs/memory/investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `docs/memory/investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/ROADMAP.md`
