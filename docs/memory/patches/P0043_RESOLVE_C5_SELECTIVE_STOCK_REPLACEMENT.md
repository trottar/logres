# P0043 — Resolve C.5 selective stock replacement

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## Trigger

P0042 pushed at `8f5326a`.

C.5 required source resolution before changing protected Blizzard action
surfaces.

## Source result

Stock Bar 2:
- `MultiBarBottomLeft`;
- `MULTIACTIONBAR1`;
- action page 6;
- slots 61–72.

Stock Bar 3:
- `MultiBarBottomRight`;
- `MULTIACTIONBAR2`;
- action page 5;
- slots 49–60.

Current Blizzard source owns their SetShown lifecycle.

MainActionBar is also reused for multiple special action states.

## D-023

First replacement proof:
- Bar 2 + Bar 3 only;
- do not Hide/alter Blizzard stock settings;
- alpha 0 + mouse disable;
- automatically enable matching Logres routing;
- exact captured-state restoration;
- OOC-only transitions;
- combat request deferral;
- session-only fail-open reset after reload.

MainActionBar and Bars 4–5 stay visible.

## Code changes

None.

## Deployment

No redeploy required.
