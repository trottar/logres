---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Test one expressly user-initiated, guarded Logres trainer purchase without removing Blizzard fallback; repair the live catalogue's inert scrollbar and preserve proven local selection.

## Current Work Item
**P0296 — LIVE SCROLLBAR AND SINGLE-SKILL TRAIN TEST / PREPARED; WSL AND WOW UNVERIFIED.** GitHub `main` P0295 `7b1a459` verified. User screenshot and report establish local spell clicks, selected detail updates, local filtering and wheel scrolling PASS. **SCROLLBAR FAIL:** P0295 scroll thumb is static artwork, does not track offset, and cannot be dragged or clicked. P0296 replaces only the LIVE thumb with an addon-owned vertical Slider synchronized with the existing bounded offset; P fixture keeps its inert thumb. Separately, an explicit Train selected (TEST) hit region invokes an isolated capability-gated one-service controller, not native Train All. It checks live Forever six-field identity, cost, remaining funds, trainer identity/session, combat/protection and snapshot service count at click time. Native buyer may still reject the action; no successful purchase is assumed without in-game evidence.

## Verified State
- **P0295 pushed `7b1a459` / USER RUNTIME LOCAL SELECTION PASS:** screenshot shows Curse of Recklessness clicked with matching icon, requirements and description; wheel scrolling and filters work. No verified native purchase, Train All, or native UI replacement.
- **P0295 native-like scrollbar OPEN / FAIL:** gold thumb was painter-only, not attached to scroll offset or hit region. Older rail arrows remain separate and must be retested.
- **Sidebar `Visible services` remains OPEN:** inert live placeholder, not source-backed categorical navigation.

## Next Action
Apply guarded P0296 archive to clean exact P0295 main, run complete prewrite/postwrite static checks, whitespace and manifest gates. User pushes; verify remote. Deploy and `/reload`; open trainer, H panel → Live Trainer ON (TEST). Verify live gold thumb movement with wheel, track click/drag, arrow movement, local filter/clamp and preserved row clicking. Click an eligible affordable Logres skill, then click **Train selected (TEST)** once only if intentionally willing to spend its displayed gold. Verify Blizzard actually learned the specific skill, spent correct funds and remains usable; absence of error alone is NOT purchase proof. OFF/close restores inert regions. Native Train All is out of scope.

## Success Criteria
Offset and slider value are synchronized without OnUpdate/polling; synthetic preview remains inert. Explicit purchase requests are single service, native-index-stable and abort on changed source/secret/visibility/combat/funds/eligibility; never use cached status alone or automatically reattempt. Blizzard stock training remains accessible even on a blocked or failed Logres request. Actual purchase is pending runtime proof.

## Do Not Reopen Without New Evidence
No automatic Train All, stock suppression, native frame reparenting, polling or inferred eligibility from numeric category. No false claims of transaction success from `pcall`; source-dependent service indices must be rechecked. Preserve unresolved category sidebar and lifecycle deferrals.

## Relevant References
- `docs/memory/evidence/P0296_TRAINER_SCROLL_TRAIN_TEST.md`, `docs/memory/patches/P0296_TRAINER_SCROLL_TRAIN_TEST.md`
- `docs/memory/evidence/P0295_TRAINER_ROW_HIT_PRIORITY.md`, D-046/D-047
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
