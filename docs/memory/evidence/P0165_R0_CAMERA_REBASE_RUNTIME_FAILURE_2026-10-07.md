# P0165 R0 — Camera Rebase Runtime Failure

Date: 2026-10-07
Runtime candidate: `0.0.82-dev`
Classification: **BLOCKING RUNTIME FAIL — P0165 NOT ACCEPTED**

## Observed result

During the first P0165 runtime gate, the stock Blizzard quest-offer Accept/Decline buttons were visibly hidden as intended. That is partial positive evidence for the new suppression slice, but the integrated checkpoint failed because a camera Lua error occurred.

Error shown by the client:

`Interface/AddOns/Logres/Camera/WorldCombat.lua:896: attempt to compare nil with number`

Stack included:
- `WorldCombat.lua:896` inside the transition expected-position helper;
- `WorldCombat.lua:1595` from the OnUpdate transition rebase path;
- `WorldCombat.lua:426` from the camera frame OnUpdate dispatch.

Client locals at the failure were:
- `easingFunc=11.099131`;
- `startZoom=5`;
- `targetZoom=2.5`;
- `duration=0.472958`;
- `elapsed=nil`.

## Cause

P0162 changed the helper signature to:

`transitionExpectedZoom(easingFunc, startZoom, targetZoom, duration, elapsed)`

The normal expected-position call was updated, but the rebase branch retained the old four-argument call:

`transitionExpectedZoom(startZoom, requestedTargetZoom, transitionDuration, elapsed)`

Therefore every argument shifted left at that call site. The observed locals match this exactly: the numeric prior `startZoom` became `easingFunc`, and the real `elapsed` occupied `duration`, leaving `elapsed=nil`. The helper then failed at its first `t < 0` comparison.

## Fishing follow-up

The user then reported Fishing camera behavior going "crazy" with repeated sound spam while the camera still partly moved. Because the same camera OnUpdate transition/rebase path remained active, this is classified as consistent with repeated recurrence of the same Lua exception. No separate Fishing timing/rotation policy change is authorized without independent evidence.

## R1 correction

P0165 R1 changes only the stale rebase call to pass:

`easingForName(self.transitionEasingName)`

as the first argument, and adds a static contract that requires the corrected call shape and rejects the stale four-argument form.

Quest-offer suppression logic and camera policy/tuning are unchanged. Runtime retest is required before P0165 can be accepted.
