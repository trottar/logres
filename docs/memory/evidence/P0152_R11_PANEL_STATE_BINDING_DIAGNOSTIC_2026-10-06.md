# P0152 R11 — Panel State-Binding Diagnostic Result

Date: 2026-10-06
Runtime candidate: `0.0.74-dev`
Durable HEAD while testing: `b62397b116cf028326167b7f8bf7010ed94f3717`
Classification: **TARGETED DIAGNOSTIC PASS / PRESENTATION BINDING DEFECT IDENTIFIED**

## Observed panel result

Phase H **Pet State Diagnostic** reported `module=true`, `tracked=46`, `pet=0`,
`readable=0`, `activeIndicators=0`, and `autocastIndicators=0`. Default-on dispatch
reported `armAttempts=2`, `armDispatches=2`, `armPending=false`, latest trigger
`UNIT_PET`, and `armResult=arm-command-dispatched`. The execution probe itself was
`configured=true`, `armed=true`, and `visible=true`.

The first ten tracked buttons — the visible ten-slot pet cluster — reported raw generic
`type=nil` / `action=nil`; later shared action clusters retained ordinary action
attributes. The supplied runtime screenshot simultaneously showed the pet cluster
visible but without an obvious active-command or autocast treatment.

## Diagnosis

The presentation module correctly intercepted the shared button factory and the
default-on lifecycle successfully made the pet cluster visible. The defect is narrower:
presentation classified pet buttons only from raw generic `type` and `action`
attributes, while the working secure click path uses modified/click-specific secure
attributes. That left the first ten pet buttons tracked but unclassified.

Pinned Forever source (`Gethe/wow-ui-source@a84e2b1`) resolves secure action type and
pet action slot through `SecureButton_GetModifiedAttribute`, including the physical
button suffix. R12 mirrors that resolution for addon-owned presentation reads and
secret-checks/type-checks returned values before branching.

## Disposition

Default-on behavior is **observed working for this test**. Persistent pet state
presentation remains **FAIL / OPEN** until the effective-binding correction is
visually verified.
