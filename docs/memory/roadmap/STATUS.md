# Roadmap Status

As of 2026-10-03.

## Active

**Phase G — Cinematic Camera**

Active work item:
**G.4 City camera ownership contract review**

State:
**Phase F COMPLETE; Phase G ACTIVE — G.4**

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
| G — Cinematic Camera | ACTIVE — G.4 |
| H — Integration and Polish | QUEUED |

## G.2

Classification:
**CLOSED — RUNTIME + INTEGRATION PASS.**

## G.3

Production World/Combat ownership:
**CLOSED — RUNTIME + INTEGRATION PASS.**

Implementation checkpoint:
P0100 at `31a2a7f`, introduced on runtime `0.0.41-dev`.

Final validation runtime:
`0.0.42-dev` from P0102 at `20ad55ba`.

Accepted evidence includes World transition/no-op, automatic live-combat
transition, combat no-op, fresh World reevaluation on combat exit, disable
interruption, Run All integration, DynamicCam coexistence block, and clean
addon-owned failure/secret/error diagnostics.

Canonical evidence:
`../evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`.

The first P0100 resting observation remains retained as expected environmental
deferral evidence rather than being rewritten as failure or success.

## G.4

**ACTIVE — City camera ownership contract review.**

Resolve exact City/resting zoom and precedence semantics from captured profile
and source before runtime implementation. DynamicCam City UI hide/fade remains a
separate presentation-policy question until explicitly accepted.

## Phase H queued direction

D-032 accepted the world-first integration composition. D-033 accepted parallel
World Ghost art-direction work. D-034 refines the working visual anchor to
Selective Hybrid E and establishes the canonical component inventory and
percentage-bar direction. These remain parallel planning and do not change
active Phase G camera scope.
