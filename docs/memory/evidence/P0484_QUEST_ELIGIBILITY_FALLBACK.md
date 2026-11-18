# P0484 — Independent bounded current-player eligibility for QuestieDB givers (2026-11-18)

## Baseline and observed failure

Remote `main` verified at `24245ce60707580a5bd85a43512c1388c9675336`,
tree `1724dcb3c87c4d8d1e2a07c4fc62c5ceaefd2e67`, P0483.
P0483 Forever 0.0.350-dev session167 #17170–#17198 shows Marshal Dughan
(NPC240) offers Classic quest **Further Concerns** (quest35), as a live
Logres greeting, but no quest marker appears. Read-only source counters:
QuestieDB `nearby=6`, native `availableQuestNearby=0`, `nativeOfferNearby=0`,
`dbNativeOfferCount=0`, `dbConfirmedQuestCandidates=0`,
`dbHistoricalQuestExcluded=6`. At #17193 quest greeting was observed;
#17198 captured the open offer. P0483's broadened quest-ID indexing
could not help while all markers demanded native feed corroboration.
User reports turning somewhat improved, no measured rotation PASS; L-035
remains PARTIAL/OPEN. No new quest UI ownership or native API error is inferred.

## Source decision

P0337 correctly eliminated historical-only future/completed NPC markers,
but World/Map quest-line APIs do not enumerate every Classic giver in
Forever. P0484 retains the native corroboration path and adds an *independent*
quest-by-quest gate using QuestieDB's documented `QuestDB.Get(id,key)` and
ordinary current player-state APIs. A provider spawn alone is insufficient.
Positive checks require ordinary quest record, live `IsOnQuest=false`,
`IsQuestFlaggedCompleted=false`, level/race/class match, complete prereq
groups or at least one alternative prerequisite, nonconflicting exclusive
and chain states, and absence of unverified conditional requirements.
Special/quest flags, skill/reputation/spell/specialization requirements,
secret values or missing APIs fail closed. Source records remain immutable.
Only one eligible quest per NPC is promoted from bounded nearby candidates;
8-NPC and 50-yard caps remain, native offers win first. Native quest marker,
service-only fallback, native interactions, waypoint/tracking and stock UI
are untouched. The existing 0.15-second Compass refresh is reused; no ticker,
new scan loop, CVars, protected/native presentation reads or Z inference.

P0484 checks at most 16 uncached quest IDs per normal refresh, with a
2048-entry capped cache invalidated on quest/player requirement events;
read-only diagnostics distinguish eligibility model positives/rejections,
truncation, last checked NPC/quest ID and eligibility reason. A cache miss
is not proof a quest is unavailable. Phase/season/remote server conditions
without independently verifiable source are NOT claimed solved; behavior
remains an approximation and may underreport valid quests.

## Source and verification gates

QuestieDB public API: `https://github.com/Questie/QuestieDB/blob/master/docs/api.md`;
quest field metadata: `src/meta/questMeta.lua`. Independent published Classic
quest reference identifies Further Concerns as quest35 / Dughan NPC240,
required level7. In-client offer screenshot remains stronger than external
quest history for current availability. No Questie source code is copied.
Actual-source Lua fixtures must verify quest35 without a native marker,
completed/onquest, prerequisites, exclusivity, class/race/level/conditional
vetoes, secret deferral, event invalidation, 8-cap, native source priority;
P0483 rotation/2yd and P0481/82 3/4yd contracts remain.
Initial independent 346/346 static checker suite, Lua parse and
P0484/P0483/P0481 actual-source fixtures PASS; exact candidate, ZIP payload
hash, transactional PRE/POST, and rollback are still required before handoff.
Do not report static PASS as Forever runtime PASS. Early candidate read helper
wrongly treated ordinary false as nil; corrected via `readBoolean` and
regression-tested before packaging. Historical R0 failures remain recorded.

## Runtime validation

At a naturally available quest NPC (e.g., Marshal Dughan), observe the
**pre-interaction** compass quest glyph and focus. Capture Report Bug before
and after interaction; check `questCompassDB.eligibilityQualified`,
`eligibilityLastReason`, `eligibilityLastQuestID` and `dbEligibilityQuestCandidates`.
Then test a future/locked and an accepted/completed quest giver in ordinary
play. The first client run must not be marked PASS without these checks.
L-030 remains PARTIAL/OPEN; P0483 native-feed false negative is historical
failure, not erased. L-035, L-002 remain independently OPEN.
