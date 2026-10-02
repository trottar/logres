# D-030 — Minimap Remains Blizzard-Owned

Status: ACCEPTED
Date: 2026-10-02

## Decision

The Blizzard minimap remains **stock and Blizzard-owned**.

Phase E does not suppress, hide, disable, replace, or mutate the minimap.

## Why

Project suppression architecture allows a Blizzard surface to be suppressed
only after:
1. a deliberate Logres replacement exists;
2. its runtime behavior is proven;
3. restoration behavior is defined;
4. interaction/security constraints are understood.

Phase E now runtime-proves:
- horizontal heading compass;
- manual user-waypoint direction;
- movement/update/clear behavior;
- world/Immersion eligibility;
- fail-open omission.

That is not the complete minimap/navigation surface.

Known unreplaced or unsupported domains include:
- quest/objective navigation;
- route/path guidance;
- local POI/tracking information;
- minimap ping/click interaction;
- zoom controls;
- zone/territory context;
- other minimap utility not deliberately replaced and runtime-proven.

In particular, tested super-tracked quest IDs `436` and `237` produced no
usable quest waypoint output, so quest direction cannot be treated as a
replacement capability.

## Capability consequence

The minimap suppression gate is **false**.

No context-specific partial suppression is authorized by this decision.

This is a deliberate product/architecture decision, not an implementation
failure.

## Fail-open rule

If Logres compass/navigation is unavailable or incomplete, Blizzard navigation
remains available because the minimap is untouched.

## Reopening condition

Reopen minimap ownership only if a future phase deliberately adds and
runtime-proves the missing information/control surfaces and has a reversible
restoration contract.

A future review must start from the then-current Blizzard surface rather than
assuming D-030 should be overturned.

## Phase boundary

Phase E owns restrained direction through the world.

Phase F owns quest experience.

Keeping the minimap stock prevents Phase E from prematurely absorbing quest,
POI, tracking, map-control, or other unrelated presentation domains.
