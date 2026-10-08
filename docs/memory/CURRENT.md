---
memory_schema: 1
as_of: 2026-10-07
project: logres
---

# Current State

## Active Objective

**Finish the first new Phase H stock-surface suppression slice, then move to authored layout/positions and final whole-screen polish.**

Phase G is complete for the scope Logres currently claims. P0164 resolved the Phase H ownership matrix. P0165 implements only the already-justified ordinary quest-offer Accept/Decline stock-control suppression path.

## Current Work Item

**P0165 R1 — correct the camera transition rebase call, then rerun the P0165 suppression gate.**

Candidate runtime remains `0.0.82-dev`; the initial P0165 runtime attempt is a blocking FAIL and is not accepted.

The stock quest-offer suppression itself was visibly effective: the user confirmed the Blizzard Accept/Decline buttons were hidden. However, the same runtime exposed a pre-existing P0162 camera integration defect in `Camera/WorldCombat.lua`: the rebase branch still called `transitionExpectedZoom` with the old four-argument signature after the easing-function parameter was added. This produced `elapsed=nil` and a Lua error at the first numeric comparison.

Exact Forever `1.60.1.70245` source is pinned at `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca`. The relevant QuestFrame Lua/XML blobs are unchanged from 70235.

P0165 adds `QuestOfferStockSuppression` and integrates it with the proven Logres QuestDialogue offer controls. For ordinary non-PvP, non-auto-accept offers only, stock `QuestFrameAcceptButton` and `QuestFrameDeclineButton` are alpha-suppressed and mouse-disabled while Logres owns the offer interaction. Exact prior alpha/mouse state is restored before Logres interaction is withdrawn.

PvP-confirmation, auto-accept, hidden/gamepad, missing/secret/unreadable, and unsafe protected/combat states fail open to Blizzard. The QuestFrame root, progress/complete, rewards, gossip, tracker/log, and every unsupported state remain stock.

## Verified State

P0164 Phase H.1 audit is durable at `61bc9a41f290e3fbb2b3282ed3d3e3ffaaa28c58`.

Already accepted existing suppression remains unchanged:
- Quiet Mode passive chat/social presentation;
- selective PlayerFrame conventional shell;
- selective TargetFrame shell/disallowed metadata while preserving target context;
- conditional stock Bar 2/3 presentation + mouse replacement with matching Logres routing.

P0165 source findings:
- exact 70245 Forever commit is `15666a6e67938a1ab5caf041406464251db111ca`;
- `QuestFrameAcceptButton` and `QuestFrameDeclineButton` are direct children of `QuestFrameDetailPanel`;
- Blizzard separately owns auto-accept acknowledgement and PvP-confirmation behavior;
- targeted detail-panel lifecycle hooks plus quest-state events are sufficient; no polling/timer/global Show/Hide forcing is justified.

P0165 initial runtime result:
- stock Accept/Decline hiding was visually observed working;
- integrated runtime **FAIL**: `Camera/WorldCombat.lua:896 attempt to compare nil with number`;
- stack reached the rebase `transitionExpectedZoom` call around line 1595; screenshot locals showed `easingFunc=11.099131`, `startZoom=5`, `targetZoom=2.5`, `duration=0.472958`, `elapsed=nil`, exactly matching positional argument shift from the stale four-argument call;
- a Fishing follow-up produced repeated error/sound spam while camera motion partly continued, consistent with the same OnUpdate rebase exception recurring; no separate Fishing-policy defect is inferred without new evidence.

P0165 R1 changes only that camera rebase call shape plus a static regression contract and durable failure evidence. No quest suppression policy or camera tuning changes.

## Next Action

Apply/deploy P0165 R1 and run the bounded corrective gate:
1. `/reload`;
2. Phase G -> **Camera Profile Check** and Phase 0 -> **Run All**;
3. repeat one previously failing natural camera transition (one Fishing cast is sufficient because it reproduced the error) and require no Lua error/sound spam;
4. run **Camera Profile Check** again; require camera/reactive/profile failures and secret errors to remain zero;
5. open one ordinary non-PvP/non-auto-accept quest offer; confirm stock Accept/Decline are hidden and no invisible click regions remain;
6. Phase H -> **Quest Offer Stock Check** while open; require applied ownership, snapshot ready, exact source commit, zero failures/secret blocks;
7. Immersion OFF restores stock controls; ON reapplies supported ownership;
8. use one explicit Logres Accept or Decline, then run **Quest Offer Stock Check** and **Run All** again.

Do not accept or push P0165 until the Lua error is absent. The already-observed stock-button hiding is partial positive evidence only.

## Success Criteria

P0165 succeeds when:
- exact 70245 source-backed ordinary offer gating works in client;
- only stock Accept/Decline are hidden for the supported state;
- alpha-zero stock controls have mouse interaction disabled;
- earlier Logres narrative pages cannot be bypassed through visible stock Accept/Decline;
- Logres actions surface only on the final page and only while stock ownership is safely applied;
- PvP-confirmation/auto-accept/unsupported states remain Blizzard-owned;
- Immersion OFF, state transition, module disable, action start/block, and failure restore stock before Logres interaction is withdrawn;
- exact restoration succeeds in the normal path; emergency visible-interactive fail-open exists only for restore failure;
- the corrected transition rebase call always passes the selected easing function, so rebase cannot shift `elapsed` to nil;
- one natural Fishing/rebase retest produces no Lua-error/sound-spam recurrence;
- no polling, timer retry, hidden parent, global Show/Hide hook, unrelated frame mutation, saved-setting mutation, taint, protected-action, Lua, or secret inspection is introduced;
- full static checker suite and `git diff --check` pass.

## Do Not Reopen Without New Evidence

- P0164 ownership matrix remains authoritative;
- existing Quiet Mode, Player shell, Target selective suppression, and Bar 2–3 replacement remain accepted for tested scopes;
- the one-off TargetFrame reappearance remains OPEN / INTERMITTENT / UNREPRODUCED; do not add periodic forcing without recurrence evidence;
- no conventional player health bar;
- PvP is a modifier, not Immersion OFF;
- stock minimap, Party/CompactPartyFrame, target aura/status, target-of-target, PetFrame/PetActionBar, Main/Override/special action surfaces, unsupported class/special surfaces, alternate power, RuneFrame, TotemFrame, Objective Tracker, persistent XP, nameplates, and quest states beyond the proven ordinary offer slice remain available until separately replaced;
- player harmful/urgent and populated target aura production remain deferred;
- positive world-target nameplate attachment remains deferred;
- individual tracking-result positions remain source-blocked by D-043.

## Relevant References

- `docs/memory/evidence/P0165_R0_CAMERA_REBASE_RUNTIME_FAILURE_2026-10-07.md`
- `docs/memory/evidence/P0165_QUEST_OFFER_STOCK_SOURCE_AUDIT_2026-10-07.md`
- `docs/memory/patches/P0165_QUEST_OFFER_STOCK_SUPPRESSION.md`
- `docs/memory/evidence/P0164_BLIZZARD_SURFACE_OWNERSHIP_AUDIT_2026-10-07.md`
- `docs/memory/patches/P0164_PHASE_H_SUPPRESSION_AUDIT.md`
- `docs/memory/decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
- `docs/memory/decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
- `docs/memory/investigations/NPC_QUEST_INTERACTION_CAPABILITY.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
