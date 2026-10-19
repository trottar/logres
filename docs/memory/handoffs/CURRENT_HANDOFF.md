# Current Handoff — P0259 accepted modularity-first NPC sequence

Authority: `docs/memory/CURRENT.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`, `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/evidence/P0259_NPC_MODULARITY_SEQUENCE.md`.

Verified GitHub `main` `edec5eb` (P0258). User accepts the P0258 Multiple reward preview visual. **Scope is ALL NPC interactions**, not just quest/gossip. Focus first on extracting existing accepted Logres UI components; create a shared NPC session/camera handoff architecture that keeps DynamicCam framing and transitions smooth, while selecting the lightest safe treatment for each NPC: native-backed styling/placement, hybrid Logres shell plus Blizzard transactions, or custom supported interaction. No assumption that banks/auction houses should be replaced; defer that decision until after modularity and capability analysis. Maintain D-046 P-tab preview-before-live rule for ALL Logres surfaces.

**Required order:** (1) P0259 memory docs-only; (2) P0260 full source modularity audit (no speculative code); (3) incremental evidence-led extraction and regression-tested modularity fixes; (4) post-extraction all-NPC feasibility reranking. Preserve Blizzard controls on unsupported/protected states. Claim flash remains OPEN, live selectable rewards remain unverified, quest 237 reserved, unrelated gameplay bugs open/details pending. No new DynamicCam profile needed merely to audit.

Next: user applies, commits and pushes P0259; verify remote main before starting P0260. **No WoW deploy for this patch.**
