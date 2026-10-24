# P0323 — Repository-wide modularity and ownership audit

**Authority:** verified `main` P0322 `272130eb9e80c3c51ebe5da08598453cdfc56a88` (2026-10-23 EDT). **Scope:** read-only source analysis of the 94 Lua entries actually loaded by `Logres/Logres.toc`, the five D-048 product domains, shared infrastructure, and cross-domain handoff obligations. This file is a static inventory, **not** evidence of new client execution. P0321 native gossip parking is still **WoW UNVERIFIED / DEFERRED until November 4**.

## Summary and boundary findings

- **94 loaded Lua source entries**, with no duplicate TOC entries. Directory distribution: Core 8, Media 1, Quest 40, Integration 1, UI 8, HUD 10, Actions 6, Immersion 8, Navigation 4, Camera 5, Dev 2, Settings 1. Every loaded file is listed in the generated inventory below in actual TOC order. Names are a *primary ownership classification*, not proof that the file has no secondary dependencies.
- **Current preference ownership remains coupled.** `Logres/Core/Preferences.lua` currently specifies only `immersionEnabled` and `activeQuestEnabled`; `Logres/Core/Database.lua` schema 3 persists these settings. `Logres/Immersion/Controller.lua:BuildPolicy` derives **action stock replacement**, **player frame suppression**, **target frame suppression**, and **Quiet Mode** from the same Immersion state. `Logres/Navigation/Compass.lua:ReconcilePolicy` also depends on Immersion. `Logres/Settings/Panel.lua` exposes only the two existing settings. Do not claim the five selectors exist now.
- **NPC work already has useful seams:** `Quest/NPCGossipSource.lua` collects validated source; `Quest/OptionModel.lua`, `Quest/NarrativeModel.lua`, `Quest/RewardModel.lua` are presentation models; `UI/NarrativePages.lua`, `UI/OptionList.lua`, `UI/DecisionVisual.lua` and `Quest/RewardVisual.lua` render; `Quest/NPCGossipChoice.lua` and `Quest/NPCGossipQuestChoice.lua` gate native actions; `Quest/NPCGossipStockParking.lua` is separately responsible for Blizzard presentation restoration. `UI/NPCServiceNativeParking.lua` separately owns trainer parking. **These two parking implementations must NOT be merged** without independent Forever proof.
- **Complex boundary files demand caution:** `Core/Commands.lua` (6,361 source lines), `Quest/Dialogue.lua` (2,279), `Camera/WorldCombat.lua` (2,084), `Navigation/NavigationSourceProbe.lua` (1,592), `Navigation/Compass.lua` (1,483), and `HUD/ClassPetSpecialProbe.lua` (1,476) are not candidates for wholesale pre-beta rewriting. Large size identifies an audit seam, not a reproduced runtime defect or automatic refactoring permission.
- **Shared infrastructure remains shared:** `Core/State.lua` samples game context, `Core/Modules.lua` handles lifecycle, `Core/Preferences.lua` publishes settings, `Integration/Layout.lua` owns semantic geometry, `Media/Theme.lua` owns assets/styles, and `Core/UIOwnershipAudit.lua` reports policy. D-048 requires a future requested/effective/fallback/pending report per domain; an existing stock policy flag must not be relabeled as actual Blizzard visibility proof.
- **Native ownership is capability-dependent, not a Boolean.** NAV must retain minimap/unsupported tracking information; ACT retains unsupported secure/pet/vehicle/override controls and bindings; NPC preserves quest detail/rewards, merchant, flight and other service transactions; STATUS retains party/target-of-target/unreplaced aura and special information; CAM remains frozen under D-047 until a separate consented runtime gate.

## Ownership matrix and isolation seams

