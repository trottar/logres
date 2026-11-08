# P0388 — Scoped native objective info gate

Baseline main P0387 `2ad6f3a`. Implemented in existing QuestObjectiveProgress owner: candidate detects only typed native objective information with exact Logres-owned and visibly pulsing objective identity and delegates all remaining errors to Blizzard. No new Lua module or native frame hide; preserves Immersion OFF and user-facing error messages. Client runtime UNVERIFIED, L-027 OPEN, L-002 OPEN. Negative limitations in `docs/memory/evidence/P0388_OBJECTIVE_INFO_GATE.md`.

Pre-handoff: baseline source SHA 14/14, 258/258 static checkers, 12/12 isolated Lua behavioral tests, and 4/4 applier transaction cases PASS. Transaction tests stubbed suite execution; full real suite independent. The WSL applier executes real PREWRITE/POSTWRITE checkers. No WoW PASS.
