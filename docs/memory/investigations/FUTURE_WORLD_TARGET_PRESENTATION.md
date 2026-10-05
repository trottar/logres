# Future — World-Attached Target Presentation

Status: **OPEN — SOURCE + ANCHORING/FALLBACK AUDIT NEXT (P0139)**
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
