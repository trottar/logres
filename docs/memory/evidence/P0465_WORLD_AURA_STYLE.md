# P0465 — Shared world aura appearance

Baseline main/local `048eaed622f605d745abc63dfc6c069f2d646269` (P0464),
independently verified after user push. Runtime 0.0.334-dev. Git writes by
assistant remain absent. Earlier P0464 applied state was locally dirty before
user committed; next baseline was not guessed or bypassed.

## Runtime evidence, diagnosis and negative result

Export 2026-11-16T20:21:39-05:00; incident13986 session137 version0.0.333-dev.
Standalone/bundled diagnostic SHA256
`ab77ed9b872e2f34e10faea7c7bf1c9ecb5246d85512fdb0f7c5ca7a16b1cf92`;
source/deployed/capture versions match. New screenshot
WoWScrnShot_111626_202106.jpg individually inspected: Goldshire after combat,
no active enemy auras, panel overlays right. It does NOT visually establish
the reported styling defect or absence of native duplicate icons. User states
positioning worked but elements still looked Blizzard. Record positional PASS
scoped and style FAIL. Source counters24 binds/releases,0 refusals are not
visual acceptance. Selected11 attaches/detaches and secondary13/13, active0
at capture; zero native restoration failures. Prior HP/50/50 PASS retained.

P0464 native initializer had a CooldownFrameTemplate/SetDurationCooldown,
plain native count and filter-tinted passive border. Approved
docs/design/approved/04_status_aura_icon_primitive.png was actually inspected:
native WoW spell art remains unchanged, thin Logres framing, reserved lower-
right count/duration text, explicitly NO timer sweep. P0464 did not satisfy
that appearance contract. This source mismatch is confirmed; screenshot does
not establish which exact native/custom icons the user saw during combat.

## Coherent presentation correction

New source-independent AuraPresentation.CreateBase is used by both ordinary
StatusAuras and native world AuraButton initialization. It owns exact existing
statusAura frame asset and 2px icon inset, no new art and no stock frame
fallback. Native spell textures remain engine-owned and unchanged by design.
Native world frames are no longer filter-tinted. Ordinary StatusAuras retains
its existing urgency/marker/count plate policy; no ordinary data/source change.

Replace the world cooldown widget with native SetDurationText and
SetApplicationCount consumers, styled in separate reserved lower-right text
cells using Logres warm text/shadow. No radial sweep, edge glow, stock cooldown
template, native child enumeration or restricted aura/duration/stack reads.
The native engine formats and updates its consumers; no Lua concatenation or
classification of restricted values. Text consumers have no conditional
backplate: engine visibility cannot safely be used by addon Lua to show a
separate plate. Do not manufacture a permanent empty metadata overlay or infer
count/duration presence. Artwork is the shared approved passive primitive.

All P0464 positioning, unit binding, per-owner setup, native shown restoration
and fail-open paths remain identical. Accepted HP geometry/scale/opacity and
identity/activation policy unchanged. Report Bug includes a sanitized style
identity alongside existing bind/refusal/release state. No panel itinerary.

Public native duration/count consumer contract checked 2026-11-16:
https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_AuraContainer/Blizzard_CustomAuraButton.lua
New visual policy comes from repository Sheet04, not API source or invented
art. Native formatter behavior, text packing and appearance require client
acceptance. Source tests cannot establish these outcomes.

## Validation gates and failures

Execute actual shared primitive/native initializer fixture plus previous eight
actual-source fixtures. New fixture must fail on P0464 baseline. Assert shared
asset, border/inset, distinct metadata cells, no frame tint/cooldown, no secret
getters; retain restoration/lifecycle/50-50 fixtures. Full328 checker candidate,
Lua5.1 syntax, canonical PREWRITE/POSTWRITE, source/hash/HEAD/collision refusal,
manifest/payload parity, injected POSTWRITE exact rollback and Git-preservation
audit required. Revise only P0464 obsolete cooldown-method assertion to native
text; do not relax ownership/data/combat gates.

Initial new fixture failed due Lua multi-return find bounds truncating the
source initializer slice; corrected fixture, not runtime source. Runtime PASS
is not inferred. L-028 OPEN; P0465 client appearance/taint UNVERIFIED.

User correction: P0464 reply linked push commands instead of printing them.
P0465 handoff must include exact apply AND git add/commit/push commands directly.

Source inventory audit refused an initial new loaded helper file (96-source
ownership contract). Kept the independent Logres.AuraPresentation namespace
inside existing NativeDebuffs.lua, loaded before StatusAuras, so the complete
96-source TOC inventory remains unchanged. No historical inventory gate relaxed.

Release validation: 328/328 exact-candidate STATIC PASS; 9/9 relevant actual-source fixtures PASS. New style fixture fails on unmodified P0464. Canonical PREWRITE/POSTWRITE328/328, refusal/rollback, manifest, payload parity, Lua5.1 syntax and Git-preservation audit are repeated on final ZIP before delivery. Client appearance/taint UNVERIFIED.
