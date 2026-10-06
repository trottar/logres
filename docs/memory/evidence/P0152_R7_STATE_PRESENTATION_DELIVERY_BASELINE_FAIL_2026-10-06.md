# P0152 R7 — Pet-State Presentation Delivery Baseline Failure

Date: 2026-10-06
Durable HEAD: `b62397b116cf028326167b7f8bf7010ed94f3717`
Classification: **DELIVERY FAILURE — REFUSED BEFORE TRACKED WRITES**

## Attempt

The first pet-state presentation correction attempted to edit the shared
`Logres/Actions/Button.lua` while assuming the durable P0151 blob was still the
working-tree baseline.

## Observed result

The applier refused before tracked writes:

- expected `Button.lua` blob: `4cc073052b25d7e368be6c669b46716181f503a5`;
- observed working-tree blob: `41a8f8077b5d866c7796a09d19157684650d73e9`.

The active uncommitted P0152 candidate already owned changes in the shared button
primitive, so overwriting it from the durable baseline would have risked destroying
working secure pet execution behavior.

## Disposition

**CLOSED as a delivery path.** Later correction overlays must preserve the current
P0152 `Button.lua` rather than replace it.
