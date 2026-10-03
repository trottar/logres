# Roadmap Status

As of 2026-10-03.

## Active

**Phase G — Cinematic Camera**

Active work item:
**G.4 City camera ownership implementation**

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

Final validation runtime:
`0.0.42-dev` from P0102 at `20ad55ba`.

Canonical evidence:
`../evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`.

## G.4

**IMPLEMENTATION PUSHED — RUNTIME PROOF PENDING.**

P0104 source/profile review resolves:
- resting -> City;
- live combat precedence over City;
- conditional City target 5;
- ordinary 2.5-second entry;
- restore never / fresh destination evaluation;
- existing G.3 fail-open/coexistence model reused.

City UI fade, City `cameraDistanceMaxZoomFactor`, reactive zoom, startup instant
transition parity, and later DynamicCam contexts remain outside the first City
runtime slice.

P0105 is verified pushed at `69560080`, runtime `0.0.43-dev`, with City
selected from resting after live-combat precedence, conditional target 5,
City-aware diagnostics, and a dedicated static contract. Runtime acceptance
remains pending.

Canonical source evidence:
`../evidence/G4_CITY_CAMERA_SOURCE_AUDIT_2026-10-03.md`.

## Phase H queued direction

D-032 accepted the world-first integration composition. D-033 accepted parallel
World Ghost art-direction work. D-034 refines the working visual anchor to
Selective Hybrid E and establishes the canonical component inventory and
percentage-bar direction. D-035 now also defines NPC quest interaction as a
future Logres-owned experience with Blizzard fallback until each interaction
surface is proven. These remain parallel planning and do not change active Phase
G camera scope.
