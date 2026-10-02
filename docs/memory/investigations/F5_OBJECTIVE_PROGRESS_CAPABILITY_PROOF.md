# F.5 — Objective / Progress Runtime Capability Proof

Status: ACTIVE — EXISTING QUEST PROBE; RUNTIME EVIDENCE PENDING
Opened: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

## Question

Can Forever provide stable, secret-safe objective/progress information sufficient
for a restrained Logres objective presentation without fabricating missing data
or replacing Blizzard controls prematurely?

## Existing evidence

F.2 established:
- `C_QuestLog.GetQuestObjectives` is source-present;
- the tested completed quest `436` returned an empty objective table;
- quest-detail passive reads work;
- relevant quest events can be registered.

Still unproven:
- populated active-objective rows;
- meaningful progress-row transitions;
- natural `QUEST_PROGRESS`;
- natural `QUEST_COMPLETE`;
- natural `QUEST_TURNED_IN`;
- natural `QUEST_WATCH_UPDATE`.

These are environmental evidence gaps, not failures.

## Method

Use the existing **Quest Probe** in the developer panel.

No new runtime patch is required for the first F.5 evidence pass.

During normal gameplay, capture Quest Probe output when naturally available:

1. while an active quest has one or more incomplete objectives;
2. after an objective count/state changes;
3. after quest completion if encountered;
4. after turn-in if encountered.

Do not travel, repeat content, or manufacture gameplay solely to obtain these
states.

After a useful sample:
- `/reload` to flush diagnostics;
- export `LOGRES_DIAGNOSTICS_LATEST.lua`.

## Evidence rules

Do not convert:
- `nil` into empty;
- empty into complete;
- missing cache into an objective claim;
- unobserved events into PASS.

Secret-capable values must remain subject to D-031 rules before inspection,
counting, formatting, comparison, or arithmetic.

## Stock ownership

Throughout F.5:
- Blizzard Objective Tracker remains stock;
- quest log/watch interaction remains Blizzard-owned;
- accept/decline/continue/complete/reward controls remain Blizzard-owned;
- no quest compass marker is added.

## Success

F.5 may authorize a production objective/progress slice only if runtime evidence
proves enough information to distinguish:
- unavailable/not loaded;
- empty objective list;
- populated active objectives;
- completed objective state where observable;
- update behavior that does not retain stale information.

Any transition that remains unobserved is recorded as an environmental
deferral, not silently promoted to PASS.
