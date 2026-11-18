# P0481 — One probable NPC arrival lock; deterministic Chat rollover

Date2026-11-18. Verified main/local P0480
037de4bc712343791ff0435b2d9dd4aa157b3061, tree
10191af30e19f6d3cd0ddb0e917214f7d00c4ea7; tracked checkout clean.
Source/deployed/capture0.0.347-dev match. ZIP/standalone diagnostics SHA256
3189d69d0afcc7a74410189595f1a43338d887714c7922479207a7f82a0d0e64.
Export2026-11-18T00:49:17-05:00, session162, twelve captures in69 seconds.
L-035 remains OPEN. User: "a little better", concept there, still janky;
within3yd according to new approach plus compass should lock, "good chance
were there". This explicitly permits a probable arrival presentation rather
than demanding verified 3D/floor proximity. It does not establish live PASS.

## Individually inspected image/event sequence

All12 screenshots inspected individually, correlations inferred by exporter.
Each has serviceNearCenteredCandidates=0 and native proof counters0 across
softinteract/nameplate/legacy sources. No captured native-proven snap occurs.
Map-only/held counts below are current snapshot counts, not proof of floor.

| Incident / image suffix | Map-only / held | Visible focused text |
| --- | --- | --- |
|16721 /004755|1/1|Brog Hamfist [vendor] -6yd|
|16723 /004803|2/2|Brog Hamfist [vendor], no yards|
|16725 /004810|1/1|Barkeep Dobbins [vendor], no yards|
|16727 /004816|0/0|Toddrick [vendor] -6yd|
|16729 /004819|0/0|Tomas [profession] -11yd rounded; cached focused yards10|
|16731 /004825|1/1|Toddrick [vendor], no yards|
|16733 /004828|1/1|Cylina Darkheart [vendor] -7yd; cached yards6|
|16735 /004834|1/1|Tomas [profession] -6yd; cached yards5|
|16737 /004838|1/1|Toddrick [vendor], no yards|
|16739 /004844|3/3|Cylina Darkheart [vendor], no yards|
|16741 /004847|3/3|Toddrick [vendor], no yards|
|16743 /004904|1/1|Toddrick [vendor], no yards, camera occluded by pillar|

The visible/cached yard differences are consistent with sampling/rounding;
do not claim a separate distance bug from those one-yard differences.
No hard target is required for the requested workflow. The images show the
inn, several nearby providers and changing focus; they do not prove NPC Z.
L-002 native popup remains separate and OPEN; this patch changes no quest UI.

## Cause and coherent policy

P0480 requires live unit proof on every refresh for provider centering. That
proof is absent throughout these captures. P0479's held map bearing improves
direction continuity but never locks identity/focus, so other nearby vendor
or trainer candidates can replace the caption. No existing native API failure
is inferred: tokens may simply not be exposed under current client settings.

Add a pure selector within the existing Compass module; no loaded-module
inventory change. Gather ordinary provider candidates, then select ONE named
NPC spawn within<=3 map yards with native proximity proof OR fresh source
compass alignment within the existing8-degree focus cone. Native-supported
acquisition outranks estimated acquisition. Keep an existing exact spawn/map
lock while distance<4, regardless of facing, token loss or closer competitors.
At>=4, disappearance, disabled/unavailable source or map/spawn change release.
Stable provider sourceX/sourceY fields bind the lock to the actual DB spawn,
not only template NPC ID or a player-relative reconstructed point. Missing/
secret/invalid identity/name/spawn cannot acquire. No NPC positions invented.

An ordinary negative native range result vetoes estimated acquisition and
held arrival for that NPC unless another current token positively proves
the same template in range. Unknown/secret/missing results are not fabricated
negative evidence. Retain existing secret-first GUID/range checks, combat
call gate, observed-token cap40, sampler cadence and client settings.

