# Visual Implementation Status

Status: **CANONICAL IMPLEMENTATION AUDIT**
Date: 2026-10-03

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
| Shared percentage/resource bar | Yes | Player resource, target health, pet/party health currently render primarily as percentage text | Build reusable secret-safe bar primitive; migrate accepted Logres-owned percentage consumers; keep player health excluded | **Runtime asset integration** |
| Action button primitive | Yes | Secure Primary/Secondary/Utility buttons, cooldown, counts, usability/range, pressed/activation plumbing already exist | Replace procedural rectangles/native pushed art with approved frame/state assets; add hover/checked polish; calibrate hotkey/count placement and 36-button density | **Mostly asset wiring** |
| Status / aura icon primitive | Yes | Logres does not own a complete aura/status presentation domain | Prove/filter sources and priority policy; implement player urgent/passive and target status placement; retain stock until replacement complete | **New capability + integration** |
| Cast-state cue | Yes | Player and target event-driven cast/channel cues exist; player true-path proven, target true-path historically environment-deferred | Replace procedural cue with approved silhouettes/assets; preserve no-timer contract; opportunistically verify target true path | **Mostly asset wiring + deferred proof** |
| Target health/name + relative danger | Yes | Sparse detached target name/health text and secure target interaction exist; selective stock shell replacement is proven fallback | Reuse percentage bar; audit/implement safe relative-danger source; prove world-attached anchoring and fallback before making it default | **Capability + integration** |
| Pet / party compact health | Covered by bar + target/ally sheets | Compact pet/party rows are runtime-proven | Reuse compact percentage bar and approved quiet typography; preserve Blizzard secure party/aura surfaces until separately replaced | **Mostly asset wiring** |
| NPC quest narrative | Yes | Additive temporary title/body/objective presentation exists and has visual/runtime proof | Replace temporary excerpt-style surface with bounded/paged authored reader when the future ownership slice is implemented | **Integration + future ownership** |
| NPC quest controls / rewards | Yes | Not Logres-owned at runtime | Capability-prove and implement Accept/Decline, Continue/Complete, reward choice, quest-related gossip transitions, errors/eligibility, fail-open restoration | **Major new runtime capability** |
| Context messages | Yes | XP pulse and objective-progress pulse are runtime + visual proven | Apply approved final line/diamond typography treatment; verify/add dedicated objective-completion variant only where producer semantics support it | **Mostly asset wiring** |
| Active Quest | Yes | No final optional Active Quest panel exists | Implement one-focus source selection, ambient phrase policy, progress bars, hover/inspection counts, complete state, toggle, and stable Phase-H anchor | **New presentation using mostly proven data** |
| Player-health tunnel | Yes / D-036 frozen | Secret-safe four-band procedural rectangle implementation is runtime-proven | Create organic mask/texture assets and continuous native secret-safe alpha/visible-field treatment; no Lua health branching | **Major visual/runtime integration** |
| Compass heading + manual waypoint | Yes | Heading tape + manual waypoint bearing are runtime-proven with procedural shapes | Replace tape/center/manual marker with approved assets; add lane/fade/focus/depth behavior for inputs already proven | **Asset wiring + calibration** |
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

1. establish a reusable production asset/tokens directory and naming convention;
2. implement the approved action-button and shared percentage-bar primitives;
3. assetize the already-proven cast cue, Context messages, heading compass, and
   manual waypoint;
4. replace the procedural health bands with the approved secret-safe tunnel treatment;
5. implement Active Quest using already-proven passive quest/objective data;
6. separately open capability slices for Logres-owned quest controls, aura/status,
   world-attached target, and unproven compass roles;
7. finish class-specific discrete resources, settings/accessibility, and final
   whole-screen composition calibration.

This is a dependency-oriented implementation map, not a claim that Phase H has
started while Phase G remains active.
