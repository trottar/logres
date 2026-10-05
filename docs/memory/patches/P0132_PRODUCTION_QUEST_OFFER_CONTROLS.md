# P0132 — Production Quest-Offer Accept / Decline Controls

Date: 2026-10-05
Result: **INSTALLED / PUSHED — RUNTIME + CONTROL PASS; VISUAL ORDER CORRECTION REQUIRED** (`671f9836`)
Baseline: `68233e647279c8651a83626952ad409531c71832`
Runtime: `0.0.63-dev -> 0.0.64-dev`

## Purpose

Translate the capability-proven P0131 Accept / Decline path into the approved
player-facing quest-offer interaction controls.

Canonical capability evidence:
`../evidence/P0131_QUEST_OFFER_ACTION_RUNTIME_PASS_2026-10-05.md`.

Canonical ownership decision:
`../decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`.

Canonical visual reference:
`../../design/approved/08_npc_quest_interaction_states.png`.

## Production behavior

P0132 extends the accepted P0130 quest-offer narrative with two restrained
player-owned controls:
- `Decline`;
- `Accept`.

The controls are text-first rather than boxed, following approved sheet 08.
A thin Theme-owned production rule provides authored emphasis.

For one-page offers, controls are immediately available.

For multi-page offers, controls remain hidden until the player reaches the final
page. Page navigation therefore remains the only Logres interaction on earlier
pages.

The deterministic Quest Dialogue Preview also renders these controls, but preview
button clicks are explicitly non-mutating.

## Mutation routing

`QuestDialogue` never calls `AcceptQuest()` or `DeclineQuest()` directly.

It calls:
`QuestOfferActionProbe:TriggerProductionAction(kind, expectedQuestID, expectedTitle)`.

That production route:
- requires the exact cached Logres offer ID/title;
- requires the probe's current observed offer to match that bound identity;
- reuses the single P0131-proven mutation call sites;
- keeps P0131's Accept event-order correlation;
- records production source/result state;
- automatically acknowledges completed production results so a later real offer
  cannot be blocked by the diagnostic second-click reporting contract.

There is no automatic choice, polling, timer-driven mutation, or broad hook.

## Fail-open behavior

Blizzard Accept / Decline remain visible and usable throughout P0132.

If Logres cannot safely route an offer action:
- Logres does not mutate quest state;
- the Logres control remains available for retry where appropriate;
- restrained feedback says to use the standard quest controls;
- Blizzard UI remains untouched.

No quest/gossip Blizzard surface is hidden, faded, disabled, reparented, or
suppressed by P0132.

## Scope boundary

P0132 owns only the **offer-phase production controls under proof**.

Out of scope:
- progress / Continue;
- completion / Complete;
- reward presentation ownership;
- reward selection / `GetQuestReward`;
- quest-related gossip selection;
- Blizzard offer-control suppression.

Those remain separate D-035 gates.

## Diagnostics

Phase H adds:
`Quest Offer Controls Check`.

It is non-mutating and is also included in `Run All`.

The check reports:
- control construction/readiness;
- final-page visibility policy;
- preview/pending state;
- production button click/result state;
- latest shared offer-action runtime source/state/event/identity/call result.

The existing P0131 mutation diagnostics remain separate.

## Runtime validation

1. Phase F -> `Quest Dialogue Preview`.
2. Navigate a multi-page preview:
   - earlier page: no Accept / Decline controls;
   - final page: Decline / Accept controls visible.
3. Click either preview control and verify it only reports `Preview only`; no quest
   state may change.
4. Phase H -> `Quest Offer Controls Check` -> PASS.
5. Open a real quest offer:
   - Logres narrative renders;
   - Logres Decline / Accept render on the applicable final page;
   - Blizzard Accept / Decline remain visible and usable.
6. Prefer Decline first on a quest the player is willing to decline:
   - click Logres Decline;
   - offer closes normally;
   - run `Quest Offer Controls Check`;
   - require shared probe source=`production`, event=`QUEST_FINISHED`,
     state=`event-confirmed`, reported=true.
7. Reopen and test Logres Accept:
   - click Logres Accept;
   - quest accepts normally;
   - run `Quest Offer Controls Check`;
   - require source=`production`, event=`QUEST_ACCEPTED`,
     identity=`matched`, state=`event-confirmed`, reported=true.
8. Run Phase 0 -> `Run All`.

If repeating both actions is not naturally convenient, preserve the untested
production control as DEFERRED. Do not manufacture unrelated gameplay solely for
proof.

Any Lua, secret-value, taint, protected-action, wrong-quest mutation,
double-mutation, invisible Logres click surface, or Blizzard fallback regression
is FAIL.

## Decision gate

Even if P0132 passes, this checkpoint still does **not** suppress Blizzard offer
controls.

A later checkpoint may consider capability-gated stock offer-control suppression
only after this production replacement surface is accepted.

## Runtime / visual result

Durable commit:
`671f9836c43f3a4c9755f296ccad4a9574a62848`.

Canonical evidence:
`../evidence/P0132_PRODUCTION_OFFER_CONTROLS_RUNTIME_VISUAL_ORDER_2026-10-05.md`.

Runtime/control PASS:
- preview non-mutating;
- production Decline event-confirmed;
- production Accept matched/event-confirmed;
- Blizzard quest UI remained visible/usable;
- integrated `checkall` PASS.

Manual visual review found one defect:
- Logres Decline was left;
- Logres Accept was right;
- Blizzard's simultaneously visible fallback uses the opposite order;
- the mismatch was confusing.

P0133 corrects positions only: Accept left / Decline right.
