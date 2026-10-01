# D.1 Immersion Orchestration Source Review — 2026-10-01

Status: SOURCE-RESOLVED
Date: 2026-10-01

## Goal

Determine which Blizzard surfaces Phase D can safely suppress immediately and
which surfaces require more replacement capability first.

D-017 remains authoritative:

**Do not remove a Blizzard surface while Logres would also remove required
information or controls that it has not replaced.**

## Existing Logres contracts

### Preference

D-010 keeps `immersionEnabled` separate from observed state.

The Immersion Controller consumes:
- persisted preference;
- observed state;

and derives presentation/suppression policy.

It must not add `immersionEnabled` to the State table.

### Action replacement

Phase C proves a complete replacement transaction for:
- stock Bar 2 / `MultiBarBottomLeft`;
- stock Bar 3 / `MultiBarBottomRight`.

That transaction already owns:
- stock presentation suppression;
- mouse suppression;
- matching Logres routing;
- restoration;
- combat deferral.

Phase D must call that capability rather than duplicating its internals.

## Blizzard unit-frame security

Current Blizzard source shows:

### Player

`PlayerFrame` inherits:
- `SecureUnitButtonTemplate`;
- Edit Mode player-frame behavior.

### Target

`TargetFrameTemplate` inherits:
- `SecureUnitButtonTemplate`.

`TargetFrameMixin:Update()` actively calls `Show()` / `Hide()` as target state
changes.

A one-time ordinary `TargetFrame:Hide()` is therefore not durable ownership.

### Party

`PartyMemberFrameTemplate` inherits:
- `SecureUnitButtonTemplate`.

Raid-style party frames are a separate path:
- `CompactPartyFrame`;
- its member frames inherit `CompactUnitFrameTemplate`;
- `CompactUnitFrameTemplate` inherits `SecureUnitButtonTemplate`.

Phase D must account for both normal and raid-style party presentation.

## Blizzard unit-frame controls

Current `SecureUnitButton_OnLoad()` configures secure unit frames with:

```text
*type1 = target
*type2 = menu
unit = <unit>
```

Therefore hiding Blizzard unit frames removes more than visuals.

It can remove:
- secure left-click unit targeting;
- right-click unit menu access.

Current Logres HUD target/ally presentation is ordinary non-interactive HUD
presentation and does not provide equivalent secure unit controls.

This blocks blanket Player/Target/Party suppression.

## PlayerFrame dependency finding

Full `PlayerFrame` suppression is additionally unsafe because Blizzard parents
multiple independent gameplay surfaces to `PlayerFrame`.

Current source includes:
- class power bars parented to `PlayerFrame`;
- `RuneFrame` parented to `PlayerFrame`;
- `TotemFrame` parented to `PlayerFrame`;
- `PetFrame` parented to `PlayerFrame`;
- other managed player-frame children.

Logres currently replaces:
- primary power percentage;
- player health awareness;
- pet name/health awareness.

It does **not** yet replace every class-specific resource/control represented by
those Blizzard children.

Therefore:

**Do not hide or alpha-zero the whole PlayerFrame.**

A future player-frame suppression proof must either:
1. suppress only the conventional PlayerFrame visual shell while preserving
   required child resources;
2. or first replace all required child resources.

## TargetFrame dependency finding

TargetFrame also owns more than target name/health:
- secure unit click/menu interaction;
- target aura presentation;
- target contextual presentation.

Logres currently replaces:
- target name;
- target health percent;
- target cast cue.

It does not yet replace target aura interaction/presentation.

Therefore full TargetFrame suppression is not yet capability-complete.

A later D.4 proof may selectively suppress the conventional target shell while
preserving required aura/control paths, or add equivalent Logres secure unit
interaction first.

## Party-frame dependency finding

Normal and raid-style party member frames are secure unit buttons.

They also expose party aura/debuff and other group context beyond Logres'
current compact name/health rows.

Most importantly, current Logres ally rows are not secure click-target/menu
surfaces.

Therefore full stock party-frame suppression is not yet safe.

