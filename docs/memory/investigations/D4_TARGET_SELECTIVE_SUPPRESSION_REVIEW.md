# D.4 — Target Selective Suppression Review

Status: COMPLETE
Opened: 2026-10-01
Resolved: 2026-10-01

## Result

D-027 is canonical.

Target source structure supports selective replacement without blanket frame
hiding.

### Suppress
- TargetFrameContainer;
- TargetFrameContentMain;
- TargetFrameContentContextual parent alpha.

### Preserve
Using IgnoreParentAlpha:
- Auras;
- RaidTargetIcon;
- QuestIcon;
- PingIconFrame.

### Interaction
Add a secure UIParent target interaction frame aligned with the Logres target
block and controlled by RegisterUnitWatch.

Disable the stock TargetFrame mouse region only after replacement interaction
is ready.

### Leave untouched
- target-of-target;
- FocusFrame;
- boss target frames;
- Party/CompactPartyFrame.

## Next

Implement P0056 Target selective replacement runtime proof.
