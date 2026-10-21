# P0289 — P0288 developer-panel routing omission

Date: 2026-10-21. Status: **OPEN UNTIL WSL/WOW VERIFIED**. Baseline: verified GitHub main P0288 `2e4b509581dca547a203b307f1a8f29cbbfa7e65`.

## Observed process failure

P0288 introduced `nativetrainerlive on|off` as the only trigger for the read-only live landscape and then instructed a slash-only test. The user explicitly challenged that omission. Repository `Logres/Dev/Panel.lua` already exposes a paginated H developer-panel action runner and prioritizes the existing native trainer skin ON/OFF commands; `Logres/Core/Commands.lua` includes the live command but does **not** register it in `Logres:RegisterDevPanelAction`. Consequently P0288 had no direct H control for live trainer. This is an **ASSISTANT WORKFLOW AND IMPLEMENTATION FAILURE**, not a source API or Blizzard trainer failure. No new in-client P0288 runtime result was supplied; do not claim visual success or regression.

## Narrow correction

P0289 adds explicit **H — Integration and Polish** `Live Trainer ON (TEST)` and `Live Trainer OFF` actions, routed through the existing `Panel:RunCommand` to the unchanged `nativetrainerlive on|off` handler. The H first-page ordering rule includes the live pair ahead of the existing trainer skin controls, preserving the original skin buttons and general H pagination. The stock trainer stays Blizzard-owned; P0288 live trial remains mouse-inert, read-only, bound to ordinary source values and explicitly off on exit/combat. No new gameplay calls, selector, transaction, polling, reflow, renderer or source adapter change.

## Validation gate

Generated source/checker/ZIP validity may be verified locally. The full WSL PREWRITE/POSTWRITE suite, manifest, diff hygiene and in-client ON/OFF behavior remain **UNVERIFIED** until the user executes the guarded applier, pushes and deploys. With a trainer open, `/logres panel` → **H** → `Live Trainer ON (TEST)` / `Live Trainer OFF`, not a slash-only procedure. Check command result, addon panel appearance, Blizzard click-through and hide on close. A deferred result is not PASS; preserve the reason. Prior P0285/86 category-shape failures, P0287 R0 checker PREWRITE failure, and unverified numeric semantics remain historical evidence.

## P0289 R0 PREWRITE refusal — linked historical registry contracts

User WSL 2026-10-21: ZIP checksum OK; pinned P0288 baseline PASS; PREWRITE ran
160 checkers, with 6 failures (`check_p0256_preview_hub_contract.py`,
`check_p0271_native_placement_trial_contract.py`,
`check_p0272_native_auto_handoff_contract.py`,
`check_p0273_native_gossip_continuity_contract.py`,
`check_p0274_native_service_accent_contract.py`, and
`check_p0276_r1_native_trainer_skin_contract.py`). All six froze the former
108 total / 20 H panel action counts; P0289 adds two legitimate H actions.
PREWRITE REFUSED before ANY tracked file was changed. This is an assistant
static-contract migration omission, NOT a WoW or user failure.

P0289 R1 repairs the complete historical checker dependency graph, including
P0261/P0269/P0270, with 108/20 as minima while retaining the exact accepted
35-entry P gallery. The new P0289 checker verifies the precise H ON/OFF IDs,
commands, first-page priority and absence of gameplay mutation. Full WSL
PREWRITE, POSTWRITE and WoW checks are still UNVERIFIED. No native purchase,
filter, selection, movement or renderer change was made.
