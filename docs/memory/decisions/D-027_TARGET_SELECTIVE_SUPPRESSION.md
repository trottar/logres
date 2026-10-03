# D-027 — Target selective suppression

Status: ACCEPTED
Date: 2026-10-01

## Decision

The global Blizzard TargetFrame may be selectively replaced only as an atomic
combination of:
- Logres sparse target presentation;
- secure Logres target interaction;
- conventional stock shell/main suppression;
- contextual metadata filtering;
- preservation of useful stock context not yet replaced;
- stock mouse removal;
- exact restoration.

Do not hide or alpha-zero the whole TargetFrame.

## Suppress

Set runtime alpha 0 on:
- `TargetFrame.TargetFrameContainer`;
- `TargetFrame.TargetFrameContent.TargetFrameContentMain`;
- `TargetFrame.TargetFrameContent.TargetFrameContentContextual`.

## Preserve through IgnoreParentAlpha

Snapshot and set `IgnoreParentAlpha=true` on:
- `Auras`;
- `RaidTargetIcon`;
- `QuestIcon`;
- `PingIconFrame`.

Restore each exact prior value on OFF.

## Information policy

This hides:
- exact level;
- high-level/difficulty cue;
- rarity/elite/boss classification shell/icon;
- numerical threat;
- PvP prestige/icon metadata;
- leader/guide and battle-pet HUD metadata;
- conventional portrait/health/power frame.

It preserves:
- target auras;
- raid target marker;
- quest-target icon;
- unit ping signal.

## Secure Logres target interaction

Create a UIParent secure unit button aligned with the Logres target block:

```text
260 x 54
CENTER, 0, -54
unit=target
*type1=target
*type2=togglemenu
AnyUp
```

Use `RegisterUnitWatch()` while active.

## Stock interaction

After Logres secure interaction is ready:
- disable stock TargetFrame mouse;
- disable stock click/motion interaction where available.

Do not disable preserved aura child interaction.

## Exclusions

Do not suppress:
- target-of-target;
- FocusFrame;
- boss target frames;
- PartyFrame;
- CompactPartyFrame.

## Combat

Protected setup/mutation is out-of-combat only.

Combat-time desired-state changes defer until combat ends.

Secure unit watch owns target-existence visibility after configuration.

## Restoration

Restore exact captured:
- container alpha;
- main alpha;
- contextual alpha;
- stock mouse/click/motion state;
- preserved child IgnoreParentAlpha state.

Then unregister/disable the Logres target interaction.

Stock restoration occurs before removal of the replacement interaction path.

## Fail-open

Any missing child path, secure registration failure, or suppression failure
leaves/restores the stock TargetFrame and reports diagnostic failure.

No blanket TargetFrame Hide/Show fallback is allowed.

## P0056 implementation binding

P0056 binds D-027 to `Immersion/TargetFrameReplacement.lua`.

ImmersionController owns desired state.

TargetFrameReplacement owns secure target interaction, unit-watch registration,
selective presentation snapshots, contextual child preservation, stock mouse
suppression, combat deferral, and exact restoration.

Target-of-target, Focus, boss targets, and Party remain outside ownership.

## Secret-safe restoration refinement

Some TargetFrame presentation getters are secret-capable under addon execution.

Exact restoration values may be captured and transported opaquely to their
native setters, but Logres must not inspect those values in Lua.

D-027 diagnostics therefore prove replacement through:
- structure;
- Logres-owned mutation state;
- runtime visual/interaction evidence;

not protected readback.

## Runtime follow-up

P0057 runtime passed.

One unreproduced stock TargetFrame reappearance remains tracked separately.

This does not change D-027 suppression semantics.

Do not add periodic TargetFrame forcing without evidence of the reassertion
path.

## P0084 secret-setter refinement — accepted 2026-10-02

P0083 runtime evidence invalidated the original IgnoreParentAlpha restoration
mechanism.

Observed:
- `IsIgnoringParentAlpha()` yielded a secret-capable restoration token;
- Logres did not inspect that token;
- Forever still rejected it when passed to `SetIgnoreParentAlpha` outside
  untainted execution.

The IgnoreParentAlpha snapshot/restore technique is therefore superseded.

Preserve without mutation:
- `Auras`;
- `RaidTargetIcon`;
- `QuestIcon`;
- `PingIconFrame`.

Suppress by exact alpha snapshot/restoration:
- `HighLevelTexture`;
- `LeaderIcon`;
- `GuideIcon`;
- `BossIcon`;
- `PvpIcon`;
- `PrestigePortrait`;
- `PrestigeBadge`;
- `PetBattleIcon`;
- `NumericalThreat`.

Do not alpha-zero the contextual parent.

Captured alpha values remain opaque restoration tokens and are never inspected.

Stock restoration still occurs before Logres secure interaction is removed.


## Phase H+ target direction — D-032

D-027 remains the accepted implementation/fallback contract for the current
sparse detached target presentation.

The desired default endpoint is now world-attached target presentation: show
relevant target information through or near the actual creature/player in the
world whenever capability permits.

Therefore the detached Logres target block should become optional/fallback
rather than the default final presentation.

This future direction does not authorize removing the current target block,
secure target interaction, or preserved Blizzard information. Those remain
until world-attached presentation deliberately replaces every required
information/control surface with a safe fallback.
