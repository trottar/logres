# Current Handoff

Authoritative state: `../CURRENT.md`.

P0073 is verified pushed at `4d4ea878`.

Phase E / E.3 is complete.

Final north-reference runtime proof:
- current-map waypoint position was usable;
- map delta was approximately `-0.00506, -0.37168`;
- map-space bearing was `359.2` degrees;
- previous raw-world candidates remained near east.

Therefore the supported bearing orientation is current UI map space, not raw
world X/Y.

Active work:
**E.4 — User-waypoint compass marker integration.**

E.4 scope:
- manual user waypoint only;
- current-player-map bearing;
- existing world/Immersion compass eligibility;
- fail open;
- no quest marker without new runtime evidence;
- minimap remains stock.

Production runtime remains `0.0.29-dev`.

User performs all commits/pushes.
