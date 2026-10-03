# Future — Aura / Status Presentation Domain

Status: DEFERRED DESIGN DOMAIN
Opened: 2026-10-01

## Observation

After selective Player and Target replacement:
- player buffs/status remain visible;
- target buffs/debuffs/status remain visible.

This is intentional with current capability boundaries.

## Why separate domain

Aura/status presentation is not equivalent to unit-frame health/name
replacement.

It needs its own information policy:
- which player buffs are always important;
- which debuffs require immediate visibility;
- target dispellable/important auras;
- crowd-control / defensive / offensive state;
- PvP-specific emphasis;
- instance/party/raid accessibility;
- duration/count presentation;
- whether world-space cues can replace some icons;
- healer/support fallbacks.

## Suppression rule

Do not suppress stock player/target aura/status presentation until Logres has a
deliberate replacement/fallback for the information being removed.

## Placement direction — D-032

Status placement should communicate both owner and urgency:

- urgent/actionable **player debuffs**: near player resources and the central
  reaction space;
- lower-urgency **player buffs/auras**: quieter peripheral/right-side region;
- **target status**: attached to or spatially associated with the actual world
  target when safe and useful.

This direction does not yet choose exact icon filtering, duration presentation,
PvP emphasis, or healer/support fallbacks.

It remains future integration/design work, not a D.4 blocker. Revisit before
final Phase H integration/polish and capability-gate any stock suppression.
