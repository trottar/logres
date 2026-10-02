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
- first compass slice does not need map position;
- later player position path uses `C_Map`;
- waypoint APIs/events require dedicated runtime proof;
- minimap remains stock.

## E.2 — Heading-only world compass

**Status: COMPLETE.**

Runtime:
`0.0.28-dev`.

P0067:
`931f068e`.

The requested runtime validation passed, with direct natural-instance module
transition proof explicitly environmentally deferred under existing I-001
restricted-context evidence.

## E.3 — Waypoint-bearing capability/proof

**Status: ACTIVE.**

P0069 prepares a dedicated temporary `LogresWaypointAudit` addon.

The probe runtime-proves:
- user waypoint retrieval;
- active/super-tracked quest selection;
- quest waypoint result semantics;
- Forever navigation event registration/firing;
- player + destination map/world conversion;
- compatible world/continent domain;
- candidate axis/bearing orientation.

The probe records both `+Y north` and `-Y north` world-bearing candidates.
Runtime visual comparison chooses the correct convention.

Do not treat source presence as runtime proof.

Do not add quest text/objective presentation here.

Do not add a production waypoint marker until E.3 proof is accepted.

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
- supported waypoint behavior is proven rather than assumed;
- required navigation fallback remains available;
- any minimap suppression is separately capability-gated and reversible.
