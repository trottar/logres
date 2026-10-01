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

## Placement

This is future integration/design work, not a D.4 blocker.

It should be revisited before final Phase H integration/polish and may require a
dedicated earlier implementation item if later phases depend on aura ownership.
