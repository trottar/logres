# P0139 World-Attached Target Source + Anchoring/Fallback Audit — 2026-10-05

Status: **SOURCE + FALLBACK POLICY RESOLVED — READ-ONLY RUNTIME PROBE NEXT**
Logres baseline: `6392b2e447f710e84d6add4ef46b972afc95bf4c`
Runtime: unchanged at `0.0.67-dev`

## Scope

P0139 is source/policy evidence only.

It does not:
- move the production target frame;
- attach Logres presentation to a Blizzard nameplate;
- hide or alter Blizzard target/nameplate UI;
- change target interaction;
- add target aura/status presentation;
- inspect enemy level/classification/difficulty;
- change nameplate CVars;
- change Camera behavior.

## Source pin

The upstream source used for this audit remains the exact tested Forever
generation:

- repository: `Gethe/wow-ui-source`;
- branch: `forever`;
- commit: `e3ecc27b64d30fdc735a3f6579b866858f9f9df1`;
- client: `1.60.1`;
- build: `70205`.

Primary files reviewed:

- `Interface/AddOns/Blizzard_APIDocumentationGenerated/NamePlateDocumentation.lua`;
- `Interface/AddOns/Blizzard_APIDocumentationGenerated/NamePlateManagerDocumentation.lua`;
- `Interface/AddOns/Blizzard_NamePlates/Blizzard_NamePlates.lua`;
- `Interface/AddOns/Blizzard_APIDocumentationGenerated/UnitDocumentation.lua`.

## Candidate world/UI anchor

Forever exposes:

`C_NamePlate.GetNamePlateForUnit(unitToken, includeForbidden)`.

The generated API contract:
- takes `UnitTokenNamePlate`;
- defaults `includeForbidden` to `false`;
- marks secret arguments as allowed only when untainted;
- returns a `NamePlateFrame`.

Blizzard's own `NamePlateDriverMixin:GetNamePlateForUnit` calls
`C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure())` and explicitly
handles a nil result.

Therefore nameplate availability is conditional, not guaranteed.

For Logres, the only acceptable candidate is:

`C_NamePlate.GetNamePlateForUnit("target", false)`

behind `pcall`, with runtime proof still required that the tested Forever client
accepts the current-target token on this path.

Logres must never request `includeForbidden=true`.

## Forbidden/protected boundary

Forever separately exposes `FORBIDDEN_NAME_PLATE_*` events and the public API's
`includeForbidden` flag.

That is sufficient source evidence to establish the policy boundary:

- forbidden/protected nameplates are not Logres anchors;
- no `NamePlateDriverFrame` internals are required;
- no Blizzard nameplate child frame is reparented or mutated;
- no Blizzard nameplate hit-test, simplified-state, size, or CVar mutation is
  authorized.

An absent accessible nameplate is a normal fallback state, not a failure.

## Event model

The exact Forever nameplate manager documents synchronous events:

- `NAME_PLATE_UNIT_ADDED`;
- `NAME_PLATE_UNIT_REMOVED`;
- `NAME_PLATE_UNIT_BEHIND_CAMERA_CHANGED`;
- forbidden equivalents for creation/add/remove.

Blizzard's nameplate driver also reacts to `PLAYER_TARGET_CHANGED`.

The target-anchor runtime should therefore be event-driven.

For the first Logres probe, nameplate event payloads are not needed to correlate a
specific plate. Any relevant event may simply invalidate the current snapshot and
cause a fresh direct query for `"target"`.

No polling, frame enumeration, or `UnitIsUnit(nameplateN, "target")` scan is
required.

## Behind-camera state

Forever exposes:

`C_NamePlateManager.IsNamePlateUnitBehindCamera(unitToken)`.

It returns a boolean and has no source-level conditional-secret return marker.

Policy:
- query it only after the target nameplate source itself is available;
- wrap it and secret-check the result before branching;
- a behind-camera target is not a world-anchor presentation opportunity;
- fall back immediately to the existing screen-space target surface.

## On-screen / no-nameplate / off-screen behavior

The source does not provide a universal direct 3D world-coordinate API for this
target presentation slice.

The nameplate frame is therefore a **conditional Blizzard-managed world/UI
proxy**, not a promise of raw world coordinates.

Expected fallback states include:
- target has no nameplate;
- user nameplate settings do not expose one;
- target is out of nameplate range;
- target plate is forbidden/protected;
- target is behind the camera;
- target is lost.

Logres must not change nameplate CVars to create an anchor.

If Blizzard stacks/clamps/repositions an accessible nameplate, a future Logres
world-target presentation should inherit that Blizzard anchor behavior rather
than fabricate a separate 3D projection.

