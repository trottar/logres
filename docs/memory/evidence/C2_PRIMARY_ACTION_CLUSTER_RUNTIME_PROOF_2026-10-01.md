# C.2 Primary Action Cluster Runtime Proof — 2026-10-01

Status: VERIFIED WITH NON-BLOCKING VISUAL REGRESSION
Final tested baseline: `405c599d90ff02a07a07437e4b20ce4c628675f0`

## P0032 failure context

P0032 established:
- cluster rendering;
- icon/state presentation;
- out-of-range red tint.

But secure execution failed:
- mouse clicks did not execute;
- automatically routed keybinds did not execute.

P0033 corrected the secure click/release path and made key routing fail-open.

## P0033 result

Verified:
- Logres secure action buttons execute when clicked;
- Logres secure action buttons execute through the user's existing keybinds;
- range feedback continues to work.

No protected-action failure was reported after the P0033 correction.

No secret-value error was reported.

Stock Blizzard action bars remain visible as required by D-017/D-018.

## Presentation result

Working:
- 4 x 3 primary cluster;
- action icons;
- real keybind labels;
- out-of-range red tint;
- secure mouse execution;
- secure keyboard execution.

P0033 removed the redundant internal `1–12` labels.

## Non-blocking visual regression

During the P0033 test, the player cast/channel cues continued to appear, but
their previously visible cast/channel colors were no longer perceptible.

Important:
- cue presence/lifecycle remains functional;
- `HUD.lua` still contains the expected color assignments;
- P0033 did not intentionally modify cast-cue styling;
- cause is not yet isolated.

Classification:
**VISUAL REGRESSION — NON-BLOCKING / CAUSE UNKNOWN**

Retry/fix conditions:
- revisit during cast-cue visual redesign/polish;
- investigate earlier if the color loss affects other HUD elements or becomes
  functionally ambiguous.

Do not treat this as evidence that the cast-event transport failed.

## C.2 conclusion

C.2's functional secure-action objectives are satisfied.

**C.2 — Primary Action Cluster: COMPLETE.**

Known debt:
- combat-time primary page remapping still defers until combat ends;
- cast/channel cue color regression remains recorded visual debt;
- stock action bars remain visible pending later replacement proof.
