# P0264 — Functional multiple-choice reward preview and selectable reward visual

Date 2026-10-18. Baseline verified pushed GitHub `main` `373c82b177339b210626d15226d4c1d8c94320cc` (P0263). Candidate build `0.0.162-dev`.

## Reported failure and evidence

User reports that P0263 did not produce visible functional progress and explicitly identifies **inability to click/select any of the three choice cards in Multiple reward preview**. The attached `LOGRES_DIAGNOSTICS_LATEST.lua` reports `0.0.161-dev` loadCount 351 and `questrewardpreview multi` PASS as a command, `questdialoguecheck` PASS, `questoffercontrolscheck` PASS previewOnly with six inert action clicks, but no choice-selection check. These PASS states only measure presentation, not input functionality. Targeted source inspection shows exact cause: `Quest/RewardVisual.lua` builds each reward slot as `CreateFrame("Frame")` and calls `slot:EnableMouse(false)`, while `Quest/RewardModel.lua` explicitly declared all multi-choice cards display-only. The previous generic N3 extraction did not add a user-facing capability and was therefore insufficient for the requested progression.

## Combined repair (one patch)

- Change the existing one shared reward slot factory to a Button while keeping all baseline geometry, images, quantity, labels and panel sizing; keep mouse **disabled** unless a synthetic authored preview choice handler exists and a card is `kind="choice"`.
- Add synthetic preview ordinal and exclusive selected visual state in `RewardVisual` (gold emphasis, SELECTED label, highlight changes when another CHOICE is clicked). Guaranteed reward card never becomes selectable. No duplicate fixture-only renderer.
- `QuestDialogue` alone enables interaction after displaying `RewardModel.Preview("multi")`, guards every callback against stale/hidden/production presentation, and reports a selected ordinal and click count. Entering Single, a new preview, production completion, or hiding/reset clears selection.
- The existing shared Complete Quest preview button stays **inert**, now giving contextual feedback if the multi sample has no selected choice, or confirming the selected choice. It never calls native actions from preview. Single remains inert with unchanged feedback.
- Add choice state readout to existing **F — Quest Experience → Quest Dialogue Check**, not another scattered diagnostic; update legacy passive-card static checks P0248/P0249 to allow precisely the new preview-only callback while continuing to bar native calls, secure actions and polling; add stronger dedicated P0264 checker.
- Bump TOC and Bootstrap together; preserve the actual live `CompletionControl` gate (`GetNumQuestChoices == 0`) and all stock fallback, secret-safe reads, camera/DynamicCam files, Quest 237, live quest action controllers, and P tab label/registration.

## Limits, validation, negative-result discipline

This is a **FUNCTIONAL PREVIEW INTERACTION**, not an assertion of live reward selection or claiming. Real multiple-choice completion remains **Blizzard-owned**, for safety; the native frame flash, all-NPC transaction integration and generic service/gossip remain OPEN. Do not silently promote preview action to live or make selected preview ordinals drive `GetQuestReward` without independent source/risk evidence. Static suite and archive parity are separate from WoW acceptance. Candidate remains **RUNTIME UNVERIFIED** until the user actually clicks the three authored CHOICE rows in a running client and observes exclusive highlight and F tab selection diagnostics. The P0263 no-progress complaint is recorded as a negative outcome; do not mark its visual checking a substitute for functional progress.

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
