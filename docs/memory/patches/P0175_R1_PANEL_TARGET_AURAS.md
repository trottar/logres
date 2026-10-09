# P0175 R1 — Phase H status controls and target helpful fallback

Baseline: locally applied P0175 `0.0.91-dev` over Git HEAD `996f6099`; no separate commit. Status: corrective candidate, **runtime not yet retested**.

## Reported defect / delivery failure

User: "Why are these not in the panel? Thats how we do things" and "Also I see no enemy buff/debug" (interpreted as buff/debuff). P0175 added working slash diagnostic/preview commands but omitted their Phase H panel registrations to avoid the 15-button limit. That violated the project's established in-game validation workflow. P0175 also queried important/dispellable target helpful subfilters without a general `HELPFUL` fallback, so ordinary buffs omitted by those special filters were not represented. A lack of naturally populated target auras or inaccessible/secret aura data can still yield zero visible Logres icons, so this report alone does not prove all such nonrendering is attributable to the missing filter.

## Correction

Register **Status Aura Check**, **Status Aura Preview ON**, and **Status Aura Preview OFF** in Phase H. Preserve all existing actions by moving the three existing pet execution ARM/Check/Hide panel entries intact to Phase C, whose secure-action focus and three free slots match that group. Update the permanent dev-panel contract. Slash commands are unchanged. Keep 15 actions per phase. Add the general target `HELPFUL` source filter after high-priority categories, retain `HARMFUL` fallback and priority ordering, and show `targetEvidence=preview-only|live-populated|deferred-no-populated-target-aura` in status diagnostics. An empty target scan is not live display proof.

Keep Blizzard player/target/private/group auras visible. Avoid protected/secret readbacks, native frame mutations, broad show hooks, and polling; maintain existing D-041/D-042 boundaries. No general aura stock suppression is authorized by this change.

## Validation

The applier verifies the P0175 manifest's exact per-file hashes, Git HEAD and uncommitted baseline; builds the *combined* P0175 + R1 candidate in a shadow clone; runs all `tools/check_*.py` and `git diff --check` before writing; applies transactionally, reruns checks, and creates a separate R1 manifest. In WoW, deploy and `/reload`, open Phase H Status Aura Preview ON, inspect both lanes, use Status Aura Check, then Preview OFF. A populated target with ordinary helpful effects should display those when source data is available; if target state is empty/secret, record DEFERRED. Inspect pet probes under Phase C, then Phase 0 Run All. Preserve original P0175 manifest and failure history.

## R2 continuation

The user confirmed helpful icons but not debuffs. R2 splits target harmful and helpful status capacity and records the unresolved loot-associated quest flash. See `P0175_R2_SPLIT_DEBUFF_LANES.md`.
