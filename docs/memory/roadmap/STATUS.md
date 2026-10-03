# Roadmap Status

As of 2026-10-03.

## Active

**Phase G — Cinematic Camera**

Active work item:
**G.5 Taxi camera ownership contract review**

State:
**Phase F COMPLETE; Phase G ACTIVE — G.5**

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
| G — Cinematic Camera | ACTIVE — G.5 |
| H — Integration and Polish | QUEUED |

## G.2

Classification:
**CLOSED — RUNTIME + INTEGRATION PASS.**

## G.3

Production World/Combat ownership:
**CLOSED — RUNTIME + INTEGRATION PASS.**

Final validation runtime:
`0.0.42-dev`.

## G.4

City/resting camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS.**

Implementation:
P0105 at `69560080`, runtime `0.0.43-dev`.

Accepted runtime evidence proves automatic City selection, City >5 target-5
movement, City <=5 no-op, fresh destination evaluation on exit, Run All, and
DynamicCam coexistence with clean addon-owned failure/secret/error state.

Canonical evidence:
`../evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`.

Natural combat + resting overlap remains an environmental deferral.

## G.5

**ACTIVE — TAXI CONTRACT REVIEW; NO RUNTIME CODE YET.**

Captured profile starting point:
- Taxi `160`;
- priority `1000`;
- enter/exit `5`;
- conditional-out target `50`;
- rotation speed `-20`;
- UI hide/fade stored;
- restore `never`.

The current Taxi fail-open exclusion remains until source/profile review resolves
precedence, transition semantics, target capability/CVar boundaries, rotation
scope, presentation scope, coexistence, and the smallest runtime slice.

## Phase H queued direction

D-032 accepted the world-first integration composition. D-033 accepted parallel
World Ghost art-direction work. D-034 refines the working visual anchor to
Selective Hybrid E and establishes the canonical component inventory and
percentage-bar direction. D-035 defines NPC quest interaction as a future
Logres-owned experience with Blizzard fallback until each interaction surface is
proven. These remain parallel planning and do not change active Phase G camera
scope.
