# Active Investigations

## F.4 — Additive NPC quest detail presentation

Status:
**ACTIVE — RUNTIME PATH PASS; VISUAL + INTEGRATED RETEST PENDING**

P0083 proves the real quest-detail path, accept cleanup, Immersion policy, and
Quest Dialogue Check.

Visual acceptance remains pending.

## TargetFrame restoration failure

Status:
**ROOT CAUSE IDENTIFIED — P0084 CORRECTION PREPARED**

P0083 captured the exact failure:
`SetIgnoreParentAlpha(secret-token)` is rejected outside untainted execution.

P0084 removes IgnoreParentAlpha mutation and uses selective contextual alpha
suppression/restoration instead.

No polling, retry, periodic reassertion, or broad hook.

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

## Deferred quest/navigation evidence

- populated active-objective rows remain unproven;
- quest IDs `436` and `237` have no usable next waypoint in tested states;
- quest compass marker remains unsupported.
