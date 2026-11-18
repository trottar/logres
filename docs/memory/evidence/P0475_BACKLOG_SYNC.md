# P0475 — Post-P0474 acceptance and feature intake (docs only)

2026-11-17. Verified GitHub `main` P0474 `e476b9046e7fc45ad14a8924ca2d0aa1837231dd`,
tree `e50c3e0e8618a64a92f6d1d7627953957cff23bb`. User after P0474 installation: **"Works great."**
The prior P0473 Forever 0.0.341-dev incident #16018 remains an observed
failure; P0474 corrected header-zero handling and AddOns keybinding category.
The new report establishes scoped positive user feedback, not independently
recorded PASS for every input/focus/fallback variant. L-037 moved OPEN to
PARTIAL pending detailed completion criteria; no other issue was closed.

User requests: start with memory synchronization, then process the already
reported bugs; add an AddOns options menu with action bar/nameplate etc.
toggles; a short-lived loot presentation; profession skill-increase splash
consistent with XP/quest objectives; and a coherent tooltip UI. These are
ideas / prioritized workstreams, not accepted detailed design or proven
client capabilities. Reference existing L-014/L-018, L-027, L-038 and D-048;
do not duplicate the earlier L-021–L-053 bug ledger. New user bugs will be
intaked into the ledger as they are reported.

`docs/memory/roadmap/POST_P0474_WORKSTREAMS.md` owns requirements,
dependencies, sequencing, non-goals and acceptance gates. No runtime source,
settings schema, addon options registration, binds, native UI, or client
installation was modified. No WoW test was run for this documentation patch.

## Assistant audit negative result

Initial R0 documentation candidate was REFUSED by 17/337 static checkers
(320 PASS). It removed historical CURRENT status anchors and changed the
required P0474 handoff heading. R1 restores those historical markers and
keeps the expected header; no checkout, gameplay, or GitHub change was made
by the failed attempt. A full R1 rerun is required before release.

The R1 audit then reached 335/337 PASS: historical P0448/P0449 contracts
require the **current** phase as handoff heading, whereas P0474's checker
incorrectly required its own phase as the permanent heading. R2 preserves
all P0474 runtime/binding source assertions and historical handoff entry but
corrects the checker to follow CURRENT's active ID; no addon runtime files
were changed. The independent exact R2 checker run then passed 337/337;
package and installer acceptance are separate release gates.
