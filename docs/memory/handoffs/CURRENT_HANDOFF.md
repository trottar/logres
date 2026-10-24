# P0325 handoff — staged migration dry-run, no WoW changes

**Authority:** `docs/memory/CURRENT.md`, `docs/memory/architecture/P0325_MIGRATION_DRY_RUN.md`, D-046/D-047/D-048, launch roadmap and issue register.

Verified pushed P0324 `bc56185992e79d185063ecfedb1c39da4e8fb58e`. The five-domain P0324 model and P0325 migration preview are **Python-only fixtures**, not deployed Lua or actual SavedVariables updates. Legacy schema-3 `immersionEnabled`/`activeQuestEnabled` are preserved untouched, an unselected domain remains `legacy` (existing runtime policy), explicit selections draft only one domain, and CAM is never guessed from old Immersion. Future native restoration must be tested individually in Forever; no switches can yet be called live.

P0325 guards exact clean P0324, runs **196 PREWRITE+POSTWRITE** static checker suite, diff hygiene and manifest, then user Git commit/push and remote verification. **Docs/test-only; no WoW redeploy.** P0321 native GossipFrame parking remains **WoW UNVERIFIED / DEFERRED to November 4**; merchant/flight native service handoffs next for read-only source audit. Preserve separate gossip/trainer parking, frozen Camera/DynamicCam D-047, Quest 237, protected/secret fail-open stock policy and L-001–L-018 classifications. Next candidate P0326: merchant/flight source-hand-off research; no spending/travel or speculative native UI mutation.