## Quiet Mode / chat source review

Current Blizzard floating-chat source separates:
- runtime ChatFrame objects;
- their tabs;
- edit boxes;
- persisted chat-window settings.

`FloatingChatFrame_Update()` reconstructs visibility from stored chat-window
configuration.

`FCF_SetWindowAlpha()` primarily changes chat-frame texture/background alpha
and does not constitute complete message-text suppression.

Therefore Quiet Mode should not:
- change persistent chat-window shown settings;
- rewrite dock configuration;
- rewrite saved alpha merely to silence chat.

First Quiet Mode direction:
- snapshot runtime frame/tab visibility;
- hide chat frames and tabs at runtime;
- leave edit boxes/communication status alone;
- reapply hiding after chat-window update events while Quiet Mode is active;
- restore runtime presentation without changing saved chat configuration.

This satisfies:
**visual silence is separate from communication status.**

## Secure transition rule

Player/Target/Party unit buttons are protected-capable surfaces.

Any future interaction/suppression mutation touching those protected frames must
be configured/applied outside combat or use a source-proven secure mechanism.

Do not rely on ordinary combat-time Hide/Show or mouse mutation.

## D.1 result

### Safe for immediate Phase D orchestration

1. persisted `immersionEnabled` -> controller policy;
2. Phase C selective stock Bar 2–3 replacement;
3. runtime-only Quiet Mode chat/tab suppression;
4. existing Logres HUD visibility behavior.

### Not safe for immediate blanket suppression

1. full `PlayerFrame`;
2. full `TargetFrame`;
3. normal PartyFrame members;
4. CompactPartyFrame members;
5. focus;
6. MainActionBar;
7. Bars 4–5;
8. vehicle/override/form action surfaces.

## Next implementation order

### D.2
Immersion Controller runtime foundation:
- consume preference + observed state;
- automatically request Phase C selective action replacement;
- deterministic restoration when immersion is OFF;
- diagnostics;
- no new unit-frame suppression.

### D.3
Quiet Mode:
- runtime chat/tab suppression;
- no saved chat-setting mutation;
- preserve edit-box communication path;
- restoration.

### D.4
Unit-frame interaction/suppression completion:
- add/verify equivalent secure unit interactions where required;
- preserve PlayerFrame class-resource children;
- resolve target aura policy;
- account for both normal and compact party-frame paths;
- only then suppress proven stock unit-frame surfaces.

## Sources

Blizzard source mirror (`Gethe/wow-ui-source`, `live`):
- `Blizzard_UnitFrame/Mainline/PlayerFrame.xml`
- `Blizzard_UnitFrame/Mainline/TargetFrame.xml`
- `Blizzard_UnitFrame/Mainline/TargetFrame.lua`
- `Blizzard_UnitFrame/Mainline/PartyFrameTemplates.xml`
- `Blizzard_UnitFrame/Shared/PartyFrame.xml`
- `Blizzard_UnitFrame/Shared/PartyFrame.lua`
- `Blizzard_UnitFrame/Shared/CompactPartyFrame.xml`
- `Blizzard_UnitFrame/Shared/CompactRaidGroup.xml`
- `Blizzard_UnitFrame/Shared/CompactUnitFrame.xml`
- `Blizzard_UnitFrame/Mainline/ClassPowerBar.xml`
- `Blizzard_UnitFrame/Mainline/RuneFrame.xml`
- `Blizzard_UnitFrame/Mainline/TotemFrame.xml`
- `Blizzard_UnitFrame/Mainline/PetFrame.xml`
- `Blizzard_FrameXML/SecureTemplates.lua`
- `Blizzard_ChatFrameBase/Mainline/FloatingChatFrame.lua`

Warcraft Wiki:
- SecureStateDriver / RegisterAttributeDriver behavior;
- protected frame/combat-lockdown rules.

Logres:
- D-010 preference contract;
- D-017 suppression/restoration ownership;
- D-023 selective stock action replacement;
- current `HUD.lua`.
