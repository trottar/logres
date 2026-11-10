# P0438 — Guarded world-target trial evidence and scope

## Verified baseline and accepted appearance

GitHub main `5437e810869459a472c7576c064d511060412037`, tree
`aa418e69b55d8238b14702f8ed03930d2f3387c5`. User's November 10
P0437 screenshot accepts the approved 100/50 enemy preview with the gold
HP underline removed, 25px relative auras and no simulated health vignette.
L-046 remains PARTIAL because normal target fallback was not retested.

## Narrow hypothesis / implementation

P0432 Forever incident 10457 proved accessible *in-combat* target nameplate,
not safe addon-owned SetPoint. Existing hidden probe always defers in combat.
This patch exposes opt-in `/logres worldtrial on|off` from the existing slash handler.
Right-click Report Bug still opens the full developer panel, and left-click
captures scalar diagnostics. No existing panel action is replaced or added. At an ordinary OOC hostile target nameplate, the
existing hidden proxy attachment must pass first, and IsForbidden must return
ordinary false. Only then is the owned live target display (native-forwarded
unit name/percent and duplicate already-ordinary target aura rows) anchored.
The existing HUD fallback remains present, including friendly/neutral targets.
An independent secure parent combat visibility driver hides trial children in
combat. Neither event handler nor target update reparents/moves Blizzard UI,
forces plates, inspects protected presentation state, polls, or mutates a
trial attachment during lockdown. All failures produce scalar reason codes;
Report Bug exports those separately from WorldTargetProbe.

## Author-side negative result retained

The R0 mock detected an incorrect *reason* for neutral OOC targets: source
refused attachment safely but reported `world-anchor-candidate` instead of
`not-hostile`. The ordering of ordinary reaction and candidate checks was
repaired before release. The runtime safety result was not reclassified as
an actual Forever PASS; P0438 remains an unverified world trial.

## Gate and limitations

A test requiring a selected target whose OOC plate is accessible may be
unavailable with the user's intended target-only visibility settings. This is
not permission to force enemy nameplates or modify UI settings. If OOC anchor
is absent, worldtrial remains visually absent and fallback is untouched.
The trial is not production and is never activated from the saved screen-space
preference. This patch does not implement secondary anchor identity or per-unit
confirmed aggro. No source-only evidence can declare live SetPoint, secure
combat hide, aura contents or user interaction visually PASS.

## Exact Forever test after successful author-check/deployment

1. `/reload`, with regular nameplate settings unchanged.
2. Outside combat with a hostile target, use `/logres worldtrial on`.
   The right-click Report Bug developer panel and its World Target Probe
   remain available unchanged.
3. If trial cannot attach, preserve current fallback and left-click Report Bug;
   reason `no-accessible-nameplate` or equivalent is an expected deferral.
4. If trial appears, inspect live name, percent, 25px buffs/debuffs and native
   fallback without loss of target interaction; briefly enter normal combat
   and confirm trial parent securely hides while the fallback remains usable.
5. Run `/logres worldtrial off`. Record screenshot/Report Bug, then `/reload`
   and export diagnostics. Any secret/taint/protected action error is a FAIL.

Do not promote the world trial to production without positive in-client proof.
