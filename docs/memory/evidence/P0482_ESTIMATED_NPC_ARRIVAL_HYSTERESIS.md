# P0482 — Estimated NPC arrival 2/3 yards; native 3/4 unchanged

Date: 2026-11-18. Verified GitHub main `51bf50dd2c6d6d0ab57dbf91db52d1af2440f106` / tree `d1405fcfb348796455cc4684bab3b55600f0a8ff` (P0481). Runtime candidate `0.0.349-dev`; client **UNVERIFIED** until user tests. L-035 OPEN, L-002 remains separately OPEN.

## Reported result and exact current evidence

The user reports the newest P0481 "works really nicely" but it gets stuck with clustered nearby NPCs; specifically asks whether estimated acquisition/release should use 2/3yd instead of 3/4yd. Session163 (0.0.348-dev) exported 2026-11-18 01:20:50 -0500, matching source/deployed/capture versions. Incident16824: estimated NPC3935 at1.589yd held; incident16826: the same NPC3935 still held at3.704yd; incident16828: estimated NPC1430 at1.710yd held. All have zero native-centered and zero native proximity-proof counts; the **current symptoms concern estimated**, not native, locks. These snapshots show state, not exact in-world XYZ or proof of same-floor presence. Four session163 screenshots accompany the bug report; session162's twelve screenshots and original partial/janky result remain preserved in P0481 evidence and are not superseded. The session163 user report is scoped positive for the lock concept, not an all-variants gameplay PASS.

## Narrow policy

For `compass-estimate` only, acquire a uniquely identified named NPC source spawn when projected distance <=2yd and fresh original compass alignment <=8 degrees, then hold the same spawn while distance <3yd despite camera turn/competitors. At >=3yd release. For `native`, retain <=3yd acquisition and <4yd hold. An ordinary positive native observation promotes an existing matching estimate to native so the appropriate wider release radius applies; token loss alone does not demote a native lock. Explicit ordinary negative native range still vetoes that NPC. Retain sourceX/sourceY+map identity, disappearance/source withdrawal, secret/refusal handling, one centered identity, native quest 3/4yd, waypoint and marker priority, no tilde/floor caption/no close fake yards, no new polling/CVars/hooks/Blizzard state reads. Also tighten the prior-facing inclusion path to use the same source-specific hold limit; otherwise a released estimated lock could keep an out-of-view candidate.

## Evidence gates and known limitations

Expected improvement: an estimated NPC held at3.70yd in P0481 should no longer latch or center; other estimated candidates can acquire at <=2yd when freshly aligned. A 2yd entry radius may be too restrictive for imprecise QuestieDB spawn coordinates, and both thresholds remain two-dimensional map estimates; wrong-floor possibilities **remain OPEN**, including P0476 #16399. Preserve P0477 blank-marker FAIL, P0478 visual/tildes FAIL, P0479 no-snap FAIL, and P0480 janky partial. Accepted P0481 positives survive; no claim of completed L-035. No new interaction, quest, HP/aura, chat SHOW or native-fallback behavior is authorized. The minimal natural-play check is one close NPC approach/turn/release, verifying the other NPC takes focus when appropriate; Report Bug on recurrence, without forced travel.

## Candidate / release audit

**Assistant pre-release R0 negative:** 342/344 checker run; P0450 and P0451
refused absent `# P0451:` history line following a budget trim. Restored
that line with no runtime change; final checker rerun required.
 R1 complete
**344/344 STATIC PASS** on corrected author candidate, 0 failures.


The existing complete-refresh P0481 Lua fixture now checks distinct estimated 2/3 and native 3/4 thresholds, identity, compete/turn, disappearance/map/spawn, native veto, secret data, and estimate-to-native upgrade. Historical P0476–P0481 source contracts retain all unrelated checks and follow the current handoff prefix. P0482 check adds an exact source/policy guard. Full candidate, real repository checkers, Lua parse, canonical builder/applier PREWRITE/POSTWRITE, wrong-baseline/dirty/tamper/refusal/rollback, manifest and SHA are required before handoff. Record actual outcomes in PRE_HANDOFF_AUDIT and package receipt; static/source tests never establish client acceptance.
