# P0055 — Resolve Target selective suppression

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## Baseline

P0054 verified pushed at `d971459`.

Runtime remains:
`0.0.23-dev`

## Source result

D-027 accepted.

### Suppress
- TargetFrameContainer;
- TargetFrameContentMain;
- contextual parent alpha.

### Preserve via IgnoreParentAlpha
- Auras;
- RaidTargetIcon;
- QuestIcon;
- PingIconFrame.

### Secure interaction
Add a UIParent secure target button aligned with the Logres target block:
- 260 x 54;
- center 0, -54;
- unit target;
- left target;
- right togglemenu;
- RegisterUnitWatch while active.

### Leave untouched
- target-of-target;
- FocusFrame;
- boss target frames;
- Party/CompactPartyFrame.

## Next

P0056 runtime Target selective replacement.

## Code changes

None.

## Deployment

No redeploy required.
