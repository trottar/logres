# Current Handoff — P0288 read-only live trainer shared renderer

Authority: `docs/memory/CURRENT.md`, D-046/D-047 and `docs/memory/evidence/P0288_TRAINER_LIVE_READONLY_TRIAL.md`.

P0287 R1 verified pushed `e80d2e8`. Latest saved client diagnostic is from P0286 (Logres 0.0.187-dev), not P0287, so do not invent numeric category mapping or source coverage. P0284's portrait-free synthetic trainer landscape is a scoped user VISUAL PASS; no actual training transaction replacement has been verified. P0285/86 negative source-shape results and P0287 R0 PREWRITE checker failure stay recorded.

P0288 PREPARED / WSL AND WOW UNVERIFIED: `NPCTrainerLiveTrial.FromSnapshot` translates existing P0287 source-probe ordinary values into the same `NPCTrainerLandscape.Build/Render` model/painter used by the accepted synthetic P fixture. Explicit `/logres nativetrainerlive on|off` makes a mouse-inert addon-owned 896x712 read-only rendering; native stock trainer is not hidden/moved/intercepted and handles all selection, filters and training. Unknown numeric categories are labeled unclassified, train buttons disabled and icons generic; missing data returns DEFERRED. Native close/world/combat event hides the addon-owned trial. No polling, purchased spell or H trainer skin requirement.

Next: run guarded WSL applier on exact pushed P0287 R1, require static PREWRITE and POSTWRITE PASS, user commit/push then verify remote; deploy to beta. With stock trainer open use `/logres nativetrainerlive on`, inspect display/click-through, then close trainer. Do not repeat the H general audit merely to sample already known fields. Any runtime errors mean FAIL and must be recorded before advancing to interactions.
