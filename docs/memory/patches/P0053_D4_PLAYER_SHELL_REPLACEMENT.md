# P0053 — D.4 Player selective shell replacement

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Runtime

Version:
`0.0.22-dev -> 0.0.23-dev`

Adds:
- `Immersion/PlayerFrameReplacement.lua`;
- secure player target/menu interaction;
- selective stock PlayerFrame shell suppression;
- controller orchestration;
- Player Frame Check;
- static replacement contract checker.

## Stock scope

Suppress:
- PlayerFrameContainer;
- PlayerFrameContentMain;
- stock PlayerFrame mouse interaction.

Preserve:
- whole PlayerFrame parent;
- alternate power;
- direct class/rune/totem/pet children.

## Deferred

- TargetFrame suppression;
- PartyFrame suppression;
- CompactPartyFrame suppression.

## Safety

Protected transitions defer during combat.

Stock restoration occurs before removing Logres player interaction.
