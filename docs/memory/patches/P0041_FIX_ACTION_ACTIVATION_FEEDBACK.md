# P0041 — Fix action activation feedback

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Trigger

P0040 was pushed at `6c21344` and deployed correctly.

Runtime:
- execution works;
- range red works;
- GCD works;
- no perceptible activation-feedback difference.

## Fix

Move feedback off the context-faded cluster hierarchy.

Each secure action button gets an unprotected feedback frame parented to
`UIParent`, anchored to the button, on HIGH strata, with mouse disabled.

Activation is hidden at rest, then explicitly shown at alpha 1 and faded to
zero over 0.24 seconds.

Adds `/logres actionfeedback` and diagnostics-panel **Feedback Test**.

## Version

`0.0.18-dev -> 0.0.19-dev`

## Generation note

The temporary generation workspace expired/reset after P0040, so P0041 is
applied by a one-time repository patch script against verified P0040 source
signatures. This is an artifact-generation environment issue, not addon/runtime
evidence.
