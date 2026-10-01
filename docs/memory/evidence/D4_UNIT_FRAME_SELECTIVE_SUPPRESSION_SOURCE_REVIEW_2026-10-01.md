# D.4 Unit-Frame Selective Suppression Source Review — 2026-10-01

Status: SOURCE-RESOLVED
Date: 2026-10-01

## Goal

Resolve the smallest safe Player / Target / Party suppression boundaries.

Blanket unit-frame hiding remains rejected.

The source review asks two separate questions per domain:

1. Which conventional visuals can Logres suppress without removing required
   Blizzard child systems?
2. Which secure unit interaction must Logres replace before disabling the stock
   frame's mouse region?

## Secure interaction foundation

Current Blizzard `SecureUnitButton_OnLoad()` configures a secure unit frame
with:
- left click -> `target`;
- right click -> `menu`;
- `unit` attribute.

The secure action system also exposes the addon-usable `togglemenu` action.

Therefore Logres can provide its own secure unit interaction surface with
`SecureUnitButtonTemplate` using:
- unit attribute;
- left click target;
- right click togglemenu.

For dynamic units such as target, Blizzard's secure state driver provides
`RegisterUnitWatch()` to show/hide a protected frame from unit existence
without insecure combat-time Show/Hide.

This is the preferred interaction replacement foundation.

## PlayerFrame

### Source structure

Current PlayerFrame is itself a `SecureUnitButtonTemplate`.

Its conventional shell is split into child regions:

- `PlayerFrameContainer`
  - portrait;
  - frame textures / conventional shell.

- `PlayerFrameContent.PlayerFrameContentMain`
  - player name / level;
  - health presentation;
  - primary mana/power presentation.

Important required resources are **not all inside those conventional children**.

Current source separately exposes:
- `PlayerFrameAlternatePowerBarArea` as a sibling of
  `PlayerFrameContentMain`;
- class-power frames parented directly to `PlayerFrame`;
- `RuneFrame` parented directly to `PlayerFrame`;
- `TotemFrame` parented directly to `PlayerFrame`;
- `PetFrame` parented directly to `PlayerFrame`.

### Decision

**Player conventional shell is a supported first selective-suppression target.**

First runtime proof may suppress only:
- `PlayerFrame.PlayerFrameContainer`;
- `PlayerFrame.PlayerFrameContent.PlayerFrameContentMain`.

It must preserve:
- alternate power area;
- class-resource frames;
- rune frames;
- totem frames;
- pet frame;
- other direct PlayerFrame children not explicitly proven replaceable.

Do not alpha-zero or Hide the whole `PlayerFrame`.

### Secure interaction

Before disabling stock PlayerFrame mouse interaction, add a secure Logres
`player` interaction button aligned with a visible Logres player/resource
affordance.

That button provides:
- left-click self target;
- right-click unit menu.

Stock PlayerFrame mouse is disabled only while:
- immersion is ON;
- the Logres secure player interaction surface is ready;
- selective shell suppression is applied.

All protected mutation occurs outside combat or is deferred.

## TargetFrame

### Source structure

Current TargetFrame is a secure unit button.

Its display is split into:
- `TargetFrameContainer`;
- `TargetFrameContentMain`;
- `TargetFrameContentContextual`.

The aura container is specifically:

`TargetFrameContent.TargetFrameContentContextual.Auras`

The current contextual region also contains other metadata / indicators such as:
- high-level indicator;
- PvP icon;
- raid target icon;
- numerical threat;
- other contextual icons.

The target aura container is therefore separable in source from the main
portrait/health/power shell.

### Policy conflict

Logres intentionally does not advertise level/classification-style metadata.

Therefore simply leaving all of `TargetFrameContentContextual` visible after
suppressing the main target shell is not acceptable.

At the same time, target auras and raid-target coordination remain useful
gameplay information that Logres has not yet replaced.

### Decision

**Target blanket suppression remains blocked.**

The eventual selective target path is source-feasible, but it needs one more
target-specific capability proof before stock suppression:

