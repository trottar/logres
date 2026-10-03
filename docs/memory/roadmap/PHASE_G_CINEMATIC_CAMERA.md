# Phase G — Cinematic Camera

Status: ACTIVE — G.3
Opened: 2026-10-02

## Product Objective

Translate the user's established contextual DynamicCam behavior into Logres.

## G.1 — Current DynamicCam profile capture

**COMPLETE — PASS.**

## G.2 — World/Combat camera zoom capability

**COMPLETE — RUNTIME + INTEGRATION PASS.**

Correct profile behavior:
- World -> conditional target 5;
- World (Combat) -> conditional target 15;
- ordinary transitions 2.5 seconds;
- zoom restore never.

DynamicCam situation 006 uses live:
`UnitAffectingCombat("player")`.

P0095 proved the primary camera movement/restoration path out of combat but
classified combat from cached Logres state.

P0096 corrected the diagnostic classifier and then passed two genuine
live-combat probes on `0.0.40-dev`:
- live combat true;
- lockdown true;
- cached combat false;
- mismatch true;
- target/movement/restoration true;
- no secret/error result.

Out-of-combat and post-combat paths remained clean. Run All passed every emitted
check through `checkall: complete` on the same runtime.

Canonical evidence:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`.

## G.3 — Production World/Combat camera ownership

**ACTIVE — IMPLEMENTATION NEXT.**

Evidence-backed contract:
- World (Combat) uses live `UnitAffectingCombat("player")` while not in an
  instance and has priority over World;
- World applies when not resting and not in an instance;
- World conditionally targets zoom 5 only when farther than 5;
- World (Combat) conditionally targets zoom 15 only when closer than 15;
- ordinary transition is 2.5 seconds;
- zoom restore is never;
- use the proven `GetCameraZoom` + `MoveView*Start/Stop` mechanism;
- treat `InCombatLockdown()` as a separate restriction signal;
- do not use the unproven temporary-CVar fallback;
- stop movement cleanly on interruption, disable, ownership loss, or failure;
- DynamicCam and Logres must not move the camera simultaneously.

Canonical G.3 investigation:
`../investigations/G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`.

## Parallel future integration direction

D-032 world-first layout/action-role planning and D-033 World Ghost visual
planning remain valid parallel Phase H+ work. They do not broaden G.3 runtime
scope or waive camera capability gates.

## Later Phase G Work

More complex City/NPC/taxi/teleport/fishing/gathering/global settings remain
later slices. Rotation, UI hiding, shoulder offsets, and broader camera CVar
ownership are also outside G.3.
