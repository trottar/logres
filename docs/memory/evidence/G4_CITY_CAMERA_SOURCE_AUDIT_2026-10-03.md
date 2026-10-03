# G.4 City Camera Source Audit — 2026-10-03

Status: SOURCE/PROFILE RESOLVED — CITY ZOOM IMPLEMENTATION AUTHORIZED
Date: 2026-10-03
Logres baseline: P0103 `4adf400a`
DynamicCam source: `ae586a9c973c3f868c10440358d4a6e8c2fab5ff`

## Question

Define the smallest City/resting camera slice that preserves the captured
DynamicCam camera semantics without importing unrelated UI presentation or
unproven global camera-setting ownership.

## Captured profile facts

The canonical `RPG` profile stores City situation `001` as enabled with:
- `timeToEnter = 2.5`;
- `viewZoom.enabled = true`;
- `zoomType = in`;
- `zoomValue = 5`;
- UI hide/fade enabled at opacity `0.65`;
- situation settings for reactive zoom plus `cameraDistanceMaxZoomFactor = 1`
  and `cameraZoomSpeed = 15.5`.

The profile-wide zoom restoration policy is `never`.

Canonical profile:
`G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`.

## DynamicCam context source

`DefaultSettings.lua` defines:
- City `001`: `IsResting()`, priority `1`, reevaluated from
  `PLAYER_UPDATE_RESTING`;
- World `004`: not resting and not in an instance, priority `0`;
- World (Combat) `006`: not in an instance and live
  `UnitAffectingCombat("player")`, priority `50`.

Therefore live World (Combat) outranks City when both combat and resting are
true. This matches the G.3 requirement that live combat classification remains
independent of cached `State.combat`.

Logres already captures `state.resting` from `IsResting()` and refreshes it on
`PLAYER_UPDATE_RESTING`, so City does not require a new sensor or polling loop.

## Transition and restoration semantics

DynamicCam `situationDefaults.transitionTime` is `1` second for both enter and
exit. The captured City profile overrides only `timeToEnter`, setting it to
`2.5`; its omitted exit value therefore retains the situation default.

For an ordinary situation change, `SituationManager:ChangeSituation()` uses the
**new situation's `timeToEnter`** for the zoom transition. Consequently:
- entering City normally uses City `2.5` seconds;
- City -> World uses World's `2.5` seconds;
- City -> World (Combat) uses Combat's `2.5` seconds.

The old City's inherited exit value is not an ordinary destination zoom time.
It matters to old-situation exit effects and zoom restoration paths. Because the
captured profile sets zoom restoration to `never`, G.4 must not invent any
restore-to-pre-City zoom behavior.

DynamicCam also forces transition time `0` for its first situation application
after login/reload. That is a global initialization special case, not a City
rule. G.4 will not introduce a startup snap that would also alter already-proven
G.3 behavior; startup parity remains a separate future question if needed.

## Conditional City zoom

DynamicCam's proven `zoomType = in` semantics are unchanged:
- if current zoom is greater than `5`, City targets absolute zoom `5`;
- if current zoom is already `5` or closer, City is a no-op;
- City never zooms outward merely to reach `5`.

The existing G.3 MoveView controller already runtime-proved this exact
conditional-in target shape for World.

## Reactive zoom and CVar comparison

The City profile explicitly stores reactive-zoom values:
- enabled `true`;
- add increments `2.5`;
- add-increments-always `0.1`;
- increment-add difference `1.2`;
- max zoom time `2.5`.

Those values are identical to the effective standard settings represented by
the captured profile plus DynamicCam's defaults. City therefore introduces no
City-specific reactive-zoom behavior delta that G.4 needs to own.

City also stores `cameraZoomSpeed = 15.5`, the same value stored in the captured
standard settings, so there is no City-specific speed delta.

City's `cameraDistanceMaxZoomFactor = 1` is different in kind: the captured
standard profile does not pin an equivalent value, so the audit must not assume
it is semantically redundant. G.4 explicitly defers that CVar override because
global/situation CVar ownership is outside the accepted camera slice. This is a
known partial-parity boundary, not an accidental omission.

## UI hide/fade separation

City's DynamicCam UI hide/fade at opacity `0.65` is presentation policy, not
camera motion. G.4 does not import it into the camera controller.

Any Logres equivalent must be decided against the existing Immersion Controller,
Quiet Mode, and Phase H visual policy rather than copied as a side effect of
City zoom ownership.

## Accepted G.4 camera contract

Context order inside the existing proven exclusions:
1. instance / taxi / active interaction remain fail-open/out-of-slice gates;
2. live `UnitAffectingCombat("player")` -> `combat`;
3. `state.resting == true` -> `city`;
4. otherwise -> `world`.

Targets:
- `combat`: conditional-out target `15`;
- `city`: conditional-in target `5`;
- `world`: conditional-in target `5`.

Ordinary City transition duration:
`2.5` seconds.

Restoration:
`never`.

Movement/coexistence/failure behavior:
reuse the runtime-proven G.3 controller unchanged in principle:
- targeted state/event reconciliation, no periodic context polling;
- `GetCameraZoom` + read-only `cameraZoomSpeed` + `MoveView*Start/Stop`;
- stop active movement before replacement transitions;
- stop on disable, ownership loss, DynamicCam load, or failure;
- fail open at the current usable camera position;
- DynamicCam and Logres never move the camera simultaneously.

## Explicit G.4 exclusions

Not implemented by the City zoom slice:
- City UI hide/fade;
- `cameraDistanceMaxZoomFactor` override;
- reactive-zoom ownership;
- startup first-situation instant transition parity;
- Taxi, Hearth/Teleport, NPC Interaction, Fishing, AFK, Gathering;
- rotation;
- shoulder offsets;
- broader/global camera CVar ownership.

## Smallest runtime proof

The implementation checkpoint should prove:
1. automatic World -> City selection from a real resting transition;
2. City >5 moves toward target 5 over the ordinary 2.5-second path;
3. City <=5 is a no-op and never zooms outward;
4. leaving City fresh-evaluates the destination context without restoring a
   remembered pre-City zoom;
5. Run All remains clean and includes camera status;
6. DynamicCam coexistence remains fail-open/blocked;
7. no Lua, taint, protected-action, or secret-value failure is observed.

A live combat + resting overlap is useful evidence if it occurs naturally, but
it must not require contrived gameplay solely to manufacture proof. Static
contract enforcement must place live combat before City, and any unavailable
runtime overlap is recorded as an environmental deferral rather than PASS.

## Result

**G.4 CONTRACT RESOLVED — CITY ZOOM IMPLEMENTATION AUTHORIZED.**
