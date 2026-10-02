# P0077 — Close Phase E / Open Phase F

Date: 2026-10-02
Result: PREPARED

## Baseline

P0076 verified pushed:
`ebb4bbc7084987e78b2fb9789d712a7e9d81e239`

## Purpose

Resolve E.5, accept the minimap ownership contract, close Phase E, and open
Phase F / F.1.

## E.5 result

**NO MINIMAP SUPPRESSION.**

Canonical decision:
`../decisions/D-030_MINIMAP_REMAINS_BLIZZARD_OWNED.md`

The suppression gate fails because Logres does not replace the complete stock
minimap/navigation information and control surface.

No unsafe minimap suppression probe is required.

## Phase E

**COMPLETE.**

Accepted production navigation:
- heading compass;
- manual user-waypoint compass marker;
- fail-open omission.

Blizzard-owned:
- minimap;
- unsupported quest navigation;
- POI/tracking/map controls and other unreplaced minimap utility.

## Phase F

**ACTIVE — F.1 Quest-experience source / capability review.**

No stock quest/objective/XP suppression is authorized during F.1.

## Runtime

No runtime code changes.

Production runtime remains:
`0.0.30-dev`.

Docs-only patch.
No WoW redeploy required.
