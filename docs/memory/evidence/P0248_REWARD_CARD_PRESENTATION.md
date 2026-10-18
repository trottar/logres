# P0248 — Dynamic quest reward portrait presentation

Date: 2026-10-18. Baseline: verified pushed P0247 `0f2d605` (`0.0.147-dev`).

## Authoritative runtime observation (P0247 acceptance within scope)

User-supplied loadCount 324 Quest Dialogue Check during ordinary quest 237 completion and screenshot show Logres **Lesser Healing Potion x3**, **1050 XP**, and **7s**, visually matching native Blizzard rewards. Diagnostics: `QUEST_COMPLETE=1`, shown=1, `source=guaranteed-item-ordinary`, `itemIdentified=true`, `moneyCopper=700`, `gate=name-ordinary`, `requests=0`, `signals=0`, `resolved=0`; stock Complete Quest usable. This is a successful *ordinary-name-source* presentation. A zero request count was appropriate because source name was already ordinary. Earlier P0245/46 missing-name result remains OPEN / INTERMITTENT, and event-cache recovery is not runtime-proven. The user's request is visual refinement, not a new item identity fix.

## Reference and design

Review of `seblindfors/Immersion`, `Components/Elements.lua`, found the same `GetQuestItemInfo(type,index)` source used for item name, texture, count, and static item-button portrait. This establishes a source/design comparison, not a dependency. P0248 uses the existing Logres quest lifecycle module and directly obtained ordinary quest texture (fallback to secret-guarded `GetItemIcon` where available) with no fixed quest ID or specific item. It adds a dark, muted-gold 34-pixel portrait card row, text name and separate stack count, consistent with the established Logres narrative panel; two columns and at most six cards. The section expands only for completion rewards; other dialogue/paging stays unchanged.

Both guaranteed `reward` and selectable `choice` item arrays are considered within the source-provided ordinary counts. `CHOICE` cards are **read-only**: no selection/claim API, no protected Blizzard UI manipulation, no hover/click stealing. Up to six source rows in total are read; if more are declared, the footer directs the user to Blizzard controls. Secret/missing/unusable names/counts are omitted from visual cards and fall back to the established stock window; secret icons are discarded without inspecting them. Selection UI, multiple-currency/other-kind payouts, optional bonus items, item tooltip/quality, and dynamic layout beyond six items remain OPEN for separate proof. Current multi reward runtime is ENVIRONMENTALLY DEFERRED, not PASS.

The existing name / request / item-data signal logic remains intact. The item-data-event branch may populate a portrait for an active, matching single-item completion if an ordinary name later resolves. No timed retries, polling, quest mutation, quest claiming, or new stock suppression.

## Visual validation

P0248 prepared candidate (`0.0.148-dev`) only; runtime UNVERIFIED. Developer panel F has **Reward Preview: Single** and **Reward Preview: Multiple** (read-only demonstration with authored fake sample names and built-in icon paths, not actual quest data). Preview must show icons, counts, choice tags, footer, proper anchoring, no overlaps. The ordinary quest-completion path should show source-reported items/XP/money when naturally available; click Blizzard controls for completion. Phase F Quest Dialogue Check has `rewardvisual: CANDIDATE (cards=... overflow=...)`; Phase 0 Run All and WoW Lua/taint observations required. If a natural multi-reward quest isn't available, record it as DEFERRED and use visual preview only. On broken icons, clipping, source secrets, errors, or lost stock interaction: FAIL and repair.

## P0248 R0 preflight failure — corrected in R1

The user applied the original P0248 ZIP against verified GitHub `main`
`0f2d605` with clean tracked source. The applier **REFUSED before any
tracked writes**: Dialogue.lua contained two occurrences of
`self.completionActive = false` followed by `self.pendingCompletionItem = nil`
(in HidePresentation and OnInitialize), while transformation 18 required
a globally unique anchor. `git status --short` showed only three pre-existing
untracked preview PNG files, with no tracked changes or manifest. This is
an artifact authoring failure, not an observed WoW runtime defect.

R1 scopes the same insertion to the uniquely identified OnInitialize block
using the immediately preceding `self.completionSkippedCount = 0` anchor.
The user must discard the original applier/ZIP and extract R1 over its
temporary inputs. All source/static checks and runtime acceptance remain
UNVERIFIED until the corrected applier and in-client validation pass.

## P0248 R1 shadow-check failure — corrected in R2

The user ran R1 against verified `main` `0f2d605` with the three previously
untracked preview PNGs only. Exact Git baseline and all **27 source transforms**
passed, reporting 15 prepared source/memory files. Before any tracked write,
`check_ui_ownership_audit_contract.py` rejected the shadow candidate because
`handleCommand` would capture **61 locals** (Forever limit **60**). The baseline
already captured 60; the new `local function runQuestRewardPreview(argument)`
introduced the 61st referenced local. This is a packaging/static-contract
FAIL, not a WoW runtime failure; no tracked files were changed and no manifest
was produced. R2 uses `function Logres:RunQuestRewardPreview(argument)`
instead, matching the existing UI ownership audit's namespace-method precedent.
The slash dispatch uses the method, and the existing full-suite guard remains
unchanged. Pre-write full shadow validation and runtime visual acceptance remain
mandatory; do not infer PASS from this source correction alone.

## P0248 R2 runtime failure — observed in load 326; repaired by P0249

Verified pushed main `cfd67be`, addon `0.0.148-dev`. Both synthetic previews (`questrewardpreview single`, `questrewardpreview multi`) threw `Dialogue.lua:1258: attempt to call a nil value`. Reward visual diagnostic recorded zero cards; `Quest Dialogue Check: PASS` does not certify the previews. Source diagnosis: `Visual.New()` returned a plain table without `Visual` method inheritance; `PresentText` called its nil `Reset` method. P0249 repairs that constructor, but its own runtime acceptance is pending. Preserve this FAIL alongside the earlier R0/R1 prewrite failures. See `docs/memory/evidence/P0249_REWARD_VISUAL_INSTANCE_FAILURE.md`.
