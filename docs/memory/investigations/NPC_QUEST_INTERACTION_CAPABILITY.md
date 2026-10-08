# NPC Quest Interaction Capability Audit

Status: **OPEN — SOURCE LAYER RESOLVED; READ-ONLY RUNTIME PROBE NEXT**
Opened: 2026-10-05

Canonical product decision:
`../decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`.

Approved visual references:
- `../../design/approved/07_npc_quest_narrative_block.png`;
- `../../design/approved/08_npc_quest_interaction_states.png`.

## Question

What exact WoW Forever information, event, and interaction capabilities are
available for Logres to own the player-facing NPC quest flow safely and fail-open?

The audit must resolve capability before any Blizzard quest/gossip information or
control surface is suppressed.

## Existing proven baseline

Phase F already proves additive passive quest presentation while Blizzard remains
authoritative for interaction.

P0126 separately proves the optional Active Quest one-focus surface. It does not
claim NPC quest controls.

D-035 defines the intended future endpoint:
- offer/progress/completion narrative;
- bounded/paged source text;
- objective/action text;
- Accept / Decline;
- Continue / Complete;
- reward presentation and player reward selection;
- required quest-related gossip transitions.

No quest choice is automated.

## Audit slices

Resolve these independently rather than treating "quest interaction" as one
blanket capability:

1. **Narrative/source information**
   - offer text;
   - progress text;
   - completion text;
   - objectives/action wording;
   - quest identity/state.

2. **Reward information**
   - guaranteed rewards;
   - selectable rewards;
   - reward identity/details required for an informed player choice;
   - missing/secret/invalid-data behavior.

3. **Quest actions**
   - accept;
   - decline/cancel where applicable;
   - continue;
   - complete;
   - reward selection/claim.

4. **Quest-related gossip transitions**
   - entering the correct quest interaction from an NPC;
   - returning safely to Blizzard when Logres cannot continue.

5. **Runtime restrictions**
   - combat/protected behavior where applicable;
   - secret-capable values;
   - event/update ownership;
   - restoration and fail-open behavior.

## Required evidence discipline

For each surface:
- identify the current source/API candidate from pinned/current client evidence;
- separate read-only information from action/control;
- record secret/protected uncertainty before branching or mutation;
- prefer a targeted developer-panel diagnostic when runtime proof is needed;
- preserve Blizzard fallback until the corresponding Logres information and
  interaction are both proven.

Do not bundle all controls into one speculative implementation patch.

## Success criteria

The audit closes only when the repository can state, per quest-interaction state:
- what information source is available;
- what action path is available;
- what remains unproven or unsupported;
- what fallback stays visible;
- which smallest runtime implementation slice should come first.

A likely first implementation may be narrative/paging if its sources are already
safe while controls remain gated, but the audit must decide this from evidence
rather than assumption.

## Non-goals

This audit does not claim:
- the full quest log;
- watch-list management;
- super-track mutation;
- stock Objective Tracker ownership;
- non-quest gossip generally;
- quest-destination navigation;
- automatic quest choices.

## P0128 source-audit result

Canonical source evidence:
`../evidence/P0128_NPC_QUEST_INTERACTION_SOURCE_AUDIT_2026-10-05.md`.

Resolved from current Forever source references:
- narrative/progress/completion text sources exist;
- reward item/choice/currency/spell sources exist;
- Accept/Decline/Continue/finalize action functions exist;
- structured gossip quest/option reads and selection functions exist.

Still unproven at runtime:
- progress/complete text flow;
- reward-choice/item/currency/spell sufficiency;
- structured gossip rows on real NPCs;
- every quest/gossip mutation path.

Therefore P0128 does not authorize suppression or mutation.

Next:
**P0129 read-only runtime capability probe**, integrated into the Phase-H
developer panel.

## P0129 read-only runtime probe prepared

P0129 runtime `0.0.59-dev` adds an addon-owned event-driven diagnostic probe.

