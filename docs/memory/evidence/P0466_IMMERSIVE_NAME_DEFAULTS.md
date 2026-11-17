# P0466 — Saved world display defaults and immersive overhead names

Baseline main/local c0ed39acb94fab686b756b76b27a9c2de5a69d83, P0465.
Runtime0.0.335-dev; user owns Git commits/push. No source writes to actual
checkout; isolated author candidate and canonical transactional package.

## Accepted runtime and request

P0465 latest export 2026-11-16T20:48:35-05:00, session138 #14065,
0.0.334-dev. Standalone/bundle diagnostics SHA256
773d4730bd690af72f41aed9dd6d9495e6ff047b12f7616186240191ee0228c3.
Source/deploy/capture match. WoWScrnShot_111626_204737.jpg individually
inspected: selected Forest Spider and two secondary Mangy Wolves with Logres
HP/aura presentation. User says "works well". Visual PASS scoped; full taint/
off/restoration coverage not established. L-028 retains history and OPEN
full-safety variants. Screenshot attachment d8ea1c5d-ea06-4e36-b522-59540b3685da
shows ambient Stormwind Guard and service-name labels. User explicitly wants
world display default ON, screen enemy default OFF, unselected names hidden,
selected unit names and accepted combat world plates retained. L-049/L-050.

## Source findings and implementation

screenSpaceEnemyFrameEnabled already defaults false, but HUD.UpdateTarget
always shows name/HP without reading it. New gate respects explicit screen
opt-in while retaining cast/aura parent. Secure screen click overlay likewise
uses that preference, updates OOC, and defers changes in combat. Native target
interaction remains native on world plates; stock restoration contract stays.
World Enemy has no persistent preference; add worldEnemyEnabled=true through
existing schema3 defaults and preference publication. Explicit false survives
reload. HUD enables once per desired preference transition and immersion
activation; unrelated preferences do not churn owners. Existing world ON/OFF
controls persist this choice, no extra settings UI or panel work required.

Separate OverheadNamePolicy namespace in existing ImmersionController owns
only supported ordinary 0/1 client configuration. No new loaded module or
change to 96-source inventory. Snapshot all supported values before writes;
require core NPC/player name settings. Whitelist ambient player/NPC/pet/
minion/guild/title settings to0, focused names to1 when supported, enemy plates
to1, always-show plates/friendly ambient plates to0. Optional absent CVars are
skipped; required absent/secret settings refuse before mutation. No unknown
CVar creation. Each setter verifies ordinary config readback. On failure
restore; preserve original baseline in addon meta across /reload. External
ordinary settings changes are respected on release. Unsupported settings and
native selected/mouseover behavior remain explicit client limitations.

Changes are OOC only. Pending intent uses one existing-owner regen event,
latest intent wins, no polling/CVAR_UPDATE loop or periodic reassertion.
Stable active state does no writes. Restore on Immersion OFF or controller
disable; restore refusal keeps original snapshot and safe-event retry. No
world frame mutation, native presentation getters or unit identity reads.
Only owned policy flags/counts/reason are captured by Report Bug; original
saved settings are not included in incident snapshots. Existing HP, scale,
opacity, eligible secondary policy and P0465 aura drawing are unchanged.

## Selection and source boundary

Native settings definitions (primary source, read 2026-11-16) expose separate
NPC/player/minion/nameplate controls:
https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_SettingsDefinitions_Frame/Nameplates.lua
Native settings handle label visibility; no fake world-to-screen anchor or
Lua inspection of restricted target names. UnitNameFocused is optional and
capability-gated, with runtime exact target/focus/mouseover semantics UNVERIFIED.
No claim that ordinary CVar source checks establish the exact engine policy.
Actual NPC/player selection/name display and native fallback must be checked
in Forever. New D-049 narrowly supersedes D-042 CVar opt-in proof restrictions
for this explicit user-approved production policy; historical decision retained.

## Validation and limitations

Actual-source fixture covers fresh/existing explicit preferences, preference
publication, default world activation/idempotence, screen flag/cast parent,
secure screen opt-in/combat deferral, native config transaction and readback,
optional missing/required missing/secret rejection, silent setter refusal,
rollback, pending restoration, reload snapshot and OFF cancellation.
Run previous nine actual-source fixtures, entire329 checker candidate,
Lua5.1 syntax, source/HEAD/hash/dirty/collision refusal, manifest/payload
parity, injected POSTWRITE exact rollback and actual user Git preservation.
No static PASS is client PASS. Existing failed experiments remain preserved.
P0466 new defaults/names/secure preference transitions client UNVERIFIED.

Initial author candidate refused298/329: compact handoff exceeded8000 bytes,
P0360 expected unconditional screen unit-watch ownership and P0446 expected
unconditional screen fallback. Shortened handoff without changing its budget;
preserved P0360 true/false diagnostics under explicit screen-opt-in branches.
Only P0446 name/HP assertions evolve to require the stronger preference gate,
backed by actual source tests. Native input/combat/secret checks unchanged.
New source fixture fails on unmodified P0465, confirming behavioral coverage.

Release validation: 329/329 complete exact-candidate STATIC PASS and ten
actual-source fixtures PASS, including new default/name/secure-input tests.
New fixture fails on unmodified P0465. Canonical final ZIP audit repeats
PREWRITE/POSTWRITE329/329, payload/manifest/cleanup/diff hygiene, Lua5.1
syntax, HEAD/source/hash/dirty/collision refusal and injected POSTWRITE
byte-for-byte rollback, preserving actual user HEAD/refs/index/tracked bytes.
Client defaults, selection/mouseover and CVar restoration remain UNVERIFIED.

Final safety review: when an explicit screen ON is turned OFF during combat,
its secure input may remain until regen. Keep the name/HP visible while that
owned deferred input exists; refresh immediately after safe completion. New
actual-source test prevents an invisible pending screen click area. Default
OFF never enables it. This correction requires final full audit repetition.
