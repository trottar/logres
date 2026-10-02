# P0076 — Close E.4 / Open E.5

Date: 2026-10-02
Result: PREPARED

## Baseline

P0075 verified pushed:
`51763025758a1ee36897917792ee4088228e319b`

## Purpose

Record P0075 runtime + visual PASS, close E.4, and open the explicit
navigation-sufficiency/minimap capability review.

## E.4 result

PASS.

Accepted production capability:
- heading compass;
- manual user-waypoint compass marker;
- current-map bearing;
- movement/update/clear behavior;
- world/Immersion policy gating;
- fail-open omission.

## E.5 opened

**E.5 — Navigation sufficiency / minimap capability review**

Initial rule:
**no minimap mutation or suppression during the review.**

The review must inventory required Blizzard minimap/navigation information and
controls and decide whether any reversible suppression is justified.

## Runtime

No runtime code changes.

Production runtime remains:
`0.0.30-dev`.

Docs-only patch.
No WoW redeploy required.
