# D-047 — Modularize first; selective NPC integration and camera continuity

**Status:** ACCEPTED project direction, 2026-10-18. This complements D-035 (quest-interaction ownership) and D-046 (preview-first UI pipeline). It does not authorize any new native/protected mutation.

## Goal and scope

- The review covers **ALL NPC interaction families**, not just quests or quest-related gossip. Include ordinary dialogue, branching gossip, merchants/vendors/buyback/repair, trainers, innkeepers, travel/flight, spirit healers, stables, banks, guild services, auctions, PvP, appearance/transmog, profession services, event/scripted/custom NPCs, and capability-dependent Forever-specific interactions. The eventual feasibility audit must distinguish source-proven features from conjectural/unavailable services.
- The player-facing priority is **smooth NPC interaction**, visual continuity, and **DynamicCam camera/session consistency**, not indiscriminate replacement of Blizzard's working interfaces. Different NPC services should feel like one coherent visit; avoid avoidable camera snapping, overlapping windows, and disruptive handoffs.
- Reuse the accepted Logres visual language and working runtime elements. Do **not** rebuild a complete Blizzard transaction UI simply because Logres could draw one. Dense information/transaction surfaces may appropriately remain Blizzard-owned under the world-first product thesis.

## Accepted development order

1. **Memory acceptance:** record this decision and ordered plan in durable repo memory; commit/push by the user and verify main before advancing.
2. **Modularity audit:** map current production modules, frame hierarchies, data sources, event ownership, interactions, previews and duplicated primitives. Inventory all NPC families, visual and action complexity separately; classify what is actually reusable versus merely similar-looking. Source/static findings are not WoW runtime PASS.
3. **Modularity fixes:** narrowly extract already-working components with preview fixtures, shared models/renderers, capability-gated data adapters, and independent interaction controllers. Preserve stable look, quest behavior, stock fallbacks, protection/secret safety and regression evidence. Avoid speculative broad rewrites. Prove reuse with existing quest narrative/decisions/rewards before extending to generic gossip and services.
4. **Post-modularity reassessment:** rerank all NPC interaction families for feasible Logres visual reuse, verified source/action safety, expected camera/immersion benefit and maintenance cost. Defer, integrate lightly, hybridize, or custom-replace on evidence; do not predetermine bank/auction-house ownership.

## Integration tiers — choose the lightest safe layer

1. **Native-backed presentation integration:** leave Blizzard's native data, input and transactions intact; adjust presentation/placement/coordinated framing only where safe. Styling or repositioning must not manipulate protected/secret state or leave invisible click regions.
2. **Hybrid interaction:** Logres handles session narrative/selection/visual composition while a proven Blizzard subsystem retains complex transactions or protected controls. Restore usable stock surfaces before Logres interaction is removed.
3. **Full Logres ownership:** only after capability and runtime evidence proves equivalent information, player control, identity/eligibility guards and fail-open restoration. No silent auto-accept, claim, spend, vendor transaction or travel action.

## Shared NPC session contract (to audit, not yet implemented)

A session coordinator should track native NPC context/lifecycle, transitions between gossip and services, close/cancel/restoration, and camera context handoff. DynamicCam remains separately owned; a session coordinator may request only supported existing camera behavior, not invent profiles or force camera state. Keep observed client state distinct from presentation policy. Missing or secret data must not be inspected or fabricated.

Common visual modules should support text/pages, action buttons, option lists, reward/item cards, costs, eligibility/confirmation, feedback and compact catalog states, using **D-046 fixture -> plain model -> same renderer -> guarded live adapter -> separate controller**. The central P — Previews tab must offer representative states for every Logres element, before new gameplay ownership. Never add a fake preview that only logs PASS.

## Release and evidence gates

No current bank/auction implementation promise: both are **DEFERRED PENDING POST-MODULARITY ASSESSMENT**, not excluded. The same applies to any unsupported service. The known Blizzard-frame flash during native quest claim stays OPEN; do not hide it with a timer, polling or unsafe restoration changes. Quest 237 remains reserved; live selectable reward claims remain unverified. The user-reported 20-minute session bugs remain **OPEN / DETAILS PENDING**, not resolved by this architecture decision.
