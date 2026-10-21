# P0285 — Forever trainer native-source feasibility: evidence and limits

Baseline: verified pushed Logres `main` `c773a942d18d84c919841063a84bc6ff94ece567` (P0284), 2026-10-21.

## Client evidence

**P0284 P-preview VISUAL PASS, WITH LATER POLISH DEFERRED:** user screenshot shows a portrait-free, warm-parchment 896×712 trainer composition including search, Filters/Categorize, skill catalogue with selected-vs-ordinary contrast, details/reagent, Funds, Train and disabled Train All. User: "Looks good. Could use refinement, but that can be done with the other refinement." This is acceptance of the synthetic visual fixture, NOT a live trainer capability PASS. The existing P0279 mapping probe previously highlighted native trainer controls, and P0278 ScrollBox motif had scoped runtime activation. Neither establishes read-safe data for the Logres landscape or secure transaction ownership.

## Independent addon/source investigation

- **ElvUI** `ElvUI/Game/Shared/Skins/Trainer.lua`: Forever's `ClassTrainerFrame.ScrollBox:ForEachFrame`, list categories versus icon-bearing rows, `ScrollBar`, `FilterDropdown`, `ClassTrainerStatusBar`, `ClassTrainerFrame.money`, selected skill, and native Train. Its implementation directly rearranges native row children and skins native frame geometry. **Do not copy or transplant**; use only evidence about source ownership/lifecycle.
  https://github.com/tukui-org/ElvUI/blob/main/ElvUI/Game/Shared/Skins/Trainer.lua
- **Aurora Classic** `Skin/Classic/AddOns/Blizzard_TrainerUI.lua`: older trainer service/header detection and legacy fixed rows; source includes native region hiding and reanchors. Not proof of Forever behavior, unsuitable as a copy-paste replacement.
  https://github.com/Haleth/Aurora/blob/master/Skin/Classic/AddOns/Blizzard_TrainerUI.lua
- **Class Trainer Plus**, `TrainerServices.lua` and `ClassTrainerPlus.lua`: separates *service index* from filtered visual position; reads `GetNumTrainerServices`, `GetTrainerServiceInfo`, `GetTrainerServiceCost`, and selected index. Also implements its own search/train-all transactions and event handlers: **DO NOT adopt its BuyTrainerService loop, search hooks, or OnUpdate strategy** without a separate supported controller and in-client proof.
  https://github.com/fusionpit/ClassTrainerPlus/blob/master/TrainerServices.lua
  https://github.com/fusionpit/ClassTrainerPlus/blob/master/ClassTrainerPlus.lua
- **Skinner** has a Forever version-specific integration directory, but its Forever/UIFrames.lua presently contains no trainer-specific implementation; skin availability does not establish integration/transaction safety.
  https://github.com/jncl/Skinner/tree/master/Forever
- **API reference**: Warcraft Wiki documents native Forever `GetNumTrainerServices`, `GetTrainerServiceInfo`, `GetTrainerServiceCost` and `GetTrainerServiceIcon` as sources. Trainer service indices can change under filter changes; `GetNumTrainerServices` can return stale data if no trainer is open. These are public source semantics, not proof of this user's running client or unsecret result values.
  https://warcraft.wiki.gg/wiki/API_GetNumTrainerServices
  https://warcraft.wiki.gg/wiki/API_GetTrainerServiceInfo
  https://warcraft.wiki.gg/wiki/API_GetTrainerServiceCost

## Exact remaining gap and P0285 hypothesis

The existing M index maps **native presentation elements**, not stable per-row service identity or all source values. Five design-only roles, including search, categories, reagents and Train All, have no verified Blizzard equivalent; scroll rows recycle. A safe bridge should consume validated trainer service data **into a separate plain model**, preserve native service index independent of sorted/filtered position, and keep Blizzard-owned training controls/stock fallback. We cannot infer true native landscape capability just from overlay-highlight successes.

P0285 adds one READ-ONLY, on-demand probe to the existing **H — Native Service Frame Audit** action; it samples at most 12 service indices after a valid Logres interaction state, out-of-combat and an ordinary unprotected visible `ClassTrainerFrame`. It gates every source result against secret-capable data, reports count, selected index, optional costs, icon presence, wallet and API *presence only* for mutation functions. It **never calls** SetTrainerServiceTypeFilter, SelectTrainerService or BuyTrainerService, never hides/reanchors Blizzard regions, never hooks updates, never displays a fake "live" landscape, and never overwrites UI controls. Unknown APIs, excessive counts, unavailable/secret results or no native trainer are reported DEFERRED. No contrived gameplay or purchase required; test during an ordinary trainer encounter.

## Acceptance and deferrals

Static validation: complete PREWRITE/POSTWRITE suite, LF/diff hygiene and manifest. This is **NOT** WoW evidence. Runtime validation: while a native trainer is open, developer panel H → `Native Service Frame Audit`, export `LOGRES_DIAGNOSTICS_LATEST.lua` and inspect exact service-source status/rows. Also run outside trainer context (expected `open-trainer-required`) if convenient; no NPC travel solely for a negative test. Native setter/transaction authorizations, filter write semantics, selected skill events, service-index stability over recycling/filter changes, secure interaction replacement, restoration, live layout and multi-service Train All remain **DEFERRED**.

No dependencies, code, or assets copied from inspected third-party addons; independently authored Logres implementation. Licensing of ElvUI, Aurora and Skinner restricts wholesale code reuse.
