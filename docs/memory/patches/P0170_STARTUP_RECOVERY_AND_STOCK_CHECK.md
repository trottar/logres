# P0170 — Stock Bar first-login recovery and truthful diagnostic

Date: 2026-10-08. Baseline: verified `74ff4156376c40d96efc100ed2f33415e6462291` (`0.0.86-dev`). Candidate: `0.0.87-dev`. **Status: PREPARED / STATIC PREWRITE GATE REQUIRED; RUNTIME PENDING**.

## Change

- On the original clean-login `Settings.GetValue` unknown result for native Bar4/5, keep `requestedEnabled=true`, mark `pending=true`, preserve all stock mouse/visual state, and count a deferral. Reply `deferred` through existing ImmersionController contract.
- Reattempt only on actual `PLAYER_ENTERING_WORLD`, `EDIT_MODE_LAYOUTS_UPDATED` and `PLAYER_REGEN_ENABLED` events. If an event is too early, the pending state persists without periodic work; native UI stays usable. Reset stale pending on successful apply or unrelated hard failure.
- Preserve last-known safe native source visibility so a temporary nil cannot hide a working Logres extra cluster while stock is suppressed. Add sourceDeferrals/retryCount/lastRetryEvent to addon-owned recovery/debug state.
- Phase C Stock Replace Check now compares Immersion preference (desired) with requested/applied, pending, lastError and snapshot state before calling PASS. It emits startup retry evidence on PASS and FAIL. Update both existing and new static contracts.
- No geometry change, no newly hidden stock domains, no CVar or persistent key edits, no protected-state readback, no polling. Existing exact stock restoration/binding routing untouched.

## Runtime gate

1. Apply only if expected P0169 pushed main and clean tracked baseline; applier builds exact shadow candidate, checks `git diff --check` and full checker suite before writing, and runs suite again after transactional write.
2. Deploy and `/reload`; first run Phase C → **Stock Replace Check before Run All or Immersion toggles**. Immersion ON must show `expected=true requested=true applied=true pending=false error=nil`, Bar2–5 stock alpha 0/no mouse and corresponding Logres routing. Then Action Check, Layout Check (15 anchors, 17 binds) and Run All.
3. Immersion OFF restores original bars/mouse and ON reapplies; test button clicks and configured Bar4/5 hotkeys; reload a second time with Immersion ON. No Lua, taint, protected, secret-value error. User owns commits and pushes; patch is not durable until pushed commit verified.
4. Unobserved or still-unavailable source configuration is an **environmental deferral or failure**, not PASS. Preserve the P0169 initial failure even if P0170 eventually succeeds.

## R0 rejected during applier construction

The first P0170 ZIP stopped before any tracked changes: `Commands.lua` transform demanded incorrectly indented `tostring(status.initialized)` fragments (12 spaces vs actual eight). No checker or runtime result can be claimed from that run. R1 corrects the baseline anchor only; original runtime objective, gate and preservation policy are unchanged. See P0170 failure section in the canonical evidence record.
