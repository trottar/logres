# P0249 — Repair quest reward visual instance dispatch

- Baseline: verified GitHub `main` `cfd67beb8c046668286df809b91b645f09acbe72` (P0248, `0.0.148-dev`).
- User evidence: `0.0.148-dev`, loadCount 326, both reward previews ERROR at `Dialogue.lua:1258` on a nil instance method. R2 was pushed but runtime FAILED; this is not a user-environment deferral.
- Cause: a new plain table returned by `Visual.New` had no metatable redirecting calls to `Visual:Reset` and `Visual:Present`.
- Correction: add `setmetatable(..., { __index = Visual })`; keep all read-only reward features and Blizzard stock controls unchanged.
- Regression guard: new static instance-contract checker; focused standalone Lua-stub simulation performed on prepared RewardVisual.lua.
- All full repository static checks run twice (shadow and actual) in the one-time applier, plus `git diff --check`, before generating the manifest.
- Runtime **UNVERIFIED** until Phase F Reward Preview: Single / Multiple both run without Lua errors; real multiple rewards remain environmentally deferred.
- Failures P0248 R0 nonunique anchor, R1 61-local budget, and R2 nil-instance-method must all remain historically recorded.

## P0250 follow-up runtime observation

P0249 `aaee288` was deployed; user-provided `0.0.149-dev`, load328 diagnostics show both `/logres questrewardpreview single` and `multi` PASS and two screenshots show the actual rendered item cards. This closes **P0249 synthetic preview method-dispatch validation**, not natural guaranteed or selectable quest reward parity. The original P0248 runtime error remains documented above; see `docs/memory/evidence/P0250_REWARD_PREVIEW_RUNTIME_ACCEPTANCE.md`.
