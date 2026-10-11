# P0189 — Default Immersion ON secure Main gate (runtime candidate)

Date: 2026-10-11. Baseline: verified `main` `a1e85e79a89917fa2c3b84b0cb738f1f13e68d37` (P0188 R1); runtime `0.0.100-dev` -> `0.0.101-dev`.

## Narrow hypothesis and change

P0187 R2 manual normal-screen ON/OFF/ON already passed. The remaining user-reported ordinary unwanted native bar can use the same capability-gated secure Main parent gate at login, rather than a second suppression mechanism. P0189 initializes session intent to automatic on module enable, then reconciles only when Immersion ON and native/Primary normal-mode preflight is ready. The Primary module registers/enables before Main. `PLAYER_ENTERING_WORLD` and native action-mode change events provide bounded retries. No OnUpdate/timer/global Show hook/blanket suppression.

Explicit `/logres mainreplace off` is a session opt-out that survives Immersion toggles and the developer lifecycle check; explicit `on` re-enables. `/reload` resets to automatic default. Immersion OFF and Edit Mode restore native Main; combat-time protected changes defer and existing secure state driver keeps native special paths when already engaged. Initial unsafe/unready special state stays Blizzard-owned with diagnostic pending rather than FAIL; actual gate/restore errors still report FAIL. No preference database migration or persistent toggle is introduced in this checkpoint.

## Negative evidence and boundaries

Preserve P0187 R0 failed repeat ON, P0187 R1 packaging checker mismatch, and P0188 R0 whitespace failure as negative history. User-approved P0187 R2 normal manual behavior does not prove fresh-login auto timing, eventual recovery from initial special mode, secure special transitions during combat, native editor interaction, or complete absence of invisible click regions. This is a **candidate, not runtime PASS**. Missing special gameplay is DEFERRED, not PASS. The 35-row ownership audit still marks Main STOCK intentionally as a fallback policy; do not change it from static assumptions.

## Runtime validation

After deploy and `/reload` with Immersion ON, Phase D **Main Replace Check** must say CANDIDATE, `armed=true`, `applied=true`, `optOut=false`, `error=nil`, *without pressing ON*. Test Logres Primary actions and hotkeys, ordinary Main absence and lack of ghost click region. Press Main Replace OFF: native Main returns and `optOut=true` with stock action/key access. Toggle Immersion OFF/ON: opt-out must persist. Press ON: candidate returns; toggle Immersion OFF: stock returns; toggle ON: candidate returns. Enter and exit Edit Mode and confirm safe stock editing/restoration. Run Phase 0 Run All and UI Ownership, inspect Lua/taint/protected/secret errors. If initial mode is special or unavailable, stock must remain available; test natural mode return only when available. Do not manufacture unavailable special gameplay or mark it PASS.

H.1 remains OPEN pending observed startup and fallback checks; H.2/H.3 follow separately. The static checker protects event-only opt-out/preflight/restore invariants, not runtime behavior.
