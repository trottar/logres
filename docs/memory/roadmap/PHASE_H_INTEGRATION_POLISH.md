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

## Parallel production visual translation — P0120–P0123

While Phase G remains the formal active roadmap phase, the user has explicitly
chosen to finish the already-approved visual translation sequence before
returning to Camera work.

Current parallel visual checkpoints:

- P0120: shared percentage-bar production baseline — accepted, additional
  ornament deferred;
- P0121: cast-state production glyph family — player cast runtime + visual PASS,
  target cast/channel naturally deferred;
- P0122: shared Context-message primitive — durable runtime/preview path PASS,
  objective-completion variant naturally deferred;
- P0123: heading/manual-waypoint Compass asset translation — runtime + visual
  PASS at `1721eb4d` / `0.0.53-dev`;
- P0124: organic player-health tunnel asset translation plus deterministic
  D-036 preview percentages — prepared for in-client proof.

This remains implementation translation under D-039/D-040. It does not authorize
Phase-H-only capability expansion, minimap suppression, unproven navigation
sources, or Camera changes.
