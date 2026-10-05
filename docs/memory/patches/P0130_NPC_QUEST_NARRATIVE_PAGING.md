# P0130 — Bounded / Paged NPC Quest Narrative

Date: 2026-10-05
Result: **INSTALLED / PUSHED — RUNTIME + VISUAL PASS** (`ab6473b2`)
Baseline: `e50676b993b9f5bc544eab610f99c7532dc98148`
Runtime: `0.0.59-dev -> 0.0.61-dev`

## Purpose

Translate approved sheet 07 into the production `QUEST_DETAIL` presentation using
the runtime-proven P0129 offer/detail read path.

Canonical runtime evidence:
`../evidence/P0129_NPC_QUEST_INTERACTION_RUNTIME_READ_PASS_2026-10-05.md`.

Canonical decision:
`../decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`.

## Production behavior

P0130 replaces the temporary excerpt-style Logres quest-offer presentation with:
- fixed authored narrative area;
- full source quest body split into discrete pages at word boundaries;
- visible page indicator only when more than one page exists;
- player-driven previous/next page buttons;
- wrapped objective text in its own authored region;
- no fabricated quest prose;
- no persistent timeout for real `QUEST_DETAIL` interactions.

The panel remains visible until the established quest interaction lifecycle hides
it (`QUEST_ACCEPTED`, `QUEST_FINISHED`, world transition, immersion off, module
disable).

The deterministic developer preview uses long text and a 30-second preview-only
timeout so paging can be inspected without a live quest.

## Visual media

Production derivatives:
- `Media/Quest/quest_narrative_panel.tga`;
- `Media/Quest/quest_narrative_divider.tga`;
- `Media/Quest/quest_page_chevron.tga`.

`Theme.lua` owns geometry, colors, typography, and media paths.

Canonical art reference:
`docs/design/approved/07_npc_quest_narrative_block.png`.

## Ownership boundary

P0130 is presentation-only.

It does not:
- Accept or Decline quests;
- call `CompleteQuest`;
- call `GetQuestReward`;
- select gossip quests/options;
- hide/reparent/fade/disable Blizzard quest/gossip UI;
- claim `QUEST_PROGRESS` or `QUEST_COMPLETE` proof;
- claim reward-choice control ownership.

Blizzard controls remain the fail-open interaction surface.

## Validation

After deployment:
1. Phase F -> `Quest Dialogue Preview`;
2. confirm the long preview spans multiple pages;
3. click previous/next controls and confirm source text changes with the page
   indicator;
4. Phase F -> `Quest Dialogue Check`;
5. interact naturally with a quest-offer NPC;
6. confirm real title/body/objective render without truncation and Blizzard
   Accept/Decline controls remain usable;
7. if the real body is one page, do not manufacture a long quest solely for
   paging proof because the deterministic preview covers the multi-page path;
8. run `Run All`.

Any Lua, secret-value, taint, protected-action, stuck page, invisible click
region, or Blizzard interaction regression is FAIL.

## Deferred states

`QUEST_PROGRESS` / `QUEST_COMPLETE` presentation remains deferred pending natural
runtime evidence.

Reward choice presentation/control remains separately gated.

## R1 immersion-restore correction

Initial P0130 `0.0.60-dev` runtime/visual proof passed:
- deterministic multi-page preview;
- Previous / Next buttons;
- real `QUEST_DETAIL` body/objective rendering;
- Blizzard Accept / Decline coexistence;
- integrated `checkall`.

Failure:
Immersion OFF correctly hid Logres, but turning Immersion back ON during the same
open quest offer did not restore the Logres narrative until a fresh
`QUEST_DETAIL` occurred after leaving/reopening the conversation.

Canonical failure evidence:
`../evidence/P0130_QUEST_DIALOGUE_IMMERSION_RESTORE_FAILURE_2026-10-05.md`.

R1 `0.0.61-dev`:
- caches the successful active detail snapshot;
- preserves it through Immersion OFF;
- restores it on OFF -> ON;
- clears it on accepted/finished/world/module-disable;
- clears it on failed/secret new detail reads;
- exposes `restoreCount` and `activeDetailCached` via addon-owned debug state;
- changes no quest/gossip mutation or Blizzard-control ownership.

R1 requires one narrow runtime retest before P0130 can be accepted.

## Final R1 acceptance

Runtime:
`0.0.61-dev`.

Canonical final evidence:
`../evidence/P0130_QUEST_DIALOGUE_R1_RUNTIME_VISUAL_PASS_2026-10-05.md`.

Final result:
- deterministic multi-page preview PASS;
- Previous / Next manual PASS;
- real `QUEST_DETAIL` presentation PASS;
- Blizzard Accept / Decline coexistence PASS;
- initial Immersion OFF -> ON restore failure preserved;
- R1 same-conversation restore PASS with
  `presentationReason=immersion-on-restore`;
- body/objective present;
- secret=false;
- error=nil;
- integrated `checkall` complete with all recorded checks PASS.

Classification:
**RUNTIME + VISUAL PASS / ACCEPTED PRODUCTION BASELINE.**

Next:
P0131 player-triggered Accept / Decline capability probe only.
