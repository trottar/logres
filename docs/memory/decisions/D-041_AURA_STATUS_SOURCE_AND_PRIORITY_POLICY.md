# D-041 — Aura / Status Source and Priority Policy

Status: ACCEPTED
Date: 2026-10-05
Scope: player/target aura-status capability preparation

## Decision

Logres treats aura/status as an urgency-ranked information domain, not as a generic
full buff/debuff clone.

### Player

- Harmful/actionable status belongs near resources and reaction space.
- Helpful/passive status stays peripheral and lower urgency.
- Harmful crowd control and player-dispellable/raid-relevant harmful status are
  the first capability priorities.
- A complete stock player aura surface remains available until Logres has proven
  replacement completeness.

### Target

- Player/pet-applied harmful status, crowd control, dispellable/stealable or
  important helpful status, and major defensives are the first target-status
  capability priorities.
- The intended production endpoint is world-target association.
- Target status replacement does not proceed before world-target anchoring and
  fallback are separately proven.

### Sources

Use current `C_UnitAuras` / `AuraUtil` semantics only behind explicit secret-first
gating.

For diagnostic enumeration:
- preflight with `C_Secrets.ShouldUnitAuraIndexBeSecret`;
- do not query secret indices;
- treat `UNIT_AURA` as invalidation, not as permission to inspect
  `UnitAuraUpdateInfo.addedAuras`;
- use source-defined filters rather than hard-coded spell lists where practical.

### Private / group state

- Private/restricted auras remain Blizzard-owned.
- Party/CompactPartyFrame aura and dispel information remains Blizzard-owned until
  a secure complete replacement exists.
- PvP changes emphasis only; it does not disable Immersion or relax safety rules.

### Accessibility

Future Logres status meaning must not depend on color alone. Exact identity/detail
may remain deliberate-inspection information where appropriate.

## Consequence

P0135 resolves the source/policy layer only.

P0136 must prove representative ordinary runtime aura data for player and target
before production visual wiring.

No Blizzard aura/status suppression is authorized by D-041.
