# P0495 — L-054 protect native BUFFS during combat-restricted scans (2026-11-19)

## Verified source and client evidence

GitHub main P0494 `fd0e4677d235d17eef5f12d5ce169de098e4a94c`, tree
`d603863f516219aba2b4cccbab7db3ab4122f10b`, read-only verified.
Forever 0.0.360-dev session179 incident #18521 at 01:10:21 EST,
`state.combat=true`, `PlayerHelpfulAuras.visibleCount=0`, root hidden,
`secretSkipCount=40`, `coverageReady=false`. In screenshot no usable
player buff icons are evident. #18524 at 01:10:32, after restriction
release, `combat=false`, root shown, seven icons, secret0, coverage=true,
`lastRefreshReason=restriction-release`. Screenshot association inferred
by filesystem mtime, not native filename proof. User confirms icons vanish
in combat and recover afterward, while P0494 keybind work is accepted.
L-054 OPEN. Keep historical P0488 prior post-combat FAIL/PASS scopes.

## Narrow root and action

NativeSurfaceReplacement folds stock BuffFrame after a complete ordinary
OOC scan. When a combat-time UNIT_AURA makes all 40 indices secret,
PlayerHelpfulAuras correctly hides its incomplete root. Native Reconcile
then defers while InCombatLockdown; stock BUFFS stays hidden. P0488 fixes
only recovery *after* restrictions lift, as #18524 demonstrates. Do not
render stale cached icons as true buffs or inspect secret aura payloads.

P0495 adds an addon-owned secure state helper to the already loaded
PlayerHelpfulAuras owner, prearmed OUTSIDE lockdown before native fold.
The handler only shows stock BuffFrame in combat and hides it at rest.
Native retains ownership of its opaque captured visibility token and
unregisters the helper before manual BUFFS access, restriction-release
fail-open, immersion OFF or module teardown. If secure setup fails, do
NOT fold native BUFFS; if disarming fails, leave the snapshot tracked.
No native aura inspection, targeting/binding changes, timer, user-created
OnUpdate, native visibility readback, or combat-time insecure Show/Hide.
The secure handler is not a new state-visibility driver on Blizzard's frame.

## Validation and uncertainty

A source fixture must verify restricted combat shows stock BUFFS, normal
combat exit and P0488 restriction recovery, manual stock access, and
unavailable driver fail-open. Negative results remain in the ledger.
Source/static success does NOT demonstrate secure native Show is accepted
by the Forever client. Observe the next natural combat/exit sequence and
watch Lua/taint/protected warnings. If the secure helper errors, record
client failure and restore stock-first behavior in the next correction.
This remains a CLIENT-UNVERIFIED capability gate, not L-054 PASS.

## Assistant candidate audit results

An initial candidate put the helper in a 97th TOC file and exceeded
CURRENT/HANDOFF byte bounds. Historical checkers correctly refused those
candidate changes. The corrected candidate places the secure helper in
the existing player-aura owner, retains 96 loaded sources and changes no
previous production aura-scanning logic. The full corrected checker suite
passed 356/356 in the first complete run; exact-final audit is required
again after this evidence receipt. Native combat visibility has not been
proved in WoW, nor has the generic addon-action warning been attributed.