| D-048 domain | Current primary modules | Shared or cross-domain dependencies | Native or runtime constraint | Preparation before November 4 |
| --- | --- | --- | --- | --- |
| NAV | `Navigation/{Compass,NavigationSourceProbe,QuestieDBLocationProbe,QuestieDBNearby}.lua` | `Core/Preferences`, `Core/State`, `Integration/Layout`, `Media/Theme`, QuestieDB optional provider | Compass eligibility follows global Immersion; complete minimap/tracking replacement unproven | Pure navigation presentation fixtures and provider-absence contracts; no minimap ownership change |
| ACT | `Actions/*.lua`; pet execution/presentation in `HUD/PetAction*.lua`; special controls in `Immersion/Pet*.lua` | `Immersion/Controller` presently drives stock action replacement; secure state, state/paging/layout | Combat, Edit Mode, native pet stock recovery and supported Bar 2–3 are distinct gates | Snapshot existing routing, bindings, activation/fallback contracts; defer secure action mutations |
| NPC | `Quest/*.lua` (gossip, dialogue, trainer, quest progress/offer/rewards); NPC submodules `UI/NPCService*.lua`, `UI/{OptionList,NarrativePages,DecisionVisual}.lua` | `Core/State`, `Quest/Dialogue`, UI shared renderer, NPC session, protected/native restore | P0320 observed selections; P0321 single-window parking unverified; merchant/flight transaction ownership native | Source/fixture audits for merchant and flight; preserve `Quest 237`, native quest handoff, and two distinct parking roots |
| STATUS | `HUD/{HUD,StatusAuras,PlayerHelpfulAuras,NativeDebuffs,AuraSourceEngine,WorldTargetProbe,ClassPetSpecialProbe}.lua`; `Immersion/{PlayerFrameReplacement,TargetFrameReplacement,NativeSurfaceReplacement}.lua` | `Immersion/Controller`, shared layout/theme, native aura/pet safety | No exact player HP; sparse enemy info; target/party/aura/target-of-target fallbacks; status parts follow global Immersion | Isolated source-normalization and preview cases; no status-shell suppression changes |
| CAM | `Camera/{ProfileContexts,ProfileBehavior,ReactiveZoom,WorldCombat,Probe}.lua` | Context/state, DynamicCam coexistence, NPC conversation context | **FROZEN** D-047/P0260: no camera Lua, CVars, profiles, event timing or DynamicCam modifications | Read-only mapping and independent-switch requirements only; defer camera implementation |
| SHARED | `Core/*.lua`, `Media/Theme.lua`, `Integration/Layout.lua`, `Dev/*.lua`, `Settings/Panel.lua`, `UI/PanelSurface.lua`, and other render primitives | All domains, SavedVariables, developer panels and feature policy | Core controller/diagnostic coupling, current global Immersion; changing API signatures can affect multiple domains | Candidate pure policy evaluator and deterministic 32-combination test matrix, inert five-switch settings preview; no live rewiring |

## Immediate extraction decision — ranked by preservation safety

| Priority | Candidate | Classification | Gate |
| --- | --- | --- | --- |
| 1 | **Pure five-domain requested/effective/fallback policy model + 32 synthetic combinations** | SAFEST NEW ISOLATED TEST/MODEL | No production preference schema changes, native mutations or automatic enable/disable; match D-048 and migration expectations |
| 2 | Existing small pure models (`Quest/OptionModel.lua`, `NarrativeModel.lua`, `RewardModel.lua`) + equivalent fixture coverage | EXISTING GOOD SEAM, PRESERVE CODE | Add tests/fixtures only; no renaming public exports or changing current quest choices |
| 3 | Shared style/presentation helpers (`UI/PanelSurface.lua`, `Quest/ContextVisual.lua`, `Quest/TrainerComponents.lua`, `Media/Theme.lua`) | AUDIT FOR DUPLICATION, NOT AUTOMATIC EXTRACTION | Require exact same renderer/output, baseline snapshots and visual proof later |
| 4 | High-level cross-domain orchestration (`Immersion/Controller.lua`, `Core/Commands.lua`, `Quest/Dialogue.lua`) | HIGH RISK — DEFER MUTATION | Needs supported migration, user-visible five-toggle policy contract, runtime native restoration proof and scope-specific tests |
| 5 | Secure ACT/pet, native `NPCGossipStockParking.lua`/`NPCServiceNativeParking.lua`, STATUS suppression and all Camera logic | FROZEN / NATIVE-PROTECTED | No generalization or merger without November 4 client evidence and separate authorization |

## Audit limitations and negative discipline

D-046 and D-047 remain authoritative for preview-first renderer parity, independently controlled interactions, and the frozen camera.

