---
memory_schema: 1
as_of: 2026-10-07
project: logres
---

# Current State

## Active Objective

**Finish the final non-presentation DynamicCam camera-parity slice, then close Phase G with explicit environmental deferrals and enter Phase H integration/layout/polish.**

The canonical DynamicCam RPG profile is already stored in repository evidence. Do not request another export unless the profile changes.

P0161 is verified durable at `2a95909495e81104e02891fac94f19d59b1e030c` on runtime `0.0.80-dev` and is runtime-accepted for the observed Taxi/settings/shoulder-offset scope.

## Current Work Item

**P0162 R1 — source-backed DynamicCam reactive mouse-wheel zoom.**

P0162 is the final planned non-presentation Phase G slice. It adapts pinned DynamicCam `MouseZoom.lua` semantics while reusing Logres's P0160 source-backed transition engine rather than creating another camera driver.

Effective captured-profile settings are:
- reactive zoom enabled;
- always-add increment `0.1000000000000001`;
- quick-zoom additional increment `2.5`;
- quick threshold `1.2`;
- maximum zoom time `2.5` seconds;
- `OutQuad` easing from the pinned DynamicCam default.

The implementation must preserve:
- exact pre-ownership `CameraZoomIn` / `CameraZoomOut` function restoration;
- zero-increment suppression;
- non-wheel increment pass-through for P0160/LibCamera correction behavior;
- direction-change target reset;
- first-person outward escape through native `0.05` zoom;
- max-distance clamping from the live factor without changing it;
- fail-open native zoom on unreadable/secret inputs;
- same-context manual zoom persistence until the camera context actually changes.

DynamicCam UI fades remain Phase H presentation policy.

The initial P0162 delivery artifact refused before tracked writes because its exact-baseline guard rejected the standard untracked `LOGRES_DIAGNOSTICS_LATEST.lua` evidence file. R1 fixes only that delivery guard and keeps the runtime implementation unchanged.

## Verified State

P0161 runtime acceptance on `0.0.80-dev`:
- base Camera Profile Check PASS;
- separate Run All PASS;
- Taxi reached `50` with captured continuous yaw `-20`;
- profile behavior reported zero settings and rotation failures;
- after landing, City returned from `50` to about `4.97-5.01`;
- Taxi rotate-back completed; last recorded return was about `-29.43` degrees;
- City max-distance override was `1`, while the captured original factor remained `4`;
- no camera/profile secret or runtime failures were recorded.

Classification:
**P0161 RUNTIME PASS FOR OBSERVED TAXI/SETTINGS/SHOULDER-OFFSET SCOPE.**

Environmental deferrals remain:
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- Gathering;
- AFK priority behavior where not naturally observed.

These are deferrals, not failures, and do not require contrived gameplay to close Phase G.

## Next Action

Apply/deploy P0162 R1 (`0.0.81-dev`) and run the bounded reactive-zoom gate:

1. `/reload`.
2. Phase G -> **Camera Profile Check**.
3. Phase 0 -> **Run All** separately.
4. In the current ordinary world context, make one slow wheel tick in each direction, then several quick same-direction ticks and one direction reversal.
5. Confirm smooth zoom, larger quick-step accumulation, and no snap back toward a stale target after reversal.
6. Phase G -> **Camera Profile Check** again; require reactive hook active, wheel count > 0, `OutQuad`, zero reactive failures/secrets/hook conflicts.
7. Phase G -> **Camera Profile OFF**; verify one ordinary wheel zoom still works through restored Blizzard functions.
8. Phase G -> **Camera Profile ON**; wheel once, then run **Camera Profile Check** again.
9. Upload refreshed `LOGRES_DIAGNOSTICS_LATEST.lua`.

Do not require another Taxi or travel to deferred contexts for this gate.

If P0162 passes, close Phase G with the explicit environmental deferrals above and make Phase H primary.

## Success Criteria

P0162 succeeds when:
- base Camera Profile Check and separate Run All remain clean;
- reactive mouse-wheel ownership is active only while Logres owns camera context;
- one-tick and quick repeated wheel input move smoothly with the captured effective settings;
- reversing wheel direction resets the stale reactive target;
- manual reactive zoom is not immediately reasserted back to the same situation entry target;
- P0160 source-correction/non-wheel calls pass through rather than being mistaken for wheel ticks;
- Camera Profile OFF restores exact captured zoom functions when Logres still owns the hooks;
- a later external replacement is not overwritten on release;
- diagnostics show zero reactive failures, secret skips, and unexpected hook conflicts in the normal no-DynamicCam test;
- no CVar ownership expansion, timer/polling loop, UI fade, or stock-surface suppression is added;
- all static checks and `git diff --check` pass;
- no Lua, taint, protected-action, or secret-value failure occurs.

## Do Not Reopen Without New Evidence

- P0161 is accepted for observed Taxi/settings/shoulder-offset scope;
- P0160 source-backed Taxi zoom convergence is accepted;
- no conventional player health bar;
- no arbitrary/global `cameraDistanceMaxZoomFactor` ownership beyond the captured City override;
- no periodic context polling;
- no DynamicCam UI fade in Phase G;
- P0152 pet execution/state presentation remains accepted;
- stock minimap, Party/CompactPartyFrame, target aura/status, target-of-target, and unsupported class/special surfaces remain available until their replacement gates are satisfied;
- player harmful/urgent and populated target aura production remain deferred;
- positive world-target nameplate attachment remains deferred;
- individual tracking-result positions remain source-blocked by D-043;
- possess/override/vehicle/extra-action surfaces remain separate domains.

## Relevant References

- `docs/memory/evidence/P0162_P0161_RUNTIME_PASS_2026-10-07.md`
- `docs/memory/evidence/P0162_REACTIVE_ZOOM_SOURCE_AUDIT_2026-10-07.md`
- `docs/memory/patches/P0162_REACTIVE_MOUSE_WHEEL_ZOOM.md`
- `docs/memory/evidence/P0161_PROFILE_BEHAVIOR_SOURCE_AUDIT_2026-10-07.md`
- `docs/memory/evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`
- `docs/memory/investigations/G6_DYNAMICCAM_PROFILE_PARITY.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
