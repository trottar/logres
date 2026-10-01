# C.3 Secondary / Utility Source Review — 2026-10-01

Status: SOURCE-RESOLVED
Date: 2026-10-01

## Goal

Resolve the first secondary/utility action-slot and binding domains without
guessing and without expanding into every stock action bar at once.

## Current Blizzard multi-bar slot domains

Current Blizzard action-slot documentation/source identifies persistent
multi-bar domains including:

- Action Bar 2: slots 61–72;
- Action Bar 3: slots 49–60;
- Action Bar 4: slots 25–36;
- Action Bar 5: slots 37–48;
- Action Bar 6: slots 145–156;
- Action Bar 7: slots 157–168;
- Action Bar 8: slots 169–180.

The first C.3 proof does not need all of them.

## First C.3 mapping

Use two fixed stock multi-bar domains:

### Secondary Cluster

Transport domain:
- stock Action Bar 2;
- slots `61–72`;
- Blizzard frame family `MultiBarBottomLeft`.

Binding domain:
- `MULTIACTIONBAR1BUTTON1`;
- through `MULTIACTIONBAR1BUTTON12`.

### Utility Cluster

Transport domain:
- stock Action Bar 3;
- slots `49–60`;
- Blizzard frame family `MultiBarBottomRight`.

Binding domain:
- `MULTIACTIONBAR2BUTTON1`;
- through `MULTIACTIONBAR2BUTTON12`.

Important:
"Secondary" and "Utility" are Logres presentation roles.

They do not claim Blizzard assigns semantic meaning to those stock bars.

The user remains free to choose what actions occupy those slots.

## Why fixed domains are useful

Unlike the primary action bar, these selected multi-bars are fixed slot
domains.

The first C.3 implementation therefore does not require:
- action-page remapping;
- combat-time primary-page handling;
- a new SecureStateDriver for slot changes.

This makes them a lower-risk extension of the C.2 secure execution proof.

## Binding evidence

Blizzard's longstanding binding manifest maps:
- `MULTIACTIONBAR1BUTTONx` to `MultiBarBottomLeft`;
- `MULTIACTIONBAR2BUTTONx` to `MultiBarBottomRight`.

Forever runtime still must prove:
- the commands exist as expected;
- existing user keys are discoverable through `GetBindingKey`;
- temporary override routing executes correctly.

Do not treat current/legacy FrameXML naming as sufficient runtime proof by
itself.

## Other multi-bars

Initial C.3 does not cover:
- stock Action Bar 4;
- stock Action Bar 5;
- stock Action Bars 6–8.

They remain available through Blizzard UI.

Future expansion is required before any corresponding stock surface can be
suppressed.

## Shared action-button architecture

C.2's Primary module currently combines:
- secure button construction;
- presentation widgets;
- presentation updates;
- primary paging;
- primary binding routing;
- event handling.

C.3 should extract only the low-risk common primitive first:

Shared:
- secure button creation;
- icon;
- cooldown;
- count;
- checked texture;
- hotkey label;
- usability/range presentation;
- native action-button registration helpers.

Keep Primary-specific proven orchestration in `Primary.lua` for now:
- current primary page;
- pending page refresh;
- primary Action Keys routing.

Secondary/Utility can then use the shared primitive with fixed slot ranges.

Do not rewrite all proven Primary control flow in the same patch that first
introduces new clusters.

## Geometry

Initial proof geometry:

```text
Secondary      Primary       Utility
   3 x 4         4 x 3         3 x 4
```

Candidate lower-center anchors:
- Secondary: x = -190, y = -260;
- Primary: x = 0, y = -260;
- Utility: x = 190, y = -260.

This creates a constellation rather than three horizontal bars.

Exact spacing is provisional and should be judged in runtime with Phase B HUD.

## Visibility

C.3 establishes cluster existence and secure execution.

C.4 owns context-driven world/combat/PvP/instance visibility.

C.3 may use static initial visual weighting only:
- Secondary slightly quieter than Primary;
- Utility quieter than Secondary.

Do not implement combat-time contextual hiding in C.3.

## Key-routing safety

L-011 remains authoritative.

Default:
- no new Secondary/Utility key takeover.

Developer controls should allow explicit temporary routing:
- Secondary Keys ON/OFF;
- Utility Keys ON/OFF.

The existing Primary Action Keys controls remain independent.

All routing:
- session-only;
- out-of-combat mutation;
- immediate fail-open release;
- deferred if requested during combat.

## Sources

Current Blizzard/WoW references:
- `https://warcraft.wiki.gg/wiki/Action_slot`
- `https://warcraft.wiki.gg/wiki/Action_Bar`
- `https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_ActionBar/Shared/MultiActionBars.lua`
- `https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_ActionBar/Shared/ActionButtonUtil.lua`

Historical binding-manifest confirmation:
- `https://github.com/MOUZU/Blizzard-WoW-Interface/blob/master/2.4.3/FrameXML/Bindings.xml`

The historical binding source is used only to corroborate command-to-bar
naming. Current Forever behavior must still be runtime-proven.
