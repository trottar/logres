# D.3 P0050 Quiet Mode Implementation — 2026-10-01

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Date: 2026-10-01

## Runtime version

`0.0.22-dev`

## Implementation

Adds:
`Logres/Immersion/QuietMode.lua`

The module owns first-pass runtime chat presentation suppression.

It does not own communication state or persisted Blizzard chat configuration.

## Managed presentation

When Quiet Mode is active:
- current ChatFrame objects receive alpha 0;
- ChatFrame mouse interaction is disabled;
- matching tabs receive alpha 0 and mouse disable;
- minimized chat-frame affordances are suppressed when present;
- general chat dock overflow is suppressed;
- known first-pass auxiliary controls are suppressed when present:
  - ChatFrameChannelButton;
  - TextToSpeechButton;
  - QuickJoinToastButton.

## Intentional chat input

Each managed chat edit box:
- snapshots its prior IgnoreParentAlpha state;
- receives `SetIgnoreParentAlpha(true)` while Quiet Mode is active.

This is intended to keep Enter/chat composition visible even though the passive
parent ChatFrame is transparent.

Runtime visual proof is required.

## Saved-setting safety

The implementation does not call:
- ChatFrame Hide/Show;
- `SetChatWindowShown`;
- `FCF_SetWindowAlpha`;
- `SetChatWindowAlpha`;
- message-group/channel mutation;
- communication CVars;
- chat send APIs.

It snapshots the ChatWindow shown value diagnostically and verifies that it
remains unchanged while Quiet Mode is applied.

## Reconciliation

Quiet Mode listens for:
- UPDATE_CHAT_WINDOWS;
- UPDATE_FLOATING_CHAT_WINDOWS.

It also post-hooks `FCF_CheckShowChatFrame` when available.

Reconciliation occurs on the next frame so Blizzard can finish its own chat
presentation update first.

New/temporary chat frames encountered while Quiet Mode is active receive their
own snapshots and suppression.

## Controller integration

ImmersionController now requests Quiet Mode along with action replacement.

Policy:
- Immersion ON + world -> Quiet Mode ON;
- Immersion OFF -> Quiet Mode OFF;
- instance -> Quiet Mode OFF;
- PvP flag alone -> no Quiet Mode change.

## Diagnostics

Adds:
- Quiet Check;
- `/logres quietcheck`.

Immersion Check now verifies Quiet Mode desired/requested/applied state.

Run All includes Quiet Check.

## Runtime proof

World / Immersion ON:
1. confirm `0.0.22-dev`;
2. passive chat text and tabs are visually absent;
3. old chat/tab locations do not intercept mouse;
4. Quiet Check PASS;
5. Immersion Check PASS;
6. Run All PASS.

Intentional communication:
7. press Enter;
8. chat edit box is visible and usable;
9. send a normal intentional chat message;
10. communication succeeds;
11. passive chat remains quiet afterward.

Restoration:
12. Immersion OFF;
13. original chat presentation returns;
14. tabs/interactions return;
15. Quiet Check PASS;
16. Immersion ON reapplies Quiet Mode.

Context:
17. if a natural instance transition is available, chat restores in the
    instance and Quiet Mode reapplies after returning to world;
18. do not manufacture an instance solely for this proof.

PvP:
19. PvP flag alone does not restore passive chat.

Configuration:
20. Blizzard chat-window shown/layout configuration remains intact across
    Quiet Mode ON/OFF and reload;
21. no Lua/taint/secret error occurs.
