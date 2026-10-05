# Visual Implementation Status

Status: **CANONICAL IMPLEMENTATION AUDIT**
Date: 2026-10-05

Canonical visual decision:
`../decisions/D-039_APPROVED_VISUAL_BASELINE.md`.

Approved reference assets:
`../../design/approved/README.md`.

## Purpose

The broad visual language is now substantially designed. This record separates
three questions that must not be conflated:

1. **Art approved?** — is the component's intended appearance settled enough to
   implement?
2. **Runtime plumbing exists?** — does Logres already own a working producer/control
   path that can receive the approved art?
3. **Capability/ownership complete?** — may Logres safely replace the relevant
   Blizzard surface or use the required data/control source?

A component can be visually complete while runtime ownership remains incomplete.

## Audit

| Domain | Approved visual | Current runtime | Remaining work | Classification |
| --- | --- | --- | --- | --- |
| World Ghost / Hybrid E composition | Yes | Existing modules are independently placed | Establish shared production asset/token library and Phase-H integration anchors; in-client spacing/contrast calibration | **Integration / organization** |
| Shared percentage/resource bar | Yes | P0120 reusable normal/compact production bar is runtime + visual PASS for the core production baseline; visible `%` text is retained and player health remains excluded | Preserve the accepted simpler production baseline; defer additional approved-sheet ornament and final spacing/color calibration to whole-screen polish | **Production primitive proven — ornament deferred** |
| Action button primitive | Yes | Secure Primary/Secondary/Utility buttons consume the production D-040 frame/state family; P0116 core presentation is proven and P0118 keybind plate/compact modifier/42 px polish is visually accepted | Checked/cooldown/range/resource/unusable visual states remain coverage-deferred; final 36-button density calibration remains whole-screen polish | **Production primitive + metadata polish proven** |
| Status / aura icon primitive | Yes | P0137 `2b578759` / `0.0.67-dev` is runtime + visual PASS for the passive player `HELPFUL|PLAYER` native-icon lane with lower-right ordinary stack metadata and event-driven updates | Retain harmful/target/private/group stock ownership until populated runtime proof; no stock suppression | **Player helpful production baseline accepted** |
| Cast-state cue | Yes | P0121 is durable at `fc928d99`; player cast runtime + visual result is accepted on the approved heraldic frame/glyph family | Target cast/channel remains environmentally deferred; player channel/interrupted variants remain state-coverage items unless naturally observed | **Player cast production primitive proven — target proof deferred** |
| Target health/name + relative danger | Yes | Existing sparse target name + P0120 percentage bar remain the screen-space fallback. P0140 `f7e2c31d` / `0.0.68-dev` runtime-proves safe no-nameplate fallback and ordinary friendly reaction/triviality reads with zero observed failures | Positive accessible-nameplate result, behind-camera path, and hidden addon-owned attachment remain environmental deferrals; production relocation stays blocked | **Fallback/reaction runtime PASS — world-anchor capability deferred** |
| Pet / party compact health | Covered by bar + target/ally sheets | P0120 integrates compact percentage bars inside the runtime-proven pet/party rows using the accepted shared primitive | Natural group-composition density calibration remains; preserve Blizzard secure party/aura surfaces until separately replaced | **Production primitive integrated — group calibration deferred** |
| NPC quest narrative | Yes | P0130 R1 `0.0.61-dev` is runtime + visual PASS: full-source paging, Previous/Next, real offer rendering, Blizzard-control coexistence, and same-conversation Immersion OFF -> ON restoration all proven | Final whole-screen spacing/contrast calibration remains polish; progress/completion narrative stays gated by deferred runtime states | **Runtime + visual production baseline accepted** |
| NPC quest controls / rewards | Yes | P0132 production controls pass; P0133 `f2feead6` / `0.0.65-dev` is runtime + visual PASS with Accept-left / Decline-right aligned to Blizzard while fallback remains visible | Continue/Complete/reward/gossip mutation remains separately gated; later suppression requires further proof | **Offer production baseline accepted for proven state** |
| Context messages | Yes | P0122 is durable at `62353ecf`; XP preview, live XP producer/check, objective preview, live objective producer/check, and full checkall passed on `0.0.52-dev` | Dedicated warmer completion variant remains naturally deferred; final whole-screen placement/contrast calibration remains polish | **Runtime + preview path proven — completion state deferred** |
| Active Quest | Yes | P0126 is durable at `89b0c563` / `0.0.58-dev`; final R3 runtime + visual PASS uses one-focus title, count-free normalized objective labels, bar-only progress, hover-only exact detail, quiet completion, and an independent persisted toggle | Final whole-screen spacing/contrast calibration remains polish; do not reopen persistent `%`/`N/M` mechanics without new evidence | **Runtime + visual production baseline accepted** |
| Player-health tunnel | Yes / D-036 frozen | P0124 is durable at `1e7e27e` / `0.0.54-dev`; five Theme-owned organic tunnel/death masks run on the proven native secret-safe health-to-alpha path, with deterministic D-036 preview percentages | Whole-interface contrast/scale polish remains; natural damage/heal may be observed opportunistically but is not required to re-prove the accepted preview matrix | **Runtime + visual baseline accepted — final polish deferred** |
| Compass heading + manual waypoint | Yes | P0148 `6f381a77` / `0.0.72-dev` is runtime + visual PASS for the live-radius depth baseline after P0147's too-subtle calibration failed | Preserve P0123 off-tape authority; defer exact amplitude refinement to final whole-screen polish; identity remains unavailable | **Production depth baseline accepted — final calibration deferred** |
| Compass quest / POI / tracking roles | Yes | P0143 `b9b2f90b` / `0.0.69-dev` runtime-proves current-map/player geometry, minimap view radius, and 23/23 multi-select tracking selector metadata rows; individual tracked-result/service-instance positions remain source-blocked | Current-map AreaPOI population and current/quest waypoint output were absent and remain deferred; keep stock minimap until replacement completeness is proven | **Geometry/selector metadata proven — destination/AreaPOI deferred; tracking-result markers blocked** |
| Class/pet/special controls | Shared button language approved; class-specific mechanics only partially covered | P0149/D-044 resolves source boundaries: pet secure cast is plausible; stance/totem mutation remains gated; class resources are secret-first/discrete; special modes remain stock | P0150 bounded read-only runtime probe; implement only runtime-proven domains afterward | **Source layer resolved — runtime probe next** |
| Settings / accessibility | Visual language only, no dedicated final sheet | Preference infrastructure exists, not final Phase-H settings UI | Design compact settings/accessibility presentation and expose only accepted product choices | **Residual design / integration** |

