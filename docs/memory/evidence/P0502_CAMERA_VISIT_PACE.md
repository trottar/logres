# P0502 — L-036 NPC visit continuity and camera movement pace

**Date:** 2026-11-21. **Baseline:** P0501 GitHub main `04431587f931a68c1d316d7801ece5c9be229ea3`, version `0.0.367-dev`. **New version:** `0.0.368-dev`. **Client state:** UNVERIFIED.

## Observation and source mechanism

User reports a stable roughly hour-long recent gameplay session, but repeated camera rotation as consecutive quest/gossip prompts are consumed at one NPC and movement that feels roughly 30–40% too fast. This is scoped stability, not comprehensive regression coverage. L-036 remains OPEN. Source mapping: `ProfileContexts:ReadSnapshot()` considers an NPC interaction eligible when a supported frame is shown and `UnitExists("npc")`; `WorldCombat` reconciles `QUEST_FINISHED`, `GOSSIP_CLOSED`, `QUEST_*`, etc. A transient frame disappearance can change interaction -> world/city -> interaction; `ProfileBehavior:ChangeContext` stops/returns the former rotation and starts another. This is a supported potential mechanism, not proof from captured gameplay.

## Design and safety

One bounded 0.45-second closure grace is armed only when the current camera context is interaction and the reason is `QUEST_FINISHED` or `GOSSIP_CLOSED`. During this grace a later quest/gossip event with an absent interaction frame does not force a world camera; a newly eligible interaction cancels the grace. On expiry through the existing finite camera frame driver (already used for fishing delays), ordinary context reconciliation restores the world camera when no frame remains. Explicit combat, target change, world entry and restriction events cancel the grace; incidental state updates do not. Disabled camera, missing context eligibility and loaded DynamicCam remain fail-open. No new OnUpdate, timer, polling source, native frame mutation or secret inspection; the already-active finite camera driver handles the deadline. A distinct new NPC within the grace period has no independent GUID-based identity gate; record this as an unverified limitation, not a proven behavior.

Motion duration multiplier = 1/0.65 = 1.53846 for the existing profile transitions (zoom/shoulder/degree yaw/pitch); fixed targets and degrees remain unchanged. Continuous yaw angular speed multiplier = 0.65. Cast-derived teleport durations are camera motion durations, not changes to spellcasting or sampling. Fixed source profile literals and previous DynamicCam exclusion remain intact.

## Rejected pre-release attempts

Initial draft used `C_Timer.After` in `WorldCombat.lua`. Six preexisting camera contracts correctly rejected the added timer (357/363 historical checks passed); no release was produced. A second draft reused the existing camera animation driver but rewrote the exact fishing-only `SetAnimationActive` statement. The captured-profile parity checker rejected that historical source change (362/363 passed). The corrected draft retains that statement unchanged and reactivates the same finite driver only for a pending NPC handoff. Both negative test results are retained rather than counted as PASS.

## Validation boundary

Author full checker suite, Lua syntax, source-bound camera fixture and exact package transaction/rollback tests required before release; a passing static suite is not client behavior. Forever acceptance: multiple quests at one NPC and gossip transitions without duplicate yaw; ordinary close returns to prior context; immediate different NPC, movement/combat and addon OFF restore correctly; look for Lua/taint/protected errors; pace subjectively 30–40% slower. Export `python3 tools/export_panel_diagnostics.py` if behavior fails. L-036 stays OPEN until documented scoped client PASS and pushed commit verification.
