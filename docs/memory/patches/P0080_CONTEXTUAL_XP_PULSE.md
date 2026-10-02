# P0080 — Contextual XP Pulse

Date: 2026-10-02
Result: PREPARED — RUNTIME + VISUAL PROOF PENDING

## Baseline

P0079 verified pushed:
`1aad7bad305865ff0fddab61b94b919371499c9c`

## Runtime

`0.0.30-dev -> 0.0.31-dev`

## Purpose

Close F.2 from its resolved capability matrix and implement F.3's first
production quest-experience presentation slice.

## Production behavior

Adds `Logres/Quest/XP.lua`.

On a safe positive XP gain:
- compute delta from a safe baseline;
- show `+N XP · progress%`;
- auto-hide after approximately two seconds.

Safety:
- secret-check before inspection/arithmetic;
- level/range changes rebaseline;
- non-positive deltas do not fabricate gain;
- invalid/secret/unavailable input fails open;
- Immersion OFF suppresses presentation.

## Diagnostics

Adds:
- XP Check;
- XP Preview.

Run All now includes XP Check.

## Non-scope

No:
- permanent XP bar;
- stock XP suppression;
- quest/objective tracker suppression;
- quest compass marker;
- quest interaction automation.

## Runtime next

Deploy `0.0.31-dev`.

Validate:
- XP Check;
- XP Preview;
- one real XP gain;
- Immersion OFF/ON preview behavior;
- Run All;
- no Lua/taint/secret errors;
- stock quest/XP UI unchanged.