## Consequence

The project no longer needs another broad round of component concept exploration
before implementation.

For the approved families, the default workflow is now:

**approved sheet -> production asset extraction/derivation -> narrow runtime wiring ->
in-client visual proof -> durable evidence.**

New concept work is reserved for genuinely uncovered domains or when runtime evidence
invalidates an approved treatment.

## Practical implementation order

Phase H ordering remains capability-gated rather than frozen, but the lowest-risk
translation work is now clear:

Completed translation sequence:
1. production asset/token boundary plus action-button primitive;
2. shared percentage/resource bar;
3. player cast cue, Context messages, heading compass, and manual waypoint;
4. organic secret-safe player-health tunnel.

Completed:
5. Active Quest one-focus production presentation.

Completed:
6. D-035 NPC quest-interaction source/API audit (P0128).

Completed:
7. P0129 read-only NPC quest interaction runtime probe for the naturally observed
   offer/gossip scope.

Completed:
8. P0130 bounded/paged NPC quest-offer narrative runtime + visual proof.

Completed:
9. P0131 runtime capability proof for player-triggered Accept / Decline.

Completed:
10. P0132 production offer-control runtime/control proof; one left/right visual
    alignment defect recorded.

Completed:
11. P0133 Accept-left / Decline-right alignment runtime + visual PASS.

Completed:
12. P0135 aura/status source + priority-policy audit.

Next:
13. P0136 read-only player/target aura-status runtime probe — PASS with environmental deferrals.

Completed:
14. P0137 production player helpful aura presentation — runtime + visual PASS.

Deferred:
15. player harmful/urgent production until populated runtime proof exists.

Completed:
16. P0139 world-attached target source + anchoring/fallback audit.

Completed with environmental deferral:
17. P0140 read-only world-target runtime probe — fallback/reaction PASS on
    `f7e2c31d` / `0.0.68-dev`; positive anchor/attachment remains deferred.

Completed:
18. P0142 D-037 navigation/minimap source-capability audit — source layer resolved;
    D-043 accepted; individual tracking-result/service-instance positions blocked.

Completed with environmental deferrals:
19. P0143 read-only runtime proof — current-map/player geometry, minimap view
    radius, and tracking selector metadata/state PASS; AreaPOI/current/quest
    destination paths deferred.

Completed with correction history:
20. P0145 manual-waypoint same-map distance + clear-state proof.
21. P0147 live-local-awareness band mechanics — runtime/mechanical PASS, visual FAIL
    because `1.05 -> 0.90` was too subtle.
22. P0148 stronger manual-waypoint depth amplitude — runtime + visual PASS at
    `6f381a77` / `0.0.72-dev`; exact amplitude polish deferred.

Current:
23. P0149 class/pet/special-control source-capability audit — source layer resolved,
    D-044 accepted; no runtime suppression or mutation.

Next:
24. P0150 bounded read-only class/pet/special source probe.
25. implement only source/runtime-proven class/pet/special slices, preserve stock
    fallback for the rest, and continue settings/accessibility/final whole-screen
    composition calibration. Deferred navigation roles remain deferred until natural
    evidence or new source capability justifies reopening them.

This is a dependency-oriented implementation map, not a claim that formal Phase H
has started. Phase G remains open but is explicitly frozen while this approved
visual sequence is completed.
