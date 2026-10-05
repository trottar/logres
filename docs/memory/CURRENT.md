---
memory_schema: 1
as_of: 2026-10-04
project: logres
---

# Current State

## Active Objective

**Approved visual implementation translation — Active Quest next.**

This is parallel Phase-H preparation while the formal Phase G camera phase remains
open. The user has explicitly frozen Camera work until the already-approved visual
sequence is finished.

## Current Work Item

**P0126 — Active Quest one-focus presentation prepared for in-client runtime +
visual proof.**

Latest verified durable checkpoint:
P0125 `72d2f040d9a4b5a5a5fa125e22da58884c07cbeb`.

Current pushed runtime:
`0.0.54-dev`.

Prepared refinement runtime:
`0.0.58-dev`.

Initial P0126 runtime `0.0.55-dev` exposed the hover tooltip API failure.
P0126 R1 `0.0.56-dev` corrected it and passed runtime/hover validation.
P0126 R2 `0.0.57-dev` removed persistent `%` labels and was visually preferred.

P0126 R3 adds count-free persistent objective labels from the existing normalized
objective text above each bar, while preserving hover-only exact counts. Narrow
visual confirmation is pending.

## Verified State

Visual translation:
- P0120 shared percentage/resource bar: runtime + visual PASS; simplified
  production baseline accepted; extra ornament deferred to whole-screen polish.
- P0121 cast-state cue: player cast runtime + visual PASS; target cast/channel
  remains environmentally deferred; player channel/interrupted variants remain
  state-coverage items unless naturally observed.
- P0122 Context-message primitive: runtime + preview path PASS; objective
  completion-specific treatment remains naturally deferred.
- P0123 Compass heading/manual waypoint: runtime + visual PASS at `1721eb4d` /
  `0.0.53-dev`; extended quest/POI/tracking roles remain capability-gated.
- P0124 organic player-health tunnel: runtime + visual baseline accepted at
  `1e7e27e` / `0.0.54-dev`; final visual polish is deferred to the broader
  whole-interface calibration pass.

Camera:
- Phase G / G.5 remains open but is intentionally frozen while visuals are
  finished.
- P0119 is durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`
  on runtime `0.0.49-dev`.
- P0119 replaced the constant-rate MoveView transition driver with frame-shaped
  motion and bounded target correction.
- The post-P0117 normal-Taxi landing retest has not been recorded as PASS and
  remains pending when Camera work resumes.
- Do not infer Camera completion from static code or later visual work.

Active Quest boundary:
- optional one-focus current quest;
- parchment/heraldic meaning-heavy treatment;
- title plus restrained ambient progress wording;
- one or more objective rows;
- shared percentage-bar language for percentage progress;
- deliberate hover/inspection for exact mechanical counts;
- quiet complete state;
- no permanent multi-quest objective tracker.

Preserved deferrals/gates:
- target cast/channel runtime proof: environmentally deferred;
- Context objective-completion-specific presentation: naturally deferred;
- Compass quest/POI/tracking, identity, and comparable-distance inputs:
  capability-gated;
- stock minimap remains until the complete D-037 replacement surface is proven;
- NPC quest controls/rewards remain Blizzard-owned until D-035 capability gates pass;
- target auras/status remain preserved until a dedicated replacement policy exists;
- party/CompactPartyFrame remain stock until secure interaction and required
  group/aura information are replaced safely;
- Camera G.5 P0119 Taxi landing retest remains pending and frozen.

## Next Action

After P0126 is verified pushed, deploy runtime `0.0.55-dev` and validate Active
Quest from the Phase-F developer panel:

1. Active Quest Check;
2. Active Quest Preview;
3. Active Quest Complete;
4. Active Quest Live;
5. Active Quest OFF / ON;
6. with a real selected/super-tracked quest when naturally available, confirm one
   live focus and hover-only exact objective wording/counts;
7. confirm Blizzard quest log / Objective Tracker remain available;
8. Immersion OFF / ON hides and restores the panel.

No quest travel or contrived completion is required.

## Success Criteria

The next Active Quest checkpoint succeeds when:
- one current-focus quest can be selected from proven passive quest/objective data;
- the panel presents title, ambient progress wording, objective rows, and a quiet
  completion treatment without becoming a permanent multi-quest tracker;
- exact mechanical counts appear only through deliberate inspection/hover;
- percentage progress reuses the accepted shared bar language where applicable;
- no new quest-control, navigation, minimap, aura, protected, or secret-value
  ownership is implied;
- static contracts pass and the production result receives in-client runtime +
  visual proof before being called complete.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- P0124 organic tunnel remains the accepted player-health production baseline;
- P0120 simplified shared percentage-bar baseline remains accepted pending final
  whole-screen polish;
- P0123 heading/manual-waypoint Compass remains accepted;
- Compass quest/POI/tracking roles remain capability-gated;
- stock minimap remains until D-037 replacement completeness is proven;
- NPC quest controls remain Blizzard-owned until D-035 capability proof;
- P0119 Camera landing retest is pending/frozen, not implicitly PASS;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/evidence/P0126_ACTIVE_QUEST_SOURCE_AUDIT_2026-10-04.md`
- `docs/memory/patches/P0126_ACTIVE_QUEST_PRESENTATION.md`
- `docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `docs/memory/decisions/D-040_PRODUCTION_VISUAL_ASSET_TRANSLATION_CONTRACT.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/evidence/P0124_HEALTH_TUNNEL_RUNTIME_VISUAL_PASS_2026-10-04.md`
- `docs/memory/patches/P0124_HEALTH_TUNNEL_VISUAL_TRANSLATION.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/design/approved/README.md`
