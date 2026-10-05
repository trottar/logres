# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0145 `60244841d0ecfa35b58c7db60293145b8962b6dc`.

Current pushed/tested runtime:
`0.0.70-dev`.

P0145:
**INSTALLED / PUSHED — MANUAL-WAYPOINT SAME-MAP DISTANCE + BOUNDED DEPTH RUNTIME PASS FOR CHANGED SCOPE.**

## Active work stream

Current objective:
**P0146 — record P0145 evidence, then open P0147 class/pet/special-control source audit.**

P0145 runtime evidence proves:
- normal current-map manual waypoint distance is ordinary;
- observed populated distances: `115.8`, `45.5`, `51.7`, `116.0` yards;
- depth remained bounded at `1.050` in those samples;
- render scale remained within `0.90–1.12`;
- clearing the waypoint produced `waypoint=false`, `marker=false`, `distance=false`, `yards=nil`, `depth=1.000`, `renderScale=nil`;
- integrated `Run All` passed before the targeted clear-state capture.

P0123 remains the recorded off-tape runtime sample (`relative=115.5`,
`marker=false`). P0145 did not add a fresh off-tape diagnostic sample; do not claim
otherwise.

Quest/current-navigation destination, AreaPOI/service, and tracking-result roles
remain deferred/source-blocked. Stock minimap remains Blizzard-owned.

After this docs-only checkpoint is durable, P0147 is a source/capability audit for
class/pet/special-control territory. Preserve Blizzard direct class-resource
children, RuneFrame, TotemFrame, PetFrame, alternate power, and unsupported
possess/override/vehicle surfaces until each ownership path is proven.

World-target positive anchoring remains environmentally deferred. Camera remains
frozen, not complete.

## Key references

- `../CURRENT.md`
- `../evidence/P0146_P0145_MANUAL_WAYPOINT_DISTANCE_DEPTH_RUNTIME_PASS_2026-10-05.md`
- `../patches/P0146_RECORD_P0145_RUNTIME_RESULT.md`
- `../patches/P0145_MANUAL_WAYPOINT_DISTANCE_DEPTH.md`
- `../patches/P0123_COMPASS_VISUAL_TRANSLATION.md`
- `../investigations/FUTURE_NAVIGATION_POI_TRACKING_CAPABILITY.md`
- `../investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `../decisions/D-026_SELECTIVE_UNIT_FRAME_SUPPRESSION.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
