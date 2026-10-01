# D.4 P0053 Player Shell Implementation — 2026-10-01

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Date: 2026-10-01

## Runtime version

`0.0.23-dev`

## Scope

P0053 implements only the first D-026 supported unit-frame domain:

**Player secure interaction + selective PlayerFrame conventional-shell
suppression.**

Target and Party remain untouched.

## Stock suppression

When immersion is ON, Logres snapshots and suppresses only:

- `PlayerFrame.PlayerFrameContainer`;
- `PlayerFrame.PlayerFrameContent.PlayerFrameContentMain`.

Suppression:
- child alpha -> 0;
- stock PlayerFrame mouse interaction -> disabled.

The whole `PlayerFrame` remains shown/owned by Blizzard.

## Preserved Blizzard children

P0053 does not intentionally mutate:
- alternate power area;
- class power direct children;
- RuneFrame;
- TotemFrame;
- PetFrame;
- other unproven direct PlayerFrame children.

Their true-path visibility is class/spec/context dependent and may be
environmentally deferred.

## Secure Logres player interaction

Adds:
`LogresPlayerUnitInteraction`

Configuration:
- SecureUnitButtonTemplate;
- `unit=player`;
- left click -> target;
- right click -> togglemenu;
- AnyUp clicks.

The hit surface is aligned with the visible Logres resource percentage near the
center of the screen.

It is enabled before stock PlayerFrame mouse interaction is disabled.

## Restoration

Immersion OFF:
1. restores exact captured conventional-shell alpha;
2. restores captured PlayerFrame mouse state;
3. disables/hides the Logres player interaction surface.

Stock restoration occurs before removing Logres interaction.

## Combat

ON/OFF mutation is out-of-combat only.

Combat-time changes:
- set pending state;
- reconcile on `PLAYER_REGEN_ENABLED`.

## Fail-open

If selective suppression fails after Logres interaction is enabled:
- restore captured stock shell/mouse state;
- disable the Logres interaction;
- clear requested replacement;
- report the failure.

No whole-frame Hide/alpha-zero fallback exists.

## Diagnostics

Adds:
- `/logres playerframecheck`;
- `Player Frame Check`.

Run All includes the new check.

Immersion Check now validates Player selective replacement ownership.

## Runtime proof

Under Immersion ON:
1. version is `0.0.23-dev`;
2. conventional Blizzard player portrait/name/health/primary-power shell is
   absent;
3. Logres health/resource presentation remains;
4. click the visible Logres resource percentage -> player becomes target;
5. right-click the resource percentage -> player unit menu opens;
6. old PlayerFrame location does not intercept mouse;
7. Player Frame Check PASS;
8. Immersion Check PASS;
9. Run All PASS.

Immersion OFF:
10. stock PlayerFrame shell returns exactly;
11. stock PlayerFrame mouse interaction returns;
12. resource percentage no longer owns Logres unit interaction;
13. Player Frame Check PASS.

Combat:
14. toggle immersion during combat;
15. PlayerFrame transition defers;
16. after combat the requested state applies;
17. no protected/taint/Lua/secret error occurs.

Preserved children:
18. if class resource/rune/totem/pet/alternate-power surfaces occur naturally,
    confirm they remain available;
19. do not switch class/spec or manufacture a special state solely for proof.
