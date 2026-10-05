# Visual Implementation Status

Status: **CANONICAL IMPLEMENTATION AUDIT**
Date: 2026-10-04

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
| Status / aura icon primitive | Yes | Logres does not own a complete aura/status presentation domain | Prove/filter sources and priority policy; implement player urgent/passive and target status placement; retain stock until replacement complete | **New capability + integration** |
| Cast-state cue | Yes | P0121 is durable at `fc928d99`; player cast runtime + visual result is accepted on the approved heraldic frame/glyph family | Target cast/channel remains environmentally deferred; player channel/interrupted variants remain state-coverage items unless naturally observed | **Player cast production primitive proven — target proof deferred** |
| Target health/name + relative danger | Yes | P0120 detached percentage bar under the existing sparse target name is part of the accepted core bar baseline; secure target interaction/selective stock-shell fallback remain unchanged | Audit safe reaction/relative-danger source; prove world-attached anchoring and fallback before making it default | **Capability + integration** |
| Pet / party compact health | Covered by bar + target/ally sheets | P0120 integrates compact percentage bars inside the runtime-proven pet/party rows using the accepted shared primitive | Natural group-composition density calibration remains; preserve Blizzard secure party/aura surfaces until separately replaced | **Production primitive integrated — group calibration deferred** |
| NPC quest narrative | Yes | Additive temporary title/body/objective presentation exists and has visual/runtime proof | Replace temporary excerpt-style surface with bounded/paged authored reader when the future ownership slice is implemented | **Integration + future ownership** |
| NPC quest controls / rewards | Yes | Not Logres-owned at runtime | Capability-prove and implement Accept/Decline, Continue/Complete, reward choice, quest-related gossip transitions, errors/eligibility, fail-open restoration | **Major new runtime capability** |
| Context messages | Yes | P0122 is durable at `62353ecf`; XP preview, live XP producer/check, objective preview, live objective producer/check, and full checkall passed on `0.0.52-dev` | Dedicated warmer completion variant remains naturally deferred; final whole-screen placement/contrast calibration remains polish | **Runtime + preview path proven — completion state deferred** |
| Active Quest | Yes | P0126 R1 `0.0.56-dev` passed live one-focus data, previews, hover inspection, feature/immersion response, and integrated checks. R2 `0.0.57-dev` removed persistent percentages and was visually preferred. R3 `0.0.58-dev` adds count-free normalized objective labels above bar-only progress while retaining hover-only exact detail | Confirm objective wording + bar composition in normal/complete/live presentation; final spacing/contrast calibration remains whole-screen polish | **R1 runtime + hover PASS; R3 minor visual refinement pending** |
| Player-health tunnel | Yes / D-036 frozen | P0124 is durable at `1e7e27e` / `0.0.54-dev`; five Theme-owned organic tunnel/death masks run on the proven native secret-safe health-to-alpha path, with deterministic D-036 preview percentages | Whole-interface contrast/scale polish remains; natural damage/heal may be observed opportunistically but is not required to re-prove the accepted preview matrix | **Runtime + visual baseline accepted — final polish deferred** |
| Compass heading + manual waypoint | Yes | P0123 is durable at `1721eb4d` / `0.0.53-dev`; heading/manual-waypoint runtime + visual PASS includes truthful off-tape suppression and near-center marker proof | Distance-dependent depth and identity remain gated because comparable distance/name inputs are not proven; quest/POI/tracking remain separate capability work | **Production primitive proven — extended roles gated** |
| Compass quest / POI / tracking roles | Yes | Sources not generally proven; only manual waypoint is production-proven | Dedicated source/runtime capability audit; implement only proven roles; keep stock minimap until D-037 replacement gate completes | **Capability blocked** |
| Class/pet/special controls | Shared button language approved; class-specific mechanics only partially covered | Existing Blizzard-owned child/special surfaces remain available; Logres ordinary action roles are separate | Apply button family where ownership is proven; design/implement discrete class-resource art (runes/combo points/etc.) separately as needed | **Residual art + capability** |
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

Next:
5. implement Active Quest using already-proven passive quest/objective data.

After that:
6. separately open capability slices for Logres-owned quest controls, aura/status,
   world-attached target, and unproven compass roles;
7. finish class-specific discrete resources, settings/accessibility, and final
   whole-screen composition calibration.

This is a dependency-oriented implementation map, not a claim that formal Phase H
has started. Phase G remains open but is explicitly frozen while this approved
visual sequence is completed.
