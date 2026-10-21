# P0286 — Forever trainer service row schema rejected at runtime

Status: **OPEN / DEFERRED — SCHEMA UNKNOWN; NO LIVE ADAPTER AUTHORIZED**. Observed on 2026-10-21.
Verified pushed GitHub `main` P0285 `bbc9045355b44f45835ba32904e9b56d9e618d10` at time of review.

## Actual client evidence (user `LOGRES_DIAGNOSTICS_LATEST.lua`)

`Logres 0.0.186-dev`, WoW Forever 1.60.1 (interface 16001), trainer interaction `true/7`, visible unprotected native `ClassTrainerFrame`.
Latest **H — Native Service Frame Audit** returned:

```
Logres trainer service source: read-only-service-sample (total=1 selected=1 walletCopper=12058 sampled=1/12 countAPI=present infoAPI=present costAPI=present iconAPI=present filterRead=present filterWritePresent=present selectionWritePresent=present purchasePresent=present mutations=0 purchases=0 geometryWrites=0)
Logres trainer service row: id=1 state=unexpected-service-shape category=unavailable name=unavailable subText= costCopper=unavailable icon=unavailable
```

`GetNumTrainerServices` returned an ordinary bounded integer 1; `GetTrainerSelectionIndex` returned 1, and `GetMoney` returned 12058 copper. Those results independently demonstrate source availability for **this one client session**, but **do not establish that the row is valid or that service counts generalize**. The P0285 row gate rejected the tuple. Its `snapshotRow` validates a bounded string name and a `category` in the Classic set `header`/`available`/`used`/`unavailable`. Crucially, it does **not** report tuple type shape, so the cause could be a table-valued first result, unknown category, nil name or another ordinary-but-unexpected return shape. **No particular cause is established.** No native writes or purchases were observed.

## Narrow P0286 investigation

Retain the exact read-only on-demand H action, trainer-open/ordinary/unprotected/out-of-combat gates, the bounded first 12 samples, and the already successful source data. On `unexpected-service-shape` ONLY after all returned values independently pass `ordinary()`, record their Lua type names and a short sanitized category string if one exists. Do not iterate a returned table, dereference nested or unknown keys, inspect secret-capable values or guess alternate native method signatures. Return `service-row-shape-deferred` when any row was rejected, rather than implying a usable data sample. The user must run H — Native Service Frame Audit again with an ordinary open trainer, export diagnostics and inspect the `Logres trainer service shape` line. No screenshot or trainer purchase required; H native skin remains off.

## Negative result, constraints and next gate

P0285 source-row interpretation **FAILED / OPEN** on the observed client even while frame and API presence gates passed. The previously accepted P0284 preview and the P0285 native control mapping are unaffected. P0286 is **PREPARED / WSL AND WOW UNVERIFIED**; it deliberately does not convert a rejected service into a fake valid row or dispatch any action. A new live data adapter, UI replacement, filter write or transaction controller is **DEFERRED** until the exact in-client shape is observed. **NO NATIVE MUTATIONS** are introduced in P0286. No third-party code is copied.
