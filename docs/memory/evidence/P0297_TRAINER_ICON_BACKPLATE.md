# P0297 — Trainer icon backplate evidence

Date: 2026-10-22. Verified pushed baseline GitHub `main` P0296 `1a753518b197341b472fae777bf10d8599010f6f` (`0.0.197-dev`). **P0297 PREPARED / WSL AND WOW UNVERIFIED.**

## User runtime report

User: "I was able to purchase spell. There are these weird yellow boxes again though". Screenshot after the trial shows normal stock trainer still open with one fewer available skill, 1g14s58c displayed (versus prior 1g20s58c), Logres details and filtering visible. This supports one **user-reported transaction PASS** for the exercised skill, not general capability, and visible 6-silver change. No full transaction audit/identity proof for other services; no Train All test. The panel's legacy read-only `purchases=0` counter does not report requests from the separate P0296 PurchaseTrial audit. Do not use this legacy zero to disprove the user result.

The screenshot shows **VISUAL FAIL**: Curse of Recklessness and Unending Breath in the Logres available list are dominated by tan/yellow squares, while neighboring spell icons retain full colors. The failing source IDs or whether the effect is transient are not established by screenshot alone. P0295 screenshots showed the same spells rendering normally before P0296, so a global conclusion about unusable icon sources is unwarranted. No P0296 slider drag/track result is reported and that aspect remains UNVERIFIED. Native training and selection remain separately owned; Blizzard UI was not hidden by Logres.

## Source finding and narrow remedy

In `Logres/Quest/TrainerLandscape.lua`, `icon()` paints a full `iconBorder` colored rectangle behind the full image. When an image is partly transparent/not ready, the gold fill is exposed. `Landscape.UpdateLiveRows()` reuses the icon and calls its `SetTexture` with the copied source; no mutation is applied to the raw texture ID. P0297 gives ONLY the `view.localBrowse` icon calls a dark opaque parchment background and narrow gold border, preserving source icon overlay and updates. `icon()` for the synthetic P fixture (and reagents) retains the accepted prior gold backing. This is a **cosmetic containment hypothesis**, not proof that alpha vs file ID caused the underlying faded images. Full icon imagery still needs a client retest; if faded artwork persists, perform a targeted source diagnostic before changing `GetTrainerServiceInfo` semantics.

## Static and WoW gates

Pin main P0296 and all touched blobs; clean tracked state; validate all anchors, prepared text EOFs, prewrite whitespace and complete `tools/check_*.py` suite (including version policy and memory health); postwrite full suite, `git diff --check`, manifest. No commit/push by applier.

WoW: deploy, `/reload`, ordinary trainer → `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST). Compare Curse of Recklessness and Unending Breath icons; toggle All sampled / Available only and scroll, select and confirm details. Examine slider thumb drag and track click if possible; check H OFF/close and stock trainer functionality. **No second purchase is required.** Any Lua, secret or taint error is FAIL. P fixture remains visually unchanged. Exact icon transparency cause and full transaction coverage remain OPEN.
