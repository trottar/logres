# Future — World-Attached Target Presentation

Status: **OPEN — P0140 PREPARED; IN-CLIENT RUNTIME PROOF PENDING**
Opened: 2026-10-05

## Product direction

D-039 approves the target/enemy visual direction:
- unit name;
- shared percentage-health bar;
- reaction color;
- restrained relative-danger treatment;
- no exact enemy level/classification/difficulty badge.

The intended Phase-H endpoint is target information spatially associated with the
actual world target when safe and useful.

## Current runtime baseline

Logres already owns:
- sparse current-target name;
- secret-safe target health percentage;
- accepted shared percentage-bar primitive.

The current target presentation remains screen-space / addon-owned fallback.

Blizzard target interaction and information surfaces remain available according to
the existing selective replacement/fail-open contracts.

## Capability questions

P0139 must audit, before any production anchor change:

1. whether Forever exposes a safe, supported current-target world/UI anchor that
   addon presentation can follow without protected/secret inspection;
2. whether that anchor remains stable through target changes, target loss,
   nameplate creation/removal, combat, and off-screen state;
3. whether a target nameplate is a sufficient source or only a conditional
   opportunity;
4. what happens when the current target has no usable world-attached anchor;
5. which fallback must remain in those cases;
6. whether reaction / relative-danger inputs are ordinary and safe enough for the
   approved sparse policy;
7. whether target status should remain separately gated until populated aura
   evidence exists;
8. whether combat lockdown or protected-frame ownership constrains attachment or
   interaction.

## Safety / ownership boundary

P0139 is an audit, not suppression.

Do not:
- hide the current Logres screen-space target fallback;
- hide Blizzard target/nameplate surfaces;
- inspect secret-capable level/classification/difficulty values;
- infer relative danger from unproven secret-capable values;
- reparent or mutate protected Blizzard frames merely to obtain an anchor;
- add polling or broad hooks to chase nameplates.

Prefer capability-gated, event-driven, fail-open behavior.

## Success condition

P0139 succeeds when the repo can state:
- the safe anchor source(s), if any;
- the exact availability/failure states;
- whether reaction / relative-danger source data is usable;
- the fallback policy when no world anchor is available;
- the narrow runtime probe needed next.

Source availability alone does not authorize making world-attached target the
default.

## P0139 source / policy result

Canonical evidence:
`../evidence/P0139_WORLD_TARGET_SOURCE_ANCHOR_AUDIT_2026-10-05.md`.

Accepted decision:
`../decisions/D-042_WORLD_TARGET_ANCHOR_AND_FALLBACK_POLICY.md`.

Source generation:
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`
(`1.60.1.70205`).

Resolved:
- `C_NamePlate.GetNamePlateForUnit` is the conditional anchor-source family;
- Logres must always use `includeForbidden=false`;
- nameplate add/remove/behind-camera plus target-change events support
  event-driven invalidation;
- the existing screen-space target is the canonical fallback;
- nameplate CVars/settings are never changed to manufacture an anchor;
- Blizzard frames are never reparented/mutated to obtain one;
- reaction source candidates are `UnitReaction`, `UnitCanAttack`, and
  `UnitIsFriend`;
- relative danger is intentionally limited to `UnitIsTrivial` low-danger
  de-emphasis if runtime-proven ordinary;
- exact level/classification/difficulty, selection type/color, boss
  classification, and threat values are excluded.

Still unproven:
- `"target"` token behavior on `GetNamePlateForUnit` on the tested client;
- accessible nameplate availability in representative gameplay;
- behind-camera query behavior;
- safe addon-owned anchor relation;
- ordinary reaction/triviality runtime values.

Next:
Deploy and validate the prepared P0140 read-only runtime probe.

## P0140 implementation checkpoint

P0140 prepares `WorldTargetProbe` on candidate runtime `0.0.68-dev`.

Implementation boundary:
- event-driven only: target change, nameplate add/remove, behind-camera change,
  entering world;
- event payloads discarded; `"target"` is re-queried directly;
- `C_NamePlate.GetNamePlateForUnit("target", false)` only;
- returned source values pass through secret-first wrappers before inspection;
- behind-camera state is queried only after an ordinary accessible plate exists;
- one hidden addon-owned `UIParent` proxy tests relative `SetPoint` only outside
  combat and is immediately detached;
- reaction/triviality reads are limited to `UnitReaction`, `UnitCanAttack`,
  `UnitIsFriend`, and `UnitIsTrivial`;
- only sanitized booleans/categories/fallback state/errors are retained;
- no exact enemy level/classification/difficulty/selection/threat read;
- no nameplate enumeration/CVar changes/Blizzard-frame mutation/polling;
- current screen-space Logres target remains unchanged.

Runtime evidence remains pending. A clean no-nameplate state is a valid fallback
observation; an actual Lua/secret/protected-frame/attachment failure is not.
