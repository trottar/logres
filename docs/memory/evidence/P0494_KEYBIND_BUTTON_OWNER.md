# P0494 — L-055 keybind metadata follows secure action button (2026-11-19)

## Verified baseline and failure

GitHub main P0493 `d3c65789d6b02058e1b1d7ac97a0d8381d01d137` / tree
`757cf11a8e6ac1bd9e4970d3995055b5c4b86b23` verified read-only.
Forever client session178 `0.0.359-dev`, incident #18442, user reports
intermittent missing keybind tags while action icons are visible, and
repeated generic addon action warning. Screenshot at 00:38:33 shows
icons without labels, with `state.combat=false`, secure refs70, and
policy requested alpha0; a combat transition is journaled about five
seconds **after** the snapshot. Do not state #18442 directly proves a
missing tag *while* state.combat=true. Ordinary actual alpha is not
recorded due lockdown/read restrictions. Generic addon warning caller
is UNKNOWN; separate investigation required. L-055 OPEN/INTERMITTENT.

## Historic conflict and deliberate revision

P0118 R3 reduced icon/root alpha to `.45`/`.20`; child metadata became
unreadable. P0118 R4 intentionally placed keybind metadata on the
UIParent activation-feedback sibling, preserving an alpha-isolated tag;
R5 set bronze border / black fill / ivory text draw levels. That history
is retained, not relabeled a success. New role policy since P0491 is:
all resting OOC0, combat/hover primary+Bar4 1, secondary+pet .85,
utility+Bar5 .75. Therefore the former .45/.20 alpha evidence does not
establish unreadability at .75+. The explicit P0494 compromise trades
some key-tag brightness for shared action/keybind secure visibility.
The user authorized proceeding after reviewing this direction; no claim
of P0118-equivalent in-client legibility until visual validation.

## Ownership scope

Move only border/fill/font regions from feedbackFrame to the existing
SecureActionButton child region owner at button creation. No new frames,
no `SetParent` in combat, no polling/hooks/secure action attributes,
no bindings/routing/paging changes, no native Blizzard control changes.
The activation feedback frame, press art and flash remain independent
UIParent siblings, retaining preconfigured P0493 secure refs70. Keybind
appearance is now inherited through the same secure button/cluster
alpha that reveals icons. P0493 sibling driver only synchronizes
activation feedback (not hotkey tags) and P0492 OOC reconciliation
continues. Pet action keybinds share the identical Button.lua primitive.

## Validation and limitations

Historical P0118 checker must be updated to assert the migrated keybind
owner while retaining its full styling, normalization and draw-order
checks. P0331 separately guards UIParent activation feedback/menu
strata. P0493 secure-driver test must still pass unchanged. New actual
Button.lua fixture asserts parentage, layer order, nonempty/empty
keybind text, compact modifier and activation isolation. Full static
checks, exact candidate ZIP audit and transactional refusal are required.
Static PASS does not establish combat execution, P0118-equivalent plate
readability, hidden stock owner, or addon warning cause.

In WoW Forever after deployment/reload test out of combat no bar, hover
full tags, combat simultaneous button/tag reveal, utility 75% and pet
85% tag readability, successful action and pet execution, zero Lua/
taint/protected errors. Developer panel Phase C **Action Check** and
**Pet Action Probe Check**, Phase D **Context Policy Check**. Left-click
Report Bug during a failure and export diagnostics. L-055 remains OPEN.
