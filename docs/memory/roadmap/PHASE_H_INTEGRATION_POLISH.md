# Phase H — Integration and Polish

Status: QUEUED

## Product objective

Integrate the proven Logres capabilities into one authored world-first
composition, expose only the settings needed to preserve meaningful player
choice, and finish fallback/restoration/accessibility behavior without turning
Logres into a general-purpose UI construction toolkit.

Canonical direction:
- `../decisions/D-032_WORLD_FIRST_LAYOUT_AND_ACTION_ROLES.md`
- `../decisions/D-033_PARALLEL_ART_DIRECTION_AND_WORLD_GHOST.md`
- `../decisions/D-034_SELECTIVE_HYBRID_E_AND_VISUAL_COMPONENTS.md`
- `../decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
- `../decisions/D-036_HEALTH_TUNNEL_VISIBLE_FIELD_CONTRACT.md`
- `../decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `../decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `../decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `../decisions/D-040_PRODUCTION_VISUAL_ASSET_TRANSLATION_CONTRACT.md`
- `../architecture/WORLD_FIRST_LAYOUT.md`
- `../architecture/VISUAL_SYSTEM_DIRECTION.md`
- `../architecture/VISUAL_COMPONENT_INVENTORY.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../../design/approved/README.md`

## Accepted inputs

Phase H begins from these settled directions:
- world before abstraction;
- approved continuous player-health tunnel in which clear/usable visual field
  roughly follows remaining health, with increasingly severe critical collapse;
- four semantic navigation roles: manual waypoint, quest destination, local radius
  POI, and tracking; local POI/tracking capability remains unproven;
- D-038 compass focus/depth treatment: exact-bearing glyph anchors, center-focused
  identity with continuous angular fade, proximity-first focus selection when safe
  comparable distance exists, and bounded depth scaling for major destinations;
- stock minimap remains available until the complete D-037 replacement gate is
  satisfied;
- authored semantic screen regions;
- optional Active Quest current-focus presentation;
- NPC quest interaction is a future Logres-owned experience, with Blizzard
  fallback retained until each information/control surface is capability-proven;
- dedicated transient Context region;
- fixed Primary role plus user assignment of supported bars to
  Secondary/Utility roles;
- separate pet/class/special-control domains;
- world-attached target presentation as the intended default endpoint;
- urgent player debuffs near reaction/resources;
- passive player buffs/auras peripheral;
- target status attached to the world target when safe;
- every removed Blizzard surface requires a deliberate replacement/fallback.

## Candidate work slices

Exact ordering is intentionally not frozen before Phase H starts.

Likely slices include:
- establish authored layout anchors / integration geometry;
- decouple transient Context from incidental module anchors;
- Active Quest toggle, ambient wording, and exact hover detail;
- Logres-owned NPC quest interaction: bounded/paged source text,
  accept/decline, continue/complete, reward choice, required quest-related
  gossip transitions, eligibility/error feedback, and fail-open fallback;
- broaden supported action sources and role assignment safely;
- optional limited action-grid/whole-cluster adjustments if justified;
- world-attached target capability and fallback policy;
- source/runtime audit for local POI, tracking-result, quest-destination, and
  remaining minimap information/control capabilities before any minimap suppression;
- integrate the accepted four-role compass marker system only for proven sources;
- aura/status ownership, filtering, and placement;
- coherent settings/toggles for optional Logres feature domains;
- accessibility, compatibility, restoration, performance, packaging, and final
  visual consistency.

## Parallel art-direction preparation

Phase H visual preparation can begin before Lua integration work reaches this
phase.

Parallel deliverables may include:
- moodboards / art-direction sheets;
- full-screen representative mockups;
- typography/color/opacity/spacing/motion tokens;
- reusable asset-family exploration;
- health-tunnel asset/mask implementation studies constrained by the frozen D-036
  visible-field mapping;
- compass state/detail sheets covering heading, manual waypoint, quest destination,
  local POI, generic tracking glyphs, center-focus identity/fade, collision lanes, and
  bounded depth states without implying source capability;
- canonical component boards from `VISUAL_COMPONENT_INVENTORY.md`, including full 36-button combat-density stress tests and state sheets.

Current preferred working direction:
**Selective Hybrid E on the World Ghost foundation** — authored/thematic treatment for meaning-heavy surfaces, simple high-density interaction controls, restrained Warcraft-native Logres/Camelot cues, and a shared percentage-bar primitive for percentage-based Logres-owned values except player health.

These outputs inform implementation later; they do not replace capability
proofs.

## Non-goals

Phase H does not automatically imply:
- arbitrary draggable frame construction;
- general action-bar profiles/editors;
- removal of stock fallbacks before replacements are proven;
- a permanent conventional player-health bar;
- a permanent multi-quest objective tracker.

