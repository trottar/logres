# Active Investigations

## F.3 — Contextual XP pulse

Status:
**ACTIVE — P0080 IMPLEMENTATION PREPARED**

Canonical:
`F3_CONTEXTUAL_XP_PULSE.md`

Runtime target:
`0.0.31-dev`.

Developer-panel actions:
- **XP Check**
- **XP Preview**

No stock XP/quest UI suppression is authorized.

## Closed Phase F investigation

F.2 quest / XP runtime capability probe is CLOSED.

Canonical:
`F2_QUEST_XP_RUNTIME_CAPABILITY_PROBE.md`

## Tracked intermittent runtime failure

P0078 Restoration Check settle failure:
**OPEN — INTERMITTENT / UNREPRODUCED under P0079 targeted validation.**

Evidence:
`../evidence/P0078_RESTORATION_SETTLE_FAILURE_2026-10-02.md`

Targeted P0079 evidence:
`../evidence/P0079_RESTORATION_TARGETED_PASS_2026-10-02.md`

Do not add retries, polling, periodic reassertion, or broad hooks without a
reproducible failing subdomain.

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

## Deferred quest/navigation evidence

- populated active-objective rows remain unproven;
- quest IDs `436` and `237` have produced no usable next waypoint in tested
  states;
- quest compass marker remains unsupported.
