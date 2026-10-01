# D-026 — Selective unit-frame suppression

Status: ACCEPTED
Date: 2026-10-01

## Decision

Phase D does not replace unit frames as monolithic objects.

Stock unit-frame suppression is capability-based and selective.

A domain may suppress only the stock presentation that Logres has actually
replaced while preserving required Blizzard child systems.

## Secure interaction requirement

A stock secure unit-button mouse region is not removed until Logres provides a
replacement secure interaction surface.

Logres unit interaction buttons use:
- `SecureUnitButtonTemplate`;
- unit attribute;
- left click target;
- right click togglemenu.

Dynamic target interaction may use `RegisterUnitWatch()` after out-of-combat
configuration.

## Player

### Supported first-pass suppression

Suppress only:
- `PlayerFrameContainer`;
- `PlayerFrameContent.PlayerFrameContentMain`.

Preserve:
- alternate power area;
- direct PlayerFrame class-resource children;
- RuneFrame;
- TotemFrame;
- PetFrame;
- unknown/unproven direct children.

Do not hide or alpha-zero the entire PlayerFrame.

### Interaction

Provide a visible Logres-associated secure `player` interaction surface first.

Then disable stock PlayerFrame mouse while selective suppression is active.

## Target

Target suppression is not part of the first D.4 runtime pass.

Before target suppression:
- provide secure target interaction;
- use secure unit existence visibility;
- preserve target auras;
- preserve raid-target marker;
- suppress disallowed high-level/classification-style metadata;
- remove stock invisible mouse region;
- prove restoration.

## Party

Party suppression remains deferred.

Reason:
- normal PartyMemberFrame is a secure unit button with additional aura/power/
  pet/group context;
- compact/raid-style party frames are a separate secure frame path;
- current Logres rows do not replace those interaction/accessibility surfaces.

Both normal and compact paths must be covered before stock party suppression.

## Atomic ownership

For any supported unit domain:

```text
Logres visible presentation
+
Logres secure unit interaction
+
selective Blizzard presentation suppression
+
stock mouse suppression
+
exact restoration
```

is one replacement capability.

If secure interaction or restoration is unavailable, do not suppress the stock
unit frame.

## Combat

Protected mutation is out-of-combat only unless a source-proven secure driver
owns it.

Combat-time preference changes defer.

## Fail-open

Failure restores/preserves Blizzard unit-frame presentation and interaction.

No unit domain is considered replaced merely because its health/name data is
available to Logres.
