# P0265 — four NPC option interaction families in one patch

Baseline: pushed main `6b3ed96` P0264. Status at packaging: PREPARED / FULL WSL STATIC AND WOW RUNTIME UNVERIFIED.

One guarded checkpoint: source-independent NPC option model, shared two-column paginated option view, preview-only session/controller with branching/back and explicit native gating, four P-tab scenarios including services and locked states, debug readout, gallery inventory updates, version synchronization, durable memory. No Blizzard action, service transaction, stock suppression, quest claim or camera change. See `docs/memory/evidence/P0265_NPC_OPTION_SESSION.md`. Preserve P0264 R0/R1 static delivery failures and native claim flash as prior negative evidence.

R0 failed prewrite static validation (1/132), specifically P0263 historical visual TOC adjacency. R1 preserves the historic three-file order by placing the new visual before NarrativePages; adds its own preflight contract. Failure remains in evidence. Client remains unverified until tested.
