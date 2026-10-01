# D.3 Quiet Mode Source Review — 2026-10-01

Status: SOURCE-RESOLVED FOR FIRST RUNTIME PASS
Date: 2026-10-01

## Goal

Implement visual chat/social silence without:
- changing communication status;
- changing saved Blizzard chat-window configuration;
- losing intentional outbound chat;
- creating invisible mouse interaction zones.

## Critical source finding: do not Hide ChatFrame

Current Blizzard `FloatingChatFrame.xml` gives the chat frame these scripts:

```text
OnShow -> SetChatWindowShown(id, true)

OnHide ->
    if not self:IsShown() and not minimized:
        SetChatWindowShown(id, false)
```

Therefore direct:

```lua
chatFrame:Hide()
```

is **not** runtime-only visual suppression.

It can mutate the player's persisted Blizzard chat-window shown state.

This refines the earlier D.1 wording that suggested runtime Hide/Show.

D.3 must not use direct ChatFrame Hide/Show as its Quiet Mode mechanism.

## FCF update ownership

`FloatingChatFrame_Update()` reads saved `GetChatWindowInfo()` and reconstructs
frame/tab presentation.

It can show chat frames and tabs again according to Blizzard configuration.

Events include:
- `UPDATE_CHAT_WINDOWS`;
- `UPDATE_FLOATING_CHAT_WINDOWS`.

Quiet Mode therefore needs reconciliation after Blizzard chat-window updates.

## Alpha mechanism

Whole-frame `SetAlpha(0)` does not trigger ChatFrame OnHide/OnShow.

This is the selected first-pass visual-suppression mechanism.

For each managed chat frame:
- capture runtime alpha;
- capture mouse-enabled state;
- set frame alpha to 0;
- disable frame mouse interaction.

For each matching chat tab:
- capture runtime alpha;
- capture mouse-enabled state;
- set alpha to 0;
- disable mouse interaction.

This avoids invisible click targets.

## Intentional outbound chat

The chat edit box is a child of its ChatFrame.

A zero-alpha parent would normally also make the edit box invisible.

Current UI API provides:
- `SetIgnoreParentAlpha(bool)`;
- `IsIgnoringParentAlpha()`.

First-pass Quiet Mode therefore:
- snapshots edit-box ignore-parent-alpha state;
- sets `editBox:SetIgnoreParentAlpha(true)` while Quiet Mode is active;
- leaves chat activation/editing behavior otherwise Blizzard-owned;
- restores the prior ignore-parent-alpha state when Quiet Mode ends.

This allows pressing Enter / intentional chat entry to remain visually usable
while passive chat presentation stays silent.

Runtime proof is required because effective edit-box rendering is a visual
behavior, not just an API-shape claim.

## Chat-frame enumeration

Blizzard maintains global `CHAT_FRAMES`.

FloatingChatFrame OnLoad adds chat frame names to this list.

Temporary whisper/conversation windows created later also use
`FloatingChatFrameTemplate`.

First-pass implementation should:
- reconcile every currently present frame named in `CHAT_FRAMES`;
- re-run reconciliation after chat update events;
- hook safe post-creation/update paths as necessary so temporary windows do not
  escape Quiet Mode.

Do not alter:
- message groups;
- channel subscriptions;
- whisper status;
- communication CVars.

## Dock/tab controls

The general chat dock has an overflow control independent of individual chat
message frames.

Quiet Mode should also suppress the dock overflow affordance at runtime:
- alpha 0;
- mouse disabled;
- exact prior state restored.

Do not rewrite dock membership or saved dock layout.

## First-pass auxiliary chat/social controls

Where present, first-pass Quiet Mode may presentation-suppress these known
visual controls using snapshot alpha/mouse state:
- `ChatFrameChannelButton`;
- `TextToSpeechButton`;
- `QuickJoinToastButton`.

No persistent settings should be changed.

This gives Quiet Mode a useful social-visual silence boundary without claiming
that every social notification surface is covered.

## Context policy

D-024 remains authoritative:

```text
Immersion OFF              -> Quiet Mode OFF
Immersion ON + world       -> Quiet Mode ON
Immersion ON + instance    -> Quiet Mode OFF (conservative first pass)
PvP flagged                -> does not disable Quiet Mode by itself
```

## Restoration

Quiet Mode restoration must restore captured runtime presentation state:
- ChatFrame alpha;
- ChatFrame mouse-enabled state;
- tab alpha;
- tab mouse-enabled state;
- edit-box ignore-parent-alpha;
- dock overflow alpha/mouse;
- managed auxiliary-control alpha/mouse.

Do not synthesize defaults when a captured value exists.

## Rejected

- `chatFrame:Hide()` / `Show()` for Quiet Mode;
- `SetChatWindowShown()` for Quiet Mode;
- `FCF_SetWindowAlpha()` as the silence mechanism;
- changing saved background alpha to hide text;
- changing message groups/channels;
- auto-reply behavior;
- making edit boxes unusable.

## First runtime proof

D.3 implementation should prove:
1. world + Immersion ON hides passive chat text/tabs/managed controls;
2. no invisible tab/control click zones;
3. pressing Enter still shows a usable chat edit box;
4. sending intentional chat still works;
5. Immersion OFF restores chat presentation;
6. entering an instance restores chat for the conservative policy;
7. returning to world reapplies Quiet Mode;
8. PvP flag alone does not restore chat;
9. chat-window updates do not permanently break suppression;
10. no saved Blizzard chat configuration is changed;
11. no Lua/taint/secret error occurs.

## Sources

Blizzard source mirror (`Gethe/wow-ui-source`, current source snapshot):
- `Blizzard_ChatFrameBase/Mainline/FloatingChatFrame.xml`
- `Blizzard_ChatFrameBase/Mainline/FloatingChatFrame.lua`
- `Blizzard_ChatFrameBase/Shared/FloatingChatFrame.lua`
- `Blizzard_APIDocumentationGenerated/SimpleRegionAPIDocumentation.lua`
- `Blizzard_APIDocumentationGenerated/SimpleFrameAPIDocumentation.lua`
