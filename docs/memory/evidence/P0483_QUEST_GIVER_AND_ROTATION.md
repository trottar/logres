# P0483 — L-030 native-backed quest coverage and L-035 fast-turn sampling (2026-11-18)

## Authority and client evidence

Verified GitHub `main` P0482 `3bc6d19b8e5254e208c212d6cb6e159ffebc66fb`
(tree `41258b21bcee6f4371a17a14bd427370102c0f31`), source 0.0.349-dev.
Client session165 #16985/#16987/#16999/#17001/#17003 is user-positive for
P0482 NPC arrival overall, with intermittent disappearance after fast rotation;
no exact frequency is established. All five snapshots hold one estimated
service NPC268238 at planar0.232yd with no native proof; field report and
screenshots show Marshal Dughan has a visible quest exclamation mark but no
Logres quest compass glyph. Session165 #16989 records
`ordinary-quest-greeting-ready`; this proves a live greeting at that time,
not that QuestieDB or native map feeds held a matching positioned quest ID.
P0482 WoW acceptance is PARTIAL; L-035 remains OPEN; L-030 remains PARTIAL.
The earlier P0337 historical-only false positives, P0476 wrong-floor2yd,
P0477 hiding, P0478 tildes/visual, P0479 no-snap, P0480 session162 jank
and P0481 sticky3.70yd failures remain durable and unresolved where scoped.

## Code-level cause and patch policy

- QuestieDBNearby stored only `quests[1]` and skipped **all** quest rows for
  NPCs with any service role; later current native quest IDs could never match.
  Index up to 32 ordinary valid quest IDs for each NPC, retain one row per
  spawn with `questIDs` and preserve the service row independently. The
  existing eight-NPC nearby cap stays but prefers native-confirmed quests,
  avoiding starvation by eight nearer historical-only candidates.
- Compass still requires a matching native current-map offer ID before
  admitting any historical QuestieDB quest glyph. It searches the bounded
  quest-ID list; if native already supplied a position, dedup remains.
  An NPC with a confirmed quest takes the quest role instead of the service
  glyph; a different service NPC does not override an aligned current offer's
  focus label. No completed/future/unavailable quest is inferred from being
  merely present in QuestieDB.
- Fast-turn missed estimated acquisition may occur because the current
  0.15-second marker refresh skips the 8-degree compass cone. Reuse the
  existing 0.05-second heading samples and bounded <=60-degree turns to
  check whether a named provider candidate within **2 planar yards** crossed
  the focus cone. Never extend the 2/3 or native 3/4 thresholds, add a timer,
  inspect protected presentation or assert floor/actual physical distance.
- Source-only Report Bug statuses: native offer count, confirmed provider
  count, historical exclusion, dual-role suppression, rotation recovery,
  existing native quest feed status and finite QuestieDB index state.

## Limits / explicit deferrals

No Forever-supported passive API is established for interrogating the
exclamation mark above an *unselected* NPC. If the native map quest feeds
omit a quest even though the NPC's visible dialogue has an offer, P0483
**cannot** create a quest marker safely from historical database data alone.
The exact Marshal Dughan failure is therefore not claimed fixed; the new
incident read-only counters distinguish absent native feed vs provider/paint
issues. Observed quest greeting after interacting is not proof the marker
should have been available before interaction. Do not re-enable
unconditional historical QuestieDB markers or infer quest prerequisites.
The planar map still cannot distinguish upper/lower floors; existing
stock quest interfaces and all native interactions remain available.

## Verification and follow-up

Independent actual-source Lua fixtures cover native-empty historical-only
veto, second eligible quest ID, dual-role index, service/quest focus,
fast-turn rotation acquisition, <=2yd estimated entry and map isolation.
Prior P0481/P0482 fixture retains native 3/4yd, estimate 2/3yd,
negative-range/secret safety and stable identity.
All repository source contracts, Lua syntax, checker-version policy, diff
hygiene, exact-candidate ZIP and guarded transactional applier are release
gates. Static pass is never in-game PASS.
In-game: at a naturally encountered live quest exclamation, Report Bug
before and during dialogue, compare questCompassSources, questCompassDB,
compassNearNPC and native greeting; then turn across an available nearby
NPC within the compass-estimated 2yd and verify lock/release. No travel
required solely to reproduce.
