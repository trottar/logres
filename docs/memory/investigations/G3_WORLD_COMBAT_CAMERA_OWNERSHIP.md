# G.3 — Production World/Combat Camera Ownership

Status: ACTIVE — IMPLEMENTATION NEXT
Opened: 2026-10-02

G.1 profile evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`

G.2 source audit:
`../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`

G.2 runtime PASS:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`

## Objective

Replace the isolated manual G.2 capability probe with deliberate production
ownership for the narrow World / World (Combat) camera slice.

Do not broaden this checkpoint into the rest of the DynamicCam profile.

## Context contract

Use the captured profile's actual situation meanings and priority:

### World (Combat)

Active when:
- not in an instance; and
- live `UnitAffectingCombat("player")` is true.

This situation has higher priority than World.

### World

Active when:
- not resting; and
- not in an instance; and
- World (Combat) is not selected.

### Outside this slice

City/resting, instances, taxi, NPC interaction, fishing, AFK, gathering,
hearth/teleport, and other later contexts are not implemented by G.3.

When neither G.3 situation owns the camera, G.3 must stop any active movement
and relinquish ownership without inventing a new target.

## Zoom contract

World:
- read current zoom;
- if current zoom > 5, target 5;
- otherwise do not zoom out merely to reach 5.

World (Combat):
- read current zoom;
- if current zoom < 15, target 15;
- otherwise do not zoom in merely to reach 15.

Ordinary World <-> World (Combat) transition:
`2.5` seconds.

Zoom restoration policy:
`never`.

Leaving combat therefore does not restore a remembered pre-combat zoom. The
World rule is evaluated normally and conditionally targets 5 when needed.

## Signal contract

Combat selection uses live:
`UnitAffectingCombat("player")`.

Do not substitute cached:
`Logres:GetState().combat`.

P0096 runtime evidence showed the two can disagree during real combat.

`InCombatLockdown()` remains a separate restriction/protection signal. It may
inform whether a particular operation is legal, but it does not define the
World (Combat) situation.

## Movement contract

Use the runtime-proven primary path:
- `GetCameraZoom()`;
- read-only `cameraZoomSpeed`;
- `MoveViewOutStart()` / `MoveViewOutStop()`;
- `MoveViewInStart()` / `MoveViewInStop()`;
- frame-based animation only while a transition is active.

Do not adopt the unproven LibCamera corrective fallback:
- no temporary `SetCVar("cameraZoomSpeed", ...)`;
- no `CameraZoomIn()` / `CameraZoomOut()` fallback.

Frame updates for active animation are allowed. Periodic context polling is not.

## Interruption and fail-open contract

Production ownership must:
- stop an active movement before starting a replacement transition;
- stop both movement directions on cleanup;
- stop on module disable;
- stop when the G.3 context loses ownership;
- stop on movement/controller failure;
- leave the current camera usable rather than forcing a speculative restore.

No pre-combat zoom restoration is added because the captured profile explicitly
uses `zoomRestoreSetting = never`.

## DynamicCam coexistence

DynamicCam and Logres must not drive camera movement simultaneously.

G.3 must capability-gate ownership so that Logres does not begin or continue a
camera transition while DynamicCam is the active camera owner.

Runtime validation of Logres production behavior is performed with DynamicCam
movement ownership disabled. Any coexistence gate must fail open to a usable
camera rather than competing for it.

## Scope exclusions

G.3 does not implement:
- City camera behavior;
- taxi camera behavior;
- NPC interaction camera behavior;
- fishing/gathering/hearth/AFK contexts;
- camera rotation;
- shoulder offsets;
- DynamicCam UI hiding;
- global camera CVar ownership;
- the temporary-CVar corrective zoom fallback;
- a core State.combat redesign.

## Parallel design boundary

D-032 world-first layout planning and D-033 World Ghost visual planning are
parallel future integration work. They do not alter camera context predicates,
movement ownership, restoration policy, or G.3 runtime acceptance.

## Implementation direction

The next runtime patch should add the smallest production controller that:
1. selects only the two G.3 contexts from event/state changes;
2. applies conditional targets using the proven primary path;
3. handles interruption and ownership loss explicitly;
4. exposes enough addon-owned diagnostic state to validate selection,
   transition, no-op, stop, and coexistence behavior;
5. remains fail-open.

## Runtime acceptance

G.3 is not complete until current-runtime evidence shows:
- World target behavior PASS when current zoom is farther than 5;
- World no-op behavior when already 5 or closer;
- live-combat target behavior PASS when current zoom is closer than 15;
- combat no-op behavior when already 15 or farther;
- clean World <-> World (Combat) transition behavior;
- no invented pre-combat zoom restoration;
- active movement stops on disable/ownership loss;
- DynamicCam and Logres do not move the camera simultaneously;
- no Lua, taint, protected-action, or secret-value errors;
- integrated checks remain PASS.
