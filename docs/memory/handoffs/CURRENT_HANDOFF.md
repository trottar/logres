# P0315 Handoff — guarded live gossip source sample

Authority: `docs/memory/CURRENT.md`, P0315 evidence, D-046/D-047. GitHub main verified P0314 `f40a8e0`; user reports successful runtime result without noticed issues. Treat P0314 as user-confirmed within tested interactions, not universal recovery/purchase proof.

P0315 PREPARED / 186 static and WoW UNVERIFIED. New `NPCGossipSource.Sample()` is explicit H-panel only, no automatic gossip opening, native click, window suppression or camera effect. Bounded, secret-screened `C_GossipInfo` option/quest/text reads may construct an existing `NPCOptionModel.FromValidated` but leave every real option disabled; no live renderer starts yet. Unknown APIs, mixed quests, incomplete text and nonordinary values defer to untouched Blizzard stock.

Apply against clean exact P0314 main; run 186 PREWRITE+POSTWRITE static contracts, diff --check and manifest, then user commits/pushes. Deploy and `/reload`; test `/logres panel` > H > **Gossip Source Check (READ-ONLY)** during real ordinary gossip and compare result with Blizzard; export diagnostics and report failures/deferrals. No visual change is expected. Then design separately gated read-only live gossip presentation using approved P fixtures/Quest option renderer. Quest 237 reserved, no native selection, no camera change.
