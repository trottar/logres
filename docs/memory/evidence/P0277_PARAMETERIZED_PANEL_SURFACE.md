# P0277 — Shared panel surface / independent Quest and Trainer inputs

Status: PREPARED; static and WoW runtime result UNVERIFIED until user WSL and client tests. Baseline is verified GitHub main `b01cecf6a961bda8e0056bd2d6041584dc4839fd` (P0276 R4). User's October 20 screenshots demonstrate the synthetic trainer panel is displaced compared with the live/synthetic Quest dialogue and can overlap it. The latest attached diagnostics distinguish P Trainer Skin Art Preview shown from H native Trainer Skin ON deferred without an open trainer; the preview does not prove real native skin compatibility.

## Architectural defect / D-046 breach

Quest Dialogue built a single stretched quest panel texture and separate divider, anchored at the questDialogue top-of-screen layout anchor. P0276 NativeTrainerSkin introduced a different nine-slice painter, hard-coded 560x430 centered preview, independently styled preview text. Both used the same art file, but not the same visual component or parameters. D-046 requires shared view construction and presentation parity. The user explicitly clarified that independent geometry/presentation input files are intended: shared *visual vocabulary*, not identical layout.

## Implementation hypothesis and boundaries

- `Media/Theme.lua` owns the shared asset paths and palette, exposed as `Theme.panelSurface`. It does not own Quest/Trainer frame geometry.
- `Quest/QuestPanelConfig.lua` owns the accepted Quest geometry, typography, layout placement and surface mode; `Quest/TrainerPanelConfig.lua` independently owns trainer preview geometry, preview labels, and native art mode.
- `UI/PanelSurface.lua` is the one art painter. It accepts a declarative configuration to render either a stretch background (accepted quest legacy appearance) or a guarded nine-slice background (trainer), and one thematic divider. It does not own gameplay, native controls, model data, or anchors.
- `Quest/Dialogue.lua` and `Quest/NativeTrainerSkin.lua` consume the common renderer; the live trainer and its inert preview also consume the same trainer config and painter. Native trainer geometry, protected controls, transaction ownership and original alpha-token restoration remain unchanged.
- Existing Quest layout anchor policy reads Quest config, preserving the approved top alignment and placement. Trainer preview default is also top-aligned but can be independently adjusted through TrainerPanelConfig, without changing the Quest UI.
- This is not a proven live native trainer skin or landscape reflow. Native lists/filters/purchases remain Blizzard-owned; explicit H ON/OFF safety gates apply.

## Validation / negative evidence

A prior assistant response incorrectly described P0276 as architecturally consistent because it reused texture files. That statement is superseded; shared assets alone did not prevent visual drift. P0274/P0275 visual failures and P0276 R1–R3 failed appliers remain historical facts. This P0277 patch is intended to reject duplicate artist/painter geometry and avoid the same drift. Full in-repository checker suite PREWRITE and POSTWRITE must pass before commit. WoW must confirm: original Quest preview unchanged; Trainer preview top-aligned with matching colors/border language; independent TrainerPanelConfig edits are isolated; skin native ON/OFF still defers safely without trainer, restores correctly with naturally open trainer. Runtime failures/secret/protected errors stop progress. Do not claim any runtime PASS from this record.
