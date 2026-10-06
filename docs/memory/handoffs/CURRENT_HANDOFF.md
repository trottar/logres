# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0150 initial implementation `c7ea363842351f766527a16192a3e2e6535f579e`.

Current pushed/tested runtime:
`0.0.73-dev` — initial probe run failed on an isolated diagnostic contract.

## Active work stream

**P0150 R3 — correct the durable read-only class/pet/special-control probe contract on `0.0.73-dev`.**

P0149/D-044 resolves the exact Forever source/fallback layer. Pet secure `type="pet"` casting is source-plausible but does not complete PetActionBar ownership; stance/totem mutations remain gated; discrete class resources remain secret-first and non-percentage by default; PetFrame and integrated possess/override/vehicle/extra-action surfaces remain stock.

P0150 adds only `ClassPetSpecialProbe` plus developer-panel/diagnostic integration. It reads bounded current state and source-owned invalidation events. It does not cast, mutate, suppress, page, exit, dismiss, reorder, or alter autocast.

Secret observations are counted/deferred safely. Environmental absence is DEFERRED. The contextual probe is not part of `Run All`; run the probe manually, then run `Run All` separately.

Initial runtime failed only inside the diagnostic contract: Forever returned numeric `GetPetActionInfo(...).isToken` values on six rows, while the probe required boolean. All special-mode detail flags were ordinary false, but the summary collapsed them to nil through Lua `and/or`. One Warlock primary-power value was safely secret-skipped; the resource domain had zero failures. Separate `Run All` passed.

R3 keeps `0.0.73-dev`, treats `isToken` as opaque secret-first value data, preserves false special-mode summary values, and changes no mutation/ownership scope. R1 correctly refused before writes because it expected `dbe468f7` after P0150 was already durable at `c7ea3638`. R2 also refused before writes because it incorrectly asserted the raw command token `"classpetspecialprobe"` was unique; it legitimately appears in both dispatch and developer-panel registration.

P0148 waypoint depth remains accepted. Navigation deferrals/blockers and Camera freeze remain unchanged.

## Runtime proof

After deployment and `/reload`:
1. apply/deploy P0150 R3, then Phase H -> **Class / Pet / Special Probe**;
2. preserve its summary/detail lines;
3. Phase 0 -> **Run All**;
4. upload refreshed diagnostics.

Any Lua/secret/taint/protected-action/mutation failure is a real failure. Do not manufacture missing pet/form/totem/rune/vehicle states solely to close deferrals.

## Key references

- `../CURRENT.md`
- `../decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `../evidence/P0149_CLASS_PET_SPECIAL_CONTROL_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`
- `../evidence/P0150_INITIAL_RUNTIME_FAIL_2026-10-05.md`
- `../investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `../patches/P0150_CLASS_PET_SPECIAL_CONTROL_READ_ONLY_PROBE.md`
- `../decisions/D-026_SELECTIVE_UNIT_FRAME_SUPPRESSION.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
