# P0126 — Active Quest Runtime / Visual PASS — 2026-10-05

Status: **RUNTIME + VISUAL PASS — ACCEPTED PRODUCTION BASELINE**

Durable implementation:
`89b0c563d1ff5e12c61baa3e407725a90d9cefd4`

Runtime:
`0.0.58-dev`

## Scope

This evidence closes the P0126 Active Quest one-focus checkpoint.

The final accepted presentation contains:
- one current-focus quest;
- super-tracked quest first, selected quest fallback;
- exact quest title;
- restrained qualitative ambient progress wording;
- count-free normalized objective labels;
- bar-only objective progress with no persistent `%` or `N/M`;
- exact source wording/counts on deliberate hover;
- quiet complete/ready treatment;
- independent persisted `activeQuestEnabled` preference;
- Blizzard quest log / Objective Tracker retained.

## Preserved failure history

The initial `0.0.55-dev` candidate produced a real hover tooltip Lua failure.
That failure remains canonical at:

`P0126_ACTIVE_QUEST_HOVER_TOOLTIP_FAILURE_2026-10-04.md`.

R1 `0.0.56-dev` corrected the tooltip signature and passed hover validation.
R2 removed persistent percentage labels.
R3 added count-free normalized objective labels above bar-only progress.

The final accepted runtime is `0.0.58-dev`.

## Final runtime evidence

The final client diagnostics record:
- Logres `0.0.58-dev`, loadCount `134`;
- Active Quest normal preview: PASS;
- Active Quest complete preview: PASS;
- Active Quest live restore: PASS;
- Active Quest Check: PASS;
- real super-tracked quest `237`;
- two live objective rows;
- secret=false;
- error=nil;
- integrated `checkall`: complete with Active Quest and all recorded checks PASS.

No new Lua, secret-value, taint, or protected-action failure was reported in the
final tested scope.

## Visual result

The final R3 composition was accepted and committed:
- objective wording is persistently readable without exposing exact mechanical
  counts;
- progress remains bar-only;
- exact detail remains available on deliberate hover;
- the component remains one-focus rather than becoming a permanent multi-quest
  tracker.

Final whole-screen spacing/contrast calibration remains later polish and does not
block this checkpoint.

## Classification

**PASS / ACCEPTED PRODUCTION BASELINE.**

P0126 is complete. The next work item is a separate D-035 NPC quest-interaction
source/capability audit; P0126 itself does not authorize quest-control ownership
or Blizzard quest-surface suppression.
