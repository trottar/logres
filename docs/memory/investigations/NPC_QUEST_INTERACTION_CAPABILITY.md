# NPC Quest Interaction Capability Audit

Status: **OPEN — NEXT WORK ITEM**
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
