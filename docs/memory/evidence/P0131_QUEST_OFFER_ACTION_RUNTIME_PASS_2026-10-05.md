# P0131 Quest Offer Action Runtime PASS — 2026-10-05

Status: **ACCEPT + DECLINE RUNTIME CAPABILITY PASS**
Final tested runtime: `0.0.63-dev`
Baseline Git HEAD: `ab6473b25944f6d8e17318235b370a6cb5a74cc5`

## Preserved history

P0131 passed through two corrective steps before final capability acceptance.

The initial applier failed only because the new static checker required the wrong
reporting literal. The transactional applier rolled back tracked changes. That
tooling failure remains preserved separately.

The first runtime Accept attempt on `0.0.62-dev` called `AcceptQuest()` successfully
but observed `QUEST_FINISHED` before `QUEST_ACCEPTED`. The probe incorrectly treated
that intermediate event as terminal failure and lost correlation.

The same `0.0.62-dev` session proved Decline on quest 436 (`Ironband's Excavation`):
`callOK=true`, `event=QUEST_FINISHED`, `state=event-confirmed`, `secret=false`,
`error=nil`.

R2 `0.0.63-dev` changed only Accept event correlation: `QUEST_FINISHED` became an
intermediate observation and the pending action remained correlated until
`QUEST_ACCEPTED`.

## R3 finalizer preflight correction

The first docs/evidence finalizer attempt refused before writing because it required
every finalization target to already appear in the P0131 runtime manifest.
`docs/memory/MEMORY.md` was intentionally unchanged by the runtime patch and was
therefore absent from that manifest. The refusal left the P0131 R2 working tree
unchanged.

R3A corrects the finalizer contract: manifest-owned files must still match their
recorded hashes, while a finalization-only tracked file absent from the manifest
must be exactly clean against the verified Git HEAD before it may be updated. The
regenerated manifest then includes that newly finalized file. No runtime behavior
is changed by this correction.

## Final Accept retest

Client:
- interface `16001`;
- client `1.60.1` build `70205`;
- Logres load count `146`;
- runtime `0.0.63-dev`.

The player explicitly triggered Accept for quest ID `436`, title
`Ironband's Excavation`.

First diagnostic result:
- attempts `1`;
- mutationCalls `1`;
- state `awaiting-accepted-after-finished`.

Second diagnostic result:
- **PASS**;
- `callOK=true`;
- `event=QUEST_ACCEPTED`;
- `eventIdentity=matched`;
- `state=event-confirmed`;
- `finishedObserved=true`;
- attempts `1`;
- mutationCalls `1`;
- success `1`;
- failure `0`;
- secret=false;
- error=nil.

The accepted event therefore matched the exact preflight quest ID and closed the
same pending action correlation.

## Integrated regression result

Post-Accept `checkall` completed cleanly on `0.0.63-dev`.

Relevant continuity:
- Quest Dialogue: PASS;
- detail events `1`;
- accepted events `1`;
- finished events `2`;
- quest ID `436`;
- body/objective present;
- secret=false;
- error=nil;
- all recorded integrated checks PASS.

No Lua, secret-value, taint, protected-action, automatic quest choice, wrong-quest
mutation, or Blizzard-fallback regression was reported in the tested scope.

## Capability decision

The tested Forever quest-offer mutation capabilities are now proven:
- **AcceptQuest(): PASS**;
- **DeclineQuest(): PASS**.

This proves capability only. It does not authorize suppressing Blizzard quest
controls.

Before stock Accept / Decline can be hidden, Logres still needs a production
interaction surface that shows exact offer identity/source narrative, exposes
explicit player-owned controls, preserves cancellation/fallback behavior, and
fails open to Blizzard on unsupported/missing/secret/invalid state.

Continue / Complete, reward selection/claim, and quest-related gossip mutation
remain separately gated and unproven.

## Next slice

**P0132 — production Logres quest-offer Accept / Decline controls with Blizzard
controls retained as visible fallback during proof.**
