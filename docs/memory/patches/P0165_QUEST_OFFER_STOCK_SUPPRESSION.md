# P0165 — Quest-Offer Stock Accept/Decline Suppression

Status: **R1 PREPARED — CORRECTIVE RUNTIME RETEST REQUIRED**
Date: 2026-10-07
Expected baseline: `61bc9a41f290e3fbb2b3282ed3d3e3ffaaa28c58`
Candidate runtime: `0.0.82-dev`

## Purpose

Make the already-proven Logres ordinary quest-offer interaction the sole visible
Accept/Decline path for its supported state, while retaining the rest of the
Blizzard QuestFrame as fallback.

## Runtime scope

Adds `Quest/OfferStockSuppression.lua` and integrates it with QuestDialogue.

For a normal non-PvP, non-auto-accept offer:
- stock `QuestFrameAcceptButton` and `QuestFrameDeclineButton` are alpha-suppressed
  and mouse-disabled while Logres owns the offer interaction;
- stock controls are suppressed even on earlier Logres narrative pages so the
  final-page gate is meaningful;
- Logres Accept/Decline are shown only on the final page and only after stock
  ownership is actually applied;
- preview never suppresses Blizzard controls;
- action start/block, Immersion OFF, panel transition, module disable, accepted /
  finished / progress / complete / world transition restore stock first.

PvP-confirmation, auto-accept, gamepad/hidden-button, missing/secret/unreadable,
and unsafe combat/protected states fail open to Blizzard.

## Explicit non-scope

P0165 does not suppress or mutate:
- the QuestFrame root;
- progress / Continue;
- completion / Complete;
- rewards or reward choice;
- gossip;
- objective tracker / quest log / watch;
- any minimap, action-special, unit-frame, aura, party, or pet surface.

No polling, timer retry, hidden parent, global Show/Hide hook, or blanket UI-hider
framework is introduced.

## Runtime gate

Use one naturally available ordinary quest offer.

1. Base Phase H **Quest Offer Stock Check** PASS while idle.
2. Separate Phase 0 **Run All** PASS.
3. Open a normal non-PvP, non-auto-accept quest offer.
4. Confirm the Blizzard Accept/Decline buttons are absent and leave no clickable
   invisible regions; the Blizzard QuestFrame itself remains present.
5. If the Logres narrative has multiple pages, confirm stock Accept/Decline remain
   absent before the final page and Logres actions appear only on the final page.
6. Phase H **Quest Offer Stock Check** while the offer is open: require
   `applied=true`, snapshot ready, zero failures/secret blocks, and exact source
   commit reported.
7. Toggle **Immersion OFF**: Blizzard Accept/Decline must restore and remain usable
   before Logres controls disappear. Toggle **Immersion ON**: supported offer
   suppression and Logres controls return.
8. Use one explicit Logres Accept or Decline action and confirm normal quest outcome.
9. Run **Quest Offer Stock Check** and **Run All** again; require clean restoration
   and zero Lua/taint/protected/secret failures.

If no ordinary offer is naturally available, record environmental deferral rather
than manufacturing a special state.

## R0 runtime failure / R1 correction

The first P0165 runtime attempt is a blocking FAIL despite positive visual evidence that the stock quest-offer Accept/Decline buttons were hidden.

Observed Lua failure:
`Interface/AddOns/Logres/Camera/WorldCombat.lua:896: attempt to compare nil with number`.

The stack reached the transition rebase call around line 1595. Screenshot locals were:
- `easingFunc=11.099131`;
- `startZoom=5`;
- `targetZoom=2.5`;
- `duration=0.472958`;
- `elapsed=nil`.

Cause: P0162 changed `transitionExpectedZoom` to accept the selected easing function as its first argument, but the source-rebase call site retained the old four-argument form. The positional shift made `elapsed` nil and failed at `if t < 0`.

A Fishing follow-up produced repeated error/sound spam while camera motion partly continued. This is treated as recurrence of the same OnUpdate exception, not as evidence for a second Fishing-policy defect.

P0165 R1 adds the missing `easingForName(self.transitionEasingName)` argument at the rebase call and extends the reactive-zoom static contract to forbid the stale call shape. Candidate runtime remains `0.0.82-dev` because P0165 has not been accepted. Quest suppression behavior is unchanged.
