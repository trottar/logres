# P0258 — Multiple reward preview action parity (2026-10-18)

Baseline GitHub `main` `94635d3` verified P0257 pushed. The user's screenshot of **Reward Preview: Multiple** shows four correctly rendered sample cards (one guaranteed item, three labeled CHOICE items) and correct XP/money, but the footer adds **“Choose and complete in Blizzard quest window”** and there is no in-panel **Complete Quest** visual. The user explicitly accepts the other previews and requests that Multiple match Single, removing instructional text. This is a narrow negative **VISUAL GAP**, not an item-card rendering failure or a live choice-claim failure.

## Change

`QuestRewardModel.Preview("multi")` now returns the same numeric footer (`1050 XP | 7s`) and synthetic `action="preview-complete"` as Single. The unchanged `QuestDialogue:ShowRewardPreview` branch presents this through the **exact production reward-card renderer and shared in-panel Accept/Complete button**. The existing `offerActionPreview` click intercepts all preview clicks before completion logic: preview button input never selects rewards, accepts, or claims a quest. The preview cards, CHOICE labels, quantities and icons are unchanged. No changes to reward source, stock suppression, production claim gates, or the native controller.

**Important distinction:** A preview control demonstrates visual placement only. Multiple-choice item selection is still NOT implemented; supported production single-choice claim remains gated by `GetNumQuestChoices == 0`, and native Blizzard UI stays available for true selectable rewards. The brief Blizzard frame flash after a real claim stays **OPEN**. Quest 237 must remain uncompleted.

## Acceptance and testing

- P0257: GitHub pushed. Scope user says other previews seem good; do not infer acceptance of live quest reward claiming.
- P0258: exact-baseline and full static suite required; in-game Multiple preview **Complete Quest** visibility, footer cleanup, unchanged cards/icons, safe preview-only click, and Single/Quest Dialogue regression to be checked.
- This does not close full NPC state fixture coverage or project-wide preview coverage under D-046. Additional unspecified gameplay bugs remain OPEN / DETAILS PENDING.
