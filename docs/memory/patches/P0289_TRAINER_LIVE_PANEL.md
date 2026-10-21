# P0289 — Place the live trainer trial in H developer panel

Baseline verified P0288 pushed `2e4b509`. P0288 live rendering was offered only via slash commands, contrary to the established H diagnostic/control workflow. The user flagged the missing panel controls. The correction registers Live Trainer ON (TEST) and OFF using the existing `nativetrainerlive` command, keeps both on the first paginated H page through explicit priority ordering, and adds a static contract. No source model, renderer, stock transaction, combat hook, purchase, filter/selection, portrait, or native frame geometry change. P0288 still requires a visual runtime test; P0289 is PREPARED / WSL AND WOW UNVERIFIED.

Important: no manual dev-panel alternative is required. After guarded apply, complete static pass and user push, deploy, `/reload`, open a trainer, `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST) and Live Trainer OFF. Capture status/screenshot. Do not use a new service audit to test this UI routing.

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
