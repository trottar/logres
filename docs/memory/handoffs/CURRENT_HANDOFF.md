# Current Handoff — P0264 synthetic reward-choice interaction

Authority: `docs/memory/CURRENT.md` is the current authoritative state; this handoff is a compact pointer only.

Verified pushed main `373c82b` contains P0263 N3; user's 0.0.161-dev diagnostic export sees preview commands and checks PASS, but choice cards are NON-INTERACTIVE and the user rejected repeating visual-only extraction as progress. Exact source cause: `RewardVisual.New` creates disabled Frame rows; `RewardModel.Preview("multi")` documented choice cards as display-only.

P0264 is one functional patch: turns the *same shared production/preview* card renderer rows into Buttons, but enables mouse **only on synthetic preview choice rows** through a controller-owned callback; exclusive selected visual state, change selection/reset, guarded completion feedback, and `Quest Dialogue Check` diagnostics. Live rows remain passive and the guarded native completion controller stays unchanged. Camera and DynamicCam source frozen; quest237 reserved; native choice/claim and frame flash remain OPEN.

After P0264 applier full WSL suite, deploy and validate P tab Multiple choice clicks in order 2→3→4, Complete Quest (inert), Single reset, Multiple reset, Quest Dialogue Preview reset; F Quest Dialogue Check shows previewchoices audit, H Quest Offer Controls Check confirms preview-only, no native call. Record runtime failures without reclassifying static PASS. Next actual live choice adapter requires separate evidence before taking Blizzard interaction ownership. Exact steps in P0264_README.txt.
