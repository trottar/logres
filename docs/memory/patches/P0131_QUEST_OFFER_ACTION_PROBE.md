# P0131 — Player-Triggered Quest Offer Accept / Decline Probe

Date: 2026-10-05
Result: **INSTALLED / PUSHED — ACCEPT + DECLINE RUNTIME CAPABILITY PASS** (`68233e64`)
Baseline: `ab6473b25944f6d8e17318235b370a6cb5a74cc5`
Runtime: `0.0.61-dev -> 0.0.63-dev`

## Purpose

Resolve the first D-035 quest mutation capability slice without suppressing any
Blizzard quest controls.

Canonical prerequisite evidence:
- `../evidence/P0130_QUEST_DIALOGUE_R1_RUNTIME_VISUAL_PASS_2026-10-05.md`;
- `../evidence/P0129_NPC_QUEST_INTERACTION_RUNTIME_READ_PASS_2026-10-05.md`.

## Scope

P0131 tests only:
- `AcceptQuest()`;
- `DeclineQuest()`.

The player must explicitly click the corresponding developer-panel action while a
real `QUEST_DETAIL` offer is open.

P0131 does not test or invoke:
- `CompleteQuest()`;
- `GetQuestReward()`;
- gossip quest selection;
- generic gossip option selection.

## Safety contract

The mutation probe is isolated in `Quest/OfferActionProbe.lua`.

Before an action call it requires:
- an observed `QUEST_DETAIL` offer;
- ordinary/non-secret current quest ID;
- ordinary/non-secret current quest title;
- current quest identity matching the offer captured by the probe;
- no pending action;
- no unreported prior result;
- the selected action API to exist.

On missing/secret/invalid/mismatched state, the action is blocked and Blizzard UI
remains untouched.

Each developer-panel click is the explicit player trigger. There is no automatic
acceptance/decline, polling, timer, or hidden replacement click surface.

## Outcome evidence

Accept:
- call attempt is recorded;
- `QUEST_ACCEPTED` is the expected success event;
- event numeric arguments are secret-checked before identity comparison;
- a numeric mismatch or secret event identity is FAIL;
- absence of a numeric identity argument may still record event confirmation while
  preserving the pre-action exact quest identity.

Decline:
- call attempt is recorded;
- `QUEST_FINISHED` is the expected success event;
- the exact offered quest identity is preserved from preflight.

If `QUEST_FINISHED` arrives for a pending Accept before `QUEST_ACCEPTED`, it is
recorded as an intermediate observation (`awaiting-accepted-after-finished`). The
same pending Accept remains correlated until `QUEST_ACCEPTED`, a replacement
offer, or world transition resolves the attempt. No polling or timer is used.

## Developer panel

Phase H adds two explicit mutation buttons:
- `TEST Accept Current Quest`;
- `TEST Decline Current Quest`.

First click attempts the action and reports STARTED/BLOCKED.
After the event resolves, click the same action again to report PASS/FAIL without
repeating the mutation.

The probe is not part of `Run All`.

## Blizzard fallback

Blizzard Accept / Decline controls remain visible and usable throughout P0131.
P0131 does not suppress, disable, fade, reparent, or replace them.

## Runtime validation

Accept proof:
1. open a quest offer the player is willing to accept;
2. Phase H -> `TEST Accept Current Quest`;
3. confirm the quest is accepted normally;
4. click `TEST Accept Current Quest` again to report the event-confirmed result;
5. confirm no Lua, taint, protected-action, or secret-value error.

Decline proof, only when naturally convenient:
1. open a quest offer the player is willing to decline;
2. Phase H -> `TEST Decline Current Quest`;
3. confirm the offer closes without accepting the quest;
4. click `TEST Decline Current Quest` again to report the event-confirmed result;
5. confirm the Blizzard quest can still be reopened normally.

If no convenient Decline case is available, record **DEFERRED**, not PASS or FAIL.

After tested mutation(s), run Phase 0 -> `Run All`.

## Decision gate

P0131 does not itself authorize Blizzard-control suppression.

After runtime evidence:
- if Accept and/or Decline passes, record only the tested action(s) as
  capability-proven;
- preserve any untested action as deferred;
- design actual Logres-owned action controls separately before suppressing Blizzard
  controls;
- keep Continue / Complete, rewards, and gossip transitions separately gated.

## R1 static-contract correction

The initial P0131 applier reached the new static checker after all existing
repository checks passed, then failed because the checker required the literal
`action.reported = true`.

The implementation correctly uses `self.lastAction.reported = true` in
`Probe:MarkReported(kind)`. The applier rolled back patch-owned tracked files.

Canonical failure evidence:
`../evidence/P0131_INITIAL_APPLIER_STATIC_CONTRACT_FAILURE_2026-10-05.md`.

R1 corrects only that checker literal. Runtime probe behavior and mutation scope
are unchanged.

## R2 Accept event-order correction

Canonical runtime evidence:
`../evidence/P0131_ACCEPT_EVENT_ORDER_FAILURE_2026-10-05.md`.

`0.0.62-dev` result:
- Decline PASS on quest 436;
- Accept `callOK=true`, but `QUEST_FINISHED` arrived first and the probe reported
  `finished-without-accepted`;
- the same runtime session later recorded one `QUEST_ACCEPTED` event through the
  existing quest-dialogue diagnostics;
- integrated `checkall` PASS.

Cause:
the probe incorrectly assumed `QUEST_FINISHED` was terminal failure for Accept.

R2 `0.0.63-dev`:
- preserves pending Accept correlation across `QUEST_FINISHED`;
- records `finishedObserved=true`;
- requires later `QUEST_ACCEPTED` for terminal PASS;
- leaves Decline behavior unchanged;
- adds no timer, polling, broad hook, or new mutation surface.

Only Accept requires corrective retest.

## Final R2 acceptance

Final runtime: `0.0.63-dev`.

Canonical final evidence:
`../evidence/P0131_QUEST_OFFER_ACTION_RUNTIME_PASS_2026-10-05.md`.

Final capability result:
- Decline PASS from `0.0.62-dev`;
- Accept PASS from `0.0.63-dev`;
- Accept exact identity matched on `QUEST_ACCEPTED`;
- `finishedObserved=true` confirms corrected event ordering;
- success=1, failure=0 in the final Accept session;
- secret=false;
- error=nil;
- integrated `checkall` PASS.

Classification: **Accept / Decline offer mutation capability proven.**

This does not authorize Blizzard control suppression. P0132 must first build and
prove production Logres Accept / Decline controls while Blizzard remains visible.

R3 finalization note:
The first finalizer attempt refused because `docs/memory/MEMORY.md` was a
finalization-only clean tracked file and therefore absent from the P0131 runtime
manifest. R3A verifies such non-manifest targets are clean against the verified
Git HEAD before updating them, then adds them to the regenerated manifest. No
runtime code changed.
