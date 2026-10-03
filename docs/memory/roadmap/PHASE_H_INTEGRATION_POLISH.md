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
- `../architecture/WORLD_FIRST_LAYOUT.md`
- `../architecture/VISUAL_SYSTEM_DIRECTION.md`
- `../architecture/VISUAL_COMPONENT_INVENTORY.md`

## Accepted inputs

Phase H begins from these settled directions:
- world before abstraction;
- authored semantic screen regions;
- optional Active Quest current-focus presentation;
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
- broaden supported action sources and role assignment safely;
- optional limited action-grid/whole-cluster adjustments if justified;
- world-attached target capability and fallback policy;
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
- perceptual-effect studies such as health-tunnel styling;
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
