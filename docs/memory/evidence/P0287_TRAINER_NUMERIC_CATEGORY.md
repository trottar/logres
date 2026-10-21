# P0287 — Forever trainer category is numeric, not the documented string

Status: **OBSERVED NUMERIC TYPE / CATEGORY SEMANTICS OPEN / LIVE ADAPTER DEFERRED**.
Baseline: verified GitHub `main` P0286 `cb8b7567f843a4250d92f19ec74d62291f23a0c3`.

## Runtime evidence — user diagnostic, 2026-10-21

With an ordinary open trainer, WoW Forever 1.60.1 and Logres `0.0.187-dev`, the H Native Service Frame Audit reported:

```
Logres trainer service source: service-row-shape-deferred (total=1 selected=1 walletCopper=12058 sampled=1/12 ... mutations=0 purchases=0 geometryWrites=0)
Logres trainer service row: id=1 state=unexpected-service-shape category=unavailable name=Enchant Chest - Minor Absorption subText= costCopper=unavailable icon=unavailable
Logres trainer service shape: id=1 nameType=string subTextType=string categoryType=number expandedType=number categoryValue=unavailable
```

The exact service name and 12,058 copper were read without unsafe inspections or mutations. The `unavailable` category in P0286 was a placeholder from its formatter, **not a Blizzard category observation**. The numeric value was not logged, and no semantic mapping of category numbers was proven. This patch records the raw category number without interpreting it.

## Source contrast

Warcraft Wiki API GetTrainerServiceInfo describes string category values `header`, `available`, `unavailable`, and `used`. This client's observed third return is a **number**, so copying the published string branch into a live adapter was incorrect in this environment. This is a measured difference, not proof that any particular numeric enum value equals an eligibility status. Class Trainer Plus, ElvUI and Aurora remain technique references only; no third-party implementation copied.

References:
- https://warcraft.wiki.gg/wiki/API_GetTrainerServiceInfo
- https://github.com/tukui-org/ElvUI/blob/main/ElvUI/Game/Shared/Skins/Trainer.lua

## P0287 scope and safety

Keep P0286's gate: a normalized open trainer, out of combat, visible unprotected native root, bounded 12-row sampling and an `ordinary()` check on **all four tuple values before type, comparison or formatting**. On a nonsecret integral category in [0,255], record `rawNumericCategory` and label the row `numeric-category-unclassified`. Collect only bounded ordinary name, subtitle, optional read-only cost and icon presence. `expanded` is recorded only when it is an ordinary bounded integer. Retain Classic string categories as a separate path. Any numeric-unclassified row keeps the whole source status `service-row-shape-deferred`. Never claim an unknown numeric row is trainable, known, unavailable, a header, or selected solely from the value.

**NO NATIVE MUTATIONS:** no filter/selection/training call, row click, geometry changes, hooks, polling or UI suppression. Blizzard owns Train, money/filter behavior and stock fallback; portrait-free P0284 visual acceptance unchanged. Probe remains one-shot H → Native Service Frame Audit. Rerun client H diagnostic when convenient. The numerical values (not merely their types) will determine whether an independent source-backed mapping can be proven; another trainer/state may be needed to establish semantic classes, but do not manufacture gameplay solely for it.

### Negative results preserved

P0285 `unexpected-service-shape` (client) and P0286 `service-row-shape-deferred` (client) are OPEN and remain part of the project evidence. This patch does not retroactively convert either into a PASS; P0287 is **PREPARED / WSL AND WOW UNVERIFIED** until applied and tested. Exact enum semantics, sorted/filtered index stability, dynamic row ownership and live training controller remain DEFERRED.

## P0287 R0 PREWRITE failure — historical checker runtime-version pin (2026-10-21)

**Observed user WSL failure / NO TRACKED WRITES:** The P0287 R0 ZIP checksum verified, its applier accepted the exact P0286 baseline, and PREWRITE executed 158 checkers. Exactly one checker failed: `check_checker_version_policy.py` identified the new `tools/check_p0287_numeric_trainer_category_contract.py` because its evidence-string assertions included an exact historical runtime version. The failed checker policy reported one historical version pin. The applier refused before writing tracked files, so no new runtime behavior was tested. This is an assistant-created test/packaging defect, not a repository problem, and is **CLOSED as a checker-policy defect in P0287 R1 only after R1 WSL checks pass**. Until then R1 remains PREPARED/UNVERIFIED.

**R1 correction:** The P0287 feature checker now tests for the client family `Forever 1.60.1` rather than hard-coding a Logres development runtime version. Existing evidence still preserves the exact version for historical context. The R1 applier also performs an explicit version-literal preflight on its bundled feature checker before attempting the full PREWRITE suite. The runtime probe, API sampling logic, no-transaction restriction, and raw-number handling are unchanged. The full suite and in-game test are pending.
