# Active Investigations

## G.3 — Production World/Combat camera ownership

Status:
**ACTIVE — P0100 PUSHED; FIRST MOVEMENT OBSERVATION ENVIRONMENTALLY DEFERRED**

Canonical:
`G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`

P0100 is durable at `31a2a7f6`, runtime `0.0.41-dev`.

First runtime observation:
- controller reason `outside-slice:resting`;
- selected context `none`;
- ownership false;
- live combat false;
- DynamicCam false;
- camera API available;
- no secret/error result;
- no accepted World movement proof because resting intentionally relinquishes.

Classification:
**ENVIRONMENTAL DEFERRAL — EXPECTED RESTING RELINQUISH.**

Separate reproduced runtime UI defect:
- developer-panel flat action grid overflowed into diagnostics;
- P0102 introduces roadmap-phase tabs and preserves diagnostics persistence.

P0102 also removes the G.3 feature checker's stale exact-runtime pin; global
TOC/Bootstrap version synchronization remains enforced by
`tools/check_addon_structure.py`.

Required next camera evidence remains production validation outside resting/City
on the corrected panel runtime.

## Closed Phase G investigations

G.1 DynamicCam profile capture:
**CLOSED — PASS.**

G.2 World/Combat camera zoom capability:
**CLOSED — RUNTIME + INTEGRATION PASS.**

Canonical G.2 record:
`G2_WORLD_COMBAT_CAMERA_CAPABILITY.md`

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`
