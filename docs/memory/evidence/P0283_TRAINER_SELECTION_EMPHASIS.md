# P0283 — Trainer skill-row emphasis: preview visual negative and narrow repair

Date: 2026-10-21. Verified pushed `main` baseline `39acd570635f33c5bbf97b0264cdee66985a597b` (P0282).

## User observation and scope

**P0282 VISUAL NEAR-PASS / ROW EMPHASIS FAIL.** The user-provided WoW screenshot shows a readable 896x712 landscape trainer, consistent warm parchment panels, legible categories, integrated selection details, seven rows, reagent quantity, and Train control. The user says **"Very close, the only issue is every spell is yellowish when only the highlighted or selected should be"**. This is a specific visual negative result, not a full visual acceptance. Previous P0280 disjoint-preview VISUAL FAIL, P0281 parchment VISUAL FAIL, and P0281 R0/R1 PREWRITE errors remain preserved in their own evidence.

## Narrow source-backed cause

The P0282 preview's `TrainerLandscape.Render` passes all seven skill rows through `NPCTrainerMotif.PaintFixtureRow(row)`, whose default `recipe.rowWash` and `recipe.rowRule` are the gold/tan native motif applied to **all** rows. It also assigns `datum.disabled and p.muted or p.goldText`, making every enabled skill name gold. The source establishes both indiscriminate effects; the user screenshot confirms the visual consequence.

## P0283 proposed behavior

Retain the accepted landscape geometry, parchment material, category labels, selection detail, reagents, fixture values, and component painter. Within `TrainerPanelConfig.motif.previewStates`, define three strictly preview-only wash/rule pairs: normal (low-alpha neutral warm parchment), selected (distinct gold wash and brighter rule), disabled (subdued neutral). Pass that plain row state from `Landscape.Render` into the existing `Motif.PaintFixtureRow` API; the one `paintRow` painter accepts optional fixture colors, while native `Motif.Enable` continues calling `paintRow(row, recipe)` without any override. Regular skill titles use `p.body` (ivory), selected titles `p.goldText`, disabled titles `p.muted`. Only the selected row receives the extra selected overlay. The preview remains mouse-inert and deterministic. No native reflow/transaction capability is implied; no Blizzard controls, values, camera, Quest UI or stock fallback are changed.

## Gates and negative-result preservation

**P0283 PREPARED / full WSL checker and in-game visual acceptance UNVERIFIED.** Applier must accept only verified P0282 `main` with clean tracked state and matching blob hashes; create exact candidate shadow; run all `tools/check_*.py` before tracked writes and after; apply transactional rollback if postwrite rejects; produce manifest and git whitespace proof. Changed historical P0281/P0282 assertions must validate actual state-aware source, not obsolete call literals. Then after user commits/pushes/deploys, the **P — Previews → Trainer Skin Art Preview** screenshot should show one gold selected row, ordinary names ivory/neutral, and disabled row muted; toggling P OFF remains safe. H native trainer styling/row reuse, dynamic scroll rows, and live adaptation remain separately UNVERIFIED/DEFERRED. No forced NPC visit.
