# P0349 — Native UI diagnostic ownership seam

**Source baseline:** verified pushed GitHub `main` P0348 `4b7481d731d5f90e214b285bc7cce16ec826176f`; P0348 manifest 219/219 PREWRITE/POSTWRITE **STATIC**, version `0.0.237-dev`. WoW runtime **UNVERIFIED**. No client available; no client PASS or performance claim.

## Narrow hypothesis and source evidence

`Logres/Core/Commands.lua` has a ~70-line `local function runNativeAccessCheck()` which reads only addon-owned `NativeAccess`, `NativeSurfaceReplacement` and `PetCombatCandidate` debug status and emits four report lines: `Logres nativeuicheck`, `Logres native-surfaces`, `Logres petbar-reshow`, and `Logres petcombat`. This report belongs to the already-loaded `Logres/Core/UIOwnershipAudit.lua` which explicitly owns read-only native/Logres presentation provenance. `Logres/Logres.toc` loads UI objective ownership audit before Commands. The existing command entry, Run All and panel registration are stable and do not need changes.

The report does **not** prove protected Blizzard frame visibility. `NativeAccess` and pet state are cached owner diagnostics. Existing stock actions must remain accessible.

## Minimal extraction

Move only the original `runNativeAccessCheck` body, byte-for-byte, into `Audit.RunNativeAccessCheck(emit)` in `Logres/Core/UIOwnershipAudit.lua`; change only its function header. Retain the preexisting command-local `runNativeAccessCheck()` wrapper and forward the existing `emit` sink to `Logres.UIOwnershipAudit.RunNativeAccessCheck(emit)`. The report has no return value; its four output strings, `PASS`/`FAIL`/`DEFERRED` classification and arguments are not altered. No new timer, native setter, global event, protected/secret read or frame inspection. `Core/UIOwnershipAudit.lua` already loads before Commands and the function is called only after the addon loads. Nothing changes at addon load beyond defining one function.

Retain exactly **94** loaded Lua files and **120** developer-panel actions (38 P previews); `Core/Commands.lua` is measurably smaller, but no FPS improvement is claimed. Version parity advances to `0.0.238-dev` for the runtime Lua change. D-048 selectors, schema 3, camera and current coupled Immersion presentation remain untouched.

## Historical contract migration

The initial R0 source audit exposed four historical source checkers that expected these lines to remain **physically inside Commands.lua**: `check_native_pet_aura_replacement_contract.py` (`native-surfaces`); `check_native_pet_reshow_recovery_contract.py` (`petbar-reshow`); `check_pet_combat_candidate_contract.py` (`petcombat` and rejected-counter field); and `check_native_cast_gate_contract.py` (cast gate diagnostics). Simply relocating code would have caused PREWRITE refusal. R0 migrated those four presence assertions to `Core/UIOwnershipAudit.lua` while leaving each original native-source safety and dispatch assertion intact. P0349's new checker guards that all four migrated tests still check the correct owner and original tokens. R1 also migrates the two P0174 checkers listed below, preserving all original native safety assertions. Historical checker migration is explicit, not a deletion or an arbitrary bypass.

## Verification / open work

P0349 checker #220 guards the same single delegation, exact four report strings and order, source separation, no NativeAccess setters, load order and historical P0172/P0178 contracts. Shadow PREWRITE 220/220 and POSTWRITE 220/220 **STATIC** are required in the user's WSL checkout; they do not mean WoW acceptance. P0321 GossipFrame safe restore remains first contingent November 4 in-client gate. L-022 quest visual artifact, L-027 native XP/quest popup owner, L-028 target auras remain **OPEN**; L-019 root license **BLOCKED**. Future diagnostics may be extracted only with distinct owner, regression proof and historical-contract preservation, not wholesale refactoring.

No runtime/in-client validation attempted in this source-only environment. No prior negative result is erased (including P0347 R0 PREWRITE refusal).

## P0349 R0 refused candidate and R1 source-contract correction

**P0349 R0 PREWRITE REFUSED 2/220.** On 2026-10-26 (EDT), the user verified R0 ZIP SHA-256 and ran guarded `P0349_APPLY.py` on verified P0348 `4b7481d731d5f90e214b285bc7cce16ec826176f`. PREWRITE shadow **REFUSED 2/220** before tracked writes: `tools/check_interaction_native_contract.py` (index 50/220) still required `expected and 5 or 0` and `castStockOnDemand=true` physically within `Commands.lua`, and `tools/check_native_reshow_contract.py` (index 62/220) still required `result.pendingRefolds == 0` and `nativeShows=%s/%s combatDeferred=%s pending=%s` there. These tokens correctly moved with the untouched four-line native diagnostic body into `UIOwnershipAudit.lua`; R0 migrated four other historical checker owners but **missed these two**. This was an assistant integration-test omission, NOT a WoW failure or user error. **R0 CLOSED / PREWRITE REFUSED; no tracked writes.**

R1 adds both P0174 checker files to the exact Git-blob guard and redirects ONLY their historical diagnostic-token lookups to `Core/UIOwnershipAudit.lua`; native source behavioral, interaction, protected/cast, re-show and fallback assertions are unchanged. It adds both migrations to P0349 checker #220, retains the original four checkers' migrations, and requires 220/220 PREWRITE and POSTWRITE PASS before acceptance. Do not weaken or delete historical native safeguards to obtain a passing suite. The error demonstrates why a pure synthetic checker subset cannot establish complete historical checker compatibility.
