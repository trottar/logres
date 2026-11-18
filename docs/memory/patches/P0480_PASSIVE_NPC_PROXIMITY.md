# P0480 — Restore NPC 3/4-yard proximity without hard target

Baseline P0479 `7f6f2a2` (verified). Source and memory patch only; no GitHub
write. Add ordinary `softinteract` and event-observed `nameplateN` proof to
existing P0477 guard. Preserve P0479 text/style, P0478/P0477 negative
results, quest/stock fallback and protected state. Runtime unverified.
See `docs/memory/evidence/P0480_PASSIVE_NPC_PROXIMITY.md`.
