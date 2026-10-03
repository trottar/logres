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
**P0100 PUSHED — RUNTIME PROOF PENDING.**

Current pushed runtime: `0.0.41-dev` (`31a2a7f`).
P0102 runtime target: `0.0.42-dev`.

First P0100 movement observation:
**ENVIRONMENTAL DEFERRAL — resting/City relinquish; movement not exercised.**

The same runtime screenshot reproduced a developer-panel overflow defect. P0102
organizes diagnostics by roadmap phase and leaves camera semantics unchanged.

The global TOC/Bootstrap version-sync contract remains owned by
`tools/check_addon_structure.py`; the G.3 feature checker no longer pins a
specific addon runtime.

Next camera evidence must be collected outside resting/City.

## Phase H queued direction

D-032 accepted the world-first integration composition. D-033 accepted parallel
World Ghost art-direction work. D-034 refines the working visual anchor to
Selective Hybrid E and establishes the canonical component inventory and
percentage-bar direction. These remain parallel planning and do not change
active G.3 runtime scope.
