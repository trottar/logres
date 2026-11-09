# P0418 — translate approved full-screen authored layout into runtime anchors

Baseline: verified GitHub `main` P0417 `bc91448bcb3632e493c5c2d9b28dd57baff744c6`.
Date: 2026-11-09. State: source-backed layout candidate; WoW Forever UNVERIFIED.

## New evidence and authority

After P0417, the user reports the Blizzard PetFrame/PetActionBar regression
"seems fixed" and uploads an approved whole-screen layout file:
`LOGRES_SCREEN_MAP_APPROVED.json`. The accompanying diagnostics also show the
pet trial armed with native drivers installed (`armed=true nativeDriver=true`)
and the Logres pet probe READY with eight occupied slots. That confirms the
narrow P0417 readiness correction is behaving in the observed session, while
broader pet edge cases still need normal runtime coverage.

The new map is the authority for the coordinated H.2 screen-fit pass. It
supersedes the earlier five-bar-only adjustment request and adds exact targets
for:

- all five action bars;
- active quest, quest dialogue, context objective, context XP;
- player/target auras and target fallback;
- player reaction, allies, pet actions, passive status; and
- the standalone Report Bug button.

The uploaded coordinates are viewport percentages expressed as **component
centers** rather than the old V4 top-left rectangles. P0418 therefore keeps the
map as approved and translates it into the correct anchor semantics per owned
widget (top-center, top-right, center, left-center).

## Source changes

P0418 updates only addon-owned layout metadata and diagnostics:

- action-bar authored centers move Bar 3 and Bar 5 slightly left to 88/85 and
  88/95, preserving all role/grid/source assignments and 12-slot secure action
  routing introduced in P0416;
- the H.2 approved-anchor table now includes quest dialogue, context objective,
  context XP, and the Report Bug surface in addition to the previous regions;
- the H.2 geometry plan and panel subview now show the full approved map rather
  than the original 13-row HUD-only sheet;
- the Report Bug button gets its own addon-owned layout anchor instead of being
  indirectly offset from the native-access dock.

No protected Blizzard frame ownership, secure action bindings, pet probe
execution, combat logic, polling, or native fallback policy is changed.

## Acceptance boundary

Apply to an exact clean P0417 main checkout and run the historical static suite
plus the new P0418 contract. In WoW Forever, validate the user-approved visual
fit in normal gameplay with `/logres panel` H.2 map and regular play, then run
Layout Check, Native Access, and the relevant quest/pet/manual bar interactions.
Expected result: the pet regression stays absent, the five bars match the
approved whole-screen map, and the newly added objective/dialogue/bug-button
anchors sit in the approved positions without Lua or protected-action errors.

## R0 preflight refusal and R1 correction (2026-11-09)

The user verified the P0418 R0 ZIP hash, unpacked its guarded applier, and ran
`P0418_APPLY.py`. Exact source review succeeded, but the isolated historical
check suite **REFUSED 283/286 before any tracked writes**. This is an author
pre-handoff coverage failure, not a game failure:

- `check_p0381_integrated_gameplay_contract.py` rejected a stale active-phase
  roadmap heading (P0417 instead of P0418).
- `check_p0389_session_41_regressions.py` assumed Report Bug remains bound
  to `nativeAccess`, although the approved whole-screen map moves the owned
  button to an independent `reportBug` anchor.
- `check_p0408_chat_preflight_contract.py` failed only because it invokes the
  P0381 checker. It does not establish a third independent runtime defect.

R1 synchronizes the active phase and top-level roadmap with CURRENT and updates
the historical P0389 Report Bug checker narrowly to the new approved anchor,
keeping the existing low strata and native-access independence. The original
P0417 GitHub baseline remains unchanged. Do not claim runtime PASS from R1
static checks.

## R1 assistant-side validation boundary

A rebuilt candidate using the original P0417 file contents plus all 23 R1
changes passed 286/286 Python static contracts with independent per-checker
processes, followed by source-byte comparison and `git diff --check`. An
isolated checkout verified the exact package content against 23 files and its
staged manifest. The sandbox's **sequential** full check and guarded apply
exceeded the execution deadline; those wrapper executions are environmental
deferrals, not PASS. The deliverable retains the user's mandatory full guarded
PREWRITE and POSTWRITE check path before any gameplay test. WoW remains
UNVERIFIED for P0418 R1.
