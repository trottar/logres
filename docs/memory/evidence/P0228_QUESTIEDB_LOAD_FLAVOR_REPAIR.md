# P0228 — QuestieDB addon load ordering and packaged flavor correction

Date: 2026-10-17. Prepared corrective runtime patch, **NOT WoW validated**. Baseline GitHub `main` P0227 `7c6850b3a0fafdde1ff1adc549a4264550a4fa94` verified.

## Why this correction is necessary

User states QuestieDB is visible in WoW AddOns, contradicting the assistant's repeated inference that it was absent based on a check against one assumed Windows filesystem path. That path result is not evidence of the live game's actual addon registration. Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` records P0226 `questiedbprobe` at load count 300, `provider=not-installed`, `gossip=not-observed`, `map=unvalidated-map-or-stale-gossip`. The file's newest overall load count is 302; there is no newer QuestieDB probe in it. In P0226, `provider=not-installed` meant only `_G.LibQuestieDB` was not readable in that test, not that an installation was absent. Source positive match **remains DEFERRED**.

## Independent existing consumer / official provider evidence

- `Questie/Questie/Modules/VersionCheckDB.lua`: Questie checks global `LibQuestieDB.RequireContract(required)` separately from gameplay data; its flavor TOCs use `RequiredDeps: QuestieDB` because Questie actually requires the provider.
- `Team-Squad-io/PlateSmith/PlateSmith_QuestieDB/PlateSmith_QuestieDB.toc`: a functioning optional consumer declares `OptionalDeps: QuestieDB` to order loading without making the database mandatory; it accesses the public provider global.
- Official `Questie/QuestieDB` v1.0.6 `src/ui/modeIndicator.lua` supplies `GetStatus().expansion` **only in Source mode**; for Baked it returns `nil`. P0226 incorrectly required `GetStatus().expansion == 'Forever'` and would reject valid baked releases.
- Official v1.0.6 `generate.lua` emits `## X-Flavor: Forever` and `## X-Mode: baked` in the generated baked Forever TOC. `src/read/baked.lua` selects flavor from `GetAddOnMetadata(ADDON_NAME,'X-Flavor')`. That metadata is the source-correct packaged flavor check.

## P0228 changes / limits

Add `## OptionalDeps: QuestieDB` to Logres TOC, never a required dependency. Make `/logres questiedbprobe` separately expose `QuestieDB` addon registration/load indication, X-Flavor/X-Mode metadata and the public-library contract check before map/gossip checks. Baked flavor is verified from packaged `X-Flavor`; Source flavor from `ModeIndicator.GetStatus().expansion`. Preserve the existing QuestieDB public API, bounded positive/negative location sample, accepted quest filtering, native source preference, stock minimap, and no new production POIs. Change a misleading `provider=not-installed` to `provider=api-unavailable` when the global is unreadable. This is diagnostic language, not proof of why the global is missing. No automatic `LoadAddOn`, timers, scans or installer changes.

## Acceptance / failure classification

The prepared static patch is not runtime PASS. After user applies/deploys and reloads WoW, run `/logres questiedbprobe` once. A `contract-compatible` provider with `mode=baked`, `flavor=Forever`, `tocFlavor=Forever` is provider-compatibility evidence even if `gossip=not-observed`; gameplay source match stays DEFERRED. If `addonLoaded=yes` but `provider=api-unavailable`, preserve as a real provider startup/API issue and investigate actual WoW Lua errors. If `addonLoaded=no` but registered=yes, investigate enable state/load failures, not installation guesses. A quest marker is not accepted until real coordinates and in-game presentation are observed. Do not claim checks run by the user until the user supplies results.

## P0228 R1 pre-write artifact failure and correction

The user applied the original P0228 archive with matching SHA-256 `309582c2b37c054ab96b92fe9f390fe5ba25e3d1f05548042e2173adf9012282`; the applier correctly rejected an extra blank line at EOF in its generated `docs/memory/CURRENT.md` during **pre-write diff hygiene**. `git status --short` showed only three unrelated pre-existing untracked PNG previews, not modified tracked files. This is an assistant artifact-generation error, **not** a game/client/QuestieDB error or runtime PASS. P0228 R1 fixes the last-section generator and makes the candidate EOF rule exact; no changes to the Lua/TOC runtime intent. The user-side full shadow suite and live validation remain outstanding.
