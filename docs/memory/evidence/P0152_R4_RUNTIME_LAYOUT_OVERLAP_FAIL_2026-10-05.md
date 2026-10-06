# P0152 R4 Runtime Layout Overlap Failure — 2026-10-05

Status: **REAL RUNTIME USABILITY / LAYOUT FAILURE — R5 CORRECTION REQUIRED**
Runtime: `0.0.74-dev`

## Observation

After R4 fixed the shared-action dependency load order, the pet row rendered with the established Logres action-button presentation, but it was positioned directly over the existing player action clusters. The user could not reliably click the pet buttons because the temporary probe and production action controls occupied the same screen region.

## Cause

`PetActionExecutionProbe` reused `ActionButton.CreateCluster` correctly but placed its single-row cluster at `y=-190`. The existing Secondary/Utility clusters are centered at `y=-260` with four rows, so their upper row occupies the same vertical region. Primary also extends upward into that area.

## Classification

**REAL P0152 RUNTIME USABILITY / LAYOUT FAIL.**

The secure pet-action path is not disproven. R4 established that the shared action infrastructure loads and renders. The failure is temporary-probe placement only.

## R5 correction

Keep the R4 shared-action adapter unchanged and move only the temporary pet row to `y=-120`, above the established bottom action clusters. Add a static placement contract so the probe cannot silently drift back into the player-action region.

Stock PetActionBar remains visible and usable. No ownership scope expands.
