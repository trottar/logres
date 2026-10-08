# P0165 — Quest-Offer Stock-Control Source Audit

Date: 2026-10-07
Baseline: `61bc9a41f290e3fbb2b3282ed3d3e3ffaaa28c58`
Forever client target: `1.60.1.70245`

Pinned Forever source:
`Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca`

The pinned commit is `1.60.1 (70245)`. Its parent is the previously audited
`1.60.1 (70235)` commit `a84e2b1b41d3d4137127c07e4da448aa3251d6f1`, and the 70245 commit changes only
`version.txt`.

Relevant source blobs are unchanged between 70235 and 70245:
- `Interface/AddOns/Blizzard_UIPanels_Game/Mainline/QuestFrame.lua`:
  `2fb8847426d6cb3f4e72f9f788ed9d840ed697ce`;
- `Interface/AddOns/Blizzard_UIPanels_Game/Vanilla/QuestFrame.xml`:
  `0749b35b12b27a4da03e35e80f3181ca7ed1f0a5`.

## Exact stock controls

Forever's Vanilla QuestFrame XML creates the offer buttons as direct children of
`QuestFrameDetailPanel`:
- `QuestFrameAcceptButton`, `UIPanelButtonTemplate`, left side;
- `QuestFrameDeclineButton`, `UIPanelButtonTemplate`, right side.

The rest of QuestFrame is a separate surface and is not part of P0165.

## Lifecycle

The shared QuestFrame source handles `QUEST_DETAIL` by switching to
`QuestFrameDetailPanel`, then showing `QuestFrame`.

`QuestFrameDetailPanel_OnShow`:
- hides progress/reward/greeting panels;
- hides Decline and marks `QuestFrame.autoQuest` for auto-accept offers;
- otherwise shows Decline outside gamepad UI;
- renders the detail content;
- disables Accept while Blizzard's quest-text fade is still active.

`QuestFrameDetailPanel_OnUpdate` later enables Accept after the text fade.

`QuestFrameDetailPanel_OnHide` clears the fade state. QuestFrame state changes to
progress/completion or closes on accepted/finished transitions.

The stock Accept path also has two semantics Logres must not silently bypass:
- `QuestFlagsPVP()` routes through the Blizzard `CONFIRM_ACCEPT_PVP_QUEST` popup;
- `QuestFrame.autoQuest` routes through `AcknowledgeAutoAcceptQuest()`.

Therefore P0165 must fail open for PvP-confirmation and auto-accept offers. The
existing Logres `AcceptQuest()` production path is proven only for the ordinary
non-PvP, non-auto-accept offer path.

## Suppression technique

The narrow safe technique is runtime alpha + mouse suppression on the two stock
buttons only:
- snapshot exact alpha token and ordinary mouse-enabled state;
- `SetAlpha(0)`;
- `EnableMouse(false)`;
- do not call `Hide()` / `Show()` on either button;
- do not mutate QuestFrame, QuestFrameDetailPanel, progress, reward, gossip, or
  quest-log surfaces;
- restore the exact alpha token and mouse state before Logres offer interaction is
  withdrawn.

The alpha snapshot is restoration-only and may be secret-capable. It is never
inspected, compared, formatted, counted, persisted, or used for branching.

If exact restore itself fails, an emergency fail-open attempts visible interactive
stock buttons (`alpha=1`, mouse enabled) and records the failure instead of leaving
an invisible click/control gap.

## Reconciliation

No polling or timer loop is required.

The source-backed lifecycle is sufficient:
- targeted `QuestFrameDetailPanel` `OnShow` hook to retry an event-order race only
  when Logres has already requested ownership;
- targeted `OnHide` restore;
- restore on `QUEST_PROGRESS`, `QUEST_COMPLETE`, `QUEST_ACCEPTED`,
  `QUEST_FINISHED`, and `PLAYER_ENTERING_WORLD`;
- protected/combat mutation, if encountered, defers to `PLAYER_REGEN_ENABLED`.

No global Show/Hide hook, hidden parent, CreateFrame interception, or periodic
reassertion is authorized.

## Production gate

Stock Accept/Decline suppression is eligible only when:
- Logres QuestDialogue is active for a real offer, not preview;
- the Blizzard detail panel and both ordinary stock buttons are present/shown;
- `QuestGetAutoAccept()` is safely readable and false;
- `QuestFlagsPVP()` is safely readable and false;
- any protected mutation is currently allowed.

If any gate fails, Logres leaves/restores the Blizzard controls and does not expose
its production Accept/Decline controls for that unsupported state.

This preserves every unsupported quest/gossip surface as Blizzard-owned fallback.
