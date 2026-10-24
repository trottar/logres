# P0324 — pure five-domain policy reference fixture

- **Baseline:** exact clean pushed GitHub `main` P0323 `386a7ef`, verified Git blobs; no assistant Git mutations.
- **Scope:** standalone `tools/p0324_domain_policy.py`, new deterministic checker, architecture/evidence/patch memory, and current/roadmap/handoff synchronization. **No Lua** runtime file, TOC, version, saved-variable schema, camera, native/secure mutations or live five-toggle wiring.
- **Contract:** D-048 NAV/ACT/NPC/STATUS/CAM requested/effective/fallback/pending, 32 combinations, 160 isolation checks, five unavailable/partial/native restore cases and four unchanged legacy preference combinations. Policy is a fixture, not runtime authority.
- **Static gate:** 195/195 PREWRITE+POSTWRITE `tools/check_*.py`, checker-version policy, exact candidate diff hygiene, `git diff --check`, P0324 manifest; user applies/commits/pushes and verifies main. Full suite currently UNVERIFIED until WSL.
- **Next:** separately design backward-compatible migration and actual Lua policy tests before domain-by-domain runtime exposure, while keeping high-risk secure ACT/pet, gossip/trainer parking, native services and camera frozen. November 4 P0321 native gossip restoration remains runtime UNVERIFIED. No WoW redeploy required for P0324.
