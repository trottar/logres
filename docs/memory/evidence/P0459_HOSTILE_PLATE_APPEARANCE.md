# P0459 — Hostile plate appearance independent of threat (2026-11-16)

## Exact authority and reported failure

GitHub main P0458 `6739cf2e5033fc445f258648525b12b0297a0ae1`, tree `fa02a20c1710e5c69d6b2d220434a3b3fb9e1d1f`,
version 0.0.327-dev verified. Forever Report Bug session 128 incident
#13250 (2026-11-15 23:59:50 EST) matches source/deployed/capture
0.0.327-dev; ZIP and standalone diagnostics SHA-256 identical. Screenshot
shows selected Mangy Wolf Logres name/HP and separate Forest Spider
Blizzard red plate. Secondary pool: 1 attachment, 1 restore, 0 active;
last detach `secondary-confirmed-threat-loss`, 6 ordinary basic 0/1
samples, only 1 primary eligible sample. Zero restoration errors. Event
counts are not unique-enemy proof, and image matching is inferred from
mtime (1 sec), not byte-level client association. The user confirms
Blizzard nameplates must not appear in the intended Logres enemy view.

## Source explanation and independent precedent

P0458 `WorldTargetProbe:ObserveSecondaryThreat` reports `confirmed-loss`
on 0/1 even when a nonselected hostile is safely visible; HUD uses that
as a nameplate withdrawal. Ordinary threat classifies who is tanking, NOT
whether the game should draw native artwork. P0459 leaves the complete
read-only basic+detailed source diagnostics, including secret skips,
unchanged, and adds independent `ObserveSecondaryVisualEligibility`.

ElvUI current nameplates use an owned nameplate renderer for every plate
through an oUF nameplate driver, with threat as an appearance modifier.
Reviewed publicly at `github.com/tukui-org/ElvUI` / `Nameplates.lua`;
Logres code is independently authored inside existing HUD/Probe modules,
not copied. No third-party license content included.

## Candidate design

A safely observed, ordinary nonselected `nameplateN` with ordinary
attackable=true and reaction hostile/neutral and verified unprotected,
visible, not-behind-camera anchor qualifies for 50%-scale and 50%-alpha
Logres name/HP whether in or out of combat. Threat 0/1/2/3/secret/no
ordinary table cannot itself withdraw or create an appearance claim.
An existing per-unit frame/opaque native alpha restoration claim stays
unchanged on same-owner events; native name, health, level, level-diff
artwork is dimmed only after capture and guarded validation. Native
auras, casts, CC/raid indicators and click/hit rectangles remain native.
Selected world display stays accepted 100% untouched. On promotion,
removal, unrelated/unknown token safety failures, friend/unattackable
change, anchor/identity loss and World Enemy OFF, all claims restore
original alphas. Restore refusal is quarantined; no polling, CVars,
secret-value inspection, or native click mutation. No blanket suppression.

## Explicit limitation and required runtime test

A P0458-era 40-slot preallocated pool, missing/secret identity, unsafe
anchor/operation, or refused restoration can leave Blizzard's visible
name/health as **fail-open**. This means the absolute no-Blizzard visual
requirement is **not yet guaranteed in every state**; silently hiding
stock without replacement would violate input/cast/aura and protected
state safety. A true always-custom production nameplate host may require
a separately proven secure nameplate-driver replacement path, inspired
by (not copied from) oUF/ElvUI. This is not a scoped visual PASS.

Test World Enemy ON OOC, multiple hostile/neutral nonselected enemies,
normal fight, target promotion/demotion, threat 0/1 and missing, removal,
unknown reaction, OFF, player death, and inspect Logres/stock visual
regions. Verify cast/auras/click and Lua/taint via Report Bug. Record
all native fallback and incomplete coverage explicitly (L-011 OPEN);
L-028 remains OPEN and P0454/P0455 flicker failures remain preserved.
