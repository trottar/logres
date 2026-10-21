# P0288 — Read-only native trainer snapshot in accepted landscape

Date: 2026-10-21. **PREPARED / STATIC CANDIDATE, WSL AND WOW UNVERIFIED.**
Baseline: verified pushed Logres `main` P0287 R1 `e80d2e83170a6913a02db5c2c8fb31844fff77fa`.

## Authoritative evidence and prior negative results

- **P0284 user screenshot and acceptance: VISUAL PASS** within the portrait-free, synthetic landscape; aesthetic polish deferred. This does not prove a live data adapter or a working native transaction replacement.
- **P0285/86 WoW 1.60.1 read-only trainer sample:** with a real native trainer open, service count 1, selected index 1, wallet 12,058 copper, and a spell name `Enchant Chest - Minor Absorption`; the return tuple types were `string/string/number/number`. The Classic string-only status gate rejected the numeric category. This was a source-model interpretation FAIL, **not** a native trainer failure.
- **P0287 R1 pushed but no new in-game category-value evidence:** the user's most recently supplied saved diagnostic still ends with Logres 0.0.187-dev (P0286). No numeric enum values or semantics have been proven. P0287 R0 **PREWRITE FAIL** due to its checker freezing a runtime version; it produced no tracked writes. R1 repaired that feature checker; P0287 in-client status remains **UNVERIFIED**.
- **Independent addon investigation already documented:** ElvUI Forever has ScrollBox/native control references; Class Trainer Plus separates native service indices from filtered visual positions. Methods were studied but no external code was copied. Mapping highlighted many native controls but not recycled row identity.

## P0288 coherent live-data trial

P0288 attaches an explicit `NPCTrainerLiveTrial.FromSnapshot()` model adapter to the existing `NPCNativeTrainerServiceProbe.Read()` and passes the resulting model into **the same `NPCTrainerLandscape.Build` and `Render`** used by the accepted fixture. The skin/PanelSurface recipe and 896×712 geometry remain unchanged. This is a deliberately **mouse-inert, addon-owned** read-only live display alongside the intact Blizzard trainer. It samples at most 12 source rows; the first 7 display. It uses real source names/indices, accepted observed cost when available, selected index, and wallet denominations. Native icon identities, professions, reagents, trainer heading, categories and availability semantics are **not yet proven**, so icons are generic, labels say unclassified, and both Train and Train All remain disabled in Logres. Synthetic fixture still works independently and is never promoted into live content.

Any rejected/secret/unavailable source row, invalid selected service input, missing native trainer or combat/hidden/protected root causes a **DEFERRED** result. There is no event polling, Lua trainer API setter, native layout mutation, stock hiding, selection, filtering, purchase or controller. A small addon-owned watcher hides the trial on interaction exit, world entry, or combat start. On failure Blizzard remains fully functional. One `/logres nativetrainerlive on` action after opening a trainer is the single runtime visual test; `/logres nativetrainerlive off` hides it. **No additional general frame audit is required.**

## Verification boundaries

- **Static candidate:** version parity; source/renderer/command load order, no native mutations; full checker suite PREWRITE/POSTWRITE in WSL; whitespace hygiene; manifest.
- **WoW test pending:** deploy, `/reload`, open ordinary trainer, `/logres nativetrainerlive on`, inspect that at least the true name is displayed and the trial does not intercept Blizzard controls; close trainer and confirm it disappears. If the source API gates defer, report exact reason; do not make an in-game purchase for proof.
- **Future DEFERRED:** numeric-category semantic mapping, real icon paths, multiple-service coverage, row click/filtered index mapping, Blizzard control replacement, trainer close recovery beyond trial scope, transaction-safe Train All. A one-service sample is not a complete source adapter PASS.

Decision basis: D-046 shared renderer / explicit adapter separation; D-047 selective native integration, Blizzard-owned transactions and stock fallback.
