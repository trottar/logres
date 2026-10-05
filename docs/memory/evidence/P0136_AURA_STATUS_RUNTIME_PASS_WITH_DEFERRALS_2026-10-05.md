# P0136 Aura / Status Runtime Probe PASS With Environmental Deferrals — 2026-10-05

Status: **RUNTIME PROBE PASS WITH ENVIRONMENTAL DEFERRALS**
Runtime: `0.0.66-dev`
Git baseline: `b69eb109ab9d65477414e66864fef484c244eabc`

## Preserved tooling history

The initial P0136 applier failed and rolled back because the new static checker
matched API-presence references rather than the actual predicate/query pcall
sites.

P0136 R1 corrected only those checker landmarks. Runtime probe behavior was
unchanged.

Canonical failure evidence:
`P0136_INITIAL_APPLIER_STATIC_CONTRACT_FAILURE_2026-10-05.md`.

## Client / runtime

Observed diagnostic state:
- interface `16001`;
- client `1.60.1`;
- build `70205`;
- Logres load count `152`;
- runtime `0.0.66-dev`.

No Lua, secret-value, taint, protected-action, or Blizzard-aura-surface regression
was reported by the user.

## Probe 1 — player present, target unavailable

`Aura Status Probe`:
- PASS;
- capture=true;
- failures=0;
- secretSkips=0;
- secretFields=0;
- targetAvailable=false.

Player `HELPFUL`:
- one ordinary aura: `Demon Skin`;
- no secret index/predicate/payload;
- no failures.

Player `HELPFUL|PLAYER`:
- one ordinary aura: `Demon Skin`;
- no secret index/predicate/payload;
- no failures.

For the ordinary helpful payload, the probe recorded ordinary/non-secret metadata
for:
- name;
- icon;
- stacks/applications;
- dispel field;
- duration;
- expiration;
- source;
- stealable flag;
- spell ID;
- boss-aura flag;
- player-origin flag;
- active-player-dispel flag.

Player `HARMFUL`, `HARMFUL|CROWD_CONTROL`, and `HARMFUL|RAID` were empty.

Target was absent and correctly classified DEFERRED.

## Probe 2 — target available

`Aura Status Probe`:
- PASS;
- targetAvailable=true;
- failures=0;
- secretSkips=0;
- secretFields=0.

Player helpful evidence reproduced unchanged.

Target scans all completed safely but were empty:
- `HELPFUL`;
- `HARMFUL`;
- `HARMFUL|PLAYER`;
- `HARMFUL|CROWD_CONTROL`;
- `HELPFUL|DISPELLABLE`;
- `HELPFUL|IMPORTANT`;
- `HELPFUL|BIG_DEFENSIVE`.

This proves the target-unit query path can execute safely in an ordinary empty
state, but it does not prove populated target-aura metadata.

## Integrated regression

Post-probe `Run All` completed on `0.0.66-dev` with every recorded integrated
check PASS.

The contextual aura probe remains intentionally excluded from `Run All`.

## Capability classification

### PASS

- P0136 event-driven probe lifecycle and developer integration;
- player/target unit-availability handling;
- bounded indexed scanning;
- ordinary/non-secret player `HELPFUL` payload;
- ordinary/non-secret player `HELPFUL|PLAYER` payload;
- selected helpful metadata fields listed above;
- safe empty target-category scans;
- integrated regression suite.

### DEFERRED — environmental absence

No populated runtime aura was available for:
- player `HARMFUL`;
- player `HARMFUL|CROWD_CONTROL`;
- player `HARMFUL|RAID`;
- any tested populated target category.

These are DEFERRED, not FAIL.

### DEFERRED — branch not encountered

No runtime secret aura index, secret predicate result, secret payload, or secret
selected field was encountered.

The secret-skip implementation remains statically contracted, but that branch is
not classified runtime PASS from this evidence.

## Ownership consequence

P0136 does **not** authorize broad player or target aura replacement.

The only populated production data category proven ordinary in this checkpoint is
player helpful status, including player-origin helpful status.

Accordingly, the next production slice may use only that proven category and must
retain Blizzard player aura presentation as completeness fallback.

Player harmful/urgent status remains stock-backed until populated ordinary evidence
exists. Target status remains stock-backed and separately gated by both populated
aura evidence and world-target placement proof.

## Next work item

**P0137 — production player helpful aura presentation, using only runtime-proven
ordinary player helpful data and retaining Blizzard player aura presentation as
visible/completeness fallback during proof.**

P0137 must not suppress stock buffs, must not infer harmful/target capability from
P0136, and must remain fail-open.
