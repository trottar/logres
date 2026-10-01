# P0039 — C.4 context alpha + secure Primary paging

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Runtime

Version:
`0.0.16-dev -> 0.0.17-dev`

Adds:
- `Actions/Context.lua`;
- role alpha policy from observed state;
- Primary secure button IDs;
- normal-page `actionpage` attribute driver;
- presentation-only action registration;
- expanded Action Check;
- C.4 static contract checker.

## Context policy

No alpha-zero state.

World:
- Primary 1.00;
- Secondary 0.45;
- Utility 0.20.

PvP:
- 1.00 / 0.75 / 0.40.

Instance:
- 1.00 / 0.70 / 0.45.

Combat:
- 1.00 / 1.00 / 0.75.

## Secure paging

Normal pages 1–6 use secure `actionpage`.

Special:
- form/bonus;
- vehicle;
- override;
- possess;

remain explicitly unproven.

## Stock UI

All Blizzard action bars remain visible.

## Runtime proof

Required:
- contextual alpha;
- faded usability;
- normal page execution + presentation;
- no protected/taint/secret errors.
