# P0042 — Close C.4 and open C.5

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## Trigger

P0041 was pushed at `c020ab1`.

Runtime passed:
- manual feedback rendering;
- mouse activation;
- Logres-routed keyboard activation.

## C.4 result

**COMPLETE**

## Key routing result

Stock bindings bypass Logres local feedback.

Logres-routed bindings execute through the Logres secure button and show local
activation feedback.

This is expected architecture and becomes a C.5 requirement.

## C.5

Opened:
**Stock Action-Bar Replacement**

Initial contract:
- no global suppression;
- suppress only proven replacement domains;
- suppression implies active Logres key routing;
- restoration releases routing and restores stock surfaces;
- Bars 4–5 remain visible until Logres coverage exists.

## Code changes

None.

## Deployment

No redeploy required.
