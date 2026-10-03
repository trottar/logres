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

## Phase G

| Item | State |
| --- | --- |
| G.1 Current DynamicCam profile capture | COMPLETE — exact RPG evidence preserved |
| G.2 World/Combat camera zoom capability | ACTIVE — source PASS; runtime probe pending |
| G.3+ Production/context slices | QUEUED — evidence-driven |

## G.2 source result

Correct semantics:
- World -> conditional target 5;
- World (Combat) -> conditional target 15;
- ordinary transition 2.5 seconds;
- restore policy never.

Primary camera path:
`GetCameraZoom` + read-only `cameraZoomSpeed` + `MoveView*Start/Stop`.

P0095 adds the isolated manual runtime probe.

## Runtime proof next

With DynamicCam disabled:
- Camera Zoom Probe PASS out of combat;
- Camera Zoom Probe PASS in combat;
- starting zoom restored both times;
- no camera/security errors.

## Deferred navigation

Quest IDs `436`, `237`, and `1338` remain negative waypoint samples.

Quest compass marker remains unsupported.
