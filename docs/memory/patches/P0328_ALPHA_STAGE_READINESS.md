# P0328 — guarded internal alpha stage and client regression runbook

- **Expected baseline:** verified pushed P0327 `67c58185e2d05ce469ff7cdf7cc132f28814cf96`, clean branch `main`, committed file hashes verified. User retains all commits/pushes.
- **Scope:** tools-only deterministic internal staging/preflight utility and permanent static checker; an internal package notice, A0/A3/Nov 3 freeze/Nov 4 test plan and memory. **No addon Lua, TOC, version, camera, save schema, media, NPC/native or secure runtime change.**
- **Evidence:** P0327 source and manifests reviewed; 94 TOC Lua, media folder and mandatory LibCamera attribution included. QuestieDB remains optional and separately installed. No top-level Logres license was found; record L-019 public release gate. ZIP is internal-only, NEVER a public artifact claim.
- **Expected checks:** 199/199 PREWRITE and POSTWRITE static, exact candidate diff hygiene, `git diff --check`, manifest. WoW and full WSL results **UNVERIFIED** until checked by user; client tests **DEFERRED until November 4**. Failure states preserved in history.
- **Next:** review licensing/credits and pre-Nov 3 installability docs, static candidate freeze, then run November 4 native gossip and services plus action/HUD/compass/camera regression matrix. Public distribution **NOT APPROVED** by this patch. No WoW redeploy for docs/tools-only P0328.
