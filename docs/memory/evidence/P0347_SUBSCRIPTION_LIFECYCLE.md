# P0347 — bounded state and preference subscription lifecycle

**Baseline:** GitHub main P0346 `26370095bd092d076868cd3d2e5e6a74f6b845d3`, 217/217 PREWRITE/POSTWRITE STATIC, version `0.0.236-dev`, WoW runtime UNVERIFIED.

## Source finding

Both `Logres/Core/State.lua` and `Logres/Core/Preferences.lua` append subscription records to private arrays. Both unsubscribe closures only set `subscription.active = false`; the array retains the record and its handler closure indefinitely. `Core/Modules.lua` intentionally calls these unsubscribers on failed enable/disable, and `Actions/Context.lua` renews a `SubscribeState` handler upon enable. Repeated enable/disable cycles therefore cause an append-only listener array and continuing linear scans over inactive records. This is a **static ownership/lifecycle finding**, not measured FPS impact or a user-reproduced memory fault.

## Narrow correction

- In each owning Lua module, compact inactive records in original order when no notification is dispatching. Idempotent unsubscribe clears the handler reference immediately and compacts outside dispatch.
- While notifying, mark a subscription inactive and clear its handler without altering the array being iterated; at the end of the outermost notification, compact in original order. A guarded dispatch (`pcall`) guarantees depth cleanup and reraises callback failures rather than suppressing them. Nested notifications retain the same subscriber order and copy-on-callback semantics; no initial replay or extra notification.
- No changes to `Core/Modules.lua` or any subscribing module; preserve ordinary state snapshots, persisted preference schema 3, event list, observation, camera, secure/native restoration, and D-048 domain-selection deferral. No new loaded Lua file or developer-panel action. TOC/Bootstrap bump to `0.0.237-dev` in parity.

## Verification and limitations

Contract #218 checks both implementations, source ordering, deliberate nested/idempotent/deferred cleanup requirements and absence of registry/schema/secret changes. The P0347 applier requires 218/218 static PREWRITE shadow and POSTWRITE checks, no tracked partial writes on PREWRITE refusal and transactional rollback on POSTWRITE failure. Client behavior is **UNVERIFIED**. The improvement bounds stale listener growth but is not a measured runtime speedup. Keep the P0321 GossipFrame restoration-first in-game safety gate for the contingent November 4 client; L-022/L-027/L-028 remain OPEN and L-019 public license BLOCKED.

## P0347 R0 refused source candidate and R1 historic-checker migration

On 2026-10-25 (EDT), the user verified P0347 R0 ZIP integrity and invoked the guarded applier on pushed P0346 `26370095bd092d076868cd3d2e5e6a74f6b845d3`. The **R0 PREWRITE shadow REFUSED 1/218**: `tools/check_p0346_architecture_health_contract.py` asserted an **exactly 217** checker inventory and therefore rejected P0347's new checker #218. No tracked writes occurred. This was an assistant packaging/integration test miss, not an addon runtime failure or user error. R0 is **CLOSED / REFUSED**.

R1 updates only P0346's brittle count assertion to a **minimum 217 historical checkers**, preserving P0346's source inventory, TOC parity, panel registration, 38 previews, source negative tests, memory continuity, and P0346 evidence. The new P0347 applier still requires **exactly 218** distinct checker files and successful 218/218 PREWRITE shadow and POSTWRITE execution. The migration is included in exact pushed P0346 baseline blob verification and P0347's manifest. It does not weaken the former requirement to run the full suite and allows later checkers without rebreaking archived audit policy. All WoW gameplay remains **UNVERIFIED**.
