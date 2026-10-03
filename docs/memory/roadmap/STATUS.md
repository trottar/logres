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

Source semantics:
**PASS.**

Primary camera path out of combat:
**PASS.**

Primary camera path in live DynamicCam-equivalent combat:
**PASS.**

Integration on `0.0.40-dev`:
**PASS.**

Classification:
**CLOSED — RUNTIME + INTEGRATION PASS.**

## G.3

Production World/Combat ownership:
**ACTIVE — IMPLEMENTATION NEXT.**

The implementation uses the proven primary camera path and live combat
predicate, preserves zoom restore `never`, keeps lockdown separate, and must not
compete with DynamicCam for movement ownership.

## Phase H queued direction

D-032 accepted the world-first integration composition.

Queued direction:
- optional one-quest Active Quest context with exact hover details;
- shared transient Context region;
- fixed Primary plus supported source-bar assignment to Secondary/Utility;
- no general Logres action layout/profile editor requirement;
- class/pet/special controls remain separate domains;
- world target preferred over a detached target frame;
- urgent player debuffs central, passive buffs peripheral, target status in
  world space where safe.

Parallel art-direction / mockup work may proceed outside Lua implementation.
Current preferred working hypothesis: World Ghost.

These Phase H+ directions remain parallel planning and do not change active G.3
runtime scope.