It observes:
- `GOSSIP_SHOW` / `GOSSIP_CLOSED`;
- `QUEST_DETAIL`;
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_FINISHED`.

It captures bounded narrative/reward/gossip state using secret-first guards and
records action-function presence without invoking mutation.

One Phase-H developer-panel action exposes the captured evidence. The contextual
probe is deliberately excluded from `Run All` so absence of an NPC quest state is
not misreported as a generic addon failure.

Runtime evidence is still required before this investigation can authorize any
mutation-specific follow-up.

## P0129 runtime result / P0130 decision

Canonical runtime evidence:
`../evidence/P0129_NPC_QUEST_INTERACTION_RUNTIME_READ_PASS_2026-10-05.md`.

Observed runtime PASS:
- three real offer/detail states;
- available-gossip quest row with stable quest ID/title;
- one real two-choice reward sample with item identity/link metadata;
- observed snapshots secret=false and call failures=0;
- expected mutation function groups present;
- mutation invariant `invoked=0`;
- integrated `checkall` PASS.

Environmental deferrals:
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- active gossip quest rows;
- generic gossip options;
- reward currencies;
- reward spells.

Decision:
the next implementation slice is **P0130 bounded/paged NPC quest-offer narrative**
using only the proven `QUEST_DETAIL` path.

P0130 remains presentation-only. Blizzard Accept/Decline/reward/gossip controls
stay available. No mutation-specific probe is authorized by this result.

## P0130 immersion-restore failure

P0130 `0.0.60-dev` passed deterministic multi-page preview, previous/next paging,
real `QUEST_DETAIL` rendering, Blizzard Accept/Decline coexistence, and integrated
checks.

A real lifecycle defect remained:
after Immersion OFF then ON during the same open quest offer, the Logres narrative
stayed hidden until the conversation was exited/reopened.

Canonical failure evidence:
`../evidence/P0130_QUEST_DIALOGUE_IMMERSION_RESTORE_FAILURE_2026-10-05.md`.

Cause:
preference OFF hid presentation, but preference ON had no restore path because no
new `QUEST_DETAIL` event fires solely from the preference change.

P0130 R1 caches only the successfully read active detail snapshot, preserves it
while immersion is off, restores it on OFF -> ON, and clears it on accepted /
finished / world / module-disable lifecycle termination.

This correction does not expand quest/gossip ownership.

## P0130 R1 acceptance / P0131 decision

Canonical final evidence:
`../evidence/P0130_QUEST_DIALOGUE_R1_RUNTIME_VISUAL_PASS_2026-10-05.md`.

P0130 R1 `0.0.61-dev` is runtime + visual PASS:
- bounded multi-page preview worked;
- Previous / Next worked;
- real offer rendering coexisted with usable Blizzard Accept / Decline;
- Immersion OFF hid Logres while Blizzard remained usable;
- Immersion ON during the same offer restored Logres directly;
- diagnostic reason was `immersion-on-restore`;
- body/objective remained present, secret=false, error=nil;
- integrated `checkall` completed cleanly.

The initial `0.0.60-dev` lifecycle failure remains preserved as negative evidence.

Next capability decision:
**P0131 player-triggered Accept / Decline mutation probe only.**

The probe must leave Blizzard controls visible, require explicit player-triggered
diagnostic actions, prove event/outcome behavior separately, and fail open. It
must not bundle Continue / Complete, reward choice, or gossip selection.

## P0131 Accept / Decline probe prepared

P0131 `0.0.62-dev` isolates the first quest mutation slice in a dedicated
`QuestOfferActionProbe` module.

Contract:
- only Accept / Decline may be invoked;
- the player must explicitly click the matching Phase-H diagnostic action;
- an observed current `QUEST_DETAIL` identity is re-read and matched before the
  call;
- secret/missing/invalid/mismatched state blocks mutation and fails open;
- Accept requires `QUEST_ACCEPTED` outcome evidence;
- Decline requires `QUEST_FINISHED` outcome evidence;
- Blizzard controls remain visible and usable;
- the same diagnostic button reports the resolved result on a subsequent click
  rather than repeating an unreported mutation;
- the probe is excluded from `Run All`.

No Continue / Complete, reward, or gossip selection call is authorized by this
slice.

Runtime evidence is required before either mutation can be classified as proven.

## P0131 first runtime result / R2 event-order correction

Canonical failure/result evidence:
`../evidence/P0131_ACCEPT_EVENT_ORDER_FAILURE_2026-10-05.md`.

`0.0.62-dev` result:
- Decline: **PASS** on quest 436, `callOK=true`, `QUEST_FINISHED`,
  `state=event-confirmed`, secret=false, error=nil;
- Accept: callOK, but the probe reported `finished-without-accepted` after seeing
  `QUEST_FINISHED` first;
- the same runtime session later recorded `QUEST_ACCEPTED` through the existing
  QuestDialogue event counter;
- integrated `checkall` PASS.

Classification:
Accept capability is **not yet marked PASS** because the probe lost correlation
before the accepted event. The failure is diagnostic event-order handling, not
permission to infer success.

P0131 R2 `0.0.63-dev` changes only that correlation rule:
- Decline still resolves immediately on `QUEST_FINISHED`;
- Accept records `QUEST_FINISHED` as intermediate and remains pending;
- a later `QUEST_ACCEPTED` resolves the same action;
- no polling, timer, broad hook, or new mutation is introduced.

Only Accept requires retest.

## P0131 final capability result / P0132 decision

Canonical final evidence:
`../evidence/P0131_QUEST_OFFER_ACTION_RUNTIME_PASS_2026-10-05.md`.

P0131 final result:
- **Decline capability PASS** from the tested `0.0.62-dev` run;
- **Accept capability PASS** on `0.0.63-dev`;
- Accept exact quest identity matched on `QUEST_ACCEPTED`;
- intermediate `QUEST_FINISHED` was observed and retained through correlation;
- secret=false;
- error=nil;
- integrated `checkall` PASS.

Therefore Accept / Decline mutation capability is proven for the tested Forever
quest-offer path.

This does not authorize suppression of Blizzard offer controls. The next
checkpoint is P0132: production Logres Accept / Decline controls for the offer
state, with Blizzard controls retained as visible fallback until those controls
are proven in-client.

Continue / Complete, reward selection/claim, and quest-related gossip mutation
remain unproven and separately gated.

## P0132 production offer controls prepared

P0131 is durable at `68233e64` / `0.0.63-dev` with Accept + Decline capability
proven.

P0132 `0.0.64-dev` translates only that proven offer-action subset into production
Logres controls:
- restrained text-first `Decline` / `Accept`;
- final-page gating for multi-page offers;
- deterministic non-mutating preview;
- exact cached offer ID/title bound into the production action route;
- shared P0131 mutation call sites and event correlation;
- non-mutating `Quest Offer Controls Check`;
- Blizzard controls retained as visible fallback.

P0132 does not suppress Blizzard offer controls and does not include Continue,
Complete, rewards, or gossip transitions. P0133 later accepted the corrected
Accept-left / Decline-right production surface at runtime and visual scale while
Blizzard remained visible fallback.

P0165 now prepares the separately gated stock-control suppression step on candidate
`0.0.82-dev`. Exact Forever `1.60.1.70245` source confirms stock Accept/Decline
lifecycle and requires fail-open for PvP-confirmation and auto-accept semantics that
Logres does not own. Only those two ordinary offer buttons are in scope; Continue,
Complete, rewards, gossip, and the QuestFrame root remain Blizzard-owned. Runtime
proof is required before this suppression capability is accepted.
