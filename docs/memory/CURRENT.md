---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Approved visual implementation translation — production quest-offer Accept / Decline controls next.**

This is parallel Phase-H preparation while the formal Phase G camera phase remains
open. The user has explicitly frozen Camera work until the already-approved visual
sequence is finished.

## Current Work Item

**P0132 — production Logres quest-offer Accept / Decline controls prepared for
runtime + visual proof with Blizzard controls retained as visible fallback.**

Latest verified durable checkpoint:
P0131 `68233e647279c8651a83626952ad409531c71832`.

Current pushed runtime:
`0.0.63-dev`.

Prepared runtime:
`0.0.64-dev`.

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

P0130 is accepted as the production quest-offer narrative baseline.

P0131 is durable at `68233e64` / `0.0.63-dev` and proves both player-triggered
offer mutations on Forever:
- Decline -> `QUEST_FINISHED`, event-confirmed;
- Accept -> matched `QUEST_ACCEPTED` after intermediate `QUEST_FINISHED`.

P0132 therefore advances only the offer-phase production control surface. It does
not suppress Blizzard controls or expand into Continue / Complete / rewards /
gossip.

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
- Blizzard quest-offer controls remain available through P0132 proof; Continue /
  Complete / reward / gossip ownership remains separately capability-gated;
- target auras/status remain preserved until a dedicated replacement policy exists;
- party/CompactPartyFrame remain stock until secure interaction and required
  group/aura information are replaced safely;
- Camera G.5 P0119 Taxi landing retest remains pending and frozen.

## Next Action

Deploy P0132 `0.0.64-dev` and prove the production offer controls.

Validation:
1. use `Quest Dialogue Preview` to verify controls are hidden before the final
   page and visible on the final page;
2. click a preview control and confirm it is non-mutating;
3. Phase H -> `Quest Offer Controls Check`;
4. open a real quest offer and confirm both Logres and Blizzard offer controls are
   simultaneously visible/usable;
5. test Logres Decline and Accept separately where naturally convenient, checking
   production event outcomes after each;
6. Phase 0 -> `Run All`.

Do not test Continue / Complete, reward selection, or gossip selection in P0132.

## Success Criteria

P0132 succeeds only when:
- Logres offer controls are explicit player-owned buttons;
- long offers gate those controls to the final page;
- exact current offer identity is bound to the action surface;
- preview controls cannot mutate quest state;
- Accept / Decline reuse the proven P0131 mutation path with no automatic choice;
- Blizzard controls remain fully usable as fallback throughout proof;
- unsupported/missing/secret/invalid state fails open;
- visual state matches approved sheet 08;
- no Lua, taint, protected-action, secret-value, wrong-quest, duplicate-action, or
  invisible-click-surface defect occurs.

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

- `docs/memory/patches/P0132_PRODUCTION_QUEST_OFFER_CONTROLS.md`
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
