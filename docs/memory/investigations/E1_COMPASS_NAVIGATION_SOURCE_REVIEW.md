# E.1 — Compass / Navigation Source Review

Status: ACTIVE
Opened: 2026-10-01

## Question

What is the smallest capability-safe production compass/navigation contract for
the tested Forever client?

## Known evidence

From I-001:
- open-world map position is available;
- open-world facing is available;
- tested party-instance map position is unavailable;
- tested party-instance facing is unavailable;
- both recover after returning to the world;
- `C_QuestLog.GetNextWaypoint` exists, but detailed waypoint output was not
  exercised.

From Phase D:
- world/instance context already exists in observed State;
- instance is not a global Logres-off state;
- PvP is orthogonal;
- fail-open fallback is required whenever Logres lacks a safe replacement.

## Source review targets

### Heading
Resolve:
- exact native facing source;
- units/range and orientation convention;
- unavailable-value behavior;
- update cadence.

### Position
Resolve:
- exact map ID source;
- exact player-position source;
- zone/map transition behavior;
- unavailable/restricted behavior;
- whether heading-only presentation remains meaningful when position is absent.

### Waypoints
Resolve:
- selected quest waypoint semantics;
- user waypoint API availability;
- map/coordinate conversion requirements;
- stale/absent waypoint handling;
- ownership boundary with Phase F quest presentation.

### Context
Resolve:
- consumption of existing State;
- world presentation;
- instance/restriction suspension;
- restoration when navigation capability returns;
- no polling/reassertion intended merely to fight restricted state.

### Blizzard fallback
Resolve:
- what the minimap currently provides that Logres does not;
- what must be replaced before any later minimap suppression;
- restoration/fail-open requirements.

## Diagnostic requirement

A future Compass Check should prefer addon-owned state and report:
- module enabled;
- observed context;
- heading capability available/unavailable;
- position capability available/unavailable;
- waypoint capability/status where proven;
- presentation active/suspended reason.

It must not invent navigation data.

## Exit

E.1 closes with:
- a source-backed capability matrix;
- explicit production API choices;
- a first runtime implementation slice;
- static contract requirements;
- a runtime validation plan.
