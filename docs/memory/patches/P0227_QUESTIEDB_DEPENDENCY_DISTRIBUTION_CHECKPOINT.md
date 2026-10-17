# P0227 — External QuestieDB dependency and public distribution docs

Docs-only checkpoint on verified GitHub `main` P0226 `45bbd0e`. Captures actual P0226 runtime DEFERRED provider-not-installed result, clarifies that QuestieDB is optional for base Logres and *not yet a source of compass POIs*, and documents safe upstream v1.0.6 Forever installation, SHA-256, updates and missing-provider behavior. Separates `Questie/QuestieDB` from the unrelated CurseForge `LibQuestDB` and records the unverified redistribution-license and CurseForge dependency registration gates before public packaging. Preserves Blizzard-first positions, native fallback and P0223 working compass.

No Lua/runtime/source code changes, no WoW redeployment, no new feature PASS. Full checker suite and git diff hygiene run by guarded applier; only the user's pushed commit makes this checkpoint durable.

R1 correction: restored required `CURRENT.md` do-not-reopen heading after the original archive failed `check_memory_health.py` shadow validation before tracked writes. No runtime changes.
