# G.2 — World/Combat Camera Zoom Capability

Status: ACTIVE — SOURCE REVIEW PASS; FOREVER RUNTIME PROBE PENDING
Opened: 2026-10-02

Profile evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`

Source audit:
`../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`

Phase roadmap:
`../roadmap/PHASE_G_CINEMATIC_CAMERA.md`

## Correct target behavior

World:
- if current zoom > `5`, target zoom `5`;
- otherwise leave the closer current zoom alone;
- ordinary enter transition `2.5` seconds.

World (Combat):
- if current zoom < `15`, target zoom `15`;
- otherwise leave the farther current zoom alone;
- ordinary enter transition `2.5` seconds.

These are conditional absolute targets, not deltas.

P0094's `by 5` / `by 15` wording is superseded.

## Source-resolved camera path

DynamicCam:
- computes the conditional target;
- calls `LibCamera:SetZoom(target, transitionTime, easing)`;
- stops an existing transition before replacing it.

LibCamera primary zoom:
- reads `GetCameraZoom()`;
- reads `cameraZoomSpeed`;
- drives `MoveViewOutStart()` / `MoveViewInStart()` from a frame animation;
- stops both directions on completion/interruption.

The primary path does not set a CVar.

LibCamera's temporary-CVar corrective fallback remains unaccepted and is not
part of P0095.

## Existing Logres state inputs

Use existing observed state:
- combat;
- instance/world;
- resting.

Do not create duplicate sensors.

## P0095 runtime probe

P0095 adds a manual `Camera Zoom Probe` panel action.

The probe:
- is excluded from Run All;
- has no state subscription or automatic event trigger;
- refuses while DynamicCam is loaded;
- reads camera zoom and camera zoom speed secret-safely;
- makes a small reversible movement with the `MoveView*` path;
- does not call `SetCVar`;
- records whether it began in combat.

Panel sequence:
1. click once to start;
2. wait about two seconds;
3. click again to persist the final result.

Required proof:
- PASS out of combat;
- PASS in combat;
- starting zoom restored both times;
- no Lua/taint/protected/secret errors.

## Coexistence contract

DynamicCam must be disabled for the isolated G.2 proof.

Until production Logres camera ownership exists:
- DynamicCam may be re-enabled after proof;
- Logres performs no automatic camera mutation.

## Fail-open / interruption contract

For eventual production:
- stop the previous Logres transition before starting another;
- stop movement immediately when ownership is relinquished;
- leave no temporary CVar mutation;
- do not restore pre-combat zoom merely because combat ended;
- instead, entering World applies its conditional target rule.

## Out of scope

G.2 does not implement:
- City UI fading;
- NPC interaction yaw/shoulder/UI hiding;
- Taxi UI hiding/rotation;
- Hearth/Teleport detection/rotation;
- Fishing rotation;
- Gathering rotation;
- AFK behavior;
- global target-focus/dynamic-pitch ownership;
- instance-specific camera policy.

## Success criteria

G.2 closes only after:
- source review remains accepted;
- P0095 passes out of combat;
- P0095 passes in combat;
- both runs restore the starting zoom;
- no camera/security error occurs;
- production World/Combat can be specified without adopting the unproven CVar
  fallback.

## Next action

Apply/push P0095 and run the isolated panel probe outside and inside combat.
