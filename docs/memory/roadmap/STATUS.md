# Roadmap Status

As of 2026-10-03.

## Active

**Phase G — Cinematic Camera**

Active work item:
**G.5 camera-distance product/ownership policy after default negative**

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

**CLOSED — RUNTIME + INTEGRATION PASS.**

## G.3

**CLOSED — RUNTIME + INTEGRATION PASS.**

## G.4

**CLOSED — RUNTIME + INTEGRATION PASS on `0.0.43-dev`.**

## G.5

Target 50 under current no-CVar-mutation boundary:
**CLOSED — CLEAN NEGATIVE on `0.0.44-dev`.**

Camera-distance source contract:
**RESOLVED.**

Key finding:
DynamicCam's captured Taxi target 50 does not itself raise max-distance; the
standard max-distance setting inherits the client default, which G.1 did not
persist and P0109 did not measure.

P0112 runtime `0.0.45-dev` read-only PASS:
- current factor `1.2` / ceiling `18`;
- default factor `1` / ceiling `15`;
- required factor `3.3333333333333`;
- current/default support false/false;
- account-stored=true;
- locked=false; secure=false; readOnly=false;
- secret=false; error=nil.

Therefore the inherited client/DynamicCam default cannot satisfy target 50.

Next:
resolve product/ownership policy for any temporary above-default account-scoped
max-distance mutation.

Production Taxi remains fail-open.

No CVar mutation or clamped target is authorized.

## Phase H queued direction

D-032/D-033/D-034 define the accepted world-first / Selective Hybrid E visual
direction. D-035 defines NPC quest interaction as a future Logres-owned
experience with Blizzard fallback until each replacement surface is proven.
D-036 freezes the approved health-tunnel visible-field progression. D-037 defines
the future four-role navigation/minimap endpoint while preserving D-030 until
local POI/tracking/quest and remaining minimap capabilities are runtime-proven.
D-038 defines the accepted compass focus/depth visual contract while all
source-dependent quest/POI/tracking inputs remain capability-gated. D-039 now
preserves the twelve approved visual sheets as the canonical art baseline and
moves the covered component families from broad concept exploration to asset /
runtime translation. D-040 now defines the production `Logres/Media/` token/
asset boundary; P0116 is the first action-button translation and remains
in-client visual-proof pending. See `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`.
