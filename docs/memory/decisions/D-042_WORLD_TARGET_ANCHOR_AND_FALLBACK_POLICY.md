# D-042 — World Target Anchor and Fallback Policy

Status: ACCEPTED
Date: 2026-10-05
Scope: target name/health placement and sparse reaction/danger treatment

## Decision

The intended world-attached target endpoint is conditional, not universal.

### Anchor

The only current approved candidate anchor source is an accessible Blizzard
nameplate obtained through:

`C_NamePlate.GetNamePlateForUnit("target", false)`

after runtime proof on the tested Forever client.

Logres never requests forbidden nameplates.

Logres does not:
- reparent Blizzard nameplates;
- mutate Blizzard nameplate children;
- change nameplate CVars/settings;
- poll or enumerate nameplates to manufacture an anchor.

A future production target presentation may anchor an addon-owned frame relative to
an accessible nameplate only after runtime proof.

### Fallback

The existing screen-space Logres target name/percentage surface remains the
canonical fallback.

Fallback is used whenever:
- target is absent;
- no accessible nameplate exists;
- the nameplate is forbidden/protected;
- target is behind camera;
- attachment is unavailable/deferred/failed;
- source state is secret or erroneous.

Blizzard target/nameplate UI remains available throughout proof.

### Reaction

Use runtime-proven ordinary reaction state only.

Preferred source:
`UnitReaction("player", "target")`.

`UnitCanAttack` and `UnitIsFriend` may corroborate/fallback if separately proven
ordinary.

Reaction maps only to the approved hostile / neutral / friendly presentation
semantics.

### Relative danger

Do not inspect exact enemy level/classification/difficulty.

P0139 permits only a one-sided low-danger hint from runtime-proven ordinary:

`UnitIsTrivial("target")`.

A trivial hostile may be visually de-emphasized.

A non-trivial hostile remains the ordinary/default hostile treatment. P0139 does
not authorize high-danger escalation, elite/rare/boss badges, or hidden difficulty
reconstruction.

### Target status

Target aura/status remains separately gated. World-target anchoring does not imply
target-status ownership.

## Consequence

P0140 must runtime-prove:
- `"target"` nameplate query behavior;
- accessible vs fallback states;
- behind-camera query behavior;
- safe addon-owned hidden attachment;
- ordinary reaction state;
- ordinary triviality state.

No production target relocation occurs before that proof.
