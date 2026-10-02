# Phase E — Compass and Navigation

Status: ACTIVE

## Objective

Build a Warcraft-aesthetic navigation layer that shows direction through the
world whenever the tested Forever client provides reliable navigation data.

The system must degrade safely when position or facing is unavailable.

Blizzard navigation remains available as fail-open fallback until Logres
deliberately replaces the required information/control surface.

## Existing runtime evidence

I-001 proved on the tested Forever client:

Open world:
- usable player map position is available;
- player facing is available.

Tested party instance:
- usable player map position is unavailable;
- player facing is unavailable;
- map restriction state is active.

After returning to the world:
- position/facing recover.

Therefore:
- world navigation is capability-gated;
- instance/restricted contexts suspend navigation when required inputs are
  unavailable;
- Logres never fabricates a bearing;
- absence of compass capability does not imply Immersion OFF;
- minimap suppression requires a later explicit capability gate.

## E.1 — Compass/navigation source review and capability audit

**Status: COMPLETE.**

D-029 is canonical.

Resolved:
- heading source: `GetPlayerFacing()`;
- API convention: radians, 0 north, increasing counterclockwise;
- presentation conversion:
  `headingDegrees = (360 - degrees(facing)) % 360`;
- first compass slice does not need map position;
- later player position path:
  `C_Map.GetBestMapForUnit("player")` +
  `C_Map.GetPlayerMapPosition(mapID, "player")`;
- map/player-facing queries are unavailable in restricted instance contexts;
- user waypoint APIs are source-present on Forever but project runtime semantics
  remain unproven;
- `C_QuestLog.GetNextWaypoint` is source-present/presence-proven but detailed
  semantics remain unproven;
- `SUPER_TRACKING_CHANGED` is source-listed for Forever;
- `USER_WAYPOINT_UPDATED` is not a current Forever dependency;
- waypoint bearing math must be separately proven;
- minimap remains stock.

## E.2 — Heading-only world compass

**Status: ACTIVE.**

Runtime target:
`0.0.28-dev`.

Implement:
- `Compass` module;
- top-center horizontal directional strip;
- cardinal/intercardinal heading presentation;
- consume persisted Immersion preference and existing observed State;
- eligible only when:
  - module enabled;
  - Immersion ON;
  - State context is `world`;
  - `GetPlayerFacing()` returns a usable non-secret number;
- throttled `OnUpdate` while presentation is eligible;
- immediate suspend/hide on preference/context ineligibility;
- fail closed for presentation when facing is absent;
- addon-owned diagnostic state and `Compass Check`.

Do not implement in E.2:
- player coordinates;
- quest waypoint marker;
- user waypoint marker;
- distance;
- route/path guidance;
- minimap suppression.

## E.3 — Waypoint-bearing capability/proof

**Status: QUEUED.**

Before waypoint markers:
- runtime-prove user waypoint retrieval on Forever;
- runtime-prove active/super-tracked quest selection path;
- runtime-prove quest waypoint result semantics;
- determine reliable Forever update events;
- convert player + target points through map/world coordinates;
- verify axis/bearing orientation in game;
- require matching world/continent domain before calculating a bearing;
- fail open/omit marker when conversion is unavailable.

Phase F owns quest text/objective presentation.
Phase E may later own only the restrained navigational bearing marker for the
currently selected/super-tracked destination.

## Minimap gate

The minimap remains Blizzard-owned.

Do not suppress it merely because the heading tape exists.

A later phase-E checkpoint must explicitly prove that Logres supplies every
required navigation/control surface for the active context before any reversible
minimap suppression is considered.

## Exit

Phase E completes only when:
- compass presentation is capability-safe and useful;
- world/instance suspension/restoration is proven;
- supported waypoint behavior is proven rather than assumed;
- required navigation fallback remains available;
- any minimap suppression is separately capability-gated and reversible.
