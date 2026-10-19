# P0261 — N1 source-independent NPC narrative model and preview parity

- Baseline: pushed P0260 at `1251434b4f66a929b1ae303f8c268fb5ce3118fc`.
- Scope: `Quest/NarrativeModel.lua` plain model and long/short/generic fixtures; existing guarded live quest offer -> shared model -> **unchanged** `QuestDialogue:PresentText` renderer; two P-tab preview actions; targeted contract updates and durable memory.
- No new native action: Accept/Decline controls and stock suppression are unchanged, generic dialogue preview does not offer fabricated selectable gossip.
- Camera source/behavior is strictly frozen; source files excluded and shadow checked byte-for-byte.
- Static: all existing checks plus P0261 new model/fixture parity checker run against assembled shadow and after write; `git diff --check` required. Tool and artifact syntax/hash preflight do NOT prove WoW runtime.
- Runtime acceptance: original and new previews must render correctly/inertly; previous reward previews and existing live quest flow must not regress. Natural live opportunities may be deferred. Quest 237 reserved.
- Known negative: P0257 R0/R1 prewrite checker/source disagreements and earlier quest visual alignment failures remain historical evidence; this applier tests exact generated candidate before tracked writes to avoid repeating that pattern.
- Next: N2 presentation extraction only after N1 evidence and push; universal NPC feasibility comes after modularization, not now.

## P0261 R0 negative / R1 memory-health correction

- User's WSL R0 applier verified exact `1251434` baseline and prepared 18 candidates. The shadow `check_memory_health.py` stopped with `ERROR: CURRENT.md exceeds 20 KB hard maintenance threshold`. This was a **STATIC FAILURE / NO TRACKED WRITE**, not a Lua or camera defect.
- Cause: `CURRENT.md` already held approximately 15 KB of previous PASS/FAIL history inside `Verified State`; R0 appended further N1 status instead of compacting it.
- R1 replaces **only that summary section** with the current authoritative state, accepted constraints, open failures, and pointers to the existing evidence documents. No evidence files are deleted, and the historical negative results remain durable elsewhere. The other CURRENT headings and references stay intact. R1 refuses unexpected historical anchors and checks the exact prepared `CURRENT.md` is at most 10,000 UTF-8 bytes **before** running the shadow checker suite or writing tracked files.
- Status: R1 prepared; full WSL static suite and WoW visual/runtime regression remain UNVERIFIED.

R2 negative (2026-10-18): shadow static failure, `check_ui_ownership_audit_contract.py` rejected a 61st captured local in `handleCommand` (Forever max 60). R3 makes preview runner a `Logres:` method rather than a new local function, adds prewrite budget check, and preserves the 60 captured locals. Neither previous attempt touched tracked source. Full WSL suite and WoW runtime still pending.
