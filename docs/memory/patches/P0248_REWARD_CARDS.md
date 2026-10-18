# P0248 — Dynamic Logres quest reward portrait cards

- Baseline GitHub `main` `0f2d605` (verified); first step after P0247 diagnostic acceptance.
- Visual-only candidate, `0.0.148-dev`: split ordinary reward identity from portrait presentation while preserving the original reward text fallback and guarded single-item name/cache event handling.
- Dynamic `GetQuestItemInfo(type, index)` reward portraits, source-derived quantities, two-column maximum of six, CHOICE labels with stock selection and completion controls retained.
- Secret-safe value checks and optional source-gated `GetItemIcon` fallback; no fixed quest/item data, polling, protected-action mutation, or external Immersion dependency.
- Adds Phase F **Reward Preview: Single** and **Reward Preview: Multiple**, read-only render demonstration.
- Source/static checks are required by the one-time transactional applier before tracked writes; user must validate after deployment. No claim of runtime success or multi-reward live proof from static tests.
- P0247 diagnostic evidence accepted for ordinary source branch (`gate=name-ordinary` load324). Earlier intermittent reward-name failure and unexercised item events stay open.

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
