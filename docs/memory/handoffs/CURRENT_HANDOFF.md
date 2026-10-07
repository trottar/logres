# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0161 `2a95909495e81104e02891fac94f19d59b1e030c` / `0.0.80-dev`.

## P0161 runtime acceptance

Observed accepted scope:
- base Camera Profile Check PASS;
- separate Run All PASS;
- Taxi target `50` reached;
- captured Taxi continuous yaw `-20` active;
- City landing return about `4.97-5.01`;
- Taxi rotate-back completed, last recorded return about `-29.43` degrees;
- City max-distance override `1` with captured original factor `4` retained;
- profile settings/rotation failures `0`;
- camera/profile secret/runtime failures `0`.

Classification:
**P0161 RUNTIME PASS FOR OBSERVED TAXI/SETTINGS/SHOULDER-OFFSET SCOPE.**

Teleport, NPC Interaction, Fishing, Gathering, and unobserved AFK behavior remain environmental deferrals.

## P0162 R1

P0162 R1 is the exact next work item and the final planned non-presentation Phase G slice.

It adapts pinned DynamicCam reactive mouse-wheel behavior with effective captured settings:
- enabled `true`;
- always-add `0.1000000000000001`;
- quick additional increment `2.5`;
- quick threshold `1.2`;
- max time `2.5` seconds;
- easing `OutQuad`.

Implementation boundaries:
- reuse P0160's source-backed transition engine;
- exact pre-ownership CameraZoom function restoration;
- non-wheel increments pass through to captured native functions;
- same-context manual zoom persists until context changes;
- no CVar ownership expansion;
- no timers/polling;
- no UI fade or stock suppression.

Candidate runtime:
`0.0.81-dev`.

Delivery note: the initial P0162 artifact refused before tracked writes because its exact-baseline guard rejected `LOGRES_DIAGNOSTICS_LATEST.lua`. R1 changes only that guard, allowing the exact diagnostics filename and known patch-delivery inventory while continuing to reject unexpected untracked files.

## Runtime gate

1. `/reload`.
2. Phase G -> Camera Profile Check.
3. Phase 0 -> Run All.
4. In place, use one slow wheel tick each way, several quick same-direction ticks, then reverse once.
5. Phase G -> Camera Profile Check; require reactive active/hooked, wheel count > 0, easing OutQuad, failures/secrets/conflicts `0`.
6. Phase G -> Camera Profile OFF; verify one normal Blizzard wheel zoom still works.
7. Phase G -> Camera Profile ON; wheel once and run Camera Profile Check again.
8. Upload diagnostics.

No Taxi/travel is required for this gate.

## Key references

- `../CURRENT.md`
- `../evidence/P0162_P0161_RUNTIME_PASS_2026-10-07.md`
- `../evidence/P0162_REACTIVE_ZOOM_SOURCE_AUDIT_2026-10-07.md`
- `../patches/P0162_REACTIVE_MOUSE_WHEEL_ZOOM.md`
- `../investigations/G6_DYNAMICCAM_PROFILE_PARITY.md`
- `../architecture/CAMERA.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
