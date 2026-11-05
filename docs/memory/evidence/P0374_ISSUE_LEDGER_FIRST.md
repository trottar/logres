# P0374 — First-reference issue and resolution ledger (documentation only)

Date: 2026-11-05. Verified GitHub `main` P0373 `2a97a774564077a22e3fd640be63199c1387a7b7`, `0.0.260-dev`. User requests one issue-by-issue register, current OPEN/RESOLVED state, the actual resolution, and mandatory first lookup on every subsequent bug. Previous `ISSUE_REGISTER.md` interleaved dated patches and early L-001–L-032 triage; as-of text and some rows were stale after live P0372/P0373 testing. Do **not** destroy those raw reports or convert source patches into gameplay PASS.

## Source and live evidence retained

- P0369: real Forever gossip single-window and native quest window failures L-001/L-002/L-005; no native frame owner confirmed.
- P0370: user says no-pet keybinding labels no longer leak, **PASS only for observed no-pet condition**, other pet paths unverified (L-021).
- P0372: passive journal and screenshot-correlation exercised in actual gameplay, partial diagnostic success (L-020); broad feature coverage incomplete.
- P0373: user reports Logres profession training unavailable (L-033) and quest turn-in window (L-002/L-005) remains. Client journal quests 7, 91741, 92124 records `completion-owned` and `native-handler-invoked`; neither proves reward granted or identifies exact popup. Code restores Blizzard visual/mouse ownership before calling native handler; that is source-supported **potential** transient exposure, not proven screenshot cause.
- P0373 `0.0.260-dev` session 7 Report Bug **incident 764**, journal sequence 765, screenshot event `screenshot-succeeded`. No quest offer/completion/gossip event between session initialization and incident; completion controller inactive in snapshot. User reports quest GUI appears at random (new **L-034**, separate from L-002). Image content and Blizzard-versus-Logres frame provenance not supplied. **OPEN**; do not suppress native frames speculatively.
- P0373 R0 lost `P0371` baseline ID, refused before writes; R1 removed P0296 train click guard token, refused 133/243; R2 passed full 243/243 PRE/POST and was verified pushed. Negative patch evidence remains in P0373 record and is not erased.

## Change and acceptance

New `docs/memory/investigations/ISSUE_LEDGER.md` indexes L-001–L-034, stores current disposition and most recent attempted or completed resolution, distinguishes static patch from in-client result and requires explicit closure proof. `AGENTS.md`, `CURRENT.md`, handoff and old `ISSUE_REGISTER.md` route bug work to the ledger **before** diagnosis. Legacy history stays available; the ledger does not supersede original raw evidence for factual reconstruction. A durable static contract enforces one row per L-ID and the central first-lookup links.

**No runtime Lua, dependency, SavedVariables schema, protected action, stock presentation, camera, version or generated screenshot behavior is changed.** This checkpoint cannot claim any new WoW test PASS. Full static suite must pass prewrite and postwrite; GitHub push must be verified before issue ledger becomes durable. Do not redeploy WoW for this docs-only patch.
