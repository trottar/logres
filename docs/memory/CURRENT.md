---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Approved visual implementation translation — P0142 D-037 navigation/minimap source-capability audit next.**

This remains parallel Phase-H preparation while formal Phase G / G.5 is open and
explicitly frozen until the approved visual sequence is finished.

## Current Work Item

**P0141 records P0140 runtime PASS with environmental world-anchor/attachment deferral; P0142 source audit next.**

Latest verified durable checkpoint:
P0140 `f7e2c31dd656dd1a7478670c56a32747db32a66e`.

Current pushed/tested runtime:
`0.0.68-dev`.

P0140 runtime result:
**PASS WITH ENVIRONMENTAL ANCHOR/ATTACHMENT DEFERRAL.**

Observed P0140 evidence:
- diagnostic lifecycle/API/event integration PASS;
- no-target/no-nameplate fallback PASS with zero failures;
- ordinary friendly reaction state PASS (`friendly`, `friend=true`,
  `canAttack=false`);
- ordinary `UnitIsTrivial` false result observed with zero secret skips;
- repeated target samples returned no accessible `"target"` nameplate;
- nameplate add/remove/behind-camera events were not observed in the recorded run;
- hidden addon-owned attachment therefore remained `not-attempted`;
- production world-target relocation remains **BLOCKED**;
- existing screen-space Logres target remains canonical fallback;
- Blizzard target/nameplate presentation remains preserved;
- integrated `Run All` remained PASS;
- no Lua, secret-value, forbidden/protected-frame, or other runtime issue was
  reported during testing.

Environmental absence of an accessible nameplate is a preserved deferral, not a
failure and not a reason to alter nameplate settings merely to manufacture proof.

## Verified State

Accepted production baselines remain:
- P0120 shared percentage/resource bar;
- P0121 player cast cue, with target cast/channel environmentally deferred;
- P0122 Context-message primitive;
- P0123 heading/manual-waypoint Compass;
- P0124 organic player-health tunnel;
- P0126 one-focus Active Quest;
- P0130 bounded/paged quest-offer narrative;
- P0133 Accept-left / Decline-right offer controls for the proven offer state;
- P0137 passive player `HELPFUL|PLAYER` aura lane.

World target:
- D-042 source/fallback policy remains accepted;
- reaction/fallback runtime paths are now proven for the observed scope;
- positive accessible-nameplate anchoring, behind-camera behavior, and hidden
  addon-owned attachment remain environmentally deferred;
- no production relocation or target-status ownership is authorized.

Navigation:
- heading/manual waypoint are production-proven;
- quest destination, local POI, tracking results, comparable-distance/depth
  inputs, and minimap replacement completeness remain source/runtime-unproven;
- Blizzard minimap remains stock and available.

Camera:
- P0119 remains durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`;
- the normal-Taxi landing retest remains pending/frozen, not PASS.

## Next Action

Prepare P0142 as a **D-037 navigation/minimap source-capability audit** against the
exact tested Forever source generation.

Audit, without runtime mutation:
1. quest-destination source APIs and update semantics, preserving the prior Phase-E
   negative result unless new source/runtime evidence changes it;
2. current tracking types, selection semantics, and whether individual detected
   results are addon-enumerable;
3. local minimap/POI/service sources and whether individual positions or bearings
   are addon-available;
4. safe player/map coordinate and comparable-distance inputs needed by D-038;
5. update/removal/staleness and secret/protected behavior;
6. the remaining stock minimap information/control responsibilities that must be
   replaced, deliberately omitted, or retained;
7. the smallest read-only runtime probes justified by source findings.

Do not suppress the minimap, fabricate marker bearings, add polling/broad hooks,
or implement unproven marker roles in P0142.

## Success Criteria

P0142 succeeds when the repository can state, from current primary source evidence,
which D-037 navigation roles have plausible supported source paths, which are
unavailable or indeterminate, what minimap responsibilities remain, and the exact
narrow runtime proof required next for any surviving candidate.

Source availability alone does not authorize production markers or minimap
suppression.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- harmful/urgent player and populated target aura production remain deferred;
- target aura/status remains separately gated from world-target anchoring;
- positive world-target nameplate anchoring/attachment remains deferred;
- stock minimap remains until D-037 replacement completeness is proven;
- party/CompactPartyFrame remain stock until secure interaction and required
  group/aura information are safely replaced;
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- P0119 Taxi landing retest remains pending/frozen;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/evidence/P0140_WORLD_TARGET_RUNTIME_PASS_WITH_DEFERRALS_2026-10-05.md`
- `docs/memory/patches/P0140_WORLD_TARGET_READ_ONLY_PROBE.md`
- `docs/memory/decisions/D-042_WORLD_TARGET_ANCHOR_AND_FALLBACK_POLICY.md`
- `docs/memory/investigations/FUTURE_WORLD_TARGET_PRESENTATION.md`
- `docs/memory/investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `docs/memory/decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