## Attachment policy

P0139 does not statically declare attachment mutation runtime-safe merely because a
frame source exists.

The next probe should test only an **addon-owned hidden anchor proxy**:

- parent remains addon-owned / `UIParent`;
- `SetPoint` may reference an accessible returned nameplate frame;
- immediately clear the point after the diagnostic;
- do not reparent or mutate the Blizzard frame;
- do not show the diagnostic proxy;
- do not perform the attachment test during combat lockdown.

This will establish whether the accessible frame can safely serve as an anchor on
the tested client.

Production attachment remains unapproved until that runtime proof passes.

## Reaction source

Forever source exposes ordinary-looking reaction APIs including:

- `UnitReaction(unit, target)`;
- `UnitCanAttack(unit, target)`;
- `UnitIsFriend(unit, target)`.

Their generated definitions have no conditional-secret return marker.

These are appropriate candidates for D-039's reaction semantics:
- hostile;
- neutral;
- friendly.

The runtime probe must still use `pcall`, secret-check every result before
comparison, and fail open on errors/secret state.

`UnitReaction("player", "target")` is the preferred primary source if it proves
ordinary; `UnitCanAttack` / `UnitIsFriend` are diagnostic corroboration/fallback
candidates, not a reason to invent new categories.

## Relative-danger source

P0139 intentionally rejects exact or classification-like enemy inspection.

Do not use:
- `UnitLevel`;
- `UnitClassification`;
- `UnitIsBossMob`;
- `UnitSelectionType`;
- `UnitSelectionColor`;
- exact health totals/stats;
- threat values as a proxy for enemy danger.

`UnitThreatSituation` is also explicitly secret-capable when threat state is
restricted and represents aggro state, not inherent relative danger.

Forever does expose:

`UnitIsTrivial("target") -> bool`.

Its generated definition has no conditional-secret return marker and does not
require reading exact level/classification/difficulty values.

Decision:
- if runtime-proven ordinary, `UnitIsTrivial` may support a **one-sided low-danger
  de-emphasis** for hostile targets;
- absence of triviality means ordinary/default hostile treatment only;
- no stronger/high-danger escalation is authorized from P0139.

This satisfies the sparse policy without reconstructing hidden exact mechanics.

## Existing Logres fallback

Current Logres already owns a screen-space target presentation:
- sparse target name;
- secret-safe target health percentage;
- accepted shared percentage bar.

That surface remains the canonical fallback.

Future target anchoring must be capability-gated per snapshot:

**accessible anchor + ordinary behind-camera=false + successful addon-owned
attachment proof -> world-attached candidate**

otherwise:

**existing screen-space Logres target fallback**

Blizzard target/nameplate surfaces remain available throughout proof.

## Target status remains separate

P0136 did not observe populated target aura data.

Therefore P0139 does not bundle target status onto the world anchor.

World-target name/health anchoring and target aura/status ownership remain separate
capability gates.

## P0140 runtime probe contract

Next:
**P0140 — read-only world-target anchor/reaction runtime probe.**

The probe should:
- preserve current production target presentation unchanged;
- register `PLAYER_TARGET_CHANGED`,
  `NAME_PLATE_UNIT_ADDED`,
  `NAME_PLATE_UNIT_REMOVED`,
  `NAME_PLATE_UNIT_BEHIND_CAMERA_CHANGED`,
  and entering-world invalidation;
- ignore event payloads and re-query `"target"` directly;
- call `C_NamePlate.GetNamePlateForUnit("target", false)` behind `pcall`;
- secret-check the returned value before inspection;
- never request forbidden plates;
- query behind-camera state only when an accessible plate exists;
- outside combat only, test a hidden addon-owned proxy `SetPoint` relative to the
  accessible plate, then immediately detach;
- read `UnitReaction`, `UnitCanAttack`, `UnitIsFriend`, and `UnitIsTrivial` through
  secret-first wrappers;
- record only addon-owned booleans/categories and error strings;
- never inspect level/classification/difficulty/selection/threat data;
- never hide/reparent/mutate Blizzard target/nameplate frames;
- never poll.

Environmental lack of a nameplate is **DEFERRED / fallback-observed**, not FAIL.

A Lua/secret/protected-action error, forbidden-frame access, or mutation of
Blizzard presentation is FAIL.

## Classification

**SOURCE + FALLBACK POLICY LAYER RESOLVED.**

A conditional accessible nameplate is the only approved world-anchor candidate.

Reaction source is source-level available.

Relative-danger source is deliberately limited to runtime-proven `UnitIsTrivial`
low-danger de-emphasis.

P0140 runtime evidence is required before any production target relocation.
