# F.5 — Objective / Progress Runtime Capability Proof

Status: CLOSED — RUNTIME PASS
Opened: 2026-10-02
Closed: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

Evidence:
- `../evidence/F5_OBJECTIVE_DATA_SHAPES_2026-10-02.md`
- `../evidence/F5_SAME_QUEST_TRANSITION_PASS_2026-10-02.md`

## Proven data states

### Unavailable / no active quest

Quest Probe:
`LQA objectives nil`.

### Empty objective list

Quest `436`:
`LQA objectives <empty>`.

### Populated incomplete objectives

Quest `237`:
**In Defense of the King's Lands**

Baseline:
1. Stonesplinter Skullthumper slain — `0/10`, done=false;
2. Stonesplinter Seer slain — `0/10`, done=false.

### Populated completed objective

Quest `1338`:
**Stormpike's Order**

State:
- complete=true;
- ready=true.

Objective:
1. Bring Stormpike's Request to Furen Longbeard in Stormwind —
   `1/1`, done=true.

## Same-quest transition proof

Quest `237` later reported:
1. Stonesplinter Skullthumper slain — `0/10`, done=false;
2. Stonesplinter Seer slain — `1/10`, done=false.

A subsequent probe on the same quest again reported the Seer objective at
`1/10`.

This proves:
- objective rows refresh for the same quest identity;
- the prior `0/10` row is not retained as stale state;
- fresh objective data can be passively recaptured after gameplay progress.

## Event evidence

During the same-quest transition:
- `QUEST_LOG_UPDATE` reached 50;
- `QUEST_WATCH_UPDATE` advanced from 0 to 1;
- `QUEST_PROGRESS` remained 0;
- `QUEST_COMPLETE` remained 0;
- `QUEST_TURNED_IN` remained 0.

Therefore:
- `QUEST_LOG_UPDATE` is a proven production refresh source;
- `QUEST_WATCH_UPDATE` is also runtime-observed;
- the three still-zero events remain environmental deferrals and must not be
  required by production behavior.

## Waypoint side evidence

Negative destination samples remain:
- `436`;
- `237`;
- `1338`.

Quest compass marker remains unsupported.

## Stock ownership

F.5 did not suppress or mutate:
- Blizzard Objective Tracker;
- quest log/watch interaction;
- quest accept/decline/continue/complete/reward controls;
- super-track/watch state.

## Result

**F.5 CLOSED — RUNTIME PASS.**

The passive objective source is sufficient for a narrow, fail-open contextual
objective-progress presentation.

It is not evidence for removing the stock Objective Tracker.
