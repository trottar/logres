# P0058 — Close D.4 and open D.5

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## Baseline

P0057 verified pushed:
`fc848b9`

Runtime:
`0.0.25-dev`

## P0057 result

PASS:
- Target Frame Check;
- Immersion Check;
- Run All;
- target selective replacement behavior.

The P0056 secret-boolean diagnostic bug is fixed.

## D.4 result

**COMPLETE for supported scope**

Proven:
- Player selective replacement;
- Target selective replacement.

Deferred:
- Party / CompactPartyFrame suppression.

## Tracked issue

One stock TargetFrame reappearance occurred and disappeared after `/reload`.

Status:
**OPEN / INTERMITTENT / UNREPRODUCED**

No speculative reassertion loop is added.

## Future domain

Player and Target aura/status presentation remains stock-owned.

A dedicated future Aura / Status Presentation design domain is recorded.

## Next

D.5:
Context / PvP / instance orchestration source/design review.

## Code changes

None.

## Deployment

No redeploy required.
