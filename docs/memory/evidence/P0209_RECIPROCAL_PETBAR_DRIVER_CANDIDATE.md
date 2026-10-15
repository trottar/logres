# P0209 — reciprocal native pet action visibility driver trial (2026-10-13)

## R0 prewrite failure (2026-10-13; no tracked files written)

The user ran the delivered P0209 R0 applier on the verified P0208 main baseline. It passed exact HEAD/worktree pins and the shadow checker suite through `check_main_replacement_contract.py`, but then `check_memory_health.py` failed with **two errors**: CURRENT's mandatory `## Verified State` heading occurred zero times (the generator used `## Source and Evidence Boundary` instead), and CURRENT_HANDOFF contained no literal `CURRENT.md` authority reference. **P0209 R0 APPLY FAIL / PREWRITE / NO TRACKED WRITE.** This was a generator/schema error, not a runtime failure or user worktree drift. R1 restores required headings/authority and adds an independent candidate-memory preflight before any shadow work. This negative result remains durable after any later successful runtime test.

Parent verified pushed `main` `f6b9a3a58bfc9081043455038df33b706c6e9e6f` (P0208). Logres `0.0.113-dev` user loadCount 268 screenshots showed Blizzard PetFrame and PetActionBar present under Immersion ON; stock fallback successfully visible, intended immersive pet suppression still OPEN. The commit is a safety checkpoint, **not** final replacement proof.

## Exact client source and narrow hypothesis

WoW Forever `1.60.1.70338`, `Gethe/wow-ui-source@943764493e6b16d63ded3ab304150d1f05e58b57`: `PetActionBarMixin:OnEvent` uses direct Show on `PET_BAR_UPDATE`, `UNIT_PET` (player), `PET_UI_UPDATE` and `UPDATE_VEHICLE_ACTIONBAR`; ordinary addon Hide is combat-unsafe and native may re-show. `Blizzard_RestrictedAddOnEnvironment/SecureStateDriver.lua` `RegisterStateDriver` resolves `state-visibility` securely; `UnregisterStateDriver` removes driver but **does not inherently clear `statehidden`**. Thus a reversible out-of-combat driver *might* arbitrate visibility, but no source proves correct interaction with Edit Mode or Blizzard Show. The prior P0206 R2 hidden-parent trial caused protected-action error and failed stock restoration; **reparenting remains rejected**.

P0209 tests reciprocal visibility rather than permanent native suppression: when session-opted-in **outside combat**, secure native PetActionBar `[combat] show; hide`; secure Logres pet cluster `[combat] hide; show`. In combat the stock bar is intended to be available and Logres duplicates removed; outside combat the Logres cluster is intended to be primary. Registration occurs only if existing addon-owned probe counters indicate armed, configured, nonempty secure pet actions and immersion is ON. The code does not branch on secret-capable pet API values or inspect Blizzard native visibility. It does not mutate PetFrame. Pressing OFF or PET STOCK first restores stock via secure `show` state, then unregisters drivers, only out of combat. Immersion OFF/disable also requests release; during combat release defers and the preinstalled native `[combat] show` ensures stock fallback. No active driver survives a fresh `/reload` because this trial is session-only default OFF.

**Limitations / risk:** This is a runtime hypothesis, not an approved fix. The exact in-client compatibility of direct driver registration on Blizzard's Edit Mode-owned PetActionBar, flash races with native `Show()`, transition ordering, and native `statehidden` restoration are UNVALIDATED. Edit Mode must be tested **with trial OFF** first; entering while armed is not yet an accepted scenario. The secure manager may show stock briefly on Blizzard pet events before reevaluation. Presence of source API is not proof of uninterrupted secure fallback; do not accept P0209 from checkers/counters alone.

## Negative evidence retained and new gate

P0206 R0 panel overflow, rejected R1 slash-only workaround, R2 protected-function/restoration failure, R3 version-pinned checker, R4 missing payload, R5 petActions still folded, R6 PetFrame still folded/intermittent stock absence; P0208 R0 wrong baseline pin and R1 false quarantine literal gate remain historical failures. P0208 stock-first fallback visual return PASS **bounded to screenshots**; no full click/edit/combat pass. P0197 in-combat duplicate remains OPEN. Neither R2 hidden-parent nor polling/unsafe Hide is revived.

## Required runtime sequence (developer panel)

1. Deploy, `/reload`, Phase H **Pet Bar Driver Check**: requested=false armed=false; Phase H Native Access Check: petFrame:stock petActions:stock. Observe stock native pet unit/action UI.
2. Pet active, outside combat; Phase H **Pet Bar Driver ON (TEST)**. Expect addon-owned `armed=true` only if capability ready. Visually inspect native pet action bar absence **outside combat** and interactive Logres secure actions. PetFrame intentionally remains Blizzard stock.
3. Phase H **Pet Bar Driver OFF**, verify Blizzard native action buttons visible/working. Phase D Immersion OFF/ON separately, and Edit Mode entry/exit with trial **OFF**. Recheck BugCatcher.
4. If ordinary combat occurs while trial ON, observe native action bar accessible and Logres duplicate hidden, then return to Logres outside combat. Do not force combat. Any protected action, taint, missing native fallback, duplicate, or lost interaction means FAIL and STOP. Do not commit a failed runtime candidate.
5. Capture panel output from Check/Native Access both OFF and ON and user-visible result. ON only means secure-driver registration reported success, not proof of native visual state.

No WoW runtime result is claimed by this patch. PetFrame replacement, editor-safe driver behavior, final combat-safe ownership and visual polish remain OPEN. No automated production default ON without positive evidence.

## P0209 R1 negative result — LUA UPVALUE LIMIT / PREWRITE FAIL

User's extracted P0209 R1 applier passed `check_memory_health.py` and 86 other checkers, then stopped before tracked writes at `check_ui_ownership_audit_contract.py`: `ERROR: handleCommand would capture 61 locals; Forever limit is 60`. P0208 baseline already captured 60. R1 added `local function runPetBarDriverCheck()` and invoked it within `handleCommand`, creating one more upvalue. R1's restricted fixture did not run this repository checker. R2 makes the diagnostic `Logres:RunPetBarDriverCheck()` (no added captured local) and preflights the actual checker calculation before all shadow checkers. **R1: FAILED / PREWRITE / NO RUNTIME TEST**; this is not a user/environment issue. Preserve P0209 R0 invalid memory-schema failure separately. The secure visibility hypothesis remains unverified in WoW.

## P0209 R2 actual runtime outcome (2026-10-14)

P0209 R0 memory-health PREWRITE FAIL; R1 61/60 Lua upvalue PREWRITE FAIL; R2 applied and ran in WoW (`0.0.114-dev`, loadCount 269) but **RUNTIME FAIL for intended combat behavior**: pressing trial ON removed the Blizzard pet bar out of combat, then the `[combat] show; hide` native / `[combat] hide; show` Logres state drivers removed Logres pet actions and showed Blizzard's bar during combat. This was the authored reciprocal policy and contrary to user intent. No push. P0208 `f6b9a3a` remains the verified HEAD. P0197 combat duplicate remains OPEN. See `docs/memory/evidence/P0209_R3_NATIVE_REUSE_EVIDENCE.md`.

R3 corrective trial details in `P0209_R3_NATIVE_REUSE_EVIDENCE.md`.
