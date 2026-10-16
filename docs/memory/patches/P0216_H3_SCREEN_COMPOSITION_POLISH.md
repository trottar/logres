# P0216 — H.3 coordinated appearance-only corrections

Pushed baseline `8386e918322240ebee76a6c94d5dc2b5f29d5fc6` (P0215); candidate runtime version `0.0.125-dev`. User-observed P0215 screenshot is acceptable except overly large black cluster backgrounds, small player-resource silhouette, and insufficient ready/complete quest distinction. Implementation:

- Remove full-cluster black BACKGROUND texture (one source in shared ActionButton.CreateCluster), retaining individual button dark inner backing, approved sheet-03 assets, 42px buttons, normal/secure presses and all routing.
- Introduce Theme `percentageBar.resource` width 210, height 12, diamond 12, text width 38 (total 268px). Only HUD's player resource bar selects that style. Shared `normal` 142/12 and `compact` 58/8 remain unchanged for enemy/pet/group/quest.
- Existing ActiveQuest ready/complete state toggles strong title/divider, ambient phrase, 2px below-header stroke and one sheet-10 family heraldic seal; normal state has no added decorations. All state detection reuses `snapshot.ready` and `snapshot.complete`, no new Blizzard API or source.
- Update Bootstrap/TOC version, static contract, README and canonical memory/evidence in same patch. No asset file or screen map mutation; fail-open and secret/protected semantics unmodified.

The guarded one-time applier refuses unexpected Git head or modified patch-owned files, preflights CURRENT required headings, shadows all tracked files and the prepared changes, runs full check suite, validates text/hygiene, transactionally writes changes, then executes `git diff --check` and writes P0216 manifest. It **never commits or pushes**. Runtime behavior requires user acceptance and developer panel validation; no static result represents WoW PASS.
