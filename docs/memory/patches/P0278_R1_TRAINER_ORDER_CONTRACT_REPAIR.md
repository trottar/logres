# P0278 R1 — trainer order contract reconciliation

Status: PREPARED; runtime and complete in-repository static validation pending.

Baseline: exact pushed main P0277 `f042f311ba01e9b498c9abb2e0295d60e3e3a3b6`. Supersedes failed prewrite P0278 R0 without requiring an R0 installation or resetting any local user changes. Diff: original P0278 runtime/source/memory changes plus one backward-compatible historical checker change and preserved negative result. P0278 R0 prewrite check 109/146 failed literal TOC adjacency despite intentional new module between audit and skin. R1 changes only checker chronology; P0278 own checker enforces motif load order. All checks and WoW proof remain pending WSL/client.

See `docs/memory/evidence/P0278_R1_PREWRITE_ORDER_FAILURE.md`.
