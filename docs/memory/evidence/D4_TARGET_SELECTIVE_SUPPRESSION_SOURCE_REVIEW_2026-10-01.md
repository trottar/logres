# D.4 Target Selective Suppression Source Review — 2026-10-01

Status: SOURCE-RESOLVED
Date: 2026-10-01

## Goal

Resolve the next D-026 capability:

**secure Logres target interaction + selective TargetFrame suppression**

without losing useful target auras, raid-marker coordination, quest context, or
the stock target-of-target surface that Logres has not replaced.

## Current Blizzard TargetFrame structure

Current source defines `TargetFrameTemplate` as a `SecureUnitButtonTemplate`.

### Conventional shell

`TargetFrame.TargetFrameContainer`

Contains portrait/frame presentation including:
- portrait;
- frame texture;
- combat flash;
- boss/elite portrait frame texture.

### Main content

`TargetFrame.TargetFrameContent.TargetFrameContentMain`

Contains:
- target name;
- level text;
- reputation/reaction color;
- health/heal/absorb presentation;
- mana/power presentation.

### Contextual content

`TargetFrame.TargetFrameContent.TargetFrameContentContextual`

Contains mixed policy domains.

Preserve:
- `Auras`;
- `RaidTargetIcon`;
- `QuestIcon`;
- `PingIconFrame`.

Suppress:
- `HighLevelTexture`;
- `LeaderIcon`;
- `GuideIcon`;
- `BossIcon`;
- `PvpIcon`;
- `PrestigePortrait`;
- `PrestigeBadge`;
- `PetBattleIcon`;
- `NumericalThreat`.

## Level/classification policy

Current TargetFrame code:
- shows exact effective level in `LevelText`;
- colors level by content difficulty;
- shows `HighLevelTexture` for unknown/high level;
- changes frame/boss visuals from `UnitClassification`;
- shows rare/boss classification visuals.

This conflicts with Logres policy:
- no exact level;
- no classification;
- no explicit difficulty.

Suppressing the container + main content removes the conventional level and
classification shell.

## Contextual-parent technique

Blizzard actively updates contextual children on target changes. Chasing every
Show/Hide/alpha mutation individually is fragile.

Selected first-pass technique:

1. snapshot `TargetFrameContentContextual` alpha;
2. set contextual parent alpha to 0;
3. snapshot `IsIgnoringParentAlpha()` on preserved children;
4. set preserved children to `SetIgnoreParentAlpha(true)`.

Preserved children continue to render while other contextual children inherit
the zero parent alpha.

This reuses an API path already runtime-proven by Logres Quiet Mode.

## Aura behavior

The Blizzard aura container remains Blizzard-owned for the first proof.

Preserve:
- aura enumeration;
- aura layout;
- aura interaction/tooltips;
- target-of-target-aware aura row sizing.

Do not re-anchor Blizzard aura children in the first pass.

## Raid target / quest / ping

Preserve:
- `RaidTargetIcon`;
- `QuestIcon`;
- `PingIconFrame`.

These are useful coordination/world signals that Logres does not yet replace.

## Target-of-target

Current TargetFrame code separately manages `totFrame` and changes aura layout
when target-of-target is visible.

Logres has no target-of-target replacement yet.

Decision:
**do not suppress target-of-target in the first target pass.**

## Secure interaction replacement

Add a separate Logres secure interaction frame aligned with the visible Logres
target block:

```text
size: 260 x 54
anchor: UIParent CENTER, 0, -54
unit: target
left click: target
right click: togglemenu
click registration: AnyUp
```

Parent it to UIParent, not the ordinary HUD frame.

## Dynamic target existence

Use `RegisterUnitWatch(interaction)` after out-of-combat configuration.

The secure state driver reads the unit attribute and owns Show/Hide as unit
existence changes.

On restoration:
- `UnregisterUnitWatch(interaction)`;
- disable mouse;
- hide the Logres interaction frame.

## Stock mouse region

After secure Logres target interaction is ready:
- disable stock TargetFrame mouse/click/motion interaction;
- leave preserved aura child interaction intact;
- do not leave an invisible stock target-button hit region.

## Snapshot

Capture:
- TargetFrameContainer alpha;
- TargetFrameContentMain alpha;
- TargetFrameContentContextual alpha;
- stock TargetFrame mouse/click/motion state;
- preserved child IgnoreParentAlpha state.

Apply:
- container alpha 0;
- main content alpha 0;
- contextual parent alpha 0;
- preserved children IgnoreParentAlpha true;
- stock TargetFrame mouse disabled;
- secure Logres target interaction enabled + unit watched.

Restore exact captured values on OFF.

## Combat / fail-open

All protected setup/mutation is out-of-combat.

Combat-time desired-state changes defer until `PLAYER_REGEN_ENABLED`.

Enable order:
1. capture stock state;
2. configure/register Logres secure target interaction;
3. verify interaction readiness;
4. suppress stock shell/context and mouse.

Failure restores stock presentation/interaction and removes the Logres secure
interaction.

No blanket TargetFrame Hide/Show fallback.

## Scope exclusions

Do not suppress:
- FocusFrame;
- boss target frames;
- target-of-target;
- PartyFrame;
- CompactPartyFrame.

## Runtime proof target

Under Immersion ON:
- stock portrait/frame/name/level/health/power shell is absent;
- no level/classification/high-level/numerical-threat metadata leaks;
- Logres target name + health percent + cast cue remain;
- Logres target block supports secure left target / right menu;
- old stock TargetFrame area is not an invisible click zone;
- target auras remain visible/usable when present;
- raid marker/quest icon/ping remain when naturally present;
- target-of-target remains Blizzard-owned;
- Immersion OFF restores exact stock presentation + interaction;
- combat transitions defer safely;
- no protected/taint/Lua/secret regression occurs.

Natural-only context paths may be environmentally deferred.

## Sources

Current Blizzard source snapshot:
- `Blizzard_UnitFrame/Mainline/TargetFrame.xml`;
- `Blizzard_UnitFrame/Mainline/TargetFrame.lua`;
- `Blizzard_FrameXML/SecureTemplates.lua`;
- `Blizzard_RestrictedAddOnEnvironment/SecureStateDriver.lua`.

Current Logres:
- `HUD/HUD.lua` target block is 260 x 54 at center 0, -54;
- D-026;
- Quiet Mode IgnoreParentAlpha runtime proof.
