# P0132 Production Offer Controls — Runtime PASS / Visual Order Correction Required

Date: 2026-10-05
Status: **RUNTIME + CONTROL PASS; VISUAL ORDER DEFECT**
Runtime: `0.0.64-dev`
Durable commit: `671f9836c43f3a4c9755f296ccad4a9574a62848`

## Runtime evidence

The tested Forever client loaded Logres `0.0.64-dev` at load count 148.

Deterministic preview:
- `Quest Dialogue Preview`: PASS;
- `Quest Offer Controls Check`: PASS;
- preview control clicks remained `preview-only`;
- no production mutation path was entered.

Production Decline:
- `probeSource=production`;
- `probeState=event-confirmed`;
- `probeEvent=QUEST_FINISHED`;
- `probeCallOK=true`;
- `probeReported=true`;
- `probeSuccess=true`;
- no probe error.

Production Accept:
- `probeSource=production`;
- `probeState=event-confirmed`;
- `probeEvent=QUEST_ACCEPTED`;
- `probeIdentity=matched`;
- `probeCallOK=true`;
- `finishedObserved=true`;
- `probeReported=true`;
- `probeSuccess=true`;
- no probe error.

Integrated `checkall` completed cleanly on `0.0.64-dev`, including
`questoffercontrolscheck`.

No Lua, secret-value, taint, protected-action, wrong-quest mutation,
double-mutation, or Blizzard-fallback failure was observed in the tested scope.

## Manual visual result

The user confirmed:
- the Logres controls work;
- the Blizzard quest box remains visible/usable as intended;
- the Logres control order is opposite Blizzard's simultaneous fallback order;
- specifically, Logres Accept is on the right instead of Blizzard's left-side
  position.

This is confusing while both control surfaces are visible.

## Classification

**P0132 functional/runtime behavior passes.**

**P0132 visual order requires correction before the offer-control presentation is
accepted.**

The defect is strictly positional:
- current Logres order: Decline left / Accept right;
- desired alignment while Blizzard fallback remains visible: Accept left /
  Decline right.

No mutation semantics or capability assumption is changed.

## Corrective decision

P0133 will swap only the horizontal positions:
- Accept -> left;
- Decline -> right.

The existing labels, colors, click handlers, exact-offer binding, mutation
routing, final-page gating, preview-only behavior, and Blizzard-visible fallback
remain unchanged.

A static contract must preserve the aligned left/right order so later visual
refactors do not reintroduce conflicting motor memory while stock fallback is
simultaneously visible.

## Retest gate

P0133 requires a narrow visual/integration retest:
1. deterministic preview final page shows Accept left / Decline right;
2. real quest offer shows the same Logres order;
3. Blizzard offer controls remain visible and the relative order now matches;
4. `Quest Offer Controls Check` passes;
5. `Run All` passes.

Repeating real Accept / Decline mutation is not required solely for this positional
correction because the click handlers and mutation route are unchanged.
