# P0152 R8 — Presentation/Default-On Delivery Marker Failure

Date: 2026-10-06
Durable HEAD: `b62397b116cf028326167b7f8bf7010ed94f3717`
Classification: **DELIVERY FAILURE — REFUSED BEFORE TRACKED WRITES**

## Attempt

R8 avoided overwriting the active P0152 shared-button implementation and attempted
to add a separate pet-state presentation/default-on overlay.

## Observed result

The applier refused before tracked writes while validating
`Logres/HUD/PetActionExecutionProbe.lua`:

`RuntimeError: PetActionExecutionProbe.lua: missing required fragment: petactionexecprobe`

The baseline assertion was wrong. The command token belongs to the command-routing
surface; it is not a valid required marker for the probe implementation itself.
The current candidate's `Commands.lua` route had already passed the R8 baseline
check before this refusal.

## Disposition

**CLOSED as a delivery path.** R9 removes content assumptions about the uncommitted
probe implementation and validates only the candidate surfaces actually required
for the overlay: probe file presence, command-route presence, runtime version, and
TOC placement.
