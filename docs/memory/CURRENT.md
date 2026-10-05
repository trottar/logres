---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Approved visual implementation translation — quest-offer Accept / Decline capability probe next.**

This is parallel Phase-H preparation while the formal Phase G camera phase remains
open. The user has explicitly frozen Camera work until the already-approved visual
sequence is finished.

## Current Work Item

**P0132 planning target — production Logres quest-offer Accept / Decline controls
with Blizzard controls retained as visible fallback during proof.**

Latest verified durable checkpoint:
P0130 `ab6473b25944f6d8e17318235b370a6cb5a74cc5`.

Current pushed runtime:
`0.0.61-dev`.

Current tested runtime:
`0.0.63-dev`.

P0129 read-only runtime evidence passes the naturally observed offer/gossip path:
- three real `QUEST_DETAIL` states;
- stable available-gossip quest ID/title;
- one real two-choice reward metadata sample;
- secret=false / failures=0 in observed snapshots;
- all expected mutation APIs present but `invoked=0`;
- integrated `checkall` PASS.

`QUEST_PROGRESS` / `QUEST_COMPLETE`, active-gossip rows, generic gossip options,
reward currencies, and reward spells remain environmentally deferred.

P0130 runtime/visual proof passed paging, real `QUEST_DETAIL`, and Blizzard
control coexistence, but exposed a real lifecycle defect: after Immersion OFF then
ON during the same open quest offer, the Logres narrative did not restore until a
fresh `QUEST_DETAIL`.

P0130 R1 is runtime + visual PASS. The OFF -> ON restore path executed directly
with `presentationReason=immersion-on-restore`; the same real offer remained shown,
body/objective data remained ordinary/non-secret, and integrated checks passed.

P0130 is accepted as the production quest-offer narrative baseline. Quest/gossip
mutation ownership remains unproven.

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
- P0126 Active Quest: runtime + visual PASS at `89b0c563` / `0.0.58-dev`;
  one-focus title + count-free objective labels + bar-only progress + hover exact
  detail is the accepted production baseline; final whole-screen polish deferred.

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

Prepare P0132 as the first **production** quest-offer action surface.

Scope:
1. use the already-proven P0130 quest-offer narrative state;
2. add explicit Logres-owned Accept / Decline controls for the offer phase only;
3. route those controls through the proven Accept / Decline capability path;
4. keep Blizzard Accept / Decline controls visible and usable during proof;
5. preserve exact offer identity, cancellation, and fail-open behavior;
6. add deterministic visual preview plus real in-client proof;
7. do not include Continue / Complete, rewards, or gossip transitions.

Only after those production controls are proven may a later checkpoint consider
capability-gated Blizzard offer-control suppression.

## Success Criteria

P0132 succeeds only when:
- Logres offer controls are explicit player-owned buttons;
- exact current offer identity is bound to the action surface;
- Accept / Decline use the proven mutation path with no automatic choice;
- Blizzard controls remain fully usable as fallback throughout proof;
- unsupported/missing/secret/invalid state fails open;
- visual state matches the approved quest-interaction direction;
- no Lua, taint, protected-action, secret-value, wrong-quest, or duplicate-action
  defect occurs.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- P0124 organic tunnel remains the accepted player-health production baseline;
- P0120 simplified shared percentage-bar baseline remains accepted pending final
  whole-screen polish;
- P0123 heading/manual-waypoint Compass remains accepted;
- P0126 Active Quest remains accepted; do not reintroduce persistent `%`/`N/M`
  objective mechanics without new evidence;
- Compass quest/POI/tracking roles remain capability-gated;
- stock minimap remains until D-037 replacement completeness is proven;
- NPC quest controls remain Blizzard-owned until D-035 capability proof;
- P0119 Camera landing retest is pending/frozen, not implicitly PASS;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/evidence/P0131_QUEST_OFFER_ACTION_RUNTIME_PASS_2026-10-05.md`
- `docs/memory/evidence/P0131_ACCEPT_EVENT_ORDER_FAILURE_2026-10-05.md`
- `docs/memory/evidence/P0130_QUEST_DIALOGUE_R1_RUNTIME_VISUAL_PASS_2026-10-05.md`
- `docs/memory/evidence/P0130_QUEST_DIALOGUE_IMMERSION_RESTORE_FAILURE_2026-10-05.md`
- `docs/memory/evidence/P0129_NPC_QUEST_INTERACTION_RUNTIME_READ_PASS_2026-10-05.md`
- `docs/memory/evidence/P0128_NPC_QUEST_INTERACTION_SOURCE_AUDIT_2026-10-05.md`
- `docs/memory/evidence/P0126_ACTIVE_QUEST_RUNTIME_VISUAL_PASS_2026-10-05.md`
- `docs/memory/patches/P0126_ACTIVE_QUEST_PRESENTATION.md`
- `docs/memory/investigations/NPC_QUEST_INTERACTION_CAPABILITY.md`
- `docs/memory/decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
- `docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `docs/memory/decisions/D-040_PRODUCTION_VISUAL_ASSET_TRANSLATION_CONTRACT.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/evidence/P0124_HEALTH_TUNNEL_RUNTIME_VISUAL_PASS_2026-10-04.md`
- `docs/memory/patches/P0124_HEALTH_TUNNEL_VISUAL_TRANSLATION.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/design/approved/README.md`
