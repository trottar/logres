# P0040 Action Feedback Runtime Failure — 2026-10-01

Status: REAL RUNTIME VISUAL FAILURE
Baseline: `6c21344dc44daccdd55744080dbca750082632f5`

## Observed

The correct P0040 version was deployed.

Existing behavior remained functional:
- secure action execution;
- out-of-range red;
- normal GCD/cooldown presentation.

But activating a Logres action produced **no perceptible visual difference**.

Therefore P0040 did not satisfy D-022.

## Root-cause hypothesis

P0040 had two presentation hazards:
1. the activation texture rested at alpha zero before its alpha animation;
2. the feedback texture inherited contextual cluster alpha, especially Utility.

This is a visual-presentation failure, not an action-execution failure.

## P0041 correction

P0041 uses a separate unprotected feedback frame parented to `UIParent`,
anchored to the secure action button, and independent from cluster alpha.

At rest the flash is hidden, not alpha-zero. On activation it is explicitly
reset to alpha 1, shown, faded, then hidden.

A manual **Feedback Test** pulses one Primary, Secondary, and Utility button
without requiring secure action execution.

## Retry

P0041 must prove:
- Feedback Test visible;
- mouse activation visible;
- routed-key activation visible;
- Utility feedback visible despite contextual fading;
- no protected/taint/Lua/secret regression.
