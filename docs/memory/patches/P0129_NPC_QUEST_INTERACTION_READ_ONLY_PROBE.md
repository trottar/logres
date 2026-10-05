# P0129 — Read-Only NPC Quest Interaction Runtime Probe

Date: 2026-10-05
Result: **PREPARED — RUNTIME EVIDENCE PENDING**
Baseline: `0ec74fe5a8e41a8bab7bf9eee6946a4d3d58c133`
Runtime: `0.0.58-dev -> 0.0.59-dev`

## Purpose

Resolve the first runtime layer of the D-035 NPC quest-interaction capability
audit without invoking quest/gossip mutation or suppressing Blizzard UI.

Canonical source audit:
`../evidence/P0128_NPC_QUEST_INTERACTION_SOURCE_AUDIT_2026-10-05.md`.

## Runtime probe

P0129 adds `QuestInteractionProbe`, an event-driven read-only module.

Observed events:
- `GOSSIP_SHOW`;
- `GOSSIP_CLOSED`;
- `QUEST_DETAIL`;
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_FINISHED`.

Read-only interaction capture:
- current quest ID/title/detail/objective/progress/reward text;
- reward XP;
- reward/choice counts;
- up to four choice and guaranteed-reward item rows;
- up to four reward-currency rows;
- up to four reward-spell IDs.

Read-only gossip capture:
- up to four available quest rows;
- up to four active quest rows;
- up to four generic gossip option rows.

All API-returned containers, rows, and scalars are secret-checked before nil/type/
comparison/format/count/iteration inspection.

## Mutation boundary

P0129 records runtime function presence only for:
- Accept;
- Decline;
- Continue (`CompleteQuest`);
- final reward (`GetQuestReward`);
- available/active quest gossip selection;
- generic gossip option selection.

P0129 does not invoke any of those functions.

The static contract explicitly rejects those mutation call forms.

No Blizzard quest/gossip surface is hidden, disabled, faded, mouse-suppressed, or
reparented.

## Diagnostic UX

One Phase-H developer-panel action is added:

`Quest Interaction Probe`

The action performs one manual read-only capture and prints:
- event registration/observation counts;
- read API presence;
- mutation API presence with `invoked=0`;
- summaries for naturally observed gossip/detail/progress/complete states;
- bounded reward metadata;
- bounded gossip quest/option rows;
- secret/call-failure state.

The probe is intentionally not included in `Run All`: absence of a contextual NPC
quest state is an environmental deferral, not a generic addon failure.

## Runtime validation

After deployment:
1. Phase H -> `Quest Interaction Probe` with no NPC interaction open;
2. interact naturally with a quest NPC;
3. if available, observe a quest offer and click `Quest Interaction Probe`;
4. if naturally available, observe a progress/turn-in interaction and click the
   probe again;
5. inspect persisted developer-panel diagnostics.

Required:
- module/probe action PASS;
- `invoked=0`;
- Blizzard quest/gossip UI remains usable;
- no Lua, secret-value, taint, or protected-action errors.

Natural absence of `QUEST_PROGRESS`, `QUEST_COMPLETE`, reward choices, currencies,
spells, or gossip categories is recorded as environmental deferral, not failure.

Do not travel or manufacture special quest states solely for this proof.

## Next decision gate

Runtime evidence determines whether the next slice is:
- narrative/paging implementation from proven read-only state; or
- one separately designed player-triggered mutation probe with Blizzard fallback
  still visible.

No mutation slice is authorized until P0129 evidence is reviewed.
