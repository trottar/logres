# P0056 — D.4 Target selective replacement

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Runtime

Version:
`0.0.23-dev -> 0.0.24-dev`

Adds:
- `Immersion/TargetFrameReplacement.lua`;
- secure unit-watched target interaction;
- selective stock TargetFrame suppression;
- contextual child preservation;
- controller orchestration;
- Target Frame Check;
- static Target replacement contract checker.

Suppress:
- TargetFrameContainer;
- TargetFrameContentMain;
- TargetFrameContentContextual parent alpha;
- stock TargetFrame mouse interaction.

Preserve:
- Auras;
- RaidTargetIcon;
- QuestIcon;
- PingIconFrame.

Excluded:
- whole TargetFrame hide;
- target-of-target;
- FocusFrame;
- boss targets;
- Party/CompactPartyFrame.

Protected transitions defer during combat.
