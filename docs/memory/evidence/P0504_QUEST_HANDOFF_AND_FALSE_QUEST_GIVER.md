# P0504 — Quest-link native handoff and exact NPC observed no-offer gating

Baseline `325f4dc14c440b18cf27cfddabd97d00c18a06c9` (verified GitHub
P0503); runtime 0.0.370-dev. Previous P0503 R0 packaging refused before
writes; P0503 R1 364/364 STATIC passed and was pushed to main. The subsequent
P0503 R2 draft was built for old P0502 baseline, **NOT RELEASED/APPLIED**
after main advanced; P0504 rebases only the additional changes.

## Native quest-stage flash — L-002 OPEN

Forever bug bundle `2026-11-21T12:18:28-05:00` captured 0.0.368-dev
P0502 session192. Event #20852 at 12:05:35 EST restored parked gossip via
`native-choice-handoff` before validated quest-link selection. Native gossip
closed; QUEST_COMPLETE followed about 0.31s later. #20865 screenshot at
12:05:37 shows Logres quest completion (quest239). User reports a subsecond
Blizzard quest/gossip window prior to screenshot. Exact transient pixel owner
was not captured; quest link native restore interval is source-confirmed.

P0503 intentionally restricted its bounded 0.8s handoff to validated gossip
service options. P0504 extends that *same*, existing one-shot parking lease
to directly validated gossip quest-link selections. A transient
`PLAYER_INTERACTION_MANAGER_FRAME_HIDE` or `GOSSIP_CLOSED` does not release
that lease before an authoritative `QUEST_DETAIL`/`QUEST_PROGRESS`/
`QUEST_COMPLETE` event. Failure, missing scheduler, timeout, explicit exit,
Immersion OFF and native fallback return stock. QuestFrame greetings and
claim-before-native-handler restoration remain Blizzard-safe and unchanged.
This is a narrow hypothesis; WoW no-flash and no-taint remain UNVERIFIED.

## Quest-giver false positive — L-030 PARTIAL

Forever same bundle #20897 at 12:06:11 EST: screenshot labels
Sergeant De Vries `[quest] - 2 yd` though user reports no offered quest.
Diagnostic source: `questCompassDB` NPC955 quest91738 independently qualifies,
`nativeOfferNearby=0`, `dbEligibilityQuestCandidates=1`,
`availableQuestPoiShown=1`, native compass arrival NPC955 distance2.0135yd.
This is **not** a proved QuestieDB record error; it is an unconfirmed
player-eligibility model candidate presented as a current quest giver.

P0504 records an exact-NPC *observed negative* only after an ordinary
`GOSSIP_SHOW` empty `C_GossipInfo.GetAvailableQuests` list, or
`QUEST_GREETING` ordinary zero available-count, correlated to an ordinary
`UnitGUID("npc")` template identity. Only DB-inferred candidate for
that NPC is withheld. Real native-confirmed offers take priority, and player
quest/progression/zone invalidation clears the negative. No ID blacklists,
client polling, speculative quest phase rules, provider mutations, forced
unit targeting, broad suppression, or secret branching. Initial map-only
DB markers may remain before the NPC is actually observed with no offers.
This limitation is deliberate to preserve the accepted real q35/q37 givers.

## Additional user reports during pre-handoff — L-002 and L-004

The user subsequently reported another brief Blizzard popup during quest NPC
interaction, with no additional incident bundle or screenshot; this reinforces
L-002 as OPEN but does not establish a second root cause or a P0503 failure.
P0504 is an untested hypothesis until a newer-client quest interaction.

The user also reported that the flight-path UI needs fixing. The latest
attached P0502 report contains no TAXIMAP_OPENED visit and its flight
snapshots report `hostResult = not-attempted`. L-004's earlier P0404
centered/unclipped visual PASS is retained as scoped historical evidence,
not claimed as current acceptance. The exact defect, flight map geometry
and native paid-route behavior are UNVERIFIED; no flight runtime change is
made here. A naturally encountered flight master with an open-map screenshot
and Report Bug export will distinguish layout, pin, sidebar, close or
stock-fallback defects without risking protected native route selection.

## Gates / unverified

Focused actual-source Lua tests extend P0503 service selection with quest
selection/interaction-hide, next-stage/timeout guards, plus P0486 explicit
no-offer, native override, quest-log invalidation, failed/secret identity
and QuestFrame greeting checks. The complete candidate historical checkers
are an offline contract gate, not a WoW PASS. Runtime L-001/L-002/L-030
remain OPEN/PARTIAL until a short actual NPC quest/service and no-offer
interaction; preserve user-reported P0502 camera continuity and all other
accepted gameplay.
