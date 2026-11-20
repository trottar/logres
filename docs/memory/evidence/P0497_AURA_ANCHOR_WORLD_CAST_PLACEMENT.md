# P0497 — Restore player-buff placement and move world cast cue above (2026-11-19)

## Authoritative baseline and incident

GitHub main verified P0496 `df6bae8e8d60a25ed75f2b810731c88ac042df65`,
tree `c36b823c8c9d7bc6816a5e6278ae0a02c5f38383`. Forever
source/deployed/capture `0.0.362-dev`, session181, #18691 (18:01:56
Eastern, combat) and #18694 (18:02:17, after combat). In #18691,
`playerHelpful.nativeHelpfulActive=true`, native result active,
`secretSkipCount=40`, old Lua root hidden and zero icons; #18694 native
active, coverage true, seven ordinarily read auras, old root hidden.
`worldEnemyCastCueOwner=world`, `worldEnemyNativeCastDimmed=true`
were recorded in both incidents. Screenshot association is from the
report exporter filesystem-mtime inference, not a client event binding.
User: P0496 functionality works, but player buffs shifted from their
approved location and selected-world cast cue overlaps the NPC. This
is a **P0496 visual/layout FAIL**, not failure of the native secret-aura
combat source; preserve the original P0495 combat failure separately.
L-054/L-057 remain OPEN until corrected visuals are validated in-client.

## Narrow source diagnosis and correction

The old `PlayerHelpfulAuras` root is bound to `passiveStatus` with its
`LEFT` midpoint at the first icon's center; it grows upward. P0496's
new native container has a 40-aura, ten-row maximum footprint and grows
`BOTTOMLEFT` to the right and up, but was independently bound at its
**LEFT center** to that same passiveStatus anchor. Consequently its
first icon is vertically displaced downward by about half the unused
maximum container height, into the action controls. The real screenshot
supports the displacement; the exact pixel delta is not measured.

P0497 gives `NativeDebuffs.CreatePlayerHelpfulMirror()` the existing
ordinary old-root anchor token, and attaches the native `BOTTOMLEFT`
to the original root's `LEFT` with a half-icon negative offset.
Only the legacy root retains `Logres.Layout.Bind(... passiveStatus)`;
when layout reprojects, both move together. The native container stays
parented to UIParent, independently shown/updated through Blizzard's
AuraContainer engine while the legacy root is hidden. No native aura
source, restriction event, stock BUFFS fold, tooltip, edit, settings,
or combat protected mutation changes. Missing anchor fails open to the
stock owner instead of installing an unpositioned replacement.

World-enemy `HUD.lua` built the shared addon-owned enemy fixture cue at
`TOP` of the frame's `BOTTOM` with -6 offset; that position lies under
the health/name frame and overlaps the NPC. P0497 instead puts the
symbolic 24px cue `BOTTOM` at world fixture `TOP` plus 10px gap. The
screen-space target cue's existing anchor stays unchanged; target
cast lifecycle, native-strip dim eligibility and opaque restoration,
nameplate input, auras, health and secondary remain unchanged.

## Validation and limits

The updated P0496 actual-source Lua fixture asserts native first-row
`BOTTOMLEFT` anchoring follows the legacy root; P0497 checker also
asserts no second layout owner, unchanged native flow and screen cue,
world cue above frame, and no new OnUpdate. Run all historical Python
static checkers, changed Lua syntax, `git diff --check`, native fixture,
ZIP payload/rollback/refusal and SHA before handoff. Static tests do not
measure actual native AuraContainer pixel output in Forever; user must
confirm the buff first row returns to the original location, never
collides with action bars during combat/OOC, and that casting enemies
show the cue above the nameplate without overlap. Test target change,
no protected/taint errors, manual BUFFS fallback; record unexpected
behavior as OPEN rather than declaring success.
