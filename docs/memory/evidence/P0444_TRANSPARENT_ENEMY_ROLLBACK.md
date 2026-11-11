# P0444 — Restore the transparent world enemy display

## Verified baseline and negative Forever result

P0443 GitHub main `2bc9afc5cee537cc5d77be996da418d55c96a934`,
tree `58a664d9100ab8f65bc82f8cfde72e1acffd8a1a`.
After deployment of `0.0.314-dev`, the user reports a black rectangle behind
the Logres enemy name/HP and continued visibility of Blizzard's native
nameplate. This is a **VISUAL FAIL** for P0443's experimental 208x44 fully
opaque backdrop, not evidence of replacement. The original P0443 record
retains that failed hypothesis; P0444 explicitly abandons it.

## Accepted visual contract and correction

- Current hostile target: existing name, health bar and percentage at
  100% size and opacity; buff/debuff lanes retain 100% opacity and the
  original +/-25px relative offsets.
- Frame background: **fully transparent**, never a black box, mask or matte.
- Secondary 50%/50% live frames require independently confirmed aggro;
  player-targeting evidence alone is insufficient.
- Native nameplate interaction and the usable screen-space target fallback
  remain unchanged. Duplicate Blizzard name/HP remains OPEN and is NOT
  claimed solved by removing the matte.

P0444 deletes the opaque backing, its creation-failure gate, initialization
state and backing-specific panel/status diagnostics. It retains the P0442
CENTER nameplate anchor, target-switch/removal cleanup, P0441 target health
and aura renderer, opt-in ON/OFF/Status controls under Report Bug > H, and
Blizzard clickability. Historical P0443 checker is updated to preserve the
failure as evidence without pinning the failed backing in active code.

## Client validation (P0444 not yet verified)

Outside combat right-click Report Bug > H > World Enemy ON; fight a red
hostile, verify transparent name/HP and existing aura spacing, click the
native enemy, check target switch, then use World Enemy Status and left-click
Report Bug. Turn OFF. The native duplicate may remain; report this separately.
Any taint, Lua or protected-action error is FAIL, not a static PASS.
