# P0123 — Compass Runtime / Visual PASS — 2026-10-04

## Checkpoint

Patch:
`P0123_COMPASS_VISUAL_TRANSLATION`

Durable commit:
`1721eb4dac7bb90057de5666767f2736bc48fdc6`

Runtime:
`0.0.53-dev`

Result:
**RUNTIME + VISUAL PASS.**

## Runtime evidence

The user deployed P0123 and validated the production heading/manual-waypoint
treatment in client.

Observed diagnostics:

- `Logres 0.0.53-dev` loaded successfully.
- A real user waypoint was present with bearing `64.0`.
- With the waypoint outside the visible tape, relative bearing `115.5` correctly
  produced `marker=false`.
- Waypoint audit independently reported the same user-waypoint bearing.
- Immersion OFF/ON cycles completed without a reported error.
- After turning toward the waypoint, `compasscheck` reported:
  - heading `44.1`;
  - waypoint bearing `41.8`;
  - relative bearing `-2.3`;
  - `marker=true`;
  - overall `PASS`.

The user accepted the in-client appearance and pushed the checkpoint.

## Scope

This proves the P0123 production visual/runtime subset only:

- heading baseline / tick hierarchy;
- fixed center marker;
- manual user-waypoint production glyph;
- true-bearing placement;
- visible-tape gating / edge behavior;
- immersion hide/restore.

It does not prove or authorize:

- quest destination sources;
- local POI sources;
- tracking-result sources;
- comparable world-distance scaling;
- centered destination identity text;
- minimap suppression.

Those remain capability-gated by D-037/D-038.
