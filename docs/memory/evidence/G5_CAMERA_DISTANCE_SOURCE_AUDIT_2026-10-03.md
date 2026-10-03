# G.5 Camera-Distance CVar Source Audit — 2026-10-03

Status: **SOURCE CONTRACT RESOLVED — READ-ONLY FOREVER DEFAULT/METADATA PROBE NEXT**
Date: 2026-10-03
Logres baseline: P0111 `bd0a9da3`
Current pushed runtime: `0.0.44-dev`
Pinned DynamicCam source: `ae586a9c973c3f868c10440358d4a6e8c2fab5ff`
Pinned LibCamera source: `c0b23135a0b24fbca24b41cb53dd7afc9114e352`

## Question

After P0109 proved that current `cameraDistanceMaxZoomFactor = 1.2` caps the
camera at zoom 18, determine whether the next step should be a CVar mutation or a
narrower read-only fact-finding step.

## DynamicCam max-distance model

Pinned DynamicCam `Options.lua` defines a camera-distance display maximum of:
- 39 for mainline;
- 50 for non-mainline projects.

Pinned `Ui/Descriptor.lua` maps the stored CVar factor to displayed yards with:

`display = factor * 15`

and maps display yards back with:

`factor = display / 15`.

Therefore a physical target of 50 requires a factor of at least:

`50 / 15 = 3.333333333333333...`

This is a source-derived requirement, not yet a statement that Forever accepts
that value in the current session.

## DynamicCam inherited standard setting

Pinned `DefaultSettings.lua` initializes the standard profile value for
`cameraDistanceMaxZoomFactor` from:

`GetCVarDefault("cameraDistanceMaxZoomFactor")`

The canonical G.1 `RPG` profile capture does not store an explicit standard
`cameraDistanceMaxZoomFactor` value.

The Taxi situation also does not store a situation-specific
`cameraDistanceMaxZoomFactor` override.

Therefore the captured Taxi profile does **not** itself instruct DynamicCam to
raise camera-distance max for target 50. Its effective standard setting is
inherited from the client default unless a separately persisted profile value
exists.

That missing client default was not measured by P0109: P0109 measured only the
current value, `1.2`.

## DynamicCam application/restoration semantics

Pinned `Core.lua` separates CVar application from situation zoom.

`ApplySettings()` applies the profile's standard CVar settings, replacing an
individual CVar with the active situation override when one exists.

`DC_SetCVar()` changes the client CVar only when its current value differs from
the desired profile value.

There is no source path in the Taxi zoom action that automatically raises
`cameraDistanceMaxZoomFactor` merely because `viewZoom.zoomValue = 50`.

DynamicCam shutdown exits the active situation and reapplies standard settings.
That restores situation-specific overrides back to DynamicCam's standard profile
value; it is not evidence of a general arbitrary pre-addon-value token restore.

`ResetCVars()` is a separate explicit path that writes client defaults.

## LibCamera boundary

Pinned LibCamera drives zoom primarily with:
- `GetCameraZoom`;
- `cameraZoomSpeed`;
- `MoveViewInStart/Stop`;
- `MoveViewOutStart/Stop`.

Its fallback zoom path may temporarily change `cameraZoomSpeed`, perform a
CameraZoom action, and restore the zoom-speed value.

No pinned LibCamera source path was found that changes
`cameraDistanceMaxZoomFactor`.

Therefore neither the Taxi situation's target 50 nor LibCamera's zoom engine
proves that DynamicCam would raise the camera-distance ceiling to satisfy target
50.

## Supporting current API documentation

Warcraft Wiki documentation retrieved 2026-10-03 reports
`C_CVar.GetCVarInfo` as available on Forever 1.60.1 and returning:
- current value;
- default value;
- server-account storage flag;
- server-character storage flag;
- locked-from-user flag;
- secure flag;
- read-only flag.

The generic Classic CVar documentation also describes
`cameraDistanceMaxZoomFactor` as factor-times-15 and reports a Classic range up
to factor 4 / a 50-yard effective cap.

These are supporting API/source references, not accepted runtime proof of the
exact current Forever default, storage flags, or write behavior.

References retrieved:
- https://warcraft.wiki.gg/wiki/API:C_CVar.GetCVarInfo
- https://warcraft.wiki.gg/wiki/CVar_cameraDistanceMaxZoomFactor

## Architectural conclusion

The source audit does **not** justify a `SetCVar` experiment yet.

The narrower missing fact is the current Forever metadata for
`cameraDistanceMaxZoomFactor`, especially:

`defaultValue`

because the captured DynamicCam profile inherits that client default.

The next capability step must therefore be read-only.

## Required read-only runtime probe

Add one Phase G developer-panel action that obtains, without mutation:
- current factor;
- default factor;
- current/default effective ceilings (`factor * 15`);
- required factor for target 50 (`50 / 15`);
- whether current/default can support target 50;
- storage scope flags;
- locked/secure/read-only flags;
- API source;
- DynamicCam load status;
- secret/error state.

Prefer `C_CVar.GetCVarInfo`.

If unavailable, fall back to read-only current/default APIs and leave unavailable
metadata fields nil.

The probe must not:
- call `SetCVar`;
- move the camera;
- call CameraZoom APIs;
- add timers, events, state subscriptions, or polling;
- require production camera ownership to be disabled.

## Decision after read-only runtime evidence

If the client default itself supports target 50, investigate whether reproducing
DynamicCam's inherited standard value requires temporary Logres CVar ownership.

If the client default does not support target 50, then the captured DynamicCam
Taxi target can itself saturate below 50 under inherited standard settings. In
that case Logres must not invent a higher max-distance mutation merely to make
the configured target numerically reachable without a separate product decision.

In either case, no target clamp is accepted by inference.

## Result

**SOURCE CONTRACT RESOLVED.**

Next:
**read-only Forever default/metadata evidence.**

No CVar mutation is authorized by this audit.
