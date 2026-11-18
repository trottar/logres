# P0486 — L-030 ordinary quest flags were misclassified as eligibility vetoes (2026-11-18)

## Exact baseline and negative runtime evidence

GitHub main `4de75674a7b32377c2b46e054c3486cda27654b3`, tree
`a7ce0a0a97de15e54a219471917ec3a57b07bba2`, verified. P0485
Forever session169 `0.0.352-dev`, source/deployment matched, incidents
#17365/#17367/#17369/#17371 (12:50 Eastern): Marshal Dughan NPC240
has current quest **Further Concerns** quest35 from prior in-game
#17193/#17198, but quest mark absent. `questCompassDB` shows
`eligibilityClosestRejectedNPCID=240`, `eligibilityClosestRejectedQuestID=35`,
`eligibilityClosestRejectedReason=conditional-quest-flags`, while
native available offers0, DB eligibility promoted0, historical
excluded8, compass available quest0. No Lua/taint failure is indicated
by this evidence. P0485 gameplay **FAIL**, not superseded by static PASS.

The P0484/P0485 model incorrectly treated *any* nonzero `questFlags`
as an unverified availability requirement. External Classic quest35
record (db.thealphaproject.eu/?action=show_quest&id=35) reports
`QuestFlags=0x8 SHARABLE`; Classic quest-template documentation
(cmangos/issues wiki `quest_template`) identifies this bit as quest
sharing, not a gating prerequisite. The installed QuestieDB numeric
bitmask itself was **not** exported, so the exact Forever value is not
measured; the session rejection and historical record support the
narrow SHARABLE hypothesis, not a claim of verified Forever parity.
P0485 Forever FAIL is explicitly retained.

## Source correction and safety

Keep P0484 current player/QuestieDB independent eligibility checks for
level, race, class, active/completed, prerequisite, exclusive, chain,
profession/reputation/spell/specialization and `specialFlags`, including
secret/failed-read deferrals, native-confirmed priority, quest-by-quest
cache/invalidation, 16-read limit, eight-NPC/50yd cap and service
fallback. Replace the unconditional nonzero questFlags veto with an
explicit allowlist of documented non-eligibility Classic bits:
1 STAY_ALIVE, 2 PARTY_ACCEPT, 4 EXPLORATION, 8 SHARABLE,
32 EPIC, 64 RAID, 256 NO_MONEY_FROM_XP, 512 HIDDEN_REWARDS.
Any other set bit, including 4096 DAILY, 16384 UNAVAILABLE,
32768 WEEKLY and undefined flags, remains conservatively excluded.
Absent (`nil`) optional flags mean 0 only after successful ordinary
provider read. No bit inspection of secret values, native-frame checks,
new timers, map/floor guesses, source promotion without eligibility or
change to P0482 2/3yd and native 3/4yd proximity.

P0485 actual-source fixture used a missing/zero `questFlags` for quest35;
it could not detect nonzero shareable rejection. New P0486 fixture tests
quest35 explicitly with flag8, combined informational flags and daily,
unavailable, unknown, malformed, negative, secret, active/completed and
prerequisite vetoes. Keep P0483/P0484/P0485 negative evidence. Full
static candidate audit, checker version/diff, ZIP refusal/rollback,
PREWRITE/POSTWRITE before handoff; **not** WoW client PASS.

Initial P0486 targeted source/evidence checker failed because its expected
literal `P0485 Forever FAIL` was absent; corrected evidence and retained
this failure. Initial runtime-version policy rejected a checker that
pinned `0.0.353-dev`; replaced it with Bootstrap/TOC parity. The
subsequent full 348/348 candidate checker audit PASS applies only to
static/source tests, not in-client quest markers.

## Next in-game check

Observe one naturally available Dughan quest35 marker **before**
interaction, plus another NPC that has completed/future/unavailable
quest history. Report Bug before/after interaction and inspect
`questCompassDB.eligibilityClosestRejectedReason`, `eligibilityQualified`
and `compassNearNPC.dbEligibilityQuestCandidates`. A failure on a new
veto is OPEN; do not widen gating without an incident reason. L-030
remains OPEN/PARTIAL pending real Forever test. L-035 turning retains
previous user-scoped PARTIAL, and L-002 is independent OPEN.
