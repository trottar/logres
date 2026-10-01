# D.4 P0056 Target Replacement Implementation — 2026-10-01

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Date: 2026-10-01

## Runtime version

`0.0.24-dev`

## Scope

P0056 implements D-027 for the global Blizzard TargetFrame.

It does not suppress target-of-target, FocusFrame, boss target frames, or
Party/CompactPartyFrame.

## Runtime behavior

When immersion is ON, Logres snapshots and suppresses:
- TargetFrameContainer alpha;
- TargetFrameContentMain alpha;
- TargetFrameContentContextual parent alpha;
- stock TargetFrame mouse/click/motion interaction.

The whole TargetFrame remains Blizzard-owned.

Preserved through IgnoreParentAlpha:
- Auras;
- RaidTargetIcon;
- QuestIcon;
- PingIconFrame.

Adds `LogresTargetUnitInteraction`:
- SecureUnitButtonTemplate;
- UIParent;
- 260 x 54;
- CENTER 0, -54;
- unit=target;
- left target;
- right togglemenu;
- AnyUp;
- RegisterUnitWatch while active.

## Restoration and combat

Immersion OFF restores exact stock alpha/mouse/IgnoreParentAlpha state before
unregistering the Logres target interaction.

Combat-time transitions defer until PLAYER_REGEN_ENABLED.

## Diagnostics

Adds:
- `/logres targetframecheck`;
- `Target Frame Check`.

Run All and Immersion Check include Target ownership.

## Runtime proof

With Immersion ON and a target:
1. confirm `0.0.24-dev`;
2. conventional stock TargetFrame shell/metadata is absent;
3. Logres target name/health/cast presentation remains;
4. left-click Logres target block works;
5. right-click opens target menu;
6. old stock target area is not an invisible click zone;
7. target auras remain usable when naturally present;
8. Target Frame Check PASS;
9. Immersion Check PASS;
10. Run All PASS.

Immersion OFF restores stock TargetFrame.

Combat-time ON/OFF transitions defer.

Raid marker, quest icon, ping, target-of-target, and unusual aura-layout paths
may be natural-play environmental proofs.
