# Phase E — Compass and Navigation

Status: ACTIVE

## Objective

Build a Warcraft-aesthetic navigation layer that shows direction through the
world whenever the tested Forever client provides reliable navigation data.

The system must degrade safely when position or facing is unavailable.

Blizzard navigation remains available as fail-open fallback until Logres
deliberately replaces the required information/control surface.

## Existing runtime evidence

I-001 already proved on the tested Forever client:

Open world:
- usable player map position is available;
- player facing is available.

Tested party instance:
- usable player map position is unavailable;
- player facing is unavailable;
- map restriction state is active.

After returning to the world:
- position/facing recover.

Therefore Phase E starts with these non-negotiable rules:
- world navigation is capability-gated;
- instance/restricted contexts suspend the compass when required inputs are
  unavailable;
- Logres never fabricates a bearing;
- absence of compass capability does not imply Immersion OFF;
- minimap suppression requires a later explicit capability gate.

`C_QuestLog.GetNextWaypoint` is present, but its detailed runtime semantics were
not proven by I-001.

## E.1 — Compass/navigation source review and capability audit

**Status: ACTIVE.**

Resolve before runtime implementation:

1. exact heading/facing API and value semantics;
2. exact player map-position API and map-transition semantics;
3. safe availability checks;
4. update cadence/event strategy;
5. integration with existing State world/instance context;
6. selected quest waypoint capability;
7. user waypoint capability;
8. coordinate/bearing conversion requirements;
9. Phase E navigation marker ownership vs Phase F quest presentation;
10. minimap suppression prerequisites;
11. addon-owned diagnostic state and runtime proof matrix.

### Standing rules

- Do not fabricate position or heading.
- Do not suppress the minimap during E.1.
- Do not create a competing global context mode; consume existing State.
- Do not require contrived travel solely to prove an unavailable environmental
  path when existing evidence already establishes the restriction.
- Preserve Blizzard navigation fail-open when Logres lacks equivalent required
  information/control.
- PvP remains a modifier, not Immersion OFF.

## First implementation gate

E.1 should end with a narrow first runtime slice.

Expected shape, subject to source review:
- world-only compass heading presentation;
- immediate suspension when required navigation inputs are unavailable;
- no quest/user marker until its data contract is proven;
- no minimap suppression.

Do not commit to that slice if current source evidence contradicts it.

## Exit

Phase E completes only when:
- compass presentation is capability-safe and useful;
- world/instance suspension/restoration is proven;
- supported waypoint behavior is proven rather than assumed;
- required navigation fallback remains available;
- any minimap suppression is separately capability-gated and reversible.
