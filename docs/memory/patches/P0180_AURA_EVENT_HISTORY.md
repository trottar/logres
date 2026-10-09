# P0180 — event-latched aura source comparison and safe target reaction

Date: 2026-10-09. Baseline: verified `main` `8f5d94ff8e8c9e2876dd993765f8865ea54e244c` (`0.0.95-dev`). Candidate: `0.0.96-dev`. Runtime PENDING.

## Scope

- Reuse `StatusAuras` existing `UNIT_AURA` and `PLAYER_TARGET_CHANGED` invalidations; no event registration, polling, broad frame hooks, or Blizzard mutations.
- Add bounded session-only canonical `HARMFUL`/`HELPFUL` against priority-filter evidence in `AuraSourceEngine`. Ordinary empty base results skip priority scans; populated, protected, or indeterminate base results receive priority comparison. Limit each scan to the existing 12-index bound. Record only sanitized counts/reasons, not aura objects, spell identity, unit identity or icons.
- Where available, classify target from safely checked ordinary `UnitCanAttack`/`UnitIsFriend` booleans; restricted/unreadable reaction is **unknown**. An attackable/hostile label is not PvP or detailed affiliation proof.
- `Status Aura Check` and Run All print three new history lines; preview and Immersion OFF never record. Preserve existing P0176 history, live selection/rendering, native aura fallback, UI ownership matrix (35 unchanged), stock cast gate and mana/resource UI.
- Add a static contract covering event guard, no new registration, scope and history output. No additional locally captured slash handler functions (the original P0178 >60-upvalue failure remains preserved).

## Acceptance

Deploy/reload, verify `/logres status` and Phase 0 Run All, Phase H Preview ON/OFF, and Phase H Status Aura Check. Event history remains at zero during preview and Immersion OFF; ordinary real event observations accumulate during ON. `hostileMax>0` for target helpful/harmful is only a source evidence candidate and still requires visual verification; no forced combat is required. `restrictedEvents` counts scans with blocked indices, **not hidden aura identities**. No source counters justify new stock suppression.

## Limitations

No naturally populated harmful data was available in loadCount 229, and the earlier target HELPFUL observation lacked confirmed hostility. Both remain OPEN/DEFERRED. The intermittent ObjectiveTracker flash remains OPEN/INTERMITTENT/UNREPRODUCED. Primary/special/pet/party/minimap/full-quest ownership remains capability-gated. No production aura renderer promotion occurs in P0180.

## P0181 outcome — observed P0180 acceptance (2026-10-09)

Verified user-pushed `main` `d45097c` with P0180 `0.0.96-dev`; latest loadCount 232 persisted **Phase 0 Run All complete**, including ownership ON `17 PASS / 18 STOCK / 0 FAIL / 0 DEFERRED`, no recorded Lua/command failure. Event history behaved correctly on naturally available source data and preview/Immersion guards in earlier loadCount 230/231. Only a friendly target general-filter HELPFUL candidate was ordinary-positive; player/target HARMFUL and hostile-target HELPFUL population remain DEFERRED. Stock auras stay available. See P0181 evidence for explicit scope and the recorded panel/slash communication failure. Original P0180 candidate text above remains historical.
