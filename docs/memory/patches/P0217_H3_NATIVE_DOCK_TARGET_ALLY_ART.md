# P0217 — H.3 native access and sparse unit visual translation

Baseline: GitHub `main` `905c84700590272ab4e0ff6c9a90125730a308fa` (P0216); new runtime version `0.0.126-dev`. User visually accepted P0216, instructed implementation of the many remaining approved component treatments rather than more final refinement.

- Add two RGBA dock TGA textures derived from the approved D-040/P0214 sheet-03 action-frame texture, via nine-slice stretch/corner extraction; original production action and approved references not modified.
- Register them under `Theme.nativeAccessDock.assets` plus color tokens. Six `NativeAccess` dock labels gain small bronze skin over their existing fail-open procedural fill.
- Retain `NativeSurfaceReplacement` stock domain, callback, frame sizes and text updates, but replace the three default red `UIPanelButtonTemplate` visuals with addon-owned bronze button/text overlays and restrained hover/press layers.
- Add Theme-owned target/pet/ally hairline/name tokens and create fixed-position decorative rules in `HUD.OnInitialize` without any new source reads or bar/anchor changes. Secure pet unit interaction remains unchanged.
- Update Bootstrap/TOC, static checker, media index, memory and patch index in the same transaction.

Guarded applier pins expected baseline blobs and refuses mismatched HEAD, shadow-runs complete check suite before writing, checks whitespace, writes manifest and never commits/pushes. WoW execution and visual acceptance remain unverified until user checks.
