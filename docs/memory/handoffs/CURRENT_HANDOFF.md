# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0164 `61bc9a41f290e3fbb2b3282ed3d3e3ffaaa28c58`; runtime remains `0.0.81-dev`.

## P0165 R1 corrective gate

P0165 candidate runtime remains `0.0.82-dev`. The initial P0165 runtime attempt is a blocking FAIL, not an accepted checkpoint.

Exact current Forever source:
`Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca` (`1.60.1.70245`). Relevant QuestFrame Lua/XML blobs are unchanged from 70235.

P0165 suppresses only `QuestFrameAcceptButton` / `QuestFrameDeclineButton` for ordinary non-PvP, non-auto-accept offers when the proven Logres offer narrative/control surface is active. Technique: exact alpha/mouse snapshot, alpha 0 + mouse off, exact restore before Logres interaction withdrawal. No whole-QuestFrame hide, parent mutation, timer/polling, or broad Show/Hide hook.

Unsupported PvP-confirmation, auto-accept, gamepad/hidden-button, missing/secret/unreadable, or unsafe protected/combat states fail open to Blizzard and do not expose Logres production offer actions.

## R0 runtime failure

The quest-offer stock buttons were visibly hidden as intended, but integrated runtime failed in the camera engine:
`Camera/WorldCombat.lua:896 attempt to compare nil with number`.

The rebase path around line 1595 called the five-argument `transitionExpectedZoom(easingFunc, startZoom, targetZoom, duration, elapsed)` helper with the old four-argument shape. Screenshot locals (`easingFunc=11.099131`, `startZoom=5`, `targetZoom=2.5`, `duration=0.472958`, `elapsed=nil`) directly identify that argument shift. Fishing subsequently produced repeated error/sound spam consistent with the same OnUpdate exception recurring.

P0165 R1 adds the missing `easingForName(self.transitionEasingName)` argument and a static call-shape contract. It does not change quest suppression behavior or camera policy.

## Runtime gate

1. `/reload`.
2. Phase G -> Camera Profile Check; Phase 0 -> Run All.
3. Repeat one natural previously failing transition; one Fishing cast is sufficient. Require no Lua error or repeated error sound.
4. Camera Profile Check again; require zero camera/reactive/profile failures and secret errors.
5. Open one ordinary quest offer; stock Accept/Decline hidden, no invisible click regions.
6. Quest Offer Stock Check while open: applied + snapshot ready + source commit + zero failures/secrets.
7. Immersion OFF restores stock first; ON reapplies supported ownership.
8. Use one Logres Accept or Decline; rerun Quest Offer Stock Check + Run All.

## After PASS

Close H.1 for all currently replacement-proven stock surfaces and move to H.2 authored integration anchors/default positions.

## Key references

- `../CURRENT.md`
- `../evidence/P0165_R0_CAMERA_REBASE_RUNTIME_FAILURE_2026-10-07.md`
- `../evidence/P0165_QUEST_OFFER_STOCK_SOURCE_AUDIT_2026-10-07.md`
- `../patches/P0165_QUEST_OFFER_STOCK_SUPPRESSION.md`
- `../evidence/P0164_BLIZZARD_SURFACE_OWNERSHIP_AUDIT_2026-10-07.md`
- `../investigations/NPC_QUEST_INTERACTION_CAPABILITY.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
