# Active Investigations

## F.2 — Quest / XP runtime capability probe

Status:
**ACTIVE — CAPABILITY EVIDENCE CAPTURED; BLOCKED BY RESTORATION FAILURE**

Canonical:
`F2_QUEST_XP_RUNTIME_CAPABILITY_PROBE.md`

Runtime evidence:
`../evidence/F2_P0078_QUEST_XP_RUNTIME_EVIDENCE_2026-10-02.md`

Capability results:
- contextual XP source/event path proven;
- quest-detail passive reads proven;
- populated objective rows unproven;
- quest destination for tested quest 436 unavailable.

No stock quest/objective/XP suppression is authorized.

## P0078 restoration settle failure

Status:
**OPEN — REPRODUCED ONCE / SUBDOMAIN UNKNOWN**

Evidence:
`../evidence/P0078_RESTORATION_SETTLE_FAILURE_2026-10-02.md`

P0079 adds diagnostic detail only; no behavior workaround.

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

Do not conflate the P0078 Restoration Check failure with the TargetFrame
reappearance without evidence.

## Deferred navigation evidence

- `SUPER_TRACKING_PATH_UPDATED` registered but did not fire in tested E.3 runs.
- quest IDs `436` and `237` have produced no usable next waypoint in tested
  states.
- quest waypoint presentation remains unsupported.
