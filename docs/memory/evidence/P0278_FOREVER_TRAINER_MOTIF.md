# P0278 — WoW Forever trainer: source-guided native row/surface motif

Date: 2026-10-20. Baseline pushed `main` `f042f311ba01e9b498c9abb2e0295d60e3e3a3b6` (P0277). **PREPARED; client runtime UNVERIFIED.**

## Observed input / negative result

User screenshot: at a trainer (Enchanting, Thonys Pillarstone), P0277 ON looks like a mostly black Blizzard trainer, with original header, portrait, black skill list, native skill rows and train controls. This is **VISUAL FAIL / NOT ACCEPTED** for Logres art identity, even though the user reports other behaviors working. Previous uploaded diagnostics show older H ON without an open trainer was DEFERRED; those older lines do not independently verify the screenshot session's H activation/restoration. No taint/Lua errors were reported by the user; absence of a log is not a PASS. The synthetic P preview does not establish real native presentation acceptance.

## Primary upstream implementation evidence (source read, not copied)

- ElvUI `ElvUI/Game/Shared/Skins/Trainer.lua` on `tukui-org/ElvUI` main, inspected 2026-10-20: its Forever branch consumes `ClassTrainerFrame.ScrollBox`, `ScrollBox:ForEachFrame` to distinguish category headers from rows (`row.icon`), applies independent row/icon/backdrop treatment, and hooks the ScrollBox Update path; also treats `ClassTrainerFrameBottomInset`, `.FilterDropdown`, Train, status and money separately. Its Classic branch uses entirely different indexed `ClassTrainerSkillN` controls. Repository source: https://github.com/tukui-org/ElvUI/blob/main/ElvUI/Game/Shared/Skins/Trainer.lua
- Aurora Classic `Skin/Classic/AddOns/Blizzard_TrainerUI.lua` uses fixed `ClassTrainerSkillN` rows, hides selected inherited textures and alters native control layout. Those Classic row indices and global controls must not be assumed on Forever. Source: https://github.com/Haleth/Aurora/blob/master/Skin/Classic/AddOns/Blizzard_TrainerUI.lua
- Source and visual techniques studied only; code, textures, namespaced helper implementations and assets are **not copied**. Licenses are not used as permission to import source.

## Narrow hypothesis / independently authored trial

The P0276/P0277 black-background-only appearance results from leaving the Forever ScrollBox/list entry surface unstyled. P0278 creates a distinct `Quest/TrainerMotif.lua` adapter with small, parameterized, mouse-inert Logres parchment wash and gold divider accents. The same original `paintRow` helper is used on actual visible ScrollBox rows and inert P Preview sample rows. Palette is supplied by the common `Theme.panelSurface.motifs`; per-service dimensions/opacity/sublevels by `TrainerPanelConfig.motif`.

The adapter explicitly requires the real unprotected trainer, ordinary unprotected `frame.ScrollBox`, callable `ScrollBox:ForEachFrame`, and at least one ordinary unprotected row that permits addon-owned paint. If unsupported, it cleans up every addon-owned texture, fails open, and the enclosing H skin trial restores the prior stock alpha state. **All native trainer inputs remain Blizzard-owned; no Blizzard child texture, row, button, money, filter, scroll control, position, parent or transaction is mutated by TrainerMotif.** Existing root texture alpha snapshots/restoration from P0276 remain unchanged. No polling, ScrollBox update hook, gameplay action, camera modification or landscape reflow.

P preview now includes inert exemplar rows using exactly the same row painter. That previews row ornament appearance but not Blizzard's live row content or its layering. If row surfaces are obscured, partial, clipped, missing on recycling, or blot out stock text/icons, record FAIL/DEFERRED and do not advance; the implementation is a visual trial, not an accepted full reskin. ScrollBox row recycling after new pool creation remains OPEN because there is no update hook in this checkpoint.

## Acceptance gate

1. Apply full shadow/prewrite and postwrite `tools/check_*.py` suite, manifest, whitespace; no Git writes by the assistant. If blocked, preserve failure evidence.
2. Deploy, `/reload`; P → **Trainer Skin Art Preview** confirms row motif preview and native gameplay remains absent. P → **Quest Dialogue Preview** must retain approved art without alteration.
3. With a naturally opened trainer, H → **Trainer Skin ON (TEST)**, close panel, screenshot. A PASS command must indicate `native-scroll-motif-active` rather than merely `native-root-skin-active` or DEFERRED. Compare list wash/rows and read all text, icons, costs, selection, status and native Train buttons. Do not buy training solely to test.
4. H → **Trainer Skin OFF**; confirm stock decorations and background fully restore, no leftover gold regions. Reopen native trainer after closing while ON and verify same. H → **Native Service Frame Audit** if needed and 0 → **Run All**. Save diagnostics via `/reload` or logout. Any Lua/taint/secret/protected error is FAIL.
5. Inspect rows after scrolling: absent motifs on newly recycled rows is OPEN / INTERMITTENT and is not an excuse to add polling absent client proof.

## Explicit scope

Source finding = upstream code paths only, not Forever client proof. Visual failure = user screenshot. Expected effect = hypothesis to test. WoW runtime and visual acceptance = **UNVERIFIED**. Decisions D-046/D-047 intact. Camera unchanged. No stock UI surface removed unless safely reversible. P0274/P0275 VISUAL FAIL and P0276 R1–R3 assistant static/patch failures retained in history.
