# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.2.**

P0095 is verified pushed at:
`b65ea1af`.

Current pushed runtime:
`0.0.39-dev`.

P0096 runtime target:
`0.0.40-dev`.

G.2 source review:
**PASS.**

P0095 runtime:
- two primary-path camera movements PASS;
- DynamicCam disabled;
- target/movement/restoration PASS;
- no secret/error result;
- both runs reported `combat=false`.

Classification defect:
P0095 used cached `Logres:GetState().combat`, which is an event-refreshed
`InCombatLockdown()` observation and is not DynamicCam's World (Combat)
predicate.

DynamicCam situation 006 uses:
`UnitAffectingCombat("player")`.

P0096 makes the probe report four distinct facts:
- `combat`: live UnitAffectingCombat;
- `lockdown`: live InCombatLockdown;
- `cachedCombat`: Logres state;
- `mismatch`: live combat versus cached combat disagreement.

Core state semantics are not changed by P0096.

Next proof:
one reversible probe with `combat=true` while naturally fighting.

User performs all commits/pushes.
