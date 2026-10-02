# Active Investigations

## F.6 — Contextual objective progress pulse

Status:
**ACTIVE — RUNTIME/INTEGRATION PASS; VISUAL FAIL; P0089 REPAIR 2 RETEST PENDING**

Canonical:
`F6_CONTEXTUAL_OBJECTIVE_PROGRESS.md`

P0088 runtime/integration:
**PASS within tested scope.**

P0088 visual:
**FAIL — objective progress overlapped the lower-center action cluster.**

Real F.6 production pulse:
**UNPROVEN (`changes=0`, `pulses=0`).**

Possible post-kill Seer count freshness problem:
**OPEN / UNPROVEN**.

Use Quest Probe for actual live before/after objective state.

P0089:
- first two delivery artifacts failed static temporary-tree validation;
- neither wrote tracked target files;
- Repair 2 moves the transient presentation above addon-owned target frame;
- `520x32`;
- 6px separation;
- fallback center `y=-5`;
- visibly synthetic Preview;
- no source/event/baseline changes.

Do not add polling/retry/reassertion without live source evidence.

Stock Objective Tracker remains Blizzard-owned.

## Closed Phase F slices

F.3 contextual XP:
**CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**

F.4 additive NPC quest detail presentation:
**CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**

F.5 objective/progress capability proof:
**CLOSED — RUNTIME PASS.**

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

## Deferred quest/navigation evidence

- quest IDs `436`, `237`, and `1338` have produced no usable next waypoint;
- quest compass marker remains unsupported.
