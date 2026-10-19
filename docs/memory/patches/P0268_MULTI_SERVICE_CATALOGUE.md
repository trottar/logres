# P0268 — Shared service-catalogue interaction previews and header inset

- **Status:** PREPARED / WoW RUNTIME PENDING. Exact baseline P0267 pushed `8e1e6f8`.
- **Source:** `Quest/ServiceCatalogModel.lua` exposes four deterministic family fixtures; `Quest/Dialogue.lua` dispatches to same `NPCOptionSession` / `UI/OptionList.lua`; one gated `preview-confirm` path collects diagnostics; four P-tab actions. Existing native quest and camera files frozen.
- **Visual:** Back and Goodbye inset 45px, unchanged 24px vertical header rail. Captures user's P0267 screenshot requirement.
- **Safety:** fixture-only fictional prices/requirements; native merchant/trainer/taxi/gossip never called. Unsupported live capabilities remain stock-owned.
- **Validation:** guarded shadow static suite, postwrite check suite, git diff --check and exact ordered P/F/H/0 client actions. User commits/pushes; no Git changes by applier.
- **Negative results preserved:** P0265 services overlap and disappearing Back; P0266 misplaced Back/Farewell friction; P0267 residual corner art collision. No declaration of live NPC action support.
