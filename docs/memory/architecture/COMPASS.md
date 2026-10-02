# Compass Architecture

## Product intent

A Skyrim-like interaction pattern rendered with a Warcraft-native aesthetic:
- horizontal directional strip;
- central heading;
- restrained objective/waypoint markers;
- no minimap dependence for ordinary immersion only after sufficient Logres
  navigation capability is proven.

## Context

The compass belongs to Immersion Mode.

Default:
- Immersion ON + world/exploration: available when source capability exists;
- Immersion OFF: hidden;
- instances/restricted navigation contexts: automatically hidden/suspended;
- restoration after leaving an instance should be silent and smooth.

The compass consumes existing State. It does not create its own world/instance
authority.

## D-029 heading contract

The first production heading source is:
`GetPlayerFacing()`.

Forever/reference semantics:
- radians;
- 0 = north;
- counterclockwise-positive;
- unavailable in restricted instance content.

Presentation converts to conventional clockwise degrees:

`headingDegrees = (360 - degrees(facing)) % 360`

The first runtime slice uses heading only.

Player position is not required for a cardinal/intercardinal compass tape.

## E.2 presentation

E.2 adds:
- top-center horizontal heading tape;
- cardinal/intercardinal labels;
- module-local throttled facing refresh;
- addon-owned availability/presentation diagnostics.

Eligibility:
- Compass module enabled;
- Immersion ON;
- existing State context = `world`;
- `GetPlayerFacing()` returns a usable non-secret number.

If facing is unavailable, the compass suspends rather than retaining or
fabricating the prior heading.

## Position / waypoint boundary

Later waypoint bearings may use:
- `C_Map.GetBestMapForUnit("player")`;
- `C_Map.GetPlayerMapPosition`;
- map/world coordinate conversion;
- user/super-tracked quest waypoint data where runtime-proven.

Waypoint math must be separately runtime-proven.

Do not infer a destination bearing from source availability alone.

## Minimap boundary

The minimap remains Blizzard-owned through E.2 and E.3 capability work.

A horizontal heading tape is not a safe minimap replacement by itself.

Any minimap suppression requires a later explicit capability/fallback decision
and reversible implementation.
