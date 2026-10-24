# P0323 — all-source modularity and ownership audit evidence

## Scope and observations

- GitHub branch `main` verified at P0322 `272130eb9e80c3c51ebe5da08598453cdfc56a88`. TOC source lists **94 distinct Lua entries**; all were inventoried from the remote source. Target code paths read during audit include every loaded Lua source and the D-048 and launch records. This is source evidence, **not** an in-game test.
- `Core/Preferences.lua` contains `immersionEnabled`, `activeQuestEnabled`; `Core/Database.lua` schema 3. `Immersion/Controller.lua:BuildPolicy` derives action replacement, quiet-mode and player/target native policy from Immersion. `Navigation/Compass.lua:ReconcilePolicy` uses Immersion. `Settings/Panel.lua` exposes only those two settings.
- `Quest/NPCGossipSource.lua`, `NPCGossipPresentation.lua`, `NPCGossipChoice.lua`, `NPCGossipQuestChoice.lua`, `NPCGossipStockParking.lua`, `OptionModel.lua`, `OptionSession.lua`, `NarrativeModel.lua` and shared `UI/*` presentation modules demonstrate existing bounded source/model/control splits, albeit coupled through `Quest/Dialogue.lua`. Separate trainer native parking exists at `UI/NPCServiceNativeParking.lua` and must not be merged speculatively.
- `Core/Commands.lua` 6,361 lines; `Quest/Dialogue.lua` 2,279; `Camera/WorldCombat.lua` 2,084; `Navigation/NavigationSourceProbe.lua` 1,592; `Navigation/Compass.lua` 1,483; `HUD/ClassPetSpecialProbe.lua` 1,476. Large size alone is not a bug, and static inspection does not establish a safe behavioral refactor.
- D-047 **freezes camera** and Quest 237; D-046 requires identical fixture/model/render path. D-048 requires five independent requested/effective/native-fallback/pending states and 32 deterministic policy combinations. No new runtime modifications are authorized by audit findings.

## Classification, limits and required follow-up

- P0321 single-window gossip parking remains **runtime UNVERIFIED / DEFERRED until November 4**. The earlier P0317–P0320 user observations apply only to their tested scope, not every native service/restore path.
- Merchant and flight-master are the two principal remaining NPC service handoffs. Native vendor/flight transactions remain Blizzard-owned until capability and client evidence justify anything else; no paid transaction or travel proof is required solely to create a screenshot.
- Existing consolidated `ISSUE_REGISTER.md` L-001–L-018 remains authoritative. No new bug reproduced by static audit. Test/verification failures, environmental deferrals and intermittent issues retain their classifications; no polling or broad hooks.
- Correct next bounded work: P0324 inert pure policy fixture and 32-combination tests, with explicit backward compatibility against currently saved booleans. Runtime domain activation, secure actions, combat-native restoring, camera/DragonCam and generic native parking are excluded until separate supported runtime validation.

## Verification status

P0323 prepared docs and a deterministic inventory checker against exact remote source; author-side checks cover ZIP, Python syntax, actual generated candidate inventory, candidate diff hygiene and targeted checker. **Full 194-checker PREWRITE/POSTWRITE and WoW runtime tests have not been executed in this artifact build environment**. The WSL one-time applier must enforce the full suite transactionally; do not claim PASS before results. No WoW redeploy is required for docs-only P0323.