This inventory is a **static source pass**. Counted file loads and obvious interface names do not prove event order, combat/security behavior, runtime duplication, stable Blizzard restoration or that any 1.0 toggle already works. Merchant and flight-master APIs/transactions are not yet integration-certified. No new failure was reproduced by this read-only audit; historical P0321 patch-generation failures and all L-001–L-018 issue-register entries remain open in their documented classifications. DynamicCam and camera remain unchanged. The correct next bounded item is **P0324: pure requested/effective/fallback domain-policy fixture and 32-combination static contracts**, not five live switches.

## Full loaded-source inventory (canonical TOC order)

The following table is generated from the **actual checked-out `Logres/Logres.toc`** by the guarded P0323 applier. Primary domain follows module responsibilities in this audit. It is a path-complete source map, not a blanket assertion of exclusively local dependencies.

| Loaded Lua source | Primary system | Audit scope / boundary |
| --- | --- | --- |
| `Logres/Core/Bootstrap.lua` | SHARED | state, lifecycle, preferences, module control and audits |
| `Logres/Core/Database.lua` | SHARED | state, lifecycle, preferences, module control and audits |
| `Logres/Core/Preferences.lua` | SHARED | state, lifecycle, preferences, module control and audits |
| `Logres/Core/State.lua` | SHARED | state, lifecycle, preferences, module control and audits |
| `Logres/Core/Modules.lua` | SHARED | state, lifecycle, preferences, module control and audits |
| `Logres/Media/Theme.lua` | SHARED | shared semantic layout or theme assets |
| `Logres/Quest/QuestPanelConfig.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/TrainerPanelConfig.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/ServiceElementIndex.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Integration/Layout.lua` | SHARED | shared semantic layout or theme assets |
| `Logres/UI/PanelSurface.lua` | SHARED | reusable panel surface renderer |
| `Logres/HUD/HUD.lua` | STATUS | health/resources/auras/casts/target/pet state |
| `Logres/HUD/AuraStatusProbe.lua` | STATUS | health/resources/auras/casts/target/pet state |
| `Logres/HUD/PlayerHelpfulAuras.lua` | STATUS | health/resources/auras/casts/target/pet state |
| `Logres/HUD/AuraSourceEngine.lua` | STATUS | health/resources/auras/casts/target/pet state |
| `Logres/HUD/NativeDebuffs.lua` | STATUS | health/resources/auras/casts/target/pet state |
| `Logres/HUD/StatusAuras.lua` | STATUS | health/resources/auras/casts/target/pet state |
| `Logres/HUD/WorldTargetProbe.lua` | STATUS | health/resources/auras/casts/target/pet state |
| `Logres/HUD/ClassPetSpecialProbe.lua` | STATUS | health/resources/auras/casts/target/pet state |
| `Logres/Actions/Button.lua` | ACT | secure actions / routed stock fallback |
| `Logres/HUD/PetActionPresentation.lua` | ACT | pet action execution/presentation; secure and stock fallback |
| `Logres/HUD/PetActionExecutionProbe.lua` | ACT | pet action execution/presentation; secure and stock fallback |
| `Logres/Actions/Primary.lua` | ACT | secure actions / routed stock fallback |
| `Logres/Actions/MainReplacement.lua` | ACT | secure actions / routed stock fallback |
| `Logres/Actions/SecondaryUtility.lua` | ACT | secure actions / routed stock fallback |
| `Logres/Actions/Context.lua` | ACT | secure actions / routed stock fallback |
| `Logres/Actions/StockReplacement.lua` | ACT | secure actions / routed stock fallback |
| `Logres/Immersion/QuietMode.lua` | SHARED | native access / Quiet Mode shared policy |
| `Logres/Immersion/PlayerFrameReplacement.lua` | STATUS | stock player/target shell ownership |
| `Logres/Immersion/TargetFrameReplacement.lua` | STATUS | stock player/target shell ownership |
| `Logres/Immersion/Controller.lua` | SHARED | CROSS: global Immersion currently couples ACT, STATUS, Quiet Mode |
| `Logres/Immersion/NativeAccess.lua` | SHARED | native access / Quiet Mode shared policy |
| `Logres/Immersion/NativeSurfaceReplacement.lua` | SHARED | CROSS: multiple stock UI ownership/recovery surfaces |
| `Logres/Immersion/PetCombatCandidate.lua` | ACT | native pet controls; secure restoration gate |
| `Logres/Immersion/PetBarVisibilityTrial.lua` | ACT | native pet controls; secure restoration gate |
| `Logres/Navigation/Compass.lua` | NAV | compass sources / minimap fallback |
| `Logres/Navigation/NavigationSourceProbe.lua` | NAV | compass sources / minimap fallback |
| `Logres/Navigation/QuestieDBLocationProbe.lua` | NAV | compass sources / minimap fallback |
| `Logres/Navigation/QuestieDBNearby.lua` | NAV | compass sources / minimap fallback |
| `Logres/UI/OptionList.lua` | NPC | shared NPC list/narrative/decision/service presentation or lifecycle |
| `Logres/UI/NarrativePages.lua` | NPC | shared NPC list/narrative/decision/service presentation or lifecycle |
| `Logres/UI/DecisionVisual.lua` | NPC | shared NPC list/narrative/decision/service presentation or lifecycle |
| `Logres/Quest/ContextVisual.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/XP.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/OfferStockSuppression.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/CompletionControl.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NativeServiceCapabilities.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NativeServiceAccent.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NativeServicePlacementTrial.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NativeServicePolicy.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NativeTrainerRegionAudit.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NativeTrainerServiceProbe.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/UI/NPCServiceCatalogue.lua` | NPC | shared NPC list/narrative/decision/service presentation or lifecycle |
| `Logres/Quest/TrainerComponents.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/TrainerMotif.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/TrainerLandscape.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NativeTrainerSkin.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/TrainerLiveTrial.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/TrainerPurchaseTrial.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/OptionModel.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/OptionSession.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NarrativeModel.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/RewardModel.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/RewardVisual.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/Dialogue.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/Progress.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/ActiveQuest.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/InteractionProbe.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/OfferActionProbe.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Camera/ProfileContexts.lua` | CAM | FROZEN camera / DynamicCam baseline |
| `Logres/Camera/ProfileBehavior.lua` | CAM | FROZEN camera / DynamicCam baseline |
| `Logres/Camera/ReactiveZoom.lua` | CAM | FROZEN camera / DynamicCam baseline |
| `Logres/Camera/WorldCombat.lua` | CAM | FROZEN camera / DynamicCam baseline |
| `Logres/Camera/Probe.lua` | CAM | FROZEN camera / DynamicCam baseline |
| `Logres/Core/UIOwnershipAudit.lua` | SHARED | state, lifecycle, preferences, module control and audits |
| `Logres/Core/Commands.lua` | SHARED | CROSS: developer commands/diagnostic router; large/fragile |
| `Logres/Dev/MappingInspector.lua` | SHARED | developer inspection or player-facing preference shell |
| `Logres/Dev/Panel.lua` | SHARED | developer inspection or player-facing preference shell |
| `Logres/Settings/Panel.lua` | SHARED | developer inspection or player-facing preference shell |
| `Logres/Core/Lifecycle.lua` | SHARED | state, lifecycle, preferences, module control and audits |
| `Logres/UI/NPCServiceSession.lua` | NPC | shared NPC list/narrative/decision/service presentation or lifecycle |
| `Logres/UI/NPCServiceNativeParking.lua` | NPC | shared NPC list/narrative/decision/service presentation or lifecycle |
| `Logres/Quest/NPCTrainerFamilyProbe.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/TrainerCloseTrial.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/TrainerProfessionPurchaseTrial.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/UI/NPCServiceEmptyState.lua` | NPC | shared NPC list/narrative/decision/service presentation or lifecycle |
| `Logres/Quest/TrainerProfessionCloseTrial.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/TrainerFilterState.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/TrainerProfessionContext.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NPCGossipSource.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NPCGossipPresentation.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NPCGossipChoice.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NPCGossipQuestChoice.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
| `Logres/Quest/NPCGossipStockParking.lua` | NPC | quest/gossip/trainer; native quest/service fallback |
