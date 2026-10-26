# P0348 — Per-surface D-048 handoff contract

**Baseline:** verified pushed main P0347 R1 `b94beb4706005757497002927d80845d5355037f`; version stays `0.0.237-dev`. Prior 218/218 static PASS from committed manifest; WoW UNVERIFIED. Architecture and issue evidence in `docs/memory/evidence/P0348_SURFACE_HANDOFF.md` and `docs/memory/architecture/P0348_SURFACE_OWNERSHIP_MATRIX.md`.

**Scope:** add a pure offline Python model and #219 static checker, P0348 architecture/patch/evidence records and compact memory pointers. No loaded Lua, TOC, preference, Blizzard frame, safe fallback, D-047 camera, panel action, command, saved schema or client change. 32 domain requests × 19 surface gate invariants; independent candidate capability/restoration attestation; stock-required Blizzard surfaces remain. L-022/L-027/L-028 OPEN, P0321 runtime UNVERIFIED; L-019 public release BLOCKED.

**Validation:** guarded exact baseline and Git blob verification; 219/219 shadow PREWRITE checkers and POSTWRITE, diff hygiene and SHA-256 manifest required in user's WSL. Local Python fixture checks do not count as client PASS.

**Next step:** after pushed verification, select one safe, isolated surface for D-048 adapter implementation only when independent native restoration evidence exists; meantime continue source-driven modularity improvements without violating current gameplay. No WoW deployment is required for P0348.
