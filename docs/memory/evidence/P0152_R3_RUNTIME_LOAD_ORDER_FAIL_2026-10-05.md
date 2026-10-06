# P0152 R3 Runtime Load-Order Failure — 2026-10-05

Status: **REAL RUNTIME LOAD / INTEGRATION FAILURE — R4 CORRECTION PREPARED**
Runtime: `0.0.74-dev`
Durable baseline HEAD: `b62397b116cf028326167b7f8bf7010ed94f3717`

## Observed failure

On the first `/reload` after applying/deploying P0152 R3, WoW raised:

`PetActionExecutionProbe.lua:417: attempt to index upvalue 'ActionButton' (a nil value)`

The stack reached `PetActionExecutionProbe:OnInitialize`, `Core/Modules.lua`, `Core/Lifecycle.lua`, and `Core/Bootstrap.lua`. No pet-action runtime validation was performed after this load failure.

## Cause

P0152 R1 had inserted `HUD\PetActionExecutionProbe.lua` before `Actions\Button.lua` in `Logres.toc`. R3 correctly rewrote the probe to reuse `Logres.ActionButton`, but retained that old TOC order. Therefore the file-level `local ActionButton = Logres.ActionButton` captured nil before the shared action primitive was defined.

This violated the established action-infrastructure dependency and should have been caught statically.

## R4 correction

R4 changes only load order and its contract:
- `Actions\Button.lua`;
- then `HUD\PetActionExecutionProbe.lua`;
- then `Actions\Primary.lua`.

The existing shared-action pet adapter is otherwise unchanged. Stock PetActionBar remains fallback.