## Exit

Phase H completes when the accepted Logres experience is integrated,
configurable at the intended product boundaries, fail-open, visually coherent,
and validated across the contexts/capabilities the project claims to own.

## Approved visual baseline — D-039

The twelve approved visual reference sheets are now tracked under
`docs/design/approved/` and accepted by D-039.

For the represented families, Phase H should default to implementation translation,
not another broad concept pass:
- derive production texture/mask/glyph assets;
- establish reusable art/tokens and stable authored anchors;
- wire approved primitives into already-proven runtime producers first;
- open separate capability slices where controls/data/ownership are still unproven;
- validate the final treatment in client at realistic density and world contrast.

The canonical component-by-component split between art, runtime plumbing, and
capability ownership is `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`.

Residual visual design remains for class-specific discrete mechanics,
settings/accessibility, exact hotkey/count/36-button density calibration, and any
future capability-proven surface absent from the approved sheets.

This parallel visual checkpoint does not change the active Phase G / G.5 objective.

## First production translation — P0116

P0116 establishes `Logres/Media/` plus `Theme.lua` as the production asset/token
boundary and wires the approved action-button frame/state family into the
already-proven secure action runtime.

This is parallel Phase H preparation while G.5 remains active.

The implementation deliberately does not change:
- secure execution or paging;
- key routing;
- Primary/Secondary/Utility geometry;
- contextual alpha policy;
- stock Bar 2–3 replacement/restoration.

Static contract checks precede an in-client visual gate. A later evidence
checkpoint must record the real-scale result before the action primitive is
considered production visually proven.


## Action visual refinement — P0118

P0116's core production action primitive is accepted in client. P0118 applies
the approved aura-metadata readability idea to action keybinds with a stronger
near-black bronze-edged plate, compact modifier labels (`s-Q`, `c-C`, `a-E`),
and a modest 42 px default button size. Bottom-right counts and all secure action
behavior remain unchanged.

This remains parallel Phase H preparation while Phase G / G.5 runtime proof is
active.

## Parallel production visual translation — P0120–P0126

While Phase G remains the formal active roadmap phase, the user has explicitly
chosen to finish the already-approved visual translation sequence before
returning to Camera work.

Accepted parallel visual checkpoints:

- P0120: shared percentage-bar production baseline — accepted, additional
  ornament deferred;
- P0121: cast-state production glyph family — player cast runtime + visual PASS,
  target cast/channel naturally deferred;
- P0122: shared Context-message primitive — durable runtime/preview path PASS,
  objective-completion variant naturally deferred;
- P0123: heading/manual-waypoint Compass asset translation — runtime + visual
  PASS at `1721eb4d` / `0.0.53-dev`;
- P0124: organic player-health tunnel — runtime + visual baseline accepted at
  `1e7e27e` / `0.0.54-dev`; broad final polish deferred to whole-interface
  calibration;
- P0126: Active Quest one-focus presentation — runtime + visual PASS at
  `89b0c563` / `0.0.58-dev`; count-free objective labels, bar-only progress,
  hover-only exact detail; final whole-screen polish deferred.

P0128 source-audit result:
**SOURCE LAYER RESOLVED.**

Narrative/reward/gossip read sources exist on Forever, and the expected quest and
gossip action APIs exist, but mutation ownership remains runtime-unproven.

P0129:
**INSTALLED / PUSHED + READ-ONLY PASS FOR OBSERVED OFFER/GOSSIP SCOPE** at
`e50676b9` / `0.0.59-dev`.

Observed evidence proves offer title/body/objective, one stable available-gossip
quest row, and one real two-choice reward metadata sample without secret/call
failures. All expected mutation function groups were present with `invoked=0`.
Progress/complete and other unobserved categories remain deferred.

P0130:
**RUNTIME + VISUAL PASS — `0.0.61-dev`.**

Approved sheet 07 is now production-proven for the quest-offer state: full source
paging, Previous / Next, wrapped objective text, Blizzard-control coexistence, and
same-conversation Immersion OFF -> ON restoration. The initial restore failure is
preserved in evidence and corrected in R1.

P0131:
**ACCEPT + DECLINE CAPABILITY PASS.**

Decline is proven by `QUEST_FINISHED`; Accept is proven by a matched
`QUEST_ACCEPTED` after the intermediate `QUEST_FINISHED`, with no polling/timer or
new mutation surface.

P0132:
**RUNTIME + CONTROL PASS; VISUAL ORDER CORRECTION REQUIRED — `0.0.64-dev`.**

