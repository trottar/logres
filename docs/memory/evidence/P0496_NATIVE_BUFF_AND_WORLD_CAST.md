# P0496 — Player-buff native renderer and world-target cast handoff (2026-11-19)

## Source, observed failures, and protected boundary

Verified GitHub `main` P0495 `768bb54d2eab336b9c3336f35bfa7861afd7fc7b`, tree
`8fd3e844ffaa8c3c568b3828d76471f95754e6b6`. The 2026-11-19
Forever session180 `0.0.361-dev` incident #18605 (01:42:20 Eastern) shows
combat=true, `PlayerHelpfulAuras` root hidden, visibleCount0,
secretSkipCount40, completeCoverage=false. P0495 reports the combat
helper *armed* with zero registration failures, but there is no proof its
native `BuffFrame:Show()` was accepted. User explicitly rescinds the
initial brief positive after it failed again. #18610 and #18614 outside
combat show seven ordinary Logres icons; P0488 release recovery survives.
This is a P0495 runtime FAILURE; L-054 remains OPEN and the previous
"nice works" note is a transient positive, not a general PASS.

User also reports wrong-place cast icon and unwanted native nameplate
cast bars. The screenshot #18605 captures a selected Defias Rogue Wizard
with the transparent Logres HP overlay, but is not definitive proof of
an active native cast bar. Source inspection establishes `HUD.lua`
precreated `enemyCastCue` but delivered target spellcast events only to
the screen-space cue. The native `CastBarsContainer` stayed stock-owned.
This is L-057 OPEN (and related L-011 world attachment PARTIAL).

## Narrow P0496 implementation

Reuse `NativeDebuffs.lua`'s existing Forever-compatible
`CustomAuraContainerTemplate` engine, create a preenabled addon-owned
player `HELPFUL` AuraContainer outside lockdown with the existing 36px,
four-column passive-status layout and approved border. Blizzard owns
restricted icon membership/updates. That native renderer remains active
across combat even when the addon ordinary forty-index scan becomes all
secret. Keep P0488 ordinary scanning, recovery, preview and diagnostics;
show the old Lua grid only in preview or when native setup is absent.
NativeSurfaceReplacement may fold stock BUFFS only when both complete
ordinary coverage and the owned native mirror are ready; otherwise it
fails open to stock, rather than relying on P0495's unproven native
`BuffFrame:Show` from an addon secure handler. The prior prearmed helper
is retained as a best-effort secondary path, not counted as visibility
proof. On disable, restore native stock first before retiring the mirror;
on lock or restore failure retain usable native. If native setup fails,
stock access is mandatory, even if the old grid temporarily duplicates
icons. No secret aura payload inspected or cached as current information.

The world enemy fixture already created an addon-owned `enemyCastCue`;
route existing unit-filtered target-cast lifecycle events to that cue
while a selected world target is attached. Hide the screen copy and
restore it on detach. Optionally dim only the known
`CastBarsContainer` if its reference is ordinary, it is positively
unprotected/unforbidden and its original alpha was captured as an opaque
restoration token. Dim only after actual cast start/channel start when
Logres's replacement cue is live; restore on stop/interrupt, target
change, detach and OFF. If any gate fails, leave Blizzard's cast
information usable; never hide entire native nameplate, auras, input,
or raid/CC surfaces. Never inspect/compare/format secret alpha tokens.
No polling, timer, repeated OnShow override or blanket native suppression.

## Required acceptance, negative and environmental evidence

Author-side historical checks, actual-source fixture, syntax, package
rollback, manifest and SHA are required. A static PASS does not prove
Forever's AuraContainer will draw at the intended spot or that the
native cast region is mutable in combat. Client test: naturally cast-
capable enemy, combat buffs always visible, no duplicate OOC grids,
correct world-space cast cue under the nameplate, no conventional bar
when the optional safe cast claim succeeds, all stock/cast/buff
fallbacks restored on target change, `/reload`, immersion OFF or
manual BUFFS. Record any Lua/protected/taint error as failure. Capture
Report Bug and export bundle if a case fails. L-054/L-057 remain OPEN.

## Author audit outcome

Baseline source hashes 17/17 matched GitHub tree `8fd3e84`. Candidate
357 historical static checker contracts passed; both actual-source Lua
helpful-aura fixtures pass. The first unbounded full-suite invocation
timed out; bounded audit runs completed without checker failures. The
additional native mirror mock checks control-flow continuity, not actual
Forever secure rendering. Final ZIP and exact payload verification are
recorded independently; client acceptance remains pending.
