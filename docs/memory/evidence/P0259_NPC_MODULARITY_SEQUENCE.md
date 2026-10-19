# P0259 — accepted NPC modularization sequence and presentation integration policy

Date: 2026-10-18. Verified repository `main`: `edec5eb6941706826e952d3776e6cec3cd2eb1c7` (P0258).

## User decisions accepted

The user accepted the four-stage progression: **memory update -> modularity audit -> modularity fixes -> post-modularity reassessment of realistic NPC goals**. The scope is **ALL NPC interactions**, not merely quest NPCs. Existing implementations span visual-difficulty tiers 1–5; the audit should separate what can be extracted from what requires native/protected transaction machinery.

The user additionally accepts a pragmatic, sometimes 'lazy' integration style **after modularity**: a vendor may retain Blizzard's fully working inventory/transactions while appearing in Logres's styling, positioning and transition context. Smooth interaction with DynamicCam and a consistent immersive NPC experience are more important than replacing every native screen. This is a visual-integration option, not permission to blindly copy/reparent a protected native frame.

The user suggests banks or auction houses may not be worth custom Logres replacement initially; this is a **candidate deferral**, not a permanent decision. Actual complexity, benefit and safety will be evaluated **after** reusable components and NPC-session infrastructure exist.

## Repository facts versus planned architecture

- Source-backed: D-035 governs quest interaction, D-046 governs **all** Logres visual preview-first implementations. `Quest/Dialogue.lua` supplies paging and offer/completion controls. `Quest/RewardModel.lua` and `Quest/RewardVisual.lua` share a model/view path. `Quest/OfferActionProbe.lua`, `Quest/CompletionControl.lua` and `Quest/OfferStockSuppression.lua` gate specific interaction scopes. `Dev/Panel.lua` hosts the P preview tab.
- Source-backed absence: there is no general merchant/bank/auction NPC presentation module in the current `Logres/` Lua tree. This audit and extraction have **not** happened yet. Camera ownership currently resides in separate camera modules; a universal NPC-session coordinator is a proposal, not shipped behavior.
- Runtime acceptance: user reports P0258 Multiple preview looks good, with preview parity accepted visually; do not infer actual selectable-item claim support or native restoration success. Quest 237 preserved.
- Negative/deferred: P0257 R0/R1 shadow-check failures remain in P0257 evidence. Native quest claim may briefly reveal Blizzard's frame; unresolved. Earlier 20-minute gameplay bugs were reported without individual evidence, so they remain open/unspecified.

## Next exact work item

After the user applies/commits/pushes P0259 and main is verified: **P0260 comprehensive current-code modularity audit**. Do not start refactoring on guesses. Produce a per-module dependency and behavior inventory, duplicate-component map, candidate boundaries, preview coverage gaps, camera/session lifecycle and stock-fallback invariants. Inventory every NPC family; separate visual reuse from guarded transactional capability. The resulting evidence dictates a narrow first extraction patch, then a *post-modularity* feasibility reassessment.

**P0259 is DOCS-ONLY.** No WoW deployment or gameplay test is relevant to the memory change. No runtime PASS is claimed.