Production Decline and Accept both pass through the proven action path, preview is
non-mutating, final-page gating works, Blizzard controls remain visible, and
integrated checks pass.

Manual review found one visual integration defect: Logres placed Decline left /
Accept right, opposite Blizzard's simultaneously visible fallback.

P0133:
**RUNTIME + VISUAL PASS — `0.0.65-dev`.**

Accept-left / Decline-right now matches Blizzard's simultaneous fallback, while
preview/final-page gating, production routing, and integrated checks remain clean.

The quest-offer visual/control slice is accepted.

P0135:
**SOURCE + PRIORITY-POLICY LAYER RESOLVED.**

The exact Forever `C_UnitAuras` / `C_Secrets` source contract is pinned, and D-041
defines urgent player, passive player, target-status, private/group, PvP, and
accessibility boundaries.

No aura/status stock suppression is authorized.

P0136:
**RUNTIME PROBE PASS WITH ENVIRONMENTAL DEFERRALS on `0.0.66-dev`.**

Ordinary populated player helpful data is proven; selected metadata is ordinary.
Player harmful populated categories and populated target categories were absent,
so those remain DEFERRED. No secret branch was encountered. Integrated checks
pass.

P0137:
**RUNTIME + VISUAL PASS — `0.0.67-dev`.**

The passive player `HELPFUL|PLAYER` lane is accepted at real UI scale:
- native icon remains dominant;
- approved minimal frame;
- lower-right stack metadata;
- event-driven updates;
- no countdown/timer sweep/polling;
- integrated check remains clean.

Player harmful/urgent and populated target aura data remain environmental
deferrals. Private/group aura ownership and stock suppression remain gated.

P0139:
**INSTALLED / PUSHED — SOURCE + FALLBACK POLICY LAYER RESOLVED** at `b0122136`.

D-042 accepts only conditional accessible nameplate anchoring, with
`includeForbidden=false`, behind-camera/no-nameplate fallback, no nameplate CVar
mutation, and no Blizzard frame mutation.

Reaction candidates are source-available; relative danger is restricted to
`UnitIsTrivial` low-danger de-emphasis if runtime-proven ordinary.

P0140:
**RUNTIME PASS WITH ENVIRONMENTAL ANCHOR/ATTACHMENT DEFERRAL — `f7e2c31d`, `0.0.68-dev`.**

The diagnostic proves safe no-nameplate fallback and ordinary friendly
reaction/triviality reads with zero recorded failures. No accessible target
nameplate was observed, so behind-camera and hidden attachment proof remain
environmentally deferred. Production target relocation stays blocked.

P0142:
**SOURCE-CAPABILITY LAYER RESOLVED — DOCS/PRIMARY-SOURCE EVIDENCE ONLY.**

The exact Forever source establishes:
- ordinary quest waypoint and broader current-navigation source families;
- multi-select tracking filter state;
- no public per-detected tracking-result positions;
- no service-instance positions from service tracking filters;
- positioned `C_AreaPoiInfo` as a distinct runtime candidate;
- minimap view radius and map/world geometry as runtime-gated distance inputs;
- continued stock minimap completeness requirements.

D-043 records the fail-open/source policy.

P0143:
**INSTALLED / PUSHED — RUNTIME PASS FOR OBSERVED NAVIGATION-SOURCE SCOPE WITH ENVIRONMENTAL DEFERRALS** at `b9b2f90b` / `0.0.69-dev`.

P0143 proves ordinary current-map/player geometry, map world size, minimap view
radius, and bounded multi-select tracking selector metadata/state with zero
secret skips/failures. The tested state had no AreaPOI rows and no current,
quest, or user-waypoint destination; those branches remain DEFERRED. Integrated
`Run All` passed.

P0144 is durable at `47534363`.

P0145:
**INSTALLED / PUSHED — SAME-MAP DISTANCE + CLEAR-STATE PASS; DEPTH VARIATION REOPENED BY P0147 at `60244841` / `0.0.70-dev`.**

The accepted samples proved ordinary same-map yard distance and clear-state fallback
but all hit only the old near-depth endpoint. P0147 replaces the arbitrary absolute
thresholds with live minimap-radius close/near/medium/far bands and requires explicit
cross-band user visual confirmation. P0123 remains the off-tape runtime authority.
Quest/POI/tracking roles and stock minimap ownership remain unchanged.

Next:
**P0147 depth correction/revalidation, then P0148 class/pet/special-control source audit.**

Preserve direct class-resource children, RuneFrame, TotemFrame, PetFrame, alternate
power, and unsupported special-control fallbacks until each domain is deliberately
proven. This remains capability preparation under D-035/D-039 and does not
authorize minimap suppression, broader aura ownership, automated quest choices,
or Camera changes.
