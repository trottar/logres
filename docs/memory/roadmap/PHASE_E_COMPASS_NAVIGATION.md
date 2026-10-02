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

**Status: COMPLETE.**

Runtime:
`0.0.28-dev`.

P0067:
`931f068e`.

Implemented:
- `Compass` module;
- top-center horizontal directional strip;
- cardinal/intercardinal heading presentation;
- persisted Immersion + existing State eligibility;
- world-only secret-safe `GetPlayerFacing()` sampling;
- throttled module-local `OnUpdate`;
- fail-closed heading presentation when facing is unavailable;
- addon-owned diagnostic state and `Compass Check`;
- no position, waypoint, distance, route, or minimap dependency.

User-reported requested runtime validation passed:
- open-world Compass Check;
- visible heading movement while rotating;
- N/E/S/W orientation;
- Immersion OFF suspension;
- Immersion ON restoration;
- Run All;
- no Lua/taint/secret regression reported;
- minimap unchanged.

Direct natural-instance transition behavior for the P0067 module was not
separately exercised in the final requested validation sequence.

E.2 closes under its accepted exit rule using:
- direct world/orientation/preference proof;
- existing I-001 restricted-instance capability evidence;
- explicit environmental deferral for direct P0067 instance-transition proof.

## E.3 — Waypoint-bearing capability/proof

**Status: ACTIVE.**

Before waypoint markers:
- runtime-prove user waypoint retrieval on Forever;
- runtime-prove active/super-tracked quest selection path;
- runtime-prove quest waypoint result semantics;
- determine reliable Forever update events;
- convert player + target points through map/world coordinates;
- verify axis/bearing orientation in game;
- require matching world/continent domain before calculating a bearing;
- fail open/omit marker when conversion is unavailable.

Do not treat source presence as runtime proof.

Do not add quest text/objective presentation here.

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
- world/instance suspension/restoration is proven or explicitly resolved under
  an accepted environmental deferral;
- supported waypoint behavior is proven rather than assumed;
- required navigation fallback remains available;
- any minimap suppression is separately capability-gated and reversible.
