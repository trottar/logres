# Roadmap Status

As of 2026-10-02.

## Active

**Phase G — Cinematic Camera**

Active work item:
**G.3 Production World/Combat camera ownership**

State:
**Phase F COMPLETE; Phase G ACTIVE — G.3**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | COMPLETE |
| A — Core State Engine | COMPLETE |
| B — Core HUD | COMPLETE |
| C — Action Interface | COMPLETE |
| D — Immersion Controller | COMPLETE |
| E — Compass and Navigation | COMPLETE |
| F — Quest Experience | COMPLETE |
| G — Cinematic Camera | ACTIVE — G.3 |
| H — Integration and Polish | QUEUED |

## G.2

Source semantics: **PASS.**

Primary camera path out of combat: **PASS.**

Primary camera path in live DynamicCam-equivalent combat: **PASS.**

Integration on `0.0.40-dev`: **PASS.**

Classification: **CLOSED — RUNTIME + INTEGRATION PASS.**

## G.3

Production World/Combat ownership:
**P0100 IMPLEMENTATION PREPARED — RUNTIME PROOF PENDING.**

Runtime target: `0.0.41-dev`.

P0100 uses the proven primary camera path, live combat predicate, targeted
combat-event reevaluation, zoom restore `never`, explicit fail-open stopping,
and a DynamicCam coexistence gate. It does not adopt the temporary-CVar
fallback or redesign core combat state.

## Phase H queued direction

D-032 accepted the world-first integration composition. D-033 accepted parallel
World Ghost art-direction work. These remain parallel planning and do not change
active G.3 runtime scope.