The arrival renderer places that candidate at center and first within its
existing family; stable focus cannot be stolen by a closer competing marker.
Native quest/waypoint pools, collision bounds, source ranks, map bearing for
other candidates, artwork, opacity and no-tilde/no-floor-caption rules remain.
Ordinary map snapshots stay map-only. A probable lock is NOT native proof:
native counters are not incremented, close map-only labels still omit numeric
yards, and no exact3D/floor claim is made. User explicitly accepts the remaining
chance of a wrong-floor or inaccurate-DB arrival; do not relabel P0476's false
floor experiment solved. Explicit native negative range remains a refusal.

Report Bug automatically captures only owned arrival state: active, source
(native/compass-estimate), acquired/held/released, NPC ID, map distance and
rendered state. No extra panel itinerary or manual target is necessary.

## Source tests, failures and acceptance limits

Actual complete Compass refresh fixture (not a mirrored selector) covers
3.01 no-acquire,3 acquire,3.7 hold with180-degree turn and a closer competitor,
4 release, NPC disappearance, map/spawn changes, side-facing refusal, native
supported rear acquisition, explicit range refusal, secret native result,
missing/secret spawn, missing name and source withdrawal. Original quest snap,
map-only labels, native helper and passive source fixtures remain required.

Initial fixture caught unproven side-facing acquisition: the first draft
used P0479's held bearing as fresh alignment. Corrected acquisition to use
fresh original source-bearing magnitude before any bearing history is applied.
Corrected full-refresh fixture PASS; this was an isolated assistant draft,
not a deployed/client regression. Full exact candidate, all static contracts,
Lua syntax/diff, canonical PREWRITE/POSTWRITE, refusal/rollback/manifest audit
required before release. Client behavior and floor accuracy UNVERIFIED.

## Deterministic next Chat

Preserve this investigation and the twelve supplied captures; do not make the
user repeat the inn approach just because a Chat rolls over. After P0481 is
applied/committed/pushed, verify live main, then run from a clean checkout:
`python3 tools/chat_change.py handoff LOGRES_CHAT_HANDOFF_P0481.zip`.
Use an unused filename if already present. This official exporter binds actual
HEAD/tree/version/checker inventory, includes tracked evidence and refuses
stale/dirty context. It does not start ChatGPT. The fresh source kit can only
be generated after the user's real commit; no fabricated future commit/tree.
Attach that bundle plus the already available evidence ZIP to ordinary Chat.
The opening prompt should continue discussion, preserve estimated/native
distinctions and accepted visuals, and await the user's next fix/change.
P0476 false-floor, P0477 hide FAIL, P0478 styling FAIL and P0479 functional
FAIL stay in memory. P0480 partial/janky is the latest user result, not PASS.

## Minimal client validation

Deploy and /reload, naturally walk within3yd of a named NPC aligned on the
compass: marker and name should hold while turning or moving slightly, then
release outside4yd. Native tokens/targeting/settings changes are not required
for the estimated path. Use Report Bug on a recurrence, /reload, export with
the existing local tool. No forced travel or broad manual diagnostic itinerary.
Static/source PASS does not close L-035 or validate arbitrary floors.

Preflight summary budgets initially9854/8048 bytes; compacted active notes
before release. A shell-quoted note edit interpreted an embedded short-hash
backtick as a command and removed that short reference (no Git mutation).
Corrected via a file-based helper, avoiding shell interpolation. Long guarded
baseline/source hashes remain authoritative; final suite/package audit rerun.

Initial complete candidate341/343 STATIC PASS; P0338 required its literal
original nearest-focus branch and P0478 still pinned the P0480 handoff prefix.
Retained the original nearest branch verbatim outside the lock and migrated
only that historical prefix to P0481 while preserving prior markers. No
source/geometry or no-floor-label safety contract weakened. Final rerun required.

Corrected candidate343/343 STATIC PASS, actual complete-refresh arrival and
four historical source fixtures PASS, version-policy PASS. Final bytes receive
canonical PREWRITE/POSTWRITE, refusal/rollback, Lua5.1 syntax and diff audit;
delivered receipt records those results. WoW runtime remains UNVERIFIED.
