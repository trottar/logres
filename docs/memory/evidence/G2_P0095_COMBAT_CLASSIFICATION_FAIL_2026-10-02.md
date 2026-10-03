# G.2 P0095 Combat Classification Failure — 2026-10-02

Status: OOC CAMERA PATH PASS; COMBAT CLASSIFICATION DEFECT PROVEN
Date: 2026-10-02
P0095 commit: `b65ea1afb5915377029dff52a260668d388cd831`
Runtime: `0.0.39-dev`

## Captured runtime

DynamicCam was not loaded for either probe.

Run 1:
- combat=false;
- API=true;
- cameraZoomSpeed=15.5;
- start=14.008003234863;
- target=13.258003234863;
- turn=13.25799369812;
- final=14.026753425598;
- targetReached=true;
- moved=true;
- restored=true;
- secret=false;
- error=nil.

Run 2:
- combat=false;
- API=true;
- cameraZoomSpeed=15.5;
- start=14.026753425598;
- target=13.276753425598;
- turn=13.261747360229;
- final=14.059266090393;
- targetReached=true;
- moved=true;
- restored=true;
- secret=false;
- error=nil.

Run All subsequently passed within its tested scope.

## User report

After the requested out-of-combat and combat test sequence, the user reported:

`false for both probes`

No `combat=true` result was captured.

## Cause

P0095 assigned:

`self.lastCombat = state.combat == true`

where `state` came from `Logres:GetState()`.

Current core State derives cached `combat` from `InCombatLockdown()` when state
refresh events run.

Existing I-001 evidence proves lockdown can still be false at early combat
events and become true only later.

DynamicCam situation 006 does not use that cached signal. Its source condition
is:

`return not IsInInstance() and UnitAffectingCombat("player")`

Therefore P0095 measured the wrong signal for the G.2 context.

## Classification

Camera movement/restoration:
**PASS OUT OF COMBAT.**

In-combat camera capability:
**UNPROVEN.**

P0095 combat diagnostic:
**FAIL — WRONG CLASSIFICATION SOURCE.**

## Correction

P0096 samples live UnitAffectingCombat and live InCombatLockdown independently,
while retaining cached State.combat only as a diagnostic comparison.

Core state behavior is not changed by this repair.
