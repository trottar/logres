# P0188 — Accept P0187 R2 normal Main runtime and open persistent integration gate

Date: 2026-10-10. Baseline: `main` `41c7d972d8bd32537ccd4a956f85617a081d27b7` (P0187 R2, `0.0.100-dev`).

Documentation and evidence ONLY. No Lua, static checker, runtime version, or WoW deployment changes.

## Accepted tested scope

User confirms P0187 R2 worked as expected. Latest diagnostic export: `LOGRES_DIAGNOSTICS_LATEST.lua`, build 70338, loadCount 238, `0.0.100-dev`.

- After reload, Main replacement `STOCK` (`activations=0`, `restores=0`, `error=nil`).
- ON `CANDIDATE`, OFF `STOCK`; second ON `CANDIDATE` (2/1), idempotent ON `already-active`; second OFF `STOCK` (2/2); subsequent ON `CANDIDATE` (3/2).
- Integrated Run All eventually shows `activations=7`, `restores=6`, `armed=true`, `applied=true`, `pending=false`, `route=true`, `error=nil` after preference toggles; `actioncheck PASS` with 12/12 Primary buttons and active keys.
- 35-row UI Ownership Check `17 PASS / 18 STOCK / 0 DEFERRED / 0 FAIL`; this static-policy audit **still marks Main STOCK** and is not proof of native presentation visibility.
- User reports behavior worked as expected. Acceptance covers observed ordinary-screen visual/interaction and restoration; the diagnostic does not independently prove native click-region geometry, special-state transitions, Edit Mode, or in-combat protected behavior.

## Remain open

H.1 remains OPEN for deliberate automatic / persistent Immersion ON ownership and protected special-state fallback proof. P0187 defaults session-only OFF after reload. Existing Main `STOCK` UI ownership policy and Primary's historical read-only `stockSuppressionAuthorized=false` remain valid; only the separate P0187 candidate path is runtime accepted for tested normal mode. Vehicle/override/possess/bonus/form/petbattle runtime absence remains **environmentally DEFERRED**, not PASS. Do not require contrived gameplay to prove unavailable states.

P0187 R0 repeat-ON `secure normal mode gate not established` remains a historical runtime FAIL; R1 original delivery hash rejection remains delivery FAIL; R2 corrected both and was pushed. P0188 R0 delivery FAILED before tracked writes on 2026-10-11: the generated patch record contained trailing whitespace at line 13, caught by the applier prewrite check. P0188 R1 removes this whitespace; there was no tracked mutation from R0.

No Lua, taint, protected, or secret error was observed in the supplied final normal-mode diagnostic, but such failures outside that scope cannot be ruled out.

## Next work item

P0189 design/implementation gate: establish an explicit preference/default activation and startup reconciliation that engages only when Main secure mode is safely `normal`, with immutable Blizzard special fallback, out-of-combat rollback, mode-return recovery, OFF/Edit Mode restoration, and no periodic reassertion. Start from current source and the P0187 acceptance evidence; do not promote manual candidate to always-on until that behavior is separately runtime tested. Whole-screen H.2 layout follows H.1 safe ownership; H.3 polish later.
