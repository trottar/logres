# P0150 — Class / Pet / Special-Control Read-Only Runtime Probe

Date: 2026-10-05
Baseline: `dbe468f7994a947e9e350e0f66b214679bd110f5`
Candidate runtime: `0.0.73-dev`
Result: **PREPARED — READ-ONLY RUNTIME PROOF REQUIRED**

## Purpose

Runtime-test the P0149/D-044 source families in the player's natural current state without taking production ownership or mutating Blizzard controls/presentation.

## Probe

Adds `Logres/HUD/ClassPetSpecialProbe.lua`, an auto-enabled diagnostic module with bounded reads for:
- pet-action-bar presence and at most ten slots;
- stance/form count, state, and cooldowns;
- bounded totem state;
- current player class, primary power, class-specific discrete resource candidate, charged points where applicable, and Death Knight rune cooldowns only when naturally class-applicable;
- possess, vehicle, override, temporary-shapeshift, and extra-action mode flags/indexes.

All external values flow through secret-first sanitization before nil/type/value inspection. Charged-point tables use fixed-index reads; they are never counted or iterated before secrecy is resolved.

## Invalidation

The probe uses source-owned pet, shapeshift, totem, rune, unit-power, special-action-bar, specialization/talent, and world events. Event payloads are discarded; current state is re-queried.

High-frequency unit-power invalidation refreshes only the resource domain rather than re-reading every domain.

## Non-mutation contract

P0150 does not call or use:
- `CastPetAction`;
- `TogglePetAutocast`;
- `PickupPetAction`;
- `CastShapeshiftForm`;
- `DestroyTotem`;
- action-page/state-driver mutation;
- `VehicleExit`, taxi early landing, or possession cancellation;
- override/extra-action invocation;
- Blizzard frame hide/alpha/parent mutation;
- polling/timers.

Stock PetActionBar, StanceBar, TotemFrame, RuneFrame, PetFrame, alternate-power, possess/override/vehicle, and extra-action surfaces remain untouched.

## Diagnostic integration

Adds `/logres classpetspecialprobe` and Phase-H developer-panel action **Class / Pet / Special Probe**.

The contextual probe is intentionally excluded from `Run All`. Runtime validation runs the probe manually and then runs `Run All` separately.

## Acceptance

Observed scope passes when the probe initializes/enables, required APIs/event registrations are present, manual capture completes with zero probe failures, secret values are safely skipped, and the separate integrated `Run All` remains clean.

Environmental absence is DEFERRED, not failure. No production ownership follows from this probe alone.
