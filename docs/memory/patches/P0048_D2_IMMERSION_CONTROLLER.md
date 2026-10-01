# P0048 — D.2 Immersion Controller runtime foundation

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Runtime

Version:
`0.0.20-dev -> 0.0.21-dev`

Adds:
- `Immersion/Controller.lua`;
- `/logres immersioncheck`;
- `Immersion Check` panel action;
- D.2 static contract checker.

## Behavior

Persisted Immersion ON:
- automatically requests proven stock Bar 2–3 replacement.

Immersion OFF:
- restores that replacement.

State/preference changes:
- reconcile controller policy.

Quiet Mode:
- desired state computed only;
- no chat mutation until D.3.

Capability gates:
- Player untouched;
- Target untouched;
- Party untouched;
- Primary routing not controller-owned.

## Safety

Protected action mutation remains owned by the already-proven
StockActionReplacement module.

Combat deferral is not duplicated in the controller.
