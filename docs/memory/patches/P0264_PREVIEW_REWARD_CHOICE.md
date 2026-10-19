# P0264 — Selectable Synthetic Reward Preview

Status: PREPARED; WSL full static and WoW runtime UNVERIFIED. Baseline: pushed P0263 `373c82b` on main; 2026-10-18.

**Included functional work:** single shared reward card factory now optionally clickable in authored Multi preview; exclusive selection highlighting, safe owner-level callback, persistent click diagnostic and reset; shared inert Complete Quest button acknowledges selected/missing choice; previously no selection anywhere.

**Touched source:** Quest/RewardVisual.lua, Quest/RewardModel.lua, Quest/Dialogue.lua, Core/Commands.lua, Bootstrap.lua, TOC; P0248/P0249 static checkers updated to defend preview gating instead of obsolete universal no-click requirement; new P0264 checker; synchronized memory/evidence. Camera, Native Offer/Completion controllers, P-tab registration and Quest 237 untouched.

**Outcome pending:** User application and in-game validation. Negative history preserved: P0263 had no meaningful functional UI change; Multiple card selection entirely untested by old command PASS. Blizzard remains owner of live choice/claim; no assumption of success.

## P0264 R0 WSL static failure and R1 checker correction (2026-10-18)

The user applied the original ZIP and independently verified SHA-256 `3c4e5269dcecb385e039e37fcceed496e8aa9ae30b1f2ec46e080ac1fa6fa3f2`. Its applier verified the pushed P0263 `373c82b` baseline, clean tracked state, and prepared 18 target paths, but **stopped in the shadow-tree static suite before writing tracked files**:

```text
P0264: ERROR CHECK FAIL check_checker_version_policy.py
ERROR: tools/check_p0264_preview_reward_choice_contract.py freezes historical runtime version(s): 0.0.162-dev
```

**R0 STATIC FAIL / NOT A WOW RUNTIME FAIL / NO TRACKED WRITE:** the assistant's new checker itself violated the existing `check_checker_version_policy.py` rule by checking a literal runtime version. R1 replaces this with format and equality checks using regex (valid development-version form; TOC equals Bootstrap). A further preflight review caught an outdated P0258 substring assertion: a newly generated model comment contained a banned old footer phrase. R1 also changes that COMMENT ONLY to avoid the obsolete instruction text. The reward selection mechanics, native/camera freeze and prewrite gates are unchanged. R1's ZIP also explicitly includes this failure in patch evidence. Revalidate the exact checker with the repository version-policy test before handoff; repository-wide static validation and WoW interaction remain pending until the user applies R1.

## P0264 R1 WSL prewrite failure / R2 bundled repair (2026-10-19)

The user independently verified R1 SHA-256 `178de236f4eee596bccf080d99be53a8a237eaf1249a6961e4907ec94f4b1249`. Baseline verification and preparation of 18 paths passed, but the shadow full-suite terminated at `check_memory_health.py`:

```text
ERROR: CURRENT_HANDOFF.md must point readers to CURRENT.md
```

**R1 STATIC FAIL / NO TRACKED WRITE / NO WOW RUNTIME FINDING.** The applier generated a replacement `docs/memory/handoffs/CURRENT_HANDOFF.md` and removed the original explicit `docs/memory/CURRENT.md` authority reference. `tools/check_memory_health.py` requires that exact `CURRENT.md` substring. R2 restores the authority link in the generated handoff, adds prewrite guards for both earlier failures (handoff pointer and no historical build pin in the dedicated checker), and changes `suite()` to run all 131 expected feature/static checkers and aggregate their failures so a later unknown checker cannot be silently hidden behind the first one. The functional reward-card input/selection, native and camera changes are identical to R1. The complete repository suite still needs to run in user's WSL checkout, and WoW choice interactions remain unverified until observed.
