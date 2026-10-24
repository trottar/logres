# P0325 — Backward-compatible domain migration dry-run

**Status:** P0325 pure Python migration proposal; production runtime and native state **UNVERIFIED**. Repository baseline: pushed P0324 `bc56185`, which established only offline D-048 five-system requested/effective/fallback tests. This checkpoint does not migrate a saved variable or implement any player-facing switch.

## Hypothesis and source observations

`Logres/Core/Database.lua` uses schema 3 with `immersionEnabled`, `activeQuestEnabled`, and other keys. `Logres/Core/Preferences.lua` publishes only those two named user preferences. `Immersion/Controller.lua` uses Immersion for stock ACT replacement and player/target/Quiet Mode policy, `Navigation/Compass.lua` follows Immersion, and `Quest/Dialogue.lua` conditions live NPC presentation on Immersion. The camera module's current behavior **cannot be inferred** from the old Immersion boolean; it is explicitly frozen by D-047. Saving five inferred booleans immediately could silently change gameplay.

## Proposed staged migration semantics — offline specification, not approval to wire

1. When loading a schema-3 save, keep all saved data and existing live policy unchanged. All five proposed domain requests begin in **`legacy` bridge** status; this is *not* a mode in the existing P0324 five-domain evaluation.
2. A subsequent **explicit user selection** of `logres` or `blizzard` for *one named domain* would create only a **draft override for that domain**. Other domains stay on the current legacy controller while their native restoration and lifecycle are separately proven. No implicit batch migration; an optional Immersion preset would be an explicit later decision.
3. Do not infer CAM from Immersion or automatically disable an accepted camera profile. CAM's eventual independently reversible state requires a separate D-047-approved client validation plan.
4. The draft returns a deep-copy of legacy saved settings and requested draft overrides. It never changes `LogresDB`, schema, prefs, `Core/Commands.lua`, camera, ACT/pet, NPC parking, or native presentation. `preview_mask` compares all 32 *explicit* chosen combinations with P0324; 4 combinations of legacy booleans remain unchanged.
5. Before deploying a real domain switch, add native-source capability evidence, restoration-first transition logic with combat deferral, requested/effective/fallback/pending diagnostics, and a separately validated schema migration with rollback/legacy recovery. Two independent NPC parking owners remain separate.

## Negative and risk classification

No in-game five-switch migration was attempted, and no new gameplay failure was observed by this static fixture. This draft does **not** prove Lua policy equivalence or Blizzard restoration. A premature mass initialization of five persisted booleans is **DEFERRED**, not an accepted migration. Python fixtures cannot validate client secure/secret state. P0321 gossip parking remains WoW **UNVERIFIED** until November 4; merchant and flight-master native handoffs remain primary NPC gaps. Retain all L-001–L-018 evidence and historical failures. D-046 preview-first and D-048 five-domain independence remain binding.

## Next work

After P0325 is verified: assess merchant and flight-master native source/transaction handoff in a read-only separate checkpoint, and prepare a Lua-equivalence *fixture* only if runtime changes remain isolated; don't expose five toggles until client validation. Target public-alpha-quality without a critical gameplay/native restore regression, not a fixed release date.
