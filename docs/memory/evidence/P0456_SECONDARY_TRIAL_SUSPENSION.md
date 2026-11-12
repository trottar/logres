# P0456 — Suspend visually unstable secondary takeover (2026-11-12)

## Provenance and exact scope

Verified GitHub main P0455 commit `9317229dd9e6befd42ff3d936a516c2d9cd76c77`, tree
`364684ef8b3c7b016f9ab40e6132a1685b7be250`. Forever user report
"Its really janky" with ZIP and standalone diagnostics identical by SHA-256
`41a726d2e555f9999d742135db64eba4ad5a1b1fb99f5e92b12e20d4614b870b`.
Report Bug `0.0.324-dev` session 120 #12628 (00:59:56 EST) and #12630
(01:00:22 EST) are current source/deploy/capture version matches. Screenshot
matching is inferred from mtime, not attested by WoW. Captures show selected
Mangy Wolf 100% world health and smaller Forest Spider plate during combat;
second shows a corpse and no owned display. Still photos cannot reproduce
flicker in time; user reports unacceptable jank.

## Observed failed trial

P0455 independent unrelated-update gate does operate: ignored updates rose
6 -> 22. In the same captures secondary attachments 1 -> 2, detaches 0 -> 2,
restores 0 -> 2, last detach `secondary-threat-lost-or-unknown`, final
`secondary-target-changed`; zero counted API/restore failures. The main
selected path also records 4 -> 8 attachments, 3 -> 8 detaches, with zero
recorded restore failures. Basic threat samples: 24 ordinary including 14
primary (2/3) and 10 nonprimary (0/1), 4 missing, 6 event-time eligible;
detailed remains secret for 24. These samples do not identify unique units
or prove the cause of every ownership transition. The selected refresh
source unconditionally hides/reanchors/reclaims on a successful refresh;
that merits a separate narrow event-to-owner investigation, not a speculative
frame-identity comparison or polling. P0455 is VISUAL FAIL. L-011 PARTIAL.

## Fail-open change

P0456 removes automatic *secondary* developer-trial arming from
`HUD:SetLiveWorldEnemy(true)` and restores any existing secondary claim
before leaving it disarmed. It does not modify the selected 100% path,
accepted transparent background, native aura/cast/click ownership, 50% trial
geometry definition, threat source probe, exact original alpha tokens,
combat/end/removal restoration handlers, or production secondary gate.
World Enemy ON should retain selected world presentation and stock secondary
plates, without a 50% Logres secondary takeover. The threat probe continues
to collect read-only ordinary basic/detailed categories for future work.
No new active secondary capability is claimed; the visual trial stays
SUSPENDED until same-unit decision/owner continuity can be established
without repeated stock/Logres handoffs. No timer, CVar or Blizzard frame
comparison is introduced. Static pass is not Forever acceptance.

## Follow-up

After user push/deploy, confirm selected world name/health and native auras
still work, secondary remains entirely stock, World Enemy OFF restores the
selected plate, and no Lua/taint/cast/click regressions occur. If selected
world flicker persists, capture its distinct attach/detach event provenance
in a dedicated investigation before changing ownership. Keep both P0454 and
P0455 visual failures in history; do not erase them.
