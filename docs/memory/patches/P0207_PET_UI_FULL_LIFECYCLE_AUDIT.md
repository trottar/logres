# P0207 — PetFrame + PetActionBar full lifecycle audit

Checkpoint date: 2026-10-13. **DOCS ONLY.** Parent pushed baseline: P0205 `79a8e2308a37135b61db8ad8a0433cae5ec8b4bd`. Local uncommitted P0206 R6 is `0.0.112-dev`, runtime FAIL / INTERMITTENT. No existing P0206 implementation is accepted or pushed by this checkpoint.

Canonical evidence: `docs/memory/evidence/P0207_PET_UI_FULL_LIFECYCLE_AUDIT.md`. Exact Forever 70338 PetFrame/PetActionBar/Blizzard Edit Mode source and user-uploaded diagnostics were audited. R6's `petActions:stock` does not imply a visible pet action bar, whereas `petFrame:folded` confirms continuing Logres native unit-frame ownership, despite incomplete unit feature replacement. Saved `shown` tokens are opaque restore inputs, not native lifecycle state proofs. Edit Mode and PET control can trigger temporary reappearance but causal event unknown. P0197 combat duplicate and R2–R6 restoration failures remain OPEN.

**Next:** one narrow fail-open runtime checkpoint releasing **both** native pet domains independently, preserving secure stock fallback and 18 Phase H actions, with explicit independent source/visual runtime validation. P0207 makes no runtime changes; no WoW redeploy is required.
