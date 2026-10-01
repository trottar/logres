# D-025 — Quiet Mode runtime suppression

Status: ACCEPTED
Date: 2026-10-01

## Decision

Quiet Mode is a **runtime presentation policy**.

It does not mutate Blizzard chat configuration or communication status.

## Managed first-pass surfaces

Quiet Mode may manage:
- ChatFrame message frames;
- matching chat tabs;
- general chat dock overflow affordance;
- known safe auxiliary chat/social visual controls.

It does not change:
- saved chat-window shown state;
- dock membership;
- chat channels/message groups;
- whisper status;
- communication CVars;
- auto-reply behavior.

## ChatFrame rule

Do not call `Hide()` / `Show()` on ChatFrame objects for Quiet Mode.

Blizzard ChatFrame OnHide/OnShow writes `SetChatWindowShown()`.

Selected suppression:
- snapshot runtime alpha/mouse;
- `SetAlpha(0)`;
- disable mouse;
- restore exact snapshot later.

## Tabs

Tabs receive the same runtime treatment:
- snapshot alpha/mouse;
- alpha 0;
- mouse disabled;
- exact restore.

Alpha zero is allowed here because mouse interaction is explicitly removed.

This differs from protected action buttons, where alpha zero was rejected while
the interactive region remained active.

## Edit box

Intentional outbound communication must remain possible.

While Quiet Mode is active:
- edit box uses `SetIgnoreParentAlpha(true)`;
- activation/typing remains Blizzard-owned.

Restore the prior `IsIgnoringParentAlpha()` value afterward.

## Reconciliation

Quiet Mode must reassert presentation after Blizzard chat-window updates.

At minimum account for:
- `UPDATE_CHAT_WINDOWS`;
- `UPDATE_FLOATING_CHAT_WINDOWS`;
- chat frames created/activated while Quiet Mode is active.

## Context

Initial policy:
- immersion OFF -> Quiet Mode OFF;
- immersion ON + world -> Quiet Mode ON;
- immersion ON + instance -> Quiet Mode OFF;
- PvP flag alone does not disable Quiet Mode.

## Fail-open

If Quiet Mode cannot safely capture or restore a surface:
- preserve/restore the Blizzard presentation;
- report the problem diagnostically;
- do not rewrite saved settings to force silence.

## Future expansion

D-025 first pass does not claim total social-notification coverage.

Additional notification surfaces can be added independently after source/runtime
proof.

## P0050 implementation binding

P0050 binds D-025 to `Immersion/QuietMode.lua`.

ImmersionController owns desired Quiet Mode state.

QuietMode owns:
- runtime surface snapshots;
- alpha/mouse suppression;
- edit-box parent-alpha override;
- chat-update reconciliation;
- restoration.

Quiet Mode does not own communication status or saved chat settings.
