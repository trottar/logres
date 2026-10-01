# P0052 — Resolve D.4 selective unit frames

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## Baseline

P0051 verified pushed at `d25430f`.

Runtime remains:
`0.0.22-dev`

## Source result

D-026 accepted.

### Player

First supported selective suppression target.

Suppress only:
- PlayerFrameContainer;
- PlayerFrameContentMain.

Preserve:
- alternate power;
- class resources;
- runes;
- totems;
- pet/direct children.

Add secure Logres player interaction before disabling stock mouse.

### Target

Deferred from first runtime pass.

Needs secure target interaction plus aura/raid-marker preservation and
contextual metadata filtering.

### Party

Deferred.

Needs normal + compact secure paths plus aura/group-context policy.

## Next

Runtime implementation:
Player secure interaction + selective PlayerFrame shell suppression.

## Code changes

None.

## Deployment

No redeploy required.
