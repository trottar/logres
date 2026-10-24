# P0323 — loaded-source ownership audit and safe extraction order

- **Verified baseline:** P0322 GitHub `main` `272130eb9e80c3c51ebe5da08598453cdfc56a88`, clean tracked state and exact committed blob checks.
- **Scope:** all 94 TOC Lua modules mapped into primary NAV/ACT/NPC/STATUS/CAM/SHARED ownership, cross-domain dependencies and capability-fallback boundaries. Source-only investigation; no Lua/TOC/version/schema/image/setting/native changes.
- **Output:** `docs/memory/architecture/P0323_MODULE_OWNERSHIP_AUDIT.md` (full TOC-ordered inventory and ranked seams), synchronized `CURRENT.md`, handoff, launch roadmap and Phase-H/status/history pointers, P0323 evidence and checker.
- **Expected WSL checks:** 194 static `tools/check_*.py` PREWRITE and POSTWRITE, candidate diff hygiene, `git diff --check`, manifest, no Git commit/push.
- **Evidence distinction:** P0321 gossip parking remains WoW unverified; merchant/flight hybrid integration untested; P0320 observed dialogue preserved. Full suite needs WSL and cannot be declared passed by author-side targeted fixture checks.
- **Next:** after push verified, P0324 pure five-domain policy model/32-combination fixture. Never modify working camera, secure actions, native parking or current Immersion activation simply to improve modularity.
