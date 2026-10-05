# Future — Aura / Status Presentation Domain

Status: OPEN — SOURCE + PRIORITY POLICY RESOLVED; P0136 RUNTIME PROBE NEXT
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

## P0135 audit gate

P0133 closes the current quest-offer visual/control slice, so aura/status becomes
the next exact capability-gated visual domain.

P0135 is source/policy work only.

Required outputs:
- current player/target aura read APIs and events;
- secret-capable field classification;
- safe handling contract for duration/count/caster/dispellable data;
- urgent player debuff policy;
- passive player buff policy;
- target-status policy and world-target association constraints;
- PvP/group/accessibility fallback requirements;
- explicit stock-surface retention boundary.

Do not suppress Blizzard aura/status presentation from source evidence alone.

## P0135 source / policy result

Canonical evidence:
`../evidence/P0135_AURA_STATUS_SOURCE_PRIORITY_AUDIT_2026-10-05.md`.

Accepted decision:
`../decisions/D-041_AURA_STATUS_SOURCE_AND_PRIORITY_POLICY.md`.

Source generation:
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`
(`1.60.1.70205`).

Resolved:
- `C_UnitAuras` read APIs and `UNIT_AURA` event model exist;
- aura payload reads are secret-capable when unit aura access is restricted;
- `C_Secrets.ShouldUnitAuraIndexBeSecret` / instance / slot predicates exist;
- source-defined filter vocabulary includes helpful, harmful, player, raid,
  crowd-control, big-defensive, important, and dispellable categories;
- duration/count/caster/dispellable metadata is source-available but not yet
  runtime-proven ordinary;
- private auras remain Blizzard-owned.

D-041 policy:
- urgent player harmful status near reaction/resources;
- passive helpful state peripheral;
- target actionable status eventually world-associated;
- PvP modifies emphasis but never relaxes safety;
- party/CompactPartyFrame aura/dispel surfaces remain stock;
- no stock aura/status suppression from source evidence.

Next:
P0136 read-only runtime probe.

## P0136 implementation checkpoint

P0136 adds the read-only `AuraStatusProbe` on `0.0.66-dev`.

Implementation boundary:
- player and target only;
- event-driven `UNIT_AURA`, target-change, entering-world invalidation;
- `UNIT_AURA` update payload is deliberately discarded;
- maximum six indexed candidates per semantic filter;
- per-index `C_Secrets.ShouldUnitAuraIndexBeSecret` preflight;
- no aura payload read when the predicate is secret, true, indeterminate, or
  unavailable;
- returned payload and selected fields are secret-checked before inspection;
- contextual probe is excluded from integrated Run All;
- no aura cancellation/mutation, no polling, no Blizzard aura/status suppression.

Representative source filters cover the D-041 capability priorities.

Runtime evidence is still pending. Environmental absence is DEFERRED; predicate or
query failures, Lua errors, or secret-value violations are FAIL.

## P0136 runtime result

Canonical evidence:
`../evidence/P0136_AURA_STATUS_RUNTIME_PASS_WITH_DEFERRALS_2026-10-05.md`.

Result:
**RUNTIME PROBE PASS WITH ENVIRONMENTAL DEFERRALS.**

Proven ordinary populated category:
- player `HELPFUL`;
- player `HELPFUL|PLAYER`.

Ordinary selected metadata was observed for the populated helpful aura.

Safely executed but empty:
- player harmful / crowd-control / raid-relevant;
- all tested target categories while a target was available.

Deferred:
- populated player harmful data;
- populated target aura data;
- runtime secret-skip branch.

No failures were recorded, and integrated `Run All` remained clean.

Next:
P0137 production player helpful aura presentation only, with Blizzard player aura
presentation retained as completeness fallback.
