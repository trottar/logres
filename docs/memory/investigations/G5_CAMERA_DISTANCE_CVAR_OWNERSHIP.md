# G.5 — Camera-Distance CVar Ownership

Status: **OPEN — SOURCE/CONTRACT REVIEW**
Opened: 2026-10-03
Parent: `G5_TAXI_CAMERA_OWNERSHIP.md`

## Trigger

P0109 runtime evidence proved that target zoom `50` is not reachable under the
current no-CVar-mutation boundary.

Observed twice on runtime `0.0.44-dev`:
- `cameraDistanceMaxZoomFactor = 1.2`;
- effective ceiling `18`;
- target `50`;
- actual outbound turn zoom `18`;
- target not reached;
- starting zoom restored;
- CVar unchanged;
- secret=false.

Canonical evidence:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`.

## Narrow question

Can Logres safely and deliberately own the minimum camera-distance CVar change
needed to reproduce the captured Taxi target 50, with explicit restoration and
fail-open behavior?

## Required source/contract audit

Resolve before runtime mutation:

1. Forever client semantics for `cameraDistanceMaxZoomFactor`.
2. Current/default/minimum/maximum values and whether the client clamps writes.
3. Whether the value is account-wide, character-specific, session-only, or
   otherwise persisted.
4. Whether `SetCVar` for this setting is permitted in combat and under protected
   action restrictions.
5. Whether the value can ever be secret-capable or otherwise unsafe to inspect.
6. DynamicCam and LibCamera behavior around:
   - temporary max-distance changes;
   - old-value capture;
   - restore timing;
   - interrupted transitions;
   - addon disable/logout/reload;
   - errors and coexistence.
7. Whether target 50 requires a factor of at least `50 / 15` under the
   source-derived distance formula.
8. The smallest fail-open capability test, if source review supports one.

## Hard boundaries

Until this review is resolved:
- do not call `SetCVar` for camera distance;
- do not ship target 18 as a substitute for target 50;
- do not enable production Taxi ownership;
- do not add Taxi rotation or UI fade;
- do not add polling or periodic CVar reassertion.

If CVar ownership is not safely supportable, preserve Taxi as Blizzard/DynamicCam
fail-open and record the limitation rather than degrading the target contract.
