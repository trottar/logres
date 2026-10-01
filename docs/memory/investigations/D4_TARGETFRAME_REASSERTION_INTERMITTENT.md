# D.4 — Intermittent TargetFrame Reappearance

Status: OPEN — UNREPRODUCED
Opened: 2026-10-01

## Observation

Stock TargetFrame visuals returned once while Immersion Mode was active.

`/reload` restored expected Logres suppression.

The user could not reproduce the issue.

## Current classification

Non-blocking intermittent defect.

Do not treat as resolved.

Do not add periodic suppression loops or broad Blizzard hooks without a
repeatable trigger.

## Evidence to capture on recurrence

Before reloading:
1. run Target Frame Check;
2. run Immersion Check;
3. note combat state;
4. note PvP flag state;
5. note world vs instance context;
6. note the immediately preceding action/event;
7. test Immersion OFF -> ON once if safe;
8. record whether the frame disappears without reload.

Useful preceding events include:
- target change;
- target death/clear/reacquire;
- combat enter/leave;
- PvP flag transition;
- zone transition;
- instance transition;
- opening/closing unit menus;
- Blizzard UI/edit-mode update;
- addon/module enable/disable.

## Hypotheses

Unproven possibilities:
- Blizzard TargetFrame update path reasserted alpha/presentation;
- target-context refresh rebuilt or rewrote a child state;
- controller did not receive a state/preference event because desired policy did
  not change.

No hypothesis is currently preferred strongly enough to justify a code change.

## Exit

Close only after:
- reproducible trigger is identified and fixed; or
- later architecture removes the relevant Blizzard-owned path and long-term
  runtime evidence shows the issue no longer applies.
