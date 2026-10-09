# P0177 — Aura-source comparator: source basis and runtime gate (2026-10-08)

## Observed prerequisite

GitHub `main` verified at `5379a9f`, P0176 R1 `0.0.92-dev`. Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`, loadCount 224: Phase H preview ON yields player=2 and target harmful/helpful=2/2, but session live history stays zero during preview; Preview OFF shows no player harmful or target. A naturally populated target HELPFUL read then yielded targetHelpful max=1, positiveReads=4, while playerHarmful and targetHarmful remained max=0. Later hostile/target scans showed protected-index/payload skips; final history reported 456 cumulative skips from 53 scan observations, **not** unique hidden auras. No `failures` were reported in status source history. Full `checkall` completed, preference Immersion ON, HUD visible=true, native UI folded 5/open 0 and castGate escapes=0. This proves session-history logic and a narrow helpful-source path, but **not** harmful-source visibility or full UI replacement.

## External addon source audit

- WeakAuras 2, `WeakAuras/BuffTrigger2.lua` at `https://github.com/WeakAuras/WeakAuras2/blob/main/WeakAuras/BuffTrigger2.lua`: `AuraUtil.ForEachAura` in modern branch, per-unit tracking with UNIT_AURA invalidation, distinct match/trigger/filter systems. The implementation is much larger than Logres needs and its current API surface does not establish Forever secret safety.
- Plater, `https://github.com/Tercioo/Plater-Nameplates/blob/master/Plater_Auras.lua`: distinct helpful/harmful scan/display, `GetAuraSlots` + `GetAuraDataBySlot`, UNIT_AURA caching. On Forever, a slot ID or aura payload could be secret. Do not copy its access pattern without a proven secret-first slot gate.
- `https://warcraft.wiki.gg/wiki/API_C_Secrets.ShouldUnitAuraIndexBeSecret`: explicit preflight predicate for indexed queries and source filters.

The architecture is independently implemented. No WeakAuras or Plater Lua was copied, and no third-party addon is embedded as a runtime dependency.

## Hypothesis and test

The existing priority filters might exclude some ordinarily accessible general `HARMFUL` rows, or all relevant indexed rows might be secret on the observed client. P0177's own `AuraSourceEngine` compares base `HARMFUL`/`HELPFUL` reads to bounded priority-filter reads while secret-checking every index. Diagnostic output distinguishes absent unit, empty termination, ordinary icon candidates, secret index/predicate/payload/field count, and ordinary API/invalid failures. This is a **read-only source comparison**; it is not a debuff fix or a runtime PASS yet. Preview is excluded; unavailable API and absent target defer. If base harmful is ordinary while priority is empty, a future evidence-backed promotion can reroute presentation. If both are secret, preserve native fallback and do not bypass restrictions.

## Open failures / limitations

Historical P0175 R2 nil-row crash and original P0176 prewrite checker failure remain preserved, already corrected in R3 and R1. One brief loot-associated ObjectiveTracker frame flash is OPEN / INTERMITTENT / UNREPRODUCED; no new suppressor is justified. Live player/target harmful source remains DEFERRED; correct debuff visuals cannot be declared PASS. The new engine's API availability and safe scan behavior need in-client validation before production use.
