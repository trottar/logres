# P0050 — D.3 Quiet Mode runtime suppression

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Runtime

Version:
`0.0.21-dev -> 0.0.22-dev`

Adds:
- `Immersion/QuietMode.lua`;
- ImmersionController Quiet Mode orchestration;
- Quiet Check diagnostics;
- Quiet Mode static contract checker.

## Suppression

Passive chat uses:
- runtime alpha zero;
- mouse disable;
- snapshot restoration.

Intentional edit boxes:
- IgnoreParentAlpha true while Quiet Mode is active.

## Safety

Does not call:
- ChatFrame Hide/Show;
- SetChatWindowShown;
- FCF_SetWindowAlpha;
- SetChatWindowAlpha;
- chat channel/message mutation;
- auto reply/send APIs.

## Policy

- Immersion ON + world -> Quiet Mode ON.
- Immersion OFF -> Quiet Mode OFF.
- instance -> Quiet Mode OFF.
- PvP flag alone does not disable Quiet Mode.
