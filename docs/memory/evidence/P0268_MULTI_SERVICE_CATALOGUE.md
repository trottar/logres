# P0268 — Multi-service catalogue previews, safe confirmation and header inset

Date: 2026-10-19. Baseline verified pushed `main` `8e1e6f8` (P0267). Scope: four additive **synthetic** service workflows, no live NPC ownership.

## Prior runtime evidence and bounded acceptance

User tested P0267 on WoW Forever at addon 0.0.165-dev; Back, Goodbye, direct Farewell, branching, Services, Overflow, Locked, reward interaction and F/H/0 diagnostics worked as tested. P0267 Quest Dialogue Check reports preview options `clicks=11`, `branches=8`, `backs=4`, `pageMoves=2`, `nativeActions=0`; Goodbye `clicks=8`; Quest Offer Controls Check PASS, `probeCallOK=false`; Run All completed without reported FAIL. No live merchant, trainer or taxi action was tested. User screenshot shows Back and Goodbye at correct height but overlapping decorative corner artwork, requiring symmetric inset adjustment. Do not imply all real service controls are accepted.

## Coherent P0268 capability

- Shared `ServiceCatalogModel.Preview()` composes merchant (8 stock/cost entries), trainer (6 ability/cost/requirements), flight (7 destinations/fares), and empty/unavailable fallback, with deterministic **fictional** prices/names. One catalogue builder generates the same `{title, start, previewOnly, nodes}` envelope consumed by existing `NPCOptionSession` and `NPCOptionList`.
- Available samples navigate item -> quote -> preview confirmation -> no-op result, with Back restoring correct node/list page. Sold-out, reputation, level, prerequisite, and undiscovered-route entries remain visibly locked and unclickable. No native action or false entitlement is claimed. No service list creates its own frame.
- Session `preview-confirm` is strictly preview/model-family-gated and only increments addon-owned diagnostics and shows a synthetic result. It cannot purchase, learn, start travel, spend gold, select gossip, or claim a quest. Existing native controllers and stock fallbacks remain independent.
- `P — Previews` registers four extra buttons. Legacy gallery and historical checker inventory counts updated together (38 P actions, 106 total), with no unrelated panel additions.
- Back and Goodbye both shift from 21px to 45px symmetric corner insets, at the same accepted height, away from panel ornaments. Older static contracts are updated *without removing the mutual-clearance or native-safety assertions*.

## Validation and exclusions

Full static checkers must run in shadow tree and after tracked writes; `git diff --check` required. Local Lua load/session mock, input handling, route/requirement/confirmation invariants and archive integrity are tested before handoff. WoW runtime remains **UNVERIFIED** until user tests explicit P/F/H/0 sequence. Client tests may establish only rendered synthetic interactions; no live NPC service transactions, real quotes, camera behavior, protected-action or stock suppression changes are authorized. Quest 237 remains reserved. Frozen `Logres/Camera/*.lua`, `Quest/CompletionControl.lua`, `Quest/OfferStockSuppression.lua`, and all native action routers are untouched. P0267 corner-art overlap stays OPEN until accepted screenshot. P0265/P0266 packaging and runtime failures remain preserved in historical evidence.
