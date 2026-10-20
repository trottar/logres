# P0276 R4 — assistant-generated handoff / memory-health failure

Date: 2026-10-20. Pushed authority: main P0275 `75e8024`.

**Observed R3 result: PREWRITE FAIL, NO TRACKED WRITE.** The user's WSL log
reported exact prior R0 local candidate match and PREWRITE hygiene PASS.
The R3 aggregate suite evaluated all 144 static checkers; only checker 55,
`tools/check_memory_health.py`, failed: `CURRENT_HANDOFF.md must point readers
to CURRENT.md`. The R3 builder's generated handoff ended with the phrase
`See CURRENT and P0276_R3 evidence.` instead of referencing `CURRENT.md`.
This was an assistant-authored memory-contract defect missed before delivery.
It is not a Lua/runtime regression and not a WoW visual acceptance.

**History retained:** R1 refused the unknown dirty worktree; R2 accepted the
byte-exact R0 state but failed checker/source consistency 109/144; R3 fixed
that assertion but failed the CURRENT handoff contract 55/144. All attempts
were stopped before tracked writes. P0274 and P0275 styling experiments were
visually rejected. The native trainer skin trial remains OPEN / UNTESTED.

**R4 correction:** surgical generated handoff fix, with explicit prewrite
contract assertion; no changes to Lua, controls, secret-handling, camera,
Blizzard transactions, or already-corrected static checker. R4 retains exact
R0 candidate gating, clean index, full 144 static PREWRITE and POSTWRITE
checks, whitespace validation, transactional rollback and manifest generation.
WSL and WoW remain UNVERIFIED until actually executed. Do not claim a PASS
from this record.
