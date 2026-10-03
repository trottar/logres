# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.3.**

P0096 is verified pushed at:
`a556a19a`.

P0097 future layout direction is durable at:
`86d062d3`.

P0098 parallel World Ghost direction is durable at:
`903e65c8`.

Current pushed runtime:
`0.0.40-dev`.

G.2:
**CLOSED — RUNTIME + INTEGRATION PASS.**

Captured P0096 evidence includes two genuine live-combat probes with:
- `combat=true`;
- `lockdown=true`;
- `cachedCombat=false`;
- `mismatch=true`;
- target/movement/restoration PASS;
- no secret/error result.

Out-of-combat and post-combat paths remained clean, and Run All passed every
emitted check through `checkall: complete` on `0.0.40-dev`.

The mismatch is retained as evidence: camera combat context uses live
`UnitAffectingCombat("player")`; cached Logres combat is not equivalent.

G.3 production contract:
- World -> conditional target 5;
- World (Combat) -> conditional target 15;
- ordinary transition 2.5 seconds;
- zoom restore never;
- primary `GetCameraZoom` + `MoveView*Start/Stop` path only;
- live UnitAffectingCombat selects combat;
- InCombatLockdown remains a separate restriction signal;
- stop cleanly on interruption/disable/failure;
- never let DynamicCam and Logres move the camera simultaneously.

Future Phase H+ layout direction remains recorded in D-032 and
`architecture/WORLD_FIRST_LAYOUT.md`.

Parallel art-direction preparation remains accepted in D-033 and
`architecture/VISUAL_SYSTEM_DIRECTION.md`; current preferred hypothesis is
World Ghost.

P0099 is docs/evidence only. No WoW redeploy is required for P0099.

After P0099 is verified pushed, implement G.3 production ownership.

User performs all commits/pushes.
