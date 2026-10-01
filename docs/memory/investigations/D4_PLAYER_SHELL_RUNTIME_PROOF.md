# D.4 — Player Shell Runtime Proof

Status: P0053 IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Opened: 2026-10-01

## Goal

Prove the first D-026 selective unit-frame replacement.

## Runtime implementation target

Add a unit-frame replacement module that, when immersion requests it:

1. verifies the PlayerFrame selective child paths exist;
2. creates/configures a secure Logres player interaction button out of combat;
3. snapshots:
   - PlayerFrameContainer alpha;
   - PlayerFrameContentMain alpha;
   - PlayerFrame mouse state;
4. applies:
   - conventional child alpha -> 0;
   - PlayerFrame mouse -> disabled;
   - Logres secure player interaction -> active;
5. preserves direct PlayerFrame children and alternate power area;
6. restores exact stock state when immersion turns OFF.

## Secure Logres player interaction

Visible association:
anchor the secure hit surface to an existing visible Logres player/resource
affordance, not an arbitrary invisible screen region.

Secure behavior:
- unit = player;
- left click = target;
- right click = togglemenu.

## Combat

ON/OFF transition is out-of-combat only.

Combat-time requests defer until `PLAYER_REGEN_ENABLED`.

## Diagnostics

Add a Unit Frame Check / Player Shell Check reporting:
- requested/applied/pending;
- selective stock child paths found;
- child alpha;
- stock mouse state;
- secure Logres interaction readiness;
- whole PlayerFrame hidden = false;
- target suppression = false;
- party suppression = false.

## Proof

Under Immersion ON:
- conventional stock player shell disappears;
- Logres resource/health presentation remains;
- clicking the visible Logres player affordance targets self;
- right-click opens the player menu;
- old stock PlayerFrame region no longer intercepts mouse;
- applicable class/rune/totem/pet/alternate-power children remain functional.

Immersion OFF:
- restores conventional PlayerFrame shell;
- restores stock PlayerFrame mouse;
- disables/hides the Logres secure player interaction as appropriate.

Environmental child-resource paths may be deferred if unavailable naturally.

## P0053 implementation

Runtime version:
`0.0.23-dev`

Adds:
- secure player target/menu interaction over the Logres resource affordance;
- PlayerFrameContainer selective alpha suppression;
- PlayerFrameContentMain selective alpha suppression;
- stock PlayerFrame mouse removal;
- exact restoration;
- combat deferral;
- Player Frame Check diagnostics.

Target and Party remain untouched.

Runtime proof is next.
