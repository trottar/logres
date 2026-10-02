# F.5 — Objective / Progress Runtime Capability Proof

Status: ACTIVE — DATA SHAPE PASS; SAME-QUEST TRANSITION PENDING
Opened: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

Evidence:
`../evidence/F5_OBJECTIVE_DATA_SHAPES_2026-10-02.md`

## Question

Can Forever provide stable, secret-safe objective/progress information sufficient
for a restrained Logres objective presentation without fabricating missing data
or replacing Blizzard controls prematurely?

## Proven data states

### Unavailable / no active quest

Quest Probe with no active quest reports:
`LQA objectives nil`.

This is not converted into an empty or completed state.

### Empty objective list

Prior F.2 evidence on completed quest `436` reported:
`LQA objectives <empty>`.

### Populated incomplete objectives

Quest `237`:
**In Defense of the King's Lands**

Quest state:
- complete=false;
- failed=false;
- ready=false.

Objective rows:
1. Stonesplinter Skullthumper slain — `0/10`, done=false;
2. Stonesplinter Seer slain — `0/10`, done=false.

### Populated completed objective

Quest `1338`:
**Stormpike's Order**

Quest state:
- complete=true;
- failed=false;
- ready=true.

Objective:
1. Bring Stormpike's Request to Furen Longbeard in Stormwind —
   `1/1`, done=true.

## Event evidence

During the new samples:
- `QUEST_LOG_UPDATE` advanced from 32 to 34;
- `SUPER_TRACKING_CHANGED` advanced from 9 to 11;
- `QUEST_PROGRESS` remained 0;
- `QUEST_COMPLETE` remained 0;
- `QUEST_TURNED_IN` remained 0;
- `QUEST_WATCH_UPDATE` remained 0.

The completed final state for quest `1338` is therefore observable through the
passive query path, but no same-quest progress/completion event transition was
captured.

## Stale-state status

Switching active/super-tracked identity from none -> `237` -> `1338` produced
fresh objective rows for each selected active quest.

This supports identity-based recapture.

It does not yet prove that an objective row updates from one count to another
for the same quest.

## Waypoint side evidence

Quest `1338` also returned no usable destination.

Negative destination samples are now:
- `436`;
- `237`;
- `1338`.

Quest compass marker remains unsupported.

## Remaining proof

Capture one same-quest before/after objective state during normal gameplay.

Preferred available baseline:
quest `237` at `0/10`, `0/10`.

A later Quest Probe showing the same quest ID with a changed objective count or
finished flag is sufficient to prove the required refresh behavior.

If completion/turn-in/watch-specific events remain unobserved, preserve them as
environmental deferrals rather than PASS.

## Stock ownership

Throughout F.5:
- Blizzard Objective Tracker remains stock;
- quest log/watch interaction remains Blizzard-owned;
- accept/decline/continue/complete/reward controls remain Blizzard-owned;
- no quest compass marker is added.

## Exit

F.5 may authorize a production objective/progress slice only after a same-quest
objective update is runtime-proven and shown not to retain stale prior values.
