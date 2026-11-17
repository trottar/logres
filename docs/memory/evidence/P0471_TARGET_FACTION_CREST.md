# P0471 — Frame-stack-identified target faction crest

2026-11-17. Verified P0470 main68a9ad3ff2aefb6b956067c3a662d454903ee89a,
tree461d084becbf84651131691ff54e60be298332e0. L-049 remains OPEN.
Latest source/deployed/capture0.0.338-dev, session148 #15393, screenshot
WoWScrnShot_111726_002724.jpg: no Logres target PvP label or target aura lanes,
but small Alliance crest persists above right action bars. ZIP/standalone
diagnostics SHA256377d1e2a90bfe639ebbdde1198375ca6c8d416b593dc78d141a7ce47718318b8.
Cached nativeScreenTargetEnabled=false/pending=false; target aura roots false.
This is not evidence that the P0470 screen-aura gate failed.

The initial screenshot could not conclusively identify the native owner.
Published XML showed separate player PVPIcon and target PvpIcon paths;
the plausible player-region hypothesis was not implemented. Requested native
/fstack rather than guessing or broadly suppressing an entire contextual parent.
User image c96940b8-1d7c-444f-824e-9284383c429e explicitly lists:
TargetFrame.TargetFrameContent.TargetFrameContentContextual.PvpBackgroundIcon.
The fstack-selected LevelBackgroundCircle/source line102 is a neighboring
region under the cursor, not the crest identity. The contextual PvpBackgroundIcon
entry is the relevant faction decoration. Player-frame hypothesis superseded.

Source defect: TargetFrameReplacement's exact nine-entry decorative allowlist
contains PvpIcon but omits independently rendered PvpBackgroundIcon. Add ONLY
that tenth known region. Existing GetStockFrames requires its alpha capability;
unsupported client fails open before capture/mutation. Capture alpha only as an
opaque token, suppress via existing OOC transaction, restore original before
withdrawing replacement interaction. No new hooks/timers/events/frame inspection.
Four preserved regions (Auras/RaidTargetIcon/QuestIcon/PingIconFrame), unknown
contextual children, player/class/pet, target-of-target and native input unchanged.
Update runtime Target Frame Check, restoration expectation and historical
P0360/target checker counts9->10 without weakening their safe-data restrictions.

Actual-source fixture covers exact tenth-region inclusion, secret-like opaque
alpha restoration, missing-region prewrite refusal, combat enable/disable
deferral with no mutation, partial suppression rollback, restoration refusal
retaining snapshot and later successful retry. Preserved/unknown regions must
remain untouched. Complete exact-candidate suite, Lua syntax/diff checks,
canonical PREWRITE/POSTWRITE, refusal/rollback/manifest audit before handoff.
Static/source PASS is not client visual/taint acceptance; WoW UNVERIFIED.

Validation: /reload, select same friendly NPC; crest should disappear in
Immersion ON. D > Target Frame Check (read-only) should report contextualSuppressed10
and preserved4. Natural target switches/native aura/cast/input remain usable.
On Immersion OFF stock original decoration must restore. Report Bug on failure,
/reload and export existing diagnostics. No travel or forced PvP needed.
P0470 yellow-enemy validation remains UNVERIFIED in these friendly-NPC captures.

Fixture construction failure retained: first actual-source harness lacked
RegisterUnitWatch/UnregisterUnitWatch mocks and correctly refused secure
interaction readiness. Added mocks; production precondition unchanged.
Corrected targeted source fixture PASS; final full suite/package audit follows.
