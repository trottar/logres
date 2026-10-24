# P0323 handoff — source module ownership audit, no gameplay changes

Authority: `docs/memory/CURRENT.md`, `docs/memory/architecture/P0323_MODULE_OWNERSHIP_AUDIT.md`, D-046/D-047/D-048, launch roadmap and issue register.

Verified pushed P0322 `272130eb9e80c3c51ebe5da08598453cdfc56a88`. D-048 five selectors are a release contract, **not implemented yet**. All 94 TOC-listed Lua files are inventoried and classified into NAV/ACT/NPC/STATUS/CAM/SHARED. Findings: current Immersion policy still couples ACT/STATUS/Quiet Mode and NAV; NPC has good existing model/renderer/controller splits; two separate NPC native-parking owners must not be merged; camera frozen. The 6,361-line developer command router, 2,279-line quest dialogue, 2,084-line camera coordinator, and 1,592-line navigation probe are large but **not** refactor authorization.

P0323 is **docs/static-checker ONLY**: no Lua, TOC, version, camera, secure actions, native frame or preference schema changes. Run exact clean P0322 baseline, 194 checker PREWRITE+POSTWRITE, diff hygiene and manifest. User commits/pushes; verify main. No WoW redeploy. Next P0324: isolated deterministic policy models/fixtures for **32** five-domain combinations, requested/effective/fallback/pending and backward-compatibility expectations; do not wire live switches yet.

P0321 gossip parking remains runtime **UNVERIFIED / DEFERRED** to November 4; P0317–P0320 positive NPC observations remain scoped. Merchant and flight-master native handoffs are key remaining NPC regimes; bank/auction and broad transactions are not immediate promises. Freeze camera/DynamicCam D-047, Quest 237 and all native/secure fallbacks. Retain every `ISSUE_REGISTER.md` classification until evidence changes it.
