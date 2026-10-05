# P0139 — World-Attached Target Source + Anchoring/Fallback Audit

Date: 2026-10-05
Result: **INSTALLED / PUSHED — SOURCE + FALLBACK POLICY RESOLVED** (`b0122136`)
Baseline: `6392b2e447f710e84d6add4ef46b972afc95bf4c`
Runtime: unchanged at `0.0.67-dev`
Durable commit: `b012213662a93b455b1ed3af2325a2bacdb2a59d`

## Purpose

Resolve the source, event, protected-frame, reaction, relative-danger, and
fallback policy before changing production target placement.

Canonical evidence:
`../evidence/P0139_WORLD_TARGET_SOURCE_ANCHOR_AUDIT_2026-10-05.md`.

Accepted decision:
`../decisions/D-042_WORLD_TARGET_ANCHOR_AND_FALLBACK_POLICY.md`.

## Source result

Candidate anchor:
`C_NamePlate.GetNamePlateForUnit("target", false)`.

Availability is conditional. Exact target-token behavior and safe addon-frame
attachment require runtime proof.

Event model:
- target change;
- nameplate add/remove;
- behind-camera change;
- entering world.

No polling or nameplate enumeration is required.

## Reaction / danger result

Reaction:
source-level available through `UnitReaction`, with
`UnitCanAttack` / `UnitIsFriend` as secondary candidates.

Relative danger:
restricted to `UnitIsTrivial` low-danger de-emphasis if runtime-proven ordinary.

No exact level/classification/difficulty, selection-color/type, boss
classification, or threat-value inference is authorized.

## Fallback

The existing screen-space Logres target remains canonical whenever no proven safe
world anchor is available.

Blizzard target/nameplate presentation remains available.

## Next

P0140 read-only runtime probe:
- current target nameplate query;
- behind-camera state;
- hidden addon-owned attachment test outside combat;
- reaction/triviality ordinary-state proof;
- no production relocation or Blizzard suppression.
