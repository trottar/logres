# D-037 — Navigation Marker Roles and Future Minimap Direction

Status: ACCEPTED — FUTURE ENDPOINT; CAPABILITY-GATED
Date: 2026-10-03

## Decision

The long-term world-first navigation endpoint is broader than the currently
proven Phase E compass.

If the required information and control surfaces can be deliberately sourced,
implemented, runtime-proven, restored, and failed open, Logres should eventually
replace ordinary minimap awareness with the authored compass/navigation system.

This is a future product direction, not current suppression authorization.

D-030 remains authoritative for current runtime behavior:
**the Blizzard minimap stays stock and Blizzard-owned until the replacement gate
is actually satisfied.**

D-037 changes only the intended future endpoint. It does not rewrite the
historical E.5 negative result.

## Four navigation roles

The compass/navigation system should distinguish four semantic marker roles.

### 1. Manual waypoint

Meaning:
**the player explicitly chose this destination.**

Direction:
- authored Logres waypoint glyph;
- muted blue/cyan family is the accepted working semantic accent;
- distinct from the fixed center-heading marker;
- current manual user-waypoint capability remains the only marker role already
  runtime-proven in Phase E.

### 2. Quest destination

Meaning:
**the selected/current quest leads here.**

Direction:
- separate quest/heraldic destination treatment;
- visually distinct from manual waypoint and local POI;
- only presented when a real quest destination/bearing is capability-proven;
- never fabricate direction from quest ownership, objective text, or super-track
  selection alone.

Current Phase E evidence did not prove usable quest waypoint output for the
accepted test quests, so this role remains future/capability-gated.

### 3. Local radius POI

Meaning:
**a useful nearby world service/place exists within realistic local awareness.**

Examples may include service/location information analogous to what the stock
minimap can expose, such as repair/armorer, innkeeper, flight master, mailbox,
trainer, or other client-supported local POIs.

The exact Forever POI set must be source/runtime-enumerated rather than guessed.

Direction:
- local/proximity-limited rather than an unlimited world destination;
- restrained Logres POI marker;
- enough semantic distinction from quest/manual markers to read immediately;
- exact identity may be available on deliberate inspection if the source safely
  provides it;
- radius should correspond to believable local/minimap awareness rather than a
  global map lookup.

A client-provided minimap/view radius is a candidate source only after current
Forever source/runtime confirmation. D-037 does not assume an API contract that
has not yet been proven.

### 4. Tracking

Meaning:
**the player's currently selected tracking mode detected a matching nearby
thing.**

Tracking is deliberately separate from local POI semantics.

Visual direction:
- one generic Logres tracker glyph regardless of the tracked category;
- repeated markers are allowed when multiple matching tracked entities are
  present;
- the glyph should be small, restrained, and derived from the established Logres
  heraldic/material language;
- do not literally reproduce stock yellow dots;
- do not create a separate icon taxonomy for beasts, herbs, minerals, humanoids,
  or other track categories merely for ornament.

P0142 resolves the tracking-selection question against the pinned Forever source:
tracking state is per-index and multi-select capable. The earlier singular-mode
working assumption is therefore rejected.

Because the audited public API exposes tracking filter metadata/state but not
individual detected-result positions, the repeated generic tracking-glyph endpoint
remains visual-only and source-blocked until a supported per-result source exists.
D-043 is authoritative for this source/fallback boundary.


## Visual-system relationship

D-034 remains authoritative:
**thematic for meaning; restrained for interaction.**

Therefore:
- manual waypoint and quest destination may carry stronger authored identity;
- local POI stays compact and readable;
- tracking is the quietest repeated marker family;
- exact glyph construction, dimensions, collision rules, and final color values
  remain design work and are not frozen by D-037.

The compass itself remains a top-center horizontal heading tape with a fixed
center-heading reference and moving navigation markers.

## Capability audit required before implementation

Before any new POI/tracking implementation or minimap suppression, source and
runtime work must establish at least:

1. the actual Forever tracking types and selection semantics;
2. whether individual tracked results expose usable positions/bearings to addon
   code;
3. the actual local POI/service categories exposed by the current client;
4. whether individual local POIs expose usable positions/bearings;
5. a safe player-position/map-coordinate source for the relevant contexts;
6. a safe local-radius source or an explicit product-owned fallback radius;
7. quest-destination capability for the quest-navigation role;
8. update/event semantics and stale-result cleanup;
9. secret/protected/combat behavior;
10. density/collision behavior when several markers occupy similar bearings;
11. all remaining stock minimap information/control responsibilities that would
    otherwise be lost.

The audit should enumerate the current Forever client rather than hard-code a
list copied from another WoW branch.

## Minimap replacement gate

A compass with more markers is still not automatically a complete minimap
replacement.

Before suppression, Logres must deliberately account for every stock surface the
product still needs, including applicable:
- heading/orientation;
- manual waypoint direction;
- quest/objective navigation;
- local POI/service awareness;
- selected tracking awareness;
- ping/click interaction;
- zoom/map interaction expectations;
- zone/territory context;
- other current Forever minimap utility discovered by the audit.

A stock responsibility may be deliberately judged unnecessary only through an
explicit product decision. It must not disappear accidentally because the
compass looks complete.

## Fail-open

Until the full replacement gate passes:
- the Blizzard minimap remains available;
- unsupported marker roles are omitted rather than fabricated;
- missing/secret/invalid position data produces no Logres marker;
- no polling/broad hooks are added merely to force an unproven capability;
- no invisible Blizzard click/control region may be left behind.

## Phase relationship

Phase E's runtime work and D-030 remain valid historical/current evidence.

D-037 is accepted future Phase H+ product direction and should drive later
source/runtime capability investigations and compass visual studies.

## P0142 source-policy refinement

P0142 source evidence is recorded in
`../evidence/P0142_NAVIGATION_MINIMAP_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`.

D-043 refines this decision without changing its world-first intent:
- tracking filter selection is multi-select;
- individual tracking-result positions are not publicly enumerable;
- service/townsfolk tracking categories do not expose service-instance positions;
- positioned `C_AreaPoiInfo` rows are a separate candidate family;
- `C_Minimap.GetViewRadius` and `C_Map` geometry are runtime-gated candidates;
- the Blizzard minimap remains the completeness fallback.

P0143 is the next read-only runtime proof for only the surviving candidates.
