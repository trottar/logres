# E.2 P0067 Heading Compass Implementation — 2026-10-01

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Date: 2026-10-01
Baseline: `586d188d3c624dd64ba05cfb91b8e17db5a57bc9`
Runtime target: `0.0.28-dev`

## Implementation

P0067 implements the D-029 first runtime slice.

New module:
`Logres/Navigation/Compass.lua`

Presentation:
- top-center horizontal heading tape;
- N / NE / E / SE / S / SW / W / NW labels;
- restrained Warcraft-style line/ticks;
- central fixed heading marker;
- smooth heading motion from a 20 Hz module-local sample.

## Eligibility

The compass consumes existing project authority:

```text
module enabled
AND immersionEnabled
AND State.context == "world"
```

Only while that policy is eligible does the module sample `GetPlayerFacing()`.

It never polls facing while State reports `instance`.

## Capability handling

Facing is treated as capability data.

Before inspection/arithmetic:
- call is protected by `pcall`;
- result is checked with `issecretvalue`;
- nil/non-number results are rejected.

When facing is unavailable:
- the frame hides;
- `presentationActive=false`;
- `headingDegrees=nil`;
- the previous heading is not retained.

In eligible world context, the throttled sampler remains active after a
temporarily unavailable sample so capability can recover naturally.

## Heading conversion

The implementation follows D-029:

`headingDegrees = (360 - math.deg(facing)) % 360`

Runtime must visually verify orientation.

## Diagnostics

P0067 adds:
- `/logres compasscheck`;
- `Compass Check` developer-panel action;
- Compass Check to Run All;
- addon-owned `Compass:GetDebugStatus()`.

Compass Check does not call `GetPlayerFacing()` itself. It validates the
module-owned availability/presentation state against current State + preference.

## Explicit exclusions

P0067 does not use:
- `C_Map`;
- player map position;
- quest waypoints;
- user waypoints;
- SuperTrack;
- distance;
- route/path guidance;
- minimap mutation/suppression.

## Static contract

`tools/check_compass_contract.py` enforces the D-029/E.2 boundary.

P0067 also makes the older D.6 restoration checker version-neutral: it now
requires Bootstrap/TOC version consistency instead of permanently pinning
`0.0.27-dev`.

## Delivery tooling note

The first local P0067 artifact-generator attempt failed before creating an
artifact because nested Python triple-quoted strings terminated the generator
source incorrectly.

No ZIP was produced or handed off from that failed attempt.

The generator was corrected before delivery. This is recorded as a tooling
failure, not a repository/runtime failure.

## Runtime proof next

Validate:
1. open-world Immersion ON Compass Check PASS;
2. visible tape follows player rotation;
3. N/E/S/W orientation is correct;
4. Immersion OFF hides/suspends and Compass Check PASS;
5. Immersion ON restores and Compass Check PASS;
6. `/reload` restores preference-driven presentation;
7. natural instance transition, when available, suspends the compass and
   returning to world restores it;
8. Run All remains PASS for checks actually exercised;
9. no Lua/taint/secret regression;
10. minimap remains untouched.

## First local apply failure

The first P0067 apply aborted before manifest creation because the completed
D.6 restoration checker produced false ordering failures for PlayerFrame and
TargetFrame restoration.

Canonical evidence:
`E2_P0067_STATIC_CHECKER_FAILURE_2026-10-01.md`

The replacement runtime implementations were unchanged. Corrected P0067 repairs
only the checker logic for this issue.

