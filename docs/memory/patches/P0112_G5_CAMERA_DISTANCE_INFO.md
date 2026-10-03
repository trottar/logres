# P0112 — G.5 Camera-Distance Source Audit + Read-Only Info Diagnostic

Date: 2026-10-03
Result: **PREPARED R5 — RUNTIME READ-ONLY DIAGNOSTIC; PROOF PENDING**
Initial baseline: `bd0a9da3c7abc49ff527e8901bfd5c77846414a5`
Current parent after parallel P0113: `19c0d1ffcdc0cf2df59a2e648cfa9caab1c4d347`
Runtime: `0.0.44-dev -> 0.0.45-dev`

## Purpose

Resolve the source contract after the P0109 negative and collect the one missing
Forever runtime fact before any camera-distance mutation is considered.

## Source result

DynamicCam:
- maps displayed max distance as factor × 15;
- allows display target 50 for non-mainline;
- initializes standard max-distance from client `GetCVarDefault`;
- has no captured Taxi max-distance override;
- does not auto-raise max-distance merely because Taxi zoom target is 50.

LibCamera does not own `cameraDistanceMaxZoomFactor`.

Therefore current factor 1.2 is not enough information to justify a SetCVar test.
The inherited client default must be measured.

Canonical audit:
`../evidence/G5_CAMERA_DISTANCE_SOURCE_AUDIT_2026-10-03.md`.

## Runtime change

Adds a read-only method to the existing `CameraCapabilityProbe` and a Phase G
developer-panel action:

`Camera Distance Info`

The diagnostic prefers `C_CVar.GetCVarInfo`.

It records:
- current/default factor;
- current/default ceiling;
- required factor `50 / 15`;
- current/default support booleans;
- account/character storage flags;
- locked/secure/read-only flags;
- DynamicCam status/source;
- secret/error state;
- API source.

Fallback uses read-only current/default APIs and leaves unavailable metadata nil.

## Safety

The new diagnostic:
- does not call SetCVar;
- does not call CameraZoom APIs;
- does not call MoveView APIs;
- adds no timer, event, state subscription, or poller;
- does not require production controller disable;
- checks returned values for secret status before conversion/formatting.

Production Taxi ownership remains unchanged/fail-open.

## Static contract

Adds:
`tools/check_camera_distance_info_contract.py`.

The checker isolates the new read-only helper and enforces the no-mutation /
no-camera-motion boundary without globally rejecting the older movement probe.

The developer-panel phase checker is updated for the new Phase G action.

## Runtime acceptance

After verified push and deployment:
1. open Developer Panel -> Phase G;
2. click `Camera Distance Info`;
3. flush/export diagnostics.

No camera positioning, Taxi ride, controller OFF, or DynamicCam toggle is
required.

## Deployment

Runtime code changes.

WoW redeploy required after verified push.
## Delivery correction — R5

The first P0112 apply wrote its intended patch-owned files and then stopped on a
historical Taxi checker that pinned the whole addon to `0.0.44-dev`.

Because the failure occurred before manifest creation, later staging/diagnostic
commands that named `P0112_MANIFEST.txt` triggered zsh filename correction toward
the unrelated `P0111_MANIFEST.txt`.

P0112 R5:
- removes the obsolete exact-version assertions from the historical Taxi checker;
- keeps the new camera-distance checker version-invariant;
- records the shell/autocorrection + partial-worktree failure durably;
- adds an always-read AGENTS shell-safety rule and reusable LEARNINGS entry;
- preserves the already-written P0112 runtime implementation unchanged.

Canonical process evidence:
`../evidence/P0112_DELIVERY_SHELL_AND_CHECKER_FAILURES_2026-10-03.md`.

## Parallel P0113 boundary

P0113 (`19c0d1ffcdc0cf2df59a2e648cfa9caab1c4d347`) was pushed while P0112 remained an unstaged partial
worktree. Git comparison confirmed that P0113 touched only disjoint compass /
visual / D-038 / Phase-H files.

R5 therefore repairs P0112 in place on top of that parent and updates only
CURRENT / CURRENT_HANDOFF identity plus PATCH_INDEX. Remaining shared Phase-H
summary convergence is deferred to a later docs-only checkpoint after P0112 is
durable.
