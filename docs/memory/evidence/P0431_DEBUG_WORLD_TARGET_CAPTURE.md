# P0431 R1 — One-click World Target capture and developer panel access

Verified baseline `d949f7db03ccc58bd8886fe4fbace98e659e30c6` (P0429).
User asked for Report Bug to gather the needed diagnostic and for that
button to be the sole player-facing entry to the developer panel.

Ordinary Chat reported Forever `0.0.303-dev` session 88, incidents 9958,
9960 and 9962. Its review saw a visible Blizzard wolf nameplate and the
screen-space Logres target frame. Incident snapshots lacked the World
Target Probe result. Positive safe attachment remains UNVERIFIED.

P0430 docs-only preflight refused at 291/295 before writes. The P0431
JSON draft, SHA-256
`d6b1289d05fa376349f5b37ceb076b9eab63cd94fb705fe3fa6f46d484d2e640`,
passed review and refused at 295/296 in an isolated WSL replay. H.3 still
required the original left-click-only registration and callback signature.
R1 updates those H.3 assertions alongside the already adapted P0409
contract. P0427 remains active and L-011 stays DEFERRED.

Left-click Report Bug for a normal incident and screenshot plus sanitized
scalar results from one World Target Probe. Right-click the button to
toggle the panel. It starts closed. Slash diagnostics and native recovery
controls remain accessible. The probe owns the temporary hidden addon-frame
attachment and its combat guard. No world renderer, enemy frame toggle,
aura relocation, secondary anchors or aggro behavior is enabled.

Forever check: verify the panel starts closed. Right-click Report Bug to
open it, then close it. Outside combat, target a naturally visible hostile
nameplate and left-click Report Bug once. Run `/reload` and export with
`python3 tools/export_panel_diagnostics.py`. The bundled SavedVariables
should contain the incident's `snapshot.worldTarget` with `anchorPresent`,
`attachmentState`, `worldCandidate`, `fallback`, `reactionCategory`,
`secretSkipCount` and `failureCount`. Positive proof needs hostile reaction,
an accessible anchor, passed attachment and a world candidate with no
failures or secret skips. An absent anchor or combat deferral is valid
evidence. Forever client results for R1 are UNVERIFIED.
