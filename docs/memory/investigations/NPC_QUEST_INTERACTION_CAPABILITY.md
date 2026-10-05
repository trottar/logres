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
