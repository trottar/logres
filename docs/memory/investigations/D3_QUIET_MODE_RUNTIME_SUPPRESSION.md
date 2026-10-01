# D.3 — Quiet Mode Runtime Suppression

Status: COMPLETE — INSTANCE TRANSITION PROOF DEFERRED BY ENVIRONMENT
Opened: 2026-10-01

## Canonical decision

`../decisions/D-025_QUIET_MODE_RUNTIME_SUPPRESSION.md`

## Key source correction

Direct ChatFrame Hide/Show is rejected because Blizzard OnHide/OnShow updates
saved ChatWindowShown state.

Quiet Mode will use snapshot-based runtime alpha/mouse suppression instead.

## First runtime implementation

Create a Quiet Mode module that:
- receives desired state from ImmersionController;
- snapshots managed runtime presentation;
- suppresses chat frames/tabs without persistent settings changes;
- keeps edit boxes visually usable for intentional chat;
- reconciles after Blizzard chat-window updates;
- restores exact captured state.

## Not part of first pass

- auto replies;
- communication-status changes;
- every possible social notification;
- persistent mutation of Blizzard chat settings.

## Next

Implement P0050 runtime Quiet Mode and diagnostics.

## P0050 implementation

Runtime version:
`0.0.22-dev`

Adds runtime Quiet Mode with:
- alpha/mouse suppression;
- exact snapshots/restoration;
- edit-box parent-alpha override;
- chat-update reconciliation;
- controller integration;
- Quiet Check diagnostics.

Runtime proof is next.

## Runtime result

P0050 runtime passed for the world/restore workflow.

User observation:
the chat input surface remains available while passive chat/social
presentation is gone.

This matches D-025.

Instance transition proof is deferred by environment because no nearby
instance was naturally available.

D.3 closes.
