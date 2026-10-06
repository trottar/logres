# P0150 — Class / Pet / Special-Control Read-Only Runtime Probe

Date: 2026-10-05
Baseline: `dbe468f7994a947e9e350e0f66b214679bd110f5`
Candidate runtime: `0.0.73-dev`
Result: **INSTALLED / PUSHED — R3 RUNTIME PASS FOR OBSERVED READ-ONLY SCOPE WITH ENVIRONMENTAL DEFERRALS (`46e06295`)**

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

## Initial runtime result — preserved failure

The first `0.0.73-dev` client run reached the probe and all 22/22 event registrations, with the required API set present. The manual capture failed with `failureCount=6`. All six failures came from the probe forcing `GetPetActionInfo(...).isToken` to boolean while Forever returned numeric values for those rows (`lastFailure=pet.isToken:unexpected-number`).

Observed context also established useful non-failure evidence:
- pet action bar present, 10 slots scanned, 7 occupied;
- stance/form count 0 — environmental absence;
- 8 totem slots scanned, no active totems — environmental absence;
- Warlock / SoulShards resource path populated with one safely skipped secret primary-power value and zero resource failures;
- all special-mode flags were ordinary `false`;
- separate integrated `Run All` completed cleanly.

The summary header incorrectly displayed the ordinary false special-mode values as `nil` because `GetDebugStatus()` used Lua `and/or` extraction. The detailed special line correctly showed the values as false.

Classification: **P0150 PROBE-CONTRACT RUNTIME FAIL; NO PRODUCTION/MUTATION FAILURE OBSERVED.**

## Correction history

The first R1 correction artifact expected pre-P0150 HEAD `dbe468f7`. Because the initial P0150 implementation had already become durable at `c7ea3638`, that applier correctly refused before any tracked write.

R2 correctly rebased to durable P0150 `c7ea3638` but then refused before tracked writes because its baseline validator required the raw command token `"classpetspecialprobe"` to occur exactly once. The correct `Commands.lua` contains that token twice by design: command dispatch and developer-panel registration. This was an artifact-validator defect, not repo or runtime evidence.

R3 remains based on durable P0150 `c7ea3638`, keeps runtime `0.0.73-dev`, and changes only diagnostic interpretation/presentation:
- `isToken` is sanitized as an opaque secret-first value rather than assuming a boolean type;
- special-mode debug extraction preserves ordinary `false` instead of collapsing it to `nil`;
- the static checker now enforces both corrections.

No API, event, mutation, ownership, suppression, or polling scope changes. Retest the same Phase-H probe and then run `Run All` separately.

## R3 runtime acceptance

P0150 R3 is durable at `46e06295695587af07f6f3e1b4a6ac4ace4e4c15` and passes
on `0.0.73-dev` / client `1.60.1.70235` for the observed read-only scope.

Accepted result:
- 22/22 expected event registrations;
- required APIs present;
- PetActionBar present, 10 slots scanned / 7 occupied;
- pet-domain failures 0;
- one Warlock primary-power value secret-skipped safely;
- resource-domain failures 0;
- ordinary false special-mode flags preserved;
- total probe failures 0;
- separate integrated Run All PASS.

Stance/forms, active totems, DK runes, active special modes, and meaningful nonzero
class-resource presentation remain environmental DEFERRED.

P0151 records matching-build source continuity and opens P0152 secure pet-action
execution proof. P0150 read proof alone does not authorize stock suppression.
