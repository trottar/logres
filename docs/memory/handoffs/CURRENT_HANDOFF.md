# Current Handoff — P0289 live trainer H panel routing

Authority: `docs/memory/CURRENT.md`, D-046/D-047, and `docs/memory/evidence/P0289_TRAINER_LIVE_PANEL_ROUTING.md`.

GitHub P0288 `2e4b509` verified on main. **Negative:** P0288 registered `/logres nativetrainerlive on|off` commands but no developer-panel actions, despite the established H integration workflow. The user flagged this omission. No runtime screenshot/error for P0288 is yet verified. Prior P0285/86 numeric shape problem and P0287 R0 PREWRITE failure remain historical evidence.

P0289 PREPARED / WSL AND WOW UNVERIFIED: adds distinct H `Live Trainer ON (TEST)` and `Live Trainer OFF` action registrations in Core/Commands.lua and first-page priority in the paginated H panel. Existing H Trainer Skin ON/OFF remains registered, visible and separate. Handler, mouse-inert shared P0284 renderer, source probe, stock Blizzard trainer, and native transaction ownership are UNCHANGED. P0288 remains a read-only integration trial, not a purchase UI.

Next: apply guarded P0289 on exact P0288 baseline, full static suites, user push then verify main, deploy. With ordinary trainer open: `/logres panel` → H → Live Trainer ON (TEST), check resulting screen/stock click-through, then Live Trainer OFF and trainer-close recovery. Export only any reported errors/deferred reason; no generic service audit or forced purchase. WoW PASS is not yet established.

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
