# P0190 — P0189 automatic Main normal-mode runtime acceptance

Date: 2026-10-11. User provided `LOGRES_DIAGNOSTICS_LATEST.lua` and reported **“pushed, all worked as expected.”** Verified remote `main` commit `bd0c36a2a98439b2332f78fb9c0cc58e67a5b3ef`, message `feat: auto-arm secure Main replacement in immersion`. Client `1.60.1`, build `70338`, `Logres 0.0.101-dev`, loadCount `239`.

## Exact diagnostic observations

| Step | Observed |
| --- | --- |
| Login `status` | `0.0.101-dev`, loadCount=239, normal world, combat=false |
| First `mainreplacecheck` without manual ON | `CANDIDATE`, `auto=true`, `optOut=false`, `armed=true`, `applied=true`, `route=true`, `driver=true`, `1/0`, `error=nil` |
| `mainreplace off` | `STOCK`, `auto=true`, `optOut=true`, `armed=false`, `applied=false`, `route=false`, `1/1`, `error=nil` |
| Immersion OFF → ON | Commands present; no intervening maincheck. Retained opt-out supported by user confirmation rather than direct snapshot |
| `mainreplace on` | `CANDIDATE`, `optOut=false`, `2/1`, `route=true`, `error=nil` |
| Immersion OFF → ON again | Commands present; integrated checks follow |
| Phase 0 Run All | `mainreplacecheck CANDIDATE`, `auto=true`, `optOut=false`, `activations=7`, `restores=6`, `error=nil`; `actioncheck PASS`, Primary `12/12` keys/feedback; `checkall: complete` |
| UI Ownership Check | 35 rows; 17 PASS, 18 STOCK, 0 DEFERRED, 0 FAIL. Main row remains STOCK (fallback **policy**, not native visibility reading) |

No current-run Main secure-gate assertion, taint/Lua traceback, or failed integrated check is present in the exported diagnostics. The user visually accepts tested ordinary behavior. No evidence establishes a measured stock mouse-hit-box geometry or a direct special/combat/Edit Mode trace; no claim is made for those branches from this export.

## Decision

**ACCEPT P0189 for observed automatic normal Immersion ON ownership and tested OFF/ON/restoration cycle.** Conclude H.1 ordinary composition scope and advance H.2 layout geometry. Preserve native stock fallback for unowned/unsupported domains and secure special transitions; classify inaccessible special combat/vehicle/possess/override/form/petbattle as **ENVIRONMENTAL DEFERRALS** (not PASS). Edit Mode per user-general confirmation only; not a separately recorded diagnostic PASS. A later naturally observed runtime failure reopens the precise domain.

Historical failures remain durable: P0187 R0 secure re-arm regression, P0187 R1 delivery baseline hash rejection, P0188 R0 whitespace, P0182 ineffective filter-only aura, P0178 Lua 60-upvalue, P0175 nil row and post-loot ObjectiveTracker intermittence.
