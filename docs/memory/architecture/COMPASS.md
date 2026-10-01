# Compass Architecture

## Product intent

A Skyrim-like interaction pattern rendered with a Warcraft-native aesthetic:
- horizontal directional strip;
- central heading;
- restrained objective/waypoint markers;
- no minimap dependence for ordinary immersion when sufficient data exists.

## Context

The compass belongs to Immersion Mode.

Default:
- world/exploration: available;
- instances: automatically hidden/suspended;
- restoration after leaving instance should be silent and smooth.

## Technical status

Position, facing, objective-bearing, and instance restrictions must be established by the Phase 0 API audit.

Graceful degradation is required. The compass must never fabricate bearings when source data is unavailable.
