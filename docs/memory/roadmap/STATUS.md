# Roadmap Status

As of 2026-10-02.

## Active

**Phase G — Cinematic Camera**

Active work item:
**G.2 World/Combat camera zoom capability**

State:
**Phase F COMPLETE; Phase G ACTIVE — G.2**

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
| G — Cinematic Camera | ACTIVE — G.2 |
| H — Integration and Polish | QUEUED |

## G.2

Source semantics:
**PASS.**

Primary camera path out of combat:
**PASS.**

Combat classification:
**P0095 DEFECT — cached state used instead of DynamicCam predicate.**

P0096:
- live UnitAffectingCombat classification;
- live InCombatLockdown diagnostic;
- cached State.combat diagnostic;
- no core state-engine change;
- in-combat retest pending.


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

This does not change active G.2 scope.