1. secure Logres `target` interaction button;
2. secure unit-watch visibility;
3. preserve target auras;
4. preserve raid-target marker;
5. suppress high-level/classification-like and other disallowed stock metadata;
6. prove no invisible stock TargetFrame click zone remains;
7. exact restoration.

Do not include TargetFrame suppression in the first D.4 runtime patch.

## Party frames

### Normal party path

`PartyMemberFrameTemplate` inherits `SecureUnitButtonTemplate`.

Current normal party frames include additional gameplay presentation beyond
name/health:
- alternate power;
- aura/debuff containers;
- heal/absorb prediction;
- pet frame;
- other party context.

### Compact / raid-style party path

`CompactUnitFrameTemplate` also inherits `SecureUnitButtonTemplate`.

Compact party/raid presentation is a separate frame system and includes its
own aura/private-aura/group-context behavior.

Therefore supporting only the normal PartyFrame path would be an incomplete
stock replacement.

### Decision

**Party suppression is deferred.**

Current Logres party rows remain informational only.

Before stock party suppression:
1. add secure Logres party unit interaction;
2. define aura/debuff/role accessibility policy;
3. account for alternate power / required group context;
4. support both normal and compact party-frame modes;
5. define healer/accessibility fallback;
6. runtime-prove restoration and combat behavior.

Stock party frames remain Blizzard-owned until those conditions are met.

## Invisible stock interaction rule

Selective visual suppression must not leave an unmarked stock unit-button mouse
region behind.

For a supported domain:

```text
visible Logres unit affordance
+
secure Logres target/menu interaction
+
stock conventional visual suppression
+
stock mouse disable
+
exact restoration
```

must be treated as one capability.

This extends L-011 fail-open control replacement to unit frames.

## Combat rule

Secure unit interaction buttons and protected stock frame interactivity are
configured/mutated only out of combat.

Requests made during combat defer.

`RegisterUnitWatch()` may own dynamic target visibility once configured.

## First D.4 runtime scope

The first runtime implementation should be intentionally narrow:

### Implement
- secure Logres player interaction surface;
- selective PlayerFrame conventional-shell suppression;
- exact restoration;
- combat deferral;
- diagnostics.

### Do not implement yet
- TargetFrame suppression;
- PartyFrame suppression;
- CompactPartyFrame suppression.

Target/party remain explicit follow-up capability gates within Phase D.

## Runtime proof target

Player shell suppression succeeds when:
- conventional Blizzard player portrait/name/health/primary-power shell is
  visually absent under immersion;
- class resources / runes / totems / pet / alternate power remain available
  when applicable;
- visible Logres player affordance handles left-click target and right-click
  menu;
- old PlayerFrame area does not create an invisible click region;
- Immersion OFF restores exact stock presentation and mouse interaction;
- combat-time changes defer safely;
- no protected/taint/Lua/secret regression occurs.

Class-specific child-resource true paths may be environmentally deferred when
the current character does not expose them. Do not switch classes/specs solely
to manufacture proof.

## Sources

Current Blizzard source (`Gethe/wow-ui-source`, live snapshot):
- `Blizzard_UnitFrame/Mainline/PlayerFrame.xml`
- `Blizzard_UnitFrame/Mainline/PlayerFrame.lua`
- `Blizzard_UnitFrame/Mainline/ClassPowerBar.xml`
- `Blizzard_UnitFrame/Mainline/RuneFrame.xml`
- `Blizzard_UnitFrame/Mainline/TotemFrame.xml`
- `Blizzard_UnitFrame/Mainline/PetFrame.xml`
- `Blizzard_UnitFrame/Mainline/TargetFrame.xml`
- `Blizzard_UnitFrame/Mainline/TargetFrame.lua`
- `Blizzard_UnitFrame/Mainline/PartyFrameTemplates.xml`
- `Blizzard_UnitFrame/Shared/CompactUnitFrame.xml`
- `Blizzard_FrameXML/SecureTemplates.lua`
- `Blizzard_RestrictedAddOnEnvironment/SecureStateDriver.lua`
