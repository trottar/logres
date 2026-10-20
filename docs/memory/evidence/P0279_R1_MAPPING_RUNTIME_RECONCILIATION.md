# P0279 R1 — M mapping runtime reconciliation and overlay owner repair

Date: 2026-10-20. Baseline pushed `main` `7660395bd2f560929c39d840d8adb05843da1b6a` (P0279).

## Observed evidence, classification

User feedback: "Highlights mostly worked as expected"; a few produced no highlight and user could not identify which. The exported `LOGRES_DIAGNOSTICS_LATEST.lua` from `0.0.177-dev` records 9 successful trainer highlights after the native window opened: frame, filter, list, scrollbar, selection, status, money, Train, close. Four earlier attempts to highlight the frame/list/filter/Train before the trainer was available returned `native-root-unavailable` (environmental DEFERRED, not defects). With trainer open, nine entries were DEFERRED: title (`ClassTrainerNameText` unavailable), portrait (`overlay-anchor-deferred`), subtitle/search/category/reagents/Train All (explicit UNMAPPED), recycled ScrollBox row (`dynamic-row-identity-unverified`) and detail icon (`ClassTrainerSkillIcon` unavailable). This explains the reported partial response without requiring repeat of known successful tests. `Hide Highlight` was not recorded; overlay close and restoration remain client UNVERIFIED.

## Narrow cause and correction

`Dev/MappingInspector.lua` accepted a visible ordinary unprotected native portrait Texture, but attempted `Frame:SetParent(Texture)`. Texture/FontString objects are not valid Frame parents; the protected `pcall` failed and returned `overlay-anchor-deferred`. R1 uses the same ordinary/secret-safe, combat-gated eligibility policy to obtain the non-frame Region's eligible native Frame parent, then parents **addon-owned overlay** to that Frame and anchors its bounds to the original Region. Native owner is never changed. Frame/Button/StatusBar candidates continue as before; failed owner resolution remains DEFERRED and fails open.

The older `ClassTrainerNameText` and `ClassTrainerSkillIcon` paths were absent on the tested Forever trainer. Blizzard TrainerUI source search identifies `ClassTrainerFrameTitleText`; ElvUI Forever identifies `ClassTrainerFrameSkillStepButton.icon` on its skill-step button. R1 updates these two source-backed **candidate paths**, without claiming client availability or guaranteed semantic identity. recycled rows remain unresolved and intentionally DEFERRED; no polling, guessed global searches, hooks or native layout/transactions introduced.

## Evidence and result policy

M tab now reports HIGHLIGHTED, UNMAPPED, or DEFERRED with reason (and stable mapping ID) in diagnostic runs. A HIGHLIGHTED result means only that addon-owned artwork was anchored, not that bounds, appearance, or native skinning was accepted. Source candidates still need live visual verification. Existing ElvUI/Aurora code and assets are not copied.

## Validation state

P0279 R1 archive prepared. Full WSL suite and WoW behavior **UNVERIFIED**. Recheck only previously unresolved portrait, title, detail icon, plus Hide Highlight (after trainer closed) when a trainer is naturally accessible; do not require contrived travel or repeat successful frame/list/filter/Train tests. Preserve the unresolved row and design-only entries; no Blizzard controls are hidden or modified.
