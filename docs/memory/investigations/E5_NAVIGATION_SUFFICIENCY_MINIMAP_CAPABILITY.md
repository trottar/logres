# E.5 — Navigation Sufficiency / Minimap Capability

Status: ACTIVE — SOURCE/CAPABILITY REVIEW
Opened: 2026-10-02

## Question

Does Logres now replace enough of the Blizzard minimap/navigation information
and control surface to justify suppressing any part of the stock minimap?

This is a capability review, not an implementation authorization.

## Proven Logres navigation

Runtime-proven:
- heading compass;
- manual user-waypoint compass marker;
- waypoint updates/clearing;
- player-movement bearing refresh;
- world/Immersion policy suppression/recovery;
- fail-open omission when required waypoint inputs are absent/unusable.

Not proven/supported:
- quest waypoint destination presentation;
- route/path guidance;
- minimap tracking controls;
- minimap click interactions;
- broader map/minimap POI information;
- any other Blizzard-owned minimap utility not explicitly replaced.

## Review requirements

Inventory the Blizzard minimap/navigation surface on the tested Forever client
and classify each item:

1. information;
2. navigation;
3. control/interaction;
4. required fallback;
5. replaced by Logres / intentionally stock / unsupported.

At minimum review:
- player orientation/local spatial context;
- manual waypoint direction;
- quest/objective navigation;
- tracking/POI indicators;
- minimap interaction/click controls;
- zoom and related controls;
- mail/vendor/repair/other local indicators if present;
- instance/restricted-context behavior;
- restoration requirements.

## Decision rule

Do not suppress a Blizzard surface merely because Logres has a compass.

Suppression is allowed only when:
- required information is deliberately replaced or intentionally excluded;
- required interaction/control remains safely available;
- unsupported contexts fail open to stock presentation;
- restoration is deterministic and capability-gated.

If these conditions are not met, the minimap remains stock.

## Non-scope

This investigation does not authorize:
- quest text/objective UI;
- fabricated quest bearings;
- minimap mutation;
- broad stock UI suppression.

## Exit

Close E.5 only with an explicit accepted capability contract describing either:
- exact contexts/surfaces where reversible minimap suppression is safe; or
- a decision that the minimap remains Blizzard-owned for Phase E.

Then proceed to the next Phase E checkpoint based on that decision.
