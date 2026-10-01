# D-003 — Enemy information disclosure

Status: ACCEPTED  
Date: 2026-09-30

## Decision

Default enemy presentation:
- no numeric level;
- health/power shown only in restrained percentage-oriented form where available;
- relative danger may influence subtle name color or text style;
- elite/rare classification is not proactively shown as an explicit warning.

## Rationale

The player may encounter an enemy, engage it, and only then realize from its behavior/health/damage that it is unusually formidable. That discovery is an intended part of the experience.

## Rejected

- Easy/Normal/Hard labels;
- explicit danger glyphs generated from hidden metadata;
- automatic elite/skull warning ornaments;
- conventional elite portrait borders.

## Retry/supersession condition

A role/accessibility or gameplay requirement may justify an optional mode, but changing the default requires a superseding decision.
