# P0449 — Restricted world aura source and delegated native renderer

## P0448 negative Forever result (2026-11-11)

User reports **"Looks the same"** after P0448 deployment. Pushed main
`55f7cb7652c60e070dcf76a4d240fde22a60c76f`. Forever build 70888,
client 1.60.1, session 111 / Report Bug #11882, version `0.0.318-dev`.
The selected world health/native-decor handoff continues to function;
world buff/debuff icons remain absent. `worldEnemyLiveAttachments=1`,
`worldEnemyLiveFailures=0`; `worldEnemySourceAttachScans=1`,
`worldEnemySourceLastSecrets=40`, `worldEnemySourceLastHarmful=0`,
`worldEnemySourceLastHelpful=0`; `worldEnemyLiveRenderAttempts=5`,
`worldEnemyLiveHarmfulSlots=0`, `worldEnemyLiveHelpfulSlots=0`.
**P0448 runtime aura FAIL.** The 40 secret-skips are rejected *index
probes*, not a confirmed number of distinct auras. The ordinary source
could not provide icons; changing icon geometry or repeating a scan is
not justified. Capture is evidence, not an automatic P0449 PASS.

## Narrow hypothesis and change

The existing `Logres/HUD/NativeDebuffs.lua` uses Blizzard's `AuraContainer`
template, `AddAuraGroup`, `SetUnit`, `SetEnabled`, `UpdateAllAuras` so
restricted aura data remain exclusively in native code. Replicate this
existing addon-owned pattern as two **children of the precreated Logres
world-enemy frame**: `target` HARMFUL left by 25 px, `target` HELPFUL right
by 25 px, 25x25 icons and 3px within-lane gap. Precreate and enable only
out of combat; no polling or Lua reads of native aura values, textures,
secure children or restricted fields. Parent remains invisible until
selected enemy attachment, and all native input, cast and stock fallback
remain untouched.

If Blizzard_AuraContainer is unavailable or initialization/refusal occurs,
keep the existing Logres ordinary world-lane renderer and stock native
aura fallback. `worldEnemyNativeReady` is only capability/init status;
`worldEnemyNativeVisibilityProof=unobserved` explicitly disclaims icon
visibility. Existing screen-space player and target auras, original
P0447 health/transparent background/native alpha restoration, World
Enemy ON/OFF/Status, secondary aggro gate, P0443 black-matte rejection,
P0446 hostile negative and P0448 source negative are preserved.

## Author gate refusal and correction

R0 full author-check **278/312 REFUSED** before release: a modified
P0183 native container signature broke historical source contracts;
CURRENT_HANDOFF exceeded the 8 KB historical ceiling. No user/GitHub
writes or runtime deployment. R1 leaves the original P0183 player/target
renderer unchanged and adds a separate world helper; the handoff is
compacted without erasing prior failures. Re-run full author-check.

## Validation and disposition

P0449 static author-check, Lua syntax, scoped mock, exact apply/reverse and
SHA-256/receipt are release gates. Forever validation still required:
world target with actual visible buff/DoT, side-lane appearance in the
Report Bug screenshot, native cast/click operation, target switch and
World Enemy OFF restoration, no Lua/taint/protected errors. If native
renderer is initialized but icons absent, leave L-011 PARTIAL and
L-028 OPEN; preserve the negative result and inspect native readiness,
not secret payloads. No invented proof of in-client success.
