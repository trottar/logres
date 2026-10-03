# Roadmap Status

As of 2026-10-02.

## Active

**Phase G — Cinematic Camera**

Active work item:
**G.1 Current DynamicCam profile capture**

State:
**Phase F COMPLETE; Phase G ACTIVE — G.1**

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
| G — Cinematic Camera | ACTIVE — G.1 |
| H — Integration and Polish | QUEUED |

## Phase F final state

| Item | State |
| --- | --- |
| F.1 Quest-experience source/capability review | COMPLETE — D-031 |
| F.2 Quest/XP runtime capability probe | COMPLETE |
| F.3 Contextual XP pulse | COMPLETE — runtime + integration + visual PASS |
| F.4 Additive NPC quest detail presentation | COMPLETE — runtime + integration + visual PASS |
| F.5 Objective / progress runtime capability proof | COMPLETE — runtime PASS |
| F.6 Contextual objective progress pulse | COMPLETE — P0092 runtime + visual PASS |
| F.7+ Additional quest work | DEFERRED — only with new accepted evidence/capability |

P0092 final:
- durable at `5f8e9e96`;
- runtime `0.0.38-dev`;
- one natural objective change -> `changes=1`, `pulses=1`;
- matching quest 237 update to Skullthumper `6/10`, Seer `4/10`;
- user visual acceptance PASS.

## Phase G

| Item | State |
| --- | --- |
| G.1 Current DynamicCam profile capture | ACTIVE — fresh export required |
| G.2+ Camera implementation slices | QUEUED — selected after G.1 evidence |

G.1 must obtain a current profile before exact camera behavior is designed.

## Deferred navigation

Quest IDs `436`, `237`, and `1338` remain negative waypoint samples.

Quest compass marker remains unsupported.
