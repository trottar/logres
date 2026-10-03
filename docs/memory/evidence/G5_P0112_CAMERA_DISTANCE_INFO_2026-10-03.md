# G.5 P0112 Camera-Distance Info Runtime Evidence — 2026-10-03

Status: **RUNTIME READ-ONLY PASS — DEFAULT CANNOT SUPPORT TARGET 50**
Runtime: `0.0.45-dev`
Client: Forever `1.60.1`
Build: `70205`

## Question

What are the current and inherited-default `cameraDistanceMaxZoomFactor` values
and metadata on the current Forever client, without mutating the CVar or moving
the camera?

## Runtime action

Developer Panel -> Phase G -> `Camera Distance Info`.

The diagnostic completed successfully through `C_CVar.GetCVarInfo`.

Observed:
- current factor: `1.2`;
- default factor: `1`;
- current effective ceiling: `18`;
- default effective ceiling: `15`;
- required factor for target 50: `3.3333333333333` (`50 / 15`);
- `currentSupports50=false`;
- `defaultSupports50=false`;
- stored server-account: `true`;
- stored server-character: `false`;
- locked from user: `false`;
- secure: `false`;
- read-only: `false`;
- DynamicCam loaded: `false`;
- DynamicCam status known: `true`;
- DynamicCam status source: `C_AddOns`;
- secret: `false`;
- error: `nil`.

## Classification

**CLEAN READ-ONLY RUNTIME PASS.**

This is also a **negative capability result for the inherited/default
max-distance policy**:

- the client default factor `1` yields only distance `15`;
- the current factor `1.2` yields distance `18`;
- neither can reach the captured Taxi target `50`;
- DynamicCam's inherited standard default therefore cannot make target 50
  physically reachable by itself.

The current value differs from the client default. The evidence does not identify
which user/addon/action established that difference, so ownership must not be
inferred.

## Metadata implication

The CVar reports:
- account-stored;
- not character-stored;
- not user-locked;
- not secure;
- not read-only.

That metadata means a future write is not ruled out by those flags. It does
**not** prove that `SetCVar` is safe in all states, prove combat behavior, or
authorize Logres to change a persistent account-scoped setting.

Because current `1.2` is already a non-default value, any later temporary Logres
ownership must treat the observed current value as the restoration target rather
than resetting to default `1`.

## Architectural consequence

The prior decision gate is now resolved on the `default < 50/15` branch.

Do not:
- clamp Taxi to `18`;
- treat default `15` as the intended Taxi target;
- silently raise the account-stored CVar;
- implement production Taxi ownership yet.

Next work is a product/ownership contract for whether Logres may temporarily
raise an account-stored camera-distance CVar above both current and default
values to reproduce the captured Taxi target.

That contract must resolve, before mutation:
- exact target factor (`50 / 15`);
- current-value capture and exact restoration;
- coexistence with user or other-addon changes while Logres owns the value;
- reload/logout/disable/error interruption;
- client crash / forced termination persistence risk;
- combat/protected-state behavior;
- fail-open behavior when ownership cannot be established or restored.

No `SetCVar` experiment is authorized by this evidence record.
